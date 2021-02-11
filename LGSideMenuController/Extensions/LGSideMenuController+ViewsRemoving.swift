//
//  LGSideMenuController+ViewsRemoving.swift
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

    // MARK: - Root View

    func removeRootViews() {
        self.removeRootViewController()

        if let rootView = self.rootView {
            rootView.removeFromSuperview()
            self.rootView = nil
        }

        if let rootContainerView = self.rootContainerView {
            rootContainerView.removeFromSuperview()
            self.rootContainerView = nil
        }

        if let rootViewCoverView = self.rootViewCoverView {
            rootViewCoverView.removeFromSuperview()
            self.rootViewCoverView = nil
        }

        if let rootViewBorderView = self.rootViewBorderView {
            rootViewBorderView.removeFromSuperview()
            self.rootViewBorderView = nil
        }
    }

    func removeRootViewController() {
        if let rootViewController = self.rootViewController {
            LGSideMenuHelper.setSideMenuController(nil, to: rootViewController)
            rootViewController.view.removeFromSuperview()
            rootViewController.removeFromParent()
            self.rootViewController = nil
        }
    }

    // MARK: - Left View

    func removeLeftViews() {
        self.removeLeftViewController()

        if let leftView = self.leftView {
            leftView.removeFromSuperview()
            self.leftView = nil
        }

        if let leftContainerView = self.leftContainerView {
            leftContainerView.removeFromSuperview()
            self.leftContainerView = nil
        }

        if let leftViewCoverView = self.leftViewCoverView {
            leftViewCoverView.removeFromSuperview()
            self.leftViewCoverView = nil
        }

        if let leftViewStyleView = self.leftViewEffectView {
            leftViewStyleView.removeFromSuperview()
            self.leftViewEffectView = nil
        }

        if let leftViewBorderView = self.leftViewBorderView {
            leftViewBorderView.removeFromSuperview()
            self.leftViewBorderView = nil
        }

        if let leftViewBackgroundView = self.leftViewBackgroundView {
            leftViewBackgroundView.removeFromSuperview()
            self.leftViewBackgroundView = nil
        }
    }

    func removeLeftViewController() {
        if let leftViewController = self.leftViewController {
            LGSideMenuHelper.setSideMenuController(nil, to: leftViewController)
            leftViewController.view.removeFromSuperview()
            leftViewController.removeFromParent()
            self.leftViewController = nil
        }
    }

    // MARK: - Right View

    func removeRightViews() {
        self.removeRightViewController()

        if let rightView = self.rightView {
            rightView.removeFromSuperview()
            self.rightView = nil
        }

        if let rightContainerView = self.rightContainerView {
            rightContainerView.removeFromSuperview()
            self.rightContainerView = nil
        }

        if let rightViewCoverView = self.rightViewCoverView {
            rightViewCoverView.removeFromSuperview()
            self.rightViewCoverView = nil
        }

        if let rightViewStyleView = self.rightViewEffectView {
            rightViewStyleView.removeFromSuperview()
            self.rightViewEffectView = nil
        }

        if let rightViewBorderView = self.rightViewBorderView {
            rightViewBorderView.removeFromSuperview()
            self.rightViewBorderView = nil
        }

        if let rightViewBackgroundView = self.rightViewBackgroundView {
            rightViewBackgroundView.removeFromSuperview()
            self.rightViewBackgroundView = nil
        }
    }

    func removeRightViewController() {
        if let rightViewController = self.rightViewController {
            LGSideMenuHelper.setSideMenuController(nil, to: rightViewController)
            rightViewController.view.removeFromSuperview()
            rightViewController.removeFromParent()
            self.rightViewController = nil
        }
    }

}
