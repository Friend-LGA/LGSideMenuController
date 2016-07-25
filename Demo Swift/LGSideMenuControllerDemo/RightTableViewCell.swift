//
//  RightTableViewCell.swift
//  LGSideMenuControllerDemo
//
//  Created by Cole Dunsby on 2016-07-24.
//  Copyright © 2016 Cole Dunsby. All rights reserved.
//

import UIKit

class RightTableViewCell: UITableViewCell {

    @IBOutlet var separatorView: UIView!
    
    override var highlighted: Bool {
        didSet {
            textLabel?.textColor = highlighted ? UIColor(red: 0.0, green: 0.5, blue: 1.0, alpha: 1.0) : tintColor
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        
        backgroundColor = .clearColor()
        
        textLabel?.textAlignment = .Center
        textLabel?.numberOfLines = 0
        textLabel?.lineBreakMode = .ByWordWrapping
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        textLabel?.textColor = tintColor
        separatorView.backgroundColor = tintColor.colorWithAlphaComponent(0.4)
    }
    
}
