//
//  LGSideMenuBorderView.m
//  LGSideMenuControllerDemo
//
//  Created by Grigory Lutkov on 18/04/17.
//  Copyright © 2017 Grigory Lutkov. All rights reserved.
//

#import "LGSideMenuBorderView.h"

@implementation LGSideMenuBorderView

- (instancetype)init {
    self = [super init];
    if (self) {
        self.backgroundColor = UIColor.clearColor;
        self.userInteractionEnabled = NO;
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];

    if ((!self.strokeColor && !self.shadowColor) || (!self.strokeWidth && !self.shadowBlur)) return;

    CGContextRef context = UIGraphicsGetCurrentContext();

    // Fill

    if (self.shadowBlur && self.shadowColor) {
        CGContextSetShadowWithColor(context, CGSizeZero, self.shadowBlur, self.shadowColor.CGColor);
    }

    CGFloat offset = self.shadowBlur * 2.0;
    CGRect drawRect = CGRectMake(self.shadowBlur,
                                 self.shadowBlur,
                                 CGRectGetWidth(rect) - offset,
                                 CGRectGetHeight(rect) - offset);

    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:drawRect
                                               byRoundingCorners:self.roundedCorners
                                                     cornerRadii:CGSizeMake(self.cornerRadius, self.cornerRadius)];
    [path closePath];

    [UIColor.blackColor setFill];
    [path fill];

    // Remove black background

    CGContextSetShadowWithColor(context, CGSizeZero, 0.0, nil);

    CGContextSetBlendMode(context, kCGBlendModeClear);
    [path fill];
    CGContextSetBlendMode(context, kCGBlendModeNormal);

    // Stroke

    if (self.strokeWidth && self.strokeColor) {
        [self.strokeColor setFill];
        [path fill];

        UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:CGRectInset(drawRect, self.strokeWidth, self.strokeWidth)
                                                   byRoundingCorners:self.roundedCorners
                                                         cornerRadii:CGSizeMake(self.cornerRadius, self.cornerRadius)];

        CGContextSetBlendMode(context, kCGBlendModeClear);
        [path fill];
        CGContextSetBlendMode(context, kCGBlendModeNormal);
    }
}

@end
