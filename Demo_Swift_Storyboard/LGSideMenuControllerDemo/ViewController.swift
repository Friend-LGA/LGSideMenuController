//
//  ViewController.swift
//  LGSideMenuControllerDemo
//
//  Created by Grigory Lutkov on 18.02.15.
//  Copyright © 2015 Grigory Lutkov <Friend.LGA@gmail.com>. All rights reserved.
//

import UIKit

class ViewController : UIViewController {

    @IBAction func showChooseController(sender: UIButton) {
        let storyboard = UIStoryboard(name: "Choose", bundle: nil)

        let navigationController = storyboard.instantiateInitialViewController() as! ChooseNavigationController

        let window = UIApplication.shared.delegate!.window!!
        window.rootViewController = navigationController

        UIView.transition(with: window, duration: 0.3, options: .transitionCrossDissolve, animations: nil, completion: nil)
    }

}
