//
//  LGSideMenuController+ValidatingViewsInit.swift
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

    func validateViewsInit() {
        self.validateRootViewsInit()
        self.validateLeftViewsInit()
        self.validateRightViewsInit()
    }

    func validateRootViewsInit() {
        guard self.rootView != nil else { return }

        if self.rootContainerView == nil {
            self.rootContainerView = UIView()
            defaultRootViewSetup(self.rootContainerView, true)
        }

        if self.rootContainerClipToBorderView == nil {
            self.rootContainerClipToBorderView = UIView()
            self.rootContainerClipToBorderView?.clipsToBounds = true
            defaultRootViewSetup(self.rootContainerClipToBorderView, true)
        }

        if self.rootViewBackgroundDecorationView == nil {
            self.rootViewBackgroundDecorationView = LGSideMenuBackgroundDecorationView()
            defaultRootViewSetup(self.rootViewBackgroundDecorationView)
        }

        if self.rootViewBackgroundShadowView == nil {
            self.rootViewBackgroundShadowView = LGSideMenuBackgroundShadowView()
            defaultRootViewSetup(self.rootViewBackgroundShadowView)
        }

        if self.rootViewWrapperView == nil {
            self.rootViewWrapperView = LGSideMenuWrapperView()
            self.rootViewWrapperView?.clipsToBounds = true
            self.rootViewWrapperView?.canLayoutSubviews = self.isRootViewLayoutingEnabled
            defaultRootViewSetup(self.rootViewWrapperView, true)
        }

        if self.rootViewCoverView == nil {
            self.rootViewCoverView = UIVisualEffectView()
            defaultRootViewSetup(self.rootViewCoverView)
        }
    }

    func validateLeftViewsInit() {
        guard self.leftView != nil else { return }

        if self.leftContainerView == nil {
            self.leftContainerView = UIView()
            self.leftContainerView?.clipsToBounds = true
            defaultLeftViewSetup(self.leftContainerView, true)
        }

        if self.leftContainerClipToBorderView == nil {
            self.leftContainerClipToBorderView = UIView()
            self.leftContainerClipToBorderView?.clipsToBounds = true
            defaultLeftViewSetup(self.leftContainerClipToBorderView, true)
        }

        if self.leftViewBackgroundDecorationView == nil {
            self.leftViewBackgroundDecorationView = LGSideMenuBackgroundDecorationView()
            defaultLeftViewSetup(self.leftViewBackgroundDecorationView)
        }

        if self.leftViewBackgroundShadowView == nil {
            self.leftViewBackgroundShadowView = LGSideMenuBackgroundShadowView()
            defaultLeftViewSetup(self.leftViewBackgroundShadowView)
        }

        if self.leftViewBackgroundEffectView == nil {
            self.leftViewBackgroundEffectView = UIVisualEffectView()
            defaultLeftViewSetup(self.leftViewBackgroundEffectView)
        }

        if self.leftViewBackgroundWrapperView == nil {
            self.leftViewBackgroundWrapperView = UIView()
            self.leftViewBackgroundWrapperView?.clipsToBounds = true
            defaultLeftViewSetup(self.leftViewBackgroundWrapperView)
        }

        if self.leftViewBackgroundImage != nil && self.leftViewBackgroundImageView == nil {
            self.leftViewBackgroundImageView = UIImageView()
            self.leftViewBackgroundImageView?.contentMode = .scaleAspectFill
            defaultLeftViewSetup(self.leftViewBackgroundImageView)
        }

        if self.leftViewWrapperView == nil {
            self.leftViewWrapperView = LGSideMenuWrapperView()
            self.leftViewWrapperView?.clipsToBounds = true
            defaultLeftViewSetup(self.leftViewWrapperView, true)
        }

        if self.leftViewCoverView == nil {
            self.leftViewCoverView = UIVisualEffectView()
            defaultLeftViewSetup(self.leftViewCoverView)
        }

        if self.leftViewStatusBarBackgroundView == nil {
            self.leftViewStatusBarBackgroundView = LGSideMenuStatusBarBackgroundView()
            defaultLeftViewSetup(self.leftViewStatusBarBackgroundView)
        }

        if self.leftViewStatusBarBackgroundEffectView == nil {
            self.leftViewStatusBarBackgroundEffectView = UIVisualEffectView()
            defaultLeftViewSetup(self.leftViewStatusBarBackgroundEffectView)
        }
    }

    func validateRightViewsInit() {
        guard self.rightView != nil else { return }

        if self.rightContainerView == nil {
            self.rightContainerView = UIView()
            self.rightContainerView?.clipsToBounds = true
            defaultRightViewSetup(self.rightContainerView, true)
        }

        if self.rightContainerClipToBorderView == nil {
            self.rightContainerClipToBorderView = UIView()
            self.rightContainerClipToBorderView?.clipsToBounds = true
            defaultRightViewSetup(self.rightContainerClipToBorderView, true)
        }

        if self.rightViewBackgroundDecorationView == nil {
            self.rightViewBackgroundDecorationView = LGSideMenuBackgroundDecorationView()
            defaultRightViewSetup(self.rightViewBackgroundDecorationView)
        }

        if self.rightViewBackgroundShadowView == nil {
            self.rightViewBackgroundShadowView = LGSideMenuBackgroundShadowView()
            defaultRightViewSetup(self.rightViewBackgroundShadowView)
        }

        if self.rightViewBackgroundEffectView == nil {
            self.rightViewBackgroundEffectView = UIVisualEffectView()
            defaultRightViewSetup(self.rightViewBackgroundEffectView)
        }

        if self.rightViewBackgroundWrapperView == nil {
            self.rightViewBackgroundWrapperView = UIView()
            self.rightViewBackgroundWrapperView?.clipsToBounds = true
            defaultRightViewSetup(self.rightViewBackgroundWrapperView)
        }

        if self.rightViewBackgroundImage != nil && self.rightViewBackgroundImageView == nil {
            self.rightViewBackgroundImageView = UIImageView()
            self.rightViewBackgroundImageView?.contentMode = .scaleAspectFill
            defaultRightViewSetup(self.rightViewBackgroundImageView)
        }

        if self.rightViewWrapperView == nil {
            self.rightViewWrapperView = LGSideMenuWrapperView()
            self.rightViewWrapperView?.clipsToBounds = true
            defaultRightViewSetup(self.rightViewWrapperView, true)
        }

        if self.rightViewCoverView == nil {
            self.rightViewCoverView = UIVisualEffectView()
            defaultRightViewSetup(self.rightViewCoverView)
        }

        if self.rightViewStatusBarBackgroundView == nil {
            self.rightViewStatusBarBackgroundView = LGSideMenuStatusBarBackgroundView()
            defaultRightViewSetup(self.rightViewStatusBarBackgroundView)
        }

        if self.rightViewStatusBarBackgroundEffectView == nil {
            self.rightViewStatusBarBackgroundEffectView = UIVisualEffectView()
            defaultRightViewSetup(self.rightViewStatusBarBackgroundEffectView)
        }
    }

    private func defaultRootViewSetup(_ view: UIView?, _ isUserInteractionEnabled: Bool = false) {
        view?.backgroundColor = .clear
        view?.isUserInteractionEnabled = isUserInteractionEnabled
    }

    private func defaultLeftViewSetup(_ view: UIView?, _ isUserInteractionEnabled: Bool = false) {
        view?.backgroundColor = .clear
        view?.isUserInteractionEnabled = isUserInteractionEnabled
        view?.layer.anchorPoint = CGPoint(x: 0.0, y: 0.5)
    }

    private func defaultRightViewSetup(_ view: UIView?, _ isUserInteractionEnabled: Bool = false) {
        view?.backgroundColor = .clear
        view?.isUserInteractionEnabled = isUserInteractionEnabled
        view?.layer.anchorPoint = CGPoint(x: 1.0, y: 0.5)
    }
    
}
