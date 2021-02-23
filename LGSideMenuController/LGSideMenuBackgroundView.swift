//
//  LGSideMenuBackgroundView.swift
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

public final class LGSideMenuBackgroundView: UIView {

    public internal(set) var roundedCorners = UIRectCorner()
    public internal(set) var cornerRadius: CGFloat = .zero
    public internal(set) var strokeColor: UIColor = .clear
    public internal(set) var strokeWidth: CGFloat = .zero
    public internal(set) var fillColor: UIColor = .clear

    public init() {
        super.init(frame: .zero)
        self.backgroundColor = .clear
    }

    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override func draw(_ rect: CGRect) {
        guard let context = UIGraphicsGetCurrentContext() else { return }

        context.clear(rect)

        let path = UIBezierPath(roundedRect: rect,
                                byRoundingCorners: self.roundedCorners,
                                cornerRadii: CGSize(width: self.cornerRadius, height: self.cornerRadius))
        path.close()

        // To have inner stroke we need to fill rect and erase smaller rect from inside of it
        if self.strokeColor != .clear && self.strokeWidth > 0 {
            context.beginPath()
            context.addPath(path.cgPath)
            context.setFillColor(strokeColor.cgColor)
            context.fillPath()

            let strokePath = getStrokedPath(rect: rect)
            strokePath.close()

            context.beginPath()
            context.addPath(strokePath.cgPath)
            context.setFillColor(UIColor.clear.cgColor)
            context.setBlendMode(.clear)
            context.fillPath()
            context.setBlendMode(.normal)
        }

        // Fill smaller rect
        if self.fillColor != .clear {
            let strokePath = getStrokedPath(rect: rect)
            strokePath.close()

            context.beginPath()
            context.addPath(strokePath.cgPath)
            context.setFillColor(fillColor.cgColor)
            context.fillPath()
        }
    }

    private func getStrokedPath(rect: CGRect) -> UIBezierPath {
        return UIBezierPath(roundedRect: rect.insetBy(dx: self.strokeWidth, dy: self.strokeWidth),
                            byRoundingCorners: self.roundedCorners,
                            cornerRadii: CGSize(width: self.cornerRadius, height: self.cornerRadius))
    }

}
