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

public extension LGSideMenuController {

    /// Is root view fully opened
    var isRootViewShowing: Bool {
        return self.state == .rootViewIsShowing
    }

    /// Is left view fully opened
    var isLeftViewShowing: Bool {
        return self.state == .leftViewIsShowing
    }

    /// Is right view fully opened
    var isRightViewShowing: Bool {
        return self.state == .rightViewIsShowing
    }

    /// Is left view showing or going to show or going to hide right now
    var isLeftViewVisible: Bool {
        return self.state.isLeftViewVisible
    }

    /// Is right view showing or going to show or going to hide right now
    var isRightViewVisible: Bool {
        return self.state.isRightViewVisible
    }

    /// Is left view fully closed
    var isRootViewHidden: Bool {
        return self.state.isRootViewHidden
    }

    /// Is left view fully closed
    var isLeftViewHidden: Bool {
        return self.state.isLeftViewHidden
    }

    /// Is right view fully closed
    var isRightViewHidden: Bool {
        return self.state.isRightViewHidden
    }

    /// Is left view currently will show or hide
    var isLeftViewVisibilityChanging: Bool {
        return self.state == .leftViewWillShow || self.state == .leftViewWillHide
    }

    /// Is right view currently will show or hide
    var isRightViewVisibilityChanging: Bool {
        return self.state == .rightViewWillShow || self.state == .rightViewWillHide
    }

    /// Is left view currently fully open or close
    var isLeftViewVisibilityStable: Bool {
        return self.state != .leftViewWillShow && self.state != .leftViewWillHide
    }

    /// Is right view currently fully open or close
    var isRightViewVisibilityStable: Bool {
        return self.state != .rightViewWillShow && self.state != .rightViewWillHide
    }

    /// Is left view suppose to be "always visible" for current orientation
    var isLeftViewAlwaysVisibleForCurrentOrientation: Bool {
        return self.leftViewAlwaysVisibleOptions.isAlwaysVisibleForCurrentOrientation
    }

    /// Is right view suppose to be "always visible" for current orientation
    var isRightViewAlwaysVisibleForCurrentOrientation: Bool {
        return self.rightViewAlwaysVisibleOptions.isAlwaysVisibleForCurrentOrientation
    }

    /// Is left view suppose to be "always visible" for given orientation
    func isLeftViewAlwaysVisibleForOrientation(_ orientation: UIInterfaceOrientation) -> Bool {
        return self.leftViewAlwaysVisibleOptions.isAlwaysVisibleForOrientation(orientation)
    }

    /// Is right view suppose to be "always visible" for given orientation
    func isRightViewAlwaysVisibleForOrientation(_ orientation: UIInterfaceOrientation) -> Bool {
        return self.rightViewAlwaysVisibleOptions.isAlwaysVisibleForOrientation(orientation)
    }

}
