//
//  LGSideMenuDelegate.swift
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
import QuartzCore
import UIKit

/// Delegate protocol to observe behaviour of LGSideMenuController
public protocol LGSideMenuDelegate {

    func willShowLeftView(sideMenuController: LGSideMenuController)
    func didShowLeftView(sideMenuController: LGSideMenuController)

    func willHideLeftView(sideMenuController: LGSideMenuController)
    func didHideLeftView(sideMenuController: LGSideMenuController)

    func willShowRightView(sideMenuController: LGSideMenuController)
    func didShowRightView(sideMenuController: LGSideMenuController)

    func willHideRightView(sideMenuController: LGSideMenuController)
    func didHideRightView(sideMenuController: LGSideMenuController)

    /// This method is executed inside animation block for showing left view.
    /// Use it to add some custom animations.
    func showAnimationsForLeftView(sideMenuController: LGSideMenuController,
                                   duration: TimeInterval,
                                   timingFunction: CAMediaTimingFunction)

    /// This method is executed inside animation block for hiding left view.
    /// Use it to add some custom animations.
    func hideAnimationsForLeftView(sideMenuController: LGSideMenuController,
                                   duration: TimeInterval,
                                   timingFunction: CAMediaTimingFunction)

    /// This method is executed inside animation block for showing right view.
    /// Use it to add some custom animations.
    func showAnimationsForRightView(sideMenuController: LGSideMenuController,
                                    duration: TimeInterval,
                                    timingFunction: CAMediaTimingFunction)

    /// This method is executed inside animation block for hiding right view.
    /// Use it to add some custom animations.
    func hideAnimationsForRightView(sideMenuController: LGSideMenuController,
                                    duration: TimeInterval,
                                    timingFunction: CAMediaTimingFunction)

    /// This method is executed on every transformation of root view during showing/hiding of side views
    /// You can retrieve percentage between `0.0` and `1.0` from userInfo dictionary, where
    ///   - `0.0` - view is fully shown
    ///   - `1.0` - view is fully hidden
    func didTransformRootView(sideMenuController: LGSideMenuController, percentage: CGFloat)

    /// This method is executed on every transformation of left view during showing/hiding
    /// You can retrieve percentage between `0.0` and `1.0` from userInfo dictionary, where
    ///   - `0.0` - view is fully hidden
    ///   - `1.0` - view is fully shown
    func didTransformLeftView(sideMenuController: LGSideMenuController, percentage: CGFloat)

    /// This method is executed on every transformation of right view during showing/hiding
    /// You can retrieve percentage between `0.0` and `1.0` from userInfo dictionary, where
    ///   - `0.0` - view is fully hidden
    ///   - `1.0` - view is fully shown
    func didTransformRightView(sideMenuController: LGSideMenuController, percentage: CGFloat)
}

// As swift doesn't support optional methods,
// we use this extension with default empty implementations for delegate methods
public extension LGSideMenuDelegate {

    func willShowLeftView(sideMenuController: LGSideMenuController) {}
    func didShowLeftView(sideMenuController: LGSideMenuController) {}

    func willHideLeftView(sideMenuController: LGSideMenuController) {}
    func didHideLeftView(sideMenuController: LGSideMenuController) {}

    func willShowRightView(sideMenuController: LGSideMenuController) {}
    func didShowRightView(sideMenuController: LGSideMenuController) {}

    func willHideRightView(sideMenuController: LGSideMenuController) {}
    func didHideRightView(sideMenuController: LGSideMenuController) {}

    func showAnimationsForLeftView(sideMenuController: LGSideMenuController,
                                   duration: TimeInterval,
                                   timingFunction: CAMediaTimingFunction) {}

    func hideAnimationsForLeftView(sideMenuController: LGSideMenuController,
                                   duration: TimeInterval,
                                   timingFunction: CAMediaTimingFunction) {}

    func showAnimationsForRightView(sideMenuController: LGSideMenuController,
                                    duration: TimeInterval,
                                    timingFunction: CAMediaTimingFunction) {}

    func hideAnimationsForRightView(sideMenuController: LGSideMenuController,
                                    duration: TimeInterval,
                                    timingFunction: CAMediaTimingFunction) {}

    func rootViewIsTransforming(sideMenuController: LGSideMenuController, percentage: CGFloat) {}
    func leftViewIsTransforming(sideMenuController: LGSideMenuController, percentage: CGFloat) {}
    func rightViewIsTransforming(sideMenuController: LGSideMenuController, percentage: CGFloat) {}

}
