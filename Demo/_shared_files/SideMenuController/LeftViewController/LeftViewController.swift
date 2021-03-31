//
//  LeftViewController.swift
//  LGSideMenuControllerDemo
//

import Foundation
import UIKit

private let cellIdentifier = "cell"
private let tableViewInset: CGFloat = 44.0 * 2.0
private let cellHeight: CGFloat = 44.0

class LeftViewController: UITableViewController {

    private var type: DemoType?

    private let sections: [[SideViewCellItem]] = [
        [.close, .openRight],
        [.changeRootVC],
        [.pushVC(title: "Profile"),
         .pushVC(title: "News"),
         .pushVC(title: "Friends"),
         .pushVC(title: "Music"),
         .pushVC(title: "Video"),
         .pushVC(title: "Articles")]
    ]

    // For NonStoryboard Demo
    init(type: DemoType) {
        self.type = type
        super.init(style: .grouped)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    // For Storyboard Demo
    func setup(type: DemoType) {
        self.type = type
    }

    // MARK: - Lifecycle -

    override func viewDidLoad() {
        super.viewDidLoad()
        struct Counter { static var count = 0 }
        Counter.count += 1
        print("LeftViewController.viewDidLoad(), counter: \(Counter.count)")

        // For iOS < 11.0 use this property to avoid artefacts if necessary
        // automaticallyAdjustsScrollViewInsets = false

        tableView.register(LeftViewCell.self, forCellReuseIdentifier: cellIdentifier)
        tableView.separatorStyle = .none
        tableView.contentInset = UIEdgeInsets(top: tableViewInset, left: 0.0, bottom: tableViewInset, right: 0.0)
        tableView.showsVerticalScrollIndicator = false
        tableView.backgroundColor = .clear
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.contentOffset = CGPoint(x: 0.0, y: -tableViewInset)
    }

    // MARK: - Status Bar -

    override var prefersStatusBarHidden: Bool {
        switch type?.demoRow {
        case .statusBarHidden,
             .statusBarOnlyRoot:
            return true
        default:
            return false
        }
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        switch type?.demoRow {
        case .statusBarDifferentStyles:
            if isLightTheme() {
                return .lightContent
            } else {
                if #available(iOS 13.0, *) {
                    return .darkContent
                } else {
                    return .default
                }
            }
        default:
            return .default
        }
    }

    override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
        return .fade
    }

    // MARK: - UITableViewDataSource -

    override func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! LeftViewCell
        let item = sections[indexPath.section][indexPath.row]

        cell.textLabel!.text = item.description
        cell.isFirst = (indexPath.row == 0)
        cell.isLast = (indexPath.row == sections[indexPath.section].count - 1)
        cell.isFillColorInverted = sideMenuController?.leftViewPresentationStyle == .slideAboveBlurred

        return cell
    }

    // MARK: - UITableViewDelegate -

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let sideMenuController = sideMenuController else { return }
        let item = sections[indexPath.section][indexPath.row]

        switch item {
        case .close:
            sideMenuController.hideLeftView(animated: true)
        case .openRight:
            sideMenuController.showRightView(animated: true)
        case .changeRootVC:
            let viewController = RootViewController(imageName: getBackgroundImageNameRandom())
            if type?.demoRow == .usageInsideNavigationController {
                sideMenuController.rootViewController = viewController
                UIView.transition(with: sideMenuController.rootViewWrapperView!,
                                  duration: sideMenuController.leftViewAnimationDuration,
                                  options: [.transitionCrossDissolve],
                                  animations: nil)
            }
            else {
                let navigationController = sideMenuController.rootViewController as! RootNavigationController
                navigationController.setViewControllers([viewController], animated: false)
                UIView.transition(with: navigationController.view,
                                  duration: sideMenuController.leftViewAnimationDuration,
                                  options: [.transitionCrossDissolve],
                                  animations: nil)
            }
            sideMenuController.hideLeftView(animated: true)
        case .pushVC(let title):
            let viewController = RootViewControllerWithTextLabel(title: title,
                                                                 imageName: getBackgroundImageNameRandom())
            if type?.demoRow == .usageInsideNavigationController {
                sideMenuController.rootViewController = viewController
                UIView.transition(with: sideMenuController.rootViewWrapperView!,
                                  duration: sideMenuController.leftViewAnimationDuration,
                                  options: [.transitionCrossDissolve],
                                  animations: nil)
            }
            else {
                let navigationController = sideMenuController.rootViewController as! RootNavigationController
                navigationController.pushViewController(viewController, animated: true)
            }
            sideMenuController.hideLeftView(animated: true)
        default:
            return
        }
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeight
    }

    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 0.0
        }
        return cellHeight / 2.0
    }

    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.0
    }

    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return nil
    }

    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return nil
    }

    // MARK: - Logging -

    deinit {
        struct Counter { static var count = 0 }
        Counter.count += 1
        print("LeftViewController.deinit(), counter: \(Counter.count)")
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        struct Counter { static var count = 0 }
        Counter.count += 1
        print("LeftViewController.viewWillAppear(\(animated)), counter: \(Counter.count)")
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        struct Counter { static var count = 0 }
        Counter.count += 1
        print("LeftViewController.viewDidAppear(\(animated)), counter: \(Counter.count)")
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        struct Counter { static var count = 0 }
        Counter.count += 1
        print("LeftViewController.viewWillDisappear(\(animated)), counter: \(Counter.count)")
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        struct Counter { static var count = 0 }
        Counter.count += 1
        print("LeftViewController.viewDidDisappear(\(animated)), counter: \(Counter.count)")
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        struct Counter { static var count = 0 }
        Counter.count += 1
        print("LeftViewController.viewWillLayoutSubviews(), counter: \(Counter.count)")
    }

}
