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
              let containerView = self.rootContainerView,
              let backgroundDecorationView = self.rootViewBackgroundDecorationView,
              let backgroundShadowView = self.rootViewBackgroundShadowView,
              let wrapperView = self.rootViewWrapperView,
              let coverView = self.rootViewCoverView else { return }

        self.view.insertSubview(containerView, at: 0)

        containerView.insertSubview(backgroundDecorationView, at: 0)
        containerView.insertSubview(wrapperView, at: 1)
        containerView.insertSubview(coverView, at: 2)

        backgroundDecorationView.insertSubview(backgroundShadowView, at: 0)

        wrapperView.insertSubview(rootView, at: 0)
    }

    func validateLeftViewsHierarchy() {
        guard let rootContainerView = self.rootContainerView,
              let leftView = self.leftView,
              let containerView = self.leftContainerView,
              let backgroundDecorationView = self.leftViewBackgroundDecorationView,
              let backgroundShadowView = self.leftViewBackgroundShadowView,
              let backgroundWrapperView = self.leftViewBackgroundWrapperView,
              let backgroundEffectView = self.leftViewBackgroundEffectView,
              let wrapperView = self.leftViewWrapperView,
              let coverView = self.leftViewCoverView else { return }

        if self.leftViewPresentationStyle.isAbove {
            self.view.insertSubview(containerView, aboveSubview: rootContainerView)
        }
        else {
            self.view.insertSubview(containerView, belowSubview: rootContainerView)
        }

        containerView.insertSubview(backgroundDecorationView, at: 0)
        containerView.insertSubview(wrapperView, at: 1)
        containerView.insertSubview(coverView, at: 2)

        backgroundDecorationView.insertSubview(backgroundShadowView, at: 0)
        backgroundDecorationView.insertSubview(backgroundEffectView, at: 1)
        backgroundDecorationView.insertSubview(backgroundWrapperView, at: 2)

        if let backgroundImageView = self.leftViewBackgroundImageView {
            backgroundWrapperView.insertSubview(backgroundImageView, at: 0)
        }
        else if let backgroundView = self.leftViewBackgroundView {
            backgroundWrapperView.insertSubview(backgroundView, at: 0)
        }

        wrapperView.insertSubview(leftView, at: 0)
    }

    func validateRightViewsHierarchy() {
        guard let rootContainerView = self.rootContainerView,
              let rightView = self.rightView,
              let containerView = self.rightContainerView,
              let backgroundDecorationView = self.rightViewBackgroundDecorationView,
              let backgroundShadowView = self.rightViewBackgroundShadowView,
              let backgroundWrapperView = self.rightViewBackgroundWrapperView,
              let backgroundEffectView = self.rightViewBackgroundEffectView,
              let wrapperView = self.rightViewWrapperView,
              let coverView = self.rightViewCoverView else { return }

        if self.rightViewPresentationStyle.isAbove {
            self.view.insertSubview(containerView, aboveSubview: rootContainerView)
        }
        else {
            self.view.insertSubview(containerView, belowSubview: rootContainerView)
        }

        containerView.insertSubview(backgroundDecorationView, at: 0)
        containerView.insertSubview(wrapperView, at: 1)
        containerView.insertSubview(coverView, at: 2)

        backgroundDecorationView.insertSubview(backgroundShadowView, at: 0)
        backgroundDecorationView.insertSubview(backgroundEffectView, at: 1)
        backgroundDecorationView.insertSubview(backgroundWrapperView, at: 2)

        if let backgroundImageView = self.rightViewBackgroundImageView {
            backgroundWrapperView.insertSubview(backgroundImageView, at: 0)
        }
        else if let backgroundView = self.rightViewBackgroundView {
            backgroundWrapperView.insertSubview(backgroundView, at: 0)
        }

        wrapperView.insertSubview(rightView, at: 0)
    }
    
}
