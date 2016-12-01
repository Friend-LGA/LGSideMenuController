//
//  LeftViewCell.swift
//  LGSideMenuControllerDemo
//
//  Created by Grigory Lutkov on 26.04.15.
//  Copyright © 2015 Grigory Lutkov <Friend.LGA@gmail.com>. All rights reserved.
//

import UIKit

class LeftViewCell: UITableViewCell {

    @IBOutlet var separatorView: UIView!

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        selectionStyle = .none

        backgroundColor = .clear

        textLabel!.font = UIFont.boldSystemFont(ofSize: 16.0)

        // -----

        separatorView = UIView()
        addSubview(separatorView)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        
        textLabel!.textColor = tintColor
        separatorView.backgroundColor = tintColor.withAlphaComponent(0.4)

        let height = UIScreen.main.scale == 1.0 ? 1.0 : 0.5 as CGFloat

        separatorView.frame = CGRect(x: 0.0, y: frame.size.height-height, width: frame.size.width*0.9, height: height)
    }

    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        textLabel!.textColor = highlighted ? UIColor(red: 0.0, green: 0.5, blue: 1.0, alpha: 1.0) : tintColor
    }

}
