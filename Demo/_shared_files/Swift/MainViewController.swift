//
//  MainViewController.swift
//  LGSideMenuControllerDemo
//

public enum DemoType: Int {
    case styleScaleFromBig
    case styleSlideAbove
    case styleSlideBelow
    case styleScaleFromLittle
    case blurredRootViewCover
    case blurredCoversOfSideViews
    case blurredBackgroundsOfSideViews
    case landscapeIsAlwaysVisible
    case statusBarIsAlwaysVisisble
    case gestureAreaIsFullScreen
    case concurrentTouchActions
    case customStyleExample
}

class MainViewController: LGSideMenuController {
    
    private var type: DemoType?
    
    func setup(type: DemoType) {
        self.type = type

        // -----

        if (self.storyboard != nil) {
            // Left and Right view controllers is set in storyboard
            // Use custom segues with class "LGSideMenuSegue" and identifiers "left" and "right"

            // Sizes and styles is set in storybord
            // You can also find there all other properties

            // LGSideMenuController fully customizable from storyboard
        }
        else {
            leftViewController = LeftViewController()
            rightViewController = RightViewController()

            leftViewWidth = 250.0;
            leftViewBackgroundImage = UIImage(named: "imageLeft")
            leftViewBackgroundColor = UIColor(red: 0.5, green: 0.65, blue: 0.5, alpha: 0.95)
            rootViewCoverColorForLeftView = UIColor(red: 0.0, green: 1.0, blue: 0.0, alpha: 0.05)

            rightViewWidth = 100.0;
            rightViewBackgroundImage = UIImage(named: "imageRight")
            rightViewBackgroundColor = UIColor(red: 0.65, green: 0.5, blue: 0.65, alpha: 0.95)
            rootViewCoverColorForRightView = UIColor(red: 1.0, green: 0.0, blue: 1.0, alpha: 0.05)
        }

        // -----

        let greenCoverColor = UIColor(red: 0.0, green: 0.1, blue: 0.0, alpha: 0.3)
        let purpleCoverColor = UIColor(red: 0.1, green: 0.0, blue: 0.1, alpha: 0.3)
        let regularStyle: UIBlurEffect.Style

        if #available(iOS 10.0, *) {
            regularStyle = .regular
        }
        else {
            regularStyle = .light
        }

        // -----

        switch type {
        case .styleScaleFromBig:
            leftViewPresentationStyle = .scaleFromBig
            rightViewPresentationStyle = .scaleFromBig
        case .styleSlideAbove:
            leftViewPresentationStyle = .slideAbove
            rootViewCoverColorForLeftView = greenCoverColor

            rightViewPresentationStyle = .slideAbove
            rootViewCoverColorForRightView = purpleCoverColor
        case .styleSlideBelow:
            leftViewPresentationStyle = .slideBelow
            rightViewPresentationStyle = .slideBelow
        case .styleScaleFromLittle:
            leftViewPresentationStyle = .scaleFromLittle
            rightViewPresentationStyle = .scaleFromLittle
        case .blurredRootViewCover:
            leftViewPresentationStyle = .scaleFromBig
            rootViewCoverBlurEffectForLeftView = UIBlurEffect(style: regularStyle)
            rootViewCoverAlphaForLeftView = 0.8

            rightViewPresentationStyle = .scaleFromBig
            rootViewCoverBlurEffectForRightView = UIBlurEffect(style: regularStyle)
            rootViewCoverAlphaForRightView = 0.8
        case .blurredCoversOfSideViews:
            leftViewPresentationStyle = .scaleFromBig
            leftViewCoverBlurEffect = UIBlurEffect(style: .dark)
            leftViewCoverColor = nil

            rightViewPresentationStyle = .scaleFromBig
            rightViewCoverBlurEffect = UIBlurEffect(style: .dark)
            rightViewCoverColor = nil
        case .blurredBackgroundsOfSideViews:
            leftViewPresentationStyle = .slideAbove
            leftViewBackgroundBlurEffect = UIBlurEffect(style: regularStyle)
            leftViewBackgroundColor = UIColor(red: 0.0, green: 1.0, blue: 0.0, alpha: 0.05)
            rootViewCoverColorForLeftView = greenCoverColor

            rightViewPresentationStyle = .slideAbove
            rightViewBackgroundBlurEffect = UIBlurEffect(style: regularStyle)
            rightViewBackgroundColor = UIColor(red: 1.0, green: 0.0, blue: 1.0, alpha: 0.05)
            rootViewCoverColorForRightView = purpleCoverColor
        case .landscapeIsAlwaysVisible:
            leftViewPresentationStyle = .slideAbove
            rootViewCoverColorForLeftView = greenCoverColor

            rightViewPresentationStyle = .slideBelow
            rightViewAlwaysVisibleOptions = [.onPhoneLandscape, .onPadLandscape]
        case .statusBarIsAlwaysVisisble:
            leftViewPresentationStyle = .scaleFromBig
            leftViewStatusBarStyle = .lightContent

            rightViewPresentationStyle = .scaleFromBig
            rightViewStatusBarStyle = .lightContent
        case .gestureAreaIsFullScreen:
            swipeGestureArea = .full

            leftViewPresentationStyle = .scaleFromBig
            rightViewPresentationStyle = .scaleFromBig
        case .concurrentTouchActions:
            leftViewPresentationStyle = .scaleFromBig
            rightViewPresentationStyle = .scaleFromBig
        case .customStyleExample:
            rootViewLayerBorderWidth = 5.0
            rootViewLayerBorderColor = .white
            rootViewLayerShadowRadius = 10.0

            leftViewSwipeGestureRange = LGSideMenuSwipeGestureRangeMake(0.0, 88.0)
            leftViewPresentationStyle = .scaleFromBig
            leftViewAnimationDuration = 1.0
            leftViewBackgroundColor = UIColor(red: 0.5, green: 0.75, blue: 0.5, alpha: 1.0)
            leftViewBackgroundImageInitialScale = 1.5
            leftViewInitialOffsetX = -200.0
            leftViewInitialScale = 1.5
            leftViewCoverBlurEffect = UIBlurEffect(style: .dark)
            leftViewBackgroundImage = nil;

            rootViewScaleForLeftView = 0.6
            rootViewCoverColorForLeftView = UIColor(red: 1.0, green: 1.0, blue: 0.0, alpha: 0.3)
            rootViewCoverBlurEffectForLeftView = UIBlurEffect(style: regularStyle)
            rootViewCoverAlphaForLeftView = 0.9

            rightViewSwipeGestureRange = LGSideMenuSwipeGestureRangeMake(88.0, 0.0)
            rightViewPresentationStyle = .slideAbove
            rightViewAnimationDuration = 0.25
            rightViewBackgroundColor = UIColor(red: 0.75, green: 0.5, blue: 0.75, alpha: 1.0)
            rightViewLayerBorderWidth = 3.0
            rightViewLayerBorderColor = .black
            rightViewLayerShadowRadius = 10.0
            
            rootViewCoverColorForRightView = UIColor(red: 0.0, green: 0.5, blue: 1.0, alpha: 0.3)
            rootViewCoverBlurEffectForRightView = UIBlurEffect(style: regularStyle)
            rootViewCoverAlphaForRightView = 0.9
        }
    }

    override func leftViewWillLayoutSubviews(with size: CGSize) {
        super.leftViewWillLayoutSubviews(with: size)

        if !isLeftViewStatusBarHidden {
            leftView?.frame = CGRect(x: 0.0, y: 20.0, width: size.width, height: size.height - 20.0)
        }
    }
    
    override func rightViewWillLayoutSubviews(with size: CGSize) {
        super.rightViewWillLayoutSubviews(with: size)
        
        if (!isRightViewStatusBarHidden ||
            (rightViewAlwaysVisibleOptions.contains(.onPadLandscape) &&
                UI_USER_INTERFACE_IDIOM() == .pad &&
                UIApplication.shared.statusBarOrientation.isLandscape)) {
            rightView?.frame = CGRect(x: 0.0, y: 20.0, width: size.width, height: size.height - 20.0)
        }
    }

    override var isLeftViewStatusBarHidden: Bool {
        get {
            if (type == .statusBarIsAlwaysVisisble) {
                return UIDevice.current.userInterfaceIdiom == .phone
            }

            return super.isLeftViewStatusBarHidden
        }

        set {
            super.isLeftViewStatusBarHidden = newValue
        }
    }

    override var isRightViewStatusBarHidden: Bool {
        get {
            if (type == .statusBarIsAlwaysVisisble) {
                return UIDevice.current.userInterfaceIdiom == .phone
            }

            return super.isRightViewStatusBarHidden
        }

        set {
            super.isRightViewStatusBarHidden = newValue
        }
    }

    deinit {
        print("MainViewController deinitialized")
    }

}
