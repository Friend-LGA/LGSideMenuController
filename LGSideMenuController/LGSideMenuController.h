//
//  LGSideMenuController.h
//  LGSideMenuController
//
//
//  The MIT License (MIT)
//
//  Copyright (c) 2015 Grigory Lutkov <Friend.LGA@gmail.com>
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

#import <UIKit/UIKit.h>

static NSString *const kLGSideMenuControllerWillShowLeftViewNotification    = @"kLGSideMenuControllerWillShowLeftViewNotification";
static NSString *const kLGSideMenuControllerWillDismissLeftViewNotification = @"kLGSideMenuControllerWillDismissLeftViewNotification";
static NSString *const kLGSideMenuControllerDidShowLeftViewNotification     = @"kLGSideMenuControllerDidShowLeftViewNotification";
static NSString *const kLGSideMenuControllerDidDismissLeftViewNotification  = @"kLGSideMenuControllerDidDismissLeftViewNotification";

static NSString *const kLGSideMenuControllerWillShowRightViewNotification    = @"kLGSideMenuControllerWillShowRightViewNotification";
static NSString *const kLGSideMenuControllerWillDismissRightViewNotification = @"kLGSideMenuControllerWillDismissRightViewNotification";
static NSString *const kLGSideMenuControllerDidShowRightViewNotification     = @"kLGSideMenuControllerDidShowRightViewNotification";
static NSString *const kLGSideMenuControllerDidDismissRightViewNotification  = @"kLGSideMenuControllerDidDismissRightViewNotification";

@interface LGSideMenuController : UIViewController

typedef enum
{
    LGSideMenuAlwaysVisibleOnNone           = 0,
    LGSideMenuAlwaysVisibleOnPadLandscape   = 1 << 0,
    LGSideMenuAlwaysVisibleOnPadPortrait    = 1 << 1,
    LGSideMenuAlwaysVisibleOnPhoneLandscape = 1 << 2,
    LGSideMenuAlwaysVisibleOnPhonePortrait  = 1 << 3,
}
LGSideMenuAlwaysVisibleOptions;

typedef enum
{
    LGSideMenuStatusBarVisibleOnNone           = 0,
    LGSideMenuStatusBarVisibleOnPadLandscape   = 1 << 0,
    LGSideMenuStatusBarVisibleOnPadPortrait    = 1 << 1,
    LGSideMenuStatusBarVisibleOnPhoneLandscape = 1 << 2,
    LGSideMenuStatusBarVisibleOnPhonePortrait  = 1 << 3,
}
LGSideMenuStatusBarVisibleOptions;

typedef enum
{
    LGSideMenuPresentationStyleSlideAbove      = 0,
    LGSideMenuPresentationStyleSlideBelow      = 1,
    LGSideMenuPresentationStyleScaleFromBig    = 2,
    LGSideMenuPresentationStyleScaleFromLittle = 3
}
LGSideMenuPresentationStyle;

@property (assign, nonatomic, readonly) CGFloat leftViewWidth;
@property (assign, nonatomic, readonly) CGFloat rightViewWidth;

@property (assign, nonatomic, readonly) LGSideMenuPresentationStyle leftViewPresentationStyle;
@property (assign, nonatomic, readonly) LGSideMenuPresentationStyle rightViewPresentationStyle;

@property (assign, nonatomic, readonly) LGSideMenuAlwaysVisibleOptions leftViewAlwaysVisibleOptions;
@property (assign, nonatomic, readonly) LGSideMenuAlwaysVisibleOptions rightViewAlwaysVisibleOptions;

@property (assign, nonatomic) IBInspectable LGSideMenuStatusBarVisibleOptions leftViewStatusBarVisibleOptions;
@property (assign, nonatomic) IBInspectable LGSideMenuStatusBarVisibleOptions rightViewStatusBarVisibleOptions;

@property (assign, nonatomic, getter=isLeftViewShowing)  BOOL leftViewShowing;
@property (assign, nonatomic, getter=isRightViewShowing) BOOL rightViewShowing;

/** Default is YES */
@property (assign, nonatomic, getter=isLeftViewHidesOnTouch)  IBInspectable BOOL leftViewHidesOnTouch;
/** Default is YES */
@property (assign, nonatomic, getter=isRightViewHidesOnTouch) IBInspectable BOOL rightViewHidesOnTouch;

/** Default is YES */
@property (assign, nonatomic, getter=isLeftViewSwipeGestureEnabled)  IBInspectable BOOL leftViewSwipeGestureEnabled;
/** Default is YES */
@property (assign, nonatomic, getter=isRightViewSwipeGestureEnabled) IBInspectable BOOL rightViewSwipeGestureEnabled;

/**
 Color that hides root view, when left view is showing
 For LGSideMenuPresentationStyleSlideAbove default is [UIColor colorWithWhite:0.f alpha:0.5]
 */
@property (strong, nonatomic) IBInspectable UIColor *rootViewCoverColorForLeftView;
/**
 Color that hides root view, when right view is showing
 For LGSideMenuPresentationStyleSlideAbove default is [UIColor colorWithWhite:0.f alpha:0.5]
 */
@property (strong, nonatomic) IBInspectable UIColor *rootViewCoverColorForRightView;

/**
 Only if (presentationStyle == LGSideMenuPresentationStyleSlideBelow || LGSideMenuPresentationStyleScaleFromBig || LGSideMenuPresentationStyleScaleFromLittle).
 For LGSideMenuPresentationStyleSlideBelow default is 1.
 For LGSideMenuPresentationStyleScaleFromBig default is 0.8.
 For LGSideMenuPresentationStyleScaleFromLittle default is 0.8.
 */
@property (assign, nonatomic) IBInspectable CGFloat rootViewScaleForLeftView;
/**
 Only if (presentationStyle == LGSideMenuPresentationStyleSlideBelow || LGSideMenuPresentationStyleScaleFromBig || LGSideMenuPresentationStyleScaleFromLittle).
 For LGSideMenuPresentationStyleSlideBelow default is 1.
 For LGSideMenuPresentationStyleScaleFromBig default is 0.8.
 For LGSideMenuPresentationStyleScaleFromLittle default is 0.8.
 */
@property (assign, nonatomic) IBInspectable CGFloat rootViewScaleForRightView;

/**
 Color that hides left view, when if is not showing.
 Only if (presentationStyle == LGSideMenuPresentationStyleSlideBelow || LGSideMenuPresentationStyleScaleFromBig || LGSideMenuPresentationStyleScaleFromLittle)
 Default is [UIColor colorWithWhite:0.f alpha:0.5]
 */
@property (strong, nonatomic) IBInspectable UIColor *leftViewCoverColor;
/**
 Color that hides right view, when if is not showing.
 Only if (presentationStyle == LGSideMenuPresentationStyleSlideBelow || LGSideMenuPresentationStyleScaleFromBig || LGSideMenuPresentationStyleScaleFromLittle)
 Default is [UIColor colorWithWhite:0.f alpha:0.5]
 */
@property (strong, nonatomic)IBInspectable  UIColor *rightViewCoverColor;

/** Only if (presentationStyle == LGSideMenuPresentationStyleSlideBelow || LGSideMenuPresentationStyleScaleFromBig || LGSideMenuPresentationStyleScaleFromLittle) */
@property (strong, nonatomic) IBInspectable UIImage *leftViewBackgroundImage;
/** Only if (presentationStyle == LGSideMenuPresentationStyleSlideBelow || LGSideMenuPresentationStyleScaleFromBig || LGSideMenuPresentationStyleScaleFromLittle) */
@property (strong, nonatomic) IBInspectable UIImage *rightViewBackgroundImage;

/**
 Only if (presentationStyle == LGSideMenuPresentationStyleSlideBelow || LGSideMenuPresentationStyleScaleFromBig || LGSideMenuPresentationStyleScaleFromLittle).
 For LGSideMenuPresentationStyleSlideBelow default is 1.
 For LGSideMenuPresentationStyleScaleFromBig and LGSideMenuPresentationStyleScaleFromLittle default is 1.4.
 */
@property (assign, nonatomic) IBInspectable CGFloat leftViewBackgroundImageInitialScale;
/**
 Only if (presentationStyle == LGSideMenuPresentationStyleSlideBelow || LGSideMenuPresentationStyleScaleFromBig || LGSideMenuPresentationStyleScaleFromLittle).
 For LGSideMenuPresentationStyleSlideBelow default is 1.
 For LGSideMenuPresentationStyleScaleFromBig and LGSideMenuPresentationStyleScaleFromLittle default is 1.4.
 */
@property (assign, nonatomic) IBInspectable CGFloat rightViewBackgroundImageInitialScale;

/**
 Only if (presentationStyle == LGSideMenuPresentationStyleSlideBelow || LGSideMenuPresentationStyleScaleFromBig || LGSideMenuPresentationStyleScaleFromLittle).
 For LGSideMenuPresentationStyleSlideBelow default is 1.
 For LGSideMenuPresentationStyleScaleFromBig default is 1.2.
 For LGSideMenuPresentationStyleScaleFromLittle default is 0.8.
 */
@property (assign, nonatomic) IBInspectable CGFloat leftViewInititialScale;
/**
 Only if (presentationStyle == LGSideMenuPresentationStyleSlideBelow || LGSideMenuPresentationStyleScaleFromBig || LGSideMenuPresentationStyleScaleFromLittle).
 For LGSideMenuPresentationStyleSlideBelow default is 1.
 For LGSideMenuPresentationStyleScaleFromBig default is 1.2.
 For LGSideMenuPresentationStyleScaleFromLittle default is 0.8.
 */
@property (assign, nonatomic) IBInspectable CGFloat rightViewInititialScale;

/**
 Only if (presentationStyle == LGSideMenuPresentationStyleSlideBelow || LGSideMenuPresentationStyleScaleFromBig || LGSideMenuPresentationStyleScaleFromLittle).
 For LGSideMenuPresentationStyleSlideBelow default is -width/2.
 For LGSideMenuPresentationStyleScaleFromBig default is 0.
 For LGSideMenuPresentationStyleScaleFromLittle default is 0.
 */
@property (assign, nonatomic) IBInspectable CGFloat leftViewInititialOffsetX;
/**
 Only if (presentationStyle == LGSideMenuPresentationStyleSlideBelow || LGSideMenuPresentationStyleScaleFromBig || LGSideMenuPresentationStyleScaleFromLittle).
 For LGSideMenuPresentationStyleSlideBelow default is width/2.
 For LGSideMenuPresentationStyleScaleFromBig default is 0.
 For LGSideMenuPresentationStyleScaleFromLittle default is 0.
 */
@property (assign, nonatomic) IBInspectable CGFloat rightViewInititialOffsetX;

@property (strong, nonatomic) IBInspectable UIColor *rootViewLayerBorderColor;
@property (assign, nonatomic) IBInspectable CGFloat rootViewLayerBorderWidth;
/** For (presentationStyle == LGSideMenuPresentationStyleSlideBelow || LGSideMenuPresentationStyleScaleFromBig || LGSideMenuPresentationStyleScaleFromLittle) default is [UIColor colorWithWhite:0.f alpha:0.5] */
@property (strong, nonatomic) IBInspectable UIColor *rootViewLayerShadowColor;
/** For (presentationStyle == LGSideMenuPresentationStyleSlideBelow || LGSideMenuPresentationStyleScaleFromBig || LGSideMenuPresentationStyleScaleFromLittle) default is 5.f */
@property (assign, nonatomic) IBInspectable CGFloat rootViewLayerShadowRadius;

@property (strong, nonatomic) IBInspectable UIColor *leftViewBackgroundColor;
@property (strong, nonatomic) IBInspectable UIColor *leftViewLayerBorderColor;
@property (assign, nonatomic) IBInspectable CGFloat leftViewLayerBorderWidth;
/** For LGSideMenuPresentationStyleSlideAbove default is [UIColor colorWithWhite:0.f alpha:0.5] */
@property (strong, nonatomic) IBInspectable UIColor *leftViewLayerShadowColor;
/** For LGSideMenuPresentationStyleSlideAbove default is 5.f */
@property (assign, nonatomic) IBInspectable CGFloat leftViewLayerShadowRadius;

@property (strong, nonatomic) IBInspectable UIColor *rightViewBackgroundColor;
@property (strong, nonatomic) IBInspectable UIColor *rightViewLayerBorderColor;
@property (assign, nonatomic) IBInspectable CGFloat rightViewLayerBorderWidth;
/** For LGSideMenuPresentationStyleSlideAbove default is [UIColor colorWithWhite:0.f alpha:0.5] */
@property (strong, nonatomic) IBInspectable UIColor *rightViewLayerShadowColor;
/** For LGSideMenuPresentationStyleSlideAbove default is 5.f */
@property (assign, nonatomic) IBInspectable CGFloat rightViewLayerShadowRadius;

- (instancetype)initWithRootViewController:(UIViewController *)rootViewController;

- (void)setRootViewController:(UIViewController *)rootViewController;

- (UIViewController *)rootViewController;
- (UIView *)leftView;
- (UIView *)rightView;

- (BOOL)isLeftViewAlwaysVisible;
- (BOOL)isRightViewAlwaysVisible;

- (BOOL)isLeftViewAlwaysVisibleForInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation;
- (BOOL)isRightViewAlwaysVisibleForInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation;

- (void)setLeftViewEnabledWithWidth:(CGFloat)width
                  presentationStyle:(LGSideMenuPresentationStyle)presentationStyle
               alwaysVisibleOptions:(LGSideMenuAlwaysVisibleOptions)alwaysVisibleOptions;

- (void)setRightViewEnabledWithWidth:(CGFloat)width
                   presentationStyle:(LGSideMenuPresentationStyle)presentationStyle
                alwaysVisibleOptions:(LGSideMenuAlwaysVisibleOptions)alwaysVisibleOptions;

- (void)leftViewWillLayoutSubviewsWithSize:(CGSize)size;
- (void)rightViewWillLayoutSubviewsWithSize:(CGSize)size;

- (void)showLeftViewAnimated:(BOOL)animated completionHandler:(void(^)())completionHandler;
- (void)hideLeftViewAnimated:(BOOL)animated completionHandler:(void(^)())completionHandler;
- (void)showHideLeftViewAnimated:(BOOL)animated completionHandler:(void(^)())completionHandler;

- (void)showRightViewAnimated:(BOOL)animated completionHandler:(void(^)())completionHandler;
- (void)hideRightViewAnimated:(BOOL)animated completionHandler:(void(^)())completionHandler;
- (void)showHideRightViewAnimated:(BOOL)animated completionHandler:(void(^)())completionHandler;

@end
