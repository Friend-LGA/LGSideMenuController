//
//  RightViewCellHeaderView.swift
//  LGSideMenuControllerDemo
//

import Foundation
import UIKit

class RightViewCellHeaderView: UIView {

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
        context.setFillColor(UIColor(white: 1.0, alpha: 0.3).cgColor)

        let offset: CGFloat = 16.0
        let height: CGFloat = 4.0

        context.fill(CGRect(x: offset,
                            y: rect.height / 2.0 - height / 2.0,
                            width: rect.width - offset,
                            height: height))
    }

}
