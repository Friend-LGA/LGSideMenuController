//
//  TableViewController.swift
//  LGSideMenuControllerDemo
//
//  Created by Cole Dunsby on 2016-07-24.
//  Copyright © 2016 Cole Dunsby. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController {

    let titlesArray = [
        "Style Scale From Big",
        "Style Slide Above",
        "Style Slide Below",
        "Style Scale From Little",
        "Landscape always visible",
        "Status bar always visible",
        "Status bar light content",
        "Custom style"
    ]
    
    // MARK: - UITableViewDataSource
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titlesArray.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
        cell.textLabel?.text = titlesArray[indexPath.row]
        return cell
    }
    
    // MARK: - UITableViewDelegate
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let navigationController = storyboard.instantiateViewControllerWithIdentifier("NavigationController") as! UINavigationController
        let mainViewController = storyboard.instantiateInitialViewController() as! MainViewController
        mainViewController.rootViewController = navigationController
        
        if indexPath.row == 0 {
            mainViewController.setup(presentationStyle: .ScaleFromBig, type: 0)
        } else if indexPath.row == 1 {
            mainViewController.setup(presentationStyle: .SlideAbove, type: 0)
        } else if indexPath.row == 2 {
            mainViewController.setup(presentationStyle: .SlideBelow, type: 0)
        } else if indexPath.row == 3 {
            mainViewController.setup(presentationStyle: .ScaleFromLittle, type: 0)
        } else if indexPath.row == 4 {
            mainViewController.setup(presentationStyle: .ScaleFromBig, type: 1)
        } else if indexPath.row == 5 {
            mainViewController.setup(presentationStyle: .SlideAbove, type: 2)
        } else if indexPath.row == 6 {
            mainViewController.setup(presentationStyle: .SlideAbove, type: 3)
        } else if indexPath.row == 7 {
            mainViewController.setup(presentationStyle: .SlideAbove, type: 4)
        }
        
        let window = UIApplication.sharedApplication().keyWindow!
        window.rootViewController = mainViewController
        
        UIView.transitionWithView(window, duration: 0.3, options: [.TransitionCrossDissolve], animations: nil, completion: nil)
    }

}
