//
//  MainViewController.swift
//  LGSideMenuControllerDemo
//

import Foundation
import UIKit

public enum DemoType: Int, CaseIterable {
    case styleScaleFromBig
    case styleSlideAboveBlurred
    case styleSlideAbove
    case styleSlideBelowShifted
    case styleSlideBelow
    case styleSlideAside
    case styleScaleFromLittle
    case blurredRootViewCover
    case blurredCoversOfSideViews
    case blurredBackgroundsOfSideViews
    case landscapeIsAlwaysVisible
    case statusBarIsAlwaysVisible
    case gestureAreaIsFullScreen
    case concurrentTouchActions
    case customStyleExample

    var description: String {
        switch self {
        case .styleScaleFromBig:
            return "Style \"Scale From Big\""
        case .styleSlideAboveBlurred:
            return "Style \"Slide Above Blurred\""
        case .styleSlideAbove:
            return "Style \"Slide Above\""
        case .styleSlideBelowShifted:
            return "Style \"Slide Below Shifted\""
        case .styleSlideBelow:
            return "Style \"Slide Below\""
        case .styleSlideAside:
            return "Style \"Slide Aside\""
        case .styleScaleFromLittle:
            return "Style \"Scale From Little\""
        case .blurredRootViewCover:
            return "Blurred root view cover"
        case .blurredCoversOfSideViews:
            return "Blurred covers of side views"
        case .blurredBackgroundsOfSideViews:
            return "Blurred backgrounds side views"
        case .landscapeIsAlwaysVisible:
            return "Landscape is always visible"
        case .statusBarIsAlwaysVisible:
            return "Status bar is always visible"
        case .gestureAreaIsFullScreen:
            return "Gesture area is full screen"
        case .concurrentTouchActions:
            return "Concurrent touch actions"
        case .customStyleExample:
            return "Custom style example"
        }
    }
}

class MainViewController: LGSideMenuController {

    private var isInitialized: Bool = false
    private var type: DemoType?

    // We need this "setup" method here just to share code with storyboard-based demo.
    // Othervise you can instantiate everything inside init method.
    func setup(type: DemoType) {
        self.type = type

        // -----

        if self.storyboard != nil {
            // Root, Left and Right view controllers are set in storyboard
            // Use custom segues with class "LGSideMenuSegue" and identifiers "root", "left" and "right"

            // Sizes and styles are set in storybord
            // You can also find there all other properties

            // LGSideMenuController fully customizable from storyboard
        }
        else if !self.isInitialized {
            self.isInitialized = true

            let rootViewController = RootNavigationController()
            self.rootViewController = rootViewController

            let leftViewController = LeftViewController()
            leftViewController.setup(type: type)
            self.leftViewController = leftViewController
            self.leftViewWidth = 250.0
            self.rootViewCoverColorForLeftView = UIColor(red: 0.0, green: 1.0, blue: 0.0, alpha: 0.05)

            let rightViewController = RightViewController()
            rightViewController.setup(type: type)
            self.rightViewController = rightViewController
            self.rightViewWidth = 100.0
            self.rootViewCoverColorForRightView = UIColor(red: 1.0, green: 0.0, blue: 1.0, alpha: 0.05)
        }

        // -----

        let greenCoverColor = UIColor(red: 0.0, green: 0.1, blue: 0.0, alpha: 0.3)
        let purpleCoverColor = UIColor(red: 0.1, green: 0.0, blue: 0.1, alpha: 0.3)
        let blurStyle: UIBlurEffect.Style

        if #available(iOS 10.0, *) {
            blurStyle = .regular
        }
        else {
            blurStyle = .light
        }

        // -----

        switch type {
        case .styleScaleFromBig:
            leftViewPresentationStyle = .scaleFromBig
            leftViewBackgroundImage = UIImage(named: "imageLeft")

            rightViewPresentationStyle = .scaleFromBig
            rightViewBackgroundImage = UIImage(named: "imageRight")
        case .styleSlideAboveBlurred:
            leftViewPresentationStyle = .slideAboveBlurred
            leftViewBackgroundColor = UIColor(red: 0.0, green: 1.0, blue: 0.0, alpha: 0.05)
            rootViewCoverColorForLeftView = greenCoverColor

            rightViewPresentationStyle = .slideAboveBlurred
            rightViewBackgroundColor = UIColor(red: 1.0, green: 0.0, blue: 1.0, alpha: 0.05)
            rootViewCoverColorForRightView = purpleCoverColor
        case .styleSlideAbove:
            leftViewPresentationStyle = .slideAbove
            leftViewBackgroundColor = UIColor(red: 0.45, green: 0.6, blue: 0.45, alpha: 1.0)
            rootViewCoverColorForLeftView = greenCoverColor

            rightViewPresentationStyle = .slideAbove
            rightViewBackgroundColor = UIColor(red: 0.6, green: 0.45, blue: 0.6, alpha: 1.0)
            rootViewCoverColorForRightView = purpleCoverColor
        case .styleSlideBelowShifted:
            leftViewPresentationStyle = .slideBelowShifted
            leftViewBackgroundImage = UIImage(named: "imageLeft")

            rightViewPresentationStyle = .slideBelowShifted
            rightViewBackgroundImage = UIImage(named: "imageRight")
        case .styleSlideBelow:
            leftViewPresentationStyle = .slideBelow
            leftViewBackgroundImage = UIImage(named: "imageLeft")

            rightViewPresentationStyle = .slideBelow
            rightViewBackgroundImage = UIImage(named: "imageRight")
        case .styleSlideAside:
            let leftImageView = UIImageView(image: UIImage(named: "imageLeft"))
            leftImageView.autoresizingMask = [UIView.AutoresizingMask.flexibleWidth, UIView.AutoresizingMask.flexibleHeight]
            let leftBackgroundEffectView = UIVisualEffectView(effect: UIBlurEffect(style: blurStyle))
            leftBackgroundEffectView.autoresizingMask = [UIView.AutoresizingMask.flexibleWidth, UIView.AutoresizingMask.flexibleHeight]
            let leftBackgroundView = UIView()
            leftBackgroundView.addSubview(leftImageView)
            leftBackgroundView.addSubview(leftBackgroundEffectView)
            leftBackgroundView.autoresizingMask = [UIView.AutoresizingMask.flexibleWidth, UIView.AutoresizingMask.flexibleHeight]

            leftViewPresentationStyle = .slideAside
            leftViewBackgroundView = leftBackgroundView
            leftViewLayerBorderWidth = 1.0
            leftViewLayerBorderColor = isLightTheme() ? .white : .black

            let rightImageView = UIImageView(image: UIImage(named: "imageRight"))
            rightImageView.autoresizingMask = [UIView.AutoresizingMask.flexibleWidth, UIView.AutoresizingMask.flexibleHeight]
            let rightBackgroundEffectView = UIVisualEffectView(effect: UIBlurEffect(style: blurStyle))
            rightBackgroundEffectView.autoresizingMask = [UIView.AutoresizingMask.flexibleWidth, UIView.AutoresizingMask.flexibleHeight]
            let rightBackgroundView = UIView()
            rightBackgroundView.addSubview(rightImageView)
            rightBackgroundView.addSubview(rightBackgroundEffectView)
            rightBackgroundView.autoresizingMask = [UIView.AutoresizingMask.flexibleWidth, UIView.AutoresizingMask.flexibleHeight]

            rightViewPresentationStyle = .slideAside
            rightViewBackgroundView = rightBackgroundView
            rightViewLayerBorderWidth = 1.0
            rightViewLayerBorderColor = isLightTheme() ? .white : .black
        case .styleScaleFromLittle:
            leftViewPresentationStyle = .scaleFromLittle
            leftViewBackgroundImage = UIImage(named: "imageLeft")

            rightViewPresentationStyle = .scaleFromLittle
            rightViewBackgroundImage = UIImage(named: "imageRight")
        case .blurredRootViewCover:
            leftViewPresentationStyle = .scaleFromBig
            leftViewBackgroundImage = UIImage(named: "imageLeft")
            rootViewCoverBlurEffectForLeftView = UIBlurEffect(style: blurStyle)
            rootViewCoverAlphaForLeftView = 0.8

            rightViewPresentationStyle = .scaleFromBig
            rightViewBackgroundImage = UIImage(named: "imageRight")
            rootViewCoverBlurEffectForRightView = UIBlurEffect(style: blurStyle)
            rootViewCoverAlphaForRightView = 0.8
        case .blurredCoversOfSideViews:
            leftViewPresentationStyle = .scaleFromBig
            leftViewCoverBlurEffect = UIBlurEffect(style: .dark)
            leftViewCoverColor = .clear
            leftViewBackgroundImage = UIImage(named: "imageLeft")

            rightViewPresentationStyle = .scaleFromBig
            rightViewCoverBlurEffect = UIBlurEffect(style: .dark)
            rightViewCoverColor = .clear
            rightViewBackgroundImage = UIImage(named: "imageRight")
        case .blurredBackgroundsOfSideViews:
            leftViewPresentationStyle = .slideAbove
            leftViewBackgroundBlurEffect = UIBlurEffect(style: blurStyle)
            leftViewBackgroundColor = UIColor(red: 0.0, green: 1.0, blue: 0.0, alpha: 0.05)
            rootViewCoverColorForLeftView = greenCoverColor

            rightViewPresentationStyle = .slideAbove
            rightViewBackgroundBlurEffect = UIBlurEffect(style: blurStyle)
            rightViewBackgroundColor = UIColor(red: 1.0, green: 0.0, blue: 1.0, alpha: 0.05)
            rootViewCoverColorForRightView = purpleCoverColor
        case .landscapeIsAlwaysVisible:
            let leftImageView = UIImageView(image: UIImage(named: "imageLeft"))
            leftImageView.autoresizingMask = [UIView.AutoresizingMask.flexibleWidth, UIView.AutoresizingMask.flexibleHeight]
            let leftBackgroundEffectView = UIVisualEffectView(effect: UIBlurEffect(style: blurStyle))
            leftBackgroundEffectView.autoresizingMask = [UIView.AutoresizingMask.flexibleWidth, UIView.AutoresizingMask.flexibleHeight]
            let leftBackgroundView = UIView()
            leftBackgroundView.addSubview(leftImageView)
            leftBackgroundView.addSubview(leftBackgroundEffectView)
            leftBackgroundView.autoresizingMask = [UIView.AutoresizingMask.flexibleWidth, UIView.AutoresizingMask.flexibleHeight]

            leftViewPresentationStyle = .slideAside
            leftViewBackgroundView = leftBackgroundView
            leftViewLayerBorderWidth = 1.0
            leftViewLayerBorderColor = isLightTheme() ? .white : .black

            let rightImageView = UIImageView(image: UIImage(named: "imageRight"))
            rightImageView.autoresizingMask = [UIView.AutoresizingMask.flexibleWidth, UIView.AutoresizingMask.flexibleHeight]
            let rightBackgroundEffectView = UIVisualEffectView(effect: UIBlurEffect(style: blurStyle))
            rightBackgroundEffectView.autoresizingMask = [UIView.AutoresizingMask.flexibleWidth, UIView.AutoresizingMask.flexibleHeight]
            let rightBackgroundView = UIView()
            rightBackgroundView.addSubview(rightImageView)
            rightBackgroundView.addSubview(rightBackgroundEffectView)
            rightBackgroundView.autoresizingMask = [UIView.AutoresizingMask.flexibleWidth, UIView.AutoresizingMask.flexibleHeight]

            rightViewAlwaysVisibleOptions = .landscape
            rightViewPresentationStyle = .slideAside
            rightViewBackgroundView = rightBackgroundView
            rightViewLayerBorderWidth = 1.0
            rightViewLayerBorderColor = isLightTheme() ? .white : .black
        case .statusBarIsAlwaysVisible:
            leftViewPresentationStyle = .scaleFromBig
            leftViewBackgroundImage = UIImage(named: "imageLeft")

            rightViewPresentationStyle = .scaleFromBig
            rightViewBackgroundImage = UIImage(named: "imageRight")
        case .gestureAreaIsFullScreen:
            leftViewSwipeGestureArea = .full
            leftViewPresentationStyle = .scaleFromBig
            leftViewBackgroundImage = UIImage(named: "imageLeft")

            rightViewSwipeGestureArea = .full
            rightViewPresentationStyle = .scaleFromBig
            rightViewBackgroundImage = UIImage(named: "imageRight")
        case .concurrentTouchActions:
            leftViewPresentationStyle = .scaleFromBig
            leftViewBackgroundImage = UIImage(named: "imageLeft")

            rightViewPresentationStyle = .scaleFromBig
            rightViewBackgroundImage = UIImage(named: "imageRight")
        case .customStyleExample:
            rootViewLayerBorderWidthForLeftView = 5.0
            rootViewLayerBorderColorForLeftView = .white
            rootViewLayerShadowRadiusForLeftView = 10.0

            rootViewLayerBorderWidthForRightView = 5.0
            rootViewLayerBorderColorForRightView = .white
            rootViewLayerShadowRadiusForRightView = 10.0

            leftViewSwipeGestureRange = SwipeGestureRange(left: 0.0, right: 88.0)
            leftViewPresentationStyle = .scaleFromBig
            leftViewAnimationDuration = 1.0
            leftViewBackgroundColor = UIColor(red: 0.5, green: 0.75, blue: 0.5, alpha: 1.0)
            leftViewBackgroundScaleWhenHidden = 1.5
            leftViewOffsetWhenHidden.x = -200.0
            leftViewScaleWhenHidden = 1.5
            leftViewCoverBlurEffect = UIBlurEffect(style: .dark)

            rootViewScaleWhenHiddenForLeftView = 0.6
            rootViewCoverColorForLeftView = UIColor(red: 1.0, green: 1.0, blue: 0.0, alpha: 0.3)
            rootViewCoverBlurEffectForLeftView = UIBlurEffect(style: blurStyle)
            rootViewCoverAlphaForLeftView = 0.9

            rightViewSwipeGestureRange = SwipeGestureRange(left: 88.0, right: 0.0)
            rightViewPresentationStyle = .slideAbove
            rightViewAnimationDuration = 0.25
            rightViewBackgroundColor = UIColor(red: 0.75, green: 0.5, blue: 0.75, alpha: 1.0)
            rightViewLayerBorderWidth = 3.0
            rightViewLayerBorderColor = .black
            rightViewLayerShadowRadius = 10.0

            rootViewCoverColorForRightView = UIColor(red: 0.0, green: 0.5, blue: 1.0, alpha: 0.3)
            rootViewCoverBlurEffectForRightView = UIBlurEffect(style: blurStyle)
            rootViewCoverAlphaForRightView = 0.9
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        struct Counter { static var count = 0 }
        Counter.count += 1
        print("MainViewController.viewDidLoad(), counter: \(Counter.count)")

        guard let navigationController = self.rootViewController as? RootNavigationController else { return }

        let rootViewController: UIViewController

        if self.type == .concurrentTouchActions {
            if let storyboard = self.storyboard {
                rootViewController = storyboard.instantiateViewController(withIdentifier: "RootViewControllerWithTableView")
            }
            else {
                rootViewController = RootViewControllerWithTableView()
            }
        }
        else {
            if let storyboard = self.storyboard {
                rootViewController = storyboard.instantiateViewController(withIdentifier: "RootViewController")
            }
            else {
                rootViewController = RootViewController()
            }
        }

        navigationController.setViewControllers([rootViewController], animated: false)

        if let leftViewController = self.leftViewController as? LeftViewController,
           let type = self.type {
            leftViewController.setup(type: type)
        }

        if let rightViewController = self.rightViewController as? RightViewController,
           let type = self.type {
            rightViewController.setup(type: type)
        }
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        if let type = self.type {
            self.setup(type: type)
        }
    }

    // MARK: - Logging

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

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        struct Counter { static var count = 0 }
        Counter.count += 1
        print("MainViewController.viewWillLayoutSubviews(), counter: \(Counter.count)")
    }

}
