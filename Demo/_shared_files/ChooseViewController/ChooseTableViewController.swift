//
//  ChooseTableViewController.swift
//  LGSideMenuControllerDemo
//

import Foundation
import UIKit

private var lastContentOffsetY: CGFloat? = nil
private let cellIdentifier = "cell"

class ChooseTableViewController: UITableViewController {

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let contentOffsetY = lastContentOffsetY {
            let statusBarHeight = getStatusBarFrame().height
            let navigationBarHeight = self.navigationController?.navigationBar.frame.height ?? .zero
            tableView.contentOffset.y = statusBarHeight + navigationBarHeight + contentOffsetY
        }
    }

    // MARK: - UITableViewDataSource -
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return DemoSection.allCases.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let demoSection = DemoSection(rawValue: section) else { return 0 }
        return demoSection.items.count
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard let demoSection = DemoSection(rawValue: section) else { return nil }
        return demoSection.description
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)

        guard let demoSection = DemoSection(rawValue: indexPath.section) else { return cell }
        let demoRow = demoSection.items[indexPath.row]
        
        cell.accessoryType = .disclosureIndicator
        cell.textLabel!.font = UIFont.systemFont(ofSize: 16.0)
        cell.textLabel!.text = demoRow.title

        return cell
    }
    
    // MARK: - UITableViewDelegate -

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let demoSection = DemoSection(rawValue: indexPath.section) else { return }

        let demoRow = demoSection.items[indexPath.row]
        let presentationStyles = demoRow.presentationStyles

        if presentationStyles.count > 1 {
            let alert = UIAlertController(title: "Choose Style", message: nil, preferredStyle: .alert)
            presentationStyles.forEach { (presentationStyle: LGSideMenuController.PresentationStyle) in
                alert.addAction(UIAlertAction(title: getTitle(for: presentationStyle), style: .default, handler: { (action: UIAlertAction) in
                    let demoType = DemoType(demoRow: demoRow, presentationStyle: presentationStyle)
                    self.transitionToDemo(type: demoType)
                }))
            }
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction) in
                tableView.deselectRow(at: indexPath, animated: true)
            }))
            present(alert, animated: true, completion: nil)
        }
        else if let presentationStyle = presentationStyles.first {
            let demoType = DemoType(demoRow: demoRow, presentationStyle: presentationStyle)
            transitionToDemo(type: demoType)
        }
    }

    func transitionToDemo(type: DemoType) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate,
              let window = appDelegate.window else { return }

        let isInsideNavigationController = (type.demoRow == .usageInsideNavigationController)
        let isInsideTabBarController = (type.demoRow == .usageInsideTabBarController)
        let isContainerForTabBarController = (type.demoRow == .usageAsContainerForTabBarController)

        lastContentOffsetY = tableView.contentOffset.y

        func getRootViewController(imageName: String? = nil) -> RootViewController {
            if type.demoRow == .conflictingGesturesScrollView {
                return RootViewControllerWithScrollView(description: type.description, imageName: imageName)
            }
            else if type.demoRow == .conflictingGesturesTableView {
                return RootViewControllerWithTableView(description: type.description, imageName: imageName)
            }
            else {
                return RootViewController(description: type.description, imageName: imageName)
            }
        }

        window.rootViewController = {
            if isStoryboardBasedDemo() {
                // All view controller relationships and properties better should be assigned inside storyboard.
                // Right now all connections and properties inside storyboard are there only
                // for demonstration purposes, to give you an idea how you should setup everything.
                // But here we don't use all native storyboard logic, just to make it easier to maintain
                // two demo projects (Storyboard and NonStoryboard) because they share a lot of the codebase.
                // Don't take it as the strict example how you should do storyboards. Just follow recomendad apple
                // way of doing things and use LGSideMenuController as any other normal view controller.

                func setupSideMenuController(_ sideMenuController: MainViewController) {
                    sideMenuController.setup(type: type)
                    let leftViewController = sideMenuController.leftViewController as! LeftViewController
                    leftViewController.setup(type: type)
                    let rightViewController = sideMenuController.rightViewController as! RightViewController
                    rightViewController.setup(type: type)
                }

                func setTabBarItem(_ index: Int, _ viewController: UIViewController) {
                    switch index {
                    case 0:
                        viewController.tabBarItem = UITabBarItem(title: "One", image: tabBarIconImage("1"), tag: 0)
                    case 1:
                        viewController.tabBarItem = UITabBarItem(title: "Two", image: tabBarIconImage("2"), tag: 0)
                    case 2:
                        viewController.tabBarItem = UITabBarItem(title: "Three", image: tabBarIconImage("3"), tag: 0)
                    default:
                        break
                    }
                }

                func getImageName(index: Int) -> String {
                    switch index {
                    case 0:
                        return "imageRoot0"
                    case 1:
                        return "imageRoot1"
                    case 2:
                        return "imageRoot2"
                    default:
                        return getBackgroundImageNameRandom()
                    }
                }

                if isInsideNavigationController {
                    let storyboard = UIStoryboard(name: "InsideNavigationController", bundle: nil)
                    let navigationController = storyboard.instantiateInitialViewController() as! RootNavigationController
                    navigationController.setup(type: type)
                    let sideMenuController = navigationController.viewControllers.first as! MainViewController
                    setupSideMenuController(sideMenuController)
                    sideMenuController.rootViewController = getRootViewController()
                    return navigationController
                }
                else if isInsideTabBarController {
                    let storyboard = UIStoryboard(name: "InsideTabBarController", bundle: nil)
                    let tabBarController = storyboard.instantiateInitialViewController() as! RootTabBarController
                    tabBarController.setup(type: type)
                    for (index, viewController) in tabBarController.viewControllers!.enumerated() {
                        let sideMenuController = viewController as! MainViewController
                        setupSideMenuController(sideMenuController)
                        let navigationController = sideMenuController.rootViewController as! RootNavigationController
                        navigationController.setup(type: type)
                        navigationController.setViewControllers([getRootViewController(imageName: getImageName(index: index))],
                                                                animated: false)
                        setTabBarItem(index, viewController)
                    }
                    return tabBarController
                }
                else if isContainerForTabBarController {
                    let storyboard = UIStoryboard(name: "AsContainerForTabBarController", bundle: nil)
                    let sideMenuController = storyboard.instantiateInitialViewController() as! MainViewController
                    setupSideMenuController(sideMenuController)
                    let tabBarController = sideMenuController.rootViewController as! RootTabBarController
                    tabBarController.setup(type: type)
                    for (index, viewController) in tabBarController.viewControllers!.enumerated() {
                        let navigationController = viewController as! RootNavigationController
                        navigationController.setup(type: type)
                        navigationController.setViewControllers([getRootViewController(imageName: getImageName(index: index))],
                                                                animated: false)
                        setTabBarItem(index, viewController)
                    }
                    return sideMenuController
                }
                else {
                    let storyboard = UIStoryboard(name: "AsContainerForNavigationController", bundle: nil)
                    let sideMenuController = storyboard.instantiateInitialViewController() as! MainViewController
                    setupSideMenuController(sideMenuController)
                    let navigationController = sideMenuController.rootViewController as! RootNavigationController
                    navigationController.setup(type: type)
                    navigationController.setViewControllers([getRootViewController()], animated: false)
                    return sideMenuController
                }
            }
            else {
                // These "setup" methods are here just to share code with Storyboard based demo.
                // Usually you would pass all params inside "init" method without any additional "setup" methods.
                // Don't take this demo as the strict example how you should do non storyboard apps.
                // Just follow common sense and basic swift guidlines.

                func getSideMenuController(rootViewController: UIViewController) -> LGSideMenuController {
                    let sideMenuController = MainViewController(type: type)
                    sideMenuController.rootViewController = rootViewController
                    sideMenuController.leftViewController = LeftViewController(type: type)
                    sideMenuController.rightViewController = RightViewController(type: type)
                    return sideMenuController
                }

                func getSideMenuControllerWithNavigationController(imageName: String? = nil,
                                                                   tabBarItem: UITabBarItem? = nil) -> LGSideMenuController {
                    let navigationController = RootNavigationController(type: type)
                    navigationController.setViewControllers([getRootViewController(imageName: imageName)], animated: false)
                    let sideMenuController = getSideMenuController(rootViewController: navigationController)
                    sideMenuController.tabBarItem = tabBarItem
                    return sideMenuController
                }

                func getNavigationController(imageName: String? = nil,
                                             tabBarItem: UITabBarItem? = nil) -> UINavigationController {
                    let navigationController = RootNavigationController(type: type)
                    navigationController.setViewControllers([getRootViewController(imageName: imageName)], animated: false)
                    navigationController.tabBarItem = tabBarItem
                    return navigationController
                }

                if isInsideNavigationController {
                    let navigationController = RootNavigationController(type: type)
                    navigationController.setViewControllers(
                        [getSideMenuController(rootViewController: getRootViewController())], animated: false
                    )
                    return navigationController
                }
                else if isInsideTabBarController {
                    let tabBarController = RootTabBarController(type: type)
                    tabBarController.setViewControllers(
                        [getSideMenuControllerWithNavigationController(imageName: "imageRoot0",
                                                                       tabBarItem: UITabBarItem(title: "One",
                                                                                                image: tabBarIconImage("1"),
                                                                                                tag: 0)),
                         getSideMenuControllerWithNavigationController(imageName: "imageRoot1",
                                                                       tabBarItem: UITabBarItem(title: "Two",
                                                                                                image: tabBarIconImage("2"),
                                                                                                tag: 1)),
                         getSideMenuControllerWithNavigationController(imageName: "imageRoot2",
                                                                       tabBarItem: UITabBarItem(title: "Three",
                                                                                                image: tabBarIconImage("3"),
                                                                                                tag: 2))],
                        animated: false
                    )
                    return tabBarController
                }
                else if isContainerForTabBarController {
                    let tabBarController = RootTabBarController(type: type)
                    tabBarController.setViewControllers(
                        [getNavigationController(imageName: "imageRoot0",
                                                 tabBarItem: UITabBarItem(title: "One",
                                                                          image: tabBarIconImage("1"),
                                                                          tag: 0)),
                         getNavigationController(imageName: "imageRoot1",
                                                 tabBarItem: UITabBarItem(title: "Two",
                                                                          image: tabBarIconImage("2"),
                                                                          tag: 1)),
                         getNavigationController(imageName: "imageRoot2",
                                                 tabBarItem: UITabBarItem(title: "Three",
                                                                          image: tabBarIconImage("3"),
                                                                          tag: 2))],
                        animated: false
                    )
                    return getSideMenuController(rootViewController: tabBarController)
                }
                else {
                    return getSideMenuControllerWithNavigationController()
                }
            }
        }()

        UIView.transition(with: window, duration: 0.3, options: [.transitionCrossDissolve], animations: nil)
    }
    
}
