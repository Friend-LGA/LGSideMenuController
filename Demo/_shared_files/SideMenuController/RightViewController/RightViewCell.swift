//
//  RightViewCell.swift
//  LGSideMenuControllerDemo
//

import Foundation
import UIKit

private let cornerRadius: CGFloat = 16.0
private let fillColorNormal: UIColor = .clear
private let fillColorHighlighted = UIColor(white: 1.0, alpha: 0.3)
private let textColorNormal: UIColor = .white
private let textColorHighlighted: UIColor = .black

class RightViewCell: UITableViewCell {

    var separatorView: UIView

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        separatorView = UIView()

        super.init(style: style, reuseIdentifier: reuseIdentifier)

        selectionStyle = .none
        backgroundColor = .clear

        backgroundView = UIView()
        backgroundView!.backgroundColor = fillColorNormal
        backgroundView!.layer.masksToBounds = true
        backgroundView!.layer.cornerRadius = cornerRadius

        textLabel!.textAlignment = .center
        textLabel!.numberOfLines = 0
        textLabel!.lineBreakMode = .byWordWrapping
        textLabel!.textColor = textColorNormal

        separatorView.backgroundColor = UIColor.white.withAlphaComponent(0.3)
        addSubview(self.separatorView)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        let backgroundOffsetX: CGFloat = 8.0

        backgroundView!.frame = {
            let offsetY: CGFloat = 8.0
            return CGRect(x: backgroundOffsetX,
                          y: offsetY,
                          width: bounds.width - backgroundOffsetX + cornerRadius,
                          height: bounds.height - (offsetY * 2.0))
        }()

        textLabel!.frame = {
            let offsetX: CGFloat = 8.0
            return CGRect(x: backgroundOffsetX + offsetX,
                          y: 0.0,
                          width: bounds.width - backgroundOffsetX - (offsetX * 2.0),
                          height: bounds.height)
        }()

        separatorView.frame = CGRect(x: 16.0,
                                     y: bounds.height - 1.0,
                                     width: bounds.width - 16.0,
                                     height: 1.0)
    }

    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        super.setHighlighted(highlighted, animated: animated)
        backgroundView!.backgroundColor = highlighted ? fillColorHighlighted : fillColorNormal
        textLabel!.textColor = highlighted ? textColorHighlighted : textColorNormal
    }

}
