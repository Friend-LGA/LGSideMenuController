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
        guard let rootViewShadowView = self.rootViewShadowView,
              let rootViewBackgroundView = self.rootViewBackgroundView,
              let rootViewCoverView = self.rootViewCoverView else { return }

        rootViewBackgroundView.fillColor = self.rootViewBackgroundColor

        if self.leftView != nil && self.isLeftViewVisibleToUser {
            rootViewShadowView.shadowColor = self.rootViewLayerShadowColorForLeftView
            rootViewShadowView.shadowBlur = self.rootViewLayerShadowRadiusForLeftView

            rootViewBackgroundView.strokeColor = self.rootViewLayerBorderColorForLeftView
            rootViewBackgroundView.strokeWidth = self.rootViewLayerBorderWidthForLeftView
        }
        else if self.rightView != nil && self.isRightViewVisibleToUser {
            rootViewShadowView.shadowColor = self.rootViewLayerShadowColorForRightView
            rootViewShadowView.shadowBlur = self.rootViewLayerShadowRadiusForRightView

            rootViewBackgroundView.strokeColor = self.rootViewLayerBorderColorForRightView
            rootViewBackgroundView.strokeWidth = self.rootViewLayerBorderWidthForRightView
        }
        else {
            rootViewShadowView.shadowColor = .clear
            rootViewShadowView.shadowBlur = 0.0

            rootViewBackgroundView.strokeColor = .clear
            rootViewBackgroundView.strokeWidth = 0.0
        }

        rootViewShadowView.setNeedsDisplay()
        rootViewBackgroundView.setNeedsDisplay()

        if self.leftView != nil && self.isLeftViewVisible && !self.isLeftViewAlwaysVisibleForCurrentOrientation {
            rootViewCoverView.backgroundColor = self.rootViewCoverColorForLeftView
            rootViewCoverView.effect = self.rootViewCoverBlurEffectForLeftView
        }
        else if self.rightView != nil && self.isRightViewVisible && !self.isRightViewAlwaysVisibleForCurrentOrientation {
            rootViewCoverView.backgroundColor = self.rootViewCoverColorForRightView
            rootViewCoverView.effect = self.rootViewCoverBlurEffectForRightView
        }
        else {
            rootViewCoverView.backgroundColor = nil
            rootViewCoverView.effect = nil
        }
    }

    func validateLeftViewsStyles() {
        guard let leftViewShadowView = self.leftViewShadowView,
              let leftViewBackgroundView = self.leftViewBackgroundView,
              let leftViewBackgroundImageView = self.leftViewBackgroundImageView,
              let leftViewStyleView = self.leftViewEffectView,
              let leftViewCoverView = self.leftViewCoverView else { return }

        leftViewShadowView.shadowColor = self.leftViewLayerShadowColor
        leftViewShadowView.shadowBlur = self.leftViewLayerShadowRadius
        leftViewShadowView.setNeedsDisplay()

        leftViewBackgroundView.fillColor = self.leftViewBackgroundColor
        leftViewBackgroundView.strokeColor = self.leftViewLayerBorderColor
        leftViewBackgroundView.strokeWidth = self.leftViewLayerBorderWidth
        leftViewBackgroundView.alpha = self.leftViewBackgroundAlpha
        leftViewBackgroundView.setNeedsDisplay()

        leftViewBackgroundImageView.image = self.leftViewBackgroundImage

        leftViewStyleView.effect = self.leftViewBackgroundBlurEffect

        if self.isLeftViewAlwaysVisibleForCurrentOrientation {
            leftViewCoverView.backgroundColor = self.leftViewCoverColorWhenAlwaysVisible
            leftViewCoverView.effect = self.leftViewCoverBlurEffectWhenAlwaysVisible
        }
        else {
            leftViewCoverView.backgroundColor = self.leftViewCoverColor
            leftViewCoverView.effect = self.leftViewCoverBlurEffect
        }
    }

    func validateRightViewsStyles() {
        guard let rightViewShadowView = self.rightViewShadowView,
              let rightViewBackgroundView = self.rightViewBackgroundView,
              let rightViewBackgroundImageView = self.rightViewBackgroundImageView,
              let rightViewStyleView = self.rightViewEffectView,
              let rightViewCoverView = self.rightViewCoverView else { return }

        rightViewShadowView.shadowColor = self.rightViewLayerShadowColor
        rightViewShadowView.shadowBlur = self.rightViewLayerShadowRadius
        rightViewShadowView.setNeedsDisplay()

        rightViewBackgroundView.fillColor = self.rightViewBackgroundColor
        rightViewBackgroundView.strokeColor = self.rightViewLayerBorderColor
        rightViewBackgroundView.strokeWidth = self.rightViewLayerBorderWidth
        rightViewBackgroundView.alpha = self.rightViewBackgroundAlpha
        rightViewBackgroundView.setNeedsDisplay()

        rightViewBackgroundImageView.image = self.rightViewBackgroundImage

        rightViewStyleView.effect = self.rightViewBackgroundBlurEffect

        if self.isRightViewAlwaysVisibleForCurrentOrientation {
            rightViewCoverView.backgroundColor = self.rightViewCoverColorWhenAlwaysVisible
            rightViewCoverView.effect = self.rightViewCoverBlurEffectWhenAlwaysVisible
        }
        else {
            rightViewCoverView.backgroundColor = self.rightViewCoverColor
            rightViewCoverView.effect = self.rightViewCoverBlurEffect
        }
    }
    
}
