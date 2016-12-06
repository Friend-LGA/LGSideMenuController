//
//  RightViewCell.m
//  LGSideMenuControllerDemo
//

#import "RightViewCell.h"

@implementation RightViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;

        self.backgroundColor = [UIColor clearColor];

        self.textLabel.textAlignment = NSTextAlignmentCenter;
        self.textLabel.numberOfLines = 0;
        self.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
        self.textLabel.textColor = [UIColor whiteColor];

        // -----

        self.separatorView = [UIView new];
        self.separatorView.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.4];
        [self addSubview:self.separatorView];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];

    CGRect textLabelFrame = self.textLabel.frame;
    textLabelFrame.origin.x = 8.0;
    textLabelFrame.size.width = CGRectGetWidth(self.frame) - 16.0;
    self.textLabel.frame = textLabelFrame;

    CGFloat height = UIScreen.mainScreen.scale == 1.0 ? 1.0 : 0.5;

    self.separatorView.frame = CGRectMake(CGRectGetWidth(self.frame)*0.1,
                                          CGRectGetHeight(self.frame)-height,
                                          CGRectGetWidth(self.frame)*0.9,
                                          height);
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
    self.textLabel.alpha = highlighted ? 0.5 : 1.0;
}

@end
