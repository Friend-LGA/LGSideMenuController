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

    /// Shows left side view
    open func showLeftView(animated: Bool = true, completion: Completion? = nil) {
        guard self.leftView != nil,
              self.isLeftViewEnabled,
              !self.isLeftViewAlwaysVisible,
              !self.isLeftViewShowing,
              self.isRightViewVisibilityStable else { return }

        if self.isRightViewShowing {
            self.hideRightView(animated: animated, completion: { [weak self] in
                guard let self = self else { return }
                self.showLeftViewPrepare(updateStatusBar: false)
                self.showLeftViewActions(animated: animated, completion: completion)
            })
        }
        else {
            self.showLeftViewPrepare(updateStatusBar: false)
            self.showLeftViewActions(animated: animated, completion: completion)
        }
    }

    /// Hides left side view
    open func hideLeftView(animated: Bool = true, completion: Completion? = nil) {
        guard self.leftView != nil,
              self.isLeftViewEnabled,
              !self.isLeftViewAlwaysVisible,
              !self.isLeftViewHidden,
              self.isRightViewVisibilityStable else { return }

        self.hideLeftViewPrepare()
        self.hideLeftViewActions(animated: animated, completion: completion)
    }

    /// Toggle (shows/hides) left side view
    open func toggleLeftView(animated: Bool = true, completion: Completion? = nil) {
        guard self.leftView != nil,
              self.isLeftViewEnabled,
              !self.isLeftViewAlwaysVisible,
              self.isRightViewVisibilityStable else { return }

        if self.isLeftViewShowing {
            self.hideLeftView(animated: animated, completion: completion)
        }
        else if self.isLeftViewHidden {
            self.showLeftView(animated: animated, completion: completion)
        }
    }

    /// Shows left side view without animation
    @IBAction
    open func showLeftView(sender: Any?) {
        self.showLeftView(animated: false)
    }

    /// Hides left side view without animation
    @IBAction
    open func hideLeftView(sender: Any?) {
        self.hideLeftView(animated: false)
    }

    /// Toggle (shows/hides) left side view without animation
    @IBAction
    open func toggleLeftView(sender: Any?) {
        self.toggleLeftView(animated: false)
    }

    /// Shows left side view with animation
    @IBAction
    open func showLeftViewAnimated(sender: Any?) {
        self.showLeftView(animated: true)
    }

    /// Hides left side view with animation
    @IBAction
    open func hideLeftViewAnimated(sender: Any?) {
        self.hideLeftView(animated: true)
    }

    /// Toggle (shows/hides) left side view with animation
    @IBAction
    open func toggleLeftViewAnimated(sender: Any?) {
        self.toggleLeftView(animated: true)
    }

    // MARK: - Show -

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

        if updateStatusBar {
            LGSideMenuHelper.statusBarAppearanceUpdate(viewController: self, duration: self.statusBarAnimationDuration, animations: { [weak self] in
                guard let self = self else { return }
                self.disableRootViewLayouting()
                self.disableRootViewControllerLayouting()
            })
        }

        self.validateViewsUserInteraction()

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

            let duration = duration ?? self.leftViewAnimationDuration

            LGSideMenuHelper.animate(duration: duration, timingFunction: self.leftViewAnimationTimingFunction, animations: {
                self.disableRootViewLayouting()
                self.disableRootViewControllerLayouting()

                self.validateRootViewsTransforms(percentage: 1.0)
                self.validateLeftViewsTransforms(percentage: 1.0)
                self.validateRightViewsTransforms(percentage: 1.0)

                self.setNeedsStatusBarAppearanceUpdate()
                self.validateLeftViewStatusBarBackgroundFrames()
                self.validateRightViewStatusBarBackgroundFrames()

                self.showAnimationsForLeftViewCallbacks(duration: duration,
                                                        timingFunction: self.leftViewAnimationTimingFunction)
            },
            completion: { [weak self] in
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
            self.validateLeftViewStatusBarBackgroundFrames()
            self.validateRightViewStatusBarBackgroundFrames()

            self.showAnimationsForLeftViewCallbacks(duration: 0.0,
                                                    timingFunction: self.leftViewAnimationTimingFunction)

            self.showLeftViewDone()

            if let completion = completion {
                completion()
            }
        }
    }

    internal func showLeftViewDone() {
        guard self.state == .leftViewWillShow else { return }

        self.state = .leftViewIsShowing

        self.validateViewsUserInteraction()
        self.validateViewsVisibility()

        self.didShowLeftViewCallbacks()
    }

    // MARK: - Hide -

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

        self.validateViewsUserInteraction()
        self.validateViewsVisibility()

        self.willHideLeftViewCallbacks()
    }

    internal func hideLeftViewActions(animated: Bool, duration: TimeInterval? = nil, completion: Completion? = nil) {
        guard self.state == .leftViewWillHide else { return }

        if (animated) {
            self.isAnimating = true

            let duration = duration ?? self.leftViewAnimationDuration

            LGSideMenuHelper.animate(duration: duration, timingFunction: self.leftViewAnimationTimingFunction, animations: {
                self.enableRootViewLayouting()
                self.enableRootViewControllerLayouting()

                self.validateRootViewsTransforms(percentage: 0.0)
                self.validateLeftViewsTransforms(percentage: 0.0)
                self.validateRightViewsTransforms(percentage: 0.0)

                self.setNeedsStatusBarAppearanceUpdate()

                self.hideAnimationsForLeftViewCallbacks(duration: duration,
                                                        timingFunction: self.leftViewAnimationTimingFunction)
            },
            completion: { [weak self] in
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

            self.hideAnimationsForLeftViewCallbacks(duration: 0.0,
                                                    timingFunction: self.leftViewAnimationTimingFunction)

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

        self.validateViewsUserInteraction()
        self.validateViewsVisibility()

        self.didHideLeftViewCallbacks()
    }

}
