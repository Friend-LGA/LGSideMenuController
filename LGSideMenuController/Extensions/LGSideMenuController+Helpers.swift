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

        viewController.willMove(toParent: nil)
        viewController.removeFromParent()
        self.isRootViewControllerLayoutingEnabled = false
    }

    func enableRootViewControllerLayouting() {
        guard self.isRootViewControllerLayoutingEnabled == false,
              let viewController = self.rootViewController else { return }

        self.addChild(viewController)
        viewController.didMove(toParent: self)
        self.isRootViewControllerLayoutingEnabled = true
    }

    var leftViewWidthTotal: CGFloat {
        self.leftViewWidth + self.leftViewLayerBorderWidth
    }

    var rightViewWidthTotal: CGFloat {
        self.rightViewWidth + self.rightViewLayerBorderWidth
    }

    var rootViewOffsetTotalForLeftView: CGPoint {
        var result = self.rootViewOffsetWhenHiddenForLeftView
        if self.leftViewPresentationStyle.shouldRootViewMove {
            result.x += self.leftViewWidthTotal + self.rootViewLayerBorderWidthForLeftView
        }
        return result
    }

    var rootViewOffsetTotalForLeftViewWhenAlwaysVisible: CGFloat {
        return
            self.rootViewOffsetWhenHiddenForLeftView.x +
            self.leftViewWidthTotal +
            self.rootViewLayerBorderWidthForLeftView
    }

    var rootViewOffsetTotalForRightView: CGPoint {
        var result = CGPoint(x: -self.rootViewOffsetWhenHiddenForRightView.x,
                             y: self.rootViewOffsetWhenHiddenForRightView.y)
        if self.rightViewPresentationStyle.shouldRootViewMove {
            result.x += self.rightViewWidthTotal + self.rootViewLayerBorderWidthForRightView
        }
        return result
    }

    var rootViewOffsetTotalForRightViewWhenAlwaysVisible: CGFloat {
        return
            -self.rootViewOffsetWhenHiddenForRightView.x +
            self.rightViewWidthTotal +
            self.rootViewLayerBorderWidthForRightView
    }

    // MARK: - Cancel Animations -

    func cancelRootViewAnimations() {
        guard let containerView = self.rootContainerView,
              let wrapperView = self.rootViewWrapperView,
              let coverView = self.rootViewCoverView else { return }

        CATransaction.begin()
        containerView.layer.removeAllAnimations()
        wrapperView.layer.removeAllAnimations()
        coverView.layer.removeAllAnimations()
        CATransaction.commit()
    }

    func cancelLeftViewAnimations() {
        guard let containerView = self.leftContainerView,
              let backgroundDecorationView = self.leftViewBackgroundDecorationView,
              let wrapperView = self.leftViewWrapperView,
              let coverView = self.leftViewCoverView else { return }

        CATransaction.begin()
        containerView.layer.removeAllAnimations()
        backgroundDecorationView.layer.removeAllAnimations()
        wrapperView.layer.removeAllAnimations()
        coverView.layer.removeAllAnimations()
        CATransaction.commit()
    }

    func cancelRightViewAnimations() {
        guard let containerView = self.rightContainerView,
              let backgroundDecorationView = self.rightViewBackgroundDecorationView,
              let wrapperView = self.rightViewWrapperView,
              let coverView = self.rightViewCoverView else { return }

        CATransaction.begin()
        containerView.layer.removeAllAnimations()
        backgroundDecorationView.layer.removeAllAnimations()
        wrapperView.layer.removeAllAnimations()
        coverView.layer.removeAllAnimations()
        CATransaction.commit()
    }

    // MARK: - Status Bar -

    var isViewLocatedUnderStatusBar: Bool {
        guard let keyWindow = LGSideMenuHelper.getKeyWindow() else { return false }
        let statusBarOrigin = keyWindow.convert(LGSideMenuHelper.getStatusBarFrame().origin, to: self.view)
        return statusBarOrigin == .zero
    }

}
