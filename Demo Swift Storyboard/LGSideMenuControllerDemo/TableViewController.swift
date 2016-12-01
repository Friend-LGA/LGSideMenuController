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

    // MARK: - UITableViewDataSource
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titlesArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)

        cell.textLabel!.font = UIFont.systemFont(ofSize: 16.0)
        cell.textLabel!.text = titlesArray[indexPath.row]
        
        return cell
    }
    
    // MARK: - UITableViewDelegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let navigationController = storyboard.instantiateViewController(withIdentifier: "NavigationController") as! UINavigationController
        let mainViewController = storyboard.instantiateInitialViewController() as! MainViewController
        mainViewController.rootViewController = navigationController

        switch indexPath.row {
        case 0:
            mainViewController.setup(presentationStyle: .scaleFromBig, type: 0)
            break
        case 1:
            mainViewController.setup(presentationStyle: .slideAbove, type: 0)
            break
        case 2:
            mainViewController.setup(presentationStyle: .slideBelow, type: 0)
            break
        case 3:
            mainViewController.setup(presentationStyle: .scaleFromLittle, type: 0)
            break
        case 4:
            mainViewController.setup(presentationStyle: .scaleFromBig, type: 1)
            break
        case 5:
            mainViewController.setup(presentationStyle: .slideAbove, type: 2)
            break
        case 6:
            mainViewController.setup(presentationStyle: .slideAbove, type: 3)
            break
        case 7:
            mainViewController.setup(presentationStyle: .slideAbove, type: 4)
            break
        default:
            break
        }

        let window = UIApplication.shared.delegate!.window!!
        window.rootViewController = mainViewController

        UIView.transition(with: window, duration: 0.3, options: [.transitionCrossDissolve], animations: nil, completion: nil)
    }

}
