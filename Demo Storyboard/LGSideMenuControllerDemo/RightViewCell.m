//
//  RightViewCell.m
//  LGSideMenuControllerDemo
//
//  Created by Grigory Lutkov on 26.04.15.
//  Copyright (c) 2015 Grigory Lutkov. All rights reserved.
//

#import "RightViewCell.h"

@implementation RightViewCell

- (void)awakeFromNib {
    [super awakeFromNib];

    // -----

    self.backgroundColor = [UIColor clearColor];

    self.textLabel.textAlignment = NSTextAlignmentCenter;
    self.textLabel.numberOfLines = 0;
    self.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
}

- (void)layoutSubviews {
    [super layoutSubviews];

    self.textLabel.textColor = self.tintColor;
    _separatorView.backgroundColor = [self.tintColor colorWithAlphaComponent:0.4];
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
    self.textLabel.textColor = highlighted ? [UIColor colorWithRed:0.f green:0.5 blue:1.f alpha:1.f] : self.tintColor;
}

@end
