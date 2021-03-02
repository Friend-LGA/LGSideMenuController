//
//  LGSideMenuController+ValidatingViewsFrames.swift
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
import CoreGraphics
import UIKit

internal extension LGSideMenuController {

    func validateViewsFrames() {
        self.validateRootViewsFrames()
        self.validateLeftViewsFrames()
        self.validateRightViewsFrames()
    }

    func validateRootViewsFrames() {
        guard let rootView = self.rootView,
              let containerView = self.rootContainerView,
              let backgroundDecorationView = self.rootViewBackgroundDecorationView,
              let backgroundShadowView = self.rootViewBackgroundShadowView,
              let wrapperView = self.rootViewWrapperView,
              let coverView = self.rootViewCoverView else { return }

        let isLeftViewVisible = self.leftView != nil && self.isLeftViewVisibleToUser
        let isRightViewVisible = self.rightView != nil && self.isRightViewVisibleToUser

        let containerViewFrame: CGRect = {
            var result: CGRect = self.view.bounds
            if self.leftView != nil && self.isLeftViewAlwaysVisible {
                result.origin.x += self.rootViewOffsetTotalForLeftView.x
                result.size.width -= self.rootViewOffsetTotalForLeftView.x
            }
            if self.rightView != nil && self.isRightViewAlwaysVisible {
                result.size.width -= self.rootViewOffsetTotalForRightView.x
            }
            return result
        }()

        containerView.transform = .identity
        containerView.frame = containerViewFrame

        let borderWidth: CGFloat = {
            if isLeftViewVisible {
                return self.rootViewLayerBorderWidthForLeftView
            }
            else if isRightViewVisible {
                return self.rootViewLayerBorderWidthForRightView
            }
            return 0.0
        }()

        backgroundDecorationView.transform = .identity
        backgroundDecorationView.frame = containerView.bounds.insetBy(dx: -borderWidth, dy: -borderWidth)

        backgroundShadowView.transform = .identity
        backgroundShadowView.frame = {
            var shadowRadius: CGFloat = 0.0
            if isLeftViewVisible {
                shadowRadius = self.rootViewLayerShadowRadiusForLeftView
            }
            else if isRightViewVisible {
                shadowRadius = self.rootViewLayerShadowRadiusForRightView
            }
            return backgroundDecorationView.bounds.insetBy(dx: -shadowRadius, dy: -shadowRadius)
        }()

        wrapperView.transform = .identity
        wrapperView.frame = containerView.bounds

        rootView.transform = .identity
        rootView.frame = wrapperView.bounds

        coverView.transform = .identity
        coverView.frame = containerView.bounds
    }

    func validateLeftViewsFrames() {
        guard let leftView = self.leftView,
              let containerView = self.leftContainerView,
              let backgroundDecorationView = self.leftViewBackgroundDecorationView,
              let backgroundShadowView = self.leftViewBackgroundShadowView,
              let backgroundEffectView = self.leftViewBackgroundEffectView,
              let backgroundWrapperView = self.leftViewBackgroundWrapperView,
              let wrapperView = self.leftViewWrapperView,
              let coverView = self.leftViewCoverView,
              let statusBarBackgroundView = self.leftViewStatusBarBackgroundView,
              let statusBarBackgroundEffectView = self.leftViewStatusBarBackgroundEffectView else { return }

        containerView.transform = .identity
        containerView.frame = {
            var result = self.view.bounds
            if self.leftViewPresentationStyle.isWidthCompact {
                result.size.width = self.leftViewWidth
            }
            else if self.leftViewPresentationStyle.isWidthFull && self.isRightViewAlwaysVisible {
                result.size.width -= self.rightViewWidthTotal
            }
            return result
        }()

        backgroundDecorationView.transform = .identity
        backgroundDecorationView.frame = containerView.bounds.insetBy(dx: -self.leftViewLayerBorderWidth,
                                                                      dy: -self.leftViewLayerBorderWidth)

        backgroundShadowView.transform = .identity
        backgroundShadowView.frame = backgroundDecorationView.bounds.insetBy(dx: -self.leftViewLayerShadowRadius,
                                                                             dy: -self.leftViewLayerShadowRadius)

        backgroundEffectView.transform = .identity
        backgroundEffectView.frame = backgroundDecorationView.bounds.insetBy(dx: self.leftViewLayerBorderWidth,
                                                                             dy: self.leftViewLayerBorderWidth)

        backgroundWrapperView.transform = .identity
        backgroundWrapperView.frame = backgroundEffectView.frame

        if let backgroundImageView = self.leftViewBackgroundImageView {
            backgroundImageView.transform = .identity
            backgroundImageView.frame = backgroundWrapperView.bounds
        }
        else if let backgroundView = self.leftViewBackgroundView {
            backgroundView.transform = .identity
            backgroundView.frame = backgroundWrapperView.bounds
        }

        wrapperView.transform = .identity
        wrapperView.frame = CGRect(origin: .zero,
                                   size: CGSize(width: self.leftViewWidth, height: containerView.bounds.height))

        leftView.transform = .identity
        leftView.frame = wrapperView.bounds

        coverView.transform = .identity
        coverView.frame = containerView.bounds

        statusBarBackgroundView.transform = .identity
        statusBarBackgroundView.frame = {
            let frame = CGRect(origin: .zero,
                               size: CGSize(width: containerView.bounds.width,
                                            height: LGSideMenuHelper.getStatusBarFrame().height))
            return frame.insetBy(dx: -self.leftViewStatusBarBackgroundShadowRadius,
                                 dy: -self.leftViewStatusBarBackgroundShadowRadius)
        }()

        statusBarBackgroundEffectView.transform = .identity
        statusBarBackgroundEffectView.frame =
            statusBarBackgroundView.bounds.insetBy(dx: self.leftViewStatusBarBackgroundShadowRadius,
                                                   dy: self.leftViewStatusBarBackgroundShadowRadius)
    }

    func validateRightViewsFrames() {
        guard let rightView = self.rightView,
              let containerView = self.rightContainerView,
              let backgroundDecorationView = self.rightViewBackgroundDecorationView,
              let backgroundShadowView = self.rightViewBackgroundShadowView,
              let backgroundEffectView = self.rightViewBackgroundEffectView,
              let backgroundWrapperView = self.rightViewBackgroundWrapperView,
              let wrapperView = self.rightViewWrapperView,
              let coverView = self.rightViewCoverView,
              let statusBarBackgroundView = self.rightViewStatusBarBackgroundView,
              let statusBarBackgroundEffectView = self.rightViewStatusBarBackgroundEffectView else { return }

        containerView.transform = .identity
        containerView.frame = {
            var result = self.view.bounds
            if self.rightViewPresentationStyle.isWidthCompact {
                result.size.width = self.rightViewWidth
                result.origin.x = self.view.bounds.width - self.rightViewWidth
            }
            else if self.rightViewPresentationStyle.isWidthFull && self.isLeftViewAlwaysVisible {
                result.size.width -= self.leftViewWidthTotal
                result.origin.x += self.leftViewWidthTotal
            }
            return result
        }()

        backgroundDecorationView.transform = .identity
        backgroundDecorationView.frame = containerView.bounds.insetBy(dx: -self.rightViewLayerBorderWidth,
                                                                      dy: -self.rightViewLayerBorderWidth)

        backgroundShadowView.transform = .identity
        backgroundShadowView.frame = backgroundDecorationView.bounds.insetBy(dx: -self.rightViewLayerShadowRadius,
                                                                             dy: -self.rightViewLayerShadowRadius)

        backgroundEffectView.transform = .identity
        backgroundEffectView.frame = backgroundDecorationView.bounds.insetBy(dx: self.rightViewLayerBorderWidth,
                                                                             dy: self.rightViewLayerBorderWidth)

        backgroundWrapperView.transform = .identity
        backgroundWrapperView.frame = backgroundEffectView.frame

        if let backgroundImageView = self.rightViewBackgroundImageView {
            backgroundImageView.transform = .identity
            backgroundImageView.frame = backgroundWrapperView.bounds
        }
        else if let backgroundView = self.rightViewBackgroundView {
            backgroundView.transform = .identity
            backgroundView.frame = backgroundWrapperView.bounds
        }

        wrapperView.transform = .identity
        wrapperView.frame = CGRect(origin: CGPoint(x: containerView.bounds.width - self.rightViewWidth, y: 0.0),
                                   size: CGSize(width: self.rightViewWidth, height: containerView.bounds.height))

        rightView.transform = .identity
        rightView.frame = wrapperView.bounds

        coverView.transform = .identity
        coverView.frame = containerView.bounds

        statusBarBackgroundView.transform = .identity
        statusBarBackgroundView.frame = {
            let frame = CGRect(origin: .zero,
                               size: CGSize(width: containerView.bounds.width,
                                            height: LGSideMenuHelper.getStatusBarFrame().height))
            return frame.insetBy(dx: -self.rightViewStatusBarBackgroundShadowRadius,
                                 dy: -self.rightViewStatusBarBackgroundShadowRadius)
        }()

        statusBarBackgroundEffectView.transform = .identity
        statusBarBackgroundEffectView.frame =
            statusBarBackgroundView.bounds.insetBy(dx: self.rightViewStatusBarBackgroundShadowRadius,
                                                   dy: self.rightViewStatusBarBackgroundShadowRadius)
    }
}
