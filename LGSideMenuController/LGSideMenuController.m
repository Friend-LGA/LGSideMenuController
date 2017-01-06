//
//  LGSideMenuController.m
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

#import <objc/runtime.h>

#import "LGSideMenuController.h"
#import "LGSideMenuView.h"
#import "LGSideMenuControllerGesturesHandler.h"

#pragma mark -

LGSideMenuSwipeGestureRange LGSideMenuSwipeGestureRangeMake(CGFloat left, CGFloat right) {
    LGSideMenuSwipeGestureRange range;
    range.left = left;
    range.right = right;
    return range;
}

#pragma mark -

@interface LGSideMenuController ()

@property (strong, nonatomic, readwrite) LGSideMenuView *rootViewContainer;
@property (strong, nonatomic, readwrite) LGSideMenuView *leftViewContainer;
@property (strong, nonatomic, readwrite) LGSideMenuView *rightViewContainer;

@property (assign, nonatomic, readwrite, getter=isLeftViewShowing)  BOOL leftViewShowing;
@property (assign, nonatomic, readwrite, getter=isRightViewShowing) BOOL rightViewShowing;

@property (assign, nonatomic, getter=isLeftViewGoingToShow) BOOL leftViewGoingToShow;
@property (assign, nonatomic, getter=isLeftViewGoingToHide) BOOL leftViewGoingToHide;

@property (assign, nonatomic, getter=isRightViewGoingToShow) BOOL rightViewGoingToShow;
@property (assign, nonatomic, getter=isRightViewGoingToHide) BOOL rightViewGoingToHide;

@property (assign, nonatomic) CGSize savedSize;

@property (strong, nonatomic) UIView *backgroundColorViewForLeftView;
@property (strong, nonatomic) UIView *backgroundColorViewForRightView;

@property (strong, nonatomic) UIImageView *backgroundImageViewForLeftView;
@property (strong, nonatomic) UIImageView *backgroundImageViewForRightView;

@property (strong, nonatomic) UIView *rootViewStyleView;
@property (strong, nonatomic) UIVisualEffectView *leftViewStyleView;
@property (strong, nonatomic) UIVisualEffectView *rightViewStyleView;

@property (strong, nonatomic) UIVisualEffectView *rootViewCoverView;
@property (strong, nonatomic) UIVisualEffectView *sideViewsCoverView;

@property (strong, nonatomic) NSNumber *leftViewGestireStartX;
@property (strong, nonatomic) NSNumber *rightViewGestireStartX;

@property (assign, nonatomic, getter=isLeftViewShowingBeforeGesture)  BOOL leftViewShowingBeforeGesture;
@property (assign, nonatomic, getter=isRightViewShowingBeforeGesture) BOOL rightViewShowingBeforeGesture;

@property (strong, nonatomic) LGSideMenuControllerGesturesHandler *gesturesHandler;

@property (strong, nonatomic, readwrite) UITapGestureRecognizer *tapGesture;
@property (strong, nonatomic, readwrite) UIPanGestureRecognizer *panGesture;

@property (assign, nonatomic, getter=isUserRootViewShouldAutorotate)             BOOL userRootViewShouldAutorotate;
@property (assign, nonatomic, getter=isUserRootViewStatusBarHidden)              BOOL userRootViewStatusBarHidden;
@property (assign, nonatomic, getter=isUserLeftViewStatusBarHidden)              BOOL userLeftViewStatusBarHidden;
@property (assign, nonatomic, getter=isUserRightViewStatusBarHidden)             BOOL userRightViewStatusBarHidden;
@property (assign, nonatomic, getter=isUserRootViewStatusBarStyle)               BOOL userRootViewStatusBarStyle;
@property (assign, nonatomic, getter=isUserLeftViewStatusBarStyle)               BOOL userLeftViewStatusBarStyle;
@property (assign, nonatomic, getter=isUserRightViewStatusBarStyle)              BOOL userRightViewStatusBarStyle;
@property (assign, nonatomic, getter=isUserRootViewStatusBarUpdateAnimation)     BOOL userRootViewStatusBarUpdateAnimation;
@property (assign, nonatomic, getter=isUserLeftViewStatusBarUpdateAnimation)     BOOL userLeftViewStatusBarUpdateAnimation;
@property (assign, nonatomic, getter=isUserRightViewStatusBarUpdateAnimation)    BOOL userRightViewStatusBarUpdateAnimation;
@property (assign, nonatomic, getter=isUserRootViewCoverColorForLeftView)        BOOL userRootViewCoverColorForLeftView;
@property (assign, nonatomic, getter=isUserRootViewCoverColorForRightView)       BOOL userRootViewCoverColorForRightView;
@property (assign, nonatomic, getter=isUserLeftViewCoverColor)                   BOOL userLeftViewCoverColor;
@property (assign, nonatomic, getter=isUserRightViewCoverColor)                  BOOL userRightViewCoverColor;
@property (assign, nonatomic, getter=isUserRootViewScaleForLeftView)             BOOL userRootViewScaleForLeftView;
@property (assign, nonatomic, getter=isUserRootViewScaleForRightView)            BOOL userRootViewScaleForRightView;
@property (assign, nonatomic, getter=isUserLeftViewInititialScale)               BOOL userLeftViewInititialScale;
@property (assign, nonatomic, getter=isUserRightViewInititialScale)              BOOL userRightViewInititialScale;
@property (assign, nonatomic, getter=isUserLeftViewInititialOffsetX)             BOOL userLeftViewInititialOffsetX;
@property (assign, nonatomic, getter=isUserRightViewInititialOffsetX)            BOOL userRightViewInititialOffsetX;
@property (assign, nonatomic, getter=isUserLeftViewBackgroundImageInitialScale)  BOOL userLeftViewBackgroundImageInitialScale;
@property (assign, nonatomic, getter=isUserRightViewBackgroundImageInitialScale) BOOL userRightViewBackgroundImageInitialScale;

@end

@implementation LGSideMenuController

@synthesize
rootViewController = _rootViewController,
leftViewBackgroundImage = _leftViewBackgroundImage,
rightViewBackgroundImage = _rightViewBackgroundImage,
leftViewBackgroundBlurEffect = _leftViewBackgroundBlurEffect,
rightViewBackgroundBlurEffect = _rightViewBackgroundBlurEffect,
leftViewBackgroundAlpha = _leftViewBackgroundAlpha,
rightViewBackgroundAlpha = _rightViewBackgroundAlpha,
rootViewLayerShadowColor = _rootViewLayerShadowColor,
leftViewLayerShadowColor = _leftViewLayerShadowColor,
rightViewLayerShadowColor = _rightViewLayerShadowColor,
rootViewLayerShadowRadius = _rootViewLayerShadowRadius,
leftViewLayerShadowRadius = _leftViewLayerShadowRadius,
rightViewLayerShadowRadius = _rightViewLayerShadowRadius,
leftViewCoverBlurEffect = _leftViewCoverBlurEffect,
rightViewCoverBlurEffect = _rightViewCoverBlurEffect,
leftViewCoverAlpha = _leftViewCoverAlpha,
rightViewCoverAlpha = _rightViewCoverAlpha,
rootViewShouldAutorotate = _rootViewShouldAutorotate,
rootViewStatusBarHidden = _rootViewStatusBarHidden,
leftViewStatusBarHidden = _leftViewStatusBarHidden,
rightViewStatusBarHidden = _rightViewStatusBarHidden,
rootViewStatusBarStyle = _rootViewStatusBarStyle,
leftViewStatusBarStyle = _leftViewStatusBarStyle,
rightViewStatusBarStyle = _rightViewStatusBarStyle,
rootViewStatusBarUpdateAnimation = _rootViewStatusBarUpdateAnimation,
leftViewStatusBarUpdateAnimation = _leftViewStatusBarUpdateAnimation,
rightViewStatusBarUpdateAnimation = _rightViewStatusBarUpdateAnimation,
rootViewCoverColorForLeftView = _rootViewCoverColorForLeftView,
rootViewCoverColorForRightView = _rootViewCoverColorForRightView,
leftViewCoverColor = _leftViewCoverColor,
rightViewCoverColor = _rightViewCoverColor,
rootViewScaleForLeftView = _rootViewScaleForLeftView,
rootViewScaleForRightView = _rootViewScaleForRightView,
leftViewInititialScale = _leftViewInititialScale,
rightViewInititialScale = _rightViewInititialScale,
leftViewInititialOffsetX = _leftViewInititialOffsetX,
rightViewInititialOffsetX = _rightViewInititialOffsetX,
leftViewBackgroundImageInitialScale = _leftViewBackgroundImageInitialScale,
rightViewBackgroundImageInitialScale = _rightViewBackgroundImageInitialScale;

- (nonnull instancetype)init {
    self = [super init];
    if (self) {
        [self setupDefaultProperties];
        [self setupDefaults];
    }
    return self;
}

- (nonnull instancetype)initWithRootViewController:(nullable UIViewController *)rootViewController {
    self = [super init];
    if (self) {
        [self setupDefaultProperties];
        [self setupDefaults];

        self.rootViewController = rootViewController;
    }
    return self;
}

+ (nonnull instancetype)sideMenuControllerWithRootViewController:(nullable UIViewController *)rootViewController {
    return [[self alloc] initWithRootViewController:rootViewController];
}

- (nonnull instancetype)initWithRootViewController:(nullable UIViewController *)rootViewController
                                leftViewController:(nullable UIViewController *)leftViewController
                               rightViewController:(nullable UIViewController *)rightViewController {
    self = [super init];
    if (self) {
        [self setupDefaultProperties];
        [self setupDefaults];

        self.rootViewController = rootViewController;
        self.leftViewController = leftViewController;
        self.rightViewController = rightViewController;
    }
    return self;
}

+ (nonnull instancetype)sideMenuControllerWithRootViewController:(nullable UIViewController *)rootViewController
                                              leftViewController:(nullable UIViewController *)leftViewController
                                             rightViewController:(nullable UIViewController *)rightViewController {
    return [[self alloc] initWithRootViewController:rootViewController
                                 leftViewController:leftViewController
                                rightViewController:rightViewController];
}

- (nonnull instancetype)initWithRootView:(nullable UIView *)rootView {
    self = [super init];
    if (self) {
        [self setupDefaultProperties];
        [self setupDefaults];

        self.rootView = rootView;
    }
    return self;
}

+ (nonnull instancetype)sideMenuControllerWithRootView:(nullable UIView *)rootView {
    return [[self alloc] initWithRootView:rootView];
}

- (nonnull instancetype)initWithRootView:(nullable UIView *)rootView
                                leftView:(nullable UIView *)leftView
                               rightView:(nullable UIView *)rightView {
    self = [super init];
    if (self) {
        [self setupDefaultProperties];
        [self setupDefaults];

        self.rootView = rootView;
        self.leftView = leftView;
        self.rightView = rightView;
    }
    return self;
}

+ (nonnull instancetype)sideMenuControllerWithRootView:(nullable UIView *)rootView
                                              leftView:(nullable UIView *)leftView
                                             rightView:(nullable UIView *)rightView {
    return [[self alloc] initWithRootView:rootView leftView:leftView rightView:rightView];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setupDefaultProperties];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setupDefaults];
}

- (void)setupDefaults {
    self.view.clipsToBounds = YES;
    self.view.backgroundColor = nil;

    self.tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesture:)];
    self.tapGesture.delegate = self.gesturesHandler;
    self.tapGesture.numberOfTapsRequired = 1;
    self.tapGesture.numberOfTouchesRequired = 1;
    self.tapGesture.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:self.tapGesture];

    self.panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGesture:)];
    self.panGesture.delegate = self.gesturesHandler;
    self.panGesture.minimumNumberOfTouches = 1;
    self.panGesture.maximumNumberOfTouches = 1;
    self.panGesture.cancelsTouchesInView = YES;
    [self.view addGestureRecognizer:self.panGesture];
}

#pragma mark - Static defaults

- (void)setupDefaultProperties {
    CGFloat minSide = MIN(CGRectGetWidth(UIScreen.mainScreen.bounds), CGRectGetHeight(UIScreen.mainScreen.bounds));
    CGFloat sideMenuWidth = minSide - 44.0;

    // Needed to be initialized before default properties
    self.gesturesHandler = [[LGSideMenuControllerGesturesHandler alloc] initWithSideMenuController:self];

    self.leftViewWidth = sideMenuWidth;
    self.rightViewWidth = sideMenuWidth;

    self.leftViewPresentationStyle = LGSideMenuPresentationStyleSlideAbove;
    self.rightViewPresentationStyle = LGSideMenuPresentationStyleSlideAbove;

    self.leftViewAlwaysVisibleOptions = LGSideMenuAlwaysVisibleOnNone;
    self.rightViewAlwaysVisibleOptions = LGSideMenuAlwaysVisibleOnNone;

    self.leftViewHidesOnTouch = YES;
    self.rightViewHidesOnTouch = YES;

    self.leftViewSwipeGestureEnabled = YES;
    self.rightViewSwipeGestureEnabled = YES;

    self.swipeGestureArea = LGSideMenuSwipeGestureAreaBorders;
    self.leftViewSwipeGestureRange = LGSideMenuSwipeGestureRangeMake(44.0, 44.0);
    self.rightViewSwipeGestureRange = LGSideMenuSwipeGestureRangeMake(44.0, 44.0);

    self.leftViewAnimationSpeed = 0.5;
    self.rightViewAnimationSpeed = 0.5;

    self.leftViewEnabled = YES;
    self.rightViewEnabled = YES;

    self.leftViewBackgroundColor = nil;
    self.rightViewBackgroundColor = nil;

    self.leftViewBackgroundImage = nil;
    self.rightViewBackgroundImage = nil;

    self.leftViewBackgroundBlurEffect = nil;
    self.rightViewBackgroundBlurEffect = nil;

    self.leftViewBackgroundAlpha = 1.0;
    self.rightViewBackgroundAlpha = 1.0;

    self.rootViewLayerBorderColor = nil;
    self.leftViewLayerBorderColor = nil;
    self.rightViewLayerBorderColor = nil;

    self.rootViewLayerBorderWidth = 0.0;
    self.leftViewLayerBorderWidth = 0.0;
    self.rightViewLayerBorderWidth = 0.0;

    self.rootViewLayerShadowColor = [UIColor colorWithWhite:0.0 alpha:0.5];
    self.leftViewLayerShadowColor = [UIColor colorWithWhite:0.0 alpha:0.5];
    self.rightViewLayerShadowColor = [UIColor colorWithWhite:0.0 alpha:0.5];

    self.rootViewLayerShadowRadius = 5.0;
    self.leftViewLayerShadowRadius = 5.0;
    self.rightViewLayerShadowRadius = 5.0;

    self.rootViewCoverBlurEffectForLeftView = nil;
    self.rootViewCoverBlurEffectForRightView = nil;
    self.leftViewCoverBlurEffect = nil;
    self.rightViewCoverBlurEffect = nil;

    self.rootViewCoverAlphaForLeftView = 1.0;
    self.rootViewCoverAlphaForRightView = 1.0;
    self.leftViewCoverAlpha = 1.0;
    self.rightViewCoverAlpha = 1.0;
}

#pragma mark - Layouting

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];

    CGSize size = self.view.frame.size;

    if (!CGSizeEqualToSize(self.savedSize, size)) {
        BOOL appeared = !CGSizeEqualToSize(self.savedSize, CGSizeZero);

        self.savedSize = size;

        // -----

        [self stylesValidate];
        [self rootViewsLayoutValidate];
        [self leftViewsLayoutValidate];
        [self rightViewsLayoutValidate];
        // If side view is always visible and after rotating it should hide, we need to wait until rotation is finished
        [self visibilityValidateWithDelay:(appeared ? 0.25 : 0.0)];
    }
}

// inherit this method
- (void)rootViewWillLayoutSubviewsWithSize:(CGSize)size {
    if (self.rootViewController) {
        self.rootView.frame = CGRectMake(0.0, 0.0, size.width, size.height);
    }
}

// inherit this method
- (void)leftViewWillLayoutSubviewsWithSize:(CGSize)size {
    if (self.leftViewController) {
        self.leftView.frame = CGRectMake(0.0, 0.0, size.width, size.height);
    }
}

// inherit this method
- (void)rightViewWillLayoutSubviewsWithSize:(CGSize)size {
    if (self.rightViewController) {
        self.rightView.frame = CGRectMake(0.0, 0.0, size.width, size.height);
    }
}

#pragma mark - Rotation

- (BOOL)shouldAutorotate {
    if (self.rootView) {
        return self.rootViewShouldAutorotate;
    }

    return super.shouldAutorotate;
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];

    if (self.isLeftViewGoingToShow) {
        [self showLeftViewDoneWithGesture:(self.leftViewGestireStartX != nil)];
    }
    else if (self.isLeftViewGoingToHide) {
        [self hideLeftViewDoneWithGesture:(self.leftViewGestireStartX != nil)];
    }

    if (self.isRightViewGoingToShow) {
        [self showRightViewDoneWithGesture:(self.rightViewGestireStartX != nil)];
    }
    else if (self.isRightViewGoingToHide) {
        [self hideRightViewDoneWithGesture:(self.rightViewGestireStartX != nil)];
    }
}

#pragma mark - Status bar

- (BOOL)prefersStatusBarHidden {
    if (self.leftView && (self.isLeftViewShowing || self.isLeftViewGoingToShow) && !self.isLeftViewGoingToHide && !self.isLeftViewAlwaysVisible) {
        return self.leftViewStatusBarHidden;
    }

    if (self.rightView && (self.isRightViewShowing || self.isRightViewGoingToShow) && !self.isRightViewGoingToHide && !self.isRightViewAlwaysVisible) {
        return self.rightViewStatusBarHidden;
    }

    if (self.rootView) {
        return self.rootViewStatusBarHidden;
    }

    return super.prefersStatusBarHidden;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    if (self.leftView && (self.isLeftViewShowing || self.isLeftViewGoingToShow) && !self.isLeftViewGoingToHide && !self.isLeftViewAlwaysVisible) {
        return self.leftViewStatusBarStyle;
    }

    if (self.rightView && (self.isRightViewShowing || self.isRightViewGoingToShow) && !self.isRightViewGoingToHide && !self.isRightViewAlwaysVisible) {
        return self.rightViewStatusBarStyle;
    }

    if (self.rootView) {
        return self.rootViewStatusBarStyle;
    }

    return super.preferredStatusBarStyle;
}

- (UIStatusBarAnimation)preferredStatusBarUpdateAnimation {
    if (self.leftView && (self.isLeftViewShowing || self.isLeftViewGoingToShow) && !self.isLeftViewGoingToHide && !self.isLeftViewAlwaysVisible) {
        return self.leftViewStatusBarUpdateAnimation;
    }

    if (self.rightView && (self.isRightViewShowing || self.isRightViewGoingToShow) && !self.isRightViewGoingToHide && !self.isRightViewAlwaysVisible) {
        return self.rightViewStatusBarUpdateAnimation;
    }

    if (self.rootView) {
        return self.rootViewStatusBarUpdateAnimation;
    }

    return super.preferredStatusBarUpdateAnimation;
}

#pragma mark - Static defaults getters

- (UIImage *)leftViewBackgroundImage {
    if (self.leftViewPresentationStyle == LGSideMenuPresentationStyleSlideAbove) {
        return nil;
    }

    return _leftViewBackgroundImage;
}

- (UIImage *)rightViewBackgroundImage {
    if (self.rightViewPresentationStyle == LGSideMenuPresentationStyleSlideAbove) {
        return nil;
    }

    return _rightViewBackgroundImage;
}

- (UIBlurEffect *)leftViewBackgroundBlurEffect {
    if (self.leftViewPresentationStyle != LGSideMenuPresentationStyleSlideAbove) {
        return nil;
    }

    return _leftViewBackgroundBlurEffect;
}

- (UIBlurEffect *)rightViewBackgroundBlurEffect {
    if (self.rightViewPresentationStyle != LGSideMenuPresentationStyleSlideAbove) {
        return nil;
    }

    return _rightViewBackgroundBlurEffect;
}

- (CGFloat)leftViewBackgroundAlpha {
    if (self.leftViewPresentationStyle != LGSideMenuPresentationStyleSlideAbove) {
        return 1.0;
    }

    return _leftViewBackgroundAlpha;
}

- (CGFloat)rightViewBackgroundAlpha {
    if (self.rightViewPresentationStyle != LGSideMenuPresentationStyleSlideAbove) {
        return 1.0;
    }

    return _rightViewBackgroundAlpha;
}

- (UIColor *)leftViewLayerShadowColor {
    if (self.leftViewPresentationStyle != LGSideMenuPresentationStyleSlideAbove) {
        return nil;
    }

    return _leftViewLayerShadowColor;
}

- (UIColor *)rightViewLayerShadowColor {
    if (self.rightViewPresentationStyle != LGSideMenuPresentationStyleSlideAbove) {
        return nil;
    }

    return _rightViewLayerShadowColor;
}

- (CGFloat)leftViewLayerShadowRadius {
    if (self.leftViewPresentationStyle != LGSideMenuPresentationStyleSlideAbove) {
        return 0.0;
    }

    return _leftViewLayerShadowRadius;
}

- (CGFloat)rightViewLayerShadowRadius {
    if (self.rightViewPresentationStyle != LGSideMenuPresentationStyleSlideAbove) {
        return 0.0;
    }

    return _rightViewLayerShadowRadius;
}

- (UIBlurEffect *)leftViewCoverBlurEffect {
    if (self.leftViewPresentationStyle == LGSideMenuPresentationStyleSlideAbove) {
        return nil;
    }

    return _leftViewCoverBlurEffect;
}

- (UIBlurEffect *)rightViewCoverBlurEffect {
    if (self.rightViewPresentationStyle == LGSideMenuPresentationStyleSlideAbove) {
        return nil;
    }

    return _rightViewCoverBlurEffect;
}

- (CGFloat)leftViewCoverAlpha {
    if (self.leftViewPresentationStyle == LGSideMenuPresentationStyleSlideAbove) {
        return 1.0;
    }

    return _leftViewCoverAlpha;
}

- (CGFloat)rightViewCoverAlpha {
    if (self.rightViewPresentationStyle == LGSideMenuPresentationStyleSlideAbove) {
        return 1.0;
    }

    return _rightViewCoverAlpha;
}

#pragma mark - Dynamic defaults setters and getters

- (void)setRootViewShouldAutorotate:(BOOL)rootViewShouldAutorotate {
    _rootViewShouldAutorotate = rootViewShouldAutorotate;
    self.userRootViewShouldAutorotate = YES;
}

- (BOOL)rootViewShouldAutorotate {
    if (self.isUserRootViewShouldAutorotate) {
        return _rootViewShouldAutorotate;
    }

    if (self.rootViewController) {
        return self.rootViewController.shouldAutorotate;
    }

    return super.shouldAutorotate;
}

- (void)setRootViewStatusBarHidden:(BOOL)rootViewStatusBarHidden {
    _rootViewStatusBarHidden = rootViewStatusBarHidden;
    self.userRootViewStatusBarHidden = YES;
}

- (BOOL)isRootViewStatusBarHidden {
    if (self.isUserRootViewStatusBarHidden) {
        return _rootViewStatusBarHidden;
    }

    if (!self.isViewControllerBasedStatusBarAppearance) {
        return UIApplication.sharedApplication.statusBarHidden;
    }

    if (self.rootViewController) {
        return self.rootViewController.prefersStatusBarHidden;
    }

    return super.prefersStatusBarHidden;
}

- (void)setLeftViewStatusBarHidden:(BOOL)leftViewStatusBarHidden {
    _leftViewStatusBarHidden = leftViewStatusBarHidden;
    self.userLeftViewStatusBarHidden = YES;
}

- (BOOL)isLeftViewStatusBarHidden {
    if (self.isUserLeftViewStatusBarHidden) {
        return _leftViewStatusBarHidden;
    }

    if (!self.isViewControllerBasedStatusBarAppearance) {
        return UIApplication.sharedApplication.statusBarHidden;
    }

    if (self.leftViewController) {
        return self.leftViewController.prefersStatusBarHidden;
    }

    if (self.rootViewController) {
        return self.rootViewController.prefersStatusBarHidden;
    }

    return super.prefersStatusBarHidden;
}

- (void)setRightViewStatusBarHidden:(BOOL)rightViewStatusBarHidden {
    _rightViewStatusBarHidden = rightViewStatusBarHidden;
    self.userRightViewStatusBarHidden = YES;
}

- (BOOL)isRightViewStatusBarHidden {
    if (self.isUserRightViewStatusBarHidden) {
        return _rightViewStatusBarHidden;
    }

    if (!self.isViewControllerBasedStatusBarAppearance) {
        return UIApplication.sharedApplication.statusBarHidden;
    }

    if (self.rightViewController) {
        return self.rightViewController.prefersStatusBarHidden;
    }

    if (self.rootViewController) {
        return self.rootViewController.prefersStatusBarHidden;
    }

    return super.prefersStatusBarHidden;
}

- (void)setRootViewStatusBarStyle:(UIStatusBarStyle)rootViewStatusBarStyle {
    _rootViewStatusBarStyle = rootViewStatusBarStyle;
    self.userRootViewStatusBarStyle = YES;
}

- (UIStatusBarStyle)rootViewStatusBarStyle {
    if (self.isUserRootViewStatusBarStyle) {
        return _rootViewStatusBarStyle;
    }

    if (!self.isViewControllerBasedStatusBarAppearance) {
        return UIApplication.sharedApplication.statusBarStyle;
    }

    if (self.rootViewController) {
        return self.rootViewController.preferredStatusBarStyle;
    }

    return super.preferredStatusBarStyle;
}

- (void)setLeftViewStatusBarStyle:(UIStatusBarStyle)leftViewStatusBarStyle {
    _leftViewStatusBarStyle = leftViewStatusBarStyle;
    self.userLeftViewStatusBarStyle = YES;
}

- (UIStatusBarStyle)leftViewStatusBarStyle {
    if (self.isUserLeftViewStatusBarStyle) {
        return _leftViewStatusBarStyle;
    }

    if (!self.isViewControllerBasedStatusBarAppearance) {
        return UIApplication.sharedApplication.statusBarStyle;
    }

    if (self.leftViewController) {
        return self.leftViewController.preferredStatusBarStyle;
    }

    if (self.rootViewController) {
        return self.rootViewController.preferredStatusBarStyle;
    }

    return super.preferredStatusBarStyle;
}

- (void)setRightViewStatusBarStyle:(UIStatusBarStyle)rightViewStatusBarStyle {
    _rightViewStatusBarStyle = rightViewStatusBarStyle;
    self.userRightViewStatusBarStyle = YES;
}

- (UIStatusBarStyle)rightViewStatusBarStyle {
    if (self.isUserRightViewStatusBarStyle) {
        return _rightViewStatusBarStyle;
    }

    if (!self.isViewControllerBasedStatusBarAppearance) {
        return UIApplication.sharedApplication.statusBarStyle;
    }

    if (self.rightViewController) {
        return self.rightViewController.preferredStatusBarStyle;
    }

    if (self.rootViewController) {
        return self.rootViewController.preferredStatusBarStyle;
    }

    return super.preferredStatusBarStyle;
}

- (void)setRootViewStatusBarUpdateAnimation:(UIStatusBarAnimation)rootViewStatusBarUpdateAnimation {
    _rootViewStatusBarUpdateAnimation = rootViewStatusBarUpdateAnimation;
    self.userRootViewStatusBarUpdateAnimation = YES;
}

- (UIStatusBarAnimation)rootViewStatusBarUpdateAnimation {
    if (self.isUserRootViewStatusBarUpdateAnimation) {
        return _rootViewStatusBarUpdateAnimation;
    }

    if (self.rootViewController) {
        return self.rootViewController.preferredStatusBarUpdateAnimation;
    }

    return super.preferredStatusBarUpdateAnimation;
}

- (void)setLeftViewStatusBarUpdateAnimation:(UIStatusBarAnimation)leftViewStatusBarUpdateAnimation {
    _leftViewStatusBarUpdateAnimation = leftViewStatusBarUpdateAnimation;
    self.userLeftViewStatusBarUpdateAnimation = YES;
}

- (UIStatusBarAnimation)leftViewStatusBarUpdateAnimation {
    if (self.isUserLeftViewStatusBarUpdateAnimation) {
        return _leftViewStatusBarUpdateAnimation;
    }

    if (self.leftViewController) {
        return self.leftViewController.preferredStatusBarUpdateAnimation;
    }

    if (self.rootViewController) {
        return self.rootViewController.preferredStatusBarUpdateAnimation;
    }

    return super.preferredStatusBarUpdateAnimation;
}

- (void)setRightViewStatusBarUpdateAnimation:(UIStatusBarAnimation)rightViewStatusBarUpdateAnimation {
    _rightViewStatusBarUpdateAnimation = rightViewStatusBarUpdateAnimation;
    self.userRightViewStatusBarUpdateAnimation = YES;
}

- (UIStatusBarAnimation)rightViewStatusBarUpdateAnimation {
    if (self.isUserRightViewStatusBarUpdateAnimation) {
        return _rightViewStatusBarUpdateAnimation;
    }

    if (self.rightViewController) {
        return self.rightViewController.preferredStatusBarUpdateAnimation;
    }

    if (self.rootViewController) {
        return self.rootViewController.preferredStatusBarUpdateAnimation;
    }

    return super.preferredStatusBarUpdateAnimation;
}

- (void)setRootViewCoverColorForLeftView:(UIColor *)rootViewCoverColorForLeftView {
    _rootViewCoverColorForLeftView = rootViewCoverColorForLeftView;
    self.userRootViewCoverColorForLeftView = YES;
}

- (UIColor *)rootViewCoverColorForLeftView {
    if (self.isUserRootViewCoverColorForLeftView) {
        return _rootViewCoverColorForLeftView;
    }

    if (self.leftViewPresentationStyle == LGSideMenuPresentationStyleSlideAbove) {
        return [UIColor colorWithWhite:0.0 alpha:0.5];
    }

    return nil;
}

- (void)setRootViewCoverColorForRightView:(UIColor *)rootViewCoverColorForRightView {
    _rootViewCoverColorForRightView = rootViewCoverColorForRightView;
    self.userRootViewCoverColorForRightView = YES;
}

- (UIColor *)rootViewCoverColorForRightView {
    if (self.isUserRootViewCoverColorForRightView) {
        return _rootViewCoverColorForRightView;
    }

    if (self.rightViewPresentationStyle == LGSideMenuPresentationStyleSlideAbove) {
        return [UIColor colorWithWhite:0.0 alpha:0.5];
    }

    return nil;
}

- (void)setLeftViewCoverColor:(UIColor *)leftViewCoverColor {
    _leftViewCoverColor = leftViewCoverColor;
    self.userLeftViewCoverColor = YES;
}

- (UIColor *)leftViewCoverColor {
    if (self.isUserLeftViewCoverColor) {
        return _leftViewCoverColor;
    }

    if (self.leftViewPresentationStyle != LGSideMenuPresentationStyleSlideAbove) {
        return [UIColor colorWithWhite:0.0 alpha:0.5];
    }

    return nil;
}

- (void)setRightViewCoverColor:(UIColor *)rightViewCoverColor {
    _rightViewCoverColor = rightViewCoverColor;
    self.userRightViewCoverColor = YES;
}

- (UIColor *)rightViewCoverColor {
    if (self.isUserRightViewCoverColor) {
        return _rightViewCoverColor;
    }

    if (self.rightViewPresentationStyle != LGSideMenuPresentationStyleSlideAbove) {
        return [UIColor colorWithWhite:0.0 alpha:0.5];
    }

    return nil;
}

- (void)setRootViewScaleForLeftView:(CGFloat)rootViewScaleForLeftView {
    _rootViewScaleForLeftView = rootViewScaleForLeftView;
    self.userRootViewScaleForLeftView = YES;
}

- (CGFloat)rootViewScaleForLeftView {
    if (self.isUserRootViewScaleForLeftView) {
        return _rootViewScaleForLeftView;
    }

    if (self.leftViewPresentationStyle == LGSideMenuPresentationStyleSlideAbove ||
        self.leftViewPresentationStyle == LGSideMenuPresentationStyleSlideBelow) {
        return 1.0;
    }

    return 0.8;
}

- (void)setRootViewScaleForRightView:(CGFloat)rootViewScaleForRightView {
    _rootViewScaleForRightView = rootViewScaleForRightView;
    self.userRootViewScaleForRightView = YES;
}

- (CGFloat)rootViewScaleForRightView {
    if (self.isUserRootViewScaleForRightView) {
        return _rootViewScaleForRightView;
    }

    if (self.rightViewPresentationStyle == LGSideMenuPresentationStyleSlideAbove ||
        self.rightViewPresentationStyle == LGSideMenuPresentationStyleSlideBelow) {
        return 1.0;
    }

    return 0.8;
}

- (void)setLeftViewInititialScale:(CGFloat)leftViewInititialScale {
    _leftViewInititialScale = leftViewInititialScale;
    self.userLeftViewInititialScale = YES;
}

- (CGFloat)leftViewInititialScale {
    if (self.isUserLeftViewInititialScale) {
        return _leftViewInititialScale;
    }

    if (self.leftViewPresentationStyle == LGSideMenuPresentationStyleScaleFromLittle) {
        return 0.8;
    }

    if (self.leftViewPresentationStyle == LGSideMenuPresentationStyleScaleFromBig) {
        return 1.2;
    }

    return 1.0;
}

- (void)setRightViewInititialScale:(CGFloat)rightViewInititialScale {
    _rightViewInititialScale = rightViewInititialScale;
    self.userRightViewInititialScale = YES;
}

- (CGFloat)rightViewInititialScale {
    if (self.isUserRightViewInititialScale) {
        return _rightViewInititialScale;
    }

    if (self.rightViewPresentationStyle == LGSideMenuPresentationStyleScaleFromLittle) {
        return 0.8;
    }

    if (self.rightViewPresentationStyle == LGSideMenuPresentationStyleScaleFromBig) {
        return 1.2;
    }
    
    return 1.0;
}

- (void)setLeftViewInititialOffsetX:(CGFloat)leftViewInititialOffsetX {
    _leftViewInititialOffsetX = leftViewInititialOffsetX;
    self.userLeftViewInititialOffsetX = YES;
}

- (CGFloat)leftViewInititialOffsetX {
    if (self.isUserLeftViewInititialOffsetX) {
        return _leftViewInititialOffsetX;
    }

    if (self.leftViewPresentationStyle == LGSideMenuPresentationStyleSlideBelow) {
        self.leftViewInititialOffsetX = -self.leftViewWidth/2;
    }

    return 0.0;
}

- (void)setRightViewInititialOffsetX:(CGFloat)rightViewInititialOffsetX {
    _rightViewInititialOffsetX = rightViewInititialOffsetX;
    self.userRightViewInititialOffsetX = YES;
}

- (CGFloat)rightViewInititialOffsetX {
    if (self.isUserRightViewInititialOffsetX) {
        return _rightViewInititialOffsetX;
    }

    if (self.rightViewPresentationStyle == LGSideMenuPresentationStyleSlideBelow) {
        self.rightViewInititialOffsetX = self.rightViewWidth/2;
    }

    return 0.0;
}

- (void)setLeftViewBackgroundImageInitialScale:(CGFloat)leftViewBackgroundImageInitialScale {
    _leftViewBackgroundImageInitialScale = leftViewBackgroundImageInitialScale;
    self.userLeftViewBackgroundImageInitialScale = YES;
}

- (CGFloat)leftViewBackgroundImageInitialScale {
    if (self.isUserLeftViewBackgroundImageInitialScale) {
        return _leftViewBackgroundImageInitialScale;
    }

    if (self.leftViewPresentationStyle == LGSideMenuPresentationStyleScaleFromLittle ||
        self.leftViewPresentationStyle == LGSideMenuPresentationStyleScaleFromBig) {
        return 1.4;
    }

    return 1.0;
}

- (void)setRightViewBackgroundImageInitialScale:(CGFloat)rightViewBackgroundImageInitialScale {
    _rightViewBackgroundImageInitialScale = rightViewBackgroundImageInitialScale;
    self.userRightViewBackgroundImageInitialScale = YES;
}

- (CGFloat)rightViewBackgroundImageInitialScale {
    if (self.isUserRightViewBackgroundImageInitialScale) {
        return _rightViewBackgroundImageInitialScale;
    }

    if (self.rightViewPresentationStyle == LGSideMenuPresentationStyleScaleFromLittle ||
        self.rightViewPresentationStyle == LGSideMenuPresentationStyleScaleFromBig) {
        return 1.4;
    }

    return 1.0;
}

#pragma mark -

- (void)setLeftViewPresentationStyle:(LGSideMenuPresentationStyle)leftViewPresentationStyle {
    _leftViewPresentationStyle = leftViewPresentationStyle;
    [self leftViewsValidate];
    [self viewsHierarchyValidate];
}

- (void)setRightViewPresentationStyle:(LGSideMenuPresentationStyle)rightViewPresentationStyle {
    _rightViewPresentationStyle = rightViewPresentationStyle;
    [self rightViewsValidate];
    [self viewsHierarchyValidate];
}

- (void)setLeftViewBackgroundImage:(UIImage *)leftViewBackgroundImage {
    _leftViewBackgroundImage = leftViewBackgroundImage;
    [self leftViewsValidate];
    [self viewsHierarchyValidate];
}

- (void)setRightViewBackgroundImage:(UIImage *)rightViewBackgroundImage {
    _rightViewBackgroundImage = rightViewBackgroundImage;
    [self rightViewsValidate];
    [self viewsHierarchyValidate];
}

- (void)setLeftViewAlwaysVisibleOptions:(LGSideMenuAlwaysVisibleOptions)leftViewAlwaysVisibleOptions {
    _leftViewAlwaysVisibleOptions = leftViewAlwaysVisibleOptions;
    [self stylesValidate];
    [self leftViewsLayoutValidate];
    [self visibilityValidate];
}

- (void)setRightViewAlwaysVisibleOptions:(LGSideMenuAlwaysVisibleOptions)rightViewAlwaysVisibleOptions {
    _rightViewAlwaysVisibleOptions = rightViewAlwaysVisibleOptions;
    [self stylesValidate];
    [self rightViewsValidate];
    [self viewsHierarchyValidate];
    [self visibilityValidate];
}

- (void)setLeftViewWidth:(CGFloat)leftViewWidth {
    _leftViewWidth = leftViewWidth;
    [self leftViewsLayoutValidate];
}

- (void)setRightViewWidth:(CGFloat)rightViewWidth {
    _rightViewWidth = rightViewWidth;
    [self rightViewsLayoutValidate];
}

#pragma mark -

- (void)setRootViewContainer:(LGSideMenuView *)rootViewContainer {
    _rootViewContainer = rootViewContainer;
    self.gesturesHandler.rootViewContainer = rootViewContainer;
}

- (void)setLeftViewContainer:(LGSideMenuView *)leftViewContainer {
    _leftViewContainer = leftViewContainer;
    self.gesturesHandler.leftViewContainer = leftViewContainer;
}

- (void)setRightViewContainer:(LGSideMenuView *)rightViewContainer {
    _rightViewContainer = rightViewContainer;
    self.gesturesHandler.rightViewContainer = rightViewContainer;
}

- (void)setRootViewCoverView:(UIVisualEffectView *)rootViewCoverView {
    _rootViewCoverView = rootViewCoverView;
    self.gesturesHandler.rootViewCoverView = rootViewCoverView;
}

#pragma mark -

- (BOOL)isLeftViewVisible {
    return self.isLeftViewShowing || self.isLeftViewGoingToShow || self.isLeftViewGoingToHide;
}

- (BOOL)isRightViewVisible {
    return self.isRightViewShowing || self.isRightViewGoingToShow || self.isRightViewGoingToHide;
}

- (void)setLeftViewDisabled:(BOOL)leftViewDisabled {
    self.leftViewEnabled = !leftViewDisabled;
}

- (BOOL)isLeftViewDisabled {
    return !self.isLeftViewEnabled;
}

- (void)setRightViewDisabled:(BOOL)rightViewDisabled {
    self.rightViewEnabled = !rightViewDisabled;
}

- (BOOL)isRightViewDisabled {
    return !self.isRightViewEnabled;
}

- (void)setLeftViewHidden:(BOOL)leftViewHidden {
    self.leftViewShowing = !leftViewHidden;
}

- (BOOL)isLeftViewHidden {
    return !self.isLeftViewShowing;
}

- (void)setRightViewHidden:(BOOL)rightViewHidden {
    self.rightViewShowing = !rightViewHidden;
}

- (BOOL)isRightViewHidden {
    return !self.isRightViewShowing;
}

- (void)setLeftViewSwipeGestureDisabled:(BOOL)leftViewSwipeGestureDisabled {
    self.leftViewSwipeGestureEnabled = !leftViewSwipeGestureDisabled;
}

- (BOOL)isLeftViewSwipeGestureDisabled {
    return !self.isLeftViewSwipeGestureEnabled;
}

- (void)setRightViewSwipeGestureDisabled:(BOOL)rightViewSwipeGestureDisabled {
    self.rightViewSwipeGestureEnabled = !rightViewSwipeGestureDisabled;
}

- (BOOL)isRightViewSwipeGestureDisabled {
    return !self.isRightViewSwipeGestureEnabled;
}

- (BOOL)isLeftViewAlwaysVisibleForCurrentOrientation {
    return [self isLeftViewAlwaysVisibleForOrientation:UIApplication.sharedApplication.statusBarOrientation];
}

- (BOOL)isRightViewAlwaysVisibleForCurrentOrientation {
    return [self isRightViewAlwaysVisibleForOrientation:UIApplication.sharedApplication.statusBarOrientation];
}

- (BOOL)isLeftViewAlwaysVisibleForOrientation:(UIInterfaceOrientation)orientation {
    return ((self.leftViewAlwaysVisibleOptions & LGSideMenuAlwaysVisibleOnAll) ||
            (UIInterfaceOrientationIsPortrait(orientation) && self.leftViewAlwaysVisibleOptions & LGSideMenuAlwaysVisibleOnPortrait) ||
            (UIInterfaceOrientationIsLandscape(orientation) && self.leftViewAlwaysVisibleOptions & LGSideMenuAlwaysVisibleOnLandscape) ||
            (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone &&
             ((self.leftViewAlwaysVisibleOptions & LGSideMenuAlwaysVisibleOnPhone) ||
              (UIInterfaceOrientationIsPortrait(orientation) && self.leftViewAlwaysVisibleOptions & LGSideMenuAlwaysVisibleOnPhonePortrait) ||
              (UIInterfaceOrientationIsLandscape(orientation) && self.leftViewAlwaysVisibleOptions & LGSideMenuAlwaysVisibleOnPhoneLandscape))) ||
            (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad &&
             ((self.leftViewAlwaysVisibleOptions & LGSideMenuAlwaysVisibleOnPad) ||
              (UIInterfaceOrientationIsPortrait(orientation) && self.leftViewAlwaysVisibleOptions & LGSideMenuAlwaysVisibleOnPadPortrait) ||
              (UIInterfaceOrientationIsLandscape(orientation) && self.leftViewAlwaysVisibleOptions & LGSideMenuAlwaysVisibleOnPadLandscape))));
}

- (BOOL)isRightViewAlwaysVisibleForOrientation:(UIInterfaceOrientation)orientation {
    return ((self.rightViewAlwaysVisibleOptions & LGSideMenuAlwaysVisibleOnAll) ||
            (UIInterfaceOrientationIsPortrait(orientation) && self.rightViewAlwaysVisibleOptions & LGSideMenuAlwaysVisibleOnPortrait) ||
            (UIInterfaceOrientationIsLandscape(orientation) && self.rightViewAlwaysVisibleOptions & LGSideMenuAlwaysVisibleOnLandscape) ||
            (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone &&
             ((self.rightViewAlwaysVisibleOptions & LGSideMenuAlwaysVisibleOnPhone) ||
              (UIInterfaceOrientationIsPortrait(orientation) && self.rightViewAlwaysVisibleOptions & LGSideMenuAlwaysVisibleOnPhonePortrait) ||
              (UIInterfaceOrientationIsLandscape(orientation) && self.rightViewAlwaysVisibleOptions & LGSideMenuAlwaysVisibleOnPhoneLandscape))) ||
            (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad &&
             ((self.rightViewAlwaysVisibleOptions & LGSideMenuAlwaysVisibleOnPad) ||
              (UIInterfaceOrientationIsPortrait(orientation) && self.rightViewAlwaysVisibleOptions & LGSideMenuAlwaysVisibleOnPadPortrait) ||
              (UIInterfaceOrientationIsLandscape(orientation) && self.rightViewAlwaysVisibleOptions & LGSideMenuAlwaysVisibleOnPadLandscape))));
}

#pragma mark - ViewControllers

- (void)setRootViewController:(UIViewController *)rootViewController {
    [self removeRootViews];

    if (!rootViewController) return;

    // -----

    BOOL isLeftViewShowing = self.isLeftViewShowing;
    BOOL isRightViewShowing = self.isRightViewShowing;

    if (isLeftViewShowing || isRightViewShowing) {
        if (isLeftViewShowing) {
            self.leftViewShowing = NO;
        }

        if (isRightViewShowing) {
            self.rightViewShowing = NO;
        }

        [self setNeedsStatusBarAppearanceUpdate];
    }

    // -----

    _rootViewController = rootViewController;
    _rootView = rootViewController.view;

    // Needed because when any of side menus is showing, rootViewController is removed from it's parentViewController
    objc_setAssociatedObject(self.rootViewController, @"sideMenuController", self, OBJC_ASSOCIATION_ASSIGN);

    [self rootViewsValidate];
    [self viewsHierarchyValidate];

    // -----

    if (isLeftViewShowing || isRightViewShowing) {
        self.leftViewShowing = isLeftViewShowing;
        self.rightViewShowing = isRightViewShowing;
        [self setNeedsStatusBarAppearanceUpdate];
        [self rootViewsLayoutValidate];
    }
}

- (void)setLeftViewController:(UIViewController *)leftViewController {
    [self removeLeftViews];

    if (!leftViewController) return;

    _leftViewController = leftViewController;
    _leftView = leftViewController.view;

    [self leftViewsValidate];
    [self viewsHierarchyValidate];
}

- (void)setRightViewController:(UIViewController *)rightViewController {
    [self removeRightViews];

    if (!rightViewController) return;

    _rightViewController = rightViewController;
    _rightView = rightViewController.view;

    [self rightViewsValidate];
    [self viewsHierarchyValidate];
}

#pragma mark - Views

- (void)setRootView:(UIView *)rootView {
    [self removeRootViews];

    if (!rootView) return;

    _rootView = rootView;

    [self rootViewsValidate];
    [self viewsHierarchyValidate];
}

- (void)setLeftView:(LGSideMenuView *)leftView {
    [self removeLeftViews];

    if (!leftView) return;

    _leftView = leftView;

    [self leftViewsValidate];
    [self viewsHierarchyValidate];
}

- (void)setRightView:(LGSideMenuView *)rightView {
    [self removeRightViews];

    if (!rightView) return;

    _rightView = rightView;

    [self rightViewsValidate];
    [self viewsHierarchyValidate];
}

#pragma mark - Remove views

- (void)removeRootViews {
    if (self.rootViewController) {
        [self.rootViewController.view removeFromSuperview];
        [self.rootViewController removeFromParentViewController];
        _rootViewController = nil;

        objc_setAssociatedObject(_rootViewController, @"sideMenuController", nil, OBJC_ASSOCIATION_ASSIGN);
    }

    if (self.rootViewContainer) {
        [self.rootViewContainer removeFromSuperview];
        _rootViewContainer = nil;
    }

    if (self.rootView) {
        [self.rootView removeFromSuperview];
        _rootView = nil;
    }

    if (self.rootViewStyleView) {
        [self.rootViewStyleView removeFromSuperview];
        _rootViewStyleView = nil;
    }

    if (self.rootViewCoverView) {
        [self.rootViewCoverView removeFromSuperview];
        _rootViewCoverView = nil;
    }
}

- (void)removeLeftViews {
    if (self.leftViewController) {
        [self.leftViewController.view removeFromSuperview];
        [self.leftViewController removeFromParentViewController];
        _leftViewController = nil;
    }

    if (self.leftViewContainer) {
        [self.leftViewContainer removeFromSuperview];
        _leftViewContainer = nil;
    }

    if (self.leftView) {
        [self.leftView removeFromSuperview];
        _leftView = nil;
    }

    if (self.leftViewStyleView) {
        [self.leftViewStyleView removeFromSuperview];
        _leftViewStyleView = nil;
    }

    if (self.sideViewsCoverView && !self.rightView) {
        [self.sideViewsCoverView removeFromSuperview];
        _sideViewsCoverView = nil;
    }

    if (self.backgroundColorViewForLeftView) {
        [self.backgroundColorViewForLeftView removeFromSuperview];
        _backgroundColorViewForLeftView = nil;
    }

    if (self.backgroundImageViewForLeftView) {
        [self.backgroundImageViewForLeftView removeFromSuperview];
        _backgroundImageViewForLeftView = nil;
    }
}

- (void)removeRightViews {
    if (self.rightViewController) {
        [self.rightViewController.view removeFromSuperview];
        [self.rightViewController removeFromParentViewController];
        _rightViewController = nil;
    }

    if (self.rightViewContainer) {
        [self.rightViewContainer removeFromSuperview];
        _rightViewContainer = nil;
    }

    if (self.rightView) {
        [self.rightView removeFromSuperview];
        _rightView = nil;
    }

    if (self.rightViewStyleView) {
        [self.rightViewStyleView removeFromSuperview];
        _rightViewStyleView = nil;
    }

    if (self.sideViewsCoverView && !self.leftView) {
        [self.sideViewsCoverView removeFromSuperview];
        _sideViewsCoverView = nil;
    }

    if (self.backgroundColorViewForRightView) {
        [self.backgroundColorViewForRightView removeFromSuperview];
        _backgroundColorViewForRightView = nil;
    }

    if (self.backgroundImageViewForRightView) {
        [self.backgroundImageViewForRightView removeFromSuperview];
        _backgroundImageViewForRightView = nil;
    }
}

#pragma mark - Validators

- (void)rootViewsValidate {
    if (!self.rootView) return;

    // -----

    if (self.rootViewController && !self.isLeftViewGoingToShow && !self.isRightViewGoingToShow) {
        [self addChildViewController:self.rootViewController];
    }

    // -----

    if ((self.leftView && self.leftViewPresentationStyle != LGSideMenuPresentationStyleSlideAbove) ||
        (self.rightView && self.rightViewPresentationStyle != LGSideMenuPresentationStyleSlideAbove)) {
        if (!self.rootViewStyleView) {
            self.rootViewStyleView = [UIView new];
            // Needed because shadow is not visible for background with clear color
            self.rootViewStyleView.backgroundColor = [UIColor blackColor];
            self.rootViewStyleView.layer.masksToBounds = NO;
            self.rootViewStyleView.layer.shadowOffset = CGSizeZero;
            self.rootViewStyleView.layer.shadowOpacity = 1.0;
            self.rootViewStyleView.layer.shouldRasterize = YES;
        }
    }
    else {
        if (self.rootViewStyleView) {
            self.rootViewStyleView = nil;
        }
    }

    // -----

    if (!self.rootViewContainer) {
        __weak typeof(self) wself = self;

        self.rootViewContainer = [[LGSideMenuView alloc] initWithLayoutSubviewsHandler:^(void) {
            if (!wself) return;

            __strong typeof(wself) sself = wself;

            CGAffineTransform rootViewContainerTransform = sself.rootViewContainer.transform;
            sself.rootViewContainer.transform = CGAffineTransformIdentity;
            [sself rootViewWillLayoutSubviewsWithSize:sself.rootViewContainer.frame.size];
            sself.rootViewContainer.transform = rootViewContainerTransform;
        }];

        [self.rootViewContainer addSubview:self.rootView];
    }

    // -----

    if (!self.rootViewCoverView) {
        self.rootViewCoverView = [UIVisualEffectView new];
    }

    // -----

    [self rootViewsLayoutValidate];
}

- (void)leftViewsValidate {
    if (!self.leftView) return;

    // -----

    if (self.leftViewController) {
        [self addChildViewController:self.leftViewController];
    }

    // -----

    if (self.leftViewBackgroundColor || self.leftViewBackgroundBlurEffect) {
        if (!self.backgroundColorViewForLeftView) {
            self.backgroundColorViewForLeftView = [UIView new];
        }
    }
    else {
        self.backgroundColorViewForLeftView = nil;
    }

    // -----

    if (self.leftViewBackgroundImage && self.leftViewPresentationStyle != LGSideMenuPresentationStyleSlideAbove) {
        if (!self.backgroundImageViewForLeftView) {
            self.backgroundImageViewForLeftView = [[UIImageView alloc] initWithImage:self.leftViewBackgroundImage];
            self.backgroundImageViewForLeftView.contentMode = UIViewContentModeScaleAspectFill;
            self.backgroundImageViewForLeftView.clipsToBounds = YES;
        }
    }
    else {
        self.backgroundImageViewForLeftView = nil;
    }

    // -----

    if (!self.leftViewStyleView) {
        self.leftViewStyleView = [UIVisualEffectView new];
        self.leftViewStyleView.layer.masksToBounds = NO;
        self.leftViewStyleView.contentView.layer.masksToBounds = NO;
        self.leftViewStyleView.contentView.layer.shadowOffset = CGSizeZero;
        self.leftViewStyleView.contentView.layer.shadowOpacity = 1.0;
        self.leftViewStyleView.contentView.layer.shouldRasterize = YES;
    }

    // -----

    if (!self.leftViewContainer) {
        __weak typeof(self) wself = self;

        self.leftViewContainer = [[LGSideMenuView alloc] initWithLayoutSubviewsHandler:^(void) {
            if (!wself) return;

            __strong typeof(wself) sself = wself;

            CGAffineTransform leftViewContainerTransform = sself.leftViewContainer.transform;
            sself.leftViewContainer.transform = CGAffineTransformIdentity;
            [sself leftViewWillLayoutSubviewsWithSize:sself.leftViewContainer.frame.size];
            sself.leftViewContainer.transform = leftViewContainerTransform;
        }];

        [self.leftViewContainer addSubview:self.leftView];
    }

    // -----

    if (self.leftViewPresentationStyle != LGSideMenuPresentationStyleSlideAbove) {
        if (!self.sideViewsCoverView) {
            self.sideViewsCoverView = [UIVisualEffectView new];
        }
    }
    else if (self.rightViewPresentationStyle == LGSideMenuPresentationStyleSlideAbove) {
        self.sideViewsCoverView = nil;
    }

    // -----

    [self rootViewsValidate];
    [self leftViewsLayoutValidate];
}

- (void)rightViewsValidate {
    if (!self.rightView) return;

    // -----

    if (self.rightViewController) {
        [self addChildViewController:self.rightViewController];
    }

    // -----

    if (self.rightViewBackgroundColor || self.rightViewBackgroundBlurEffect) {
        if (!self.backgroundColorViewForRightView) {
            self.backgroundColorViewForRightView = [UIView new];
        }
    }
    else {
        self.backgroundColorViewForRightView = nil;
    }

    // -----

    if (self.rightViewBackgroundImage && self.rightViewPresentationStyle != LGSideMenuPresentationStyleSlideAbove) {
        if (!self.backgroundImageViewForRightView) {
            self.backgroundImageViewForRightView = [[UIImageView alloc] initWithImage:self.rightViewBackgroundImage];
            self.backgroundImageViewForRightView.contentMode = UIViewContentModeScaleAspectFill;
            self.backgroundImageViewForRightView.clipsToBounds = YES;
        }
    }
    else {
        self.backgroundImageViewForRightView = nil;
    }

    // -----

    if (!self.rightViewStyleView) {
        self.rightViewStyleView = [UIVisualEffectView new];
        self.rightViewStyleView.layer.masksToBounds = NO;
        self.rightViewStyleView.contentView.layer.masksToBounds = NO;
        self.rightViewStyleView.contentView.layer.shadowOffset = CGSizeZero;
        self.rightViewStyleView.contentView.layer.shadowOpacity = 1.0;
        self.rightViewStyleView.contentView.layer.shouldRasterize = YES;
    }

    // -----

    if (!self.rightViewContainer) {
        __weak typeof(self) wself = self;

        self.rightViewContainer = [[LGSideMenuView alloc] initWithLayoutSubviewsHandler:^(void) {
            if (!wself) return;

            __strong typeof(wself) sself = wself;

            CGAffineTransform rightViewContainerTransform = sself.rightViewContainer.transform;
            sself.rightViewContainer.transform = CGAffineTransformIdentity;
            [sself rightViewWillLayoutSubviewsWithSize:sself.rightViewContainer.frame.size];
            sself.rightViewContainer.transform = rightViewContainerTransform;
        }];

        [self.rightViewContainer addSubview:self.rightView];
    }

    // -----

    if (self.rightViewPresentationStyle != LGSideMenuPresentationStyleSlideAbove) {
        if (!self.sideViewsCoverView) {
            self.sideViewsCoverView = [UIVisualEffectView new];
        }
    }
    else if (self.leftViewPresentationStyle == LGSideMenuPresentationStyleSlideAbove) {
        self.sideViewsCoverView = nil;
    }

    // -----

    [self rootViewsValidate];
    [self rightViewsLayoutValidate];
}

- (void)viewsHierarchyValidate {
    [self.rootViewStyleView removeFromSuperview];
    [self.rootViewContainer removeFromSuperview];
    [self.rootViewCoverView removeFromSuperview];

    [self.backgroundColorViewForLeftView removeFromSuperview];
    [self.backgroundImageViewForLeftView removeFromSuperview];
    [self.leftViewStyleView removeFromSuperview];
    [self.leftViewContainer removeFromSuperview];

    [self.backgroundColorViewForRightView removeFromSuperview];
    [self.backgroundImageViewForRightView removeFromSuperview];
    [self.rightViewStyleView removeFromSuperview];
    [self.rightViewContainer removeFromSuperview];

    [self.sideViewsCoverView removeFromSuperview];

    // -----

    BOOL isSideViewAdded = false;

    if (self.leftViewPresentationStyle != LGSideMenuPresentationStyleSlideAbove) {
        if (self.backgroundColorViewForLeftView) [self.view addSubview:self.backgroundColorViewForLeftView];
        if (self.backgroundImageViewForLeftView) [self.view addSubview:self.backgroundImageViewForLeftView];
        if (self.leftViewStyleView) [self.view addSubview:self.leftViewStyleView];
        if (self.leftViewContainer) [self.view addSubview:self.leftViewContainer];
        isSideViewAdded = YES;
    }

    if (self.rightViewPresentationStyle != LGSideMenuPresentationStyleSlideAbove) {
        if (self.backgroundColorViewForRightView) [self.view addSubview:self.backgroundColorViewForRightView];
        if (self.backgroundImageViewForRightView) [self.view addSubview:self.backgroundImageViewForRightView];
        if (self.rightViewStyleView) [self.view addSubview:self.rightViewStyleView];
        if (self.rightViewContainer) [self.view addSubview:self.rightViewContainer];
        isSideViewAdded = YES;
    }

    if (isSideViewAdded) {
        if (self.sideViewsCoverView) [self.view addSubview:self.sideViewsCoverView];
    }

    if (self.rootViewStyleView) [self.view addSubview:self.rootViewStyleView];
    if (self.rootViewContainer) [self.view addSubview:self.rootViewContainer];
    if (self.rootViewCoverView) [self.view addSubview:self.rootViewCoverView];

    if (self.leftViewPresentationStyle == LGSideMenuPresentationStyleSlideAbove) {
        if (self.leftViewStyleView) [self.view addSubview:self.leftViewStyleView];
        if (self.leftViewContainer) [self.view addSubview:self.leftViewContainer];
    }

    if (self.rightViewPresentationStyle == LGSideMenuPresentationStyleSlideAbove) {
        if (self.rightViewStyleView) [self.view addSubview:self.rightViewStyleView];
        if (self.rightViewContainer) [self.view addSubview:self.rightViewContainer];
    }
}

- (void)rootViewsLayoutValidate {
    [self rootViewsLayoutValidateWithPercentage:(self.isLeftViewShowing || self.isRightViewShowing ? 1.0 : 0.0)];
}

- (void)rootViewsLayoutValidateWithPercentage:(CGFloat)percentage {
    if (!self.rootView) return;

    // -----

    self.rootViewStyleView.transform = CGAffineTransformIdentity;
    self.rootViewContainer.transform = CGAffineTransformIdentity;
    self.rootViewCoverView.transform = CGAffineTransformIdentity;

    // -----

    CGFloat frameWidth = CGRectGetWidth(self.view.frame);
    CGFloat frameHeight = CGRectGetHeight(self.view.frame);

    CGRect rootViewViewFrame = CGRectMake(0.0, 0.0, frameWidth, frameHeight);
    CGAffineTransform transform = CGAffineTransformIdentity;

    BOOL leftViewAlwaysVisible = NO;
    BOOL rightViewAlwaysVisible = NO;

    // -----

    if (self.leftView && self.isLeftViewAlwaysVisibleForCurrentOrientation) {
        leftViewAlwaysVisible = YES;

        rootViewViewFrame.origin.x += self.leftViewWidth;
        rootViewViewFrame.size.width -= self.leftViewWidth;
    }

    if (self.rightView && self.isRightViewAlwaysVisibleForCurrentOrientation) {
        rightViewAlwaysVisible = YES;

        rootViewViewFrame.size.width -= self.rightViewWidth;
    }

    if (!leftViewAlwaysVisible && !rightViewAlwaysVisible) {
        if (self.leftView && self.isLeftViewVisible && self.leftViewPresentationStyle != LGSideMenuPresentationStyleSlideAbove) {
            CGFloat rootViewScale = 1.0+(self.rootViewScaleForLeftView-1.0)*percentage;

            transform = CGAffineTransformMakeScale(rootViewScale, rootViewScale);

            CGFloat shift = frameWidth*(1.0-rootViewScale)/2;

            rootViewViewFrame = CGRectMake((self.leftViewWidth-shift)*percentage, 0.0, frameWidth, frameHeight);

            if (UIScreen.mainScreen.scale == 1.0) {
                rootViewViewFrame = CGRectIntegral(rootViewViewFrame);
            }
        }
        else if (self.rightView && self.isRightViewVisible && self.rightViewPresentationStyle != LGSideMenuPresentationStyleSlideAbove) {
            CGFloat rootViewScale = 1.0+(self.rootViewScaleForRightView-1.0)*percentage;

            transform = CGAffineTransformMakeScale(rootViewScale, rootViewScale);

            CGFloat shift = frameWidth*(1.0-rootViewScale)/2;

            rootViewViewFrame = CGRectMake(-(self.rightViewWidth-shift)*percentage, 0.0, frameWidth, frameHeight);

            if (UIScreen.mainScreen.scale == 1.0) {
                rootViewViewFrame = CGRectIntegral(rootViewViewFrame);
            }
        }
    }

    self.rootViewContainer.frame = rootViewViewFrame;
    self.rootViewContainer.transform = transform;

    // -----

    CGFloat borderWidth = self.rootViewStyleView.layer.borderWidth;
    self.rootViewStyleView.frame = CGRectMake(CGRectGetMinX(rootViewViewFrame)-borderWidth,
                                              CGRectGetMinY(rootViewViewFrame)-borderWidth,
                                              CGRectGetWidth(rootViewViewFrame)+borderWidth*2,
                                              CGRectGetHeight(rootViewViewFrame)+borderWidth*2);
    self.rootViewStyleView.transform = transform;

    // -----

    self.rootViewCoverView.frame = rootViewViewFrame;
    self.rootViewCoverView.transform = transform;

    if (self.leftView && self.isLeftViewVisible) {
        self.rootViewCoverView.alpha = self.rootViewCoverAlphaForLeftView * percentage;
    }
    else if (self.rightView && self.isRightViewVisible) {
        self.rootViewCoverView.alpha = self.rootViewCoverAlphaForRightView * percentage;
    }
    else {
        self.rootViewCoverView.alpha = percentage;
    }
}

- (void)leftViewsLayoutValidate {
    [self leftViewsLayoutValidateWithPercentage:(self.isLeftViewShowing ? 1.0 : 0.0)];
}

- (void)leftViewsLayoutValidateWithPercentage:(CGFloat)percentage {
    if (!self.leftView) return;

    // -----

    self.backgroundImageViewForLeftView.transform = CGAffineTransformIdentity;
    self.leftViewContainer.transform = CGAffineTransformIdentity;
    self.leftViewStyleView.transform = CGAffineTransformIdentity;

    // -----

    CGFloat frameWidth = CGRectGetWidth(self.view.frame);
    CGFloat frameHeight = CGRectGetHeight(self.view.frame);

    CGFloat originX = 0.0;
    CGAffineTransform leftViewTransform = CGAffineTransformIdentity;
    CGAffineTransform backgroundViewTransform = CGAffineTransformIdentity;

    // -----

    if (!self.isLeftViewAlwaysVisibleForCurrentOrientation) {
        if (self.leftViewPresentationStyle == LGSideMenuPresentationStyleSlideAbove) {
            originX = -(self.leftViewWidth+self.leftViewStyleView.contentView.layer.shadowRadius*2)*(1.0-percentage);
        }
        else {
            CGFloat leftViewScale = 1.0+(self.leftViewInititialScale-1.0)*(1.0-percentage);
            CGFloat backgroundViewScale = 1.0+(self.leftViewBackgroundImageInitialScale-1.0)*(1.0-percentage);

            leftViewTransform = CGAffineTransformMakeScale(leftViewScale, leftViewScale);
            backgroundViewTransform = CGAffineTransformMakeScale(backgroundViewScale, backgroundViewScale);

            originX = (-(self.leftViewWidth*(1.0-leftViewScale)/2)+(self.leftViewInititialOffsetX*leftViewScale))*(1.0-percentage);
        }
    }

    CGRect leftViewFrame = CGRectMake(originX, 0.0, self.leftViewWidth, frameHeight);

    if (UIScreen.mainScreen.scale == 1.0) {
        leftViewFrame = CGRectIntegral(leftViewFrame);
    }

    self.leftViewContainer.frame = leftViewFrame;
    self.leftViewContainer.transform = leftViewTransform;

    // -----

    if (self.leftViewPresentationStyle != LGSideMenuPresentationStyleSlideAbove) {
        CGRect backgroundViewFrame = CGRectMake(0.0, 0.0, frameWidth, frameHeight);

        if (self.isLeftViewAlwaysVisibleForCurrentOrientation && self.isRightViewAlwaysVisibleForCurrentOrientation) {
            CGFloat multiplier = self.rightViewWidth/self.leftViewWidth;

            backgroundViewFrame.size.width = (frameWidth/(multiplier+1.0));
        }

        if (UIScreen.mainScreen.scale == 1.0) {
            backgroundViewFrame = CGRectIntegral(backgroundViewFrame);
        }

        self.backgroundColorViewForLeftView.frame = backgroundViewFrame;

        self.backgroundImageViewForLeftView.frame = backgroundViewFrame;
        self.backgroundImageViewForLeftView.transform = backgroundViewTransform;
    }
    else {
        CGFloat borderWidth = self.leftViewStyleView.contentView.layer.borderWidth;
        self.leftViewStyleView.frame = CGRectMake(CGRectGetMinX(leftViewFrame)-borderWidth,
                                                  CGRectGetMinY(leftViewFrame)-borderWidth,
                                                  CGRectGetWidth(leftViewFrame)+borderWidth*2,
                                                  CGRectGetHeight(leftViewFrame)+borderWidth*2);
        self.leftViewStyleView.transform = leftViewTransform;
    }

    // -----

    if (self.sideViewsCoverView) {
        if (self.isLeftViewVisible && !self.isLeftViewAlwaysVisibleForCurrentOrientation && !self.isRightViewAlwaysVisibleForCurrentOrientation) {
            self.sideViewsCoverView.alpha = self.leftViewCoverAlpha - (self.leftViewCoverAlpha * percentage);
        }

        self.sideViewsCoverView.frame = CGRectMake(0.0, 0.0, frameWidth, frameHeight);
    }
}

- (void)rightViewsLayoutValidate {
    [self rightViewsLayoutValidateWithPercentage:(self.isRightViewShowing ? 1.0 : 0.0)];
}

- (void)rightViewsLayoutValidateWithPercentage:(CGFloat)percentage {
    if (!self.rightView) return;

    // -----

    self.backgroundImageViewForRightView.transform = CGAffineTransformIdentity;
    self.rightViewContainer.transform = CGAffineTransformIdentity;
    self.rightViewStyleView.transform = CGAffineTransformIdentity;

    // -----

    CGFloat frameWidth = CGRectGetWidth(self.view.frame);
    CGFloat frameHeight = CGRectGetHeight(self.view.frame);

    CGFloat originX = frameWidth-self.rightViewWidth;
    CGAffineTransform rightViewTransform = CGAffineTransformIdentity;
    CGAffineTransform backgroundViewTransform = CGAffineTransformIdentity;

    // -----

    if (!self.isRightViewAlwaysVisibleForCurrentOrientation) {
        if (self.rightViewPresentationStyle == LGSideMenuPresentationStyleSlideAbove) {
            originX = frameWidth-self.rightViewWidth+(self.rightViewWidth+self.rightViewStyleView.contentView.layer.shadowRadius*2)*(1.0-percentage);
        }
        else {
            CGFloat rightViewScale = 1.0+(self.rightViewInititialScale-1.0)*(1.0-percentage);
            CGFloat backgroundViewScale = 1.0+(self.rightViewBackgroundImageInitialScale-1.0)*(1.0-percentage);

            rightViewTransform = CGAffineTransformMakeScale(rightViewScale, rightViewScale);
            backgroundViewTransform = CGAffineTransformMakeScale(backgroundViewScale, backgroundViewScale);

            originX = frameWidth-self.rightViewWidth+((self.rightViewWidth*(1.0-rightViewScale)/2)+(self.rightViewInititialOffsetX*rightViewScale))*(1.0-percentage);
        }
    }

    // -----

    CGRect rightViewFrame = CGRectMake(originX, 0.0, self.rightViewWidth, frameHeight);

    if (UIScreen.mainScreen.scale == 1.0) {
        rightViewFrame = CGRectIntegral(rightViewFrame);
    }

    self.rightViewContainer.frame = rightViewFrame;
    self.rightViewContainer.transform = rightViewTransform;

    // -----

    if (self.rightViewPresentationStyle != LGSideMenuPresentationStyleSlideAbove) {
        CGRect backgroundViewFrame = CGRectMake(0.0, 0.0, frameWidth, frameHeight);

        if (self.isLeftViewAlwaysVisibleForCurrentOrientation && self.isRightViewAlwaysVisibleForCurrentOrientation) {
            CGFloat multiplier = self.leftViewWidth/self.rightViewWidth;

            backgroundViewFrame.size.width = (frameWidth/(multiplier+1.0));
            backgroundViewFrame.origin.x = frameWidth - CGRectGetWidth(backgroundViewFrame);
        }

        if (UIScreen.mainScreen.scale == 1.0) {
            backgroundViewFrame = CGRectIntegral(backgroundViewFrame);
        }

        self.backgroundColorViewForRightView.frame = backgroundViewFrame;

        self.backgroundImageViewForRightView.frame = backgroundViewFrame;
        self.backgroundImageViewForRightView.transform = backgroundViewTransform;
    }
    else {
        CGFloat borderWidth = self.rightViewStyleView.contentView.layer.borderWidth;
        self.rightViewStyleView.frame = CGRectMake(CGRectGetMinX(rightViewFrame)-borderWidth,
                                                   CGRectGetMinY(rightViewFrame)-borderWidth,
                                                   CGRectGetWidth(rightViewFrame)+borderWidth*2,
                                                   CGRectGetHeight(rightViewFrame)+borderWidth*2);
        self.rightViewStyleView.transform = rightViewTransform;
    }

    // -----

    if (self.sideViewsCoverView) {
        if (self.isRightViewVisible && !self.isRightViewAlwaysVisibleForCurrentOrientation && !self.isLeftViewAlwaysVisibleForCurrentOrientation) {
            self.sideViewsCoverView.alpha = self.rightViewCoverAlpha - (self.rightViewCoverAlpha * percentage);
        }

        self.sideViewsCoverView.frame = CGRectMake(0.0, 0.0, frameWidth, frameHeight);
    }
}

- (void)stylesValidate {
    if (self.rootViewStyleView) {
        self.rootViewStyleView.layer.borderWidth = self.rootViewLayerBorderWidth;
        self.rootViewStyleView.layer.borderColor = self.rootViewLayerBorderColor.CGColor;
        self.rootViewStyleView.layer.shadowColor = self.rootViewLayerShadowColor.CGColor;
        self.rootViewStyleView.layer.shadowRadius = self.rootViewLayerShadowRadius;
    }

    if (self.isLeftViewAlwaysVisibleForCurrentOrientation || self.isLeftViewVisible) {
        if (!self.isLeftViewAlwaysVisibleForCurrentOrientation) {
            self.rootViewCoverView.contentView.backgroundColor = self.rootViewCoverColorForLeftView;
            self.rootViewCoverView.effect = self.rootViewCoverBlurEffectForLeftView;

            if (self.sideViewsCoverView) {
                self.sideViewsCoverView.contentView.backgroundColor = self.leftViewCoverColor;
                self.sideViewsCoverView.effect = self.leftViewCoverBlurEffect;
            }
        }

        if (self.leftViewStyleView) {
            self.leftViewStyleView.contentView.backgroundColor = self.isLeftViewAlwaysVisibleForCurrentOrientation ? [self.leftViewBackgroundColor colorWithAlphaComponent:1.0] : self.leftViewBackgroundColor;
            self.leftViewStyleView.contentView.layer.borderWidth = self.leftViewLayerBorderWidth;
            self.leftViewStyleView.contentView.layer.borderColor = self.leftViewLayerBorderColor.CGColor;
            self.leftViewStyleView.contentView.layer.shadowColor = self.leftViewLayerShadowColor.CGColor;
            self.leftViewStyleView.contentView.layer.shadowRadius = self.leftViewLayerShadowRadius;
            self.leftViewStyleView.effect = self.leftViewBackgroundBlurEffect;
            self.leftViewStyleView.alpha = self.leftViewBackgroundAlpha;
        }

        if (self.backgroundColorViewForLeftView) {
            self.backgroundColorViewForLeftView.backgroundColor = self.leftViewBackgroundColor;
        }

        if (self.backgroundImageViewForLeftView) {
            self.backgroundImageViewForLeftView.image = self.leftViewBackgroundImage;
        }
    }

    if (self.isRightViewAlwaysVisibleForCurrentOrientation || self.isRightViewVisible) {
        if (!self.isRightViewAlwaysVisibleForCurrentOrientation) {
            self.rootViewCoverView.contentView.backgroundColor = self.rootViewCoverColorForRightView;
            self.rootViewCoverView.effect = self.rootViewCoverBlurEffectForRightView;

            if (self.sideViewsCoverView) {
                self.sideViewsCoverView.contentView.backgroundColor = self.rightViewCoverColor;
                self.sideViewsCoverView.effect = self.rightViewCoverBlurEffect;
            }
        }

        if (self.rightViewStyleView) {
            self.rightViewStyleView.contentView.backgroundColor = self.isRightViewAlwaysVisibleForCurrentOrientation ? [self.rightViewBackgroundColor colorWithAlphaComponent:1.0] : self.rightViewBackgroundColor;
            self.rightViewStyleView.contentView.layer.borderWidth = self.rightViewLayerBorderWidth;
            self.rightViewStyleView.contentView.layer.borderColor = self.rightViewLayerBorderColor.CGColor;
            self.rightViewStyleView.contentView.layer.shadowColor = self.rightViewLayerShadowColor.CGColor;
            self.rightViewStyleView.contentView.layer.shadowRadius = self.rightViewLayerShadowRadius;
            self.rightViewStyleView.effect = self.rightViewBackgroundBlurEffect;
            self.rightViewStyleView.alpha = self.rightViewBackgroundAlpha;
        }

        if (self.backgroundColorViewForRightView) {
            self.backgroundColorViewForRightView.backgroundColor = self.rightViewBackgroundColor;
        }

        if (self.backgroundImageViewForRightView) {
            self.backgroundImageViewForRightView.image = self.rightViewBackgroundImage;
        }
    }
}

- (void)visibilityValidate {
    [self visibilityValidateWithDelay:0.0];
}

- (void)visibilityValidateWithDelay:(NSTimeInterval)delay {
    BOOL rootViewStyleViewHiddenForLeftView = YES;
    BOOL rootViewCoverViewHiddenForLeftView = YES;
    BOOL sideViewsCoverViewHiddenForLeftView = YES;

    if (self.leftView) {
        if (self.isLeftViewAlwaysVisibleForCurrentOrientation) {
            self.backgroundColorViewForLeftView.hidden = NO;
            self.backgroundImageViewForLeftView.hidden = NO;
            self.leftViewStyleView.hidden = NO;
            self.leftViewContainer.hidden = NO;

            sideViewsCoverViewHiddenForLeftView = YES;
            rootViewStyleViewHiddenForLeftView = NO;
            rootViewCoverViewHiddenForLeftView = YES;
        }
        else if (self.isLeftViewVisible) {
            self.backgroundColorViewForLeftView.hidden = NO;
            self.backgroundImageViewForLeftView.hidden = NO;
            self.leftViewStyleView.hidden = NO;
            self.leftViewContainer.hidden = NO;

            sideViewsCoverViewHiddenForLeftView = NO;
            rootViewStyleViewHiddenForLeftView = NO;
            rootViewCoverViewHiddenForLeftView = NO;
        }
        else if (self.isLeftViewHidden) {
            if (delay) {
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^(void) {
                    self.backgroundColorViewForLeftView.hidden = YES;
                    self.backgroundImageViewForLeftView.hidden = YES;
                    self.leftViewStyleView.hidden = YES;
                    self.leftViewContainer.hidden = YES;
                });
            }
            else {
                self.backgroundColorViewForLeftView.hidden = YES;
                self.backgroundImageViewForLeftView.hidden = YES;
                self.leftViewStyleView.hidden = YES;
                self.leftViewContainer.hidden = YES;
            }

            sideViewsCoverViewHiddenForLeftView = YES;
            rootViewStyleViewHiddenForLeftView = YES;
            rootViewCoverViewHiddenForLeftView = YES;
        }
    }

    // -----

    BOOL rootViewStyleViewHiddenForRightView = YES;
    BOOL rootViewCoverViewHiddenForRightView = YES;
    BOOL sideViewsCoverViewHiddenForRightView = YES;

    if (self.rightView) {
        if (self.isRightViewAlwaysVisibleForCurrentOrientation) {
            self.backgroundColorViewForRightView.hidden = NO;
            self.backgroundImageViewForRightView.hidden = NO;
            self.rightViewStyleView.hidden = NO;
            self.rightViewContainer.hidden = NO;

            sideViewsCoverViewHiddenForRightView = YES;
            rootViewStyleViewHiddenForRightView = NO;
            rootViewCoverViewHiddenForRightView = YES;
        }
        else if (self.isRightViewVisible) {
            self.backgroundColorViewForRightView.hidden = NO;
            self.backgroundImageViewForRightView.hidden = NO;
            self.rightViewStyleView.hidden = NO;
            self.rightViewContainer.hidden = NO;

            sideViewsCoverViewHiddenForRightView = NO;
            rootViewStyleViewHiddenForRightView = NO;
            rootViewCoverViewHiddenForRightView = NO;
        }
        else if (self.isRightViewHidden) {
            if (delay) {
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^(void) {
                    self.backgroundColorViewForRightView.hidden = YES;
                    self.backgroundImageViewForRightView.hidden = YES;
                    self.rightViewStyleView.hidden = YES;
                    self.rightViewContainer.hidden = YES;
                });
            }
            else {
                self.backgroundColorViewForRightView.hidden = YES;
                self.backgroundImageViewForRightView.hidden = YES;
                self.rightViewStyleView.hidden = YES;
                self.rightViewContainer.hidden = YES;
            }

            sideViewsCoverViewHiddenForRightView = YES;
            rootViewStyleViewHiddenForRightView = YES;
            rootViewCoverViewHiddenForRightView = YES;
        }
    }

    // -----

    if (rootViewStyleViewHiddenForLeftView && rootViewStyleViewHiddenForRightView) {
        if (delay) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^(void) {
                self.rootViewStyleView.hidden = YES;
            });
        }
        else {
            self.rootViewStyleView.hidden = YES;
        }
    }
    else {
        self.rootViewStyleView.hidden = NO;
    }

    // -----

    if (rootViewCoverViewHiddenForLeftView && rootViewCoverViewHiddenForRightView) {
        if (delay) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^(void) {
                self.rootViewCoverView.hidden = YES;
            });
        }
        else {
            self.rootViewCoverView.hidden = YES;
        }
    }
    else {
        self.rootViewCoverView.hidden = NO;
    }

    // -----

    if ((sideViewsCoverViewHiddenForLeftView && sideViewsCoverViewHiddenForRightView) ||
        self.isLeftViewAlwaysVisibleForCurrentOrientation || self.isRightViewAlwaysVisibleForCurrentOrientation) {
        if (delay) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^(void) {
                self.sideViewsCoverView.hidden = YES;
            });
        }
        else {
            self.sideViewsCoverView.hidden = YES;
        }
    }
    else {
        self.sideViewsCoverView.hidden = NO;
    }
}

#pragma mark - Left view actions

- (void)showLeftViewAnimated:(BOOL)animated completionHandler:(LGSideMenuControllerCompletionHandler)completionHandler {
    if (!self.leftView ||
        self.isLeftViewDisabled ||
        self.isLeftViewShowing ||
        self.isLeftViewAlwaysVisibleForCurrentOrientation ||
        (self.isRightViewAlwaysVisibleForCurrentOrientation && self.leftViewPresentationStyle != LGSideMenuPresentationStyleSlideAbove)) {
        return;
    }

    [self showLeftViewPrepareWithGesture:NO];
    [self showLeftViewAnimatedActions:animated completionHandler:completionHandler];
}

- (void)hideLeftViewAnimated:(BOOL)animated completionHandler:(LGSideMenuControllerCompletionHandler)completionHandler {
    if (!self.leftView ||
        self.isLeftViewDisabled ||
        self.isLeftViewHidden ||
        self.isLeftViewAlwaysVisibleForCurrentOrientation ||
        (self.isRightViewAlwaysVisibleForCurrentOrientation && self.leftViewPresentationStyle != LGSideMenuPresentationStyleSlideAbove)) {
        return;
    }

    [self hideLeftViewPrepareWithGesture:NO];
    [self hideLeftViewAnimatedActions:animated completionHandler:completionHandler];
}

- (void)toggleLeftViewAnimated:(BOOL)animated completionHandler:(LGSideMenuControllerCompletionHandler)completionHandler {
    if (self.isLeftViewShowing) {
        [self hideLeftViewAnimated:animated completionHandler:completionHandler];
    }
    else {
        [self showLeftViewAnimated:animated completionHandler:completionHandler];
    }
}

#pragma mark -

- (IBAction)showLeftView:(nullable id)sender {
    [self showLeftViewAnimated:NO completionHandler:nil];
}

- (IBAction)hideLeftView:(nullable id)sender {
    [self hideLeftViewAnimated:NO completionHandler:nil];
}

- (IBAction)toggleLeftView:(nullable id)sender {
    [self toggleLeftViewAnimated:NO completionHandler:nil];
}

#pragma mark -

- (IBAction)showLeftViewAnimated:(nullable id)sender {
    [self showLeftViewAnimated:YES completionHandler:nil];
}

- (IBAction)hideLeftViewAnimated:(nullable id)sender {
    [self hideLeftViewAnimated:YES completionHandler:nil];
}

- (IBAction)toggleLeftViewAnimated:(nullable id)sender {
    [self toggleLeftViewAnimated:YES completionHandler:nil];
}

#pragma mark - Show left view

- (void)showLeftViewPrepareWithGesture:(BOOL)withGesture {
    self.leftViewGoingToShow = YES;

    [self.view endEditing:YES];

    [self stylesValidate];
    [self visibilityValidate];

    [self.rootViewController removeFromParentViewController];

    if (withGesture) {
        [self statusBarAppearanceUpdateAnimated:YES
                                       duration:self.leftViewAnimationSpeed
                                         hidden:self.leftViewStatusBarHidden
                                          style:self.leftViewStatusBarStyle
                                      animation:self.leftViewStatusBarUpdateAnimation];
    }
    else {
        [self rootViewsLayoutValidateWithPercentage:0.0];
        [self leftViewsLayoutValidateWithPercentage:0.0];
    }
}

- (void)showLeftViewAnimatedActions:(BOOL)animated completionHandler:(LGSideMenuControllerCompletionHandler)completionHandler {
    if (self.leftViewGoingToShow) {
        [self willShowLeftViewCallbacks];
    }

    // -----

    [self statusBarAppearanceUpdateAnimated:animated
                                   duration:self.leftViewAnimationSpeed
                                     hidden:self.leftViewStatusBarHidden
                                      style:self.leftViewStatusBarStyle
                                  animation:self.leftViewStatusBarUpdateAnimation];

    // -----

    if (animated) {
        self.gesturesHandler.animating = YES;

        [self
         animateStandardWithDuration:self.leftViewAnimationSpeed
         animations:^(void) {
             [self rootViewsLayoutValidateWithPercentage:1.0];
             [self leftViewsLayoutValidateWithPercentage:1.0];

             // -----

             if (self.showLeftViewAnimationsBlock) {
                 self.showLeftViewAnimationsBlock(self, self.leftView, self.leftViewAnimationSpeed);
             }

             if (self.delegate && [self.delegate respondsToSelector:@selector(showAnimationsBlockForLeftView:sideMenuController:duration:)]) {
                 [self.delegate showAnimationsBlockForLeftView:self.leftView sideMenuController:self duration:self.leftViewAnimationSpeed];
             }
         }
         completion:^(BOOL finished) {
             [self showLeftViewDoneWithGesture:NO];

             self.gesturesHandler.animating = NO;

             if (completionHandler) {
                 completionHandler();
             }
         }];
    }
    else {
        [self showLeftViewDoneWithGesture:NO];

        if (completionHandler) {
            completionHandler();
        }
    }
}

- (void)showLeftViewDoneWithGesture:(BOOL)withGesture {
    if (withGesture) {
        self.leftViewGestireStartX = nil;
    }
    else {
        [self rootViewsLayoutValidateWithPercentage:1.0];
        [self leftViewsLayoutValidateWithPercentage:1.0];
    }

    self.leftViewShowing = YES;

    if (self.isLeftViewGoingToShow) {
        self.leftViewGoingToShow = NO;

        if (self.rootViewController) {
            [self addChildViewController:self.rootViewController];
        }

        [self didShowLeftViewCallbacks];
    }
}

#pragma mark - Hide left view

- (void)hideLeftViewPrepareWithGesture:(BOOL)withGesture {
    self.leftViewGoingToHide = YES;

    [self.view endEditing:YES];

    if (self.rootViewController) {
        [self addChildViewController:self.rootViewController];
    }
}

- (void)hideLeftViewAnimatedActions:(BOOL)animated completionHandler:(LGSideMenuControllerCompletionHandler)completionHandler {
    if (self.isLeftViewGoingToHide) {
        [self willHideLeftViewCallbacks];
    }

    // -----

    [self statusBarAppearanceUpdateAnimated:animated
                                   duration:self.leftViewAnimationSpeed
                                     hidden:self.leftViewStatusBarHidden
                                      style:self.leftViewStatusBarStyle
                                  animation:self.leftViewStatusBarUpdateAnimation];

    // -----

    if (animated) {
        self.gesturesHandler.animating = YES;

        [self
         animateStandardWithDuration:self.leftViewAnimationSpeed
         animations:^(void) {
             [self rootViewsLayoutValidateWithPercentage:0.0];
             [self leftViewsLayoutValidateWithPercentage:0.0];

             // -----

             if (self.hideLeftViewAnimationsBlock) {
                 self.hideLeftViewAnimationsBlock(self, self.leftView, self.leftViewAnimationSpeed);
             }

             if (self.delegate && [self.delegate respondsToSelector:@selector(hideAnimationsBlockForLeftView:sideMenuController:duration:)]) {
                 [self.delegate hideAnimationsBlockForLeftView:self.leftView sideMenuController:self duration:self.leftViewAnimationSpeed];
             }
         }
         completion:^(BOOL finished) {
             [self hideLeftViewDoneWithGesture:NO];

             self.gesturesHandler.animating = NO;

             if (completionHandler) {
                 completionHandler();
             }
         }];
    }
    else {
        [self hideLeftViewDoneWithGesture:NO];

        if (completionHandler) {
            completionHandler();
        }
    }
}

- (void)hideLeftViewDoneWithGesture:(BOOL)withGesture {
    if (withGesture) {
        [self statusBarAppearanceUpdateAnimated:YES
                                       duration:self.leftViewAnimationSpeed
                                         hidden:self.leftViewStatusBarHidden
                                          style:self.leftViewStatusBarStyle
                                      animation:self.leftViewStatusBarUpdateAnimation];

        self.leftViewGestireStartX = nil;
    }
    else {
        [self rootViewsLayoutValidateWithPercentage:0.0];
        [self leftViewsLayoutValidateWithPercentage:0.0];
    }

    self.leftViewShowing = NO;

    if (self.isLeftViewGoingToHide) {
        self.leftViewGoingToHide = NO;

        [self visibilityValidate];

        [self didHideLeftViewCallbacks];
    }
    else {
        [self visibilityValidate];
    }
}

#pragma mark - Right view actions

- (void)showRightViewAnimated:(BOOL)animated completionHandler:(LGSideMenuControllerCompletionHandler)completionHandler {
    if (!self.rightView ||
        self.isRightViewDisabled ||
        self.isRightViewShowing ||
        self.isRightViewAlwaysVisibleForCurrentOrientation ||
        (self.isLeftViewAlwaysVisibleForCurrentOrientation && self.rightViewPresentationStyle != LGSideMenuPresentationStyleSlideAbove)) {
        return;
    }

    [self showRightViewPrepareWithGesture:NO];
    [self showRightViewAnimatedActions:animated completionHandler:completionHandler];
}

- (void)hideRightViewAnimated:(BOOL)animated completionHandler:(LGSideMenuControllerCompletionHandler)completionHandler {
    if (!self.rightView ||
        self.isRightViewDisabled ||
        self.isRightViewHidden ||
        self.isRightViewAlwaysVisibleForCurrentOrientation ||
        (self.isLeftViewAlwaysVisibleForCurrentOrientation && self.rightViewPresentationStyle != LGSideMenuPresentationStyleSlideAbove)) {
        return;
    }

    [self hideRightViewPrepareWithGesture:NO];
    [self hideRightViewAnimatedActions:animated completionHandler:completionHandler];
}

- (void)toggleRightViewAnimated:(BOOL)animated completionHandler:(LGSideMenuControllerCompletionHandler)completionHandler {
    if (self.isRightViewShowing) {
        [self hideRightViewAnimated:animated completionHandler:completionHandler];
    }
    else {
        [self showRightViewAnimated:animated completionHandler:completionHandler];
    }
}

#pragma mark -

- (IBAction)showRightView:(nullable id)sender {
    [self showRightViewAnimated:NO completionHandler:nil];
}

- (IBAction)hideRightView:(nullable id)sender {
    [self hideRightViewAnimated:NO completionHandler:nil];
}

- (IBAction)toggleRightView:(nullable id)sender {
    [self toggleRightViewAnimated:NO completionHandler:nil];
}

#pragma mark -

- (IBAction)showRightViewAnimated:(nullable id)sender {
    [self showRightViewAnimated:YES completionHandler:nil];
}

- (IBAction)hideRightViewAnimated:(nullable id)sender {
    [self hideRightViewAnimated:YES completionHandler:nil];
}

- (IBAction)toggleRightViewAnimated:(nullable id)sender {
    [self toggleRightViewAnimated:YES completionHandler:nil];
}

#pragma mark - Show right view

- (void)showRightViewPrepareWithGesture:(BOOL)withGesture {
    self.rightViewGoingToShow = YES;

    [self.view endEditing:YES];

    [self stylesValidate];
    [self visibilityValidate];

    [self.rootViewController removeFromParentViewController];

    if (withGesture) {
        [self statusBarAppearanceUpdateAnimated:YES
                                       duration:self.rightViewAnimationSpeed
                                         hidden:self.rightViewStatusBarHidden
                                          style:self.rightViewStatusBarStyle
                                      animation:self.rightViewStatusBarUpdateAnimation];
    }
    else {
        [self rootViewsLayoutValidateWithPercentage:0.0];
        [self rightViewsLayoutValidateWithPercentage:0.0];
    }
}

- (void)showRightViewAnimatedActions:(BOOL)animated completionHandler:(LGSideMenuControllerCompletionHandler)completionHandler {
    if (self.rightViewGoingToShow) {
        [self willShowRightViewCallbacks];
    }

    // -----

    [self statusBarAppearanceUpdateAnimated:animated
                                   duration:self.rightViewAnimationSpeed
                                     hidden:self.rightViewStatusBarHidden
                                      style:self.rightViewStatusBarStyle
                                  animation:self.rightViewStatusBarUpdateAnimation];

    // -----

    if (animated) {
        self.gesturesHandler.animating = YES;

        [self
         animateStandardWithDuration:self.rightViewAnimationSpeed
         animations:^(void) {
             [self rootViewsLayoutValidateWithPercentage:1.0];
             [self rightViewsLayoutValidateWithPercentage:1.0];

             // -----

             if (self.showRightViewAnimationsBlock) {
                 self.showRightViewAnimationsBlock(self, self.rightView, self.rightViewAnimationSpeed);
             }

             if (self.delegate && [self.delegate respondsToSelector:@selector(showAnimationsBlockForRightView:sideMenuController:duration:)]) {
                 [self.delegate showAnimationsBlockForRightView:self.rightView sideMenuController:self duration:self.rightViewAnimationSpeed];
             }
         }
         completion:^(BOOL finished) {
             [self showRightViewDoneWithGesture:NO];

             self.gesturesHandler.animating = NO;

             if (completionHandler) {
                 completionHandler();
             }
         }];
    }
    else {
        [self showRightViewDoneWithGesture:NO];

        if (completionHandler) {
            completionHandler();
        }
    }
}

- (void)showRightViewDoneWithGesture:(BOOL)withGesture {
    if (withGesture) {
        self.rightViewGestireStartX = nil;
    }
    else {
        [self rootViewsLayoutValidateWithPercentage:1.0];
        [self rightViewsLayoutValidateWithPercentage:1.0];
    }

    self.rightViewShowing = YES;

    if (self.isRightViewGoingToShow) {
        self.rightViewGoingToShow = NO;

        if (self.rootViewController) {
            [self addChildViewController:self.rootViewController];
        }
        
        [self didShowRightViewCallbacks];
    }
}

#pragma mark - Hide right view

- (void)hideRightViewPrepareWithGesture:(BOOL)withGesture {
    self.rightViewGoingToHide = YES;

    [self.view endEditing:YES];

    if (self.rootViewController) {
        [self addChildViewController:self.rootViewController];
    }
}

- (void)hideRightViewAnimatedActions:(BOOL)animated completionHandler:(LGSideMenuControllerCompletionHandler)completionHandler {
    if (self.isRightViewGoingToHide) {
        [self willHideRightViewCallbacks];
    }

    // -----

    [self statusBarAppearanceUpdateAnimated:animated
                                   duration:self.rightViewAnimationSpeed
                                     hidden:self.rightViewStatusBarHidden
                                      style:self.rightViewStatusBarStyle
                                  animation:self.rightViewStatusBarUpdateAnimation];

    // -----

    if (animated) {
        self.gesturesHandler.animating = YES;

        [self
         animateStandardWithDuration:self.rightViewAnimationSpeed
         animations:^(void) {
             [self rootViewsLayoutValidateWithPercentage:0.0];
             [self rightViewsLayoutValidateWithPercentage:0.0];

             // -----

             if (self.hideRightViewAnimationsBlock) {
                 self.hideRightViewAnimationsBlock(self, self.rightView, self.rightViewAnimationSpeed);
             }

             if (self.delegate && [self.delegate respondsToSelector:@selector(hideAnimationsBlockForRightView:sideMenuController:duration:)]) {
                 [self.delegate hideAnimationsBlockForRightView:self.rightView sideMenuController:self duration:self.rightViewAnimationSpeed];
             }
         }
         completion:^(BOOL finished) {
             [self hideRightViewDoneWithGesture:NO];

             self.gesturesHandler.animating = NO;

             if (completionHandler) {
                 completionHandler();
             }
         }];
    }
    else {
        [self hideRightViewDoneWithGesture:NO];

        if (completionHandler) {
            completionHandler();
        }
    }
}

- (void)hideRightViewDoneWithGesture:(BOOL)withGesture {
    if (withGesture) {
        [self statusBarAppearanceUpdateAnimated:YES
                                       duration:self.rightViewAnimationSpeed
                                         hidden:self.rightViewStatusBarHidden
                                          style:self.rightViewStatusBarStyle
                                      animation:self.rightViewStatusBarUpdateAnimation];

        self.rightViewGestireStartX = nil;
    }
    else {
        [self rootViewsLayoutValidateWithPercentage:0.0];
        [self rightViewsLayoutValidateWithPercentage:0.0];
    }

    self.rightViewShowing = NO;

    if (self.isRightViewGoingToHide) {
        self.rightViewGoingToHide = NO;

        [self visibilityValidate];
        
        [self didHideRightViewCallbacks];
    }
    else {
        [self visibilityValidate];
    }
}

#pragma mark - Callbacks

- (void)willShowLeftViewCallbacks {
    [[NSNotificationCenter defaultCenter] postNotificationName:LGSideMenuControllerWillShowLeftViewNotification object:self userInfo:nil];

    if (self.willShowLeftView) {
        self.willShowLeftView(self, self.leftView);
    }

    if (self.delegate && [self.delegate respondsToSelector:@selector(willShowLeftView:sideMenuController:)]) {
        [self.delegate willShowLeftView:self.leftView sideMenuController:self];
    }
}

- (void)didShowLeftViewCallbacks {
    [[NSNotificationCenter defaultCenter] postNotificationName:LGSideMenuControllerDidShowLeftViewNotification object:self userInfo:nil];

    if (self.didShowLeftView) {
        self.didShowLeftView(self, self.leftView);
    }

    if (self.delegate && [self.delegate respondsToSelector:@selector(didShowLeftView:sideMenuController:)]) {
        [self.delegate didShowLeftView:self.leftView sideMenuController:self];
    }
}

- (void)willHideLeftViewCallbacks {
    [[NSNotificationCenter defaultCenter] postNotificationName:LGSideMenuControllerWillHideLeftViewNotification object:self userInfo:nil];

    if (self.willHideLeftView) {
        self.willHideLeftView(self, self.leftView);
    }

    if (self.delegate && [self.delegate respondsToSelector:@selector(willHideLeftView:sideMenuController:)]) {
        [self.delegate willHideLeftView:self.leftView sideMenuController:self];
    }
}

- (void)didHideLeftViewCallbacks {
    [[NSNotificationCenter defaultCenter] postNotificationName:LGSideMenuControllerDidHideLeftViewNotification object:self userInfo:nil];

    if (self.didHideLeftView) {
        self.didHideLeftView(self, self.leftView);
    }

    if (self.delegate && [self.delegate respondsToSelector:@selector(didHideLeftView:sideMenuController:)]) {
        [self.delegate didHideLeftView:self.leftView sideMenuController:self];
    }
}

- (void)willShowRightViewCallbacks {
    [[NSNotificationCenter defaultCenter] postNotificationName:LGSideMenuControllerWillShowRightViewNotification object:self userInfo:nil];

    if (self.willShowRightView) {
        self.willShowRightView(self, self.rightView);
    }

    if (self.delegate && [self.delegate respondsToSelector:@selector(willShowRightView:sideMenuController:)]) {
        [self.delegate willShowRightView:self.leftView sideMenuController:self];
    }
}

- (void)didShowRightViewCallbacks {
    [[NSNotificationCenter defaultCenter] postNotificationName:LGSideMenuControllerDidShowRightViewNotification object:self userInfo:nil];

    if (self.didShowRightView) {
        self.didShowRightView(self, self.rightView);
    }

    if (self.delegate && [self.delegate respondsToSelector:@selector(didShowRightView:sideMenuController:)]) {
        [self.delegate didShowRightView:self.leftView sideMenuController:self];
    }
}

- (void)willHideRightViewCallbacks {
    [[NSNotificationCenter defaultCenter] postNotificationName:LGSideMenuControllerWillHideRightViewNotification object:self userInfo:nil];

    if (self.willHideRightView) {
        self.willHideRightView(self, self.rightView);
    }

    if (self.delegate && [self.delegate respondsToSelector:@selector(willHideRightView:sideMenuController:)]) {
        [self.delegate willHideRightView:self.leftView sideMenuController:self];
    }
}

- (void)didHideRightViewCallbacks {
    [[NSNotificationCenter defaultCenter] postNotificationName:LGSideMenuControllerDidHideRightViewNotification object:self userInfo:nil];

    if (self.didHideRightView) {
        self.didHideRightView(self, self.rightView);
    }

    if (self.delegate && [self.delegate respondsToSelector:@selector(didHideRightView:sideMenuController:)]) {
        [self.delegate didHideRightView:self.leftView sideMenuController:self];
    }
}

#pragma mark - UIGestureRecognizers

- (void)tapGesture:(UITapGestureRecognizer *)gesture {
    [self hideLeftViewAnimated:YES completionHandler:nil];
    [self hideRightViewAnimated:YES completionHandler:nil];
}

- (void)panGesture:(UIPanGestureRecognizer *)gestureRecognizer {
    CGPoint location = [gestureRecognizer locationInView:self.view];
    CGPoint velocity = [gestureRecognizer velocityInView:self.view];

    // -----

    CGFloat frameWidth = CGRectGetWidth(self.view.frame);

    // -----

    if (self.leftView && self.isLeftViewSwipeGestureEnabled && !self.isLeftViewAlwaysVisibleForCurrentOrientation && !self.rightViewGestireStartX && self.isRightViewHidden && self.isLeftViewEnabled) {
        if (!self.leftViewGestireStartX && (gestureRecognizer.state == UIGestureRecognizerStateBegan || gestureRecognizer.state == UIGestureRecognizerStateChanged)) {
            BOOL velocityReady = self.isLeftViewShowing ? velocity.x < 0.0 : velocity.x > 0.0;

            if (velocityReady && (self.isLeftViewShowing || self.swipeGestureArea == LGSideMenuSwipeGestureAreaFull || location.x < frameWidth / 2.0)) {
                self.leftViewGestireStartX = [NSNumber numberWithFloat:location.x];
                self.leftViewShowingBeforeGesture = self.leftViewShowing;

                if (self.isLeftViewShowing) {
                    [self hideLeftViewPrepareWithGesture:YES];
                }
                else {
                    [self showLeftViewPrepareWithGesture:YES];
                }
            }
        }
        else if (self.leftViewGestireStartX) {
            CGFloat firstVar = 0.0;

            if (self.isLeftViewShowingBeforeGesture) {
                firstVar = location.x+(self.leftViewWidth-self.leftViewGestireStartX.floatValue);
            }
            else {
                firstVar = location.x-self.leftViewGestireStartX.floatValue;
            }

            CGFloat percentage = firstVar/self.leftViewWidth;

            if (percentage < 0.0) {
                percentage = 0.0;
            }
            else if (percentage > 1.0) {
                percentage = 1.0;
            }

            if (gestureRecognizer.state == UIGestureRecognizerStateChanged) {
                [self rootViewsLayoutValidateWithPercentage:percentage];
                [self leftViewsLayoutValidateWithPercentage:percentage];
            }
            else if (gestureRecognizer.state == UIGestureRecognizerStateEnded && self.leftViewGestireStartX) {
                if ((percentage < 1.0 && velocity.x > 0.0) || (velocity.x == 0.0 && percentage >= 0.5)) {
                    self.leftViewGoingToShow = YES;
                    self.leftViewGoingToHide = NO;
                    [self showLeftViewAnimatedActions:YES completionHandler:nil];
                }
                else if ((percentage > 0.0 && velocity.x < 0.0) || (velocity.x == 0.0 && percentage < 0.5)) {
                    self.leftViewGoingToHide = YES;
                    self.leftViewGoingToShow = NO;
                    [self hideLeftViewAnimatedActions:YES completionHandler:nil];
                }
                else if (percentage == 1.0) {
                    self.leftViewGoingToShow = YES;
                    self.leftViewGoingToHide = NO;
                    [self showLeftViewDoneWithGesture:YES];
                }
                else if (percentage == 0.0) {
                    self.leftViewGoingToHide = YES;
                    self.leftViewGoingToShow = NO;
                    [self hideLeftViewDoneWithGesture:YES];
                }

                self.leftViewGestireStartX = nil;
            }
        }
    }

    // -----

    if (self.rightView && self.isRightViewSwipeGestureEnabled && !self.isRightViewAlwaysVisibleForCurrentOrientation && !self.leftViewGestireStartX && self.isLeftViewHidden && self.isRightViewEnabled) {
        if (!self.rightViewGestireStartX && (gestureRecognizer.state == UIGestureRecognizerStateBegan || gestureRecognizer.state == UIGestureRecognizerStateChanged)) {
            BOOL velocityReady = self.isRightViewShowing ? velocity.x > 0.0 : velocity.x < 0.0;

            if (velocityReady && (self.isRightViewShowing || self.swipeGestureArea == LGSideMenuSwipeGestureAreaFull || location.x > frameWidth / 2.0)) {
                self.rightViewGestireStartX = [NSNumber numberWithFloat:location.x];
                self.rightViewShowingBeforeGesture = self.rightViewShowing;

                if (self.isRightViewShowing) {
                    [self hideRightViewPrepareWithGesture:YES];
                }
                else {
                    [self showRightViewPrepareWithGesture:YES];
                }
            }
        }
        else if (self.rightViewGestireStartX) {
            CGFloat firstVar = 0.0;

            if (self.isRightViewShowingBeforeGesture) {
                firstVar = (location.x-(frameWidth-self.rightViewWidth))-(self.rightViewWidth-(frameWidth-self.rightViewGestireStartX.floatValue));
            }
            else {
                firstVar = (location.x-(frameWidth-self.rightViewWidth))+(frameWidth-self.rightViewGestireStartX.floatValue);
            }

            CGFloat percentage = 1.0-firstVar/self.rightViewWidth;

            if (percentage < 0.0) {
                percentage = 0.0;
            }
            else if (percentage > 1.0) {
                percentage = 1.0;
            }

            if (gestureRecognizer.state == UIGestureRecognizerStateChanged) {
                [self rootViewsLayoutValidateWithPercentage:percentage];
                [self rightViewsLayoutValidateWithPercentage:percentage];
            }
            else if (gestureRecognizer.state == UIGestureRecognizerStateEnded && self.rightViewGestireStartX) {
                if ((percentage < 1.0 && velocity.x < 0.0) || (velocity.x == 0.0 && percentage >= 0.5)) {
                    self.rightViewGoingToShow = YES;
                    self.rightViewGoingToHide = NO;
                    [self showRightViewAnimatedActions:YES completionHandler:nil];
                }
                else if ((percentage > 0.0 && velocity.x > 0.0) || (velocity.x == 0.0 && percentage < 0.5)) {
                    self.rightViewGoingToHide = YES;
                    self.rightViewGoingToShow = NO;
                    [self hideRightViewAnimatedActions:YES completionHandler:nil];
                }
                else if (percentage == 1.0) {
                    self.rightViewGoingToShow = YES;
                    self.rightViewGoingToHide = NO;
                    [self showRightViewDoneWithGesture:YES];
                }
                else if (percentage == 0.0) {
                    self.rightViewGoingToHide = YES;
                    self.rightViewGoingToShow = NO;
                    [self hideRightViewDoneWithGesture:YES];
                }
                
                self.rightViewGestireStartX = nil;
            }
        }
    }
}

#pragma mark - Helpers

- (void)animateStandardWithDuration:(NSTimeInterval)duration animations:(LGSideMenuControllerCompletionHandler)animations completion:(void(^)(BOOL finished))completion {
    [UIView animateWithDuration:duration
                          delay:0.0
         usingSpringWithDamping:1.0
          initialSpringVelocity:0.5
                        options:0
                     animations:animations
                     completion:completion];
    
}

- (void)statusBarAppearanceUpdateAnimated:(BOOL)animated
                                 duration:(NSTimeInterval)duration
                                   hidden:(BOOL)hidden
                                    style:(UIStatusBarStyle)style
                                animation:(UIStatusBarAnimation)animation {
    if (self.isViewControllerBasedStatusBarAppearance) {
        if (animated && animation != UIStatusBarAnimationNone) {
            [UIView animateWithDuration:duration animations:^{
                [self setNeedsStatusBarAppearanceUpdate];
            }];
        }
        else {
            [self setNeedsStatusBarAppearanceUpdate];
        }
    }
#if __IPHONE_OS_VERSION_MIN_REQUIRED < __IPHONE_9_0
    else {
        [UIApplication.sharedApplication setStatusBarHidden:hidden withAnimation:animation];
        [UIApplication.sharedApplication setStatusBarStyle:style animated:animated];
    }
#endif
}

- (BOOL)isViewControllerBasedStatusBarAppearance {
    if (UIDevice.currentDevice.systemVersion.floatValue >= 9.0) {
        return YES;
    }

    NSNumber *viewControllerBasedStatusBarAppearance = [NSBundle.mainBundle objectForInfoDictionaryKey:@"UIViewControllerBasedStatusBarAppearance"];

    return viewControllerBasedStatusBarAppearance == nil ? YES : viewControllerBasedStatusBarAppearance.boolValue;
}

@end

#pragma mark - Deprecated

@implementation LGSideMenuController (Deprecated)

- (void)setShouldShowLeftView:(BOOL)shouldShowLeftView {
    self.leftViewEnabled = shouldShowLeftView;
}

- (BOOL)isShouldShowLeftView {
    return self.isLeftViewEnabled;
}

- (void)setShouldShowRightView:(BOOL)shouldShowRightView {
    self.rightViewEnabled = shouldShowRightView;
}

- (BOOL)isShouldShowRightView {
    return self.isRightViewEnabled;
}

- (BOOL)isLeftViewAlwaysVisible {
    return self.isLeftViewAlwaysVisibleForCurrentOrientation;
}

- (BOOL)isRightViewAlwaysVisible {
    return self.isRightViewAlwaysVisibleForCurrentOrientation;
}

#pragma mark -

- (BOOL)isLeftViewAlwaysVisibleForInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return [self isLeftViewAlwaysVisibleForOrientation:interfaceOrientation];
}

- (BOOL)isRightViewAlwaysVisibleForInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return [self isRightViewAlwaysVisibleForInterfaceOrientation:interfaceOrientation];
}

- (void)showHideLeftViewAnimated:(BOOL)animated completionHandler:(LGSideMenuControllerCompletionHandler)completionHandler {
    [self toggleLeftViewAnimated:animated completionHandler:completionHandler];
}

- (void)showHideRightViewAnimated:(BOOL)animated completionHandler:(LGSideMenuControllerCompletionHandler)completionHandler {
    [self toggleRightViewAnimated:animated completionHandler:completionHandler];
}

- (void)setLeftViewEnabledWithWidth:(CGFloat)width
                  presentationStyle:(LGSideMenuPresentationStyle)presentationStyle
               alwaysVisibleOptions:(LGSideMenuAlwaysVisibleOptions)alwaysVisibleOptions {
    self.leftViewWidth = width;
    self.leftViewPresentationStyle = presentationStyle;
    self.leftViewAlwaysVisibleOptions = alwaysVisibleOptions;
}

- (void)setRightViewEnabledWithWidth:(CGFloat)width
                   presentationStyle:(LGSideMenuPresentationStyle)presentationStyle
                alwaysVisibleOptions:(LGSideMenuAlwaysVisibleOptions)alwaysVisibleOptions {
    self.rightViewWidth = width;
    self.rightViewPresentationStyle = presentationStyle;
    self.rightViewAlwaysVisibleOptions = alwaysVisibleOptions;
}

@end
