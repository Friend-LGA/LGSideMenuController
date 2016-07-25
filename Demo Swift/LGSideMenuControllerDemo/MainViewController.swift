//
//  MainViewController.swift
//  LGSideMenuControllerDemo
//
//  Created by Cole Dunsby on 2016-07-24.
//  Copyright © 2016 Cole Dunsby. All rights reserved.
//

import UIKit

class MainViewController: LGSideMenuController {

    private lazy var leftViewController: LeftViewController = {
        return self.storyboard?.instantiateViewControllerWithIdentifier("LeftViewController") as! LeftViewController
    }()
    
    private lazy var rightViewController: RightViewController = {
        return self.storyboard?.instantiateViewControllerWithIdentifier("RightViewController") as! RightViewController
    }()
    
    private var type: Int?
    
    func setup(presentationStyle style: LGSideMenuPresentationStyle, type: Int) {
        self.type = type
        
        if type == 0 {
            setLeftViewEnabledWithWidth(250, presentationStyle: style, alwaysVisibleOptions: .OnNone)
            
            leftViewStatusBarStyle = .Default
            leftViewStatusBarVisibleOptions = .OnNone
            leftViewController.tableView.backgroundColor = .clearColor()
            
            // -----
            
            setRightViewEnabledWithWidth(100, presentationStyle: style, alwaysVisibleOptions: .OnNone)
            
            rightViewStatusBarStyle = .Default
            rightViewStatusBarVisibleOptions = .OnNone
            rightViewController.tableView.backgroundColor = .clearColor()
            
            switch style {
            case .SlideAbove:
                leftViewBackgroundColor = UIColor(white: 1.0, alpha: 0.9)
                leftViewController.tintColor = .blackColor()
                
                // -----
                
                rightViewBackgroundColor = UIColor(white: 1.0, alpha: 0.9)
                rightViewController.tintColor = .blackColor()
            case .SlideBelow, .ScaleFromBig, .ScaleFromLittle:
                leftViewBackgroundImage = UIImage(named: "image")
                leftViewController.tintColor = .whiteColor()
                
                // -----
                
                rightViewBackgroundImage = UIImage(named: "image2")
                rightViewController.tintColor = .whiteColor()
            }
        } else if type == 1 {
            setLeftViewEnabledWithWidth(250, presentationStyle: style, alwaysVisibleOptions: [.OnPhoneLandscape, .OnPadLandscape])
            
            leftViewStatusBarStyle = .Default
            leftViewStatusBarVisibleOptions = .OnPadLandscape
            leftViewBackgroundImage = UIImage(named: "image")
            
            leftViewController.tableView.backgroundColor = .clearColor()
            leftViewController.tintColor = .whiteColor()
            
            // -----
            
            setRightViewEnabledWithWidth(100, presentationStyle: style, alwaysVisibleOptions: .OnNone)
            
            rightViewStatusBarStyle = .Default
            rightViewStatusBarVisibleOptions = .OnPadLandscape
            rightViewBackgroundColor = UIColor(white: 1.0, alpha: 0.9)
            
            rightViewController.tableView.backgroundColor = .clearColor()
            rightViewController.tintColor = .blackColor()
        } else if type == 2 {
            setLeftViewEnabledWithWidth(250, presentationStyle: style, alwaysVisibleOptions: .OnNone)
            
            leftViewStatusBarStyle = .Default
            leftViewStatusBarVisibleOptions = .OnAll
            leftViewBackgroundColor = UIColor(white: 1.0, alpha: 0.9)
            
            leftViewController.tableView.backgroundColor = .clearColor()
            leftViewController.tintColor = .blackColor()
            
            // -----
            
            setRightViewEnabledWithWidth(100, presentationStyle: style, alwaysVisibleOptions: .OnNone)
            
            rightViewStatusBarStyle = .Default
            rightViewStatusBarVisibleOptions = .OnAll
            rightViewBackgroundColor = UIColor(white: 1.0, alpha: 0.9)
            
            rightViewController.tableView.backgroundColor = .clearColor()
            rightViewController.tintColor = .blackColor()
        } else if type == 3 {
            setLeftViewEnabledWithWidth(250, presentationStyle: style, alwaysVisibleOptions: .OnNone)
            
            leftViewStatusBarStyle = .LightContent
            leftViewStatusBarVisibleOptions = .OnAll
            leftViewBackgroundColor = UIColor(white: 0.0, alpha: 0.5)
            
            leftViewController.tableView.backgroundColor = .clearColor()
            leftViewController.tintColor = .whiteColor()
            
            // -----
            
            setRightViewEnabledWithWidth(100, presentationStyle: style, alwaysVisibleOptions: .OnNone)
            
            rightViewStatusBarStyle = .LightContent
            rightViewStatusBarVisibleOptions = .OnAll
            rightViewBackgroundColor = UIColor(white: 0.0, alpha: 0.5)
            
            rightViewController.tableView.backgroundColor = .clearColor()
            rightViewController.tintColor = .whiteColor()
        } else if type == 4 {
            swipeGestureArea = .Full
            rootViewCoverColorForLeftView = UIColor(red: 0.0, green: 1.0, blue: 0.5, alpha: 0.3)
            rootViewScaleForLeftView = 0.6
            rootViewLayerBorderWidth = 3
            rootViewLayerBorderColor = .whiteColor()
            rootViewLayerShadowRadius = 10
            rootViewCoverColorForRightView = UIColor(red: 0.0, green: 0.5, blue: 1.0, alpha: 0.3)
            
            // -----
            
            setLeftViewEnabledWithWidth(250, presentationStyle: .ScaleFromBig, alwaysVisibleOptions: .OnNone)
            
            leftViewAnimationSpeed = 0.4
            leftViewStatusBarStyle = .Default
            leftViewStatusBarVisibleOptions = .OnNone
            leftViewBackgroundImage = UIImage(named: "image")
            leftViewStatusBarVisibleOptions = .OnPadLandscape
            leftViewBackgroundImageInitialScale = 1.5
            leftViewInititialOffsetX = -200
            leftViewInititialScale = 1.5
            
            leftViewController.tableView.backgroundColor = .clearColor()
            leftViewController.tintColor = .whiteColor()
            
            // -----
            
            setRightViewEnabledWithWidth(100, presentationStyle: .SlideAbove, alwaysVisibleOptions: .OnNone)
            
            rightViewAnimationSpeed = 0.3
            rightViewStatusBarStyle = .Default
            rightViewStatusBarVisibleOptions = .OnNone
            rightViewBackgroundColor = UIColor(white: 1.0, alpha: 0.7)
            rightViewStatusBarVisibleOptions = .OnPadLandscape
            rightViewLayerBorderWidth = 3
            rightViewLayerBorderColor = .blackColor()
            rightViewLayerShadowRadius = 10
            
            rightViewController.tableView.backgroundColor = .clearColor()
            rightViewController.tintColor = .blackColor()
        }
        
        // -----
        
        leftViewController.tableView.reloadData()
        leftView().addSubview(leftViewController.tableView)
        
        rightViewController.tableView.reloadData()
        rightView().addSubview(rightViewController.tableView)
    }
    
    override func leftViewWillLayoutSubviewsWithSize(size: CGSize) {
        super.leftViewWillLayoutSubviewsWithSize(size)
        
        if UIApplication.sharedApplication().statusBarHidden && (type == 2 || type == 3) {
            leftViewController.tableView.frame = CGRect(x: 0, y: 20, width: size.width, height: size.height - 20)
        } else {
            leftViewController.tableView.frame = CGRect(origin: CGPoint.zero, size: size)
        }
    }
    
    override func rightViewWillLayoutSubviewsWithSize(size: CGSize) {
        super.rightViewWillLayoutSubviewsWithSize(size)
        
        if UIApplication.sharedApplication().statusBarHidden && (type == 2 || type == 3) {
            rightViewController.tableView.frame = CGRect(x: 0, y: 20, width: size.width, height: size.height - 20)
        } else {
            rightViewController.tableView.frame = CGRect(origin: CGPoint.zero, size: size)
        }
    }

}
