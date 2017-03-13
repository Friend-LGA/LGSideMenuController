//
//  LGSideMenuDrawer.m
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

#import "LGSideMenuDrawer.h"

@implementation LGSideMenuDrawer

+ (UIImage *)drawRectangleWithViewSize:(CGSize)size
                        roundedCorners:(UIRectCorner)roundedCorners
                          cornerRadius:(CGFloat)cornerRadius
                           strokeColor:(UIColor *)strokeColor
                           strokeWidth:(CGFloat)strokeWidth
                           shadowColor:(UIColor *)shadowColor
                            shadowBlur:(CGFloat)shadowBlur
{
    if ((!strokeColor && !shadowColor) || (!strokeWidth && !shadowBlur)) return nil;

    CGFloat imageSizeAddon = (strokeWidth + shadowBlur) * 2;
    CGSize imageSize = CGSizeMake(size.width + imageSizeAddon, size.height + imageSizeAddon);

    UIGraphicsBeginImageContextWithOptions(imageSize, NO, 0.0);

    CGContextRef context = UIGraphicsGetCurrentContext();

    // Fill

    if (shadowBlur && shadowColor) {
        CGContextSetShadowWithColor(context, CGSizeZero, shadowBlur, shadowColor.CGColor);
    }

    CGFloat rectSizeAddon = strokeWidth * 2;
    CGSize rectSize = CGSizeMake(size.width + rectSizeAddon, size.height + rectSizeAddon);
    CGRect rect = CGRectMake(shadowBlur, shadowBlur, rectSize.width, rectSize.height);

    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:rect
                                               byRoundingCorners:roundedCorners
                                                     cornerRadii:CGSizeMake(cornerRadius, cornerRadius)];
    [path closePath];

    [UIColor.blackColor setFill];
    [path fill];

    // Remove black background

    CGContextSetShadowWithColor(context, CGSizeZero, 0.0, nil);

    CGContextSetBlendMode(context, kCGBlendModeClear);
    [path fill];
    CGContextSetBlendMode(context, kCGBlendModeNormal);

    // Stroke

    if (strokeWidth && strokeColor) {
        [strokeColor setFill];
        [path fill];

        UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:CGRectInset(rect, strokeWidth, strokeWidth)
                                                   byRoundingCorners:roundedCorners
                                                         cornerRadii:CGSizeMake(cornerRadius, cornerRadius)];

        CGContextSetBlendMode(context, kCGBlendModeClear);
        [path fill];
        CGContextSetBlendMode(context, kCGBlendModeNormal);
    }

    // Make UIImage

    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();

    UIGraphicsEndImageContext();

    return image;
}

@end
