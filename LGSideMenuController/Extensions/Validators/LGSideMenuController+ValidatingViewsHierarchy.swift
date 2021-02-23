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
              let rootViewShadowView = self.rootViewShadowView,
              let rootViewBackgroundView = self.rootViewBackgroundView,
              let rootViewWrapperView = self.rootViewWrapperView,
              let rootViewCoverView = self.rootViewCoverView else { return }

        self.view.insertSubview(rootContainerView, at: 0)

        rootContainerView.insertSubview(rootViewShadowView, at: 0)
        rootContainerView.insertSubview(rootViewBackgroundView, at: 1)
        rootContainerView.insertSubview(rootViewWrapperView, at: 2)
        rootContainerView.insertSubview(rootViewCoverView, at: 3)

        rootViewWrapperView.insertSubview(rootView, at: 0)
    }

    func validateLeftViewsHierarchy() {
        guard let rootContainerView = self.rootContainerView,
              let leftView = self.leftView,
              let leftContainerView = self.leftContainerView,
              let leftViewShadowView = self.leftViewShadowView,
              let leftViewBackgroundView = self.leftViewBackgroundView,
              let leftViewBackgroundImageView = self.leftViewBackgroundImageView,
              let leftViewStyleView = self.leftViewEffectView,
              let leftViewWrapperView = self.leftViewWrapperView,
              let leftViewCoverView = self.leftViewCoverView else { return }

        if self.leftViewPresentationStyle.isAbove {
            self.view.insertSubview(leftContainerView, aboveSubview: rootContainerView)
        }
        else {
            self.view.insertSubview(leftContainerView, belowSubview: rootContainerView)
        }

        leftContainerView.insertSubview(leftViewShadowView, at: 0)
        leftContainerView.insertSubview(leftViewBackgroundView, at: 1)
        leftContainerView.insertSubview(leftViewWrapperView, at: 2)
        leftContainerView.insertSubview(leftViewCoverView, at: 3)

        leftViewBackgroundView.insertSubview(leftViewBackgroundImageView, at: 0)
        leftViewBackgroundView.insertSubview(leftViewStyleView, at: 1)

        leftViewWrapperView.insertSubview(leftView, at: 0)
    }

    func validateRightViewsHierarchy() {
        guard let rootContainerView = self.rootContainerView,
              let rightView = self.rightView,
              let rightContainerView = self.rightContainerView,
              let rightViewShadowView = self.rightViewShadowView,
              let rightViewBackgroundView = self.rightViewBackgroundView,
              let rightViewBackgroundImageView = self.rightViewBackgroundImageView,
              let rightViewStyleView = self.rightViewEffectView,
              let rightViewWrapperView = self.rightViewWrapperView,
              let rightViewCoverView = self.rightViewCoverView else { return }

        if self.rightViewPresentationStyle.isAbove {
            self.view.insertSubview(rightContainerView, aboveSubview: rootContainerView)
        }
        else {
            self.view.insertSubview(rightContainerView, belowSubview: rootContainerView)
        }

        rightContainerView.insertSubview(rightViewShadowView, at: 0)
        rightContainerView.insertSubview(rightViewBackgroundView, at: 1)
        rightContainerView.insertSubview(rightViewWrapperView, at: 2)
        rightContainerView.insertSubview(rightViewCoverView, at: 3)

        rightViewBackgroundView.insertSubview(rightViewBackgroundImageView, at: 0)
        rightViewBackgroundView.insertSubview(rightViewStyleView, at: 1)

        rightViewWrapperView.insertSubview(rightView, at: 0)
    }
    
}
