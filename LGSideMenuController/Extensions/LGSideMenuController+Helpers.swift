//
//  LGSideMenuController+Helpers.swift
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

    func disableRootViewLayouting() {
        guard self.isRootViewLayoutingEnabled == true,
              let wrapperView = self.rootViewWrapperView else { return }

        wrapperView.canLayoutSubviews = false
        self.isRootViewLayoutingEnabled = false
    }

    func enableRootViewLayouting() {
        guard self.isRootViewLayoutingEnabled == false,
              let wrapperView = self.rootViewWrapperView else { return }

        wrapperView.canLayoutSubviews = true
        self.isRootViewLayoutingEnabled = true
    }

    func disableRootViewControllerLayouting() {
        guard self.isRootViewControllerLayoutingEnabled == true,
              let viewController = self.rootViewController else { return }

        viewController.removeFromParent()
        self.isRootViewControllerLayoutingEnabled = false
    }

    func enableRootViewControllerLayouting() {
        guard self.isRootViewControllerLayoutingEnabled == false,
              let viewController = self.rootViewController else { return }

        self.addChild(viewController)
        self.isRootViewControllerLayoutingEnabled = true
    }

    var leftViewWidthTotal: CGFloat {
        self.leftViewWidth + self.leftViewLayerBorderWidth
    }

    var rightViewWidthTotal: CGFloat {
        self.rightViewWidth + self.rightViewLayerBorderWidth
    }

    var rootViewOffsetTotalForLeftView: CGFloat {
        self.leftViewWidthTotal + self.rootViewLayerBorderWidthForLeftView
    }

    var rootViewOffsetTotalForRightView: CGFloat {
        self.rightViewWidthTotal + self.rootViewLayerBorderWidthForRightView
    }

    var isRootViewShouldMoveForLeftView: Bool {
        return self.leftViewPresentationStyle != .slideAbove
    }

    var isRootViewShouldMoveForRightView: Bool {
        return self.rightViewPresentationStyle != .slideAbove
    }

}
