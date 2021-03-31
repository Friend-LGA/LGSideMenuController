//
//  RightViewController.swift
//  LGSideMenuControllerDemo
//

import Foundation
import UIKit

private let cellIdentifier = "cell"
private let tableViewInset: CGFloat = 44.0 * 2.0
private let cellHeight: CGFloat = 100.0

class RightViewController: UITableViewController {

    private var type: DemoType?

    private let sections: [[SideViewCellItem]] = [
        [.close, .openLeft],
        [.changeRootVC],
        [.pushVC(title: "1"),
         .pushVC(title: "2"),
         .pushVC(title: "3"),
         .pushVC(title: "4"),
         .pushVC(title: "5"),
         .pushVC(title: "6"),
         .pushVC(title: "7"),
         .pushVC(title: "8"),
         .pushVC(title: "9"),
         .pushVC(title: "10")]
    ]

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
        print("RightViewController.viewDidLoad(), counter: \(Counter.count)")

        // For iOS < 11.0 use this property to avoid artefacts if necessary
        // automaticallyAdjustsScrollViewInsets = false

        tableView.register(RightViewCell.self, forCellReuseIdentifier: cellIdentifier)
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
        guard let type = type else { return .default }

        switch type.demoRow {
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
        case .statusBarNoBackground:
            if type.presentationStyle.shouldRootViewScale {
                return .lightContent
            }
            fallthrough
        default:
            return .default
        }
    }

    override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
        return .slide
    }

    // MARK: - UITableViewDataSource -

    override func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! RightViewCell
        let item = sections[indexPath.section][indexPath.row]

        cell.textLabel!.text = item.description
        cell.textLabel!.font = UIFont.boldSystemFont(ofSize: {
            if case .pushVC = item {
                return 32.0
            }
            return 16.0
        }())
        cell.separatorView.isHidden = (indexPath.row == sections[indexPath.section].count - 1)

        return cell
    }

    // MARK: - UITableViewDelegate -

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let sideMenuController = self.sideMenuController else { return }
        let item = sections[indexPath.section][indexPath.row]

        switch item {
        case .close:
            sideMenuController.hideRightView(animated: true)
        case .openLeft:
            sideMenuController.showLeftView(animated: true)
        case .changeRootVC:
            let viewController = RootViewController(imageName: getBackgroundImageNameRandom())
            if type?.demoRow == .usageInsideNavigationController {
                sideMenuController.rootViewController = viewController
                UIView.transition(with: sideMenuController.rootViewWrapperView!,
                                  duration: sideMenuController.rightViewAnimationDuration,
                                  options: [.transitionCrossDissolve],
                                  animations: nil)
            }
            else {
                let navigationController = sideMenuController.rootViewController as! RootNavigationController
                navigationController.setViewControllers([viewController], animated: false)
                UIView.transition(with: navigationController.view,
                                  duration: sideMenuController.rightViewAnimationDuration,
                                  options: [.transitionCrossDissolve],
                                  animations: nil)
            }
            sideMenuController.hideRightView(animated: true)
        case .pushVC(let title):
            let viewController = RootViewControllerWithTextLabel(title: title,
                                                                 imageName: getBackgroundImageNameRandom())
            if type?.demoRow == .usageInsideNavigationController {
                sideMenuController.rootViewController = viewController
                UIView.transition(with: sideMenuController.rootViewWrapperView!,
                                  duration: sideMenuController.rightViewAnimationDuration,
                                  options: [.transitionCrossDissolve],
                                  animations: nil)
            }
            else {
                let navigationController = sideMenuController.rootViewController as! RootNavigationController
                navigationController.pushViewController(viewController, animated: true)
            }
            sideMenuController.hideRightView(animated: true)
        default:
            return
        }
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let item = sections[indexPath.section][indexPath.row]
        if case .pushVC = item {
            return cellHeight
        }
        return cellHeight * 0.75
    }

    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 0.0
        }
        return cellHeight * 0.75
    }

    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.0
    }

    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            return nil
        }
        return RightViewCellHeaderView()
    }

    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return nil
    }

    // MARK: - Logging -

    deinit {
        struct Counter { static var count = 0 }
        Counter.count += 1
        print("RightViewController.deinit(), counter: \(Counter.count)")
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        struct Counter { static var count = 0 }
        Counter.count += 1
        print("RightViewController.viewWillAppear(\(animated)), counter: \(Counter.count)")
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        struct Counter { static var count = 0 }
        Counter.count += 1
        print("RightViewController.viewDidAppear(\(animated)), counter: \(Counter.count)")
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        struct Counter { static var count = 0 }
        Counter.count += 1
        print("RightViewController.viewWillDisappear(\(animated)), counter: \(Counter.count)")
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        struct Counter { static var count = 0 }
        Counter.count += 1
        print("RightViewController.viewDidDisappear(\(animated)), counter: \(Counter.count)")
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        struct Counter { static var count = 0 }
        Counter.count += 1
        print("RightViewController.viewWillLayoutSubviews(), counter: \(Counter.count)")
    }

}
