//
//  LGSideMenuController+RightViewActions.swift
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

    func showRightView(animated: Bool = true, completion: Completion? = nil) {

    }

    func hideRightView(animated: Bool = true, completion: Completion? = nil) {

    }

    func toggleRightView(animated: Bool = true, completion: Completion? = nil) {

    }

    @IBAction
    func showRightView(sender: Any?) {
        self.showRightView(animated: false)
    }

    @IBAction
    func hideRightView(sender: Any?) {
        self.hideRightView(animated: false)
    }

    @IBAction
    func toggleRightView(sender: Any?) {
        self.toggleRightView(animated: false)
    }

    @IBAction
    func showRightViewAnimated(sender: Any?) {
        self.showRightView(animated: true)
    }

    @IBAction
    func hideRightViewAnimated(sender: Any?) {
        self.hideRightView(animated: true)
    }

    @IBAction
    func toggleRightViewAnimated(sender: Any?) {
        self.toggleRightView(animated: true)
    }

}
