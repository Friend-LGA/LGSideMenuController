//
//  ChooseNavigationController.swift
//  LGSideMenuControllerDemo
//
//  Created by Grigory Lutkov on 05.11.15.
//  Copyright © 2015 Grigory Lutkov <Friend.LGA@gmail.com>. All rights reserved.
//

import UIKit

class ChooseNavigationController: UINavigationController {

    override var shouldAutorotate : Bool {
        return true
    }
    
    override var prefersStatusBarHidden : Bool {
        return UIInterfaceOrientationIsLandscape(UIApplication.shared.statusBarOrientation) && UI_USER_INTERFACE_IDIOM() == .phone
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .lightContent
    }
    
    override var preferredStatusBarUpdateAnimation : UIStatusBarAnimation {
        return .none
    }

}
