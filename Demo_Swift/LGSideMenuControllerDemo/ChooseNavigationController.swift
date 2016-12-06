//
//  ChooseNavigationController.swift
//  LGSideMenuControllerDemo
//

class ChooseNavigationController: UINavigationController {

    init() {
        let viewController = TableViewController()

        super.init(rootViewController: viewController)
    }

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationBar.isTranslucent = true
        navigationBar.barTintColor = UIColor(red: 0.0, green: 0.5, blue:1.0, alpha:1.0)
        navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        navigationBar.tintColor = UIColor(white: 1.0, alpha: 0.5)
    }

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
