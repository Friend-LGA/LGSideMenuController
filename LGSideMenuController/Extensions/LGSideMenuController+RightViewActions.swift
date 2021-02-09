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

public extension LGSideMenuController {

    func showRightView(animated: Bool = true, completion: Completion? = nil) {
        guard self.rightView != nil,
              self.isRightViewEnabled,
              !self.isRightViewAlwaysVisibleForCurrentOrientation,
              !self.isRightViewShowing else { return }
    }

    func hideRightView(animated: Bool = true, completion: Completion? = nil) {
        guard self.rightView != nil,
              self.isRightViewEnabled,
              !self.isRightViewAlwaysVisibleForCurrentOrientation,
              !self.isRightViewHidden else { return }
    }

    func toggleRightView(animated: Bool = true, completion: Completion? = nil) {
        guard self.rightView != nil,
              self.isRightViewEnabled,
              !self.isRightViewAlwaysVisibleForCurrentOrientation else { return }

        if self.isRightViewShowing || self.state == .rightViewWillHide {
            self.hideRightView()
        }
        else if self.isRightViewHidden || self.state == .rightViewWillShow {
            self.showRightView()
        }
    }

    @IBAction
    func showRightView(sender: Any?) {
        self.showRightView(animated: false)
    }

    @IBAction
    func hideRightView(sender: Any?) {
        self.hideRightView(animated: false)
    }

    @IBAction
    func toggleRightView(sender: Any?) {
        self.toggleRightView(animated: false)
    }

    @IBAction
    func showRightViewAnimated(sender: Any?) {
        self.showRightView(animated: true)
    }

    @IBAction
    func hideRightViewAnimated(sender: Any?) {
        self.hideRightView(animated: true)
    }

    @IBAction
    func toggleRightViewAnimated(sender: Any?) {
        self.toggleRightView(animated: true)
    }

    // MARK: - Show

    private func showRightViewPrepare(withGesture: Bool) {
        guard self.rightView != nil && self.isRightViewHidden else { return }

        var shouldUpdateFrames = false
        if (self.isRightViewHidden) {
            shouldUpdateFrames = true
        }

        self.state = .rightViewWillShow

        if let rootViewController = self.rootViewController {
            rootViewController.removeFromParent()
        }

        LGSideMenuHelper.statusBarAppearanceUpdate(animated: true,
                                             viewController: self,
                                                   duration: self.rightViewAnimationDuration,
                                                  animation: self.rightViewStatusBarUpdateAnimation)

        if let rightViewController = self.rightViewController {
            self.addChild(rightViewController)
        }

        if (shouldUpdateFrames) {
            self.rightViewsFramesValidate()
            self.rightViewsTransformsValidate(percentage: 0.0)
        }

        self.rootViewsStylesValidate()
        self.rightViewsStylesValidate()
        self.rootViewsVisibilityValidate()
        self.rightViewsVisibilityValidate()
    }

    private func showRightViewActions(animated: Bool, completion: Completion? = nil) {
        guard self.state == .rightViewWillShow else { return }

        if (animated) {
            self.gesturesHandler.isAnimating = true

            LGSideMenuHelper.animate(duration: self.rightViewAnimationDuration, animations: {
                self.rootViewsTransformsValidate(percentage: 1.0)
                self.rightViewsTransformsValidate(percentage: 1.0)

                NotificationCenter.default.post(name: Notification.showAnimationsForRightView,
                                                object: self,
                                                userInfo: [Notification.Key.duration: self.rightViewAnimationDuration])

                if let showAnimationsForRightView = self.showAnimationsForRightView {
                    showAnimationsForRightView(self, self.rightViewAnimationDuration)
                }

                if let delegate = self.delegate {
                    delegate.showAnimationsForRightView(sideMenuController: self, duration: self.rightViewAnimationDuration)
                }
            },
            completion: { [weak self] (finished: Bool) in
                guard let self = self else { return }

                self.showRightViewDone()
                self.gesturesHandler.isAnimating = false

                if let completion = completion {
                    completion()
                }
            })
        }
        else {
            self.showRightViewDone()

            if let completion = completion {
                completion()
            }
        }
    }

    private func showRightViewDone() {
        guard self.state == .rightViewWillShow else { return }

        self.rightViewGestireStartX = nil
        self.state = .rightViewIsShowing
        self.didShowRightViewCallbacks()
    }

    // MARK: - Hide

}
