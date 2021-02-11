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

public extension LGSideMenuController {

    @objc
    func handleTapGesture(gesture: UITapGestureRecognizer) {
        guard self.rootView != nil && gesture.state == .ended else { return }

        if self.isLeftViewShowing && self.isLeftViewHidesOnTouch {
            self.hideLeftView(animated: self.shouldHideLeftViewAnimated)
        }
        else if self.isRightViewShowing && self.isRightViewHidesOnTouch {
            self.hideRightView(animated: self.shouldHideRightViewAnimated)
        }
    }

    @objc
    func handlePanGesture(gesture: UIPanGestureRecognizer) {
        guard self.rootView != nil else { return }

        let location = gesture.location(in: self.view)
        let velocity = gesture.velocity(in: self.view)

        self.handlePanGestureForLeftView(gesture: gesture, location: location, velocity: velocity)
        self.handlePanGestureForRightView(gesture: gesture, location: location, velocity: velocity)
    }

    // MARK: - Left View

    private func handlePanGestureForLeftView(gesture: UIPanGestureRecognizer, location: CGPoint, velocity: CGPoint) {
        guard self.leftView != nil,
              self.isLeftViewEnabled,
              self.isLeftViewSwipeGestureEnabled,
              !self.isLeftViewAlwaysVisibleForCurrentOrientation,
              self.isRightViewHidden else { return }

        if gesture.state == .began || gesture.state == .changed,
           self.swipeGestureArea == .borders && self.isLeftViewVisibilityStable && !self.isLocationInLeftSwipeableRect(location) {
            return
        }
        if gesture.state == .ended || gesture.state == .cancelled,
           self.isLeftViewVisibilityStable {
            return
        }

        if self.isLeftViewVisibilityStable {
            if self.isLeftViewShowing ? velocity.x < 0.0 : velocity.x > 0.0 {
                self.leftViewGestureStartX = location.x
                self.isLeftViewShowingBeforeGesture = self.isLeftViewShowing

                if self.isLeftViewShowing {
                    self.hideLeftViewPrepare()
                }
                else {
                    self.showLeftViewPrepare(withGesture: true)
                }
            }
        }
        else if self.isLeftViewVisibilityChanging, let leftViewGestureStartX = self.leftViewGestureStartX {
            let shiftedAmount = self.isLeftViewShowingBeforeGesture ? leftViewGestureStartX - location.x : location.x - leftViewGestureStartX
            let percentage =  self.calculatePercentage(shiftedAmount: shiftedAmount,
                                                       viewWidth: self.leftViewWidth,
                                                       isViewShowingBeforeGesture: self.isLeftViewShowingBeforeGesture)

            if gesture.state == .changed {
                if velocity.x > 0.0 {
                    self.showLeftViewPrepare(withGesture: true)
                }
                else if velocity.x < 0.0 {
                    self.hideLeftViewPrepare()
                }

                self.rootViewsTransformsValidate(percentage: percentage)
                self.leftViewsTransformsValidate(percentage: percentage)
            }
            else if gesture.state == .ended || gesture.state == .cancelled {
                if percentage == 1.0 {
                    // We can start showing the view and ended the gesture without moving the view even by 1%
                    self.showLeftViewPrepare(withGesture: true)
                    self.showLeftViewDone()
                }
                else if percentage == 0.0 {
                    // We can start hiding the view and ended the gesture without moving the view even by 1%
                    self.hideLeftViewPrepare()
                    self.hideLeftViewDone(withGesture: true)
                }
                else if (percentage < 1.0 && velocity.x > 0.0) || (velocity.x == 0.0 && percentage >= 0.5) {
                    self.showLeftViewPrepare(withGesture: true)
                    self.showLeftViewActions(animated: true)
                }
                else if (percentage > 0.0 && velocity.x < 0.0) || (velocity.x == 0.0 && percentage < 0.5) {
                    self.hideLeftViewPrepare()
                    self.hideLeftViewActions(animated: true)
                }

                self.leftViewGestureStartX = nil
            }
        }
    }

    // MARK: - Right View

    private func handlePanGestureForRightView(gesture: UIPanGestureRecognizer, location: CGPoint, velocity: CGPoint) {
        guard self.rightView != nil,
              self.isRightViewEnabled,
              self.isRightViewSwipeGestureEnabled,
              !self.isRightViewAlwaysVisibleForCurrentOrientation,
              self.isLeftViewHidden else { return }

        if gesture.state == .began || gesture.state == .changed,
           self.swipeGestureArea == .borders && self.isRightViewVisibilityStable && !self.isLocationInRightSwipeableRect(location) {
            return
        }
        if gesture.state == .ended || gesture.state == .cancelled,
           self.isRightViewVisibilityStable {
            return
        }

        if self.isRightViewVisibilityStable {
            if self.isRightViewShowing ? velocity.x > 0.0 : velocity.x < 0.0 {
                self.rightViewGestureStartX = location.x
                self.isRightViewShowingBeforeGesture = self.isRightViewShowing

                if self.isRightViewShowing {
                    self.hideRightViewPrepare()
                }
                else {
                    self.showRightViewPrepare(withGesture: true)
                }
            }
        }
        else if self.isRightViewVisibilityChanging, let rightViewGestureStartX = self.rightViewGestureStartX {
            let shiftedAmount = self.isRightViewShowingBeforeGesture ? location.x - rightViewGestureStartX : rightViewGestureStartX - location.x
            let percentage =  self.calculatePercentage(shiftedAmount: shiftedAmount,
                                                       viewWidth: self.rightViewWidth,
                                                       isViewShowingBeforeGesture: self.isRightViewShowingBeforeGesture)

            if gesture.state == .changed {
                if velocity.x < 0.0 {
                    self.showRightViewPrepare(withGesture: true)
                }
                else if velocity.x > 0.0 {
                    self.hideRightViewPrepare()
                }

                self.rootViewsTransformsValidate(percentage: percentage)
                self.rightViewsTransformsValidate(percentage: percentage)
            }
            else if gesture.state == .ended || gesture.state == .cancelled {
                if percentage == 1.0 {
                    // We can start showing the view and ended the gesture without moving the view even by 1%
                    self.showRightViewPrepare(withGesture: true)
                    self.showRightViewDone()
                }
                else if percentage == 0.0 {
                    // We can start hiding the view and ended the gesture without moving the view even by 1%
                    self.hideRightViewPrepare()
                    self.hideRightViewDone(withGesture: true)
                }
                else if (percentage < 1.0 && velocity.x < 0.0) || (velocity.x == 0.0 && percentage >= 0.5) {
                    self.showRightViewPrepare(withGesture: true)
                    self.showRightViewActions(animated: true)
                }
                else if (percentage > 0.0 && velocity.x > 0.0) || (velocity.x == 0.0 && percentage < 0.5) {
                    self.hideRightViewPrepare()
                    self.hideRightViewActions(animated: true)
                }

                self.rightViewGestureStartX = nil
            }
        }
    }

    // MARK: - UIGestureRecognizerDelegate

    func gestureRecognizer(_ gesture: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        guard !self.isAnimating,
              self.rootView != nil,
              self.leftView != nil || self.rightView != nil else { return false }
        // TODO: Make animations interraptable with this gesture

        if gesture is UITapGestureRecognizer {
            guard let touchView = touch.view, let rootContainerView = self.rootContainerView else { return false }
            return touchView == rootContainerView
        }
        if gesture is UIPanGestureRecognizer {
            return true
        }

        return false
    }

    // MARK: - Helpers

    private func isLocationInLeftSwipeableRect(_ location: CGPoint) -> Bool {
        guard let rootContainerView = self.rootContainerView,
              let leftContainerView = self.leftContainerView else { return false }

        if self.swipeGestureArea == .full {
            return true
        }

        let borderX = (self.leftViewPresentationStyle == .slideAbove && self.isLeftViewVisible) ? leftContainerView.frame.maxX : rootContainerView.frame.minX

        let swipeableRect = CGRect(x: borderX - self.leftViewSwipeGestureRange.left,
                                   y: 0.0,
                                   width: self.leftViewSwipeGestureRange.left + self.leftViewSwipeGestureRange.right,
                                   height: self.view.bounds.height)

        return swipeableRect.contains(location)
    }

    private func isLocationInRightSwipeableRect(_ location: CGPoint) -> Bool {
        guard let rootContainerView = self.rootContainerView,
              let rightContainerView = self.rightContainerView else { return false }

        if self.swipeGestureArea == .full {
            return true
        }

        let borderX = (self.rightViewPresentationStyle == .slideAbove && self.isRightViewVisible) ? rightContainerView.frame.minX : rootContainerView.frame.maxX

        let swipeableRect = CGRect(x: borderX - self.rightViewSwipeGestureRange.left,
                                   y: 0.0,
                                   width: self.rightViewSwipeGestureRange.left + self.rightViewSwipeGestureRange.right,
                                   height: self.view.bounds.height)

        return swipeableRect.contains(location)
    }

    private func calculatePercentage(shiftedAmount: CGFloat, viewWidth: CGFloat, isViewShowingBeforeGesture: Bool) -> CGFloat {
        var percentage = shiftedAmount / viewWidth

        if percentage < 0.0 {
            percentage = 0.0
        }
        else if percentage > 1.0 {
            percentage = 1.0
        }

        if isViewShowingBeforeGesture {
            percentage = 1.0 - percentage
        }

        return percentage
    }

}
