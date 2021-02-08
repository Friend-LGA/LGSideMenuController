//
//  LGSideMenuController+Layouting.swift
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

public extension LGSideMenuController {

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        let size = self.view.bounds.size;
        if self.isNeedsUpdateLayoutsAndStyles || self.savedSize != size {
            self.savedSize = size
            self.updateLayoutsAndStyles()
        }
        else if self.isNeedsUpdateRootViewLayoutsAndStyles {
            self.updateRootViewLayoutsAndStyles()
        }
        else if self.isNeedsUpdateLeftViewLayoutsAndStyles {
            self.updateLeftViewLayoutsAndStyles()
        }
        else if self.isNeedsUpdateRightViewLayoutsAndStyles {
            self.updateRightViewLayoutsAndStyles()
        }
    }

//    func rootViewLayoutSubviews(size: CGSize) {
//        guard let rootView = self.rootView else { return }
//        rootView.setNeedsLayout()
//        rootView.layoutIfNeeded()
//    }
//
//    func leftViewLayoutSubviews(size: CGSize) {
//        guard let leftView = self.leftView else { return }
//        leftView.setNeedsLayout()
//        leftView.layoutIfNeeded()
//    }
//
//    func rightViewLayoutSubviews(size: CGSize) {
//        guard let rightView = self.rightView else { return }
//        rightView.setNeedsLayout()
//        rightView.layoutIfNeeded()
//    }

    /// Invalidates the current layout and triggers a layout update during the next update cycle.
    func setNeedsUpdateLayoutsAndStyles() {
        self.isNeedsUpdateLayoutsAndStyles = true
        if self.isViewLoaded {
            self.view.setNeedsLayout()
        }
    }

    /// Invalidates the current layout and triggers a layout update during the next update cycle.
    func setNeedsUpdateRootViewLayoutsAndStyles() {
        self.isNeedsUpdateRootViewLayoutsAndStyles = true
        if self.isViewLoaded {
            self.view.setNeedsLayout()
        }
    }

    /// Invalidates the current layout and triggers a layout update during the next update cycle.
    func setNeedsUpdateLeftViewLayoutsAndStyles() {
        self.isNeedsUpdateLeftViewLayoutsAndStyles = true
        if self.isViewLoaded {
            self.view.setNeedsLayout()
        }
    }

    /// Invalidates the current layout and triggers a layout update during the next update cycle.
    func setNeedsUpdateRightViewLayoutsAndStyles() {
        self.isNeedsUpdateRightViewLayoutsAndStyles = true
        if self.isViewLoaded {
            self.view.setNeedsLayout()
        }
    }

    /// Force update layouts and styles for all views
    func updateLayoutsAndStyles() {
        self.isNeedsUpdateLayoutsAndStyles = false
        self.isNeedsUpdateRootViewLayoutsAndStyles = false
        self.isNeedsUpdateLeftViewLayoutsAndStyles = false
        self.isNeedsUpdateRightViewLayoutsAndStyles = false

        self.viewsValidate()
        self.viewsHierarchyValidate()
        self.viewsFramesValidate()
        self.viewsStylesValidate()
        self.viewsTransformsValidate()
        self.viewsVisibilityValidate()
    }

    /// Force update layouts and styles for root views
    func updateRootViewLayoutsAndStyles() {
        self.isNeedsUpdateRootViewLayoutsAndStyles = false

        self.rootViewsValidate()
        self.rootViewsHierarchyValidate()
        self.rootViewsFramesValidate()
        self.rootViewsStylesValidate()
        self.rootViewsTransformsValidate()
        self.rootViewsVisibilityValidate()
    }

    /// Force update layouts and styles for left views
    func updateLeftViewLayoutsAndStyles() {
        self.isNeedsUpdateLeftViewLayoutsAndStyles = false

        self.leftViewsValidate()
        self.leftViewsHierarchyValidate()
        self.leftViewsFramesValidate()
        self.leftViewsStylesValidate()
        self.leftViewsTransformsValidate()
        self.leftViewsVisibilityValidate()
    }

    /// Force update layouts and styles for right views
    func updateRightViewLayoutsAndStyles() {
        self.isNeedsUpdateRightViewLayoutsAndStyles = false

        self.rightViewsValidate()
        self.rightViewsHierarchyValidate()
        self.rightViewsFramesValidate()
        self.rightViewsStylesValidate()
        self.rightViewsTransformsValidate()
        self.rightViewsVisibilityValidate()
    }

}
