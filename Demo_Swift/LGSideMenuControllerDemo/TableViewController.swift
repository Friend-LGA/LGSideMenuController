//
//  TableViewController.swift
//  LGSideMenuControllerDemo
//
//  Created by Grigory Lutkov on 05.11.15.
//  Copyright © 2015 Grigory Lutkov <Friend.LGA@gmail.com>. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController {

    private let titlesArray = ["Style Scale From Big",
                               "Style Slide Above",
                               "Style Slide Below",
                               "Style Scale From Little",
                               "Landscape always visible",
                               "Status bar always visible",
                               "Status bar light content",
                               "Custom style"]

    init() {
        super.init(style: .plain)

        title = "LGSideMenuController"

        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")

        clearsSelectionOnViewWillAppear = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    // MARK: - UITableViewDataSource

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titlesArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)

        cell.accessoryType = .disclosureIndicator
        cell.textLabel!.font = UIFont.systemFont(ofSize: 16.0)
        cell.textLabel!.text = titlesArray[indexPath.row]
        
        return cell
    }
    
    // MARK: - UITableViewDelegate

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44.0
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let viewController = ViewController()
        let navigationController = NavigationController(rootViewController:viewController)
        let mainViewController: MainViewController?

        switch indexPath.row {
        case 0:
            mainViewController = MainViewController(rootViewController: navigationController, presentationStyle: .scaleFromBig, type: 0)
            break
        case 1:
            mainViewController = MainViewController(rootViewController: navigationController, presentationStyle: .slideAbove, type: 0)
            break
        case 2:
            mainViewController = MainViewController(rootViewController: navigationController, presentationStyle: .slideBelow, type: 0)
            break
        case 3:
            mainViewController = MainViewController(rootViewController: navigationController, presentationStyle: .scaleFromLittle, type: 0)
            break
        case 4:
            mainViewController = MainViewController(rootViewController: navigationController, presentationStyle: .scaleFromBig, type: 1)
            break
        case 5:
            mainViewController = MainViewController(rootViewController: navigationController, presentationStyle: .slideAbove, type: 2)
            break
        case 6:
            mainViewController = MainViewController(rootViewController: navigationController, presentationStyle: .slideAbove, type: 3)
            break
        case 7:
            mainViewController = MainViewController(rootViewController: navigationController, presentationStyle: .slideAbove, type: 4)
            break
        default:
            mainViewController = nil
            break
        }

        let window = UIApplication.shared.delegate!.window!!
        window.rootViewController = mainViewController

        UIView.transition(with: window, duration: 0.3, options: [.transitionCrossDissolve], animations: nil, completion: nil)
    }

}
