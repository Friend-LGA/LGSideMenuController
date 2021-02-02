//
//  ChooseNavigationController.swift
//  LGSideMenuControllerDemo
//

class ChooseNavigationController: UINavigationController {
    
    init() {
        super.init(rootViewController: ChooseTableViewController())
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationBar.barTintColor = UIColor(red: 0.0, green: 0.5, blue:1.0, alpha:1.0)
        navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
    }
    
    override var shouldAutorotate : Bool {
        return true
    }
    
    override var prefersStatusBarHidden : Bool {
        return UIApplication.shared.statusBarOrientation.isLandscape && UIDevice.current.userInterfaceIdiom == .phone
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .lightContent
    }
    
    override var preferredStatusBarUpdateAnimation : UIStatusBarAnimation {
        return .none
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        self.setColors()
    }
    
    func setColors() {
        self.view.backgroundColor = (isLightTheme() ? .white : .black)
    }
}
