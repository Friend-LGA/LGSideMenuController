//
//  RootViewController.swift
//  LGSideMenuControllerDemo
//

import Foundation
import UIKit

class RootViewController : UIViewController {

    private let imageView: UIImageView
    private let button: UIButton

    init() {
        self.imageView = UIImageView(image: UIImage(named: "imageRoot"))
        self.imageView.contentMode = .scaleAspectFill

        self.button = UIButton()
        self.button.setTitle("Show Choose Controller", for: .normal)
        self.button.setTitleColor(UIColor(red: 0.0, green: 0.5, blue: 1.0, alpha: 1.0), for: .highlighted)

        super.init(nibName: nil, bundle: nil)

        self.automaticallyAdjustsScrollViewInsets = false

        self.title = "LGSideMenuController"
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Left", style: .plain, target: self, action: #selector(showLeftView(sender:)))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Right", style: .plain, target: self, action: #selector(showRightView(sender:)))

        self.view.addSubview(self.imageView)

        self.button.addTarget(self, action: #selector(showChooseController), for: .touchUpInside)
        self.view.addSubview(self.button)

        self.setColors()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        struct Counter { static var count = 0 }
        Counter.count += 1
        print("RootViewController.viewWillLayoutSubviews(), counter: \(Counter.count)")

        let buttonHeight: CGFloat = 44.0

        self.imageView.frame = CGRect(x: 0.0, y: 0.0, width: view.frame.size.width, height: view.frame.size.height)
        self.button.frame = CGRect(x: 0.0, y: view.frame.size.height - buttonHeight, width: view.frame.size.width, height: buttonHeight)
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        self.setColors()
    }

    // MARK: -

    func setColors() {
        self.button.backgroundColor = UIColor(white:(isLightTheme() ? 1.0 : 0.0), alpha: 0.75)
        self.button.setTitleColor((isLightTheme() ? .black : .white), for: .normal)
    }

    @objc func showLeftView(sender: AnyObject?) {
        sideMenuController?.showLeftView(animated: true)
    }

    @objc func showRightView(sender: AnyObject?) {
        sideMenuController?.showRightView(animated: true)
    }

    @objc func showChooseController() {
        let navigationController = ChooseNavigationController()

        let window = UIApplication.shared.delegate!.window!!
        window.rootViewController = navigationController

        UIView.transition(with: window, duration: 0.3, options: .transitionCrossDissolve, animations: nil, completion: nil)
    }

    // MARK: - Logging

    deinit {
        struct Counter { static var count = 0 }
        Counter.count += 1
        print("RootViewController.deinit(), counter: \(Counter.count)")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        struct Counter { static var count = 0 }
        Counter.count += 1
        print("RootViewController.viewDidLoad(), counter: \(Counter.count)")
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        struct Counter { static var count = 0 }
        Counter.count += 1
        print("RootViewController.viewWillAppear(\(animated)), counter: \(Counter.count)")
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        struct Counter { static var count = 0 }
        Counter.count += 1
        print("RootViewController.viewDidAppear(\(animated)), counter: \(Counter.count)")
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        struct Counter { static var count = 0 }
        Counter.count += 1
        print("RootViewController.viewWillDisappear(\(animated)), counter: \(Counter.count)")
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        struct Counter { static var count = 0 }
        Counter.count += 1
        print("RootViewController.viewDidDisappear(\(animated)), counter: \(Counter.count)")
    }

}
