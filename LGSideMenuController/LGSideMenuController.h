//
//  LGSideMenuController.h
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

#import <UIKit/UIKit.h>

@class LGSideMenuController;
@protocol LGSideMenuDelegate;

#pragma mark - Constants

extern NSString * _Nonnull const LGSideMenuWillShowLeftViewNotification;
extern NSString * _Nonnull const LGSideMenuDidShowLeftViewNotification;

extern NSString * _Nonnull const LGSideMenuWillHideLeftViewNotification;
extern NSString * _Nonnull const LGSideMenuDidHideLeftViewNotification;

extern NSString * _Nonnull const LGSideMenuWillShowRightViewNotification;
extern NSString * _Nonnull const LGSideMenuDidShowRightViewNotification;

extern NSString * _Nonnull const LGSideMenuWillHideRightViewNotification;
extern NSString * _Nonnull const LGSideMenuDidHideRightViewNotification;

/** You can use this notification to add some custom animations */
extern NSString *_Nonnull const LGSideMenuShowLeftViewAnimationsNotification;
/** You can use this notification to add some custom animations */
extern NSString *_Nonnull const LGSideMenuHideLeftViewAnimationsNotification;

/** You can use this notification to add some custom animations */
extern NSString *_Nonnull const LGSideMenuShowRightViewAnimationsNotification;
/** You can use this notification to add some custom animations */
extern NSString *_Nonnull const LGSideMenuHideRightViewAnimationsNotification;

/** Key for notifications userInfo dictionary */
extern NSString * _Nonnull const kLGSideMenuView;
/** Key for notifications userInfo dictionary */
extern NSString * _Nonnull const kLGSideMenuAnimationDuration;

static NSString * _Nonnull const LGSideMenuSegueRootIdentifier  = @"root";
static NSString * _Nonnull const LGSideMenuSegueLeftIdentifier  = @"left";
static NSString * _Nonnull const LGSideMenuSegueRightIdentifier = @"right";

#pragma mark - Types

typedef void (^ _Nullable LGSideMenuCompletionHandler)();
typedef void (^ _Nullable LGSideMenuHandler)(LGSideMenuController * _Nonnull sideMenuController, UIView * _Nonnull view);
typedef void (^ _Nullable LGSideMenuAnimationsBlock)(LGSideMenuController * _Nonnull sideMenuController, UIView * _Nonnull view, NSTimeInterval duration);

typedef NS_OPTIONS(NSUInteger, LGSideMenuAlwaysVisibleOptions) {
    LGSideMenuAlwaysVisibleOnNone           = 0,
    LGSideMenuAlwaysVisibleOnLandscape      = 1 << 1,
    LGSideMenuAlwaysVisibleOnPortrait       = 1 << 2,
    LGSideMenuAlwaysVisibleOnPad            = 1 << 3,
    LGSideMenuAlwaysVisibleOnPhone          = 1 << 4,
    LGSideMenuAlwaysVisibleOnPadLandscape   = 1 << 5,
    LGSideMenuAlwaysVisibleOnPadPortrait    = 1 << 6,
    LGSideMenuAlwaysVisibleOnPhoneLandscape = 1 << 7,
    LGSideMenuAlwaysVisibleOnPhonePortrait  = 1 << 8,
    LGSideMenuAlwaysVisibleOnAll            = 1 << 9
};

typedef NS_ENUM(NSUInteger, LGSideMenuPresentationStyle) {
    LGSideMenuPresentationStyleSlideAbove      = 0,
    LGSideMenuPresentationStyleSlideBelow      = 1,
    LGSideMenuPresentationStyleScaleFromBig    = 2,
    LGSideMenuPresentationStyleScaleFromLittle = 3
};

typedef NS_ENUM(NSUInteger, LGSideMenuSwipeGestureArea) {
    LGSideMenuSwipeGestureAreaBorders   = 0,
    LGSideMenuSwipeGestureAreaFull      = 1
};

typedef struct LGSideMenuSwipeGestureRange {
    CGFloat left;
    CGFloat right;
} LGSideMenuSwipeGestureRange;

LGSideMenuSwipeGestureRange LGSideMenuSwipeGestureRangeMake(CGFloat left, CGFloat right);

#pragma mark - Interface

@interface LGSideMenuController : UIViewController

@property (strong, nonatomic, nullable) UIViewController *rootViewController;
@property (strong, nonatomic, nullable) UIViewController *leftViewController;
@property (strong, nonatomic, nullable) UIViewController *rightViewController;

@property (strong, nonatomic, nullable) UIView *rootView;
@property (strong, nonatomic, nullable) UIView *leftView;
@property (strong, nonatomic, nullable) UIView *rightView;

/** Container for rootViewController or rootView. Usually you do not need to use it */
@property (strong, nonatomic, nullable, readonly) UIView *rootViewContainer;
/** Container for leftViewController or leftView. Usually you do not need to use it */
@property (strong, nonatomic, nullable, readonly) UIView *leftViewContainer;
/** Container for rightViewController or rightView. Usually you do not need to use it */
@property (strong, nonatomic, nullable, readonly) UIView *rightViewContainer;

@property (strong, nonatomic, nullable, readonly) UIImageView *leftViewBackgroundView;
@property (strong, nonatomic, nullable, readonly) UIImageView *rightViewBackgroundView;

/** tapGesture.cancelsTouchesInView = NO */
@property (strong, nonatomic, readonly, nonnull) UITapGestureRecognizer *tapGesture;
/** panGesture.cancelsTouchesInView = YES, only inside your swipeGestureArea */
@property (strong, nonatomic, readonly, nonnull) UIPanGestureRecognizer *panGesture;

#pragma mark - Static defaults

/**
 Default:
 if (iPhone) then MainScreen.size.min - 44.0
 else 320.0
 */
@property (assign, nonatomic) IBInspectable CGFloat leftViewWidth;
/**
 Default:
 if (iPhone) then MainScreen.size.min - 44.0
 else 320.0
 */
@property (assign, nonatomic) IBInspectable CGFloat rightViewWidth;

/** Default is LGSideMenuPresentationStyleSlideAbove */
#if TARGET_INTERFACE_BUILDER
@property (assign, nonatomic) IBInspectable NSUInteger leftViewPresentationStyle;
#else
@property (assign, nonatomic) LGSideMenuPresentationStyle leftViewPresentationStyle;
#endif
/** Default is LGSideMenuPresentationStyleSlideAbove */
#if TARGET_INTERFACE_BUILDER
@property (assign, nonatomic) IBInspectable NSUInteger rightViewPresentationStyle;
#else
@property (assign, nonatomic) LGSideMenuPresentationStyle rightViewPresentationStyle;
#endif

/** Default is LGSideMenuAlwaysVisibleOnNone */
#if TARGET_INTERFACE_BUILDER
@property (assign, nonatomic) IBInspectable NSUInteger leftViewAlwaysVisibleOptions;
#else
@property (assign, nonatomic) LGSideMenuAlwaysVisibleOptions leftViewAlwaysVisibleOptions;
#endif
/** Default is LGSideMenuAlwaysVisibleOnNone */
#if TARGET_INTERFACE_BUILDER
@property (assign, nonatomic) IBInspectable NSUInteger rightViewAlwaysVisibleOptions;
#else
@property (assign, nonatomic) LGSideMenuAlwaysVisibleOptions rightViewAlwaysVisibleOptions;
#endif

/** Default is YES */
@property (assign, nonatomic, getter=isLeftViewHidesOnTouch)  IBInspectable BOOL leftViewHidesOnTouch;
/** Default is YES */
@property (assign, nonatomic, getter=isRightViewHidesOnTouch) IBInspectable BOOL rightViewHidesOnTouch;

/** Default is YES */
@property (assign, nonatomic, getter=isLeftViewSwipeGestureEnabled)  IBInspectable BOOL leftViewSwipeGestureEnabled;
/** Default is YES */
@property (assign, nonatomic, getter=isRightViewSwipeGestureEnabled) IBInspectable BOOL rightViewSwipeGestureEnabled;

/** Default is NO */
@property (assign, nonatomic, getter=isLeftViewSwipeGestureDisabled)  BOOL leftViewSwipeGestureDisabled;
/** Default is NO */
@property (assign, nonatomic, getter=isRightViewSwipeGestureDisabled) BOOL rightViewSwipeGestureDisabled;

/** Default is LGSideMenuSwipeGestureAreaBorders */
#if TARGET_INTERFACE_BUILDER
@property (assign, nonatomic) IBInspectable NSUInteger swipeGestureArea;
#else
@property (assign, nonatomic) LGSideMenuSwipeGestureArea swipeGestureArea;
#endif

/**
 Only if (swipeGestureArea == LGSideMenuSwipeGestureAreaBorders)
 Default is LGSideMenuSwipeGestureRangeMake(44.0, 44.0)
 Explanation:
 For LGSideMenuSwipeGestureRangeMake(44.0, 44.0) => leftView 44 | 44 rootView
 For LGSideMenuSwipeGestureRangeMake(0.0, 44.0)  => leftView    | 44 rootView
 For LGSideMenuSwipeGestureRangeMake(44.0, 0.0)  => leftView 44 |    rootView
 */
@property (assign, nonatomic) IBInspectable LGSideMenuSwipeGestureRange leftViewSwipeGestureRange;

/**
 Only if (swipeGestureArea == LGSideMenuSwipeGestureAreaBorders)
 Default is LGSideMenuSwipeGestureRangeMake(44.0, 44.0)
 Explanation:
 For LGSideMenuSwipeGestureRangeMake(44.0, 44.0) => rootView 44 | 44 rightView
 For LGSideMenuSwipeGestureRangeMake(44.0, 0.0)  => rootView 44 |    rightView
 For LGSideMenuSwipeGestureRangeMake(0.0, 44.0)  => rootView    | 44 rightView
 */
@property (assign, nonatomic) IBInspectable LGSideMenuSwipeGestureRange rightViewSwipeGestureRange;

/** Default is 0.5 */
@property (assign, nonatomic) IBInspectable NSTimeInterval leftViewAnimationDuration;
/** Default is 0.5 */
@property (assign, nonatomic) IBInspectable NSTimeInterval rightViewAnimationDuration;

/** Default is YES */
@property (assign, nonatomic) IBInspectable BOOL shouldHideLeftViewAnimated;
/** Default is YES */
@property (assign, nonatomic) IBInspectable BOOL shouldHideRightViewAnimated;

/** Default is YES */
@property (assign, nonatomic, getter=isLeftViewEnabled)  IBInspectable BOOL leftViewEnabled;
/** Default is YES */
@property (assign, nonatomic, getter=isRightViewEnabled) IBInspectable BOOL rightViewEnabled;

/** Default is NO */
@property (assign, nonatomic, getter=isLeftViewDisabled)  BOOL leftViewDisabled;
/** Default is NO */
@property (assign, nonatomic, getter=isRightViewDisabled) BOOL rightViewDisabled;

/** Default is nil */
@property (strong, nonatomic, nullable) IBInspectable UIColor *leftViewBackgroundColor;
/** Default is nil */
@property (strong, nonatomic, nullable) IBInspectable UIColor *rightViewBackgroundColor;

/**
 Only if (presentationStyle != LGSideMenuPresentationStyleSlideAbove)
 Default is nil
 */
@property (strong, nonatomic, nullable) IBInspectable UIImage *leftViewBackgroundImage;
/**
 Only if (presentationStyle != LGSideMenuPresentationStyleSlideAbove)
 Default is nil
 */
@property (strong, nonatomic, nullable) IBInspectable UIImage *rightViewBackgroundImage;

/**
 Only if (presentationStyle == LGSideMenuPresentationStyleSlideAbove)
 Default is nil
 */
@property (strong, nonatomic, nullable) IBInspectable UIBlurEffect *leftViewBackgroundBlurEffect;
/**
 Only if (presentationStyle == LGSideMenuPresentationStyleSlideAbove)
 Default is nil
 */
@property (strong, nonatomic, nullable) IBInspectable UIBlurEffect *rightViewBackgroundBlurEffect;

/**
 Only if (presentationStyle == LGSideMenuPresentationStyleSlideAbove)
 Default is 1.0
 */
@property (assign, nonatomic) IBInspectable CGFloat leftViewBackgroundAlpha;
/**
 Only if (presentationStyle == LGSideMenuPresentationStyleSlideAbove)
 Default is 1.0
 */
@property (assign, nonatomic) IBInspectable CGFloat rightViewBackgroundAlpha;

/** Default is nil */
@property (strong, nonatomic, nullable) IBInspectable UIColor *rootViewLayerBorderColor;
/**
 Only if (presentationStyle == LGSideMenuPresentationStyleSlideAbove)
 Default is nil
 */
@property (strong, nonatomic, nullable) IBInspectable UIColor *leftViewLayerBorderColor;
/**
 Only if (presentationStyle == LGSideMenuPresentationStyleSlideAbove)
 Default is nil
 */
@property (strong, nonatomic, nullable) IBInspectable UIColor *rightViewLayerBorderColor;

/** Default is 0.0 */
@property (assign, nonatomic) IBInspectable CGFloat rootViewLayerBorderWidth;
/**
 Only if (presentationStyle == LGSideMenuPresentationStyleSlideAbove)
 Default is 0.0
 */
@property (assign, nonatomic) IBInspectable CGFloat leftViewLayerBorderWidth;
/**
 Only if (presentationStyle == LGSideMenuPresentationStyleSlideAbove)
 Default is 0.0
 */
@property (assign, nonatomic) IBInspectable CGFloat rightViewLayerBorderWidth;

/** Default is [UIColor colorWithWhite:0.0 alpha:0.5] */
@property (strong, nonatomic, nullable) IBInspectable UIColor *rootViewLayerShadowColor;
/**
 Only if (presentationStyle == LGSideMenuPresentationStyleSlideAbove)
 Default is [UIColor colorWithWhite:0.0 alpha:0.5]
 */
@property (strong, nonatomic, nullable) IBInspectable UIColor *leftViewLayerShadowColor;
/**
 Only if (presentationStyle == LGSideMenuPresentationStyleSlideAbove)
 Default is [UIColor colorWithWhite:0.0 alpha:0.5]
 */
@property (strong, nonatomic, nullable) IBInspectable UIColor *rightViewLayerShadowColor;

/** Default is 5.0 */
@property (assign, nonatomic) IBInspectable CGFloat rootViewLayerShadowRadius;
/**
 Only if (presentationStyle == LGSideMenuPresentationStyleSlideAbove)
 Default is 5.0
 */
@property (assign, nonatomic) IBInspectable CGFloat leftViewLayerShadowRadius;
/**
 Only if (presentationStyle == LGSideMenuPresentationStyleSlideAbove)
 Default is 5.0
 */
@property (assign, nonatomic) IBInspectable CGFloat rightViewLayerShadowRadius;

/** Default is nil */
@property (strong, nonatomic, nullable) IBInspectable UIBlurEffect *rootViewCoverBlurEffectForLeftView;
/** Default is nil */
@property (strong, nonatomic, nullable) IBInspectable UIBlurEffect *rootViewCoverBlurEffectForRightView;
/**
 Only if (presentationStyle != LGSideMenuPresentationStyleSlideAbove)
 Default is nil
 */
@property (strong, nonatomic, nullable) IBInspectable UIBlurEffect *leftViewCoverBlurEffect;
/**
 Only if (presentationStyle != LGSideMenuPresentationStyleSlideAbove)
 Default is nil
 */
@property (strong, nonatomic, nullable) IBInspectable UIBlurEffect *rightViewCoverBlurEffect;

/** Default is 1.0 */
@property (assign, nonatomic) IBInspectable CGFloat rootViewCoverAlphaForLeftView;
/** Default is 1.0 */
@property (assign, nonatomic) IBInspectable CGFloat rootViewCoverAlphaForRightView;
/**
 Only if (presentationStyle != LGSideMenuPresentationStyleSlideAbove)
 Default is 1.0
 */
@property (assign, nonatomic) IBInspectable CGFloat leftViewCoverAlpha;
/**
 Only if (presentationStyle != LGSideMenuPresentationStyleSlideAbove)
 Default is 1.0
 */
@property (assign, nonatomic) IBInspectable CGFloat rightViewCoverAlpha;

#pragma mark - Dynamic defaults

/**
 Default:
 if (rootViewController != nil) then rootViewController.shouldAutorotate
 else super.shouldAutorotate
 */
@property (assign, nonatomic) IBInspectable BOOL rootViewShouldAutorotate;

/**
 Default:
 if (view controller-based status bar appearance == NO) then UIApplication.sharedApplication.statusBarHidden
 else if (rootViewController != nil) then rootViewController.prefersStatusBarHidden
 else super.prefersStatusBarHidden
 */
@property (assign, nonatomic, getter=isRootViewStatusBarHidden) IBInspectable BOOL rootViewStatusBarHidden;
/**
 Default:
 if (view controller-based status bar appearance == NO) then UIApplication.sharedApplication.statusBarHidden
 else if (leftViewController != nil) then leftViewController.prefersStatusBarHidden
 else if (rootViewController != nil) then rootViewController.prefersStatusBarHidden
 else super.prefersStatusBarHidden
 */
@property (assign, nonatomic, getter=isLeftViewStatusBarHidden) IBInspectable BOOL leftViewStatusBarHidden;
/**
 Default:
 if (view controller-based status bar appearance == NO) then UIApplication.sharedApplication.statusBarHidden
 else if (rightViewController != nil) then rightViewController.prefersStatusBarHidden
 else if (rootViewController != nil) then rootViewController.prefersStatusBarHidden
 else super.prefersStatusBarHidden
 */
@property (assign, nonatomic, getter=isRightViewStatusBarHidden) IBInspectable BOOL rightViewStatusBarHidden;

/**
 Default:
 if (view controller-based status bar appearance == NO) then UIApplication.sharedApplication.statusBarStyle
 else if (rootViewController != nil) then rootViewController.preferredStatusBarStyle
 else super.preferredStatusBarStyle
 */
@property (assign, nonatomic) IBInspectable UIStatusBarStyle rootViewStatusBarStyle;
/**
 Default:
 if (view controller-based status bar appearance == NO) then UIApplication.sharedApplication.statusBarStyle
 else if (leftViewController != nil) then leftViewController.preferredStatusBarStyle
 else if (rootViewController != nil) then rootViewController.preferredStatusBarStyle
 else super.preferredStatusBarStyle
 */
@property (assign, nonatomic) IBInspectable UIStatusBarStyle leftViewStatusBarStyle;
/**
 Default:
 if (view controller-based status bar appearance == NO) then UIApplication.sharedApplication.statusBarStyle
 else if (rightViewController != nil) then rightViewController.preferredStatusBarStyle
 else if (rootViewController != nil) then rootViewController.preferredStatusBarStyle
 else super.preferredStatusBarStyle
 */
@property (assign, nonatomic) IBInspectable UIStatusBarStyle rightViewStatusBarStyle;

/**
 Default:
 if (rootViewController != nil) then rootViewController.preferredStatusBarUpdateAnimation
 else super.preferredStatusBarUpdateAnimation
 */
@property (assign, nonatomic) IBInspectable UIStatusBarAnimation rootViewStatusBarUpdateAnimation;
/**
 Default:
 if (leftViewController != nil) then leftViewController.preferredStatusBarUpdateAnimation
 else if (rootViewController != nil) then rootViewController.preferredStatusBarUpdateAnimation
 else super.preferredStatusBarUpdateAnimation
 */
@property (assign, nonatomic) IBInspectable UIStatusBarAnimation leftViewStatusBarUpdateAnimation;
/**
 Default:
 if (rightViewController != nil) then rightViewController.preferredStatusBarUpdateAnimation
 else if (rootViewController != nil) then rootViewController.preferredStatusBarUpdateAnimation
 else super.preferredStatusBarUpdateAnimation
 */
@property (assign, nonatomic) IBInspectable UIStatusBarAnimation rightViewStatusBarUpdateAnimation;

/**
 Color that hides root view, when left view is showing
 Default:
 if (presentationStyle == LGSideMenuPresentationStyleSlideAbove) then [UIColor colorWithWhite:0.0 alpha:0.5]
 else nil
 */
@property (strong, nonatomic, nullable) IBInspectable UIColor *rootViewCoverColorForLeftView;
/**
 Color that hides root view, when right view is showing
 Default:
 if (presentationStyle == LGSideMenuPresentationStyleSlideAbove) then [UIColor colorWithWhite:0.0 alpha:0.5]
 else nil
 */
@property (strong, nonatomic, nullable) IBInspectable UIColor *rootViewCoverColorForRightView;
/**
 Color that hides left view, when it is not showing
 Only if (presentationStyle != LGSideMenuPresentationStyleSlideAbove)
 Default is [UIColor colorWithWhite:0.0 alpha:0.5]
 */
@property (strong, nonatomic, nullable) IBInspectable UIColor *leftViewCoverColor;
/**
 Color that hides right view, when it is not showing
 Only if (presentationStyle != LGSideMenuPresentationStyleSlideAbove)
 Default is [UIColor colorWithWhite:0.0 alpha:0.5]
 */
@property (strong, nonatomic, nullable) IBInspectable UIColor *rightViewCoverColor;

/**
 Only if (presentationStyle != LGSideMenuPresentationStyleSlideAbove)
 Default:
 if (presentationStyle == LGSideMenuPresentationStyleSlideBelow) then 1.0
 else 0.8
 */
@property (assign, nonatomic) IBInspectable CGFloat rootViewScaleForLeftView;
/**
 Only if (presentationStyle != LGSideMenuPresentationStyleSlideAbove)
 Default:
 if (presentationStyle == LGSideMenuPresentationStyleSlideBelow) then 1.0
 else 0.8
 */
@property (assign, nonatomic) IBInspectable CGFloat rootViewScaleForRightView;

/**
 Only if (presentationStyle != LGSideMenuPresentationStyleSlideAbove)
 Default:
 if (presentationStyle == LGSideMenuPresentationStyleSlideBelow) then 1.0
 else if (presentationStyle == LGSideMenuPresentationStyleScaleFromBig) then 1.2
 else if (presentationStyle == LGSideMenuPresentationStyleScaleFromLittle) then 0.8
 */
@property (assign, nonatomic) IBInspectable CGFloat leftViewInitialScale;
/**
 Only if (presentationStyle != LGSideMenuPresentationStyleSlideAbove)
 Default:
 if (presentationStyle == LGSideMenuPresentationStyleSlideBelow) then 1.0
 else if (presentationStyle == LGSideMenuPresentationStyleScaleFromBig) then 1.2
 else if (presentationStyle == LGSideMenuPresentationStyleScaleFromLittle) then 0.8
 */
@property (assign, nonatomic) IBInspectable CGFloat rightViewInitialScale;

/**
 Only if (presentationStyle != LGSideMenuPresentationStyleSlideAbove)
 Default:
 if (presentationStyle == LGSideMenuPresentationStyleSlideBelow) then -width/2
 else 0.0
 */
@property (assign, nonatomic) IBInspectable CGFloat leftViewInitialOffsetX;
/**
 Only if (presentationStyle != LGSideMenuPresentationStyleSlideAbove)
 Default:
 if (presentationStyle == LGSideMenuPresentationStyleSlideBelow) then -width/2
 else 0.0
 */
@property (assign, nonatomic) IBInspectable CGFloat rightViewInitialOffsetX;

/**
 Only if (presentationStyle != LGSideMenuPresentationStyleSlideAbove)
 Default:
 if (presentationStyle == LGSideMenuPresentationStyleScaleFromBig) then 1.4
 else 1.0
 */
@property (assign, nonatomic) IBInspectable CGFloat leftViewBackgroundImageInitialScale;
/**
 Only if (presentationStyle != LGSideMenuPresentationStyleSlideAbove)
 Default:
 if (presentationStyle == LGSideMenuPresentationStyleScaleFromBig) then 1.4
 else 1.0
 */
@property (assign, nonatomic) IBInspectable CGFloat rightViewBackgroundImageInitialScale;

/**
 Only if (presentationStyle != LGSideMenuPresentationStyleSlideAbove)
 Default:
 if (presentationStyle == LGSideMenuPresentationStyleScaleFromLittle) then 1.4
 else 1.0
 */
@property (assign, nonatomic) IBInspectable CGFloat leftViewBackgroundImageFinalScale;
/**
 Only if (presentationStyle != LGSideMenuPresentationStyleSlideAbove)
 Default:
 if (presentationStyle == LGSideMenuPresentationStyleScaleFromLittle) then 1.4
 else 1.0
 */
@property (assign, nonatomic) IBInspectable CGFloat rightViewBackgroundImageFinalScale;

#pragma mark - Only getters

/** Is left view fully opened */
@property (assign, nonatomic, readonly, getter=isLeftViewShowing)  BOOL leftViewShowing;
/** Is right view fully opened */
@property (assign, nonatomic, readonly, getter=isRightViewShowing) BOOL rightViewShowing;

/** Is left view fully closed */
@property (assign, nonatomic, readonly, getter=isLeftViewHidden)  BOOL leftViewHidden;
/** Is right view fully closed */
@property (assign, nonatomic, readonly, getter=isRightViewHidden) BOOL rightViewHidden;

/** Is left view showing or going to show or going to hide right now */
@property (assign, nonatomic, readonly, getter=isLeftViewVisible)  BOOL leftViewVisible;
/** Is right view showing or going to show or going to hide right now */
@property (assign, nonatomic, readonly, getter=isRightViewVisible) BOOL rightViewVisible;

/** Is left view has property "always visible" for current orientation */
@property (assign, nonatomic, readonly, getter=isLeftViewAlwaysVisibleForCurrentOrientation)  BOOL leftViewAlwaysVisibleForCurrentOrientation;
/** Is right view has property "always visible" for current orientation */
@property (assign, nonatomic, readonly, getter=isRightViewAlwaysVisibleForCurrentOrientation) BOOL rightViewAlwaysVisibleForCurrentOrientation;

#pragma mark - Callbacks

/** To avoid retain cycle, do not forget about weak reference to self */
@property (copy, nonatomic, nullable) LGSideMenuHandler willShowLeftView;
/** To avoid retain cycle, do not forget about weak reference to self */
@property (copy, nonatomic, nullable) LGSideMenuHandler didShowLeftView;

/** To avoid retain cycle, do not forget about weak reference to self */
@property (copy, nonatomic, nullable) LGSideMenuHandler willHideLeftView;
/** To avoid retain cycle, do not forget about weak reference to self */
@property (copy, nonatomic, nullable) LGSideMenuHandler didHideLeftView;

/** To avoid retain cycle, do not forget about weak reference to self */
@property (copy, nonatomic, nullable) LGSideMenuHandler willShowRightView;
/** To avoid retain cycle, do not forget about weak reference to self */
@property (copy, nonatomic, nullable) LGSideMenuHandler didShowRightView;

/** To avoid retain cycle, do not forget about weak reference to self */
@property (copy, nonatomic, nullable) LGSideMenuHandler willHideRightView;
/** To avoid retain cycle, do not forget about weak reference to self */
@property (copy, nonatomic, nullable) LGSideMenuHandler didHideRightView;

/**
 You can use this block to add some custom animations
 To avoid retain cycle, do not forget about weak reference to self
 */
@property (copy, nonatomic, nullable) LGSideMenuAnimationsBlock showLeftViewAnimations;
/**
 You can use this block to add some custom animations
 To avoid retain cycle, do not forget about weak reference to self
 */
@property (copy, nonatomic, nullable) LGSideMenuAnimationsBlock hideLeftViewAnimations;

/**
 You can use this block to add some custom animations
 To avoid retain cycle, do not forget about weak reference to self
 */
@property (copy, nonatomic, nullable) LGSideMenuAnimationsBlock showRightViewAnimations;
/**
 You can use this block to add some custom animations
 To avoid retain cycle, do not forget about weak reference to self
 */
@property (copy, nonatomic, nullable) LGSideMenuAnimationsBlock hideRightViewAnimations;

#pragma mark - Delegate

@property (weak, nonatomic, nullable) id <LGSideMenuDelegate> delegate;

#pragma mark - Initialization

- (nonnull instancetype)initWithRootViewController:(nullable UIViewController *)rootViewController;

+ (nonnull instancetype)sideMenuControllerWithRootViewController:(nullable UIViewController *)rootViewController;

- (nonnull instancetype)initWithRootViewController:(nullable UIViewController *)rootViewController
                                leftViewController:(nullable UIViewController *)leftViewController
                               rightViewController:(nullable UIViewController *)rightViewController;

+ (nonnull instancetype)sideMenuControllerWithRootViewController:(nullable UIViewController *)rootViewController
                                              leftViewController:(nullable UIViewController *)leftViewController
                                             rightViewController:(nullable UIViewController *)rightViewController;

- (nonnull instancetype)initWithRootView:(nullable UIView *)rootView;

+ (nonnull instancetype)sideMenuControllerWithRootView:(nullable UIView *)rootView;

- (nonnull instancetype)initWithRootView:(nullable UIView *)rootView
                                leftView:(nullable UIView *)leftView
                               rightView:(nullable UIView *)rightView;

+ (nonnull instancetype)sideMenuControllerWithRootView:(nullable UIView *)rootView
                                              leftView:(nullable UIView *)leftView
                                             rightView:(nullable UIView *)rightView;

#pragma mark -

- (void)rootViewWillLayoutSubviewsWithSize:(CGSize)size;
- (void)leftViewWillLayoutSubviewsWithSize:(CGSize)size;
- (void)rightViewWillLayoutSubviewsWithSize:(CGSize)size;

- (BOOL)isLeftViewAlwaysVisibleForOrientation:(UIInterfaceOrientation)orientation;
- (BOOL)isRightViewAlwaysVisibleForOrientation:(UIInterfaceOrientation)orientation;

#pragma mark - Left view actions

- (void)showLeftView;
- (void)hideLeftView;
- (void)toggleLeftView;

- (IBAction)showLeftView:(nullable id)sender;
- (IBAction)hideLeftView:(nullable id)sender;
- (IBAction)toggleLeftView:(nullable id)sender;

- (void)showLeftViewAnimated;
- (void)hideLeftViewAnimated;
- (void)toggleLeftViewAnimated;

- (IBAction)showLeftViewAnimated:(nullable id)sender;
- (IBAction)hideLeftViewAnimated:(nullable id)sender;
- (IBAction)toggleLeftViewAnimated:(nullable id)sender;

- (void)showLeftViewAnimated:(BOOL)animated completionHandler:(LGSideMenuCompletionHandler)completionHandler;
- (void)hideLeftViewAnimated:(BOOL)animated completionHandler:(LGSideMenuCompletionHandler)completionHandler;
- (void)toggleLeftViewAnimated:(BOOL)animated completionHandler:(LGSideMenuCompletionHandler)completionHandler;

/**
 Rarely you can get some visual bugs when you change view hierarchy and toggle side views in the same iteration
 You can use delay to avoid this and probably other unexpected visual bugs
 */
- (void)showLeftViewAnimated:(BOOL)animated delay:(NSTimeInterval)delay completionHandler:(LGSideMenuCompletionHandler)completionHandler;

/**
 Rarely you can get some visual bugs when you change view hierarchy and toggle side views in the same iteration
 You can use delay to avoid this and probably other unexpected visual bugs
 */
- (void)hideLeftViewAnimated:(BOOL)animated delay:(NSTimeInterval)delay completionHandler:(LGSideMenuCompletionHandler)completionHandler;

/**
 Rarely you can get some visual bugs when you change view hierarchy and toggle side views in the same iteration
 You can use delay to avoid this and probably other unexpected visual bugs
 */
- (void)toggleLeftViewAnimated:(BOOL)animated delay:(NSTimeInterval)delay completionHandler:(LGSideMenuCompletionHandler)completionHandler;

#pragma mark - Right view actions

- (void)showRightView;
- (void)hideRightView;
- (void)toggleRightView;

- (IBAction)showRightView:(nullable id)sender;
- (IBAction)hideRightView:(nullable id)sender;
- (IBAction)toggleRightView:(nullable id)sender;

- (void)showRightViewAnimated;
- (void)hideRightViewAnimated;
- (void)toggleRightViewAnimated;

- (IBAction)showRightViewAnimated:(nullable id)sender;
- (IBAction)hideRightViewAnimated:(nullable id)sender;
- (IBAction)toggleRightViewAnimated:(nullable id)sender;

- (void)showRightViewAnimated:(BOOL)animated completionHandler:(LGSideMenuCompletionHandler)completionHandler;
- (void)hideRightViewAnimated:(BOOL)animated completionHandler:(LGSideMenuCompletionHandler)completionHandler;
- (void)toggleRightViewAnimated:(BOOL)animated completionHandler:(LGSideMenuCompletionHandler)completionHandler;

/**
 Rarely you can get some visual bugs when you change view hierarchy and toggle side views in the same iteration
 You can use delay to avoid this and probably other unexpected visual bugs
 */
- (void)showRightViewAnimated:(BOOL)animated delay:(NSTimeInterval)delay completionHandler:(LGSideMenuCompletionHandler)completionHandler;

/**
 Rarely you can get some visual bugs when you change view hierarchy and toggle side views in the same iteration
 You can use delay to avoid this and probably other unexpected visual bugs
 */
- (void)hideRightViewAnimated:(BOOL)animated delay:(NSTimeInterval)delay completionHandler:(LGSideMenuCompletionHandler)completionHandler;

/**
 Rarely you can get some visual bugs when you change view hierarchy and toggle side views in the same iteration
 You can use delay to avoid this and probably other unexpected visual bugs
 */
- (void)toggleRightViewAnimated:(BOOL)animated delay:(NSTimeInterval)delay completionHandler:(LGSideMenuCompletionHandler)completionHandler;

#pragma mark -

/** Force update layouts and styles for all views */
- (void)updateLayoutsAndStyles;

#pragma mark - Unavailable methods

/** Unavailable, select it on your rootViewController OR use rootViewShouldAutorotate */
- (BOOL)shouldAutorotate __attribute__((unavailable("select it on your rootViewController OR use rootViewShouldAutorotate")));
/** Unavailable, select it on your rootViewController, leftViewController, rightViewController OR use rootViewStatusBarHidden, leftViewStatusBarHidden, rightViewStatusBarHidden */
- (BOOL)prefersStatusBarHidden __attribute__((unavailable("select it on your rootViewController, leftViewController, rightViewController OR use rootViewStatusBarHidden, leftViewStatusBarHidden, rightViewStatusBarHidden")));
/** Unavailable, select it on your rootViewController, leftViewController, rightViewController OR use rootViewStatusBarStyle, leftViewStatusBarStyle, rightViewStatusBarStyle */
- (UIStatusBarStyle)preferredStatusBarStyle __attribute__((unavailable("select it on your rootViewController, leftViewController, rightViewController OR use rootViewStatusBarStyle, leftViewStatusBarStyle, rightViewStatusBarStyle")));
/** Unavailable, select it on your rootViewController, leftViewController, rightViewController OR use rootViewStatusBarUpdateAnimation, leftViewStatusBarUpdateAnimation, rightViewStatusBarUpdateAnimation */
- (UIStatusBarAnimation)preferredStatusBarUpdateAnimation __attribute__((unavailable("select it on your rootViewController, leftViewController, rightViewController OR use rootViewStatusBarUpdateAnimation, leftViewStatusBarUpdateAnimation, rightViewStatusBarUpdateAnimation")));

@end

#pragma mark - Delegate

@protocol LGSideMenuDelegate <NSObject>

@optional

- (void)willShowLeftView:(nonnull UIView *)leftView sideMenuController:(nonnull LGSideMenuController *)sideMenuController;
- (void)didShowLeftView:(nonnull UIView *)leftView sideMenuController:(nonnull LGSideMenuController *)sideMenuController;

- (void)willHideLeftView:(nonnull UIView *)leftView sideMenuController:(nonnull LGSideMenuController *)sideMenuController;
- (void)didHideLeftView:(nonnull UIView *)leftView sideMenuController:(nonnull LGSideMenuController *)sideMenuController;

- (void)willShowRightView:(nonnull UIView *)rightView sideMenuController:(nonnull LGSideMenuController *)sideMenuController;
- (void)didShowRightView:(nonnull UIView *)rightView sideMenuController:(nonnull LGSideMenuController *)sideMenuController;

- (void)willHideRightView:(nonnull UIView *)rightView sideMenuController:(nonnull LGSideMenuController *)sideMenuController;
- (void)didHideRightView:(nonnull UIView *)rightView sideMenuController:(nonnull LGSideMenuController *)sideMenuController;

/** You can use this method to add some custom animations */
- (void)showAnimationsForLeftView:(nonnull UIView *)leftView sideMenuController:(nonnull LGSideMenuController *)sideMenuController duration:(NSTimeInterval)duration;
/** You can use this method to add some custom animations */
- (void)hideAnimationsForLeftView:(nonnull UIView *)leftView sideMenuController:(nonnull LGSideMenuController *)sideMenuController duration:(NSTimeInterval)duration;

/** You can use this method to add some custom animations */
- (void)showAnimationsForRightView:(nonnull UIView *)rightView sideMenuController:(nonnull LGSideMenuController *)sideMenuController duration:(NSTimeInterval)duration;
/** You can use this method to add some custom animations */
- (void)hideAnimationsForRightView:(nonnull UIView *)rightView sideMenuController:(nonnull LGSideMenuController *)sideMenuController duration:(NSTimeInterval)duration;

// DEPRECATED

/** You can use this method to add some custom animations */
- (void)showAnimationsBlockForLeftView:(nonnull UIView *)leftView sideMenuController:(nonnull LGSideMenuController *)sideMenuController duration:(NSTimeInterval)duration
DEPRECATED_MSG_ATTRIBUTE("use showAnimationsForRightView:sideMenuController:duration: instead");
/** You can use this method to add some custom animations */
- (void)hideAnimationsBlockForLeftView:(nonnull UIView *)leftView sideMenuController:(nonnull LGSideMenuController *)sideMenuController duration:(NSTimeInterval)duration
DEPRECATED_MSG_ATTRIBUTE("use hideAnimationsForLeftView:sideMenuController:duration: instead");

/** You can use this method to add some custom animations */
- (void)showAnimationsBlockForRightView:(nonnull UIView *)rightView sideMenuController:(nonnull LGSideMenuController *)sideMenuController duration:(NSTimeInterval)duration
DEPRECATED_MSG_ATTRIBUTE("use showAnimationsForRightView:sideMenuController:duration: instead");
/** You can use this method to add some custom animations */
- (void)hideAnimationsBlockForRightView:(nonnull UIView *)rightView sideMenuController:(nonnull LGSideMenuController *)sideMenuController duration:(NSTimeInterval)duration
DEPRECATED_MSG_ATTRIBUTE("use hideAnimationsForRightView:sideMenuController:duration: instead");

@end

#pragma mark - Deprecated

extern NSString * _Nonnull const LGSideMenuControllerWillDismissLeftViewNotification
DEPRECATED_MSG_ATTRIBUTE("use LGSideMenuWillHideLeftViewNotification instead");
extern NSString * _Nonnull const LGSideMenuControllerDidDismissLeftViewNotification
DEPRECATED_MSG_ATTRIBUTE("use LGSideMenuDidHideLeftViewNotification instead");
extern NSString * _Nonnull const LGSideMenuControllerWillDismissRightViewNotification
DEPRECATED_MSG_ATTRIBUTE("use LGSideMenuWillHideRightViewNotification instead");
extern NSString * _Nonnull const LGSideMenuControllerDidDismissRightViewNotification
DEPRECATED_MSG_ATTRIBUTE("use LGSideMenuDidHideRightViewNotification instead");

extern NSString * _Nonnull const kLGSideMenuControllerWillShowLeftViewNotification
DEPRECATED_MSG_ATTRIBUTE("use LGSideMenuWillShowLeftViewNotification instead");
extern NSString * _Nonnull const kLGSideMenuControllerWillHideLeftViewNotification
DEPRECATED_MSG_ATTRIBUTE("use LGSideMenuWillHideLeftViewNotification instead");
extern NSString * _Nonnull const kLGSideMenuControllerDidShowLeftViewNotification
DEPRECATED_MSG_ATTRIBUTE("use LGSideMenuDidShowLeftViewNotification instead");
extern NSString * _Nonnull const kLGSideMenuControllerDidHideLeftViewNotification
DEPRECATED_MSG_ATTRIBUTE("use LGSideMenuDidHideLeftViewNotification instead");

extern NSString * _Nonnull const kLGSideMenuControllerWillShowRightViewNotification
DEPRECATED_MSG_ATTRIBUTE("use LGSideMenuWillShowRightViewNotification instead");
extern NSString * _Nonnull const kLGSideMenuControllerWillHideRightViewNotification
DEPRECATED_MSG_ATTRIBUTE("use LGSideMenuWillHideRightViewNotification instead");
extern NSString * _Nonnull const kLGSideMenuControllerDidShowRightViewNotification
DEPRECATED_MSG_ATTRIBUTE("use LGSideMenuDidShowRightViewNotification instead");
extern NSString * _Nonnull const kLGSideMenuControllerDidHideRightViewNotification
DEPRECATED_MSG_ATTRIBUTE("use LGSideMenuDidHideRightViewNotification instead");

extern NSString * _Nonnull const LGSideMenuControllerWillShowLeftViewNotification
DEPRECATED_MSG_ATTRIBUTE("use LGSideMenuWillShowLeftViewNotification instead");
extern NSString * _Nonnull const LGSideMenuControllerDidShowLeftViewNotification
DEPRECATED_MSG_ATTRIBUTE("use LGSideMenuDidShowLeftViewNotification instead");

extern NSString * _Nonnull const LGSideMenuControllerWillHideLeftViewNotification
DEPRECATED_MSG_ATTRIBUTE("use LGSideMenuWillHideLeftViewNotification instead");
extern NSString * _Nonnull const LGSideMenuControllerDidHideLeftViewNotification
DEPRECATED_MSG_ATTRIBUTE("use LGSideMenuDidHideLeftViewNotification instead");

extern NSString * _Nonnull const LGSideMenuControllerWillShowRightViewNotification
DEPRECATED_MSG_ATTRIBUTE("use LGSideMenuWillShowRightViewNotification instead");
extern NSString * _Nonnull const LGSideMenuControllerDidShowRightViewNotification
DEPRECATED_MSG_ATTRIBUTE("use LGSideMenuDidShowRightViewNotification instead");

extern NSString * _Nonnull const LGSideMenuControllerWillHideRightViewNotification
DEPRECATED_MSG_ATTRIBUTE("use LGSideMenuWillHideRightViewNotification instead");
extern NSString * _Nonnull const LGSideMenuControllerDidHideRightViewNotification
DEPRECATED_MSG_ATTRIBUTE("use LGSideMenuDidHideRightViewNotification instead");

@interface LGSideMenuController (Deprecated)

@property (assign, nonatomic, getter=isShouldShowLeftView) IBInspectable BOOL shouldShowLeftView
DEPRECATED_MSG_ATTRIBUTE("use leftViewEnabled instead");
@property (assign, nonatomic, getter=isShouldShowRightView) IBInspectable BOOL shouldShowRightView
DEPRECATED_MSG_ATTRIBUTE("use rightViewEnabled instead");

@property (assign, nonatomic, readonly, getter=isLeftViewAlwaysVisible) BOOL leftViewAlwaysVisible
DEPRECATED_MSG_ATTRIBUTE("use leftViewAlwaysVisibleForCurrentOrientation instead");
@property (assign, nonatomic, readonly, getter=isRightViewAlwaysVisible) BOOL rightViewAlwaysVisible
DEPRECATED_MSG_ATTRIBUTE("use rightViewAlwaysVisibleForCurrentOrientation instead");

@property (assign, nonatomic) IBInspectable NSTimeInterval leftViewAnimationSpeed
DEPRECATED_MSG_ATTRIBUTE("use leftViewAnimationDuration instead");
@property (assign, nonatomic) IBInspectable NSTimeInterval rightViewAnimationSpeed
DEPRECATED_MSG_ATTRIBUTE("use rightViewAnimationDuration instead");

@property (copy, nonatomic, nullable) LGSideMenuAnimationsBlock showLeftViewAnimationsBlock
DEPRECATED_MSG_ATTRIBUTE("use showLeftViewAnimations instead");
@property (copy, nonatomic, nullable) LGSideMenuAnimationsBlock hideLeftViewAnimationsBlock
DEPRECATED_MSG_ATTRIBUTE("use hideLeftViewAnimations instead");

@property (copy, nonatomic, nullable) LGSideMenuAnimationsBlock showRightViewAnimationsBlock
DEPRECATED_MSG_ATTRIBUTE("use showRightViewAnimations instead");
@property (copy, nonatomic, nullable) LGSideMenuAnimationsBlock hideRightViewAnimationsBlock
DEPRECATED_MSG_ATTRIBUTE("use hideRightViewAnimations instead");

- (void)showHideLeftViewAnimated:(BOOL)animated completionHandler:(LGSideMenuCompletionHandler)completionHandler
DEPRECATED_MSG_ATTRIBUTE("use toggleLeftViewAnimated:completionHandler instead");
- (void)showHideRightViewAnimated:(BOOL)animated completionHandler:(LGSideMenuCompletionHandler)completionHandler
DEPRECATED_MSG_ATTRIBUTE("use toggleRightViewAnimated:completionHandler instead");

- (BOOL)isLeftViewAlwaysVisibleForInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
DEPRECATED_MSG_ATTRIBUTE("use isLeftViewAlwaysVisibleForOrientation instead");
- (BOOL)isRightViewAlwaysVisibleForInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
DEPRECATED_MSG_ATTRIBUTE("use isRightViewAlwaysVisibleForOrientation instead");

- (void)setLeftViewEnabledWithWidth:(CGFloat)width
                  presentationStyle:(LGSideMenuPresentationStyle)presentationStyle
               alwaysVisibleOptions:(LGSideMenuAlwaysVisibleOptions)alwaysVisibleOptions DEPRECATED_ATTRIBUTE;

- (void)setRightViewEnabledWithWidth:(CGFloat)width
                   presentationStyle:(LGSideMenuPresentationStyle)presentationStyle
                alwaysVisibleOptions:(LGSideMenuAlwaysVisibleOptions)alwaysVisibleOptions DEPRECATED_ATTRIBUTE;

@end
