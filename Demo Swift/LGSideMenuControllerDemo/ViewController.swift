//
//  ViewController.swift
//  LGSideMenuControllerDemo
//
//  Created by Cole Dunsby on 2016-07-24.
//  Copyright © 2016 Cole Dunsby. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    // MARK: - Private Functions
    
    private func mainViewController() -> MainViewController {
        return UIApplication.sharedApplication().keyWindow?.rootViewController as! MainViewController
    }
    
    // MARK: - IBActions
    
    @IBAction private func openLeftView(sender: AnyObject?) {
        mainViewController().showLeftViewAnimated(true, completionHandler: nil)
    }
    
    @IBAction private func openRightView(sender: AnyObject?) {
        mainViewController().showRightViewAnimated(true, completionHandler: nil)
    }

}
