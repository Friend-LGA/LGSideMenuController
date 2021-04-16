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

    /// Shows right side view
    open func showRightView(animated: Bool = true, completion: Completion? = nil) {
        guard self.rightView != nil,
              self.isRightViewEnabled,
              !self.isRightViewAlwaysVisible,
              !self.isRightViewShowing,
              self.isLeftViewVisibilityStable else { return }

        if self.isLeftViewShowing {
            self.hideLeftView(animated: animated, completion: { [weak self] in
                guard let self = self else { return }
                self.showRightViewPrepare(updateStatusBar: false)
                self.showRightViewActions(animated: animated, completion: completion)
            })
        }
        else {
            self.showRightViewPrepare(updateStatusBar: false)
            self.showRightViewActions(animated: animated, completion: completion)
        }
    }

    /// Hides right side view
    open func hideRightView(animated: Bool = true, completion: Completion? = nil) {
        guard self.rightView != nil,
              self.isRightViewEnabled,
              !self.isRightViewAlwaysVisible,
              !self.isRightViewHidden,
              self.isLeftViewVisibilityStable else { return }

        self.hideRightViewPrepare()
        self.hideRightViewActions(animated: animated, completion: completion)
    }

    /// Toggle (shows/hides) right side view
    open func toggleRightView(animated: Bool = true, completion: Completion? = nil) {
        guard self.rightView != nil,
              self.isRightViewEnabled,
              !self.isRightViewAlwaysVisible,
              self.isLeftViewVisibilityStable else { return }

        if self.isRightViewShowing {
            self.hideRightView(animated: animated, completion: completion)
        }
        else if self.isRightViewHidden {
            self.showRightView(animated: animated, completion: completion)
        }
    }

    /// Shows right side view without animation
    @IBAction
    open func showRightView(sender: Any?) {
        self.showRightView(animated: false)
    }

    /// Hides right side view without animation
    @IBAction
    open func hideRightView(sender: Any?) {
        self.hideRightView(animated: false)
    }

    /// Toggle (shows/hides) right side view without animation
    @IBAction
    open func toggleRightView(sender: Any?) {
        self.toggleRightView(animated: false)
    }

    /// Shows right side view with animation
    @IBAction
    open func showRightViewAnimated(sender: Any?) {
        self.showRightView(animated: true)
    }

    /// Hides right side view with animation
    @IBAction
    open func hideRightViewAnimated(sender: Any?) {
        self.hideRightView(animated: true)
    }

    /// Toggle (shows/hides) right side view with animation
    @IBAction
    open func toggleRightViewAnimated(sender: Any?) {
        self.toggleRightView(animated: true)
    }

    // MARK: - Show -

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

        if updateStatusBar {
            LGSideMenuHelper.statusBarAppearanceUpdate(viewController: self, duration: self.statusBarAnimationDuration, animations: { [weak self] in
                guard let self = self else { return }
                self.disableRootViewLayouting()
                self.disableRootViewControllerLayouting()
            })
        }

        self.validateViewsUserInteraction()

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

            let duration = duration ?? self.rightViewAnimationDuration

            LGSideMenuHelper.animate(duration: duration, timingFunction: self.rightViewAnimationTimingFunction, animations: {
                self.disableRootViewLayouting()
                self.disableRootViewControllerLayouting()

                self.validateRootViewsTransforms(percentage: 1.0)
                self.validateRightViewsTransforms(percentage: 1.0)
                self.validateLeftViewsTransforms(percentage: 1.0)

                self.setNeedsStatusBarAppearanceUpdate()
                self.validateRightViewStatusBarBackgroundFrames()
                self.validateLeftViewStatusBarBackgroundFrames()

                self.showAnimationsForRightViewCallbacks(duration: duration,
                                                         timingFunction: self.rightViewAnimationTimingFunction)
            },
            completion: { [weak self] in
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
            self.validateRightViewStatusBarBackgroundFrames()
            self.validateLeftViewStatusBarBackgroundFrames()

            self.showAnimationsForRightViewCallbacks(duration: 0.0,
                                                     timingFunction: self.rightViewAnimationTimingFunction)

            self.showRightViewDone()

            if let completion = completion {
                completion()
            }
        }
    }

    internal func showRightViewDone() {
        guard self.state == .rightViewWillShow else { return }

        self.state = .rightViewIsShowing

        self.validateViewsUserInteraction()
        self.validateViewsVisibility()

        self.didShowRightViewCallbacks()
    }

    // MARK: - Hide -

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

        self.validateViewsUserInteraction()
        self.validateViewsVisibility()

        self.willHideRightViewCallbacks()
    }

    internal func hideRightViewActions(animated: Bool, duration: TimeInterval? = nil, completion: Completion? = nil) {
        guard self.state == .rightViewWillHide else { return }

        if (animated) {
            self.isAnimating = true

            let duration = duration ?? self.rightViewAnimationDuration

            LGSideMenuHelper.animate(duration: duration, timingFunction: self.rightViewAnimationTimingFunction, animations: {
                self.enableRootViewLayouting()
                self.enableRootViewControllerLayouting()

                self.validateRootViewsTransforms(percentage: 0.0)
                self.validateRightViewsTransforms(percentage: 0.0)
                self.validateLeftViewsTransforms(percentage: 0.0)

                self.setNeedsStatusBarAppearanceUpdate()

                self.hideAnimationsForRightViewCallbacks(duration: duration,
                                                         timingFunction: self.rightViewAnimationTimingFunction)
            },
            completion: { [weak self] in
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

            self.hideAnimationsForRightViewCallbacks(duration: 0.0,
                                                     timingFunction: self.rightViewAnimationTimingFunction)

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

        self.validateViewsUserInteraction()
        self.validateViewsVisibility()

        self.didHideRightViewCallbacks()
    }

}
