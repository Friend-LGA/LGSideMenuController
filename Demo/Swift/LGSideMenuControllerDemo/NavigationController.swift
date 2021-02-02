//
//  NavigationController.swift
//  LGSideMenuControllerDemo
//

class NavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setColors()
    }

    override var shouldAutorotate : Bool {
        return true
    }

    override var prefersStatusBarHidden : Bool {
        return UIApplication.shared.statusBarOrientation.isLandscape && UIDevice.current.userInterfaceIdiom == .phone
    }

    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .default
    }

    override var preferredStatusBarUpdateAnimation : UIStatusBarAnimation {
        return sideMenuController!.isRightViewVisible ? .slide : .fade
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        self.setColors()
    }

    func setColors() {
        self.navigationBar.barTintColor = UIColor(white: (isLightTheme() ? 1.0 : 0.0), alpha: 0.9)
        self.navigationBar.titleTextAttributes = [.foregroundColor: (isLightTheme() ? UIColor.black : UIColor.white)]
    }

}
