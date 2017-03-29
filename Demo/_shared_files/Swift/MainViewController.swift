//
//  MainViewController.swift
//  LGSideMenuControllerDemo
//

class MainViewController: LGSideMenuController {
    override func viewDidLoad() {
        super.viewDidLoad()

        let a = UIViewController()
        a.title = "root"
        a.view.backgroundColor = .red

        let b = UIViewController()
        b.title = "push"
        b.view.backgroundColor = .blue

        let nav = UINavigationController(rootViewController: a)

        let tab = UITabBarController()
        tab.setViewControllers([nav], animated: false)

        self.rootViewController = tab

        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            nav.pushViewController(b, animated: true)
        }
    }
}
