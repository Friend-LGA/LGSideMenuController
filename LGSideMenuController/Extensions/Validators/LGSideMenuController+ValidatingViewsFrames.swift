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
              let rootViewBorderView = self.rootViewBorderView,
              let rootViewWrapperView = self.rootViewWrapperView,
              let rootViewCoverView = self.rootViewCoverView else { return }

        var containerViewFrame = self.view.bounds

        if self.leftView != nil && self.isLeftViewAlwaysVisibleForCurrentOrientation {
            containerViewFrame.origin.x += self.leftViewWidth
            containerViewFrame.size.width -= self.leftViewWidth
        }

        if self.rightView != nil && self.isRightViewAlwaysVisibleForCurrentOrientation {
            containerViewFrame.size.width -= self.rightViewWidth
        }

        rootContainerView.transform = .identity
        rootContainerView.frame = containerViewFrame

        let offset = self.rootViewLayerBorderWidth + self.rootViewLayerShadowRadius

        rootViewBorderView.transform = .identity
        rootViewBorderView.frame = CGRect(x: -offset,
                                          y: -offset,
                                          width: containerViewFrame.width + (offset * 2.0),
                                          height: containerViewFrame.height + (offset * 2.0))

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
              let leftViewBackgroundView = self.leftViewBackgroundView,
              let leftViewBorderView = self.leftViewBorderView,
              let leftViewStyleView = self.leftViewEffectView,
              let leftViewWrapperView = self.leftViewWrapperView,
              let leftViewCoverView = self.leftViewCoverView else { return }

        var containerViewFrame = self.view.bounds

        if self.leftViewPresentationStyle == .slideAbove {
            containerViewFrame.size.width = self.leftViewWidth
        }

        leftContainerView.transform = .identity
        leftContainerView.frame = containerViewFrame

        let offset = self.leftViewLayerBorderWidth + self.leftViewLayerShadowRadius
        var borderViewFrame = CGRect(x: -offset,
                                     y: -offset,
                                     width: containerViewFrame.width + (offset * 2.0),
                                     height: containerViewFrame.height + (offset * 2.0))

        if self.leftViewPresentationStyle != .slideAbove,
           self.isLeftViewAlwaysVisibleForCurrentOrientation || self.isRightViewAlwaysVisibleForCurrentOrientation {
            let rightViewFullWidth = self.rightViewWidth + ((self.rightViewLayerBorderWidth + self.rightViewLayerShadowRadius) * 2.0)
            borderViewFrame.size.width -= rightViewFullWidth
        }

        leftViewBorderView.transform = .identity
        leftViewBorderView.frame = borderViewFrame

        let borderViewVisisbleFrame = leftViewBorderView.bounds.insetBy(dx: offset, dy: offset)

        leftViewBackgroundView.transform = .identity
        leftViewBackgroundView.frame = borderViewVisisbleFrame

        leftViewStyleView.transform = .identity
        leftViewStyleView.frame = borderViewVisisbleFrame

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
              let rightViewBackgroundView = self.rightViewBackgroundView,
              let rightViewBorderView = self.rightViewBorderView,
              let rightViewStyleView = self.rightViewEffectView,
              let rightViewWrapperView = self.rightViewWrapperView,
              let rightViewCoverView = self.rightViewCoverView else { return }

        var containerViewFrame = self.view.bounds

        if self.rightViewPresentationStyle == .slideAbove {
            containerViewFrame.size.width = self.rightViewWidth
            containerViewFrame.origin.x = self.view.bounds.width - containerViewFrame.width
        }

        rightContainerView.transform = .identity
        rightContainerView.frame = containerViewFrame

        let offset = self.rightViewLayerBorderWidth + self.rightViewLayerShadowRadius
        var borderViewFrame = CGRect(x: -offset,
                                     y: -offset,
                                     width: containerViewFrame.width + (offset * 2.0),
                                     height: containerViewFrame.height + (offset * 2.0))

        if self.rightViewPresentationStyle != .slideAbove,
           self.isRightViewAlwaysVisibleForCurrentOrientation || self.isLeftViewAlwaysVisibleForCurrentOrientation {
            let leftViewFullWidth = self.rightViewWidth + ((self.rightViewLayerBorderWidth + self.rightViewLayerShadowRadius) * 2.0)
            borderViewFrame.size.width -= leftViewFullWidth
            borderViewFrame.origin.x += leftViewFullWidth
        }

        rightViewBorderView.transform = .identity
        rightViewBorderView.frame = borderViewFrame

        let borderViewVisisbleFrame = rightViewBorderView.bounds.insetBy(dx: offset, dy: offset)

        rightViewBackgroundView.transform = .identity
        rightViewBackgroundView.frame = borderViewVisisbleFrame

        rightViewStyleView.transform = .identity
        rightViewStyleView.frame = borderViewVisisbleFrame

        rightViewWrapperView.transform = .identity
        rightViewWrapperView.frame = CGRect(origin: CGPoint(x: containerViewFrame.width - self.rightViewWidth, y: 0.0),
                                            size: CGSize(width: self.rightViewWidth, height: containerViewFrame.height))

        rightView.transform = .identity
        rightView.frame = rightViewWrapperView.bounds

        rightViewCoverView.transform = .identity
        rightViewCoverView.frame = rightContainerView.bounds
    }
    
}
