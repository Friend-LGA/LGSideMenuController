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

internal extension LGSideMenuController {

    func validateViewsTransforms() {
        self.validateRootViewsTransforms()
        self.validateLeftViewsTransforms()
        self.validateRightViewsTransforms()
    }

    func validateRootViewsTransforms() {
        validateRootViewsTransforms(percentage: self.isLeftViewShowing || self.isRightViewShowing ? 1.0 : 0.0)
    }

    func validateLeftViewsTransforms() {
        validateLeftViewsTransforms(percentage: self.isLeftViewShowing ? 1.0 : 0.0)
    }

    func validateRightViewsTransforms() {
        validateRightViewsTransforms(percentage: self.isRightViewShowing ? 1.0 : 0.0)
    }

    func validateRootViewsTransforms(percentage: CGFloat) {
        guard let rootContainerView = self.rootContainerView,
              let rootViewCoverView = self.rootViewCoverView else { return }

        if self.leftView != nil && self.isLeftViewVisible {
            rootViewCoverView.alpha = self.rootViewCoverAlphaForLeftView * percentage
        }
        else if self.rightView != nil && self.isRightViewVisible {
            rootViewCoverView.alpha = self.rootViewCoverAlphaForRightView * percentage
        }
        else {
            rootViewCoverView.alpha = percentage
        }

        if (self.leftView != nil && self.isLeftViewAlwaysVisibleForCurrentOrientation) ||
            (self.rightView != nil && self.isRightViewAlwaysVisibleForCurrentOrientation) {
            return
        }

        let originalWidth = self.view.bounds.width
        var translateX: CGFloat = 0.0
        var scale: CGFloat = 1.0

        if self.leftView != nil && self.isLeftViewVisible && self.leftViewPresentationStyle != .slideAbove {
            scale = 1.0 + (self.rootViewScaleForLeftView - 1.0) * percentage
            let shift = originalWidth * (1.0 - scale) / 2.0
            translateX = (self.leftViewWidth - shift) * percentage
        }
        else if self.rightView != nil && self.isRightViewVisible && self.rightViewPresentationStyle != .slideAbove {
            scale = 1.0 + (self.rootViewScaleForRightView - 1.0) * percentage
            let shift = originalWidth * (1.0 - scale) / 2.0
            translateX = -(self.rightViewWidth - shift) * percentage
        }

        let transformScale = CGAffineTransform(scaleX: scale, y: scale)
        let transfromTranslate = CGAffineTransform(translationX: translateX, y: 0.0)
        let transform = transformScale.concatenating(transfromTranslate)

        rootContainerView.transform = transform
    }

    func validateLeftViewsTransforms(percentage: CGFloat) {
        guard self.leftView != nil,
              let leftContainerView = self.leftContainerView,
              let leftViewBackgroundView = self.leftViewBackgroundView,
              let leftViewStyleView = self.leftViewEffectView,
              let leftViewWrapperView = self.leftViewWrapperView,
              let leftViewCoverView = self.leftViewCoverView else { return }

        // TODO: Add option to change alpha of the view itself

        if self.isLeftViewVisible && !self.isLeftViewAlwaysVisibleForCurrentOrientation {
            leftViewCoverView.alpha = self.leftViewCoverAlpha - (self.leftViewCoverAlpha * percentage)
        }

        var translateX: CGFloat = 0.0
        var wrapperViewTransform: CGAffineTransform = .identity
        var backgroundViewTransform: CGAffineTransform = .identity

        if !self.isLeftViewAlwaysVisibleForCurrentOrientation {
            var wrapperViewTransformScale: CGAffineTransform = .identity

            if self.leftViewPresentationStyle == .slideAbove {
                translateX = -(self.leftViewWidth + self.leftViewLayerBorderWidth + self.leftViewLayerShadowRadius) * (1.0 - percentage)
            }
            else {
                let scale = 1.0 + (self.leftViewInitialScale - 1.0) * (1.0 - percentage)
                let backgroundViewScale = self.leftViewBackgroundImageFinalScale + ((self.leftViewBackgroundImageInitialScale - self.leftViewBackgroundImageFinalScale) * (1.0 - percentage))

                wrapperViewTransformScale = CGAffineTransform(scaleX: scale, y: scale)
                backgroundViewTransform = CGAffineTransform(scaleX: backgroundViewScale, y: backgroundViewScale)
            }

            let additionalWrapperViewOffset = self.leftViewInitialOffsetX * (1.0 - percentage)
            let wrapperViewTransformTranslate = CGAffineTransform(translationX: additionalWrapperViewOffset, y: 0.0)

            wrapperViewTransform = wrapperViewTransformScale.concatenating(wrapperViewTransformTranslate)
        }

        leftContainerView.transform = CGAffineTransform(translationX: translateX, y: 0.0)
        leftViewWrapperView.transform = wrapperViewTransform
        leftViewBackgroundView.transform = backgroundViewTransform
        leftViewStyleView.transform = wrapperViewTransform
    }

    func validateRightViewsTransforms(percentage: CGFloat) {
        guard self.rightView != nil,
              let rightContainerView = self.rightContainerView,
              let rightViewBackgroundView = self.rightViewBackgroundView,
              let rightViewStyleView = self.rightViewEffectView,
              let rightViewWrapperView = self.rightViewWrapperView,
              let rightViewCoverView = self.rightViewCoverView else { return }

        // TODO: Add option to change alpha of the view itself

        if self.isRightViewVisible && !self.isRightViewAlwaysVisibleForCurrentOrientation {
            rightViewCoverView.alpha = self.rightViewCoverAlpha - (self.rightViewCoverAlpha * percentage)
        }

        var translateX: CGFloat = 0.0
        var wrapperViewTransform: CGAffineTransform = .identity
        var backgroundViewTransform: CGAffineTransform = .identity

        if !self.isRightViewAlwaysVisibleForCurrentOrientation {
            var wrapperViewTransformScale: CGAffineTransform = .identity

            if self.rightViewPresentationStyle == .slideAbove {
                translateX = (self.rightViewWidth + self.rightViewLayerBorderWidth + self.rightViewLayerShadowRadius) * (1.0 - percentage)
            }
            else {
                let scale = 1.0 + (self.rightViewInitialScale - 1.0) * (1.0 - percentage)
                let backgroundViewScale = self.rightViewBackgroundImageFinalScale + ((self.rightViewBackgroundImageInitialScale - self.rightViewBackgroundImageFinalScale) * (1.0 - percentage))

                wrapperViewTransformScale = CGAffineTransform(scaleX: scale, y: scale)
                backgroundViewTransform = CGAffineTransform(scaleX: backgroundViewScale, y: backgroundViewScale)
            }

            let additionalWrapperViewOffset = self.rightViewInitialOffsetX * (1.0 - percentage)
            let wrapperViewTransformTranslate = CGAffineTransform(translationX: additionalWrapperViewOffset, y: 0.0)

            wrapperViewTransform = wrapperViewTransformScale.concatenating(wrapperViewTransformTranslate)
        }

        rightContainerView.transform = CGAffineTransform(translationX: translateX, y: 0.0)
        rightViewWrapperView.transform = wrapperViewTransform
        rightViewBackgroundView.transform = backgroundViewTransform
        rightViewStyleView.transform = wrapperViewTransform
    }
    
}
