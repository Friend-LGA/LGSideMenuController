//
//  LGSideMenuBorderView.swift
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

final class LGSideMenuBorderView: UIView {

    var roundedCorners = UIRectCorner()
    var cornerRadius: CGFloat = .zero
    var strokeColor: UIColor?
    var strokeWidth: CGFloat = .zero
    var shadowColor: UIColor?
    var shadowBlur: CGFloat = .zero

    init() {
        super.init(frame: CGRect.zero)
        self.backgroundColor = .clear
        self.isUserInteractionEnabled = false
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func draw(_ rect: CGRect) {
        guard let context = UIGraphicsGetCurrentContext(),
              self.shadowColor != nil || self.strokeColor != nil else {
            return
        }

        let offset = self.shadowBlur * 2.0

        let drawRect = CGRect(x: self.shadowBlur,
                              y: self.shadowBlur,
                              width: rect.width - offset,
                              height: rect.height - offset)

        let path = UIBezierPath(roundedRect: drawRect,
                                byRoundingCorners: self.roundedCorners,
                                cornerRadii: CGSize(width: self.cornerRadius, height: self.cornerRadius))
        path.close()

        context.beginPath()
        context.addPath(path.cgPath)

        // Fill it black to draw proper shadow, then erase black internals and keep only shadow
        if let shadowColor = self.shadowColor?.cgColor {
            context.setShadow(offset: .zero, blur: self.shadowBlur, color: shadowColor)
            context.setFillColor(UIColor.black.cgColor)
            context.fillPath()
            context.setShadow(offset: .zero, blur: .zero, color: nil)
            context.setBlendMode(.clear)
            context.fillPath()
            context.setBlendMode(.normal)
        }

        // To stroke we need to fill rect inside already drawn shadows and erase smaller rect from inside of it
        if let strokeColor = self.strokeColor?.cgColor {
            context.setFillColor(strokeColor)
            context.fillPath()

            let innerPath = UIBezierPath(roundedRect: drawRect.insetBy(dx: self.strokeWidth, dy: self.strokeWidth),
                                         byRoundingCorners: self.roundedCorners,
                                         cornerRadii: CGSize(width: self.cornerRadius, height: self.cornerRadius))
            innerPath.close()

            context.beginPath()
            context.addPath(innerPath.cgPath)

            context.setBlendMode(.clear)
            context.fillPath()
            context.setBlendMode(.normal)
        }
    }

}
