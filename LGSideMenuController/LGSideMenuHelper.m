//
//  LGSideMenuHelper.m
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

#import "LGSideMenuHelper.h"

@implementation LGSideMenuHelper

+ (void)animateWithDuration:(NSTimeInterval)duration
                 animations:(void(^)(void))animations
                 completion:(void(^)(BOOL finished))completion {
    [UIView animateWithDuration:duration
                          delay:0.0
         usingSpringWithDamping:1.0
          initialSpringVelocity:0.5
                        options:0
                     animations:animations
                     completion:completion];

}

+ (void)statusBarAppearanceUpdateAnimated:(BOOL)animated
                           viewController:(UIViewController *)viewController
                                 duration:(NSTimeInterval)duration
                                   hidden:(BOOL)hidden
                                    style:(UIStatusBarStyle)style
                                animation:(UIStatusBarAnimation)animation {
    if (self.isViewControllerBasedStatusBarAppearance) {
        if (animated && animation != UIStatusBarAnimationNone) {
            [UIView animateWithDuration:duration animations:^{
                [viewController setNeedsStatusBarAppearanceUpdate];
            }];
        }
        else {
            [viewController setNeedsStatusBarAppearanceUpdate];
        }
    }
#if __IPHONE_OS_VERSION_MIN_REQUIRED < __IPHONE_9_0
    else {
        [UIApplication.sharedApplication setStatusBarHidden:hidden withAnimation:animation];
        [UIApplication.sharedApplication setStatusBarStyle:style animated:animated];
    }
#endif
}

+ (void)imageView:(UIImageView *)imageView setImageSafe:(UIImage *)image {
    UIViewContentMode contentMode = imageView.contentMode;
    imageView.contentMode = UIViewContentModeScaleToFill;
    imageView.image = image;
    imageView.contentMode = contentMode;
}

+ (BOOL)isViewControllerBasedStatusBarAppearance {
    static BOOL isViewControllerBasedStatusBarAppearance;
    static dispatch_once_t onceToken;

    dispatch_once(&onceToken, ^{
        if (UIDevice.currentDevice.systemVersion.floatValue >= 9.0) {
            isViewControllerBasedStatusBarAppearance = YES;
        }
        else {
            NSNumber *viewControllerBasedStatusBarAppearance = [NSBundle.mainBundle objectForInfoDictionaryKey:@"UIViewControllerBasedStatusBarAppearance"];
            isViewControllerBasedStatusBarAppearance = (viewControllerBasedStatusBarAppearance == nil ? YES : viewControllerBasedStatusBarAppearance.boolValue);
        }
    });

    return isViewControllerBasedStatusBarAppearance;
}

+ (BOOL)isNotRetina {
    static BOOL isNotRetina;
    static dispatch_once_t onceToken;

    dispatch_once(&onceToken, ^{
        isNotRetina = (UIScreen.mainScreen.scale == 1.0);
    });

    return isNotRetina;
}

+ (BOOL)isPhone {
    return UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone;
}

+ (BOOL)isPad {
    return UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad;
}

@end
