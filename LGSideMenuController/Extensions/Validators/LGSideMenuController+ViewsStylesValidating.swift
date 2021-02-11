//
//  LGSideMenuViewsStylesValidating.swift
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

    func viewsStylesValidate() {
        self.rootViewsStylesValidate()
        self.leftViewsStylesValidate()
        self.rightViewsStylesValidate()
    }

    func rootViewsStylesValidate() {
        guard let rootViewBorderView = self.rootViewBorderView,
              let rootViewCoverView = self.rootViewCoverView else { return }

        rootViewBorderView.fillColor = UIColor.black.withAlphaComponent(0.1)
        rootViewBorderView.strokeColor = self.rootViewLayerBorderColor
        rootViewBorderView.strokeWidth = self.rootViewLayerBorderWidth
        rootViewBorderView.shadowColor = self.rootViewLayerShadowColor
        rootViewBorderView.shadowBlur = self.rootViewLayerShadowRadius
        rootViewBorderView.setNeedsDisplay()

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

    func leftViewsStylesValidate() {
        guard let leftViewBackgroundView = self.leftViewBackgroundView,
              let leftViewBorderView = self.leftViewBorderView,
              let leftViewStyleView = self.leftViewEffectView,
              let leftViewCoverView = self.leftViewCoverView else { return }

        leftViewBorderView.fillColor = self.isLeftViewAlwaysVisibleForCurrentOrientation ? self.leftViewBackgroundColor.withAlphaComponent(1.0) : self.leftViewBackgroundColor
        leftViewBorderView.strokeColor = self.leftViewLayerBorderColor
        leftViewBorderView.strokeWidth = self.leftViewLayerBorderWidth
        leftViewBorderView.shadowColor = self.leftViewLayerShadowColor
        leftViewBorderView.shadowBlur = self.leftViewLayerShadowRadius
        leftViewBorderView.alpha = self.leftViewBackgroundAlpha
        leftViewBorderView.setNeedsDisplay()

        leftViewBackgroundView.image = self.leftViewBackgroundImage

        leftViewStyleView.effect = self.leftViewBackgroundBlurEffect

        leftViewCoverView.backgroundColor = self.leftViewCoverColor
        leftViewCoverView.effect = self.leftViewCoverBlurEffect
    }

    func rightViewsStylesValidate() {
        guard let rightViewBackgroundView = self.rightViewBackgroundView,
              let rightViewBorderView = self.rightViewBorderView,
              let rightViewStyleView = self.rightViewEffectView,
              let rightViewCoverView = self.rightViewCoverView else { return }

        rightViewBorderView.fillColor = self.isRightViewAlwaysVisibleForCurrentOrientation ? self.rightViewBackgroundColor.withAlphaComponent(1.0) : self.rightViewBackgroundColor
        rightViewBorderView.strokeColor = self.rightViewLayerBorderColor
        rightViewBorderView.strokeWidth = self.rightViewLayerBorderWidth
        rightViewBorderView.shadowColor = self.rightViewLayerShadowColor
        rightViewBorderView.shadowBlur = self.rightViewLayerShadowRadius
        rightViewBorderView.alpha = self.rightViewBackgroundAlpha
        rightViewBorderView.setNeedsDisplay()

        rightViewBackgroundView.image = self.rightViewBackgroundImage

        rightViewStyleView.effect = self.rightViewBackgroundBlurEffect

        rightViewCoverView.backgroundColor = self.rightViewCoverColor
        rightViewCoverView.effect = self.rightViewCoverBlurEffect
    }
    
}
