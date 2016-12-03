//
//  LeftViewCell.m
//  LGSideMenuControllerDemo
//
//  Created by Grigory Lutkov on 26.04.15.
//  Copyright © 2015 Grigory Lutkov <Friend.LGA@gmail.com>. All rights reserved.
//

#import "LeftViewCell.h"

@implementation LeftViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;

        self.backgroundColor = [UIColor clearColor];

        self.textLabel.font = [UIFont boldSystemFontOfSize:16.0];

        // -----

        self.separatorView = [UIView new];
        [self addSubview:self.separatorView];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];

    self.textLabel.textColor = self.tintColor;
    self.separatorView.backgroundColor = [self.tintColor colorWithAlphaComponent:0.4];

    CGFloat height = [UIScreen mainScreen].scale == 1.0 ? 1.0 : 0.5;

    self.separatorView.frame = CGRectMake(0.0, self.frame.size.height-height, self.frame.size.width*0.9, height);
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
    self.textLabel.textColor = highlighted ? [UIColor colorWithRed:0.0 green:0.5 blue:1.0 alpha:1.0] : self.tintColor;
}

@end
