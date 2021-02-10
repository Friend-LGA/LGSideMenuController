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

public extension LGSideMenuController {

    func showLeftView(animated: Bool = true, completion: Completion? = nil) {
        guard self.leftView != nil,
              self.isLeftViewEnabled,
              !self.isLeftViewAlwaysVisibleForCurrentOrientation,
              !self.isLeftViewShowing else { return }
    }

    func hideLeftView(animated: Bool = true, completion: Completion? = nil) {
        guard self.leftView != nil,
              self.isLeftViewEnabled,
              !self.isLeftViewAlwaysVisibleForCurrentOrientation,
              !self.isLeftViewHidden else { return }
    }

    func toggleLeftView(animated: Bool = true, completion: Completion? = nil) {
        guard self.leftView != nil,
              self.isLeftViewEnabled,
              !self.isLeftViewAlwaysVisibleForCurrentOrientation else { return }

        if self.isLeftViewShowing || self.state == .leftViewWillHide {
            self.hideLeftView()
        }
        else if self.isLeftViewHidden || self.state == .leftViewWillShow {
            self.showLeftView()
        }
    }

    @IBAction
    func showLeftView(sender: Any?) {
        self.showLeftView(animated: false)
    }

    @IBAction
    func hideLeftView(sender: Any?) {
        self.hideLeftView(animated: false)
    }

    @IBAction
    func toggleLeftView(sender: Any?) {
        self.toggleLeftView(animated: false)
    }

    @IBAction
    func showLeftViewAnimated(sender: Any?) {
        self.showLeftView(animated: true)
    }

    @IBAction
    func hideLeftViewAnimated(sender: Any?) {
        self.hideLeftView(animated: true)
    }

    @IBAction
    func toggleLeftViewAnimated(sender: Any?) {
        self.toggleLeftView(animated: true)
    }

    // MARK: - Show

    internal func showLeftViewPrepare(withGesture: Bool) {
        guard self.leftView != nil else { return }
        guard self.isLeftViewHidden else {
            if self.state == .leftViewWillHide {
                self.state = .leftViewWillShow
                self.willShowLeftViewCallbacks()
            }
            return
        }

        self.state = .leftViewWillShow
        self.willShowLeftViewCallbacks()

        if let rootViewController = self.rootViewController {
            rootViewController.removeFromParent()
        }

        LGSideMenuHelper.statusBarAppearanceUpdate(viewController: self, duration: self.leftViewAnimationDuration)

        if let leftViewController = self.leftViewController {
            self.addChild(leftViewController)
        }

        self.leftViewsFramesValidate()
        self.leftViewsTransformsValidate(percentage: 0.0)

        self.rootViewsStylesValidate()
        self.leftViewsStylesValidate()
        self.rootViewsVisibilityValidate()
        self.leftViewsVisibilityValidate()
    }

    internal func showLeftViewActions(animated: Bool, completion: Completion? = nil) {
        guard self.state == .leftViewWillShow else { return }

        if (animated) {
            self.gesturesHandler.isAnimating = true

            LGSideMenuHelper.animate(duration: self.leftViewAnimationDuration, animations: {
                self.rootViewsTransformsValidate(percentage: 1.0)
                self.leftViewsTransformsValidate(percentage: 1.0)
                self.showAnimationsForLeftViewCallbacks()
            },
            completion: { [weak self] (finished: Bool) in
                guard let self = self else { return }

                self.showLeftViewDone()
                self.gesturesHandler.isAnimating = false

                if let completion = completion {
                    completion()
                }
            })
        }
        else {
            self.showLeftViewDone()

            if let completion = completion {
                completion()
            }
        }
    }

    internal func showLeftViewDone() {
        guard self.state == .leftViewWillShow else { return }

        self.state = .leftViewIsShowing
        self.didShowLeftViewCallbacks()
    }

    // MARK: Hide

    internal func hideLeftViewPrepare() {
        guard self.leftView != nil else { return }
        guard self.isLeftViewShowing || self.state == .leftViewWillShow else { return }

        self.state = .leftViewWillHide
        self.willHideLeftViewCallbacks()
    }

    internal func hideLeftViewActions(animated: Bool, completion: Completion? = nil) {
        guard self.state == .leftViewWillHide else { return }

        if let leftViewController = self.leftViewController {
            leftViewController.removeFromParent()
        }

        LGSideMenuHelper.statusBarAppearanceUpdate(viewController: self, duration: self.leftViewAnimationDuration)

        if let rootViewController = self.rootViewController {
            self.addChild(rootViewController)
        }

        if (animated) {
            self.gesturesHandler.isAnimating = true

            LGSideMenuHelper.animate(duration: self.leftViewAnimationDuration, animations: {
                self.rootViewsTransformsValidate(percentage: 0.0)
                self.leftViewsTransformsValidate(percentage: 0.0)
                self.hideAnimationsForLeftViewCallbacks()
            },
            completion: { [weak self] (finished: Bool) in
                guard let self = self else { return }

                self.hideLeftViewDone(withGesture: false)
                self.gesturesHandler.isAnimating = false

                if let completion = completion {
                    completion();
                }
            })
        }
        else {
            self.hideLeftViewDone(withGesture: false)

            if let completion = completion {
                completion();
            }
        }
    }

    internal func hideLeftViewDone(withGesture: Bool) {
        guard self.state == .leftViewWillHide else { return }

        if withGesture {
            if let leftViewController = self.leftViewController {
                leftViewController.removeFromParent()
            }

            LGSideMenuHelper.statusBarAppearanceUpdate(viewController: self, duration: self.leftViewAnimationDuration)

            if let rootViewController = self.rootViewController {
                self.addChild(rootViewController)
            }
        }

        self.state = .rootViewIsShowing;
        self.didHideLeftViewCallbacks()

        self.rootViewsVisibilityValidate()
        self.leftViewsVisibilityValidate()
    }

}
