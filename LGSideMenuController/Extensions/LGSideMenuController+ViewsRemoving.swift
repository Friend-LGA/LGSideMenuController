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

    // Note:
    // We don't nullify any of rootView, rootViewController, leftView, leftViewController, rightView, rightViewController
    // because we don't manage their lifecycle from here, they should be assigned from the outside.

    // MARK: - Root View -

    func removeRootViewController() {
        if let rootViewController = self.rootViewController {
            LGSideMenuHelper.setSideMenuController(nil, to: rootViewController)
            rootViewController.removeFromParent()
        }
    }

    func removeRootView() {
        if let rootView = self.rootView {
            rootView.removeFromSuperview()
        }
    }

    func removeRootDependentViews() {
        if let containerView = self.rootContainerView {
            containerView.removeFromSuperview()
            self.rootContainerView = nil
        }

        if let backgroundDecorationView = self.rootViewBackgroundDecorationView {
            backgroundDecorationView.removeFromSuperview()
            self.rootViewBackgroundDecorationView = nil
        }

        if let backgroundShadowView = self.rootViewBackgroundShadowView {
            backgroundShadowView.removeFromSuperview()
            self.rootViewBackgroundShadowView = nil
        }

        if let wrapperView = self.rootViewWrapperView {
            wrapperView.removeFromSuperview()
            self.rootViewWrapperView = nil
        }

        if let coverView = self.rootViewCoverView {
            coverView.removeFromSuperview()
            self.rootViewCoverView = nil
        }
    }

    // MARK: - Left View -

    func removeLeftViewController() {
        if let leftViewController = self.leftViewController {
            LGSideMenuHelper.setSideMenuController(nil, to: leftViewController)
            leftViewController.removeFromParent()
        }
    }

    func removeLeftView() {
        if let leftView = self.leftView {
            leftView.removeFromSuperview()
        }
    }

    func removeLeftDependentViews() {
        if let containerView = self.leftContainerView {
            containerView.removeFromSuperview()
            self.leftContainerView = nil
        }

        if let backgroundDecorationView = self.leftViewBackgroundDecorationView {
            backgroundDecorationView.removeFromSuperview()
            self.leftViewBackgroundDecorationView = nil
        }

        if let backgroundShadowView = self.leftViewBackgroundShadowView {
            backgroundShadowView.removeFromSuperview()
            self.leftViewBackgroundShadowView = nil
        }

        if let backgroundImageView = self.leftViewBackgroundImageView {
            backgroundImageView.removeFromSuperview()
            self.leftViewBackgroundImageView = nil
        }

        if let backgroundView = self.leftViewBackgroundView {
            backgroundView.removeFromSuperview()
            // We don't nullify it because it is custom property
        }

        if let backgroundEffectView = self.leftViewBackgroundEffectView {
            backgroundEffectView.removeFromSuperview()
            self.leftViewBackgroundEffectView = nil
        }

        if let backgroundWrapperView = self.leftViewBackgroundWrapperView {
            backgroundWrapperView.removeFromSuperview()
            self.leftViewBackgroundWrapperView = nil
        }

        if let wrapperView = self.leftViewWrapperView {
            wrapperView.removeFromSuperview()
            self.leftViewWrapperView = nil
        }

        if let coverView = self.leftViewCoverView {
            coverView.removeFromSuperview()
            self.leftViewCoverView = nil
        }
    }

    // MARK: - Right View -

    func removeRightViewController() {
        if let rightViewController = self.rightViewController {
            LGSideMenuHelper.setSideMenuController(nil, to: rightViewController)
            rightViewController.removeFromParent()
        }
    }

    func removeRightView() {
        if let rightView = self.rightView {
            rightView.removeFromSuperview()
        }
    }

    func removeRightDependentViews() {
        if let containerView = self.rightContainerView {
            containerView.removeFromSuperview()
            self.rightContainerView = nil
        }

        if let backgroundDecorationView = self.rightViewBackgroundDecorationView {
            backgroundDecorationView.removeFromSuperview()
            self.rightViewBackgroundDecorationView = nil
        }

        if let backgroundShadowView = self.rightViewBackgroundShadowView {
            backgroundShadowView.removeFromSuperview()
            self.rightViewBackgroundShadowView = nil
        }

        if let backgroundImageView = self.rightViewBackgroundImageView {
            backgroundImageView.removeFromSuperview()
            self.rightViewBackgroundImageView = nil
        }

        if let backgroundView = self.rightViewBackgroundView {
            backgroundView.removeFromSuperview()
            // We don't nullify it because it is custom property
        }

        if let backgroundEffectView = self.rightViewBackgroundEffectView {
            backgroundEffectView.removeFromSuperview()
            self.rightViewBackgroundEffectView = nil
        }

        if let backgroundWrapperView = self.rightViewBackgroundWrapperView {
            backgroundWrapperView.removeFromSuperview()
            self.rightViewBackgroundWrapperView = nil
        }

        if let wrapperView = self.rightViewWrapperView {
            wrapperView.removeFromSuperview()
            self.rightViewWrapperView = nil
        }

        if let coverView = self.rightViewCoverView {
            coverView.removeFromSuperview()
            self.rightViewCoverView = nil
        }
    }

}
