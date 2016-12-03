//
//  MainViewController.swift
//  LGSideMenuControllerDemo
//
//  Created by Grigory Lutkov on 25.04.15.
//  Copyright © 2015 Grigory Lutkov <Friend.LGA@gmail.com>. All rights reserved.
//

import UIKit

class MainViewController: LGSideMenuController {

    private lazy var leftViewController: LeftViewController = {
        return self.storyboard!.instantiateViewController(withIdentifier: "LeftViewController") as! LeftViewController
    }()
    
    private lazy var rightViewController: RightViewController = {
        return self.storyboard!.instantiateViewController(withIdentifier: "RightViewController") as! RightViewController
    }()
    
    private var type: Int?
    
    func setup(presentationStyle style: LGSideMenuPresentationStyle, type: Int) {
        self.type = type
        
        if type == 0 {
            setLeftViewEnabledWithWidth(250.0, presentationStyle: style, alwaysVisibleOptions: [])
            
            leftViewStatusBarStyle = .default
            leftViewStatusBarVisibleOptions = LGSideMenuStatusBarVisibleOptions()
            leftViewController.tableView.backgroundColor = .clear
            
            // -----
            
            setRightViewEnabledWithWidth(100.0, presentationStyle: style, alwaysVisibleOptions: [])
            
            rightViewStatusBarStyle = .default
            rightViewStatusBarVisibleOptions = LGSideMenuStatusBarVisibleOptions()
            rightViewController.tableView.backgroundColor = .clear
            
            switch style {
            case .slideAbove:
                leftViewBackgroundColor = UIColor(white: 1.0, alpha: 0.9)
                leftViewController.tableView.backgroundColor = .clear
                leftViewController.tintColor = .black

                rightViewBackgroundColor = UIColor(white: 1.0, alpha: 0.9)
                rightViewController.tableView.backgroundColor = .clear
                rightViewController.tintColor = .black

                break
            case .slideBelow, .scaleFromBig, .scaleFromLittle:
                leftViewBackgroundImage = UIImage(named: "image")
                leftViewController.tableView.backgroundColor = .clear
                leftViewController.tintColor = .white

                rightViewBackgroundImage = UIImage(named: "image2")
                rightViewController.tableView.backgroundColor = .clear
                rightViewController.tintColor = .white
                
                break
            }
        } else if type == 1 {
            setLeftViewEnabledWithWidth(250.0, presentationStyle: style, alwaysVisibleOptions: [.onPhoneLandscape, .onPadLandscape])
            
            leftViewStatusBarStyle = .default
            leftViewStatusBarVisibleOptions = .onPadLandscape
            leftViewBackgroundImage = UIImage(named: "image")
            
            leftViewController.tableView.backgroundColor = .clear
            leftViewController.tintColor = .white
            
            // -----
            
            setRightViewEnabledWithWidth(100.0, presentationStyle: .slideAbove, alwaysVisibleOptions: [])
            
            rightViewStatusBarStyle = .default
            rightViewStatusBarVisibleOptions = .onPadLandscape
            rightViewBackgroundColor = UIColor(white: 1.0, alpha: 0.9)
            
            rightViewController.tableView.backgroundColor = .clear
            rightViewController.tintColor = .black
        } else if type == 2 {
            setLeftViewEnabledWithWidth(250.0, presentationStyle: style, alwaysVisibleOptions: [])
            
            leftViewStatusBarStyle = .default
            leftViewStatusBarVisibleOptions = .onAll
            leftViewBackgroundColor = UIColor(white: 1.0, alpha: 0.9)
            
            leftViewController.tableView.backgroundColor = .clear
            leftViewController.tintColor = .black
            
            // -----
            
            setRightViewEnabledWithWidth(100.0, presentationStyle: style, alwaysVisibleOptions: [])
            
            rightViewStatusBarStyle = .default
            rightViewStatusBarVisibleOptions = .onAll
            rightViewBackgroundColor = UIColor(white: 1.0, alpha: 0.9)
            
            rightViewController.tableView.backgroundColor = .clear
            rightViewController.tintColor = .black
        } else if type == 3 {
            setLeftViewEnabledWithWidth(250.0, presentationStyle: style, alwaysVisibleOptions: [])
            
            leftViewStatusBarStyle = .lightContent
            leftViewStatusBarVisibleOptions = .onAll
            leftViewBackgroundColor = UIColor(white: 0.0, alpha: 0.5)
            
            leftViewController.tableView.backgroundColor = .clear
            leftViewController.tintColor = .white
            
            // -----
            
            setRightViewEnabledWithWidth(100.0, presentationStyle: style, alwaysVisibleOptions: [])
            
            rightViewStatusBarStyle = .lightContent
            rightViewStatusBarVisibleOptions = .onAll
            rightViewBackgroundColor = UIColor(white: 0.0, alpha: 0.5)
            
            rightViewController.tableView.backgroundColor = .clear
            rightViewController.tintColor = .white
        } else if type == 4 {
            swipeGestureArea = .full
            rootViewCoverColorForLeftView = UIColor(red: 0.0, green: 1.0, blue: 0.5, alpha: 0.3)
            rootViewScaleForLeftView = 0.6
            rootViewLayerBorderWidth = 3.0
            rootViewLayerBorderColor = .white
            rootViewLayerShadowRadius = 10.0
            rootViewCoverColorForRightView = UIColor(red: 0.0, green: 0.5, blue: 1.0, alpha: 0.3)
            
            // -----
            
            setLeftViewEnabledWithWidth(250.0, presentationStyle: .scaleFromBig, alwaysVisibleOptions: LGSideMenuAlwaysVisibleOptions())
            
            leftViewAnimationSpeed = 0.4
            leftViewStatusBarStyle = .default
            leftViewStatusBarVisibleOptions = LGSideMenuStatusBarVisibleOptions()
            leftViewBackgroundImage = UIImage(named: "image")
            leftViewStatusBarVisibleOptions = .onPadLandscape
            leftViewBackgroundImageInitialScale = 1.5
            leftViewInititialOffsetX = -200.0
            leftViewInititialScale = 1.5
            
            leftViewController.tableView.backgroundColor = .clear
            leftViewController.tintColor = .white
            
            // -----
            
            setRightViewEnabledWithWidth(100.0, presentationStyle: .slideAbove, alwaysVisibleOptions: LGSideMenuAlwaysVisibleOptions())
            
            rightViewAnimationSpeed = 0.3
            rightViewStatusBarStyle = .default
            rightViewStatusBarVisibleOptions = LGSideMenuStatusBarVisibleOptions()
            rightViewBackgroundColor = UIColor(white: 1.0, alpha: 0.7)
            rightViewStatusBarVisibleOptions = .onPadLandscape
            rightViewLayerBorderWidth = 3.0
            rightViewLayerBorderColor = .black
            rightViewLayerShadowRadius = 10
            
            rightViewController.tableView.backgroundColor = .clear
            rightViewController.tintColor = .black
        }
        
        // -----
        
        leftViewController.tableView.reloadData()
        leftView()!.addSubview(leftViewController.tableView)
        
        rightViewController.tableView.reloadData()
        rightView()!.addSubview(rightViewController.tableView)
    }
    
    override func leftViewWillLayoutSubviews(with size: CGSize) {
        super.leftViewWillLayoutSubviews(with: size)
        
        if !UIApplication.shared.isStatusBarHidden && (type == 2 || type == 3) {
            leftViewController.tableView.frame = CGRect(x: 0.0, y: 20.0, width: size.width, height: size.height - 20.0)
        }
        else {
            leftViewController.tableView.frame = CGRect(origin: CGPoint.zero, size: size)
        }
    }
    
    override func rightViewWillLayoutSubviews(with size: CGSize) {
        super.rightViewWillLayoutSubviews(with: size)
        
        if !UIApplication.shared.isStatusBarHidden && (type == 2 || type == 3) {
            rightViewController.tableView.frame = CGRect(x: 0.0, y: 20.0, width: size.width, height: size.height - 20.0)
        }
        else {
            rightViewController.tableView.frame = CGRect(origin: CGPoint.zero, size: size)
        }
    }

}
