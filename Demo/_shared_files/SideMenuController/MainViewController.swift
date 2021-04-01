//
//  MainViewController.swift
//  LGSideMenuControllerDemo
//

import Foundation
import UIKit

class MainViewController: LGSideMenuController {

    private var type: DemoType?

    // For NonStoryboard Demo
    init(type: DemoType) {
        self.type = type
        super.init(nibName: nil, bundle: nil)
    }

    required public init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    // For Storyboard Demo
    func setup(type: DemoType) {
        self.type = type
    }

    // MARK: - Lifecycle -

    override func viewDidLoad() {
        super.viewDidLoad()
        struct Counter { static var count = 0 }
        Counter.count += 1
        print("MainViewController.viewDidLoad(), counter: \(Counter.count)")

        title = "LGSideMenuController"
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: menuIconImage, style: .plain, target: self, action: #selector(showLeftViewAction(sender:)))
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: menuIconImage, style: .plain, target: self, action: #selector(showRightViewAction(sender:)))

        updateParameters()
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        struct Counter { static var count = 0 }
        Counter.count += 1
        print("MainViewController.viewWillLayoutSubviews(), counter: \(Counter.count)")

        if let leftView = leftView,
           type?.demoRow == .statusBarNoBackground {
            let statusBarHeight = getStatusBarFrame().height
            leftView.frame = CGRect(x: 0.0,
                                    y: statusBarHeight,
                                    width: leftView.bounds.width,
                                    height: view.bounds.height - statusBarHeight)
        }

        if let rightView = rightView,
           type?.demoRow == .statusBarNoBackground {
            let statusBarHeight = getStatusBarFrame().height
            rightView.frame = CGRect(x: 0.0,
                                     y: statusBarHeight,
                                     width: rightView.bounds.width,
                                     height: view.bounds.height - statusBarHeight)
        }
    }

    // MARK: - Theme -

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        updateParameters()
    }

    // MARK: - Other -

    @objc
    func showLeftViewAction(sender: AnyObject?) {
        toggleLeftView(animated: true)
    }

    @objc
    func showRightViewAction(sender: AnyObject?) {
        toggleRightView(animated: true)
    }

    func updateParameters() {
        leftViewWidth = 250.0
        rightViewWidth = 100.0

        guard let type = type else { return }

        leftViewPresentationStyle = type.presentationStyle
        rightViewPresentationStyle = type.presentationStyle

        if type.presentationStyle == .slideAboveBlurred {
            leftViewBackgroundBlurEffect = UIBlurEffect(style: .dark)
            rightViewBackgroundBlurEffect = UIBlurEffect(style: .dark)
        }
        else if type.presentationStyle == .slideAside {
            rootViewLayerBorderWidth = 1.0
            rootViewLayerBorderColor = UIColor(white: isLightTheme() ? 1.0 : 0.0, alpha: 0.9)

            leftViewBackgroundImage = UIImage(named: "imageLeft")
            rightViewBackgroundImage = UIImage(named: "imageRight")
        }
        else {
            leftViewBackgroundImage = UIImage(named: "imageLeft")
            rightViewBackgroundImage = UIImage(named: "imageRight")
        }

        switch type.demoRow {
        case .styleScaleFromBig,
             .styleScaleFromLittle,
             .styleSlideAbove,
             .styleSlideAboveBlurred,
             .styleSlideBelow,
             .styleSlideBelowShifted,
             .styleSlideAside:
            break
        case .usageAsWindowRootViewController,
             .usageInsideNavigationController:
            break
        case .conflictingGesturesScrollView,
             .conflictingGesturesTableView:
            // Make ranges smaller, so we have bigger area to interact with scroll and table views
            leftViewSwipeGestureRange = SwipeGestureRange(left: 0.0, right: 20.0)
            rightViewSwipeGestureRange = SwipeGestureRange(left: 20.0, right: 0.0)
        case .statusBarRootAndSide:
            break
        case .statusBarOnlyRoot:
            break
        case .statusBarOnlySide:
            if !type.presentationStyle.shouldRootViewScale {
                rootViewCoverBlurEffect = UIBlurEffect(style: .dark)
            }
        case .statusBarHidden:
            break
        case .statusBarDifferentStyles:
            if !type.presentationStyle.shouldRootViewScale {
                rootViewCoverBlurEffect = UIBlurEffect(style: isLightTheme() ? .dark : .light)
            }
        case .statusBarCustomBackground:
            leftViewStatusBarBackgroundColor = isLightTheme() ? .white : .black
            leftViewStatusBarBackgroundAlpha = 1.0
            leftViewStatusBarBackgroundBlurEffect = nil

            rightViewStatusBarBackgroundColor = isLightTheme() ? .white : .black
            rightViewStatusBarBackgroundAlpha = 1.0
            rightViewStatusBarBackgroundBlurEffect = nil

            if type.presentationStyle.isBelow {
                leftViewStatusBarBackgroundShadowColor = UIColor(white: 0.0, alpha: 0.5)
                leftViewStatusBarBackgroundShadowRadius = 8.0

                rightViewStatusBarBackgroundShadowColor = UIColor(white: 0.0, alpha: 0.5)
                rightViewStatusBarBackgroundShadowRadius = 8.0
            }
            else {
                leftViewStatusBarBackgroundShadowColor = .clear
                leftViewStatusBarBackgroundShadowRadius = 0.0

                rightViewStatusBarBackgroundShadowColor = .clear
                rightViewStatusBarBackgroundShadowRadius = 0.0
            }
        case .statusBarNoBackground:
            isLeftViewStatusBarBackgroundHidden = true
            isRightViewStatusBarBackgroundHidden = true
        case .alwaysVisibleLandscapeLeft:
            leftViewAlwaysVisibleOptions = [.landscape]
        case .alwaysVisibleLandscapeRight:
            rightViewAlwaysVisibleOptions = [.landscape]
        case .alwaysVisibleLandscapeBoth:
            leftViewAlwaysVisibleOptions = [.landscape]
            rightViewAlwaysVisibleOptions = [.landscape]
        case .alwaysVisibleRegularLeft:
            leftViewAlwaysVisibleOptions = [.regular]
        case .alwaysVisibleRegularRight:
            rightViewAlwaysVisibleOptions = [.regular]
        case .alwaysVisibleRegularBoth:
            leftViewAlwaysVisibleOptions = [.regular]
            rightViewAlwaysVisibleOptions = [.regular]
        case .gestureAreaAndRangeBordersDefault:
            leftViewSwipeGestureArea = .borders
            rightViewSwipeGestureArea = .borders
        case .gestureAreaAndRangeBordersCustom:
            leftViewSwipeGestureArea = .borders
            leftViewSwipeGestureRange = SwipeGestureRange(left: 44.0, right: 128.0)

            rightViewSwipeGestureArea = .borders
            rightViewSwipeGestureRange = SwipeGestureRange(left: 128.0, right: 44.0)
        case .gestureAreaAndRangeFull:
            leftViewSwipeGestureArea = .full
            rightViewSwipeGestureArea = .full
        case .gestureAreaAndRangeDisabled:
            isLeftViewSwipeGestureDisabled = true
            isRightViewSwipeGestureDisabled = true
        case .coversWithColor:
            rootViewCoverColor = UIColor(white: 0.0, alpha: 0.9)
            leftViewCoverColor = .black
            rightViewCoverColor = .black
        case .coversWithBlur:
            rootViewCoverBlurEffect = UIBlurEffect(style: .dark)
            rootViewCoverAlpha = 0.9
            leftViewCoverBlurEffect = UIBlurEffect(style: .dark)
            rightViewCoverBlurEffect = UIBlurEffect(style: .dark)
        default:
            break
        }

        // Also look at:
        //
        // Change size of left and right views if needed:
        // viewWillLayoutSubviews
        //
        // Root view status bar appearance setup:
        // RootNavigationController.prefersStatusBarHidden
        // RootNavigationController.preferredStatusBarStyle
        // RootNavigationController.preferredStatusBarUpdateAnimation
        //
        // Left view status bar appearance setup:
        // LeftViewController.prefersStatusBarHidden
        // LeftViewController.preferredStatusBarStyle
        // LeftViewController.preferredStatusBarUpdateAnimation
        //
        // Right view status bar appearance setup:
        // RightViewController.prefersStatusBarHidden
        // RightViewController.preferredStatusBarStyle
        // RightViewController.preferredStatusBarUpdateAnimation
        //
        // =================================================================================
        //
        // For better understanding of always visible options, read more about horizontal size classes:
        // https://developer.apple.com/documentation/uikit/uitraitcollection
        //
        // =================================================================================
        //
        // To set status bar appearance you can use either default UIViewController methods:
        //
        // UIViewController {
        //   prefersStatusBarHidden
        //   preferredStatusBarStyle
        //   preferredStatusBarUpdateAnimation
        // }
        //
        // or LGSideMenuController specific methods:
        //
        // LGSideMenuController {
        //   isRootViewStatusBarHidden
        //   rootViewStatusBarStyle
        //   rootViewStatusBarUpdateAnimation
        //
        //   isLeftViewStatusBarHidden
        //   leftViewStatusBarStyle
        //   leftViewStatusBarUpdateAnimation
        //
        //   isRightViewStatusBarHidden
        //   rightViewStatusBarStyle
        //   rightViewStatusBarUpdateAnimation
        // }
        //
        // =================================================================================
        //
        // For more information read README.md and wiki on github:
        // https://github.com/Friend-LGA/LGSideMenuController
    }

    // MARK: - Logging -

    deinit {
        struct Counter { static var count = 0 }
        Counter.count += 1
        print("MainViewController.deinit(), counter: \(Counter.count)")
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        struct Counter { static var count = 0 }
        Counter.count += 1
        print("MainViewController.viewWillAppear(\(animated)), counter: \(Counter.count)")
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        struct Counter { static var count = 0 }
        Counter.count += 1
        print("MainViewController.viewDidAppear(\(animated)), counter: \(Counter.count)")
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        struct Counter { static var count = 0 }
        Counter.count += 1
        print("MainViewController.viewWillDisappear(\(animated)), counter: \(Counter.count)")
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        struct Counter { static var count = 0 }
        Counter.count += 1
        print("MainViewController.viewDidDisappear(\(animated)), counter: \(Counter.count)")
    }

    override func rootViewLayoutSubviews() {
        super.rootViewLayoutSubviews()
        struct Counter { static var count = 0 }
        Counter.count += 1
        print("MainViewController.rootViewLayoutSubviews(), counter: \(Counter.count)")
    }

    override func leftViewLayoutSubviews() {
        super.leftViewLayoutSubviews()
        struct Counter { static var count = 0 }
        Counter.count += 1
        print("MainViewController.leftViewLayoutSubviews(), counter: \(Counter.count)")
    }

    override func rightViewLayoutSubviews() {
        super.rightViewLayoutSubviews()
        struct Counter { static var count = 0 }
        Counter.count += 1
        print("MainViewController.rightViewLayoutSubviews(), counter: \(Counter.count)")
    }

}
