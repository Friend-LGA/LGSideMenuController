//
//  LGSideMenuBorderView.m
//  LGSideMenuController
//
//
//  The MIT License (MIT)
//
//  Copyright © 2015 Grigory Lutkov <Friend.LGA@gmail.com>
//  (https://github.com/Friend-LGA/LGSideMenuController)
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.
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
