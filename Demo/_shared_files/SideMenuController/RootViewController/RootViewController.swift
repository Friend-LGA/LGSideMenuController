//
//  RootViewController.swift
//  LGSideMenuControllerDemo
//

import Foundation
import UIKit

private let titleDefault = "LGSideMenuController"
private let showSideButtonsDefault = true
private let buttonHeight: CGFloat = 44.0

class RootViewController : UIViewController {

    var demoDescriptionLabel: UILabel?
    var demoDescriptionBackgroundView: UIVisualEffectView?

    var showSideButtons: Bool = showSideButtonsDefault

    var imageView = UIImageView()

    let button = UIButton()
    let buttonBackground = UIVisualEffectView(effect: UIBlurEffect(style: .regular))

    init(title: String = titleDefault,
         description: String? = nil,
         showSideButtons: Bool = showSideButtonsDefault,
         imageName: String? = nil) {
        super.init(nibName: nil, bundle: nil)

        self.title = title

        if let description = description, !description.isEmpty {
            demoDescriptionLabel = UILabel()
            demoDescriptionLabel!.text = description
            demoDescriptionBackgroundView = UIVisualEffectView(effect: UIBlurEffect(style: .regular))
        }
        else {
            demoDescriptionLabel = nil
            demoDescriptionBackgroundView = nil
        }
        self.showSideButtons = showSideButtons
        imageView.image = UIImage(named: imageName ?? getBackgroundImageNameDefault())
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle -

    override func viewDidLoad() {
        super.viewDidLoad()
        struct Counter { static var count = 0 }
        Counter.count += 1
        print("RootViewController.viewDidLoad(), counter: \(Counter.count)")

        view.clipsToBounds = true

        if showSideButtons {
            navigationItem.leftBarButtonItem = UIBarButtonItem(image: menuIconImage, style: .plain, target: self, action: #selector(showLeftView(sender:)))
            navigationItem.rightBarButtonItem = UIBarButtonItem(image: menuIconImage, style: .plain, target: self, action: #selector(showRightView(sender:)))
        }

        imageView.contentMode = .scaleAspectFill
        view.addSubview(imageView)

        if let label = demoDescriptionLabel,
           let backgroundView = demoDescriptionBackgroundView {
            view.addSubview(backgroundView)

            label.font = UIFont.boldSystemFont(ofSize: 12.0)
            label.textAlignment = .left
            label.numberOfLines = 0
            label.lineBreakMode = .byWordWrapping
            label.backgroundColor = .clear
            backgroundView.contentView.addSubview(label)
        }

        view.addSubview(buttonBackground)

        button.setTitle("Show Choose Controller", for: .normal)
        button.setTitleColor(UIColor(red: 0.0, green: 0.5, blue: 1.0, alpha: 1.0), for: .highlighted)
        button.addTarget(self, action: #selector(showChooseController), for: .touchUpInside)
        button.backgroundColor = .clear
        buttonBackground.contentView.addSubview(button)

        setColors()
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        struct Counter { static var count = 0 }
        Counter.count += 1
        print("RootViewController.viewWillLayoutSubviews(), counter: \(Counter.count)")

        let safeAreaLayoutFrame = view.safeAreaLayoutGuide.layoutFrame

        imageView.frame = CGRect(x: 0.0, y: 0.0, width: view.frame.size.width, height: view.frame.size.height)

        if let label = demoDescriptionLabel,
           let backgroundView = demoDescriptionBackgroundView {
            let labelOffset: CGFloat = 8.0

            let labelSize = label.sizeThatFits(CGSize(width: view.bounds.width - (labelOffset * 2.0),
                                                      height: CGFloat.greatestFiniteMagnitude))

            backgroundView.frame = CGRect(x: 0.0,
                                          y: 0.0,
                                          width: view.bounds.width,
                                          height: labelSize.height + (labelOffset * 2.0) + safeAreaLayoutFrame.minY)

            label.frame = {
                let labelOriginY = backgroundView.bounds.height - labelSize.height - labelOffset * 2.0
                return CGRect(x: labelOffset,
                              y: labelOriginY,
                              width: backgroundView.bounds.width - labelOffset * 2.0,
                              height: backgroundView.bounds.height - labelOriginY)
            }()
        }

        buttonBackground.frame = {
            let bottomOffset = view.bounds.height - (safeAreaLayoutFrame.minY + safeAreaLayoutFrame.height)
            let height = buttonHeight + bottomOffset
            return CGRect(x: 0.0,
                          y: view.frame.size.height - height,
                          width: view.frame.size.width,
                          height: height)
        }()

        button.frame = CGRect(x: 0.0, y: 0.0, width: buttonBackground.bounds.width, height: buttonHeight)
    }

    // MARK: - Theme -

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        setColors()
    }

    // MARK: - Other -

    @objc
    func showLeftView(sender: AnyObject?) {
        sideMenuController?.toggleLeftView(animated: true)
    }

    @objc
    func showRightView(sender: AnyObject?) {
        sideMenuController?.toggleRightView(animated: true)
    }

    @objc
    func showChooseController() {
        let storyboard = UIStoryboard(name: "Choose", bundle: nil)
        let controller = storyboard.instantiateInitialViewController() as! ChooseNavigationController
        let window = UIApplication.shared.delegate!.window!!

        window.rootViewController = controller

        UIView.transition(with: window, duration: 0.3, options: .transitionCrossDissolve, animations: nil, completion: nil)
    }

    func setColors() {
        button.setTitleColor(isLightTheme() ? .black : .white, for: .normal)
    }

    // MARK: - Logging -

    deinit {
        struct Counter { static var count = 0 }
        Counter.count += 1
        print("RootViewController.deinit(), counter: \(Counter.count)")
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
