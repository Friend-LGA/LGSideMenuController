//
//  LGSideMenuController+GesturesHandler.swift
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

internal extension LGSideMenuController {

    @objc
    func handleTapGesture(gesture: UITapGestureRecognizer) {
        guard self.rootView != nil && gesture.state == .ended else { return }

        if self.isLeftViewShowing {
            self.hideLeftView(animated: self.shouldHideLeftViewAnimated)
        }
        else if self.isRightViewShowing {
            self.hideRightView(animated: self.shouldHideRightViewAnimated)
        }
    }

    @objc
    func handlePanGesture(gesture: UIPanGestureRecognizer) {
        guard self.rootView != nil,
              gesture.state == .changed || gesture.state == .ended || gesture.state == .cancelled else { return }

        let location = gesture.location(in: self.view)
        let velocity = gesture.velocity(in: self.view)

        self.handlePanGestureForLeftView(gesture: gesture, location: location, velocity: velocity)
        self.handlePanGestureForRightView(gesture: gesture, location: location, velocity: velocity)
    }


    private func handlePanGestureForLeftView(gesture: UIPanGestureRecognizer, location: CGPoint, velocity: CGPoint) {
        guard self.leftView != nil,
              self.isLeftViewEnabled,
              self.isLeftViewSwipeGestureEnabled,
              !self.isLeftViewAlwaysVisibleForCurrentOrientation,
              self.isRightViewHidden,
              let rootContainerView = self.rootContainerView else { return }

        guard self.swipeGestureArea == .full ||
                (self.swipeGestureArea == .borders &&
                    location.x >= rootContainerView.frame.minX - self.leftViewSwipeGestureRange.left &&
                    location.x <= rootContainerView.frame.minX + self.leftViewSwipeGestureRange.right) else { return }

        if self.isLeftViewVisibilityStable {
            if self.isLeftViewShowing ? velocity.x < 0.0 : velocity.x > 0.0 {
                self.leftViewGestureStartX = location.x

                if self.isLeftViewShowing {
                    self.hideLeftViewPrepare()
                }
                else {
                    self.showLeftViewPrepare(withGesture: true)
                }
            }
        }
        else if self.isLeftViewVisibilityChanging, let leftViewGestureStartX = self.leftViewGestureStartX {
            let shiftedAmount = abs(location.x - leftViewGestureStartX)
            var percentage = shiftedAmount / self.leftViewWidth

            if percentage < 0.0 {
                percentage = 0.0
            }
            else if percentage > 1.0 {
                percentage = 1.0
            }

            if gesture.state == .changed {
                self.rootViewsTransformsValidate(percentage: percentage)
                self.leftViewsTransformsValidate(percentage: percentage)

                if percentage == 1.0 {
                    self.showLeftViewDone()
                }
                else if percentage == 0.0 {
                    self.hideLeftViewDone(withGesture: true)
                }
                else if velocity.x > 0.0 {
                    self.showLeftViewPrepare(withGesture: true)
                }
                else if velocity.x < 0.0 {
                    self.hideLeftViewPrepare()
                }
            }
            else if gesture.state == .ended || gesture.state == .cancelled {
                if (percentage < 1.0 && velocity.x > 0.0) || (velocity.x == 0.0 && percentage >= 0.5) {
                    self.showLeftViewActions(animated: true)
                }
                else if (percentage > 0.0 && velocity.x < 0.0) || (velocity.x == 0.0 && percentage < 0.5) {
                    self.hideLeftViewActions(animated: true)
                }

                self.leftViewGestureStartX = nil
            }
        }
    }

    private func handlePanGestureForRightView(gesture: UIPanGestureRecognizer, location: CGPoint, velocity: CGPoint) {
        guard self.rightView != nil,
              self.isRightViewEnabled,
              self.isRightViewSwipeGestureEnabled,
              !self.isRightViewAlwaysVisibleForCurrentOrientation,
              self.isLeftViewHidden,
              let rootContainerView = self.rootContainerView else { return }

        guard self.swipeGestureArea == .full ||
                (self.swipeGestureArea == .borders &&
                    location.x >= rootContainerView.frame.maxX - self.rightViewSwipeGestureRange.left &&
                    location.x <= rootContainerView.frame.maxX + self.rightViewSwipeGestureRange.right) else { return }

        if self.isRightViewVisibilityStable {
            if self.isRightViewShowing ? velocity.x > 0.0 : velocity.x < 0.0 {
                self.rightViewGestureStartX = location.x

                if self.isRightViewShowing {
                    self.hideRightViewPrepare()
                }
                else {
                    self.showRightViewPrepare(withGesture: true)
                }
            }
        }
        else if self.isRightViewVisibilityChanging, let rightViewGestureStartX = self.rightViewGestureStartX {
            let shiftedAmount = abs(location.x - rightViewGestureStartX)
            var percentage = shiftedAmount / self.rightViewWidth

            if percentage < 0.0 {
                percentage = 0.0
            }
            else if percentage > 1.0 {
                percentage = 1.0
            }

            if gesture.state == .changed {
                self.rootViewsTransformsValidate(percentage: percentage)
                self.rightViewsTransformsValidate(percentage: percentage)

                if percentage == 1.0 {
                    self.showRightViewDone()
                }
                else if percentage == 0.0 {
                    self.hideRightViewDone(withGesture: true)
                }
                else if velocity.x > 0.0 {
                    self.showRightViewPrepare(withGesture: true)
                }
                else if velocity.x < 0.0 {
                    self.hideRightViewPrepare()
                }
            }
            else if gesture.state == .ended || gesture.state == .cancelled {
                if (percentage < 1.0 && velocity.x > 0.0) || (velocity.x == 0.0 && percentage >= 0.5) {
                    self.showRightViewActions(animated: true)
                }
                else if (percentage > 0.0 && velocity.x < 0.0) || (velocity.x == 0.0 && percentage < 0.5) {
                    self.hideRightViewActions(animated: true)
                }

                self.rightViewGestureStartX = nil
            }
        }
    }

}
