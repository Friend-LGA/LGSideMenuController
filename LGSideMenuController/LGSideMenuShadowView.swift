//
//  LGSideMenuShadowView.swift
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
import CoreGraphics
import UIKit

public final class LGSideMenuShadowView: UIView {

    public internal(set) var roundedCorners = UIRectCorner()
    public internal(set) var cornerRadius: CGFloat = .zero
    public internal(set) var shadowColor: UIColor = .clear
    public internal(set) var shadowBlur: CGFloat = .zero

    public init() {
        super.init(frame: CGRect.zero)
        self.backgroundColor = .clear
    }

    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override func draw(_ rect: CGRect) {
        guard let context = UIGraphicsGetCurrentContext() else { return }

        let drawRect = rect.insetBy(dx: self.shadowBlur, dy: self.shadowBlur)

        let path = UIBezierPath(roundedRect: drawRect,
                                byRoundingCorners: self.roundedCorners,
                                cornerRadii: CGSize(width: self.cornerRadius, height: self.cornerRadius))
        path.close()

        context.clear(rect)
        context.beginPath()
        context.addPath(path.cgPath)

        // Fill it black to draw proper shadow, then erase black internals and keep only shadow
        if shadowColor != .clear && self.shadowBlur > 0 {
            context.setShadow(offset: .zero, blur: self.shadowBlur, color: shadowColor.cgColor)
            context.setFillColor(UIColor.black.cgColor)
            context.fillPath()
            context.setShadow(offset: .zero, blur: .zero, color: nil)

            context.beginPath()
            context.addPath(path.cgPath)
            context.setFillColor(UIColor.clear.cgColor)
            context.setBlendMode(.clear)
            context.fillPath()
            context.setBlendMode(.normal)
        }
    }

}
