//
//  LGSideMenuController.m
//  LGSideMenuController
//
//
//  The MIT License (MIT)
//
//  Copyright © 2015 Grigorii Lutkov <friend.lga@gmail.com>
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
#import "LGSideMenuGesturesHandler.h"
#import "LGSideMenuHelper.h"
#import "LGSideMenuSegue.h"
#import "LGSideMenuBorderView.h"

#pragma mark - Constants

NSString * _Nonnull const LGSideMenuWillShowLeftViewNotification = @"LGSideMenuWillShowLeftViewNotification";
NSString * _Nonnull const LGSideMenuDidShowLeftViewNotification  = @"LGSideMenuDidShowLeftViewNotification";

NSString * _Nonnull const LGSideMenuWillHideLeftViewNotification = @"LGSideMenuWillHideLeftViewNotification";
NSString * _Nonnull const LGSideMenuDidHideLeftViewNotification  = @"LGSideMenuDidHideLeftViewNotification";

NSString * _Nonnull const LGSideMenuWillShowRightViewNotification = @"LGSideMenuWillShowRightViewNotification";
NSString * _Nonnull const LGSideMenuDidShowRightViewNotification  = @"LGSideMenuDidShowRightViewNotification";

NSString * _Nonnull const LGSideMenuWillHideRightViewNotification = @"LGSideMenuWillHideRightViewNotification";
NSString * _Nonnull const LGSideMenuDidHideRightViewNotification  = @"LGSideMenuDidHideRightViewNotification";

NSString *_Nonnull const LGSideMenuShowLeftViewAnimationsNotification = @"LGSideMenuShowLeftViewAnimationsNotification";
NSString *_Nonnull const LGSideMenuHideLeftViewAnimationsNotification = @"LGSideMenuHideLeftViewAnimationsNotification";

NSString *_Nonnull const LGSideMenuShowRightViewAnimationsNotification = @"LGSideMenuShowRightViewAnimationsNotification";
NSString *_Nonnull const LGSideMenuHideRightViewAnimationsNotification = @"LGSideMenuHideRightViewAnimationsNotification";

NSString * _Nonnull const kLGSideMenuView              = @"view";
NSString * _Nonnull const kLGSideMenuAnimationDuration = @"duration";

static CGFloat const LGSideMenuRotationDuration = 0.25;

#pragma mark -

LGSideMenuSwipeGestureRange LGSideMenuSwipeGestureRangeMake(CGFloat left, CGFloat right) {
    LGSideMenuSwipeGestureRange range;
    range.left = left;
    range.right = right;
    return range;
}

typedef NS_ENUM(NSUInteger, LGSideMenuState) {
    LGSideMenuStateRootViewIsShowing  = 0,
    LGSideMenuStateLeftViewWillShow   = 1,
    LGSideMenuStateLeftViewIsShowing  = 2,
    LGSideMenuStateLeftViewWillHide   = 3,
    LGSideMenuStateRightViewWillShow  = 4,
    LGSideMenuStateRightViewIsShowing = 5,
    LGSideMenuStateRightViewWillHide  = 6
};

#pragma mark - Interface

@interface LGSideMenuController ()

@property (strong, nonatomic, readwrite) LGSideMenuView *rootViewContainer;
@property (strong, nonatomic, readwrite) LGSideMenuView *leftViewContainer;
@property (strong, nonatomic, readwrite) LGSideMenuView *rightViewContainer;

@property (assign, nonatomic, readwrite) LGSideMenuState state;

@property (assign, nonatomic) CGSize savedSize;

@property (strong, nonatomic) LGSideMenuBorderView *rootViewStyleView;
@property (strong, nonatomic) UIVisualEffectView   *rootViewCoverView;

@property (strong, nonatomic, readwrite) UIImageView *leftViewBackgroundView;
@property (strong, nonatomic) UIVisualEffectView     *leftViewStyleView;
@property (strong, nonatomic) LGSideMenuBorderView   *leftViewBorderView;

@property (strong, nonatomic, readwrite) UIImageView *rightViewBackgroundView;
@property (strong, nonatomic) UIVisualEffectView     *rightViewStyleView;
@property (strong, nonatomic) LGSideMenuBorderView   *rightViewBorderView;

@property (strong, nonatomic) UIVisualEffectView *sideViewsCoverView;

@property (strong, nonatomic) NSNumber *leftViewGestireStartX;
@property (strong, nonatomic) NSNumber *rightViewGestireStartX;

@property (assign, nonatomic, getter=isLeftViewShowingBeforeGesture)  BOOL leftViewShowingBeforeGesture;
@property (assign, nonatomic, getter=isRightViewShowingBeforeGesture) BOOL rightViewShowingBeforeGesture;

@property (strong, nonatomic) LGSideMenuGesturesHandler *gesturesHandler;

@property (strong, nonatomic, readwrite) UITapGestureRecognizer *tapGesture;
@property (strong, nonatomic, readwrite) UIPanGestureRecognizer *panGesture;

@property (assign, nonatomic, getter=isNeedsUpdateLayoutsAndStyles) BOOL needsUpdateLayoutsAndStyles;

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
@property (assign, nonatomic, getter=isUserLeftViewInitialScale)                 BOOL userLeftViewInitialScale;
@property (assign, nonatomic, getter=isUserRightViewInitialScale)                BOOL userRightViewInitialScale;
@property (assign, nonatomic, getter=isUserLeftViewInitialOffsetX)               BOOL userLeftViewInitialOffsetX;
@property (assign, nonatomic, getter=isUserRightViewInitialOffsetX)              BOOL userRightViewInitialOffsetX;
@property (assign, nonatomic, getter=isUserLeftViewBackgroundImageInitialScale)  BOOL userLeftViewBackgroundImageInitialScale;
@property (assign, nonatomic, getter=isUserRightViewBackgroundImageInitialScale) BOOL userRightViewBackgroundImageInitialScale;
@property (assign, nonatomic, getter=isUserLeftViewBackgroundImageFinalScale)    BOOL userLeftViewBackgroundImageFinalScale;
@property (assign, nonatomic, getter=isUserRightViewBackgroundImageFinalScale)   BOOL userRightViewBackgroundImageFinalScale;

@property (assign, nonatomic, getter=isRootViewControllerAdded)  BOOL rootViewControllerAdded;
@property (assign, nonatomic, getter=isLeftViewControllerAdded)  BOOL leftViewControllerAdded;
@property (assign, nonatomic, getter=isRightViewControllerAdded) BOOL rightViewControllerAdded;

@end

#pragma mark - Implementation

@implementation LGSideMenuController

@synthesize
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
leftViewInitialScale = _leftViewInitialScale,
rightViewInitialScale = _rightViewInitialScale,
leftViewInitialOffsetX = _leftViewInitialOffsetX,
rightViewInitialOffsetX = _rightViewInitialOffsetX,
leftViewBackgroundImageInitialScale = _leftViewBackgroundImageInitialScale,
rightViewBackgroundImageInitialScale = _rightViewBackgroundImageInitialScale,
leftViewBackgroundImageFinalScale = _leftViewBackgroundImageFinalScale,
rightViewBackgroundImageFinalScale = _rightViewBackgroundImageFinalScale;

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

- (void)viewDidLoad {
    [super viewDidLoad];

    // Try to initialize left and right view controllers from storyboard by segues
    if (self.storyboard) {
        @try {
            [self performSegueWithIdentifier:LGSideMenuSegueRootIdentifier sender:nil];
        }
        @catch (NSException *exception) {
            NSLog(@"LGSideMenuController Exception: %@", exception);
        }

        @try {
            [self performSegueWithIdentifier:LGSideMenuSegueLeftIdentifier sender:nil];
        }
        @catch (NSException *exception) {
            NSLog(@"LGSideMenuController Exception: %@", exception);
        }

        @try {
            [self performSegueWithIdentifier:LGSideMenuSegueRightIdentifier sender:nil];
        }
        @catch (NSException *exception) {
            NSLog(@"LGSideMenuController Exception: %@", exception);
        }
    }
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
    CGFloat sideMenuWidth = 320.0;

    if (LGSideMenuHelper.isPhone) {
        CGFloat minSide = MIN(CGRectGetWidth(UIScreen.mainScreen.bounds), CGRectGetHeight(UIScreen.mainScreen.bounds));
        sideMenuWidth = minSide - 44.0;
    }

    // Needed to be initialized before default properties (setupDefaults)
    self.gesturesHandler = [[LGSideMenuGesturesHandler alloc] initWithSideMenuController:self];

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

    self.leftViewAnimationDuration = 0.5;
    self.rightViewAnimationDuration = 0.5;

    self.shouldHideLeftViewAnimated = YES;
    self.shouldHideRightViewAnimated = YES;

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

    self.needsUpdateLayoutsAndStyles = NO;
}

#pragma mark - Layouting

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];

    CGSize size = self.view.bounds.size;

    if (self.isNeedsUpdateLayoutsAndStyles || !CGSizeEqualToSize(self.savedSize, size)) {
        BOOL appeared = !CGSizeEqualToSize(self.savedSize, CGSizeZero);

        self.savedSize = size;
        self.needsUpdateLayoutsAndStyles = NO;

        // If side view is always visible and after rotating it should hide, we need to wait until rotation is finished
        [self updateLayoutsAndStylesWithDelay:(appeared ? LGSideMenuRotationDuration : 0.0)];
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

    if (self.state == LGSideMenuStateLeftViewWillShow) {
        [self showLeftViewDoneWithGesture:(self.leftViewGestireStartX != nil)];
    }
    else if (self.state == LGSideMenuStateLeftViewWillHide) {
        [self hideLeftViewDoneWithGesture:(self.leftViewGestireStartX != nil)];
    }

    if (self.state == LGSideMenuStateRightViewWillShow) {
        [self showRightViewDoneWithGesture:(self.rightViewGestireStartX != nil)];
    }
    else if (self.state == LGSideMenuStateRightViewWillHide) {
        [self hideRightViewDoneWithGesture:(self.rightViewGestireStartX != nil)];
    }
}

#pragma mark - Status bar

- (BOOL)prefersStatusBarHidden {
    if (self.rootView && (self.state == LGSideMenuStateRootViewIsShowing || self.state == LGSideMenuStateLeftViewWillHide || self.state == LGSideMenuStateRightViewWillHide)) {
        return self.rootViewStatusBarHidden;
    }
    else if (self.leftView && self.isLeftViewVisible && !self.isLeftViewAlwaysVisibleForCurrentOrientation) {
        return self.leftViewStatusBarHidden;
    }
    else if (self.rightView && self.isRightViewVisible && !self.isRightViewAlwaysVisibleForCurrentOrientation) {
        return self.rightViewStatusBarHidden;
    }

    return super.prefersStatusBarHidden;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    if (self.rootView && (self.state == LGSideMenuStateRootViewIsShowing || self.state == LGSideMenuStateLeftViewWillHide || self.state == LGSideMenuStateRightViewWillHide)) {
        return self.rootViewStatusBarStyle;
    }
    else if (self.leftView && self.isLeftViewVisible && !self.isLeftViewAlwaysVisibleForCurrentOrientation) {
        return self.leftViewStatusBarStyle;
    }
    else if (self.rightView && self.isRightViewVisible && !self.isRightViewAlwaysVisibleForCurrentOrientation) {
        return self.rightViewStatusBarStyle;
    }

    return super.preferredStatusBarStyle;
}

- (UIStatusBarAnimation)preferredStatusBarUpdateAnimation {
    if (self.rootView && (self.state == LGSideMenuStateRootViewIsShowing || self.state == LGSideMenuStateLeftViewWillHide || self.state == LGSideMenuStateRightViewWillHide)) {
        return self.rootViewStatusBarUpdateAnimation;
    }
    else if (self.leftView && self.isLeftViewVisible && !self.isLeftViewAlwaysVisibleForCurrentOrientation) {
        return self.leftViewStatusBarUpdateAnimation;
    }
    else if (self.rightView && self.isRightViewVisible && !self.isRightViewAlwaysVisibleForCurrentOrientation) {
        return self.rightViewStatusBarUpdateAnimation;
    }

    return super.preferredStatusBarUpdateAnimation;
}

#pragma mark - Update styles and layouts

- (void)setNeedsUpdateLayoutsAndStyles {
    self.needsUpdateLayoutsAndStyles = YES;

    if (self.isViewLoaded) {
        [self.view setNeedsLayout];
    }
}

- (void)updateLayoutsAndStyles {
    [self updateLayoutsAndStylesWithDelay:0.0];
}

- (void)updateLayoutsAndStylesWithDelay:(NSTimeInterval)delay {
    [self rootViewsValidate];
    [self leftViewsValidate];
    [self rightViewsValidate];

    [self viewsHierarchyValidate];

    [self rootViewsFramesValidate];
    [self leftViewsFramesValidate];
    [self rightViewsFramesValidate];

    [self stylesValidate];

    [self rootViewsTransformValidate];
    [self leftViewsTransformValidate];
    [self rightViewsTransformValidate];

    [self visibilityValidateWithDelay:delay];
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

- (void)setLeftViewInitialScale:(CGFloat)leftViewInitialScale {
    _leftViewInitialScale = leftViewInitialScale;
    self.userLeftViewInitialScale = YES;
}

- (CGFloat)leftViewInitialScale {
    if (self.isUserLeftViewInitialScale) {
        return _leftViewInitialScale;
    }

    if (self.leftViewPresentationStyle == LGSideMenuPresentationStyleScaleFromLittle) {
        return 0.8;
    }

    if (self.leftViewPresentationStyle == LGSideMenuPresentationStyleScaleFromBig) {
        return 1.2;
    }

    return 1.0;
}

- (void)setRightViewInitialScale:(CGFloat)rightViewInitialScale {
    _rightViewInitialScale = rightViewInitialScale;
    self.userRightViewInitialScale = YES;
}

- (CGFloat)rightViewInitialScale {
    if (self.isUserRightViewInitialScale) {
        return _rightViewInitialScale;
    }

    if (self.rightViewPresentationStyle == LGSideMenuPresentationStyleScaleFromLittle) {
        return 0.8;
    }

    if (self.rightViewPresentationStyle == LGSideMenuPresentationStyleScaleFromBig) {
        return 1.2;
    }

    return 1.0;
}

- (void)setLeftViewInitialOffsetX:(CGFloat)leftViewInitialOffsetX {
    _leftViewInitialOffsetX = leftViewInitialOffsetX;
    self.userLeftViewInitialOffsetX = YES;
}

- (CGFloat)leftViewInitialOffsetX {
    if (self.isUserLeftViewInitialOffsetX) {
        return _leftViewInitialOffsetX;
    }

    if (self.leftViewPresentationStyle == LGSideMenuPresentationStyleSlideBelow) {
        self.leftViewInitialOffsetX = -self.leftViewWidth/2;
    }

    return 0.0;
}

- (void)setRightViewInitialOffsetX:(CGFloat)rightViewInitialOffsetX {
    _rightViewInitialOffsetX = rightViewInitialOffsetX;
    self.userRightViewInitialOffsetX = YES;
}

- (CGFloat)rightViewInitialOffsetX {
    if (self.isUserRightViewInitialOffsetX) {
        return _rightViewInitialOffsetX;
    }

    if (self.rightViewPresentationStyle == LGSideMenuPresentationStyleSlideBelow) {
        self.rightViewInitialOffsetX = self.rightViewWidth/2;
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

    if (self.leftViewPresentationStyle == LGSideMenuPresentationStyleScaleFromBig) {
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

    if (self.rightViewPresentationStyle == LGSideMenuPresentationStyleScaleFromBig) {
        return 1.4;
    }

    return 1.0;
}

- (void)setLeftViewBackgroundImageFinalScale:(CGFloat)leftViewBackgroundImageFinalScale {
    _leftViewBackgroundImageFinalScale = leftViewBackgroundImageFinalScale;
    self.userLeftViewBackgroundImageFinalScale = YES;
}

- (CGFloat)leftViewBackgroundImageFinalScale {
    if (self.isUserLeftViewBackgroundImageFinalScale) {
        return _leftViewBackgroundImageFinalScale;
    }

    if (self.leftViewPresentationStyle == LGSideMenuPresentationStyleScaleFromLittle) {
        return 1.4;
    }

    return 1.0;
}

- (void)setRightViewBackgroundImageFinalScale:(CGFloat)rightViewBackgroundImageFinalScale {
    _rightViewBackgroundImageFinalScale = rightViewBackgroundImageFinalScale;
    self.userRightViewBackgroundImageFinalScale = YES;
}

- (CGFloat)rightViewBackgroundImageFinalScale {
    if (self.isUserRightViewBackgroundImageFinalScale) {
        return _rightViewBackgroundImageFinalScale;
    }

    if (self.rightViewPresentationStyle == LGSideMenuPresentationStyleScaleFromLittle) {
        return 1.4;
    }

    return 1.0;
}

#pragma mark -

- (void)setLeftViewPresentationStyle:(LGSideMenuPresentationStyle)leftViewPresentationStyle {
    if (_leftViewPresentationStyle == leftViewPresentationStyle) return;

    _leftViewPresentationStyle = leftViewPresentationStyle;

    [self validateAlwaysVisibleConflict];
    [self setNeedsUpdateLayoutsAndStyles];
}

- (void)setRightViewPresentationStyle:(LGSideMenuPresentationStyle)rightViewPresentationStyle {
    if (_rightViewPresentationStyle == rightViewPresentationStyle) return;

    _rightViewPresentationStyle = rightViewPresentationStyle;

    [self validateAlwaysVisibleConflict];
    [self setNeedsUpdateLayoutsAndStyles];
}

- (void)setLeftViewBackgroundColor:(UIColor *)leftViewBackgroundColor {
    if (_leftViewBackgroundColor == leftViewBackgroundColor) return;

    _leftViewBackgroundColor = leftViewBackgroundColor;

    [self setNeedsUpdateLayoutsAndStyles];
}

- (void)setRightViewBackgroundColor:(UIColor *)rightViewBackgroundColor {
    if (_rightViewBackgroundColor == rightViewBackgroundColor) return;

    _rightViewBackgroundColor = rightViewBackgroundColor;

    [self setNeedsUpdateLayoutsAndStyles];
}

- (void)setLeftViewBackgroundImage:(UIImage *)leftViewBackgroundImage {
    if (_leftViewBackgroundImage == leftViewBackgroundImage) return;

    _leftViewBackgroundImage = leftViewBackgroundImage;

    [self setNeedsUpdateLayoutsAndStyles];
}

- (void)setRightViewBackgroundImage:(UIImage *)rightViewBackgroundImage {
    if (_rightViewBackgroundImage == rightViewBackgroundImage) return;

    _rightViewBackgroundImage = rightViewBackgroundImage;

    [self setNeedsUpdateLayoutsAndStyles];
}

- (void)setLeftViewAlwaysVisibleOptions:(LGSideMenuAlwaysVisibleOptions)leftViewAlwaysVisibleOptions {
    if (_leftViewAlwaysVisibleOptions == leftViewAlwaysVisibleOptions) return;

    _leftViewAlwaysVisibleOptions = leftViewAlwaysVisibleOptions;

    [self validateAlwaysVisibleConflict];
    [self setNeedsUpdateLayoutsAndStyles];
}

- (void)setRightViewAlwaysVisibleOptions:(LGSideMenuAlwaysVisibleOptions)rightViewAlwaysVisibleOptions {
    if (_rightViewAlwaysVisibleOptions == rightViewAlwaysVisibleOptions) return;

    _rightViewAlwaysVisibleOptions = rightViewAlwaysVisibleOptions;

    [self validateAlwaysVisibleConflict];
    [self setNeedsUpdateLayoutsAndStyles];
}

- (void)setLeftViewWidth:(CGFloat)leftViewWidth {
    if (_leftViewWidth == leftViewWidth) return;

    _leftViewWidth = leftViewWidth;

    [self setNeedsUpdateLayoutsAndStyles];
}

- (void)setRightViewWidth:(CGFloat)rightViewWidth {
    if (_rightViewWidth == rightViewWidth) return;

    _rightViewWidth = rightViewWidth;

    [self setNeedsUpdateLayoutsAndStyles];
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
    return self.state == LGSideMenuStateLeftViewIsShowing || self.state == LGSideMenuStateLeftViewWillShow || self.state == LGSideMenuStateLeftViewWillHide;
}

- (BOOL)isRightViewVisible {
    return self.state == LGSideMenuStateRightViewIsShowing || self.state == LGSideMenuStateRightViewWillShow || self.state == LGSideMenuStateRightViewWillHide;
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

- (BOOL)isLeftViewShowing {
    return self.state == LGSideMenuStateLeftViewIsShowing;
}

- (BOOL)isRightViewShowing {
    return self.state == LGSideMenuStateRightViewIsShowing;
}

- (BOOL)isLeftViewHidden {
    return self.state != LGSideMenuStateLeftViewIsShowing;
}

- (BOOL)isRightViewHidden {
    return self.state != LGSideMenuStateRightViewIsShowing;
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
            (LGSideMenuHelper.isPhone &&
             ((self.leftViewAlwaysVisibleOptions & LGSideMenuAlwaysVisibleOnPhone) ||
              (UIInterfaceOrientationIsPortrait(orientation) && self.leftViewAlwaysVisibleOptions & LGSideMenuAlwaysVisibleOnPhonePortrait) ||
              (UIInterfaceOrientationIsLandscape(orientation) && self.leftViewAlwaysVisibleOptions & LGSideMenuAlwaysVisibleOnPhoneLandscape))) ||
            (LGSideMenuHelper.isPad &&
             ((self.leftViewAlwaysVisibleOptions & LGSideMenuAlwaysVisibleOnPad) ||
              (UIInterfaceOrientationIsPortrait(orientation) && self.leftViewAlwaysVisibleOptions & LGSideMenuAlwaysVisibleOnPadPortrait) ||
              (UIInterfaceOrientationIsLandscape(orientation) && self.leftViewAlwaysVisibleOptions & LGSideMenuAlwaysVisibleOnPadLandscape))));
}

- (BOOL)isRightViewAlwaysVisibleForOrientation:(UIInterfaceOrientation)orientation {
    return ((self.rightViewAlwaysVisibleOptions & LGSideMenuAlwaysVisibleOnAll) ||
            (UIInterfaceOrientationIsPortrait(orientation) && self.rightViewAlwaysVisibleOptions & LGSideMenuAlwaysVisibleOnPortrait) ||
            (UIInterfaceOrientationIsLandscape(orientation) && self.rightViewAlwaysVisibleOptions & LGSideMenuAlwaysVisibleOnLandscape) ||
            (LGSideMenuHelper.isPhone &&
             ((self.rightViewAlwaysVisibleOptions & LGSideMenuAlwaysVisibleOnPhone) ||
              (UIInterfaceOrientationIsPortrait(orientation) && self.rightViewAlwaysVisibleOptions & LGSideMenuAlwaysVisibleOnPhonePortrait) ||
              (UIInterfaceOrientationIsLandscape(orientation) && self.rightViewAlwaysVisibleOptions & LGSideMenuAlwaysVisibleOnPhoneLandscape))) ||
            (LGSideMenuHelper.isPad &&
             ((self.rightViewAlwaysVisibleOptions & LGSideMenuAlwaysVisibleOnPad) ||
              (UIInterfaceOrientationIsPortrait(orientation) && self.rightViewAlwaysVisibleOptions & LGSideMenuAlwaysVisibleOnPadPortrait) ||
              (UIInterfaceOrientationIsLandscape(orientation) && self.rightViewAlwaysVisibleOptions & LGSideMenuAlwaysVisibleOnPadLandscape))));
}

#pragma mark - Delegate

- (void)setDelegate:(id<LGSideMenuDelegate>)delegate {
    _delegate = delegate;

    if (!delegate) return;

    if ([delegate respondsToSelector:@selector(showAnimationsBlockForLeftView:sideMenuController:duration:)]) {
        NSLog(@"WARNING: delegate method \"showAnimationsBlockForLeftView:sideMenuController:duration:\" is DEPRECATED, use \"showAnimationsForLeftView:sideMenuController:duration:\" instead");
    }

    if ([delegate respondsToSelector:@selector(hideAnimationsBlockForLeftView:sideMenuController:duration:)]) {
        NSLog(@"WARNING: delegate method \"hideAnimationsBlockForLeftView:sideMenuController:duration:\" is DEPRECATED, use \"hideAnimationsForLeftView:sideMenuController:duration:\" instead");
    }

    if ([delegate respondsToSelector:@selector(showAnimationsBlockForRightView:sideMenuController:duration:)]) {
        NSLog(@"WARNING: delegate method \"showAnimationsBlockForRightView:sideMenuController:duration:\" is DEPRECATED, use \"showAnimationsForRightView:sideMenuController:duration:\" instead");
    }

    if ([delegate respondsToSelector:@selector(hideAnimationsBlockForRightView:sideMenuController:duration:)]) {
        NSLog(@"WARNING: delegate method \"hideAnimationsBlockForRightView:sideMenuController:duration:\" is DEPRECATED, use \"hideAnimationsForRightView:sideMenuController:duration:\" instead");
    }
}

#pragma mark - ViewControllers

- (void)setRootViewController:(UIViewController *)rootViewController {
    if (self.rootViewController == rootViewController) return;

    [self removeRootViews];

    if (!rootViewController) return;

    _rootViewController = rootViewController;
    _rootView = rootViewController.view;

    // Needed because when any of side menus is showing, rootViewController is removed from it's parentViewController
    objc_setAssociatedObject(rootViewController, @"sideMenuController", self, OBJC_ASSOCIATION_ASSIGN);

    [self rootViewsValidate];
    [self viewsHierarchyValidate];
    [self rootViewsFramesValidate];
    [self stylesValidate];
    [self rootViewsTransformValidate];
    [self visibilityValidate];
}

- (void)setLeftViewController:(UIViewController *)leftViewController {
    if (self.leftViewController == leftViewController) return;

    [self removeLeftViews];

    if (!leftViewController) return;

    _leftViewController = leftViewController;
    _leftView = leftViewController.view;

    [self leftViewsValidate];
    [self viewsHierarchyValidate];
    [self leftViewsFramesValidate];
    [self stylesValidate];
    [self leftViewsTransformValidate];
    [self visibilityValidate];
}

- (void)setRightViewController:(UIViewController *)rightViewController {
    if (self.rightViewController == rightViewController) return;

    [self removeRightViews];

    if (!rightViewController) return;

    _rightViewController = rightViewController;
    _rightView = rightViewController.view;

    [self rightViewsValidate];
    [self viewsHierarchyValidate];
    [self rightViewsFramesValidate];
    [self stylesValidate];
    [self rightViewsTransformValidate];
    [self visibilityValidate];
}

#pragma mark - Views

- (void)setRootView:(UIView *)rootView {
    if (self.rootView == rootView) return;

    [self removeRootViews];

    if (!rootView) return;

    _rootView = rootView;

    [self setNeedsUpdateLayoutsAndStyles];
}

- (void)setLeftView:(LGSideMenuView *)leftView {
    if (self.leftView == leftView) return;

    [self removeLeftViews];

    if (!leftView) return;

    _leftView = leftView;

    [self setNeedsUpdateLayoutsAndStyles];
}

- (void)setRightView:(LGSideMenuView *)rightView {
    if (self.rightView == rightView) return;

    [self removeRightViews];

    if (!rightView) return;

    _rightView = rightView;

    [self setNeedsUpdateLayoutsAndStyles];
}

#pragma mark - Remove views

- (void)removeRootViews {
    if (self.rootViewController) {
        [self.rootViewController.view removeFromSuperview];
        [self.rootViewController removeFromParentViewController];
        self.rootViewControllerAdded = NO;
        _rootViewController = nil;

        objc_setAssociatedObject(_rootViewController, @"sideMenuController", nil, OBJC_ASSOCIATION_ASSIGN);
    }

    if (self.rootView) {
        [self.rootView removeFromSuperview];
        _rootView = nil;
    }

    if (self.rootViewContainer) {
        [self.rootViewContainer removeFromSuperview];
        _rootViewContainer = nil;
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
        self.leftViewControllerAdded = NO;
        _leftViewController = nil;
    }

    if (self.leftView) {
        [self.leftView removeFromSuperview];
        _leftView = nil;
    }

    if (self.leftViewContainer) {
        [self.leftViewContainer removeFromSuperview];
        _leftViewContainer = nil;
    }

    if (self.leftViewBorderView) {
        [self.leftViewBorderView removeFromSuperview];
        _leftViewBorderView = nil;
    }

    if (self.leftViewStyleView) {
        [self.leftViewStyleView removeFromSuperview];
        _leftViewStyleView = nil;
    }

    if (self.sideViewsCoverView && !self.rightView) {
        [self.sideViewsCoverView removeFromSuperview];
        _sideViewsCoverView = nil;
    }

    if (self.leftViewBackgroundView) {
        [self.leftViewBackgroundView removeFromSuperview];
        _leftViewBackgroundView = nil;
    }
}

- (void)removeRightViews {
    if (self.rightViewController) {
        [self.rightViewController.view removeFromSuperview];
        [self.rightViewController removeFromParentViewController];
        self.rightViewControllerAdded = NO;
        _rightViewController = nil;
    }

    if (self.rightView) {
        [self.rightView removeFromSuperview];
        _rightView = nil;
    }

    if (self.rightViewContainer) {
        [self.rightViewContainer removeFromSuperview];
        _rightViewContainer = nil;
    }

    if (self.rightViewBorderView) {
        [self.rightViewBorderView removeFromSuperview];
        _rightViewBorderView = nil;
    }

    if (self.rightViewStyleView) {
        [self.rightViewStyleView removeFromSuperview];
        _rightViewStyleView = nil;
    }

    if (self.sideViewsCoverView && !self.leftView) {
        [self.sideViewsCoverView removeFromSuperview];
        _sideViewsCoverView = nil;
    }

    if (self.rightViewBackgroundView) {
        [self.rightViewBackgroundView removeFromSuperview];
        _rightViewBackgroundView = nil;
    }
}

#pragma mark - Validators

- (void)validateAlwaysVisibleConflict {
    if (self.leftViewAlwaysVisibleOptions == LGSideMenuAlwaysVisibleOnNone && self.rightViewAlwaysVisibleOptions == LGSideMenuAlwaysVisibleOnNone) {
        return;
    }

    if (self.leftView) {
        NSAssert(self.leftViewPresentationStyle == LGSideMenuPresentationStyleSlideAbove || self.leftViewPresentationStyle == LGSideMenuPresentationStyleSlideBelow,
                 @".AlwaysVisibleOptions can be used only with .SlideAbove or .SlideBelow presentation styles");
    }

    if (self.rightView) {
        NSAssert(self.rightViewPresentationStyle == LGSideMenuPresentationStyleSlideAbove || self.rightViewPresentationStyle == LGSideMenuPresentationStyleSlideBelow,
                 @".AlwaysVisibleOptions can be used only with .SlideAbove or .SlideBelow presentation styles");
    }
}

- (void)rootViewsValidate {
    if (!self.rootView) return;

    // -----

    if (self.rootViewController && self.state == LGSideMenuStateRootViewIsShowing) {
        if (!self.isRootViewControllerAdded) {
            [self addChildViewController:self.rootViewController];
            self.rootViewControllerAdded = YES;
        }
    }
    else {
        if (self.isRootViewControllerAdded) {
            [self.rootViewController removeFromParentViewController];
            self.rootViewControllerAdded = NO;
        }
    }

    // -----

    if ((self.leftView && self.leftViewPresentationStyle != LGSideMenuPresentationStyleSlideAbove) ||
        (self.rightView && self.rightViewPresentationStyle != LGSideMenuPresentationStyleSlideAbove)) {
        if (!self.rootViewStyleView) {
            self.rootViewStyleView = [LGSideMenuBorderView new];
            [self.view addSubview:self.rootViewStyleView];
        }
    }
    else {
        if (self.rootViewStyleView) {
            [self.rootViewStyleView removeFromSuperview];
            self.rootViewStyleView = nil;
        }
    }

    // -----

    if (!self.rootViewContainer) {
        __weak typeof(self) wself = self;

        self.rootViewContainer = [[LGSideMenuView alloc] initWithLayoutSubviewsHandler:^(void) {
            if (!wself) return;

            __strong typeof(wself) sself = wself;

            [sself rootViewWillLayoutSubviewsWithSize:sself.rootViewContainer.bounds.size];
        }];
        self.rootViewContainer.clipsToBounds = YES;
        [self.rootViewContainer addSubview:self.rootView];
    }

    // -----

    if (!self.rootViewCoverView) {
        self.rootViewCoverView = [UIVisualEffectView new];
        self.rootViewCoverView.clipsToBounds = YES;
        [self.view addSubview:self.rootViewCoverView];
    }
}

- (void)leftViewsValidate {
    if (!self.leftView) return;

    // -----

    if (self.leftViewController && self.state == LGSideMenuStateLeftViewIsShowing) {
        if (!self.isLeftViewControllerAdded) {
            [self addChildViewController:self.leftViewController];
            self.leftViewControllerAdded = YES;
        }
    }
    else {
        if (self.isLeftViewControllerAdded) {
            [self.leftViewController removeFromParentViewController];
            self.leftViewControllerAdded = NO;
        }
    }

    // -----

    if (self.leftViewPresentationStyle != LGSideMenuPresentationStyleSlideAbove) {
        if (!self.leftViewBackgroundView) {
            self.leftViewBackgroundView = [UIImageView new];
            self.leftViewBackgroundView.contentMode = UIViewContentModeScaleAspectFill;
            self.leftViewBackgroundView.clipsToBounds = YES;
            self.leftViewBackgroundView.userInteractionEnabled = NO;
            [self.view addSubview:self.leftViewBackgroundView];
        }
    }
    else {
        if (self.leftViewBackgroundView) {
            [self.leftViewBackgroundView removeFromSuperview];
            self.leftViewBackgroundView = nil;
        }
    }

    // -----

    if (self.leftViewPresentationStyle == LGSideMenuPresentationStyleSlideAbove) {
        if (!self.leftViewStyleView) {
            self.leftViewStyleView = [UIVisualEffectView new];
            self.leftViewStyleView.userInteractionEnabled = NO;
            self.leftViewStyleView.contentView.clipsToBounds = NO;
            self.leftViewStyleView.layer.anchorPoint = CGPointMake(0.0, 0.5);
            [self.view addSubview:self.leftViewStyleView];

            self.leftViewBorderView = [LGSideMenuBorderView new];
            [self.leftViewStyleView.contentView addSubview:self.leftViewBorderView];
        }
    }
    else {
        if (self.leftViewBorderView) {
            [self.leftViewBorderView removeFromSuperview];
            self.leftViewBorderView = nil;
        }

        if (self.leftViewStyleView) {
            [self.leftViewStyleView removeFromSuperview];
            self.leftViewStyleView = nil;
        }
    }

    // -----

    if (!self.leftViewContainer) {
        __weak typeof(self) wself = self;

        self.leftViewContainer = [[LGSideMenuView alloc] initWithLayoutSubviewsHandler:^(void) {
            if (!wself) return;

            __strong typeof(wself) sself = wself;

            [sself leftViewWillLayoutSubviewsWithSize:sself.leftViewContainer.bounds.size];
        }];
        self.leftViewContainer.layer.anchorPoint = CGPointMake(0.0, 0.5);

        [self.leftViewContainer addSubview:self.leftView];
    }

    // -----

    if (self.leftViewPresentationStyle != LGSideMenuPresentationStyleSlideAbove) {
        if (!self.sideViewsCoverView) {
            self.sideViewsCoverView = [UIVisualEffectView new];
            self.sideViewsCoverView.userInteractionEnabled = NO;
            [self.view addSubview:self.sideViewsCoverView];
        }
    }
    else if (self.rightViewPresentationStyle == LGSideMenuPresentationStyleSlideAbove) {
        if (self.sideViewsCoverView) {
            [self.sideViewsCoverView removeFromSuperview];
            self.sideViewsCoverView = nil;
        }
    }
}

- (void)rightViewsValidate {
    if (!self.rightView) return;

    // -----

    if (self.rightViewController && self.state == LGSideMenuStateRightViewIsShowing) {
        if (!self.isRightViewControllerAdded) {
            [self addChildViewController:self.rightViewController];
            self.rightViewControllerAdded = YES;
        }
    }
    else {
        if (self.isRightViewControllerAdded) {
            [self.rightViewController removeFromParentViewController];
            self.rightViewControllerAdded = NO;
        }
    }

    // -----

    if (self.rightViewPresentationStyle != LGSideMenuPresentationStyleSlideAbove) {
        if (!self.rightViewBackgroundView) {
            self.rightViewBackgroundView = [UIImageView new];
            self.rightViewBackgroundView.contentMode = UIViewContentModeScaleAspectFill;
            self.rightViewBackgroundView.clipsToBounds = YES;
            self.rightViewBackgroundView.userInteractionEnabled = NO;
            [self.view addSubview:self.rightViewBackgroundView];
        }
    }
    else {
        if (self.rightViewBackgroundView) {
            [self.rightViewBackgroundView removeFromSuperview];
            self.rightViewBackgroundView = nil;
        }
    }

    // -----

    if (self.rightViewPresentationStyle == LGSideMenuPresentationStyleSlideAbove) {
        if (!self.rightViewStyleView) {
            self.rightViewStyleView = [UIVisualEffectView new];
            self.rightViewStyleView.userInteractionEnabled = NO;
            self.rightViewStyleView.contentView.clipsToBounds = NO;
            self.rightViewStyleView.layer.anchorPoint = CGPointMake(1.0, 0.5);
            [self.view addSubview:self.rightViewStyleView];

            self.rightViewBorderView = [LGSideMenuBorderView new];
            [self.rightViewStyleView.contentView addSubview:self.rightViewBorderView];
        }
    }
    else {
        if (self.rightViewBorderView) {
            [self.rightViewBorderView removeFromSuperview];
            self.rightViewBorderView = nil;
        }

        if (self.rightViewStyleView) {
            [self.rightViewStyleView removeFromSuperview];
            self.rightViewStyleView = nil;
        }
    }

    // -----

    if (!self.rightViewContainer) {
        __weak typeof(self) wself = self;

        self.rightViewContainer = [[LGSideMenuView alloc] initWithLayoutSubviewsHandler:^(void) {
            if (!wself) return;

            __strong typeof(wself) sself = wself;

            [sself rightViewWillLayoutSubviewsWithSize:sself.rightViewContainer.bounds.size];
        }];
        self.rightViewContainer.layer.anchorPoint = CGPointMake(1.0, 0.5);

        [self.rightViewContainer addSubview:self.rightView];
    }

    // -----

    if (self.rightViewPresentationStyle != LGSideMenuPresentationStyleSlideAbove) {
        if (!self.sideViewsCoverView) {
            self.sideViewsCoverView = [UIVisualEffectView new];
            self.sideViewsCoverView.userInteractionEnabled = NO;
            [self.view addSubview:self.sideViewsCoverView];
        }
    }
    else if (self.leftViewPresentationStyle == LGSideMenuPresentationStyleSlideAbove) {
        if (self.sideViewsCoverView) {
            [self.sideViewsCoverView removeFromSuperview];
            self.sideViewsCoverView = nil;
        }
    }
}

- (void)viewsHierarchyValidate {
    BOOL isSideViewAdded = false;
    NSUInteger currentIndex = 0;

    if (self.leftViewPresentationStyle != LGSideMenuPresentationStyleSlideAbove) {
        if (self.leftViewBackgroundView) {
            [self.view insertSubview:self.leftViewBackgroundView atIndex:currentIndex];
            currentIndex++;
        }

        if (self.leftViewStyleView) {
            [self.view insertSubview:self.leftViewStyleView atIndex:currentIndex];
            currentIndex++;
        }

        if (self.leftViewContainer) {
            [self.view insertSubview:self.leftViewContainer atIndex:currentIndex];
            currentIndex++;
        }

        isSideViewAdded = YES;
    }

    if (self.rightViewPresentationStyle != LGSideMenuPresentationStyleSlideAbove) {
        if (self.rightViewBackgroundView) {
            [self.view insertSubview:self.rightViewBackgroundView atIndex:currentIndex];
            currentIndex++;
        }

        if (self.rightViewStyleView) {
            [self.view insertSubview:self.rightViewStyleView atIndex:currentIndex];
            currentIndex++;
        }

        if (self.rightViewContainer) {
            [self.view insertSubview:self.rightViewContainer atIndex:currentIndex];
            currentIndex++;
        }

        isSideViewAdded = YES;
    }

    if (isSideViewAdded) {
        if (self.sideViewsCoverView) {
            [self.view insertSubview:self.sideViewsCoverView atIndex:currentIndex];
            currentIndex++;
        }
    }

    if (self.rootViewStyleView) {
        [self.view insertSubview:self.rootViewStyleView atIndex:currentIndex];
        currentIndex++;
    }

    if (self.rootViewContainer) {
        [self.view insertSubview:self.rootViewContainer atIndex:currentIndex];
        currentIndex++;
    }

    if (self.rootViewCoverView) {
        [self.view insertSubview:self.rootViewCoverView atIndex:currentIndex];
        currentIndex++;
    }

    if (self.leftViewPresentationStyle == LGSideMenuPresentationStyleSlideAbove) {
        if (self.leftViewStyleView) {
            [self.view insertSubview:self.leftViewStyleView atIndex:currentIndex];
            currentIndex++;
        }

        if (self.leftViewContainer) {
            [self.view insertSubview:self.leftViewContainer atIndex:currentIndex];
            currentIndex++;
        }
    }

    if (self.rightViewPresentationStyle == LGSideMenuPresentationStyleSlideAbove) {
        if (self.rightViewStyleView) {
            [self.view insertSubview:self.rightViewStyleView atIndex:currentIndex];
            currentIndex++;
        }

        if (self.rightViewContainer) {
            [self.view insertSubview:self.rightViewContainer atIndex:currentIndex];
            currentIndex++;
        }
    }
}

- (void)rootViewsFramesValidate {
    if (!self.rootView) return;

    // -----

    CGFloat frameWidth = CGRectGetWidth(self.view.bounds);
    CGFloat frameHeight = CGRectGetHeight(self.view.bounds);

    CGRect rootViewFrame = CGRectMake(0.0, 0.0, frameWidth, frameHeight);

    CGFloat offset = self.rootViewLayerBorderWidth + self.rootViewLayerShadowRadius;
    CGRect rootViewStyleViewFrame = CGRectMake(-offset, -offset, frameWidth + (offset * 2.0), frameHeight + (offset * 2.0));

    if (self.leftView && self.isLeftViewAlwaysVisibleForCurrentOrientation) {
        rootViewFrame.origin.x += self.leftViewWidth;
        rootViewFrame.size.width -= self.leftViewWidth;

        rootViewStyleViewFrame.origin.x += self.leftViewWidth;
        rootViewStyleViewFrame.size.width -= self.leftViewWidth;
    }

    if (self.rightView && self.isRightViewAlwaysVisibleForCurrentOrientation) {
        rootViewFrame.size.width -= self.rightViewWidth;

        rootViewStyleViewFrame.size.width -= self.rightViewWidth;
    }

    if (LGSideMenuHelper.isNotRetina) {
        rootViewFrame = CGRectIntegral(rootViewFrame);
        rootViewStyleViewFrame = CGRectIntegral(rootViewStyleViewFrame);
    }

    // -----

    self.rootViewStyleView.transform = CGAffineTransformIdentity;
    self.rootViewStyleView.frame = rootViewStyleViewFrame;

    self.rootViewContainer.transform = CGAffineTransformIdentity;
    self.rootViewContainer.frame = rootViewFrame;

    self.rootViewCoverView.transform = CGAffineTransformIdentity;
    self.rootViewCoverView.frame = rootViewFrame;
}

- (void)rootViewsTransformValidate {
    [self rootViewsTransformValidateWithPercentage:(self.isLeftViewShowing || self.isRightViewShowing ? 1.0 : 0.0)];
}

- (void)rootViewsTransformValidateWithPercentage:(CGFloat)percentage {
    if (!self.rootView) return;

    // -----

    if (self.leftView && self.isLeftViewVisible) {
        self.rootViewCoverView.alpha = self.rootViewCoverAlphaForLeftView * percentage;
    }
    else if (self.rightView && self.isRightViewVisible) {
        self.rootViewCoverView.alpha = self.rootViewCoverAlphaForRightView * percentage;
    }
    else {
        self.rootViewCoverView.alpha = percentage;
    }

    // -----

    if ((self.leftView && self.isLeftViewAlwaysVisibleForCurrentOrientation) ||
        (self.rightView && self.isRightViewAlwaysVisibleForCurrentOrientation)) {
        return;
    }

    // -----

    CGFloat frameX = 0.0;
    CGFloat frameWidth = CGRectGetWidth(self.view.bounds);
    CGFloat rootViewScale = 1.0;

    // -----

    if (self.leftView && self.isLeftViewVisible && self.leftViewPresentationStyle != LGSideMenuPresentationStyleSlideAbove) {
        rootViewScale = 1.0 + (self.rootViewScaleForLeftView - 1.0) * percentage;
        CGFloat shift = frameWidth * (1.0 - rootViewScale) / 2.0;
        frameX = (self.leftViewWidth - shift) * percentage;
    }
    else if (self.rightView && self.isRightViewVisible && self.rightViewPresentationStyle != LGSideMenuPresentationStyleSlideAbove) {
        rootViewScale = 1.0 + (self.rootViewScaleForRightView - 1.0) * percentage;
        CGFloat shift = frameWidth * (1.0 - rootViewScale) / 2.0;
        frameX = -(self.rightViewWidth - shift) * percentage;
    }

    CGAffineTransform transform = CGAffineTransformConcat(CGAffineTransformMakeScale(rootViewScale, rootViewScale),
                                                          CGAffineTransformMakeTranslation(frameX, 0.0));

    // -----

    self.rootViewContainer.transform = transform;
    self.rootViewStyleView.transform = transform;
    self.rootViewCoverView.transform = transform;
}

- (void)leftViewsFramesValidate {
    if (!self.leftView) return;

    CGFloat frameWidth = CGRectGetWidth(self.view.bounds);
    CGFloat frameHeight = CGRectGetHeight(self.view.bounds);

    // -----

    CGRect leftViewFrame = CGRectMake(0.0, 0.0, self.leftViewWidth, frameHeight);

    if (LGSideMenuHelper.isNotRetina) {
        leftViewFrame = CGRectIntegral(leftViewFrame);
    }

    self.leftViewContainer.transform = CGAffineTransformIdentity;
    self.leftViewContainer.frame = leftViewFrame;

    // -----

    if (self.sideViewsCoverView) {
        CGRect sideViewsCoverViewFrame = CGRectMake(0.0, 0.0, frameWidth, frameHeight);

        if (LGSideMenuHelper.isNotRetina) {
            sideViewsCoverViewFrame = CGRectIntegral(sideViewsCoverViewFrame);
        }

        self.sideViewsCoverView.transform = CGAffineTransformIdentity;
        self.sideViewsCoverView.frame = sideViewsCoverViewFrame;
    }

    // -----

    if (self.leftViewStyleView) {
        self.leftViewStyleView.transform = CGAffineTransformIdentity;
        self.leftViewStyleView.frame = leftViewFrame;

        CGFloat offset = self.leftViewLayerBorderWidth + self.leftViewLayerShadowRadius;
        CGRect leftViewBorderViewFrame = CGRectMake(-offset,
                                                    -offset,
                                                    CGRectGetWidth(leftViewFrame) + (offset * 2.0),
                                                    CGRectGetHeight(leftViewFrame) + (offset * 2.0));

        if (LGSideMenuHelper.isNotRetina) {
            leftViewBorderViewFrame = CGRectIntegral(leftViewBorderViewFrame);
        }

        self.leftViewBorderView.transform = CGAffineTransformIdentity;
        self.leftViewBorderView.frame = leftViewBorderViewFrame;
    }

    // -----

    if (self.leftViewBackgroundView) {
        CGRect backgroundViewFrame = CGRectMake(0.0, 0.0, frameWidth, frameHeight);

        if (self.isLeftViewAlwaysVisibleForCurrentOrientation && self.isRightViewAlwaysVisibleForCurrentOrientation) {
            CGFloat multiplier = self.rightViewWidth / self.leftViewWidth;
            backgroundViewFrame.size.width = frameWidth / (multiplier + 1.0);
        }

        if (LGSideMenuHelper.isNotRetina) {
            backgroundViewFrame = CGRectIntegral(backgroundViewFrame);
        }

        self.leftViewBackgroundView.transform = CGAffineTransformIdentity;
        self.leftViewBackgroundView.frame = backgroundViewFrame;
    }
}

- (void)leftViewsTransformValidate {
    [self leftViewsTransformValidateWithPercentage:(self.isLeftViewShowing ? 1.0 : 0.0)];
}

- (void)leftViewsTransformValidateWithPercentage:(CGFloat)percentage {
    if (!self.leftView) return;

    // -----

    if (self.sideViewsCoverView) {
        if (self.isLeftViewVisible && !self.isLeftViewAlwaysVisibleForCurrentOrientation && !self.isRightViewAlwaysVisibleForCurrentOrientation) {
            self.sideViewsCoverView.alpha = self.leftViewCoverAlpha - (self.leftViewCoverAlpha * percentage);
        }
    }

    // -----

    CGFloat frameX = 0.0;
    CGAffineTransform leftViewScaleTransform = CGAffineTransformIdentity;
    CGAffineTransform leftViewBackgroundViewTransform = CGAffineTransformIdentity;

    // -----

    if (!self.isLeftViewAlwaysVisibleForCurrentOrientation) {
        if (self.leftViewPresentationStyle == LGSideMenuPresentationStyleSlideAbove) {
            frameX = -(self.leftViewWidth + self.leftViewLayerBorderWidth + self.leftViewLayerShadowRadius) * (1.0 - percentage);
        }
        else {
            CGFloat leftViewScale = 1.0 + (self.leftViewInitialScale - 1.0) * (1.0 - percentage);
            CGFloat leftViewBackgroundViewScale = self.leftViewBackgroundImageFinalScale + ((self.leftViewBackgroundImageInitialScale - self.leftViewBackgroundImageFinalScale) * (1.0 - percentage));

            leftViewScaleTransform = CGAffineTransformMakeScale(leftViewScale, leftViewScale);
            leftViewBackgroundViewTransform = CGAffineTransformMakeScale(leftViewBackgroundViewScale, leftViewBackgroundViewScale);

            frameX = self.leftViewInitialOffsetX * (1.0 - percentage);
        }
    }

    CGAffineTransform leftViewTransform = CGAffineTransformConcat(leftViewScaleTransform,
                                                                  CGAffineTransformMakeTranslation(frameX, 0.0));

    // -----

    self.leftViewContainer.transform = leftViewTransform;
    self.leftViewBackgroundView.transform = leftViewBackgroundViewTransform;
    self.leftViewStyleView.transform = leftViewTransform;
}

- (void)rightViewsFramesValidate {
    if (!self.rightView) return;

    CGFloat frameWidth = CGRectGetWidth(self.view.bounds);
    CGFloat frameHeight = CGRectGetHeight(self.view.bounds);

    // -----

    CGRect rightViewFrame = CGRectMake(frameWidth - self.rightViewWidth, 0.0, self.rightViewWidth, frameHeight);

    if (LGSideMenuHelper.isNotRetina) {
        rightViewFrame = CGRectIntegral(rightViewFrame);
    }

    self.rightViewContainer.transform = CGAffineTransformIdentity;
    self.rightViewContainer.frame = rightViewFrame;

    // -----

    if (self.sideViewsCoverView) {
        CGRect sideViewsCoverViewFrame = CGRectMake(0.0, 0.0, frameWidth, frameHeight);

        if (LGSideMenuHelper.isNotRetina) {
            sideViewsCoverViewFrame = CGRectIntegral(sideViewsCoverViewFrame);
        }

        self.sideViewsCoverView.transform = CGAffineTransformIdentity;
        self.sideViewsCoverView.frame = sideViewsCoverViewFrame;
    }

    // -----

    if (self.rightViewStyleView) {
        self.rightViewStyleView.transform = CGAffineTransformIdentity;
        self.rightViewStyleView.frame = rightViewFrame;

        CGFloat offset = self.rightViewLayerBorderWidth + self.rightViewLayerShadowRadius;
        CGRect rightViewBorderViewFrame = CGRectMake(-offset,
                                                     -offset,
                                                     CGRectGetWidth(rightViewFrame) + (offset * 2.0),
                                                     CGRectGetHeight(rightViewFrame) + (offset * 2.0));

        if (LGSideMenuHelper.isNotRetina) {
            rightViewBorderViewFrame = CGRectIntegral(rightViewBorderViewFrame);
        }

        self.rightViewBorderView.transform = CGAffineTransformIdentity;
        self.rightViewBorderView.frame = rightViewBorderViewFrame;
    }

    // -----

    if (self.rightViewBackgroundView) {
        CGRect backgroundViewFrame = CGRectMake(0.0, 0.0, frameWidth, frameHeight);

        if (self.isLeftViewAlwaysVisibleForCurrentOrientation && self.isRightViewAlwaysVisibleForCurrentOrientation) {
            CGFloat multiplier = self.leftViewWidth / self.rightViewWidth;
            backgroundViewFrame.size.width = frameWidth / (multiplier + 1.0);
            backgroundViewFrame.origin.x = frameWidth - CGRectGetWidth(backgroundViewFrame);
        }

        if (LGSideMenuHelper.isNotRetina) {
            backgroundViewFrame = CGRectIntegral(backgroundViewFrame);
        }

        self.rightViewBackgroundView.transform = CGAffineTransformIdentity;
        self.rightViewBackgroundView.frame = backgroundViewFrame;
    }
}

- (void)rightViewsTransformValidate {
    [self rightViewsTransformValidateWithPercentage:(self.isRightViewShowing ? 1.0 : 0.0)];
}

- (void)rightViewsTransformValidateWithPercentage:(CGFloat)percentage {
    if (!self.rightView) return;

    // -----

    if (self.sideViewsCoverView) {
        if (self.isRightViewVisible && !self.isRightViewAlwaysVisibleForCurrentOrientation && !self.isLeftViewAlwaysVisibleForCurrentOrientation) {
            self.sideViewsCoverView.alpha = self.rightViewCoverAlpha - (self.rightViewCoverAlpha * percentage);
        }
    }

    // -----

    CGFloat frameX = 0.0;
    CGAffineTransform rightViewScaleTransform = CGAffineTransformIdentity;
    CGAffineTransform rightViewBackgroundViewTransform = CGAffineTransformIdentity;

    // -----

    if (!self.isRightViewAlwaysVisibleForCurrentOrientation) {
        if (self.rightViewPresentationStyle == LGSideMenuPresentationStyleSlideAbove) {
            frameX = (self.rightViewWidth + self.rightViewLayerBorderWidth + self.rightViewLayerShadowRadius) * (1.0 - percentage);
        }
        else {
            CGFloat rightViewScale = 1.0 + (self.rightViewInitialScale - 1.0) * (1.0 - percentage);
            CGFloat rightViewBackgroundViewScale = self.rightViewBackgroundImageFinalScale + ((self.rightViewBackgroundImageInitialScale - self.rightViewBackgroundImageFinalScale) * (1.0 - percentage));

            rightViewScaleTransform = CGAffineTransformMakeScale(rightViewScale, rightViewScale);
            rightViewBackgroundViewTransform = CGAffineTransformMakeScale(rightViewBackgroundViewScale, rightViewBackgroundViewScale);

            frameX = self.rightViewInitialOffsetX * (1.0 - percentage);
        }
    }

    CGAffineTransform rightViewTransform = CGAffineTransformConcat(rightViewScaleTransform,
                                                                   CGAffineTransformMakeTranslation(frameX, 0.0));

    // -----

    self.rightViewContainer.transform = rightViewTransform;
    self.rightViewBackgroundView.transform = rightViewBackgroundViewTransform;
    self.rightViewStyleView.transform = rightViewTransform;
}

- (void)stylesValidate {
    if (self.rootViewStyleView) {
        self.rootViewStyleView.strokeColor = self.rootViewLayerBorderColor;
        self.rootViewStyleView.strokeWidth = self.rootViewLayerBorderWidth;
        self.rootViewStyleView.shadowColor = self.rootViewLayerShadowColor;
        self.rootViewStyleView.shadowBlur = self.rootViewLayerShadowRadius;
        [self.rootViewStyleView setNeedsDisplay];
    }

    if (self.isLeftViewAlwaysVisibleForCurrentOrientation || self.isLeftViewVisible) {
        if (!self.isLeftViewAlwaysVisibleForCurrentOrientation) {
            self.rootViewCoverView.backgroundColor = self.rootViewCoverColorForLeftView;
            self.rootViewCoverView.effect = self.rootViewCoverBlurEffectForLeftView;

            if (self.sideViewsCoverView) {
                self.sideViewsCoverView.backgroundColor = self.leftViewCoverColor;
                self.sideViewsCoverView.effect = self.leftViewCoverBlurEffect;
            }
        }

        if (self.leftViewStyleView) {
            self.leftViewStyleView.alpha = self.leftViewBackgroundAlpha;
            self.leftViewStyleView.backgroundColor = self.isLeftViewAlwaysVisibleForCurrentOrientation ? [self.leftViewBackgroundColor colorWithAlphaComponent:1.0] : self.leftViewBackgroundColor;
            self.leftViewStyleView.effect = self.leftViewBackgroundBlurEffect;

            self.leftViewBorderView.strokeColor = self.leftViewLayerBorderColor;
            self.leftViewBorderView.strokeWidth = self.leftViewLayerBorderWidth;
            self.leftViewBorderView.shadowColor = self.leftViewLayerShadowColor;
            self.leftViewBorderView.shadowBlur = self.leftViewLayerShadowRadius;
            [self.leftViewBorderView setNeedsDisplay];
        }

        if (self.leftViewBackgroundView) {
            self.leftViewBackgroundView.backgroundColor = self.leftViewBackgroundColor;
            [LGSideMenuHelper imageView:self.leftViewBackgroundView setImageSafe:self.leftViewBackgroundImage];
        }
    }

    if (self.isRightViewAlwaysVisibleForCurrentOrientation || self.isRightViewVisible) {
        if (!self.isRightViewAlwaysVisibleForCurrentOrientation) {
            self.rootViewCoverView.backgroundColor = self.rootViewCoverColorForRightView;
            self.rootViewCoverView.effect = self.rootViewCoverBlurEffectForRightView;

            if (self.sideViewsCoverView) {
                self.sideViewsCoverView.backgroundColor = self.rightViewCoverColor;
                self.sideViewsCoverView.effect = self.rightViewCoverBlurEffect;
            }
        }

        if (self.rightViewStyleView) {
            self.rightViewStyleView.alpha = self.rightViewBackgroundAlpha;
            self.rightViewStyleView.backgroundColor = self.isRightViewAlwaysVisibleForCurrentOrientation ? [self.rightViewBackgroundColor colorWithAlphaComponent:1.0] : self.rightViewBackgroundColor;
            self.rightViewStyleView.effect = self.rightViewBackgroundBlurEffect;

            self.rightViewBorderView.strokeColor = self.rightViewLayerBorderColor;
            self.rightViewBorderView.strokeWidth = self.rightViewLayerBorderWidth;
            self.rightViewBorderView.shadowColor = self.rightViewLayerShadowColor;
            self.rightViewBorderView.shadowBlur = self.rightViewLayerShadowRadius;
            [self.rightViewBorderView setNeedsDisplay];
        }

        if (self.rightViewBackgroundView) {
            self.rightViewBackgroundView.backgroundColor = self.rightViewBackgroundColor;
            [LGSideMenuHelper imageView:self.rightViewBackgroundView setImageSafe:self.rightViewBackgroundImage];
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
            self.leftViewBackgroundView.hidden = NO;
            self.leftViewStyleView.hidden = NO;
            self.leftViewContainer.hidden = NO;

            sideViewsCoverViewHiddenForLeftView = YES;
            rootViewStyleViewHiddenForLeftView = NO;
            rootViewCoverViewHiddenForLeftView = YES;
        }
        else if (self.isLeftViewVisible) {
            self.leftViewBackgroundView.hidden = NO;
            self.leftViewStyleView.hidden = NO;
            self.leftViewContainer.hidden = NO;

            sideViewsCoverViewHiddenForLeftView = NO;
            rootViewStyleViewHiddenForLeftView = NO;
            rootViewCoverViewHiddenForLeftView = NO;
        }
        else if (self.isLeftViewHidden) {
            if (delay) {
                __weak typeof(self) wself = self;
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^(void) {
                    if (!wself) return;
                    __strong typeof(wself) sseslf = wself;

                    sseslf.leftViewBackgroundView.hidden = YES;
                    sseslf.leftViewStyleView.hidden = YES;
                    sseslf.leftViewContainer.hidden = YES;
                });
            }
            else {
                self.leftViewBackgroundView.hidden = YES;
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
            self.rightViewBackgroundView.hidden = NO;
            self.rightViewStyleView.hidden = NO;
            self.rightViewContainer.hidden = NO;

            sideViewsCoverViewHiddenForRightView = YES;
            rootViewStyleViewHiddenForRightView = NO;
            rootViewCoverViewHiddenForRightView = YES;
        }
        else if (self.isRightViewVisible) {
            self.rightViewBackgroundView.hidden = NO;
            self.rightViewStyleView.hidden = NO;
            self.rightViewContainer.hidden = NO;

            sideViewsCoverViewHiddenForRightView = NO;
            rootViewStyleViewHiddenForRightView = NO;
            rootViewCoverViewHiddenForRightView = NO;
        }
        else if (self.isRightViewHidden) {
            if (delay) {
                __weak typeof(self) wself = self;
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^(void) {
                    if (!wself) return;
                    __strong typeof(wself) sseslf = wself;

                    sseslf.rightViewBackgroundView.hidden = YES;
                    sseslf.rightViewStyleView.hidden = YES;
                    sseslf.rightViewContainer.hidden = YES;
                });
            }
            else {
                self.rightViewBackgroundView.hidden = YES;
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
            __weak typeof(self) wself = self;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^(void) {
                if (!wself) return;
                __strong typeof(wself) sseslf = wself;

                sseslf.rootViewStyleView.hidden = YES;
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
            __weak typeof(self) wself = self;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^(void) {
                if (!wself) return;
                __strong typeof(wself) sseslf = wself;

                sseslf.rootViewCoverView.hidden = YES;
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
            __weak typeof(self) wself = self;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^(void) {
                if (!wself) return;
                __strong typeof(wself) sseslf = wself;

                sseslf.sideViewsCoverView.hidden = YES;
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

- (void)showLeftView {
    [self showLeftViewAnimated:NO completionHandler:nil];
}

- (void)hideLeftView {
    [self hideLeftViewAnimated:NO completionHandler:nil];
}

- (void)toggleLeftView {
    [self toggleLeftViewAnimated:NO completionHandler:nil];
}

#pragma mark -

- (IBAction)showLeftView:(nullable id)sender {
    [self showLeftView];
}

- (IBAction)hideLeftView:(nullable id)sender {
    [self hideLeftView];
}

- (IBAction)toggleLeftView:(nullable id)sender {
    [self toggleLeftView];
}

#pragma mark -

- (void)showLeftViewAnimated {
    [self showLeftViewAnimated:YES completionHandler:nil];
}

- (void)hideLeftViewAnimated {
    [self hideLeftViewAnimated:YES completionHandler:nil];
}

- (void)toggleLeftViewAnimated {
    [self toggleLeftViewAnimated:YES completionHandler:nil];
}

#pragma mark -

- (IBAction)showLeftViewAnimated:(nullable id)sender {
    [self showLeftViewAnimated];
}

- (IBAction)hideLeftViewAnimated:(nullable id)sender {
    [self hideLeftViewAnimated];
}

- (IBAction)toggleLeftViewAnimated:(nullable id)sender {
    [self toggleLeftViewAnimated];
}

#pragma mark -

- (void)showLeftViewAnimated:(BOOL)animated completionHandler:(LGSideMenuCompletionHandler)completionHandler {
    if (!self.leftView ||
        self.isLeftViewDisabled ||
        self.isLeftViewAlwaysVisibleForCurrentOrientation) {
        return;
    }

    [self showLeftViewPrepareWithGesture:NO];
    [self showLeftViewAnimatedActions:animated completionHandler:completionHandler];
}

- (void)hideLeftViewAnimated:(BOOL)animated completionHandler:(LGSideMenuCompletionHandler)completionHandler {
    if (!self.leftView ||
        self.isLeftViewDisabled ||
        self.isLeftViewAlwaysVisibleForCurrentOrientation) {
        return;
    }

    [self hideLeftViewPrepare];
    [self hideLeftViewAnimatedActions:animated completionHandler:completionHandler];
}

- (void)toggleLeftViewAnimated:(BOOL)animated completionHandler:(LGSideMenuCompletionHandler)completionHandler {
    if (self.state == LGSideMenuStateLeftViewIsShowing) {
        [self hideLeftViewAnimated:animated completionHandler:completionHandler];
    }
    else {
        [self showLeftViewAnimated:animated completionHandler:completionHandler];
    }
}

#pragma mark -

- (void)showLeftViewAnimated:(BOOL)animated delay:(NSTimeInterval)delay completionHandler:(LGSideMenuCompletionHandler)completionHandler {
    __weak typeof(self) wself = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (!wself) return;
        __strong typeof(wself) sseslf = wself;
        [sseslf showLeftViewAnimated:animated completionHandler:completionHandler];
    });
}

- (void)hideLeftViewAnimated:(BOOL)animated delay:(NSTimeInterval)delay completionHandler:(LGSideMenuCompletionHandler)completionHandler {
    __weak typeof(self) wself = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (!wself) return;
        __strong typeof(wself) sseslf = wself;
        [sseslf hideLeftViewAnimated:animated completionHandler:completionHandler];
    });
}

- (void)toggleLeftViewAnimated:(BOOL)animated delay:(NSTimeInterval)delay completionHandler:(LGSideMenuCompletionHandler)completionHandler {
    __weak typeof(self) wself = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (!wself) return;
        __strong typeof(wself) sseslf = wself;
        [sseslf toggleLeftViewAnimated:animated completionHandler:completionHandler];
    });
}

#pragma mark - Show left view

- (void)showLeftViewPrepareWithGesture:(BOOL)withGesture {
    if (self.state == LGSideMenuStateLeftViewWillShow) return;

    BOOL shouldUpdateFrames = NO;
    if (self.state == LGSideMenuStateRootViewIsShowing) {
        shouldUpdateFrames = YES;
    }

    self.state = LGSideMenuStateLeftViewWillShow;

    [self.view endEditing:YES];

    if (self.rootViewController && self.rootViewControllerAdded) {
        [self.rootViewController removeFromParentViewController];
        self.rootViewControllerAdded = NO;
    }

    [LGSideMenuHelper statusBarAppearanceUpdateAnimated:YES
                                         viewController:self
                                               duration:self.leftViewAnimationDuration
                                                 hidden:self.leftViewStatusBarHidden
                                                  style:self.leftViewStatusBarStyle
                                              animation:self.leftViewStatusBarUpdateAnimation];

    if (self.leftViewController && !self.leftViewControllerAdded) {
        [self addChildViewController:self.leftViewController];
        self.leftViewControllerAdded = YES;
    }

    if (shouldUpdateFrames) {
        [self leftViewsFramesValidate];
        [self leftViewsTransformValidateWithPercentage:0.0];
    }

    [self stylesValidate];
    [self visibilityValidate];
}

- (void)showLeftViewAnimatedActions:(BOOL)animated completionHandler:(LGSideMenuCompletionHandler)completionHandler {
    if (self.state == LGSideMenuStateLeftViewWillShow) {
        [self willShowLeftViewCallbacks];
    }

    if (animated) {
        self.gesturesHandler.animating = YES;

        [LGSideMenuHelper
         animateWithDuration:self.leftViewAnimationDuration
         animations:^(void) {
             [self rootViewsTransformValidateWithPercentage:1.0];
             [self leftViewsTransformValidateWithPercentage:1.0];

             // -----

             [[NSNotificationCenter defaultCenter] postNotificationName:LGSideMenuShowLeftViewAnimationsNotification
                                                                 object:self
                                                               userInfo:@{kLGSideMenuView: self.leftView,
                                                                          kLGSideMenuAnimationDuration: @(self.leftViewAnimationDuration)}];

             if (self.showLeftViewAnimations) {
                 self.showLeftViewAnimations(self, self.leftView, self.leftViewAnimationDuration);
             }

             if (self.delegate && [self.delegate respondsToSelector:@selector(showAnimationsForLeftView:sideMenuController:duration:)]) {
                 [self.delegate showAnimationsForLeftView:self.leftView sideMenuController:self duration:self.leftViewAnimationDuration];
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
    self.leftViewGestireStartX = nil;

    if (self.state == LGSideMenuStateLeftViewWillShow) {
        [self didShowLeftViewCallbacks];
    }

    self.state = LGSideMenuStateLeftViewIsShowing;
}

#pragma mark - Hide left view

- (void)hideLeftViewPrepare {
    if (self.state == LGSideMenuStateLeftViewWillHide) return;
    self.state = LGSideMenuStateLeftViewWillHide;

    [self.view endEditing:YES];
}

- (void)hideLeftViewAnimatedActions:(BOOL)animated completionHandler:(LGSideMenuCompletionHandler)completionHandler {
    if (self.state == LGSideMenuStateLeftViewWillHide) {
        [self willHideLeftViewCallbacks];
    }

    // -----

    if (self.leftViewController && self.leftViewControllerAdded) {
        [self.leftViewController removeFromParentViewController];
        self.leftViewControllerAdded = NO;
    }

    [LGSideMenuHelper statusBarAppearanceUpdateAnimated:animated
                                         viewController:self
                                               duration:self.leftViewAnimationDuration
                                                 hidden:self.leftViewStatusBarHidden
                                                  style:self.leftViewStatusBarStyle
                                              animation:self.leftViewStatusBarUpdateAnimation];

    if (self.rootViewController && !self.isRootViewControllerAdded) {
        [self addChildViewController:self.rootViewController];
        self.rootViewControllerAdded = YES;
    }

    // -----

    if (animated) {
        self.gesturesHandler.animating = YES;

        [LGSideMenuHelper
         animateWithDuration:self.leftViewAnimationDuration
         animations:^(void) {
             [self rootViewsTransformValidateWithPercentage:0.0];
             [self leftViewsTransformValidateWithPercentage:0.0];

             // -----

             [[NSNotificationCenter defaultCenter] postNotificationName:LGSideMenuHideLeftViewAnimationsNotification
                                                                 object:self
                                                               userInfo:@{kLGSideMenuView: self.leftView,
                                                                          kLGSideMenuAnimationDuration: @(self.leftViewAnimationDuration)}];

             if (self.hideLeftViewAnimations) {
                 self.hideLeftViewAnimations(self, self.leftView, self.leftViewAnimationDuration);
             }

             if (self.delegate && [self.delegate respondsToSelector:@selector(hideAnimationsForLeftView:sideMenuController:duration:)]) {
                 [self.delegate hideAnimationsForLeftView:self.leftView sideMenuController:self duration:self.leftViewAnimationDuration];
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
        if (self.leftViewController && self.leftViewControllerAdded) {
            [self.leftViewController removeFromParentViewController];
            self.leftViewControllerAdded = NO;
        }

        [LGSideMenuHelper statusBarAppearanceUpdateAnimated:YES
                                             viewController:self
                                                   duration:self.leftViewAnimationDuration
                                                     hidden:self.leftViewStatusBarHidden
                                                      style:self.leftViewStatusBarStyle
                                                  animation:self.leftViewStatusBarUpdateAnimation];

        if (self.rootViewController && !self.isRootViewControllerAdded) {
            [self addChildViewController:self.rootViewController];
            self.rootViewControllerAdded = YES;
        }
    }

    self.leftViewGestireStartX = nil;

    if (self.state == LGSideMenuStateLeftViewWillHide) {
        [self didHideLeftViewCallbacks];
    }

    self.state = LGSideMenuStateRootViewIsShowing;
    [self visibilityValidate];
}

#pragma mark - Right view actions

- (void)showRightView {
    [self showRightViewAnimated:NO completionHandler:nil];
}

- (void)hideRightView {
    [self hideRightViewAnimated:NO completionHandler:nil];
}

- (void)toggleRightView {
    [self toggleRightViewAnimated:NO completionHandler:nil];
}

#pragma mark -

- (IBAction)showRightView:(nullable id)sender {
    [self showRightView];
}

- (IBAction)hideRightView:(nullable id)sender {
    [self hideRightView];
}

- (IBAction)toggleRightView:(nullable id)sender {
    [self toggleRightView];
}

#pragma mark -

- (void)showRightViewAnimated {
    [self showRightViewAnimated:YES completionHandler:nil];
}

- (void)hideRightViewAnimated {
    [self hideRightViewAnimated:YES completionHandler:nil];
}

- (void)toggleRightViewAnimated {
    [self toggleRightViewAnimated:YES completionHandler:nil];
}

#pragma mark -

- (IBAction)showRightViewAnimated:(nullable id)sender {
    [self showRightViewAnimated];
}

- (IBAction)hideRightViewAnimated:(nullable id)sender {
    [self hideRightViewAnimated];
}

- (IBAction)toggleRightViewAnimated:(nullable id)sender {
    [self toggleRightViewAnimated];
}

#pragma mark -

- (void)showRightViewAnimated:(BOOL)animated completionHandler:(LGSideMenuCompletionHandler)completionHandler {
    if (!self.rightView ||
        self.isRightViewDisabled ||
        self.isRightViewAlwaysVisibleForCurrentOrientation) {
        return;
    }

    [self showRightViewPrepareWithGesture:NO];
    [self showRightViewAnimatedActions:animated completionHandler:completionHandler];
}

- (void)hideRightViewAnimated:(BOOL)animated completionHandler:(LGSideMenuCompletionHandler)completionHandler {
    if (!self.rightView ||
        self.isRightViewDisabled ||
        self.isRightViewAlwaysVisibleForCurrentOrientation) {
        return;
    }

    [self hideRightViewPrepare];
    [self hideRightViewAnimatedActions:animated completionHandler:completionHandler];
}

- (void)toggleRightViewAnimated:(BOOL)animated completionHandler:(LGSideMenuCompletionHandler)completionHandler {
    if (self.state == LGSideMenuStateRightViewIsShowing) {
        [self hideRightViewAnimated:animated completionHandler:completionHandler];
    }
    else {
        [self showRightViewAnimated:animated completionHandler:completionHandler];
    }
}

#pragma mark -

- (void)showRightViewAnimated:(BOOL)animated delay:(NSTimeInterval)delay completionHandler:(LGSideMenuCompletionHandler)completionHandler {
    __weak typeof(self) wself = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (!wself) return;
        __strong typeof(wself) sseslf = wself;
        [sseslf showRightViewAnimated:animated completionHandler:completionHandler];
    });
}

- (void)hideRightViewAnimated:(BOOL)animated delay:(NSTimeInterval)delay completionHandler:(LGSideMenuCompletionHandler)completionHandler {
    __weak typeof(self) wself = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (!wself) return;
        __strong typeof(wself) sseslf = wself;
        [sseslf hideRightViewAnimated:animated completionHandler:completionHandler];
    });
}

- (void)toggleRightViewAnimated:(BOOL)animated delay:(NSTimeInterval)delay completionHandler:(LGSideMenuCompletionHandler)completionHandler {
    __weak typeof(self) wself = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (!wself) return;
        __strong typeof(wself) sseslf = wself;
        [sseslf toggleRightViewAnimated:animated completionHandler:completionHandler];
    });
}

#pragma mark - Show right view

- (void)showRightViewPrepareWithGesture:(BOOL)withGesture {
    if (self.state == LGSideMenuStateRightViewWillShow) return;

    BOOL shouldUpdateFrames = NO;
    if (self.state == LGSideMenuStateRootViewIsShowing) {
        shouldUpdateFrames = YES;
    }

    self.state = LGSideMenuStateRightViewWillShow;

    [self.view endEditing:YES];

    if (self.rootViewController && self.rootViewControllerAdded) {
        [self.rootViewController removeFromParentViewController];
        self.rootViewControllerAdded = NO;
    }

    [LGSideMenuHelper statusBarAppearanceUpdateAnimated:YES
                                         viewController:self
                                               duration:self.rightViewAnimationDuration
                                                 hidden:self.rightViewStatusBarHidden
                                                  style:self.rightViewStatusBarStyle
                                              animation:self.rightViewStatusBarUpdateAnimation];

    if (self.rightViewController && !self.rightViewControllerAdded) {
        [self addChildViewController:self.rightViewController];
        self.rightViewControllerAdded = YES;
    }

    if (shouldUpdateFrames) {
        [self rightViewsFramesValidate];
        [self rightViewsTransformValidateWithPercentage:0.0];
    }

    [self stylesValidate];
    [self visibilityValidate];
}

- (void)showRightViewAnimatedActions:(BOOL)animated completionHandler:(LGSideMenuCompletionHandler)completionHandler {
    if (self.state == LGSideMenuStateRightViewWillShow) {
        [self willShowRightViewCallbacks];
    }

    if (animated) {
        self.gesturesHandler.animating = YES;

        [LGSideMenuHelper
         animateWithDuration:self.rightViewAnimationDuration
         animations:^(void) {
             [self rootViewsTransformValidateWithPercentage:1.0];
             [self rightViewsTransformValidateWithPercentage:1.0];

             // -----

             [[NSNotificationCenter defaultCenter] postNotificationName:LGSideMenuShowRightViewAnimationsNotification
                                                                 object:self
                                                               userInfo:@{kLGSideMenuView: self.rightView,
                                                                          kLGSideMenuAnimationDuration: @(self.rightViewAnimationDuration)}];

             if (self.showRightViewAnimations) {
                 self.showRightViewAnimations(self, self.rightView, self.rightViewAnimationDuration);
             }

             if (self.delegate && [self.delegate respondsToSelector:@selector(showAnimationsForRightView:sideMenuController:duration:)]) {
                 [self.delegate showAnimationsForRightView:self.rightView sideMenuController:self duration:self.rightViewAnimationDuration];
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
    self.rightViewGestireStartX = nil;

    if (self.state == LGSideMenuStateRightViewWillShow) {
        [self didShowRightViewCallbacks];
    }

    self.state = LGSideMenuStateRightViewIsShowing;
}

#pragma mark - Hide right view

- (void)hideRightViewPrepare {
    if (self.state == LGSideMenuStateRightViewWillHide) return;
    self.state = LGSideMenuStateRightViewWillHide;

    [self.view endEditing:YES];
}

- (void)hideRightViewAnimatedActions:(BOOL)animated completionHandler:(LGSideMenuCompletionHandler)completionHandler {
    if (self.state == LGSideMenuStateRightViewWillHide) {
        [self willHideRightViewCallbacks];
    }

    // -----

    if (self.rightViewController && self.rightViewControllerAdded) {
        [self.rightViewController removeFromParentViewController];
        self.rightViewControllerAdded = NO;
    }

    [LGSideMenuHelper statusBarAppearanceUpdateAnimated:animated
                                         viewController:self
                                               duration:self.rightViewAnimationDuration
                                                 hidden:self.rightViewStatusBarHidden
                                                  style:self.rightViewStatusBarStyle
                                              animation:self.rightViewStatusBarUpdateAnimation];

    if (self.rootViewController && !self.isRootViewControllerAdded) {
        [self addChildViewController:self.rootViewController];
        self.rootViewControllerAdded = YES;
    }

    // -----

    if (animated) {
        self.gesturesHandler.animating = YES;

        [LGSideMenuHelper
         animateWithDuration:self.rightViewAnimationDuration
         animations:^(void) {
             [self rootViewsTransformValidateWithPercentage:0.0];
             [self rightViewsTransformValidateWithPercentage:0.0];

             // -----

             [[NSNotificationCenter defaultCenter] postNotificationName:LGSideMenuHideRightViewAnimationsNotification
                                                                 object:self
                                                               userInfo:@{kLGSideMenuView: self.rightView,
                                                                          kLGSideMenuAnimationDuration: @(self.rightViewAnimationDuration)}];

             if (self.hideRightViewAnimations) {
                 self.hideRightViewAnimations(self, self.rightView, self.rightViewAnimationDuration);
             }

             if (self.delegate && [self.delegate respondsToSelector:@selector(hideAnimationsForRightView:sideMenuController:duration:)]) {
                 [self.delegate hideAnimationsForRightView:self.rightView sideMenuController:self duration:self.rightViewAnimationDuration];
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
        if (self.rightViewController && self.rightViewControllerAdded) {
            [self.rightViewController removeFromParentViewController];
            self.rightViewControllerAdded = NO;
        }

        [LGSideMenuHelper statusBarAppearanceUpdateAnimated:YES
                                             viewController:self
                                                   duration:self.rightViewAnimationDuration
                                                     hidden:self.rightViewStatusBarHidden
                                                      style:self.rightViewStatusBarStyle
                                                  animation:self.rightViewStatusBarUpdateAnimation];

        if (self.rootViewController && !self.isRootViewControllerAdded) {
            [self addChildViewController:self.rootViewController];
            self.rootViewControllerAdded = YES;
        }
    }

    self.rightViewGestireStartX = nil;

    if (self.state == LGSideMenuStateRightViewWillHide) {
        [self didHideRightViewCallbacks];
    }

    self.state = LGSideMenuStateRootViewIsShowing;
    [self visibilityValidate];
}

#pragma mark - Callbacks

- (void)willShowLeftViewCallbacks {
    [[NSNotificationCenter defaultCenter] postNotificationName:LGSideMenuWillShowLeftViewNotification
                                                        object:self
                                                      userInfo:@{kLGSideMenuView: self.leftView}];

    if (self.willShowLeftView) {
        self.willShowLeftView(self, self.leftView);
    }

    if (self.delegate && [self.delegate respondsToSelector:@selector(willShowLeftView:sideMenuController:)]) {
        [self.delegate willShowLeftView:self.leftView sideMenuController:self];
    }
}

- (void)didShowLeftViewCallbacks {
    [[NSNotificationCenter defaultCenter] postNotificationName:LGSideMenuDidShowLeftViewNotification
                                                        object:self
                                                      userInfo:@{kLGSideMenuView: self.leftView}];

    if (self.didShowLeftView) {
        self.didShowLeftView(self, self.leftView);
    }

    if (self.delegate && [self.delegate respondsToSelector:@selector(didShowLeftView:sideMenuController:)]) {
        [self.delegate didShowLeftView:self.leftView sideMenuController:self];
    }
}

- (void)willHideLeftViewCallbacks {
    [[NSNotificationCenter defaultCenter] postNotificationName:LGSideMenuWillHideLeftViewNotification
                                                        object:self
                                                      userInfo:@{kLGSideMenuView: self.leftView}];

    if (self.willHideLeftView) {
        self.willHideLeftView(self, self.leftView);
    }

    if (self.delegate && [self.delegate respondsToSelector:@selector(willHideLeftView:sideMenuController:)]) {
        [self.delegate willHideLeftView:self.leftView sideMenuController:self];
    }
}

- (void)didHideLeftViewCallbacks {
    [[NSNotificationCenter defaultCenter] postNotificationName:LGSideMenuDidHideLeftViewNotification
                                                        object:self
                                                      userInfo:@{kLGSideMenuView: self.leftView}];

    if (self.didHideLeftView) {
        self.didHideLeftView(self, self.leftView);
    }

    if (self.delegate && [self.delegate respondsToSelector:@selector(didHideLeftView:sideMenuController:)]) {
        [self.delegate didHideLeftView:self.leftView sideMenuController:self];
    }
}

- (void)willShowRightViewCallbacks {
    [[NSNotificationCenter defaultCenter] postNotificationName:LGSideMenuWillShowRightViewNotification
                                                        object:self
                                                      userInfo:@{kLGSideMenuView: self.rightView}];

    if (self.willShowRightView) {
        self.willShowRightView(self, self.rightView);
    }

    if (self.delegate && [self.delegate respondsToSelector:@selector(willShowRightView:sideMenuController:)]) {
        [self.delegate willShowRightView:self.leftView sideMenuController:self];
    }
}

- (void)didShowRightViewCallbacks {
    [[NSNotificationCenter defaultCenter] postNotificationName:LGSideMenuDidShowRightViewNotification
                                                        object:self
                                                      userInfo:@{kLGSideMenuView: self.rightView}];

    if (self.didShowRightView) {
        self.didShowRightView(self, self.rightView);
    }

    if (self.delegate && [self.delegate respondsToSelector:@selector(didShowRightView:sideMenuController:)]) {
        [self.delegate didShowRightView:self.leftView sideMenuController:self];
    }
}

- (void)willHideRightViewCallbacks {
    [[NSNotificationCenter defaultCenter] postNotificationName:LGSideMenuWillHideRightViewNotification
                                                        object:self
                                                      userInfo:@{kLGSideMenuView: self.rightView}];

    if (self.willHideRightView) {
        self.willHideRightView(self, self.rightView);
    }

    if (self.delegate && [self.delegate respondsToSelector:@selector(willHideRightView:sideMenuController:)]) {
        [self.delegate willHideRightView:self.leftView sideMenuController:self];
    }
}

- (void)didHideRightViewCallbacks {
    [[NSNotificationCenter defaultCenter] postNotificationName:LGSideMenuDidHideRightViewNotification
                                                        object:self
                                                      userInfo:@{kLGSideMenuView: self.rightView}];

    if (self.didHideRightView) {
        self.didHideRightView(self, self.rightView);
    }

    if (self.delegate && [self.delegate respondsToSelector:@selector(didHideRightView:sideMenuController:)]) {
        [self.delegate didHideRightView:self.leftView sideMenuController:self];
    }
}

#pragma mark - UIGestureRecognizers

- (void)tapGesture:(UITapGestureRecognizer *)gesture {
    if (self.state == LGSideMenuStateLeftViewIsShowing) {
        [self hideLeftViewAnimated:self.shouldHideLeftViewAnimated completionHandler:nil];
    }
    else if (self.state == LGSideMenuStateRightViewIsShowing) {
        [self hideRightViewAnimated:self.shouldHideRightViewAnimated completionHandler:nil];
    }
}

- (void)panGesture:(UIPanGestureRecognizer *)gestureRecognizer {
    CGPoint location = [gestureRecognizer locationInView:self.view];
    CGPoint velocity = [gestureRecognizer velocityInView:self.view];

    // -----

    CGFloat frameWidth = CGRectGetWidth(self.view.bounds);

    // -----

    if (self.leftView && self.isLeftViewSwipeGestureEnabled && !self.isLeftViewAlwaysVisibleForCurrentOrientation && !self.rightViewGestireStartX && self.isRightViewHidden && self.isLeftViewEnabled) {
        if (!self.leftViewGestireStartX && (gestureRecognizer.state == UIGestureRecognizerStateBegan || gestureRecognizer.state == UIGestureRecognizerStateChanged)) {
            BOOL velocityReady = self.isLeftViewShowing ? velocity.x < 0.0 : velocity.x > 0.0;

            if (velocityReady && (self.isLeftViewShowing || self.swipeGestureArea == LGSideMenuSwipeGestureAreaFull || location.x < frameWidth / 2.0)) {
                self.leftViewGestireStartX = [NSNumber numberWithFloat:location.x];
                self.leftViewShowingBeforeGesture = self.isLeftViewShowing;

                if (self.isLeftViewShowing) {
                    [self hideLeftViewPrepare];
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
                [self rootViewsTransformValidateWithPercentage:percentage];
                [self leftViewsTransformValidateWithPercentage:percentage];
            }
            else if ((gestureRecognizer.state == UIGestureRecognizerStateEnded || gestureRecognizer.state == UIGestureRecognizerStateCancelled)
                     && self.leftViewGestireStartX) {
                if ((percentage < 1.0 && velocity.x > 0.0) || (velocity.x == 0.0 && percentage >= 0.5)) {
                    [self showLeftViewPrepareWithGesture:YES];
                    [self showLeftViewAnimatedActions:YES completionHandler:nil];
                }
                else if ((percentage > 0.0 && velocity.x < 0.0) || (velocity.x == 0.0 && percentage < 0.5)) {
                    [self hideLeftViewPrepare];
                    [self hideLeftViewAnimatedActions:YES completionHandler:nil];
                }
                else if (percentage == 1.0) {
                    [self showLeftViewPrepareWithGesture:YES];
                    [self showLeftViewDoneWithGesture:YES];
                }
                else if (percentage == 0.0) {
                    [self hideLeftViewPrepare];
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
                self.rightViewShowingBeforeGesture = self.isRightViewShowing;

                if (self.isRightViewShowing) {
                    [self hideRightViewPrepare];
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
                [self rootViewsTransformValidateWithPercentage:percentage];
                [self rightViewsTransformValidateWithPercentage:percentage];
            }
            else if ((gestureRecognizer.state == UIGestureRecognizerStateEnded || gestureRecognizer.state == UIGestureRecognizerStateCancelled)
                     && self.rightViewGestireStartX) {
                if ((percentage < 1.0 && velocity.x < 0.0) || (velocity.x == 0.0 && percentage >= 0.5)) {
                    [self showRightViewPrepareWithGesture:YES];
                    [self showRightViewAnimatedActions:YES completionHandler:nil];
                }
                else if ((percentage > 0.0 && velocity.x > 0.0) || (velocity.x == 0.0 && percentage < 0.5)) {
                    [self hideRightViewPrepare];
                    [self hideRightViewAnimatedActions:YES completionHandler:nil];
                }
                else if (percentage == 1.0) {
                    [self showRightViewPrepareWithGesture:YES];
                    [self showRightViewDoneWithGesture:YES];
                }
                else if (percentage == 0.0) {
                    [self hideRightViewPrepare];
                    [self hideRightViewDoneWithGesture:YES];
                }

                self.rightViewGestireStartX = nil;
            }
        }
    }
}

@end

#pragma mark - Deprecated

NSString * _Nonnull const LGSideMenuControllerWillDismissLeftViewNotification  = @"LGSideMenuWillHideLeftViewNotification";
NSString * _Nonnull const LGSideMenuControllerDidDismissLeftViewNotification   = @"LGSideMenuDidHideLeftViewNotification";
NSString * _Nonnull const LGSideMenuControllerWillDismissRightViewNotification = @"LGSideMenuWillHideRightViewNotification";
NSString * _Nonnull const LGSideMenuControllerDidDismissRightViewNotification  = @"LGSideMenuDidHideRightViewNotification";

NSString * _Nonnull const kLGSideMenuControllerWillShowLeftViewNotification = @"LGSideMenuWillShowLeftViewNotification";
NSString * _Nonnull const kLGSideMenuControllerWillHideLeftViewNotification = @"LGSideMenuWillHideLeftViewNotification";
NSString * _Nonnull const kLGSideMenuControllerDidShowLeftViewNotification  = @"LGSideMenuDidShowLeftViewNotification";
NSString * _Nonnull const kLGSideMenuControllerDidHideLeftViewNotification  = @"LGSideMenuDidHideLeftViewNotification";

NSString * _Nonnull const kLGSideMenuControllerWillShowRightViewNotification = @"LGSideMenuWillShowRightViewNotification";
NSString * _Nonnull const kLGSideMenuControllerWillHideRightViewNotification = @"LGSideMenuWillHideRightViewNotification";
NSString * _Nonnull const kLGSideMenuControllerDidShowRightViewNotification  = @"LGSideMenuDidShowRightViewNotification";
NSString * _Nonnull const kLGSideMenuControllerDidHideRightViewNotification  = @"LGSideMenuDidHideRightViewNotification";

NSString * _Nonnull const LGSideMenuControllerWillShowLeftViewNotification  = @"LGSideMenuWillShowLeftViewNotification";
NSString * _Nonnull const LGSideMenuControllerDidShowLeftViewNotification   = @"LGSideMenuDidShowLeftViewNotification";

NSString * _Nonnull const LGSideMenuControllerWillHideLeftViewNotification = @"LGSideMenuWillHideLeftViewNotification";
NSString * _Nonnull const LGSideMenuControllerDidHideLeftViewNotification  = @"LGSideMenuDidHideLeftViewNotification";

NSString * _Nonnull const LGSideMenuControllerWillShowRightViewNotification = @"LGSideMenuWillShowRightViewNotification";
NSString * _Nonnull const LGSideMenuControllerDidShowRightViewNotification  = @"LGSideMenuDidShowRightViewNotification";

NSString * _Nonnull const LGSideMenuControllerWillHideRightViewNotification = @"LGSideMenuWillHideRightViewNotification";
NSString * _Nonnull const LGSideMenuControllerDidHideRightViewNotification  = @"LGSideMenuDidHideRightViewNotification";

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

- (void)setLeftViewAnimationSpeed:(NSTimeInterval)leftViewAnimationSpeed {
    self.leftViewAnimationDuration = leftViewAnimationSpeed;
}

- (NSTimeInterval)leftViewAnimationSpeed {
    return self.leftViewAnimationDuration;
}

- (void)setRightViewAnimationSpeed:(NSTimeInterval)rightViewAnimationSpeed {
    self.rightViewAnimationDuration = rightViewAnimationSpeed;
}

- (NSTimeInterval)rightViewAnimationSpeed {
    return self.rightViewAnimationDuration;
}

- (void)setShowLeftViewAnimationsBlock:(LGSideMenuAnimationsBlock)showLeftViewAnimationsBlock {
    self.showLeftViewAnimations = showLeftViewAnimationsBlock;
}

- (LGSideMenuAnimationsBlock)showLeftViewAnimationsBlock {
    return self.showLeftViewAnimations;
}

- (void)setHideLeftViewAnimationsBlock:(LGSideMenuAnimationsBlock)hideLeftViewAnimationsBlock {
    self.hideLeftViewAnimations = hideLeftViewAnimationsBlock;
}

- (LGSideMenuAnimationsBlock)hideLeftViewAnimationsBlock {
    return self.hideLeftViewAnimations;
}

- (void)setShowRightViewAnimationsBlock:(LGSideMenuAnimationsBlock)showRightViewAnimationsBlock {
    self.showRightViewAnimations = showRightViewAnimationsBlock;
}

- (LGSideMenuAnimationsBlock)showRightViewAnimationsBlock {
    return self.showRightViewAnimations;
}

- (void)setHideRightViewAnimationsBlock:(LGSideMenuAnimationsBlock)hideRightViewAnimationsBlock {
    self.hideRightViewAnimations = hideRightViewAnimationsBlock;
}

- (LGSideMenuAnimationsBlock)hideRightViewAnimationsBlock {
    return self.hideRightViewAnimations;
}

#pragma mark -

- (BOOL)isLeftViewAlwaysVisibleForInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return [self isLeftViewAlwaysVisibleForOrientation:interfaceOrientation];
}

- (BOOL)isRightViewAlwaysVisibleForInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return [self isRightViewAlwaysVisibleForInterfaceOrientation:interfaceOrientation];
}

- (void)showHideLeftViewAnimated:(BOOL)animated completionHandler:(LGSideMenuCompletionHandler)completionHandler {
    [self toggleLeftViewAnimated:animated completionHandler:completionHandler];
}

- (void)showHideRightViewAnimated:(BOOL)animated completionHandler:(LGSideMenuCompletionHandler)completionHandler {
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
