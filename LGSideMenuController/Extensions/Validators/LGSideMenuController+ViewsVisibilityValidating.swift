//
//  LGSideMenuViewsVisibilityValidating.swift
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

    func viewsVisibilityValidate() {
        self.rootViewsVisibilityValidate()
        self.leftViewsVisibilityValidate()
        self.rightViewsVisibilityValidate()
    }

    func rootViewsVisibilityValidate() {
        guard let rootViewBorderView = self.rootViewBorderView,
              let rootViewCoverView = self.rootViewCoverView else { return }

        rootViewBorderView.isHidden = self.isRootViewShowing
        rootViewCoverView.isHidden = self.isRootViewShowing
    }

    func leftViewsVisibilityValidate() {
        guard let leftContainerView = self.leftContainerView,
              let leftViewCoverView = self.leftViewCoverView else { return }

        leftContainerView.isHidden = !(self.isLeftViewVisible || self.isLeftViewAlwaysVisibleForCurrentOrientation)
        leftViewCoverView.isHidden = self.isLeftViewShowing || self.isLeftViewAlwaysVisibleForCurrentOrientation
    }

    func rightViewsVisibilityValidate() {
        guard let rightContainerView = self.rightContainerView,
              let rightViewCoverView = self.rightViewCoverView else { return }

        rightContainerView.isHidden = !(self.isRightViewVisible || self.isRightViewAlwaysVisibleForCurrentOrientation)
        rightViewCoverView.isHidden = self.isRightViewShowing || self.isRightViewAlwaysVisibleForCurrentOrientation
    }

}
