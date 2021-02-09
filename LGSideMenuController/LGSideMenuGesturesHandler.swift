//
//  LGSideMenuGesturesHandler.swift
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

final internal class LGSideMenuGesturesHandler: NSObject, UIGestureRecognizerDelegate {

    weak var sideMenuController: LGSideMenuController?

    weak var rootViewContainer: UIView?
    weak var leftViewContainer: UIView?
    weak var rightViewContainer: UIView?

    weak var rootViewCoverView: UIView?

    var isAnimating = false

    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        guard let sideMenuController = self.sideMenuController, !self.isAnimating else { return false }
        // TODO: Make animations interraptable with this gesture

        if !(gestureRecognizer is UIPanGestureRecognizer) {
            guard let touchView = touch.view, let rootViewCoverView = self.rootViewCoverView else { return false }
            return touchView.isDescendant(of: rootViewCoverView)
        }

        guard sideMenuController.rootView != nil else { return false }

        let leftView = sideMenuController.leftView
        let rightView = sideMenuController.rightView
        let leftViewSwipeable = leftView != nil && sideMenuController.isLeftViewSwipeGestureEnabled
        let rightViewSwipeable = rightView != nil && sideMenuController.isRightViewSwipeGestureEnabled

        if sideMenuController.swipeGestureArea == .full && (leftViewSwipeable || rightViewSwipeable) {
            return true
        }

        guard let rootViewContainer = self.rootViewContainer else { return false }

        let location = touch.location(in: sideMenuController.view)
        var leftAvailableRect = CGRect.zero
        var rightAvailableRect = CGRect.zero

        if leftViewSwipeable {
            if sideMenuController.isLeftViewVisible {
                guard let leftViewContainer = self.leftViewContainer else { return false }

                leftAvailableRect = CGRect(x: leftViewContainer.frame.width - sideMenuController.leftViewSwipeGestureRange.left,
                                           y: rootViewContainer.frame.minY,
                                           width: sideMenuController.view.frame.width,
                                           height: rootViewContainer.frame.height)
            }
            else {
                leftAvailableRect = CGRect(x: -sideMenuController.leftViewSwipeGestureRange.left,
                                           y: rootViewContainer.frame.minY,
                                           width: sideMenuController.leftViewSwipeGestureRange.left + sideMenuController.leftViewSwipeGestureRange.right,
                                           height: rootViewContainer.frame.height)
            }

            if leftAvailableRect.contains(location) {
                return true
            }
        }

        if rightViewSwipeable {
            if sideMenuController.isRightViewVisible {
                guard let rightViewContainer = self.rightViewContainer else { return false }

                rightAvailableRect = CGRect(x: sideMenuController.view.frame.width - rightViewContainer.frame.width + sideMenuController.rightViewSwipeGestureRange.left,
                                            y: rootViewContainer.frame.minY,
                                            width: -sideMenuController.view.frame.width,
                                            height: rootViewContainer.frame.height)
            }
            else {
                rightAvailableRect = CGRect(x: rootViewContainer.frame.width - sideMenuController.rightViewSwipeGestureRange.left,
                                            y: rootViewContainer.frame.minY,
                                            width: sideMenuController.rightViewSwipeGestureRange.left + sideMenuController.rightViewSwipeGestureRange.right,
                                            height: rootViewContainer.frame.height)
            }

            if rightAvailableRect.contains(location) {
                return true
            }
        }

        return false
    }

}
