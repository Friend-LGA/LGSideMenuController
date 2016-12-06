//
//  LeftViewCell.m
//  LGSideMenuControllerDemo
//

#import "LeftViewCell.h"

@implementation LeftViewCell

- (void)awakeFromNib {
    [super awakeFromNib];

    self.textLabel.font = [UIFont boldSystemFontOfSize:16.0];
    self.textLabel.textColor = [UIColor whiteColor];
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
    self.textLabel.alpha = highlighted ? 0.5 : 1.0;
}

@end
