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

extension LGSideMenuController {

    // MARK: - UIGestureRecognizerDelegate

    open func gestureRecognizer(_ gesture: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        guard !self.isAnimating,
              self.rootView != nil,
              self.leftView != nil || self.rightView != nil else { return false }
        // TODO: Make animations interraptable with this gesture

        let isLeftViewActive = self.leftView != nil && self.isLeftViewEnabled && !self.isLeftViewAlwaysVisibleForCurrentOrientation
        let isRightViewActive = self.rightView != nil && self.isRightViewEnabled && !self.isRightViewAlwaysVisibleForCurrentOrientation

        if gesture == self.tapGesture {
            guard !self.isRootViewShowing,
                  (isLeftViewActive && self.shouldLeftViewHideOnTouch) ||
                    (isRightViewActive && self.shouldRightViewHideOnTouch),
                  let touchView = touch.view,
                  let rootContainerView = self.rootContainerView else { return false }

            return touchView == rootContainerView
        }

        if gesture == self.panGestureForLeftView {
            guard isLeftViewActive && self.isLeftViewSwipeGestureEnabled && self.isRightViewHidden  else { return false }

            let location = touch.location(in: self.view)
            return isLocationInLeftSwipeableRect(location)
        }

        if gesture == self.panGestureForRightView {
            guard isRightViewActive && self.isRightViewSwipeGestureEnabled && self.isLeftViewHidden else { return false }

            let location = touch.location(in: self.view)
            return isLocationInRightSwipeableRect(location)
        }

        return false
    }

    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        // 1. We need to hande swipeGestureArea == .full
        // 2. For some reason UINavigationController interactivePopGestureRecognizer behaviour is unpredictable,
        // sometimes it is failing and sometimes it is not. Better we will have it with higher priority but predictable.
        if otherGestureRecognizer == self.panGestureForLeftView ||
            otherGestureRecognizer == self.panGestureForRightView ||
            otherGestureRecognizer is UIScreenEdgePanGestureRecognizer {
            return false
        }
        return true
    }

    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        // We need to hande swipeGestureArea == .full
        return otherGestureRecognizer == self.panGestureForLeftView || otherGestureRecognizer == self.panGestureForRightView
    }

    // MARK: - UIGestureRecognizer Targets

    @objc
    open func handleTapGesture(gesture: UITapGestureRecognizer) {
        guard gesture.state == .ended else { return }

        if self.isLeftViewVisible {
            self.hideLeftView(animated: self.shouldLeftViewHideOnTouchAnimated)
        }
        else if self.isRightViewVisible {
            self.hideRightView(animated: self.shouldRightViewHideOnTouchAnimated)
        }
    }

    @objc
    open func handlePanGestureForLeftView(gesture: UIPanGestureRecognizer) {
        // Both pan gestures can be recognized in case of swipeGestureArea == .full
        guard self.isRightViewHidden else { return }

        let location = gesture.location(in: self.view)
        let velocity = gesture.velocity(in: self.view)

        if self.isLeftViewVisibilityStable,
           gesture.state == .began || gesture.state == .changed {
            if self.isLeftViewShowing ? velocity.x < 0.0 : velocity.x > 0.0 {
                self.leftViewGestureStartX = location.x
                self.isLeftViewShowingBeforeGesture = self.isLeftViewShowing

                if self.isLeftViewShowing {
                    self.hideLeftViewPrepare()
                }
                else {
                    self.showLeftViewPrepare(updateStatusBar: true)
                }
            }
        }
        else if self.isLeftViewVisibilityChanging,
                gesture.state == .changed || gesture.state == .ended || gesture.state == .cancelled,
                let leftViewGestureStartX = self.leftViewGestureStartX {
            let shiftedAmount = self.isLeftViewShowingBeforeGesture ? leftViewGestureStartX - location.x : location.x - leftViewGestureStartX
            let percentage =  self.calculatePercentage(shiftedAmount: shiftedAmount,
                                                       viewWidth: self.leftViewWidth,
                                                       isViewShowingBeforeGesture: self.isLeftViewShowingBeforeGesture)

            if gesture.state == .changed {
                if velocity.x > 0.0 {
                    self.showLeftViewPrepare(updateStatusBar: false)
                }
                else if velocity.x < 0.0 {
                    self.hideLeftViewPrepare()
                }

                self.validateRootViewsTransforms(percentage: percentage)
                self.validateLeftViewsTransforms(percentage: percentage)
                self.validateRightViewsTransforms(percentage: percentage)
            }
            else if gesture.state == .ended || gesture.state == .cancelled {
                if percentage == 1.0 {
                    // We can start showing the view and ended the gesture without moving the view even by 1%
                    self.showLeftViewPrepare(updateStatusBar: false)
                    self.showLeftViewDone()
                }
                else if percentage == 0.0 {
                    // We can start hiding the view and ended the gesture without moving the view even by 1%
                    self.hideLeftViewPrepare()
                    self.hideLeftViewDone(updateStatusBar: true)
                }
                else if (percentage < 1.0 && velocity.x > 0.0) || (velocity.x == 0.0 && percentage >= 0.5) {
                    self.showLeftViewPrepare(updateStatusBar: false)
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

    @objc
    open func handlePanGestureForRightView(gesture: UIPanGestureRecognizer) {
        // Both pan gestures can be recognized in case of swipeGestureArea == .full
        guard self.isLeftViewHidden else { return }

        let location = gesture.location(in: self.view)
        let velocity = gesture.velocity(in: self.view)

        if self.isRightViewVisibilityStable,
           gesture.state == .began || gesture.state == .changed {
            if self.isRightViewShowing ? velocity.x > 0.0 : velocity.x < 0.0 {
                self.rightViewGestureStartX = location.x
                self.isRightViewShowingBeforeGesture = self.isRightViewShowing

                if self.isRightViewShowing {
                    self.hideRightViewPrepare()
                }
                else {
                    self.showRightViewPrepare(updateStatusBar: true)
                }
            }
        }
        else if self.isRightViewVisibilityChanging,
                gesture.state == .changed || gesture.state == .ended || gesture.state == .cancelled,
                let rightViewGestureStartX = self.rightViewGestureStartX {
            let shiftedAmount = self.isRightViewShowingBeforeGesture ? location.x - rightViewGestureStartX : rightViewGestureStartX - location.x
            let percentage =  self.calculatePercentage(shiftedAmount: shiftedAmount,
                                                       viewWidth: self.rightViewWidth,
                                                       isViewShowingBeforeGesture: self.isRightViewShowingBeforeGesture)

            if gesture.state == .changed {
                if velocity.x < 0.0 {
                    self.showRightViewPrepare(updateStatusBar: false)
                }
                else if velocity.x > 0.0 {
                    self.hideRightViewPrepare()
                }

                self.validateRootViewsTransforms(percentage: percentage)
                self.validateRightViewsTransforms(percentage: percentage)
                self.validateLeftViewsTransforms(percentage: percentage)
            }
            else if gesture.state == .ended || gesture.state == .cancelled {
                if percentage == 1.0 {
                    // We can start showing the view and ended the gesture without moving the view even by 1%
                    self.showRightViewPrepare(updateStatusBar: false)
                    self.showRightViewDone()
                }
                else if percentage == 0.0 {
                    // We can start hiding the view and ended the gesture without moving the view even by 1%
                    self.hideRightViewPrepare()
                    self.hideRightViewDone(updateStatusBar: true)
                }
                else if (percentage < 1.0 && velocity.x < 0.0) || (velocity.x == 0.0 && percentage >= 0.5) {
                    self.showRightViewPrepare(updateStatusBar: false)
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

    // MARK: - Helpers

    private func isLocationInLeftSwipeableRect(_ location: CGPoint) -> Bool {
        guard let rootContainerView = self.rootContainerView,
              let leftContainerView = self.leftContainerView else { return false }

        let borderX = (self.leftViewPresentationStyle == .slideAbove && self.isLeftViewVisible) ? leftContainerView.frame.maxX : rootContainerView.frame.minX
        let originX = borderX - self.leftViewSwipeGestureRange.left

        let width: CGFloat = {
            if self.leftViewSwipeGestureArea == .full || self.isLeftViewVisible {
                return self.view.bounds.width - originX
            }
            else {
                return self.leftViewSwipeGestureRange.left + self.leftViewSwipeGestureRange.right
            }
        }()

        let swipeableRect = CGRect(x: originX,
                                   y: 0.0,
                                   width: width,
                                   height: self.view.bounds.height)

        return swipeableRect.contains(location)
    }

    private func isLocationInRightSwipeableRect(_ location: CGPoint) -> Bool {
        guard let rootContainerView = self.rootContainerView,
              let rightContainerView = self.rightContainerView else { return false }

        let borderX = (self.rightViewPresentationStyle == .slideAbove && self.isRightViewVisible) ? rightContainerView.frame.minX : rootContainerView.frame.maxX

        let originX: CGFloat = {
            if self.rightViewSwipeGestureArea == .full || self.isRightViewVisible {
                return 0.0
            }
            else {
                return borderX - self.rightViewSwipeGestureRange.left
            }
        }()

        let width: CGFloat = {
            if self.rightViewSwipeGestureArea == .full || self.isRightViewVisible {
                return borderX - originX + self.rightViewSwipeGestureRange.right
            }
            else {
                return self.rightViewSwipeGestureRange.left + self.rightViewSwipeGestureRange.right
            }
        }()

        let swipeableRect = CGRect(x: originX,
                                   y: 0.0,
                                   width: width,
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
