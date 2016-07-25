//
//  LeftViewController.swift
//  LGSideMenuControllerDemo
//
//  Created by Cole Dunsby on 2016-07-24.
//  Copyright © 2016 Cole Dunsby. All rights reserved.
//

import UIKit

class LeftViewController: UITableViewController {

    var tintColor: UIColor?
    
    let titlesArray = [
        "Open Right View",
        "",
        "Profile",
        "News",
        "Articles",
        "Video",
        "Music"
    ]
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.contentInset = UIEdgeInsets(top: 44, left: 0, bottom: 44, right: 0)
    }
    
    // MARK: - UITableViewDataSource
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titlesArray.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! LeftTableViewCell
        cell.textLabel?.text = titlesArray[indexPath.row]
        cell.separatorView.hidden = indexPath.row <= 1 || indexPath.row == titlesArray.count - 1
        cell.userInteractionEnabled = indexPath.row != 1
        cell.tintColor = tintColor
        return cell
    }
    
    // MARK: - UITableViewDelegate
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return indexPath.row == 1 ? 22 : 44
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        let mainViewController = UIApplication.sharedApplication().keyWindow?.rootViewController as! MainViewController
        let navigationController = mainViewController.rootViewController as! UINavigationController
        
        if indexPath.row == 0 {
            if !mainViewController.isLeftViewAlwaysVisible() {
                mainViewController.hideLeftViewAnimated(true, completionHandler: {
                    mainViewController.showRightViewAnimated(true, completionHandler: nil)
                })
            } else {
                mainViewController.showRightViewAnimated(true, completionHandler: nil)
            }
        } else {
            let viewController = UIViewController()
            viewController.view.backgroundColor = .whiteColor()
            viewController.title = "Test \(titlesArray[indexPath.row])"
            navigationController.pushViewController(viewController, animated: true)
            
            mainViewController.hideLeftViewAnimated(true, completionHandler: nil)
        }
    }
    
}
