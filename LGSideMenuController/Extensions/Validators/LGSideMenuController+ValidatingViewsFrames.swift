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
              let rootContainerView = self.rootContainerView,
              let rootViewShadowView = self.rootViewShadowView,
              let rootViewBackgroundView = self.rootViewBackgroundView,
              let rootViewWrapperView = self.rootViewWrapperView,
              let rootViewCoverView = self.rootViewCoverView else { return }

        let isLeftViewVisible = self.leftView != nil && self.isLeftViewVisibleToUser
        let isRightViewVisible = self.rightView != nil && self.isRightViewVisibleToUser

        let containerViewFrame: CGRect = {
            var result: CGRect = self.view.bounds
            if self.leftView != nil && self.isLeftViewAlwaysVisibleForCurrentOrientation {
                result.origin.x += self.rootViewOffsetTotalForLeftView
                result.size.width -= self.rootViewOffsetTotalForLeftView
            }
            if self.rightView != nil && self.isRightViewAlwaysVisibleForCurrentOrientation {
                result.size.width -= self.rootViewOffsetTotalForRightView
            }
            return result
        }()

        rootContainerView.transform = .identity
        rootContainerView.frame = containerViewFrame

        rootViewShadowView.transform = .identity
        rootViewShadowView.frame = {
            var inset: CGFloat = 0.0
            if isLeftViewVisible {
                inset = self.rootViewLayerBorderWidthForLeftView + self.rootViewLayerShadowRadiusForLeftView
            }
            else if isRightViewVisible {
                inset = self.rootViewLayerBorderWidthForRightView + self.rootViewLayerShadowRadiusForRightView
            }
            return containerViewFrame.insetBy(dx: -inset, dy: -inset)
        }()

        rootViewBackgroundView.transform = .identity
        rootViewBackgroundView.frame = {
            var borderWidth: CGFloat = 0.0
            if isLeftViewVisible {
                borderWidth = self.rootViewLayerBorderWidthForLeftView
            }
            else if isRightViewVisible {
                borderWidth = self.rootViewLayerBorderWidthForRightView
            }
            return containerViewFrame.insetBy(dx: -borderWidth, dy: -borderWidth)
        }()

        rootViewWrapperView.transform = .identity
        rootViewWrapperView.frame = rootContainerView.bounds

        rootView.transform = .identity
        rootView.frame = rootViewWrapperView.bounds

        rootViewCoverView.transform = .identity
        rootViewCoverView.frame = rootContainerView.bounds
    }

    func validateLeftViewsFrames() {
        guard let leftView = self.leftView,
              let leftContainerView = self.leftContainerView,
              let leftViewShadowView = self.leftViewShadowView,
              let leftViewBackgroundView = self.leftViewBackgroundView,
              let leftViewBackgroundImageView = self.leftViewBackgroundImageView,
              let leftViewStyleView = self.leftViewEffectView,
              let leftViewWrapperView = self.leftViewWrapperView,
              let leftViewCoverView = self.leftViewCoverView else { return }

        let containerViewFrame: CGRect = {
            var result = self.view.bounds
            if self.leftViewPresentationStyle.isWidthCompact {
                result.size.width = self.leftViewWidth
            }
            else if self.leftViewPresentationStyle.isWidthFull && self.isRightViewAlwaysVisibleForCurrentOrientation {
                result.size.width -= self.rightViewWidthTotal
            }
            return result
        }()

        leftContainerView.transform = .identity
        leftContainerView.frame = containerViewFrame

        leftViewShadowView.transform = .identity
        leftViewShadowView.frame = leftContainerView.bounds.insetBy(dx: -(self.leftViewLayerBorderWidth + self.leftViewLayerShadowRadius),
                                                                    dy: -(self.leftViewLayerBorderWidth + self.leftViewLayerShadowRadius))

        leftViewBackgroundView.transform = .identity
        leftViewBackgroundView.frame = leftContainerView.bounds.insetBy(dx: -self.leftViewLayerBorderWidth,
                                                                        dy: -self.leftViewLayerBorderWidth)

        let backgroundSafeFrame = leftViewBackgroundView.bounds.insetBy(dx: self.leftViewLayerBorderWidth,
                                                                        dy: self.leftViewLayerBorderWidth)

        leftViewBackgroundImageView.transform = .identity
        leftViewBackgroundImageView.frame = backgroundSafeFrame

        leftViewStyleView.transform = .identity
        leftViewStyleView.frame = backgroundSafeFrame

        leftViewWrapperView.transform = .identity
        leftViewWrapperView.frame = CGRect(origin: .zero,
                                           size: CGSize(width: self.leftViewWidth, height: containerViewFrame.height))

        leftView.transform = .identity
        leftView.frame = leftViewWrapperView.bounds

        leftViewCoverView.transform = .identity
        leftViewCoverView.frame = leftContainerView.bounds
    }

    func validateRightViewsFrames() {
        guard let rightView = self.rightView,
              let rightContainerView = self.rightContainerView,
              let rightViewShadowView = self.rightViewShadowView,
              let rightViewBackgroundView = self.rightViewBackgroundView,
              let rightViewBackgroundImageView = self.rightViewBackgroundImageView,
              let rightViewStyleView = self.rightViewEffectView,
              let rightViewWrapperView = self.rightViewWrapperView,
              let rightViewCoverView = self.rightViewCoverView else { return }

        let containerViewFrame: CGRect = {
            var result = self.view.bounds
            if self.rightViewPresentationStyle.isWidthCompact {
                result.size.width = self.rightViewWidth
                result.origin.x = self.view.bounds.width - self.rightViewWidth
            }
            else if self.rightViewPresentationStyle.isWidthFull && self.isLeftViewAlwaysVisibleForCurrentOrientation {
                result.size.width -= self.leftViewWidthTotal
                result.origin.x += self.leftViewWidthTotal
            }
            return result
        }()

        rightContainerView.transform = .identity
        rightContainerView.frame = containerViewFrame

        rightViewShadowView.transform = .identity
        rightViewShadowView.frame = rightContainerView.bounds.insetBy(dx: -(self.rightViewLayerBorderWidth + self.rightViewLayerShadowRadius),
                                                                      dy: -(self.rightViewLayerBorderWidth + self.rightViewLayerShadowRadius))

        rightViewBackgroundView.transform = .identity
        rightViewBackgroundView.frame = rightContainerView.bounds.insetBy(dx: -self.rightViewLayerBorderWidth,
                                                                          dy: -self.rightViewLayerBorderWidth)

        let backgroundSafeFrame = rightViewBackgroundView.bounds.insetBy(dx: self.rightViewLayerBorderWidth,
                                                                         dy: self.rightViewLayerBorderWidth)

        rightViewBackgroundImageView.transform = .identity
        rightViewBackgroundImageView.frame = backgroundSafeFrame

        rightViewStyleView.transform = .identity
        rightViewStyleView.frame = backgroundSafeFrame

        rightViewWrapperView.transform = .identity
        rightViewWrapperView.frame = CGRect(origin: CGPoint(x: containerViewFrame.width - self.rightViewWidth, y: 0.0),
                                            size: CGSize(width: self.rightViewWidth, height: containerViewFrame.height))

        rightView.transform = .identity
        rightView.frame = rightViewWrapperView.bounds

        rightViewCoverView.transform = .identity
        rightViewCoverView.frame = rightContainerView.bounds
    }
    
}
