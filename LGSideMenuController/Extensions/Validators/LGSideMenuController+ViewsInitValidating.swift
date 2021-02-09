//
//  LGSideMenuViewsValidating.swift
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

    func viewsInitValidate() {
        self.rootViewsInitValidate()
        self.leftViewsInitValidate()
        self.rightViewsInitValidate()
    }

    func rootViewsInitValidate() {
        guard let rootView = self.rootView else { return }

        rootView.clipsToBounds = true

        if self.rootContainerView == nil {
            self.rootContainerView = UIView()
            self.rootContainerView?.backgroundColor = .clear
            self.rootContainerView?.isUserInteractionEnabled = true
        }

        if self.rootViewBorderView == nil {
            self.rootViewBorderView = LGSideMenuBorderView()
        }

        if self.rootViewCoverView == nil {
            self.rootViewCoverView = UIVisualEffectView()
            self.rootViewCoverView?.backgroundColor = .clear
            self.rootViewCoverView?.isUserInteractionEnabled = false
        }
    }

    func leftViewsInitValidate() {
        guard let leftView = self.leftView else { return }

        leftView.clipsToBounds = true
        leftView.layer.anchorPoint = CGPoint(x: 0.0, y: 0.5);

        if self.leftContainerView == nil {
            self.leftContainerView = UIView()
            self.leftContainerView?.backgroundColor = .clear
            self.leftContainerView?.isUserInteractionEnabled = true
        }

        if self.leftViewBorderView == nil {
            self.leftViewBorderView = LGSideMenuBorderView()
        }

        if self.leftViewBackgroundView == nil {
            self.leftViewBackgroundView = UIImageView()
            self.leftViewBackgroundView?.backgroundColor = .clear
            self.leftViewBackgroundView?.isUserInteractionEnabled = false
        }

        if self.leftViewStyleView == nil {
            self.leftViewStyleView = UIVisualEffectView()
            self.leftViewStyleView?.backgroundColor = .clear
            self.leftViewStyleView?.isUserInteractionEnabled = false
            self.leftViewStyleView?.layer.anchorPoint = CGPoint(x: 0.0, y: 0.5);
        }

        if self.leftViewCoverView == nil {
            self.leftViewCoverView = UIVisualEffectView()
            self.leftViewCoverView?.backgroundColor = .clear
            self.leftViewCoverView?.isUserInteractionEnabled = false
        }
    }

    func rightViewsInitValidate() {
        guard let rightView = self.rightView else { return }

        rightView.clipsToBounds = true
        rightView.layer.anchorPoint = CGPoint(x: 1.0, y: 0.5);

        if self.rightContainerView == nil {
            self.rightContainerView = UIView()
            self.rightContainerView?.backgroundColor = .clear
            self.rightContainerView?.isUserInteractionEnabled = true
        }

        if self.rightViewBackgroundView == nil {
            self.rightViewBackgroundView = UIImageView()
            self.rightViewBackgroundView?.backgroundColor = .clear
            self.rightViewBackgroundView?.isUserInteractionEnabled = false
        }

        if self.rightViewStyleView == nil {
            self.rightViewStyleView = UIVisualEffectView()
            self.rightViewStyleView?.backgroundColor = .clear
            self.rightViewStyleView?.isUserInteractionEnabled = false
            self.rightViewStyleView?.layer.anchorPoint = CGPoint(x: 1.0, y: 0.5);
        }

        if self.rightViewBorderView == nil {
            self.rightViewBorderView = LGSideMenuBorderView()
        }

        if self.rightViewCoverView == nil {
            self.rightViewCoverView = UIVisualEffectView()
            self.rightViewCoverView?.backgroundColor = .clear
            self.rightViewCoverView?.isUserInteractionEnabled = false
        }
    }
    
}
