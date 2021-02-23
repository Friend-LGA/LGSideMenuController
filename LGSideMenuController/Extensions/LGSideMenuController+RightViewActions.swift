//
//  LGSideMenuController+RightViewActions.swift
//  LGSideMenuController
//
//
//  The MIT License (MIT)
//
//  Copyright © 2015 Grigorii Lutkov <friend.lga@gmail.com>
//  (https://github.com/Friend-LGA/LGSideMenuController)
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.
//

import Foundation
import UIKit

extension LGSideMenuController {

    open func showRightView(animated: Bool = true, completion: Completion? = nil) {
        guard self.rightView != nil,
              self.isRightViewEnabled,
              !self.isRightViewAlwaysVisibleForCurrentOrientation,
              !self.isRightViewShowing else { return }

        self.showRightViewPrepare(updateStatusBar: false)
        self.showRightViewActions(animated: animated, completion: completion)
    }

    open func hideRightView(animated: Bool = true, completion: Completion? = nil) {
        guard self.rightView != nil,
              self.isRightViewEnabled,
              !self.isRightViewAlwaysVisibleForCurrentOrientation,
              !self.isRightViewHidden else { return }

        self.hideRightViewPrepare()
        self.hideRightViewActions(animated: animated, completion: completion)
    }

    open func toggleRightView(animated: Bool = true, completion: Completion? = nil) {
        guard self.rightView != nil,
              self.isRightViewEnabled,
              !self.isRightViewAlwaysVisibleForCurrentOrientation else { return }

        if self.isRightViewShowing || self.state == .rightViewWillHide {
            self.hideRightView(animated: animated, completion: completion)
        }
        else if self.isRightViewHidden || self.state == .rightViewWillShow {
            self.showRightView(animated: animated, completion: completion)
        }
    }

    @IBAction
    open func showRightView(sender: Any?) {
        self.showRightView(animated: false)
    }

    @IBAction
    open func hideRightView(sender: Any?) {
        self.hideRightView(animated: false)
    }

    @IBAction
    open func toggleRightView(sender: Any?) {
        self.toggleRightView(animated: false)
    }

    @IBAction
    open func showRightViewAnimated(sender: Any?) {
        self.showRightView(animated: true)
    }

    @IBAction
    open func hideRightViewAnimated(sender: Any?) {
        self.hideRightView(animated: true)
    }

    @IBAction
    open func toggleRightViewAnimated(sender: Any?) {
        self.toggleRightView(animated: true)
    }

    // MARK: - Show

    internal func showRightViewPrepare(updateStatusBar: Bool) {
        guard self.rightView != nil else { return }
        guard self.isRightViewHidden else {
            if self.state == .rightViewWillHide {
                self.state = .rightViewWillShow
                self.willShowRightViewCallbacks()
            }
            return
        }

        self.state = .rightViewWillShow

        self.rootViewWrapperView?.isUserInteractionEnabled = false
        self.leftViewWrapperView?.isUserInteractionEnabled = false

        if updateStatusBar {
            LGSideMenuHelper.statusBarAppearanceUpdate(viewController: self, duration: self.statusBarAnimationDuration, animations: { [weak self] in
                guard let self = self else { return }
                self.disableRootViewLayouting()
                self.disableRootViewControllerLayouting()
            })
        }

        self.validateRightViewsFrames()
        self.validateRightViewsTransforms(percentage: 0.0)

        self.validateRootViewsFrames()
        self.validateRootViewsTransforms(percentage: 0.0)

        self.validateViewsStyles()
        self.validateViewsVisibility()

        self.willShowRightViewCallbacks()
    }

    internal func showRightViewActions(animated: Bool, duration: TimeInterval? = nil, completion: Completion? = nil) {
        guard self.state == .rightViewWillShow else { return }

        if (animated) {
            self.isAnimating = true

            LGSideMenuHelper.animate(duration: duration ?? self.rightViewAnimationDuration, animations: {
                self.disableRootViewLayouting()
                self.disableRootViewControllerLayouting()

                self.validateRootViewsTransforms(percentage: 1.0)
                self.validateRightViewsTransforms(percentage: 1.0)
                self.validateLeftViewsTransforms(percentage: 1.0)

                self.setNeedsStatusBarAppearanceUpdate()

                self.showAnimationsForRightViewCallbacks()
            },
            completion: { [weak self] (finished: Bool) in
                guard let self = self else { return }

                self.showRightViewDone()
                self.isAnimating = false

                if let completion = completion {
                    completion()
                }
            })
        }
        else {
            self.disableRootViewLayouting()
            self.disableRootViewControllerLayouting()

            self.validateRootViewsTransforms(percentage: 1.0)
            self.validateRightViewsTransforms(percentage: 1.0)
            self.validateLeftViewsTransforms(percentage: 1.0)

            self.setNeedsStatusBarAppearanceUpdate()

            self.showAnimationsForRightViewCallbacks()

            self.showRightViewDone()

            if let completion = completion {
                completion()
            }
        }
    }

    internal func showRightViewDone() {
        guard self.state == .rightViewWillShow else { return }

        self.state = .rightViewIsShowing

        self.validateViewsVisibility()

        self.didShowRightViewCallbacks()
    }

    // MARK: Hide

    internal func hideRightViewPrepare() {
        guard self.rightView != nil else { return }
        guard self.isRightViewShowing else {
            if self.state == .rightViewWillShow {
                self.state = .rightViewWillHide
                self.willHideRightViewCallbacks()
            }
            return
        }

        if self.isRotationInvalidatedLayout {
            self.enableRootViewLayouting()
            self.enableRootViewControllerLayouting()
        }

        self.state = .rightViewWillHide

        self.validateViewsVisibility()

        self.willHideRightViewCallbacks()
    }

    internal func hideRightViewActions(animated: Bool, duration: TimeInterval? = nil, completion: Completion? = nil) {
        guard self.state == .rightViewWillHide else { return }

        if (animated) {
            self.isAnimating = true

            LGSideMenuHelper.animate(duration: duration ?? self.rightViewAnimationDuration, animations: {
                self.enableRootViewLayouting()
                self.enableRootViewControllerLayouting()

                self.validateRootViewsTransforms(percentage: 0.0)
                self.validateRightViewsTransforms(percentage: 0.0)
                self.validateLeftViewsTransforms(percentage: 0.0)

                self.setNeedsStatusBarAppearanceUpdate()

                self.hideAnimationsForRightViewCallbacks()
            },
            completion: { [weak self] (finished: Bool) in
                guard let self = self else { return }

                self.hideRightViewDone(updateStatusBar: false)
                self.isAnimating = false

                if let completion = completion {
                    completion()
                }
            })
        }
        else {
            self.enableRootViewLayouting()
            self.enableRootViewControllerLayouting()

            self.validateRootViewsTransforms(percentage: 0.0)
            self.validateRightViewsTransforms(percentage: 0.0)
            self.validateLeftViewsTransforms(percentage: 0.0)

            self.setNeedsStatusBarAppearanceUpdate()

            self.hideAnimationsForRightViewCallbacks()

            self.hideRightViewDone(updateStatusBar: false)

            if let completion = completion {
                completion()
            }
        }
    }

    internal func hideRightViewDone(updateStatusBar: Bool) {
        guard self.state == .rightViewWillHide else { return }

        if self.isRotationInvalidatedLayout {
            self.isRotationInvalidatedLayout = false
        }

        if updateStatusBar {
            LGSideMenuHelper.statusBarAppearanceUpdate(viewController: self, duration: self.statusBarAnimationDuration, animations: { [weak self] in
                guard let self = self else { return }
                self.enableRootViewLayouting()
                self.enableRootViewControllerLayouting()
            })
        }

        self.state = .rootViewIsShowing

        self.validateViewsVisibility()

        self.rootViewWrapperView?.isUserInteractionEnabled = true
        self.leftViewWrapperView?.isUserInteractionEnabled = true

        self.didHideRightViewCallbacks()
    }

    // MARK: - Cancel Animations

    internal func cancelRightViewAnimations() {
        guard let rightContainerView = self.rightContainerView,
              let rightViewBackgroundImageView = self.rightViewBackgroundImageView,
              let rightViewWrapperView = self.rightViewWrapperView,
              let rightViewCoverView = self.rightViewCoverView else { return }

        rightContainerView.layer.removeAllAnimations()
        rightViewBackgroundImageView.layer.removeAllAnimations()
        rightViewWrapperView.layer.removeAllAnimations()
        rightViewCoverView.layer.removeAllAnimations()
    }

}
