//
//  LeftViewCellBackgroundView.swift
//  LGSideMenuControllerDemo
//

import Foundation
import UIKit

private func rad(_ deg: CGFloat) -> CGFloat {
    return (deg - 90.0) * .pi / 180.0
}

class LeftViewCellBackgroundView: UIView {

    var isFirstCell: Bool = false {
        didSet {
            setNeedsDisplay()
        }
    }

    var isLastCell: Bool = false {
        didSet {
            setNeedsDisplay()
        }
    }

    var fillColor: UIColor = .clear {
        didSet {
            setNeedsDisplay()
        }
    }

    init() {
        super.init(frame: .zero)
        backgroundColor = .clear
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func draw(_ rect: CGRect) {
        super.draw(rect)

        guard let context = UIGraphicsGetCurrentContext() else { return }

        context.clear(rect)
        context.setFillColor(fillColor.cgColor)

        var drawingRect = getDrawingRect(from: rect)

        do {
            drawingRect.origin.y += 1.0
            drawingRect.size.height -= 2.0
            drawingRect.size.width -= 1.0

            let path = getPath(inside: drawingRect)

            path.close()
            context.beginPath()
            context.addPath(path.cgPath)
            context.fillPath()
        }
    }

    private func getDrawingRect(from rect: CGRect) -> CGRect {
        var result = CGRect(origin: CGPoint(x: 0.0, y: 0.0),
                            size: CGSize(width: rect.width - 1.0, height: rect.height))
        if isFirstCell {
            result.origin.y += 1.0
            result.size.height -= 1.0
        }
        if isLastCell {
            result.size.height -= 1.0
        }
        return result
    }

    private func getPath(inside rect: CGRect) -> UIBezierPath {
        let cornerRadius: CGFloat = 16.0
        let path = UIBezierPath()

        path.move(to: CGPoint(x: rect.minX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX - cornerRadius, y: rect.minY))

        if isFirstCell {
            path.addArc(withCenter: CGPoint(x: rect.maxX - cornerRadius, y: rect.minY + cornerRadius),
                        radius: cornerRadius,
                        startAngle: rad(0.0),
                        endAngle: rad(90.0),
                        clockwise: true)
        }
        else {
            path.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))
        }

        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY - cornerRadius))

        if isLastCell {
            path.addArc(withCenter: CGPoint(x: rect.maxX - cornerRadius, y: rect.maxY - cornerRadius),
                        radius: cornerRadius,
                        startAngle: rad(90.0),
                        endAngle: rad(180.0),
                        clockwise: true)
        }
        else {
            path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        }

        path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))

        return path
    }
}
