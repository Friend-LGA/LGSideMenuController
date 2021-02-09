//
//  LGSideMenuViewsFramesValidating.swift
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

    func viewsFramesValidate() {
        self.rootViewsFramesValidate()
        self.leftViewsFramesValidate()
        self.rightViewsFramesValidate()
    }

    func rootViewsFramesValidate() {
        guard let rootView = self.rootView,
              let rootContainerView = self.rootContainerView,
              let rootViewBorderView = self.rootViewBorderView,
              let rootViewCoverView = self.rootViewCoverView else { return }

        var containerViewFrame = self.view.bounds
        let offset = self.rootViewLayerBorderWidth + self.rootViewLayerShadowRadius

        if self.leftView != nil && self.isLeftViewAlwaysVisibleForCurrentOrientation {
            containerViewFrame.origin.x += self.leftViewWidth;
            containerViewFrame.size.width -= self.leftViewWidth;
        }

        if self.rightView != nil && self.isRightViewAlwaysVisibleForCurrentOrientation {
            containerViewFrame.size.width -= self.rightViewWidth;
        }

        rootContainerView.transform = .identity
        rootContainerView.frame = containerViewFrame

        rootViewBorderView.transform = .identity
        rootViewBorderView.frame = CGRect(x: -offset,
                                          y: -offset,
                                          width: containerViewFrame.width + (offset * 2.0),
                                          height: containerViewFrame.height + (offset * 2.0))

        rootView.transform = .identity
        rootView.frame = rootContainerView.bounds

        rootViewCoverView.transform = .identity
        rootViewCoverView.frame = rootContainerView.bounds
    }

    func leftViewsFramesValidate() {
        guard let leftView = self.leftView,
              let leftContainerView = self.leftContainerView,
              let leftViewBackgroundView = self.leftViewBackgroundView,
              let leftViewBorderView = self.leftViewBorderView,
              let leftViewStyleView = self.leftViewStyleView,
              let leftViewCoverView = self.leftViewCoverView else { return }

        var containerViewFrame = self.view.bounds
        let offset = self.leftViewLayerBorderWidth + self.leftViewLayerShadowRadius

        if self.leftViewPresentationStyle == .slideAbove {
            containerViewFrame.size.width = self.leftViewWidth
        }

        leftContainerView.transform = .identity
        leftContainerView.frame = containerViewFrame

        var backgroundViewFrame = leftContainerView.bounds
        if self.isLeftViewAlwaysVisibleForCurrentOrientation || self.isRightViewAlwaysVisibleForCurrentOrientation {
            let ratio = self.rightViewWidth / self.leftViewWidth
            backgroundViewFrame.size.width = containerViewFrame.width / (ratio + 1.0)
        }

        leftViewBackgroundView.transform = .identity
        leftViewBackgroundView.frame = backgroundViewFrame

        var leftViewFrame = CGRect(origin: .zero, size: containerViewFrame.size)
        leftViewFrame.size.width = self.leftViewWidth

        leftViewStyleView.transform = .identity
        leftViewStyleView.frame = leftViewFrame

        leftViewBorderView.transform = .identity
        leftViewBorderView.frame = CGRect(x: -offset,
                                          y: -offset,
                                          width: leftViewFrame.width + (offset * 2.0),
                                          height: leftViewFrame.height + (offset * 2.0))

        leftView.transform = .identity
        leftView.frame = leftViewFrame

        leftViewCoverView.transform = .identity
        leftViewCoverView.frame = leftContainerView.bounds
    }

    func rightViewsFramesValidate() {
        guard let rightView = self.rightView,
              let rightContainerView = self.rightContainerView,
              let rightViewBackgroundView = self.rightViewBackgroundView,
              let rightViewBorderView = self.rightViewBorderView,
              let rightViewStyleView = self.rightViewStyleView,
              let rightViewCoverView = self.rightViewCoverView else { return }

        var containerViewFrame = self.view.bounds
        let offset = self.rightViewLayerBorderWidth + self.rightViewLayerShadowRadius

        if self.rightViewPresentationStyle == .slideAbove {
            containerViewFrame.size.width = self.rightViewWidth
            containerViewFrame.origin.x = self.view.bounds.width - containerViewFrame.width
        }

        rightContainerView.transform = .identity
        rightContainerView.frame = containerViewFrame

        var backgroundViewFrame = rightContainerView.bounds
        if self.isLeftViewAlwaysVisibleForCurrentOrientation || self.isRightViewAlwaysVisibleForCurrentOrientation {
            let ratio = self.rightViewWidth / self.leftViewWidth
            backgroundViewFrame.size.width = containerViewFrame.width / (ratio + 1.0)
            backgroundViewFrame.origin.x = containerViewFrame.width - backgroundViewFrame.width
        }

        rightViewBackgroundView.transform = .identity
        rightViewBackgroundView.frame = rightContainerView.bounds

        var rightViewFrame = CGRect(origin: .zero, size: containerViewFrame.size)
        rightViewFrame.origin.x = containerViewFrame.width - self.rightViewWidth
        rightViewFrame.size.width = self.rightViewWidth

        rightViewStyleView.transform = .identity
        rightViewStyleView.frame = rightViewFrame

        rightViewBorderView.transform = .identity
        rightViewBorderView.frame = CGRect(x: -offset,
                                          y: -offset,
                                          width: rightViewFrame.width + (offset * 2.0),
                                          height: rightViewFrame.height + (offset * 2.0))

        rightView.transform = .identity
        rightView.frame = rightViewFrame

        rightViewCoverView.transform = .identity
        rightViewCoverView.frame = rightContainerView.bounds
    }
    
}
