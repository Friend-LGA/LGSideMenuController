//
//  LGSideMenuController+ValidatingViewsTransforms.swift
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

private let pointsNeededForShadow: CGFloat = 10.0

internal extension LGSideMenuController {

    func validateViewsTransforms() {
        self.validateRootViewsTransforms()
        self.validateLeftViewsTransforms()
        self.validateRightViewsTransforms()
    }

    func validateRootViewsTransforms() {
        validateRootViewsTransforms(percentage: self.isSideViewShowing ? 1.0 : 0.0)
    }

    func validateLeftViewsTransforms() {
        validateLeftViewsTransforms(percentage: self.isSideViewShowing ? 1.0 : 0.0)
    }

    func validateRightViewsTransforms() {
        validateRightViewsTransforms(percentage: self.isSideViewShowing ? 1.0 : 0.0)
    }

    func validateRootViewsTransforms(percentage: CGFloat) {
        guard let containerView = self.rootContainerView,
              let coverView = self.rootViewCoverView else { return }

        let isLeftViewMoving = self.leftView != nil && self.isLeftViewVisible
        let isRightViewMoving = self.rightView != nil && self.isRightViewVisible

        containerView.alpha = {
            if isLeftViewMoving {
                return 1.0 - (1.0 - self.rootViewAlphaWhenHiddenForLeftView) * percentage
            }
            else if isRightViewMoving {
                return 1.0 - (1.0 - self.rootViewAlphaWhenHiddenForRightView) * percentage
            }
            else {
                return 1.0
            }
        }()

        coverView.alpha = {
            if isLeftViewMoving {
                return self.rootViewCoverAlphaForLeftView * percentage
            }
            else if isRightViewMoving {
                return self.rootViewCoverAlphaForRightView * percentage
            }
            else {
                return 0.0
            }
        }()

        let scale: CGFloat = {
            // If any of side views is visible, we can't change the scale of root view
            if self.isSideViewAlwaysVisible {
                return 1.0
            }
            var rootViewScale: CGFloat = 1.0
            if isLeftViewMoving {
                rootViewScale = self.rootViewScaleWhenHiddenForLeftView
            }
            if isRightViewMoving {
                rootViewScale = self.rootViewScaleWhenHiddenForRightView
            }
            return 1.0 + (rootViewScale - 1.0) * percentage
        }()

        let translate: CGPoint = {
            var result: CGPoint = .zero
            if isLeftViewMoving {
                result = CGPoint(x: self.rootViewOffsetTotalForLeftView.x * percentage,
                                 y: self.rootViewOffsetTotalForLeftView.y * percentage)
            }
            else if isRightViewMoving {
                result = CGPoint(x: -(self.rootViewOffsetTotalForRightView.x * percentage),
                                 y: self.rootViewOffsetTotalForRightView.y * percentage)
            }
            if scale != 1.0 {
                let shift = containerView.bounds.width * (1.0 - scale) / 2.0
                if isLeftViewMoving {
                    result.x -= shift * percentage
                }
                else if isRightViewMoving {
                    result.x += shift * percentage
                }
            }
            return result
        }()

        let transformScale = CGAffineTransform(scaleX: scale, y: scale)
        let transfromTranslate = CGAffineTransform(translationX: translate.x, y: translate.y)
        let transform = transformScale.concatenating(transfromTranslate)

        containerView.transform = transform

        self.didTransformRootViewCallbacks(percentage: percentage)
    }

    func validateLeftViewsTransforms(percentage: CGFloat) {
        guard self.leftView != nil,
              let containerView = self.leftContainerView,
              let backgroundDecorationView = self.leftViewBackgroundDecorationView,
              let backgroundShadowView = self.leftViewBackgroundShadowView,
              let wrapperView = self.leftViewWrapperView,
              let coverView = self.leftViewCoverView else { return }

        let viewAlpha: CGFloat = {
            if self.isLeftViewAlwaysVisible {
                return 1.0
            }
            return 1.0 - (1.0 - self.leftViewAlphaWhenHidden) * (1.0 - percentage)
        }()

        if self.leftViewPresentationStyle.isAbove {
            containerView.alpha = viewAlpha
        }
        else {
            wrapperView.alpha = viewAlpha
        }

        containerView.transform = {
            var translateX: CGFloat = 0.0
            if self.rightView != nil && self.isRightViewVisible {
                translateX -= self.rootViewOffsetTotalForRightView.x * percentage
                if self.leftViewPresentationStyle.isHiddenAside && !self.isLeftViewAlwaysVisible {
                    translateX -= self.leftViewWidthTotal
                }
            }
            else if self.leftViewPresentationStyle.isHiddenAside && !self.isLeftViewAlwaysVisible {
                translateX -= self.leftViewWidthTotal * (1.0 - percentage)
            }
            return CGAffineTransform(translationX: translateX, y: 0.0)
        }()

        backgroundDecorationView.transform = {
            var scale = self.leftViewBackgroundScaleWhenShowing
            var offsetX = self.leftViewBackgroundOffsetWhenShowing.x
            var offsetY = self.leftViewBackgroundOffsetWhenShowing.y

            if !self.isLeftViewAlwaysVisible {
                scale =
                    (self.leftViewBackgroundScaleWhenHidden * (1.0 - percentage)) +
                    (self.leftViewBackgroundScaleWhenShowing * percentage)

                offsetX =
                    (self.leftViewBackgroundOffsetWhenHidden.x * (1.0 - percentage)) +
                    (self.leftViewBackgroundOffsetWhenShowing.x * percentage)

                offsetY =
                    (self.leftViewBackgroundOffsetWhenHidden.y * (1.0 - percentage)) +
                    (self.leftViewBackgroundOffsetWhenShowing.y * percentage)
            }

            let transformTranslate = CGAffineTransform(translationX: offsetX, y: offsetY)
            let transformScale = CGAffineTransform(scaleX: scale, y: scale)

            return transformTranslate.concatenating(transformScale)
        }()

        backgroundShadowView.alpha = {
            if self.leftViewPresentationStyle.isAbove && !self.isLeftViewAlwaysVisible {
                let pointsPerPercent = self.leftViewWidthTotal / 100.0
                let percentsNeeded = pointsNeededForShadow / pointsPerPercent / 100.0
                return percentage / percentsNeeded
            }
            return 1.0
        }()

        wrapperView.transform = {
            if self.isLeftViewAlwaysVisible {
                return CGAffineTransform(translationX: self.leftViewOffsetWhenShowing.x,
                                         y: self.leftViewOffsetWhenShowing.y)
            }
            else {
                let scale = 1.0 + (self.leftViewScaleWhenHidden - 1.0) * (1.0 - percentage)

                let offsetX =
                    (self.leftViewOffsetWhenHidden.x * (1.0 - percentage)) +
                    (self.leftViewOffsetWhenShowing.x * percentage)

                let offsetY =
                    (self.leftViewOffsetWhenHidden.y * (1.0 - percentage)) +
                    (self.leftViewOffsetWhenShowing.y * percentage)

                let transformTranslate = CGAffineTransform(translationX: offsetX, y: offsetY)
                let transformScale = CGAffineTransform(scaleX: scale, y: scale)

                return transformTranslate.concatenating(transformScale)
            }
        }()

        coverView.alpha = {
            if !self.isLeftViewAlwaysVisible {
                return self.leftViewCoverAlpha - (self.leftViewCoverAlpha * percentage)
            }
            else if self.rightView != nil && self.isRightViewVisible {
                return self.leftViewCoverAlphaWhenAlwaysVisible * percentage
            }
            return 0.0
        }()

        self.didTransformLeftViewCallbacks(percentage: percentage)
    }

    func validateRightViewsTransforms(percentage: CGFloat) {
        guard self.rightView != nil,
              let containerView = self.rightContainerView,
              let backgroundDecorationView = self.rightViewBackgroundDecorationView,
              let backgroundShadowView = self.rightViewBackgroundShadowView,
              let wrapperView = self.rightViewWrapperView,
              let coverView = self.rightViewCoverView else { return }

        let viewAlpha: CGFloat = {
            if self.isRightViewAlwaysVisible {
                return 1.0
            }
            return 1.0 - (1.0 - self.rightViewAlphaWhenHidden) * (1.0 - percentage)
        }()

        if self.rightViewPresentationStyle.isAbove {
            containerView.alpha = viewAlpha
        }
        else {
            wrapperView.alpha = viewAlpha
        }

        containerView.transform = {
            var translateX: CGFloat = 0.0
            if self.leftView != nil && self.isLeftViewVisible {
                translateX += self.rootViewOffsetTotalForLeftView.x * percentage
                if self.rightViewPresentationStyle.isHiddenAside && !self.isRightViewAlwaysVisible {
                    translateX += self.rightViewWidthTotal
                }
            }
            else if self.rightViewPresentationStyle.isHiddenAside && !self.isRightViewAlwaysVisible {
                translateX += self.rightViewWidthTotal * (1.0 - percentage)
            }
            return CGAffineTransform(translationX: translateX, y: 0.0)
        }()

        backgroundDecorationView.transform = {
            var scale = self.rightViewBackgroundScaleWhenShowing
            var offsetX = self.rightViewBackgroundOffsetWhenShowing.x
            var offsetY = self.rightViewBackgroundOffsetWhenShowing.y

            if !self.isRightViewAlwaysVisible {
                scale =
                    (self.rightViewBackgroundScaleWhenHidden * (1.0 - percentage)) +
                    (self.rightViewBackgroundScaleWhenShowing * percentage)

                offsetX =
                    (self.rightViewBackgroundOffsetWhenHidden.x * (1.0 - percentage)) +
                    (self.rightViewBackgroundOffsetWhenShowing.x * percentage)

                offsetY =
                    (self.rightViewBackgroundOffsetWhenHidden.y * (1.0 - percentage)) +
                    (self.rightViewBackgroundOffsetWhenShowing.y * percentage)
            }

            let transformTranslate = CGAffineTransform(translationX: offsetX, y: offsetY)
            let transformScale = CGAffineTransform(scaleX: scale, y: scale)

            return transformTranslate.concatenating(transformScale)
        }()

        backgroundShadowView.alpha = {
            if self.rightViewPresentationStyle.isAbove && !self.isRightViewAlwaysVisible {
                let pointsPerPercent = self.rightViewWidthTotal / 100.0
                let percentsNeeded = pointsNeededForShadow / pointsPerPercent / 100.0
                return percentage / percentsNeeded
            }
            return 1.0
        }()

        wrapperView.transform = {
            if self.isRightViewAlwaysVisible {
                return CGAffineTransform(translationX: self.rightViewOffsetWhenShowing.x,
                                         y: self.rightViewOffsetWhenShowing.y)
            }
            else {
                let scale = 1.0 + (self.rightViewScaleWhenHidden - 1.0) * (1.0 - percentage)

                let offsetX =
                    (self.rightViewOffsetWhenHidden.x * (1.0 - percentage)) +
                    (self.rightViewOffsetWhenShowing.x * percentage)

                let offsetY =
                    (self.rightViewOffsetWhenHidden.y * (1.0 - percentage)) +
                    (self.rightViewOffsetWhenShowing.y * percentage)

                let transformTranslate = CGAffineTransform(translationX: offsetX, y: offsetY)
                let transformScale = CGAffineTransform(scaleX: scale, y: scale)

                return transformTranslate.concatenating(transformScale)
            }
        }()

        coverView.alpha = {
            if !self.isRightViewAlwaysVisible {
                return self.rightViewCoverAlpha - (self.rightViewCoverAlpha * percentage)
            }
            else if self.leftView != nil && self.isLeftViewVisible {
                return self.rightViewCoverAlphaWhenAlwaysVisible * percentage
            }
            return 0.0
        }()

        self.didTransformRightViewCallbacks(percentage: percentage)
    }
    
}
