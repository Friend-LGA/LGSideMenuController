//
//  LGSideMenuViewsHierarchyValidating.swift
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

    func viewsHierarchyValidate() {
        self.rootViewsHierarchyValidate()
        self.leftViewsHierarchyValidate()
        self.rightViewsHierarchyValidate()
    }

    func rootViewsHierarchyValidate() {
        guard let rootView = self.rootView,
              let rootContainerView = self.rootContainerView,
              let rootViewBorderView = self.rootViewBorderView,
              let rootViewCoverView = self.rootViewCoverView else { return }

        self.view.insertSubview(rootContainerView, at: 0)

        rootContainerView.insertSubview(rootViewBorderView, at: 0)
        rootContainerView.insertSubview(rootView, at: 1)
        rootContainerView.insertSubview(rootViewCoverView, at: 2)
    }

    func leftViewsHierarchyValidate() {
        guard let rootView = self.rootView,
              let leftView = self.leftView,
              let leftContainerView = self.leftContainerView,
              let leftViewBackgroundView = self.leftViewBackgroundView,
              let leftViewBorderView = self.leftViewBorderView,
              let leftViewStyleView = self.leftViewStyleView,
              let leftViewCoverView = self.leftViewCoverView else { return }

        if self.leftViewPresentationStyle == .slideAbove {
            self.view.insertSubview(leftContainerView, aboveSubview: rootView)
        }
        else {
            self.view.insertSubview(leftContainerView, belowSubview: rootView)
        }

        leftContainerView.insertSubview(leftViewBackgroundView, at: 0)
        leftContainerView.insertSubview(leftViewStyleView, at: 1)
        leftContainerView.insertSubview(leftView, at: 2)
        leftContainerView.insertSubview(leftViewCoverView, at: 3)

        leftViewStyleView.contentView.insertSubview(leftViewBorderView, at: 0)
    }

    func rightViewsHierarchyValidate() {
        guard let rootView = self.rootView,
              let rightView = self.rightView,
              let rightContainerView = self.rightContainerView,
              let rightViewBackgroundView = self.rightViewBackgroundView,
              let rightViewBorderView = self.rightViewBorderView,
              let rightViewStyleView = self.rightViewStyleView,
              let rightViewCoverView = self.rightViewCoverView else { return }

        if self.rightViewPresentationStyle == .slideAbove {
            self.view.insertSubview(rightContainerView, aboveSubview: rootView)
        }
        else {
            self.view.insertSubview(rightContainerView, belowSubview: rootView)
        }

        rightContainerView.insertSubview(rightViewBackgroundView, at: 0)
        rightContainerView.insertSubview(rightViewStyleView, at: 1)
        rightContainerView.insertSubview(rightView, at: 2)
        rightContainerView.insertSubview(rightViewCoverView, at: 3)

        rightViewStyleView.contentView.insertSubview(rightViewBorderView, at: 0)
    }
    
}
