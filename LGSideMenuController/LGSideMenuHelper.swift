//
//  LGSideMenuHelper.swift
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
import ObjectiveC

struct LGSideMenuHelper {
    private struct Constant {
        static var sideMenuControllerKey = "sideMenuController"
    }

    static func animate(duration: TimeInterval, animations: @escaping () -> Void, completion: @escaping (Bool) -> Void) {
        UIView.animate(withDuration: duration,
                       delay: TimeInterval.zero,
                       usingSpringWithDamping: 1.0,
                       initialSpringVelocity: 0.5,
                       animations: animations,
                       completion: completion)
    }

    static func statusBarAppearanceUpdate(viewController: UIViewController, duration: TimeInterval) {
        if viewController.preferredStatusBarUpdateAnimation == .none {
            viewController.setNeedsStatusBarAppearanceUpdate()
        }
        else {
            UIView.animate(withDuration: duration, animations: {
                viewController.setNeedsStatusBarAppearanceUpdate()
            })
        }
    }

    static func setImage(_ image: UIImage?, for imageView: UIImageView) {
        let contentMode = imageView.contentMode
        imageView.contentMode = .scaleToFill
        imageView.image = image
        imageView.contentMode = contentMode
    }

    static func isPhone() -> Bool {
        return UIDevice.current.userInterfaceIdiom == .phone
    }

    static func isPad() -> Bool {
        return UIDevice.current.userInterfaceIdiom == .pad
    }

    static func setSideMenuController(_ sideMenuController: LGSideMenuController?, to viewController: UIViewController) {
        objc_setAssociatedObject(viewController, &Constant.sideMenuControllerKey, sideMenuController, objc_AssociationPolicy.OBJC_ASSOCIATION_ASSIGN)
    }

    static func getSideMenuController(from viewController: UIViewController) -> LGSideMenuController? {
        return objc_getAssociatedObject(viewController, &Constant.sideMenuControllerKey) as? LGSideMenuController
    }

}
