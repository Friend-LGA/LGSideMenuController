//
//  LGSideMenuController+States.swift
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

    /// Is root view fully opened
    open var isRootViewShowing: Bool {
        return self.state == .rootViewIsShowing
    }

    /// Is left view fully opened
    open var isLeftViewShowing: Bool {
        return self.state == .leftViewIsShowing
    }

    /// Is right view fully opened
    open var isRightViewShowing: Bool {
        return self.state == .rightViewIsShowing
    }

    /// Is either left or right view fully opened
    open var isSideViewShowing: Bool {
        return self.isLeftViewShowing || self.isRightViewShowing
    }

    /// Is left view showing or will show or will hide right now
    open var isLeftViewVisible: Bool {
        return self.state.isLeftViewVisible
    }

    /// Is right view showing or will show or will hide right now
    open var isRightViewVisible: Bool {
        return self.state.isRightViewVisible
    }

    /// Is either left or right view showing or will show or will hide right now
    open var isSideViewVisible: Bool {
        return self.isLeftViewVisible || self.isRightViewVisible
    }

    /// Is left view fully closed
    open var isRootViewHidden: Bool {
        return self.state.isRootViewHidden
    }

    /// Is left view fully closed
    open var isLeftViewHidden: Bool {
        return self.state.isLeftViewHidden
    }

    /// Is right view fully closed
    open var isRightViewHidden: Bool {
        return self.state.isRightViewHidden
    }

    /// Is either left or right view fully closed
    open var isSideViewHidden: Bool {
        return self.isLeftViewHidden || self.isRightViewHidden
    }

    /// Is left view currently will show or hide
    open var isLeftViewVisibilityChanging: Bool {
        return self.state == .leftViewWillShow || self.state == .leftViewWillHide
    }

    /// Is right view currently will show or hide
    open var isRightViewVisibilityChanging: Bool {
        return self.state == .rightViewWillShow || self.state == .rightViewWillHide
    }

    /// Is either left or right view currently will show or hide
    open var isSideViewVisibilityChanging: Bool {
        return self.isLeftViewVisibilityChanging || self.isRightViewVisibilityChanging
    }

    /// Is left view currently fully open or close
    open var isLeftViewVisibilityStable: Bool {
        return self.state != .leftViewWillShow && self.state != .leftViewWillHide
    }

    /// Is right view currently fully open or close
    open var isRightViewVisibilityStable: Bool {
        return self.state != .rightViewWillShow && self.state != .rightViewWillHide
    }

    /// Is either left or right view currently fully open or close
    open var isSideViewVisibilityStable: Bool {
        return self.isLeftViewVisibilityStable || self.isRightViewVisibilityStable
    }

    /// Is left view suppose to be "always visible" for current orientation
    open var isLeftViewAlwaysVisibleForCurrentOrientation: Bool {
        return self.leftViewAlwaysVisibleOptions.isAlwaysVisibleForCurrentOrientation
    }

    /// Is right view suppose to be "always visible" for current orientation
    open var isRightViewAlwaysVisibleForCurrentOrientation: Bool {
        return self.rightViewAlwaysVisibleOptions.isAlwaysVisibleForCurrentOrientation
    }

    /// Is any of side views suppose to be "always visible" for current orientation
    open var isSideViewAlwaysVisibleForCurrentOrientation: Bool {
        return self.isLeftViewAlwaysVisibleForCurrentOrientation ||
            self.isRightViewAlwaysVisibleForCurrentOrientation
    }

    /// Is left view suppose to be "always visible" for given orientation
    open func isLeftViewAlwaysVisibleForOrientation(_ orientation: UIInterfaceOrientation) -> Bool {
        return self.leftViewAlwaysVisibleOptions.isAlwaysVisibleForOrientation(orientation)
    }

    /// Is right view suppose to be "always visible" for given orientation
    open func isRightViewAlwaysVisibleForOrientation(_ orientation: UIInterfaceOrientation) -> Bool {
        return self.rightViewAlwaysVisibleOptions.isAlwaysVisibleForOrientation(orientation)
    }

    /// Is any of side views suppose to be "always visible" for given orientation
    open func isSideViewAlwaysVisibleForOrientation(_ orientation: UIInterfaceOrientation) -> Bool {
        return self.isLeftViewAlwaysVisibleForOrientation(orientation) ||
            self.isRightViewAlwaysVisibleForOrientation(orientation)
    }

    /// Is left view showing or always showing or will show or will hide right now
    open var isLeftViewVisibleToUser: Bool {
        return self.isLeftViewVisible || self.isLeftViewAlwaysVisibleForCurrentOrientation
    }

    /// Is right view showing or always showing or will show or will hide right now
    open var isRightViewVisibleToUser: Bool {
        return self.isRightViewVisible || self.isRightViewAlwaysVisibleForCurrentOrientation
    }

}
