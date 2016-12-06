//
//  ViewController.swift
//  LGSideMenuControllerDemo
//

class ViewController : UIViewController {

    private lazy var imageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "imageRoot"))
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()

    private lazy var button: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor(white: 1.0, alpha: 0.5)
        button.setTitle("Show Choose Controller", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.setTitleColor(UIColor(red: 0.0, green: 0.5, blue: 1.0, alpha: 1.0), for: .highlighted)
        button.addTarget(self, action: #selector(showChooseController), for: .touchUpInside)
        return button
    }()

    init() {
        super.init(nibName: nil, bundle: nil)

        title = "LGSideMenuController"

        view.backgroundColor = .white

        view.addSubview(imageView)
        view.addSubview(button)

        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Left", style: .plain, target: self, action: #selector(showLeftView(sender:)))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Right", style: .plain, target: self, action: #selector(showRightView(sender:)))
    }

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()

        imageView.frame = CGRect(x: 0.0, y: 0.0, width: view.frame.size.width, height: view.frame.size.height)

        button.frame = CGRect(x: 0.0, y: view.frame.size.height-44.0, width: view.frame.size.width, height: 44.0)
    }

    // MARK: -

    func showLeftView(sender: AnyObject?) {
        sideMenuController?.showLeftView(animated: true, completionHandler: nil)
    }

    func showRightView(sender: AnyObject?) {
        sideMenuController?.showRightView(animated: true, completionHandler: nil)
    }

    func showChooseController() {
        let navigationController = ChooseNavigationController()

        let window = UIApplication.shared.delegate!.window!!
        window.rootViewController = navigationController

        UIView.transition(with: window, duration: 0.3, options: .transitionCrossDissolve, animations: nil, completion: nil)
    }

}
