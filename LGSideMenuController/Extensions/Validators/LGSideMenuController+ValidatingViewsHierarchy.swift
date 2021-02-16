//
//  LGSideMenuController+ValidatingViewsHierarchy.swift
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

    func validateViewsHierarchy() {
        self.validateRootViewsHierarchy()
        self.validateLeftViewsHierarchy()
        self.validateRightViewsHierarchy()
    }

    func validateRootViewsHierarchy() {
        guard let rootView = self.rootView,
              let rootContainerView = self.rootContainerView,
              let rootViewBorderView = self.rootViewBorderView,
              let rootViewWrapperView = self.rootViewWrapperView,
              let rootViewCoverView = self.rootViewCoverView else { return }

        self.view.insertSubview(rootContainerView, at: 0)

        rootContainerView.insertSubview(rootViewBorderView, at: 0)
        rootContainerView.insertSubview(rootViewWrapperView, at: 1)
        rootContainerView.insertSubview(rootViewCoverView, at: 2)

        rootViewWrapperView.insertSubview(rootView, at: 0)
    }

    func validateLeftViewsHierarchy() {
        guard let rootContainerView = self.rootContainerView,
              let leftView = self.leftView,
              let leftContainerView = self.leftContainerView,
              let leftViewBackgroundView = self.leftViewBackgroundView,
              let leftViewBorderView = self.leftViewBorderView,
              let leftViewStyleView = self.leftViewEffectView,
              let leftViewWrapperView = self.leftViewWrapperView,
              let leftViewCoverView = self.leftViewCoverView else { return }

        if self.leftViewPresentationStyle == .slideAbove {
            self.view.insertSubview(leftContainerView, aboveSubview: rootContainerView)
        }
        else {
            self.view.insertSubview(leftContainerView, belowSubview: rootContainerView)
        }

        leftContainerView.insertSubview(leftViewBorderView, at: 0)
        leftContainerView.insertSubview(leftViewWrapperView, at: 1)
        leftContainerView.insertSubview(leftViewCoverView, at: 2)

        leftViewBorderView.insertSubview(leftViewBackgroundView, at: 0)
        leftViewBorderView.insertSubview(leftViewStyleView, at: 1)

        leftViewWrapperView.insertSubview(leftView, at: 0)
    }

    func validateRightViewsHierarchy() {
        guard let rootContainerView = self.rootContainerView,
              let rightView = self.rightView,
              let rightContainerView = self.rightContainerView,
              let rightViewBackgroundView = self.rightViewBackgroundView,
              let rightViewBorderView = self.rightViewBorderView,
              let rightViewStyleView = self.rightViewEffectView,
              let rightViewWrapperView = self.rightViewWrapperView,
              let rightViewCoverView = self.rightViewCoverView else { return }

        if self.rightViewPresentationStyle == .slideAbove {
            self.view.insertSubview(rightContainerView, aboveSubview: rootContainerView)
        }
        else {
            self.view.insertSubview(rightContainerView, belowSubview: rootContainerView)
        }

        rightContainerView.insertSubview(rightViewBorderView, at: 0)
        rightContainerView.insertSubview(rightViewWrapperView, at: 1)
        rightContainerView.insertSubview(rightViewCoverView, at: 2)

        rightViewBorderView.insertSubview(rightViewBackgroundView, at: 0)
        rightViewBorderView.insertSubview(rightViewStyleView, at: 1)

        rightViewWrapperView.insertSubview(rightView, at: 0)
    }
    
}
