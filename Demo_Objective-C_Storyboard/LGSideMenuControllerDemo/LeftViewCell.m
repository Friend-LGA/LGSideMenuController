//
//  LeftViewCell.m
//  LGSideMenuControllerDemo
//
//  Created by Grigory Lutkov on 26.04.15.
//  Copyright © 2015 Grigory Lutkov <Friend.LGA@gmail.com>. All rights reserved.
//

#import "LeftViewCell.h"

@implementation LeftViewCell

- (void)awakeFromNib {
    [super awakeFromNib];

    self.backgroundColor = [UIColor clearColor];

    self.textLabel.font = [UIFont boldSystemFontOfSize:16.0];
}

- (void)layoutSubviews {
    [super layoutSubviews];

    self.textLabel.textColor = self.tintColor;
    self.separatorView.backgroundColor = [self.tintColor colorWithAlphaComponent:0.4];
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
    self.textLabel.textColor = highlighted ? [UIColor colorWithRed:0.0 green:0.5 blue:1.0 alpha:1.0] : self.tintColor;
}

@end
