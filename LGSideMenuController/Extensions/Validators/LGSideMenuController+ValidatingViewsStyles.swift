//
//  LGSideMenuController+ValidatingViewsStyles.swift
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

    func validateViewsStyles() {
        self.validateRootViewsStyles()
        self.validateLeftViewsStyles()
        self.validateRightViewsStyles()
    }

    func validateRootViewsStyles() {
        guard let backgroundDecorationView = self.rootViewBackgroundDecorationView,
              let backgroundShadowView = self.rootViewBackgroundShadowView,
              let coverView = self.rootViewCoverView else { return }

        backgroundDecorationView.fillColor = self.rootViewBackgroundColor

        if self.leftView != nil && self.isLeftViewVisibleToUser {
            backgroundDecorationView.strokeColor = self.rootViewLayerBorderColorForLeftView
            backgroundDecorationView.strokeWidth = self.rootViewLayerBorderWidthForLeftView

            backgroundShadowView.shadowColor = self.rootViewLayerShadowColorForLeftView
            backgroundShadowView.shadowBlur = self.rootViewLayerShadowRadiusForLeftView
        }
        else if self.rightView != nil && self.isRightViewVisibleToUser {
            backgroundDecorationView.strokeColor = self.rootViewLayerBorderColorForRightView
            backgroundDecorationView.strokeWidth = self.rootViewLayerBorderWidthForRightView

            backgroundShadowView.shadowColor = self.rootViewLayerShadowColorForRightView
            backgroundShadowView.shadowBlur = self.rootViewLayerShadowRadiusForRightView
        }
        else {
            backgroundDecorationView.strokeColor = .clear
            backgroundDecorationView.strokeWidth = 0.0

            backgroundShadowView.shadowColor = .clear
            backgroundShadowView.shadowBlur = 0.0
        }

        if self.leftView != nil && self.isLeftViewVisible && !self.isLeftViewAlwaysVisible {
            coverView.backgroundColor = self.rootViewCoverColorForLeftView
            coverView.effect = self.rootViewCoverBlurEffectForLeftView
        }
        else if self.rightView != nil && self.isRightViewVisible && !self.isRightViewAlwaysVisible {
            coverView.backgroundColor = self.rootViewCoverColorForRightView
            coverView.effect = self.rootViewCoverBlurEffectForRightView
        }
        else {
            coverView.backgroundColor = nil
            coverView.effect = nil
        }
    }

    func validateLeftViewsStyles() {
        guard let backgroundDecorationView = self.leftViewBackgroundDecorationView,
              let backgroundShadowView = self.leftViewBackgroundShadowView,
              let backgroundEffectView = self.leftViewBackgroundEffectView,
              let coverView = self.leftViewCoverView,
              let statusBarBackgroundView = self.leftViewStatusBarBackgroundView,
              let statusBarBackgroundEffectView = self.leftViewStatusBarBackgroundEffectView else { return }

        backgroundDecorationView.fillColor = self.leftViewBackgroundColor
        backgroundDecorationView.strokeColor = self.leftViewLayerBorderColor
        backgroundDecorationView.strokeWidth = self.leftViewLayerBorderWidth
        backgroundDecorationView.alpha = self.leftViewBackgroundAlpha

        backgroundShadowView.shadowColor = self.leftViewLayerShadowColor
        backgroundShadowView.shadowBlur = self.leftViewLayerShadowRadius

        backgroundEffectView.effect = self.leftViewBackgroundBlurEffect

        if let backgroundImageView = self.leftViewBackgroundImageView {
            backgroundImageView.image = self.leftViewBackgroundImage
        }

        if self.isLeftViewAlwaysVisible {
            coverView.backgroundColor = self.leftViewCoverColorWhenAlwaysVisible
            coverView.effect = self.leftViewCoverBlurEffectWhenAlwaysVisible
        }
        else {
            coverView.backgroundColor = self.leftViewCoverColor
            coverView.effect = self.leftViewCoverBlurEffect
        }

        statusBarBackgroundView.fillColor = self.leftViewStatusBarBackgroundColor
        statusBarBackgroundView.shadowColor = self.leftViewStatusBarBackgroundShadowColor
        statusBarBackgroundView.shadowBlur = self.leftViewStatusBarBackgroundShadowRadius

        statusBarBackgroundEffectView.effect = self.leftViewStatusBarBackgroundBlurEffect
    }

    func validateRightViewsStyles() {
        guard let backgroundDecorationView = self.rightViewBackgroundDecorationView,
              let backgroundShadowView = self.rightViewBackgroundShadowView,
              let backgroundEffectView = self.rightViewBackgroundEffectView,
              let coverView = self.rightViewCoverView,
              let statusBarBackgroundView = self.rightViewStatusBarBackgroundView,
              let statusBarBackgroundEffectView = self.rightViewStatusBarBackgroundEffectView else { return }

        backgroundDecorationView.fillColor = self.rightViewBackgroundColor
        backgroundDecorationView.strokeColor = self.rightViewLayerBorderColor
        backgroundDecorationView.strokeWidth = self.rightViewLayerBorderWidth
        backgroundDecorationView.alpha = self.rightViewBackgroundAlpha

        backgroundShadowView.shadowColor = self.rightViewLayerShadowColor
        backgroundShadowView.shadowBlur = self.rightViewLayerShadowRadius

        backgroundEffectView.effect = self.rightViewBackgroundBlurEffect

        if let backgroundImageView = self.rightViewBackgroundImageView {
            backgroundImageView.image = self.rightViewBackgroundImage
        }

        if self.isRightViewAlwaysVisible {
            coverView.backgroundColor = self.rightViewCoverColorWhenAlwaysVisible
            coverView.effect = self.rightViewCoverBlurEffectWhenAlwaysVisible
        }
        else {
            coverView.backgroundColor = self.rightViewCoverColor
            coverView.effect = self.rightViewCoverBlurEffect
        }

        statusBarBackgroundView.fillColor = self.rightViewStatusBarBackgroundColor
        statusBarBackgroundView.shadowColor = self.rightViewStatusBarBackgroundShadowColor
        statusBarBackgroundView.shadowBlur = self.rightViewStatusBarBackgroundShadowRadius

        statusBarBackgroundEffectView.effect = self.rightViewStatusBarBackgroundBlurEffect
    }
    
}
