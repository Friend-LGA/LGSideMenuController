//
//  LGSideMenuController+LeftViewActions.swift
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

    open func showLeftView(animated: Bool = true, completion: Completion? = nil) {
        guard self.leftView != nil,
              self.isLeftViewEnabled,
              !self.isLeftViewAlwaysVisibleForCurrentOrientation,
              !self.isLeftViewShowing else { return }

        self.showLeftViewPrepare(updateStatusBar: false)
        self.showLeftViewActions(animated: animated, completion: completion)
    }

    open func hideLeftView(animated: Bool = true, completion: Completion? = nil) {
        guard self.leftView != nil,
              self.isLeftViewEnabled,
              !self.isLeftViewAlwaysVisibleForCurrentOrientation,
              !self.isLeftViewHidden else { return }

        self.hideLeftViewPrepare()
        self.hideLeftViewActions(animated: animated, completion: completion)
    }

    open func toggleLeftView(animated: Bool = true, completion: Completion? = nil) {
        guard self.leftView != nil,
              self.isLeftViewEnabled,
              !self.isLeftViewAlwaysVisibleForCurrentOrientation else { return }

        if self.isLeftViewShowing || self.state == .leftViewWillHide {
            self.hideLeftView(animated: animated, completion: completion)
        }
        else if self.isLeftViewHidden || self.state == .leftViewWillShow {
            self.showLeftView(animated: animated, completion: completion)
        }
    }

    @IBAction
    open func showLeftView(sender: Any?) {
        self.showLeftView(animated: false)
    }

    @IBAction
    open func hideLeftView(sender: Any?) {
        self.hideLeftView(animated: false)
    }

    @IBAction
    open func toggleLeftView(sender: Any?) {
        self.toggleLeftView(animated: false)
    }

    @IBAction
    open func showLeftViewAnimated(sender: Any?) {
        self.showLeftView(animated: true)
    }

    @IBAction
    open func hideLeftViewAnimated(sender: Any?) {
        self.hideLeftView(animated: true)
    }

    @IBAction
    open func toggleLeftViewAnimated(sender: Any?) {
        self.toggleLeftView(animated: true)
    }

    // MARK: - Show

    internal func showLeftViewPrepare(updateStatusBar: Bool) {
        guard self.leftView != nil else { return }
        guard self.isLeftViewHidden else {
            if self.state == .leftViewWillHide {
                self.state = .leftViewWillShow
                self.willShowLeftViewCallbacks()
            }
            return
        }

        self.state = .leftViewWillShow

        self.rootViewWrapperView?.isUserInteractionEnabled = false
        self.rightViewWrapperView?.isUserInteractionEnabled = false

        if updateStatusBar {
            LGSideMenuHelper.statusBarAppearanceUpdate(viewController: self, duration: self.statusBarAnimationDuration, animations: { [weak self] in
                guard let self = self else { return }
                self.disableRootViewLayouting()
                self.disableRootViewControllerLayouting()
            })
        }

        self.validateLeftViewsFrames()
        self.validateLeftViewsTransforms(percentage: 0.0)

        self.validateRootViewsFrames()
        self.validateRootViewsTransforms(percentage: 0.0)

        self.validateViewsStyles()
        self.validateViewsVisibility()

        self.willShowLeftViewCallbacks()
    }

    internal func showLeftViewActions(animated: Bool, duration: TimeInterval? = nil, completion: Completion? = nil) {
        guard self.state == .leftViewWillShow else { return }

        if (animated) {
            self.isAnimating = true

            LGSideMenuHelper.animate(duration: duration ?? self.leftViewAnimationDuration, animations: {
                self.disableRootViewLayouting()
                self.disableRootViewControllerLayouting()

                self.validateRootViewsTransforms(percentage: 1.0)
                self.validateLeftViewsTransforms(percentage: 1.0)
                self.validateRightViewsTransforms(percentage: 1.0)

                self.setNeedsStatusBarAppearanceUpdate()

                self.showAnimationsForLeftViewCallbacks()
            },
            completion: { [weak self] (finished: Bool) in
                guard let self = self else { return }

                self.showLeftViewDone()
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
            self.validateLeftViewsTransforms(percentage: 1.0)
            self.validateRightViewsTransforms(percentage: 1.0)

            self.setNeedsStatusBarAppearanceUpdate()

            self.showAnimationsForLeftViewCallbacks()

            self.showLeftViewDone()

            if let completion = completion {
                completion()
            }
        }
    }

    internal func showLeftViewDone() {
        guard self.state == .leftViewWillShow else { return }

        self.state = .leftViewIsShowing

        self.validateViewsVisibility()

        self.didShowLeftViewCallbacks()
    }

    // MARK: Hide

    internal func hideLeftViewPrepare() {
        guard self.leftView != nil else { return }
        guard self.isLeftViewShowing else {
            if self.state == .leftViewWillShow {
                self.state = .leftViewWillHide
                self.willHideLeftViewCallbacks()
            }
            return
        }

        if self.isRotationInvalidatedLayout {
            self.enableRootViewLayouting()
            self.enableRootViewControllerLayouting()
        }

        self.state = .leftViewWillHide

        self.validateViewsVisibility()

        self.willHideLeftViewCallbacks()
    }

    internal func hideLeftViewActions(animated: Bool, duration: TimeInterval? = nil, completion: Completion? = nil) {
        guard self.state == .leftViewWillHide else { return }

        if (animated) {
            self.isAnimating = true

            LGSideMenuHelper.animate(duration: duration ?? self.leftViewAnimationDuration, animations: {
                self.enableRootViewLayouting()
                self.enableRootViewControllerLayouting()

                self.validateRootViewsTransforms(percentage: 0.0)
                self.validateLeftViewsTransforms(percentage: 0.0)
                self.validateRightViewsTransforms(percentage: 0.0)

                self.setNeedsStatusBarAppearanceUpdate()

                self.hideAnimationsForLeftViewCallbacks()
            },
            completion: { [weak self] (finished: Bool) in
                guard let self = self else { return }

                self.hideLeftViewDone(updateStatusBar: false)
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
            self.validateLeftViewsTransforms(percentage: 0.0)
            self.validateRightViewsTransforms(percentage: 0.0)

            self.setNeedsStatusBarAppearanceUpdate()

            self.hideAnimationsForLeftViewCallbacks()

            self.hideLeftViewDone(updateStatusBar: false)

            if let completion = completion {
                completion()
            }
        }
    }

    internal func hideLeftViewDone(updateStatusBar: Bool) {
        guard self.state == .leftViewWillHide else { return }

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
        self.rightViewWrapperView?.isUserInteractionEnabled = true

        self.didHideLeftViewCallbacks()
    }

    // MARK: - Cancel Animations

    internal func cancelLeftViewAnimations() {
        guard let leftContainerView = self.leftContainerView,
              let leftViewBackgroundImageView = self.leftViewBackgroundImageView,
              let leftViewWrapperView = self.leftViewWrapperView,
              let leftViewCoverView = self.leftViewCoverView else { return }

        leftContainerView.layer.removeAllAnimations()
        leftViewBackgroundImageView.layer.removeAllAnimations()
        leftViewWrapperView.layer.removeAllAnimations()
        leftViewCoverView.layer.removeAllAnimations()
    }

}
