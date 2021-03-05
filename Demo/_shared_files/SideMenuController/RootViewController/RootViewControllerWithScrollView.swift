//
//  RootViewControllerWithScrollView.swift
//  LGSideMenuControllerDemo
//

import Foundation
import UIKit

class RootViewControllerWithScrollView: RootViewController {

    private let scrollView = UIScrollView()

    // MARK: - Lifecycle -

    override func viewDidLoad() {
        super.viewDidLoad()

        // For iOS < 11.0 use this property to avoid artefacts if necessary
        // automaticallyAdjustsScrollViewInsets = false

        scrollView.contentInsetAdjustmentBehavior = .never
        view.insertSubview(scrollView, at: 0)

        imageView.clipsToBounds = true
        imageView.removeFromSuperview()
        scrollView.addSubview(imageView)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        scrollView.contentOffset = CGPoint(x: (view.bounds.width * 5.0 / 2.0) - (view.bounds.width / 2.0),
                                           y: (view.bounds.height * 3.0 / 2.0) - (view.bounds.height / 2.0))
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()

        scrollView.frame = view.bounds
        scrollView.contentInset = .zero
        scrollView.scrollIndicatorInsets = {
            let topInset = demoDescriptionBackgroundView != nil ?
                demoDescriptionBackgroundView!.frame.maxY - view.safeAreaLayoutGuide.layoutFrame.minY : 0.0
            return UIEdgeInsets(top: topInset, left: 0.0, bottom: buttonBackground.bounds.height, right: 0.0)
        }()

        imageView.frame = CGRect(origin: .zero,
                                 size: CGSize(width: scrollView.frame.width * 5.0,
                                              height: scrollView.frame.height * 3.0))
        scrollView.contentSize = imageView.frame.size
    }

    // MARK: - Other -

    override func setColors() {
        super.setColors()
        scrollView.backgroundColor = .gray
    }

}
