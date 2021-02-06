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

extension LGSideMenuController {

    open override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        let size = self.view.bounds.size
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

    /// Invalidates the current layout and triggers a layout update during the next update cycle.
    open func setNeedsUpdateLayoutsAndStyles() {
        self.isNeedsUpdateLayoutsAndStyles = true
        if self.isViewLoaded {
            self.view.setNeedsLayout()
        }
    }

    /// Invalidates the current layout and triggers a layout update during the next update cycle.
    open func setNeedsUpdateRootViewLayoutsAndStyles() {
        self.isNeedsUpdateRootViewLayoutsAndStyles = true
        if self.isViewLoaded {
            self.view.setNeedsLayout()
        }
    }

    /// Invalidates the current layout and triggers a layout update during the next update cycle.
    open func setNeedsUpdateLeftViewLayoutsAndStyles() {
        self.isNeedsUpdateLeftViewLayoutsAndStyles = true
        if self.isViewLoaded {
            self.view.setNeedsLayout()
        }
    }

    /// Invalidates the current layout and triggers a layout update during the next update cycle.
    open func setNeedsUpdateRightViewLayoutsAndStyles() {
        self.isNeedsUpdateRightViewLayoutsAndStyles = true
        if self.isViewLoaded {
            self.view.setNeedsLayout()
        }
    }

    /// Force update layouts and styles for all views
    open func updateLayoutsAndStyles() {
        self.isNeedsUpdateLayoutsAndStyles = false
        self.isNeedsUpdateRootViewLayoutsAndStyles = false
        self.isNeedsUpdateLeftViewLayoutsAndStyles = false
        self.isNeedsUpdateRightViewLayoutsAndStyles = false

        self.validateViewsInit()
        self.validateViewsHierarchy()
        self.validateViewsFrames()
        self.validateViewsStyles()
        self.validateViewsTransforms()
        self.validateViewsVisibility()
    }

    /// Force update layouts and styles for root views
    open func updateRootViewLayoutsAndStyles() {
        self.isNeedsUpdateRootViewLayoutsAndStyles = false

        self.validateRootViewsInit()
        self.validateViewsHierarchy() // Whole hierarchy should be validated
        self.validateRootViewsFrames()
        self.validateRootViewsStyles()
        self.validateRootViewsTransforms()
        self.validateRootViewsVisibility()
    }

    /// Force update layouts and styles for left views
    open func updateLeftViewLayoutsAndStyles() {
        self.isNeedsUpdateLeftViewLayoutsAndStyles = false

        self.validateLeftViewsInit()
        self.validateViewsHierarchy() // Whole hierarchy should be validated
        self.validateLeftViewsFrames()
        self.validateLeftViewsStyles()
        self.validateLeftViewsTransforms()
        self.validateLeftViewsVisibility()
    }

    /// Force update layouts and styles for right views
    open func updateRightViewLayoutsAndStyles() {
        self.isNeedsUpdateRightViewLayoutsAndStyles = false

        self.validateRightViewsInit()
        self.validateViewsHierarchy() // Whole hierarchy should be validated
        self.validateRightViewsFrames()
        self.validateRightViewsStyles()
        self.validateRightViewsTransforms()
        self.validateRightViewsVisibility()
    }

}
