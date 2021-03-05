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

        lastContentOffsetY = tableView.contentOffset.y

        window.rootViewController = {
            if isStoryboardBasedDemo() {
                let rootViewController: RootViewController = {
                    if type.demoRow == .conflictingGesturesScrollView {
                        return RootViewControllerWithScrollView(description: type.description)
                    }
                    else if type.demoRow == .conflictingGesturesTableView {
                        return RootViewControllerWithTableView(description: type.description)
                    }
                    else {
                        return RootViewController(description: type.description)
                    }
                }()

                if isInsideNavigationController {
                    let storyboard = UIStoryboard(name: "InsideNavigationController", bundle: nil)
                    let navigationController = storyboard.instantiateInitialViewController() as! RootNavigationController
                    navigationController.setup(type: type)
                    let sideMenuController = navigationController.viewControllers.first as! MainViewController
                    sideMenuController.setup(type: type)
                    let leftViewController = sideMenuController.leftViewController as! LeftViewController
                    leftViewController.setup(type: type)
                    let rightViewController = sideMenuController.rightViewController as! RightViewController
                    rightViewController.setup(type: type)
                    // It is better should be assigned inside storyboard.
                    // The one, which is connected there right now is just to show how to use root segue.
                    sideMenuController.rootViewController = rootViewController
                    return navigationController
                }
                else {
                    let storyboard = UIStoryboard(name: "AsWindowRootViewController", bundle: nil)
                    let sideMenuController = storyboard.instantiateInitialViewController() as! MainViewController
                    sideMenuController.setup(type: type)
                    let navigationController = sideMenuController.rootViewController as! RootNavigationController
                    navigationController.setup(type: type)
                    let leftViewController = sideMenuController.leftViewController as! LeftViewController
                    leftViewController.setup(type: type)
                    let rightViewController = sideMenuController.rightViewController as! RightViewController
                    rightViewController.setup(type: type)
                    navigationController.setViewControllers([rootViewController], animated: false)
                    return sideMenuController
                }
            }
            else {
                let rootViewController: RootViewController = {
                    if type.demoRow == .conflictingGesturesScrollView {
                        return RootViewControllerWithScrollView(description: type.description)
                    }
                    else if type.demoRow == .conflictingGesturesTableView {
                        return RootViewControllerWithTableView(description: type.description)
                    }
                    else {
                        return RootViewController(description: type.description)
                    }
                }()

                if isInsideNavigationController {
                    let sideMenuController = MainViewController(type: type)
                    sideMenuController.rootViewController = rootViewController
                    sideMenuController.leftViewController = LeftViewController(type: type)
                    sideMenuController.rightViewController = RightViewController(type: type)

                    let navigationController = RootNavigationController(type: type)
                    navigationController.setViewControllers([sideMenuController], animated: false)
                    return navigationController
                }
                else {
                    let navigationController = RootNavigationController(type: type)
                    let rootViewController = rootViewController
                    navigationController.setViewControllers([rootViewController], animated: false)

                    let sideMenuController = MainViewController(type: type)
                    sideMenuController.rootViewController = navigationController
                    sideMenuController.leftViewController = LeftViewController(type: type)
                    sideMenuController.rightViewController = RightViewController(type: type)
                    return sideMenuController
                }
            }
        }()

        UIView.transition(with: window, duration: 0.3, options: [.transitionCrossDissolve], animations: nil)
    }
    
}
