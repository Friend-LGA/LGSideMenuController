//
//  RightViewCell.m
//  LGSideMenuControllerDemo
//

#import "RightViewCell.h"

@implementation RightViewCell

- (void)awakeFromNib {
    [super awakeFromNib];

    self.textLabel.textAlignment = NSTextAlignmentCenter;
    self.textLabel.numberOfLines = 0;
    self.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
    self.textLabel.textColor = [UIColor whiteColor];
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
    self.textLabel.alpha = highlighted ? 0.5 : 1.0;
}

@end
