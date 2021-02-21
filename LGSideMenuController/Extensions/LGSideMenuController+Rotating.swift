//
//  LGSideMenuController+Rotating.swift
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

    open override var shouldAutorotate: Bool {
        if let rootViewController = self.rootViewController {
            return rootViewController.shouldAutorotate
        }
        return super.shouldAutorotate
    }

    open override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        super.willTransition(to: newCollection, with: coordinator)

        if !self.isRootViewShowing {
            self.isRotationInvalidatedLayout = true
        }
    }

    open override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)

        self.cancelLeftViewAnimations()
        self.cancelRightViewAnimations()

        if (self.leftView != nil && self.isLeftViewAlwaysVisibleForCurrentOrientation) ||
            (self.rightView != nil && self.isRightViewAlwaysVisibleForCurrentOrientation) {
            self.shouldUpdateVisibility = false
        }

        if self.state == .leftViewWillShow {
            if self.isLeftViewAlwaysVisibleForCurrentOrientation {
                self.showLeftViewDone()
            }
        }
        else if self.state == .leftViewWillHide {
            self.hideLeftViewDone(updateStatusBar: true)
        }

        if self.state == .rightViewWillShow {
            if self.isRightViewAlwaysVisibleForCurrentOrientation {
                self.showRightViewDone()
            }
        }
        else if self.state == .rightViewWillHide {
            self.hideRightViewDone(updateStatusBar: true)
        }

        coordinator.animate(alongsideTransition: { [weak self] (context: UIViewControllerTransitionCoordinatorContext) in
            guard let self = self else { return }

            if self.isLeftViewAlwaysVisibleForCurrentOrientation && !self.isLeftViewHidden {
                self.hideLeftViewPrepare()
                self.hideLeftViewActions(animated: true, duration: context.transitionDuration)
            }

            if self.isRightViewAlwaysVisibleForCurrentOrientation && !self.isRightViewHidden {
                self.hideRightViewPrepare()
                self.hideRightViewActions(animated: true, duration: context.transitionDuration)
            }
        }, completion: { [weak self] (context: UIViewControllerTransitionCoordinatorContext) in
            guard let self = self else { return }

            if !self.shouldUpdateVisibility {
                self.shouldUpdateVisibility = true
                self.validateLeftViewsVisibility()
                self.validateRightViewsVisibility()
            }
        })
    }

}
