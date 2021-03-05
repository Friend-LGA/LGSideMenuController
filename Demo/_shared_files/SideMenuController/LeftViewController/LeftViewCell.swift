//
//  LeftViewCell.swift
//  LGSideMenuControllerDemo
//

import Foundation
import UIKit

private let textFont = UIFont.boldSystemFont(ofSize: 16.0)
private let fillColorNormal = UIColor(white: 0.0, alpha: 0.2)
private let fillColorNormalInverted = UIColor(white: 1.0, alpha: 0.2)
private let fillColorHighlighted = UIColor(white: 1.0, alpha: 0.6)
private let textColorNormal: UIColor = .white
private let textColorHighlighted: UIColor = .black

class LeftViewCell: UITableViewCell {

    var isFirst: Bool = false {
        didSet {
            guard let backgroundView = self.backgroundView as? LeftViewCellBackgroundView else { return }
            backgroundView.isFirstCell = isFirst
        }
    }

    var isLast: Bool = false {
        didSet {
            guard let backgroundView = self.backgroundView as? LeftViewCellBackgroundView else { return }
            backgroundView.isLastCell = isLast
        }
    }

    var isFillColorInverted: Bool = false

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        selectionStyle = .none
        backgroundColor = .clear

        backgroundView = LeftViewCellBackgroundView()
        setBackgroundColor(getFillColorNormal())

        textLabel!.font = textFont
        textLabel!.textColor = textColorNormal
        textLabel!.numberOfLines = 1
        textLabel!.textAlignment = .left
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        backgroundView!.frame = CGRect(x: 0.0,
                                       y: 0.0,
                                       width: bounds.width - 16.0,
                                       height: bounds.height)

        textLabel!.frame = CGRect(x: 8.0,
                                  y: 0.0,
                                  width: bounds.width - 16.0 - 16.0,
                                  height: bounds.height)
    }

    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        super.setHighlighted(highlighted, animated: animated)
        setBackgroundColor(highlighted ? fillColorHighlighted : getFillColorNormal())
        textLabel!.textColor = highlighted ? textColorHighlighted : textColorNormal
    }

    func getFillColorNormal() -> UIColor {
        return isFillColorInverted ? fillColorNormalInverted : fillColorNormal
    }

    func setBackgroundColor(_ color: UIColor) {
        let backgroundView = self.backgroundView as! LeftViewCellBackgroundView
        backgroundView.fillColor = color
    }

}
