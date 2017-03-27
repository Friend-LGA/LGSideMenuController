//
//  RightViewCell.m
//  LGSideMenuControllerDemo
//

#import "RightViewCell.h"

@implementation RightViewCell

- (void)awakeFromNib {
    [super awakeFromNib];

    self.backgroundColor = [UIColor clearColor];
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
    self.titleLabel.alpha = highlighted ? 0.5 : 1.0;
}

@end
