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
              let containerClipToBorderView = self.rootContainerClipToBorderView,
              let backgroundDecorationView = self.rootViewBackgroundDecorationView,
              let backgroundShadowView = self.rootViewBackgroundShadowView,
              let wrapperView = self.rootViewWrapperView,
              let coverView = self.rootViewCoverView else { return }

        let isLeftViewVisible = self.leftView != nil && self.isLeftViewVisibleToUser
        let isRightViewVisible = self.rightView != nil && self.isRightViewVisibleToUser

        containerView.transform = .identity
        containerView.frame = {
            var result: CGRect = self.view.bounds
            if self.leftView != nil && self.isLeftViewAlwaysVisible {
                result.origin.x += self.rootViewOffsetTotalForLeftViewWhenAlwaysVisible
                result.size.width -= self.rootViewOffsetTotalForLeftViewWhenAlwaysVisible
            }
            if self.rightView != nil && self.isRightViewAlwaysVisible {
                result.size.width -= self.rootViewOffsetTotalForRightViewWhenAlwaysVisible
            }
            return result
        }()

        containerClipToBorderView.transform = .identity
        containerClipToBorderView.frame = containerView.bounds

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

        rootViewLayoutSubviews()
    }

    func validateLeftViewsFrames() {
        guard let leftView = self.leftView,
              let containerView = self.leftContainerView,
              let containerClipToBorderView = self.leftContainerClipToBorderView,
              let backgroundDecorationView = self.leftViewBackgroundDecorationView,
              let backgroundShadowView = self.leftViewBackgroundShadowView,
              let backgroundEffectView = self.leftViewBackgroundEffectView,
              let backgroundWrapperView = self.leftViewBackgroundWrapperView,
              let wrapperView = self.leftViewWrapperView,
              let coverView = self.leftViewCoverView else { return }

        containerView.transform = .identity
        containerView.frame = {
            var result = self.view.bounds
            let inset = self.leftViewLayerShadowRadius + self.leftViewLayerBorderWidth
            if self.leftViewPresentationStyle.isWidthCompact {
                result.size.width = self.leftViewWidth
            }
            else if self.leftViewPresentationStyle.isWidthFull && self.isRightViewAlwaysVisible {
                result.size.width -= self.rightViewWidthTotal + inset
            }
            result = result.insetBy(dx: -inset, dy: -inset)
            return result
        }()

        containerClipToBorderView.transform = .identity
        containerClipToBorderView.frame =
            containerView.bounds.insetBy(dx: self.leftViewLayerShadowRadius + self.leftViewLayerBorderWidth,
                                         dy: self.leftViewLayerShadowRadius + self.leftViewLayerBorderWidth)

        backgroundDecorationView.transform = .identity
        backgroundDecorationView.frame = containerView.bounds.insetBy(dx: self.leftViewLayerShadowRadius,
                                                                      dy: self.leftViewLayerShadowRadius)

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
                                   size: CGSize(width: self.leftViewWidth, height: containerClipToBorderView.bounds.height))

        leftView.transform = .identity
        leftView.frame = wrapperView.bounds

        coverView.transform = .identity
        coverView.frame = containerClipToBorderView.bounds

        validateLeftViewStatusBarBackgroundFrames()

        leftViewLayoutSubviews()
    }

    func validateLeftViewStatusBarBackgroundFrames() {
        guard let containerClipToBorderView = self.leftContainerClipToBorderView,
              let statusBarBackgroundView = self.leftViewStatusBarBackgroundView,
              let statusBarBackgroundEffectView = self.leftViewStatusBarBackgroundEffectView else { return }

        statusBarBackgroundView.transform = .identity
        statusBarBackgroundView.frame = {
            let frame = CGRect(origin: .zero,
                               size: CGSize(width: containerClipToBorderView.bounds.width,
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
              let containerClipToBorderView = self.rightContainerClipToBorderView,
              let backgroundDecorationView = self.rightViewBackgroundDecorationView,
              let backgroundShadowView = self.rightViewBackgroundShadowView,
              let backgroundEffectView = self.rightViewBackgroundEffectView,
              let backgroundWrapperView = self.rightViewBackgroundWrapperView,
              let wrapperView = self.rightViewWrapperView,
              let coverView = self.rightViewCoverView else { return }

        containerView.transform = .identity
        containerView.frame = {
            var result = self.view.bounds
            let inset = self.rightViewLayerShadowRadius + self.rightViewLayerBorderWidth
            if self.rightViewPresentationStyle.isWidthCompact {
                result.size.width = self.rightViewWidth
                result.origin.x = self.view.bounds.width - self.rightViewWidth
            }
            else if self.rightViewPresentationStyle.isWidthFull && self.isLeftViewAlwaysVisible {
                result.size.width -= self.leftViewWidthTotal + inset
                result.origin.x += self.leftViewWidthTotal + inset
            }
            result = result.insetBy(dx: -inset, dy: -inset)
            return result
        }()

        containerClipToBorderView.transform = .identity
        containerClipToBorderView.frame =
            containerView.bounds.insetBy(dx: self.rightViewLayerShadowRadius + self.rightViewLayerBorderWidth,
                                         dy: self.rightViewLayerShadowRadius + self.rightViewLayerBorderWidth)

        backgroundDecorationView.transform = .identity
        backgroundDecorationView.frame = containerView.bounds.insetBy(dx: self.rightViewLayerShadowRadius,
                                                                      dy: self.rightViewLayerShadowRadius)

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
        wrapperView.frame = CGRect(origin: CGPoint(x: containerClipToBorderView.bounds.width - self.rightViewWidth, y: 0.0),
                                   size: CGSize(width: self.rightViewWidth, height: containerClipToBorderView.bounds.height))

        rightView.transform = .identity
        rightView.frame = wrapperView.bounds

        coverView.transform = .identity
        coverView.frame = containerClipToBorderView.bounds

        validateRightViewStatusBarBackgroundFrames()

        rightViewLayoutSubviews()
    }

    func validateRightViewStatusBarBackgroundFrames() {
        guard let containerClipToBorderView = self.rightContainerClipToBorderView,
              let statusBarBackgroundView = self.rightViewStatusBarBackgroundView,
              let statusBarBackgroundEffectView = self.rightViewStatusBarBackgroundEffectView else { return }

        statusBarBackgroundView.transform = .identity
        statusBarBackgroundView.frame = {
            let frame = CGRect(origin: .zero,
                               size: CGSize(width: containerClipToBorderView.bounds.width,
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
