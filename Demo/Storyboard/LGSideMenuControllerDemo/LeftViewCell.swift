//
//  LeftViewCell.swift
//  LGSideMenuControllerDemo
//

import Foundation
import UIKit

class LeftViewCell: UITableViewCell {

    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var separatorView: UIView!

    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        titleLabel.alpha = highlighted ? 0.5 : 1.0
    }

}
