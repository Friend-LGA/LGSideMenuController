//
//  LGSideMenuController+ValidatingViewsVisibility.swift
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

    func validateViewsVisibility() {
        self.validateRootViewsVisibility()
        self.validateLeftViewsVisibility()
        self.validateRightViewsVisibility()
    }

    func validateRootViewsVisibility() {
        guard self.shouldUpdateVisibility == true,
              let rootViewShadowView = self.rootViewShadowView,
              let rootViewCoverView = self.rootViewCoverView else { return }

        rootViewShadowView.isHidden = self.isRootViewShowing && !self.isLeftViewAlwaysVisibleForCurrentOrientation && !self.isRightViewAlwaysVisibleForCurrentOrientation
        rootViewCoverView.isHidden = self.isRootViewShowing
    }

    func validateLeftViewsVisibility() {
        guard self.shouldUpdateVisibility == true,
              let leftContainerView = self.leftContainerView,
              let leftViewCoverView = self.leftViewCoverView else { return }

        leftContainerView.isHidden = !self.isLeftViewVisibleToUser
        leftViewCoverView.isHidden = self.isLeftViewShowing || (self.isLeftViewAlwaysVisibleForCurrentOrientation && !self.isRightViewVisible)
    }

    func validateRightViewsVisibility() {
        guard self.shouldUpdateVisibility == true,
              let rightContainerView = self.rightContainerView,
              let rightViewCoverView = self.rightViewCoverView else { return }

        rightContainerView.isHidden = !self.isRightViewVisibleToUser
        rightViewCoverView.isHidden = self.isRightViewShowing || (self.isRightViewAlwaysVisibleForCurrentOrientation && !self.isLeftViewVisible)
    }

}
