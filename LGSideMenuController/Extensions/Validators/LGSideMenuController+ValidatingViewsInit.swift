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

        if self.rootViewShadowView == nil {
            self.rootViewShadowView = LGSideMenuShadowView()
            defaultRootViewSetup(self.rootViewShadowView)
        }

        if self.rootViewBackgroundView == nil {
            self.rootViewBackgroundView = LGSideMenuBackgroundView()
            defaultRootViewSetup(self.rootViewBackgroundView)
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
            defaultLeftViewSetup(self.leftContainerView, true)
        }

        if self.leftViewShadowView == nil {
            self.leftViewShadowView = LGSideMenuShadowView()
            defaultLeftViewSetup(self.leftViewShadowView)
        }

        if self.leftViewBackgroundView == nil {
            self.leftViewBackgroundView = LGSideMenuBackgroundView()
            defaultLeftViewSetup(self.leftViewBackgroundView)
        }

        if self.leftViewBackgroundImageView == nil {
            self.leftViewBackgroundImageView = UIImageView()
            self.leftViewBackgroundImageView?.clipsToBounds = true
            self.leftViewBackgroundImageView?.contentMode = .scaleAspectFill
            defaultLeftViewSetup(self.leftViewBackgroundImageView)
        }

        if self.leftViewEffectView == nil {
            self.leftViewEffectView = UIVisualEffectView()
            defaultLeftViewSetup(self.leftViewEffectView)
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
    }

    func validateRightViewsInit() {
        guard self.rightView != nil else { return }

        if self.rightContainerView == nil {
            self.rightContainerView = UIView()
            defaultRightViewSetup(self.rightContainerView, true)
        }

        if self.rightViewShadowView == nil {
            self.rightViewShadowView = LGSideMenuShadowView()
            defaultRightViewSetup(self.rightViewShadowView)
        }

        if self.rightViewBackgroundView == nil {
            self.rightViewBackgroundView = LGSideMenuBackgroundView()
            defaultRightViewSetup(self.rightViewBackgroundView)
        }

        if self.rightViewBackgroundImageView == nil {
            self.rightViewBackgroundImageView = UIImageView()
            self.rightViewBackgroundImageView?.clipsToBounds = true
            self.rightViewBackgroundImageView?.contentMode = .scaleAspectFill
            defaultRightViewSetup(self.rightViewBackgroundImageView)
        }

        if self.rightViewEffectView == nil {
            self.rightViewEffectView = UIVisualEffectView()
            defaultRightViewSetup(self.rightViewEffectView)
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
