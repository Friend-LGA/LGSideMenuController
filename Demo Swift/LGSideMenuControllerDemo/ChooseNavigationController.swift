//
//  ChooseNavigationController.swift
//  LGSideMenuControllerDemo
//
//  Created by Cole Dunsby on 2016-07-25.
//  Copyright © 2016 Cole Dunsby. All rights reserved.
//

import UIKit

class ChooseNavigationController: UINavigationController {

    override func shouldAutorotate() -> Bool {
        return true
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return UI_USER_INTERFACE_IDIOM() == .Phone && UIInterfaceOrientationIsLandscape(UIApplication.sharedApplication().statusBarOrientation)
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
    
    override func preferredStatusBarUpdateAnimation() -> UIStatusBarAnimation {
        return .None
    }

}
