//
//  RootViewControllerWithTextLabel.swift
//  LGSideMenuControllerDemo
//

import Foundation
import UIKit

class RootViewControllerWithTextLabel : RootViewController {

    private let textLabel = UILabel()
    private let textLabelBackground = UIVisualEffectView(effect: UIBlurEffect(style: .regular))

    init(title: String, imageName: String? = nil) {
        super.init(title: title, showSideButtons: false, imageName: imageName)
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

        textLabelBackground.layer.masksToBounds = true
        view.addSubview(textLabelBackground)

        textLabel.text = title
        textLabel.font = UIFont.boldSystemFont(ofSize: 64.0)
        textLabel.textAlignment = .center
        textLabel.numberOfLines = 1
        textLabel.lineBreakMode = .byWordWrapping
        textLabel.backgroundColor = .clear
        textLabel.adjustsFontSizeToFitWidth = true
        textLabel.baselineAdjustment = .alignCenters
        view.addSubview(textLabel)
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        struct Counter { static var count = 0 }
        Counter.count += 1
        print("RootViewController.viewWillLayoutSubviews(), counter: \(Counter.count)")

        let textLabelOffset: CGFloat = 16.0
        textLabel.frame = {
            let safeAreaLayoutFrame = view.safeAreaLayoutGuide.layoutFrame
            let areaOffsetY = demoDescriptionBackgroundView?.frame.maxY ?? safeAreaLayoutFrame.minY
            let areaHeight = view.bounds.height - areaOffsetY - buttonBackground.bounds.height

            let maxWidth = view.bounds.width - (textLabelOffset * 4.0)
            var size = textLabel.sizeThatFits(CGSize(width: maxWidth, height: CGFloat.greatestFiniteMagnitude))
            size.width = max(size.width, size.height)
            size.width = min(size.width, maxWidth)
            return CGRect(x: view.bounds.width / 2.0 - size.width / 2.0,
                          y: areaOffsetY + areaHeight / 2.0 - size.height / 2.0,
                          width: size.width,
                          height: size.height)
        }()

        if textLabel.bounds.width == textLabel.bounds.height {
            textLabelBackground.frame = textLabel.frame.insetBy(dx: -textLabelOffset, dy: -textLabelOffset)
            textLabelBackground.layer.cornerRadius = textLabelBackground.bounds.height / 2.0
        }
        else {
            textLabelBackground.frame = textLabel.frame.insetBy(dx: -textLabelOffset * 2.0, dy: -textLabelOffset)
            textLabelBackground.layer.cornerRadius = 32.0
        }
    }

    // MARK: - Other -

    override func setColors() {
        super.setColors()
        textLabel.textColor = isLightTheme() ? .black : .white
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

