//
//  RootNavigationController.swift
//  LGSideMenuControllerDemo
//

import Foundation
import UIKit

class RootNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        struct Counter { static var count = 0 }
        Counter.count += 1
        print("RootNavigationController.viewDidLoad(), counter: \(Counter.count)")

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

    // MARK: - Logging

    deinit {
        struct Counter { static var count = 0 }
        Counter.count += 1
        print("RootNavigationController.deinit(), counter: \(Counter.count)")
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        struct Counter { static var count = 0 }
        Counter.count += 1
        print("RootNavigationController.viewWillAppear(\(animated)), counter: \(Counter.count)")
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        struct Counter { static var count = 0 }
        Counter.count += 1
        print("RootNavigationController.viewDidAppear(\(animated)), counter: \(Counter.count)")
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        struct Counter { static var count = 0 }
        Counter.count += 1
        print("RootNavigationController.viewWillDisappear(\(animated)), counter: \(Counter.count)")
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        struct Counter { static var count = 0 }
        Counter.count += 1
        print("RootNavigationController.viewDidDisappear(\(animated)), counter: \(Counter.count)")
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        struct Counter { static var count = 0 }
        Counter.count += 1
        print("RootNavigationController.viewWillLayoutSubviews(), counter: \(Counter.count)")
    }

}
