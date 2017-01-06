//
//  LeftViewCell.m
//  LGSideMenuControllerDemo
//

#import "LeftViewCell.h"

@implementation LeftViewCell

- (void)awakeFromNib {
    [super awakeFromNib];

    self.backgroundColor = [UIColor clearColor];
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
    self.titleLabel.alpha = highlighted ? 0.5 : 1.0;
}

@end
