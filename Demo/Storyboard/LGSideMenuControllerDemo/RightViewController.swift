//
//  RightViewController.swift
//  LGSideMenuControllerDemo
//

import Foundation
import UIKit

class RightViewController: UITableViewController {

    private var type: DemoType?
    
    private let titlesArray = ["Open Left View",
                               "",
                               "1",
                               "2",
                               "3",
                               "4",
                               "5",
                               "6",
                               "7",
                               "8",
                               "9",
                               "10"]

    func setup(type: DemoType) {
        self.type = type
    }

    override var prefersStatusBarHidden: Bool {
        if self.type == .statusBarIsAlwaysVisible {
            return UIApplication.shared.statusBarOrientation.isLandscape && UIDevice.current.userInterfaceIdiom == .phone
        }

        return true
    }

    override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
        return .slide
    }
    
    // MARK: - UITableViewDataSource
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titlesArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! RightViewCell

        cell.titleLabel.text = titlesArray[indexPath.row]
        cell.titleLabel.font = UIFont.boldSystemFont(ofSize: indexPath.row == 0 ? 15.0 : 30.0)
        cell.separatorView.isHidden = (indexPath.row <= 1 || indexPath.row == titlesArray.count - 1)
        cell.isUserInteractionEnabled = (indexPath.row != 1)
        
        return cell
    }
    
    // MARK: - UITableViewDelegate
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return indexPath.row == 1 ? 50.0 : 100.0
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let sideMenuController = sideMenuController else { return }

        if indexPath.row == 0 {
            if sideMenuController.isRightViewAlwaysVisible {
                sideMenuController.showLeftView(animated: true, completion: nil)
            }
            else {
                sideMenuController.hideRightView(animated: true, completion: {
                    sideMenuController.showLeftView(animated: true, completion: nil)
                })
            }
        }
        else {
            let viewController = UIViewController()
            viewController.view.backgroundColor = (isLightTheme() ? .white : .black)
            viewController.title = "Test \(titlesArray[indexPath.row])"

            if let navigationController = sideMenuController.rootViewController as? RootNavigationController {
                navigationController.pushViewController(viewController, animated: true)
            }
            
            sideMenuController.hideRightView(animated: true, completion: nil)
        }
    }

    // MARK: - Logging

    deinit {
        struct Counter { static var count = 0 }
        Counter.count += 1
        print("RightViewController.deinit(), counter: \(Counter.count)")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        struct Counter { static var count = 0 }
        Counter.count += 1
        print("RightViewController.viewDidLoad(), counter: \(Counter.count)")
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
