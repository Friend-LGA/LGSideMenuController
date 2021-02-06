//
//  LGSideMenuSegue.swift
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

public final class LGSideMenuSegue: UIStoryboardSegue {

    public struct Identifier {
        public static let root  = "root"
        public static let left  = "left"
        public static let right = "right"
    }

    public override func perform() {
        guard let sideMenuController = self.source as? LGSideMenuController else {
            assert(false, "LGSideMenuSegue must have source as LGSideMenuController")
            return
        }

        switch identifier {
        case Identifier.root:
            sideMenuController.rootViewController = destination
        case Identifier.left:
            sideMenuController.leftViewController = destination
        case Identifier.right:
            sideMenuController.rightViewController = destination
        default:
            assert(false, "LGSideMenuSegue must have identifier either \"root\", \"left\" or \"right\"")
        }
    }
    
}
