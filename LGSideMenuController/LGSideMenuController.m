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

#import "LGSideMenuController.h"

#define kLGSideMenuStatusBarOrientationIsPortrait   UIInterfaceOrientationIsPortrait(UIApplication.sharedApplication.statusBarOrientation)
#define kLGSideMenuStatusBarOrientationIsLandscape  UIInterfaceOrientationIsLandscape(UIApplication.sharedApplication.statusBarOrientation)
#define kLGSideMenuStatusBarHidden                  UIApplication.sharedApplication.statusBarHidden
#define kLGSideMenuStatusBarStyle                   UIApplication.sharedApplication.statusBarStyle
#define kLGSideMenuDeviceIsPad                      (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define kLGSideMenuDeviceIsPhone                    (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define kLGSideMenuSystemVersion                    UIDevice.currentDevice.systemVersion.floatValue
#define kLGSideMenuCoverColor                       [UIColor colorWithWhite:0.0 alpha:0.5]
#define kLGSideMenuIsMenuShowing                    (self.isLeftViewShowing || self.isRightViewShowing)

#define kLGSideMenuIsLeftViewAlwaysVisible \
((self.leftViewAlwaysVisibleOptions & LGSideMenuAlwaysVisibleOnAll) || \
((kLGSideMenuDeviceIsPhone && \
((kLGSideMenuStatusBarOrientationIsPortrait && (self.leftViewAlwaysVisibleOptions & LGSideMenuAlwaysVisibleOnPhonePortrait)) || \
(kLGSideMenuStatusBarOrientationIsLandscape && (self.leftViewAlwaysVisibleOptions & LGSideMenuAlwaysVisibleOnPhoneLandscape)))) || \
(kLGSideMenuDeviceIsPad && \
((kLGSideMenuStatusBarOrientationIsPortrait && (self.leftViewAlwaysVisibleOptions & LGSideMenuAlwaysVisibleOnPadPortrait)) || \
(kLGSideMenuStatusBarOrientationIsLandscape && (self.leftViewAlwaysVisibleOptions & LGSideMenuAlwaysVisibleOnPadLandscape))))))

#define kLGSideMenuIsRightViewAlwaysVisible \
((self.rightViewAlwaysVisibleOptions & LGSideMenuAlwaysVisibleOnAll) || \
((kLGSideMenuDeviceIsPhone && \
((kLGSideMenuStatusBarOrientationIsPortrait && (self.rightViewAlwaysVisibleOptions & LGSideMenuAlwaysVisibleOnPhonePortrait)) || \
(kLGSideMenuStatusBarOrientationIsLandscape && (self.rightViewAlwaysVisibleOptions & LGSideMenuAlwaysVisibleOnPhoneLandscape)))) || \
(kLGSideMenuDeviceIsPad && \
((kLGSideMenuStatusBarOrientationIsPortrait && (self.rightViewAlwaysVisibleOptions & LGSideMenuAlwaysVisibleOnPadPortrait)) || \
(kLGSideMenuStatusBarOrientationIsLandscape && (self.rightViewAlwaysVisibleOptions & LGSideMenuAlwaysVisibleOnPadLandscape))))))

#define kLGSideMenuIsLeftViewAlwaysVisibleForInterfaceOrientation(interfaceOrientation) \
((self.leftViewAlwaysVisibleOptions & LGSideMenuAlwaysVisibleOnAll) || \
((kLGSideMenuDeviceIsPhone && \
((UIInterfaceOrientationIsPortrait(interfaceOrientation) && (self.leftViewAlwaysVisibleOptions & LGSideMenuAlwaysVisibleOnPhonePortrait)) || \
(UIInterfaceOrientationIsLandscape(interfaceOrientation) && (self.leftViewAlwaysVisibleOptions & LGSideMenuAlwaysVisibleOnPhoneLandscape)))) || \
(kLGSideMenuDeviceIsPad && \
((UIInterfaceOrientationIsPortrait(interfaceOrientation) && (self.leftViewAlwaysVisibleOptions & LGSideMenuAlwaysVisibleOnPadPortrait)) || \
(UIInterfaceOrientationIsLandscape(interfaceOrientation) && (self.leftViewAlwaysVisibleOptions & LGSideMenuAlwaysVisibleOnPadLandscape))))))

#define kLGSideMenuIsRightViewAlwaysVisibleForInterfaceOrientation(interfaceOrientation) \
((self.rightViewAlwaysVisibleOptions & LGSideMenuAlwaysVisibleOnAll) || \
((kLGSideMenuDeviceIsPhone && \
((UIInterfaceOrientationIsPortrait(interfaceOrientation) && (self.rightViewAlwaysVisibleOptions & LGSideMenuAlwaysVisibleOnPhonePortrait)) || \
(UIInterfaceOrientationIsLandscape(interfaceOrientation) && (self.rightViewAlwaysVisibleOptions & LGSideMenuAlwaysVisibleOnPhoneLandscape)))) || \
(kLGSideMenuDeviceIsPad && \
((UIInterfaceOrientationIsPortrait(interfaceOrientation) && (self.rightViewAlwaysVisibleOptions & LGSideMenuAlwaysVisibleOnPadPortrait)) || \
(UIInterfaceOrientationIsLandscape(interfaceOrientation) && (self.rightViewAlwaysVisibleOptions & LGSideMenuAlwaysVisibleOnPadLandscape))))))

#define kLGSideMenuIsLeftViewStatusBarVisible \
((self.leftViewStatusBarVisibleOptions & LGSideMenuStatusBarVisibleOnAll) || \
((kLGSideMenuDeviceIsPhone && \
((kLGSideMenuStatusBarOrientationIsPortrait && (self.leftViewStatusBarVisibleOptions & LGSideMenuStatusBarVisibleOnPhonePortrait)) || \
(kLGSideMenuStatusBarOrientationIsLandscape && (self.leftViewStatusBarVisibleOptions & LGSideMenuStatusBarVisibleOnPhoneLandscape)))) || \
(kLGSideMenuDeviceIsPad && \
((kLGSideMenuStatusBarOrientationIsPortrait && (self.leftViewStatusBarVisibleOptions & LGSideMenuStatusBarVisibleOnPadPortrait)) || \
(kLGSideMenuStatusBarOrientationIsLandscape && (self.leftViewStatusBarVisibleOptions & LGSideMenuStatusBarVisibleOnPadLandscape))))))

#define kLGSideMenuIsRightViewStatusBarVisible \
((self.rightViewStatusBarVisibleOptions & LGSideMenuStatusBarVisibleOnAll) || \
((kLGSideMenuDeviceIsPhone && \
((kLGSideMenuStatusBarOrientationIsPortrait && (self.rightViewStatusBarVisibleOptions & LGSideMenuStatusBarVisibleOnPhonePortrait)) || \
(kLGSideMenuStatusBarOrientationIsLandscape && (self.rightViewStatusBarVisibleOptions & LGSideMenuStatusBarVisibleOnPhoneLandscape)))) || \
(kLGSideMenuDeviceIsPad && \
((kLGSideMenuStatusBarOrientationIsPortrait && (self.rightViewStatusBarVisibleOptions & LGSideMenuStatusBarVisibleOnPadPortrait)) || \
(kLGSideMenuStatusBarOrientationIsLandscape && (self.rightViewStatusBarVisibleOptions & LGSideMenuStatusBarVisibleOnPadLandscape))))))

@interface LGSideMenuView : UIView

@property (strong, nonatomic) void (^layoutSubviewsHandler)();

@end

@implementation LGSideMenuView

- (instancetype)initWithLayoutSubviewsHandler:(LGSideMenuControllerCompletionHandler)layoutSubviewsHandler
{
    self = [super init];
    if (self)
    {
        self.layoutSubviewsHandler = layoutSubviewsHandler;
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];

    if (self.layoutSubviewsHandler) self.layoutSubviewsHandler();
}

@end

#pragma mark -

@interface LGSideMenuController () <UIGestureRecognizerDelegate>

@property (assign, nonatomic, readwrite) CGFloat leftViewWidth;
@property (assign, nonatomic, readwrite) CGFloat rightViewWidth;

@property (assign, nonatomic, readwrite) LGSideMenuPresentationStyle leftViewPresentationStyle;
@property (assign, nonatomic, readwrite) LGSideMenuPresentationStyle rightViewPresentationStyle;

@property (assign, nonatomic, readwrite) LGSideMenuAlwaysVisibleOptions leftViewAlwaysVisibleOptions;
@property (assign, nonatomic, readwrite) LGSideMenuAlwaysVisibleOptions rightViewAlwaysVisibleOptions;

@property (assign, nonatomic, readwrite, getter=isLeftViewShowing)  BOOL leftViewShowing;
@property (assign, nonatomic, readwrite, getter=isRightViewShowing) BOOL rightViewShowing;

@property (assign, nonatomic) CGSize savedSize;

@property (strong, nonatomic) UIViewController *rootVC;
@property (strong, nonatomic) LGSideMenuView *leftView;
@property (strong, nonatomic) LGSideMenuView *rightView;

@property (strong, nonatomic) UIView *rootViewCoverViewForLeftView;
@property (strong, nonatomic) UIView *rootViewCoverViewForRightView;

@property (strong, nonatomic) UIView *leftViewCoverView;
@property (strong, nonatomic) UIView *rightViewCoverView;

@property (strong, nonatomic) UIImageView *backgroundImageViewForLeftView;
@property (strong, nonatomic) UIImageView *backgroundImageViewForRightView;

@property (strong, nonatomic) UIView *rootViewStyleView;
@property (strong, nonatomic) UIView *leftViewStyleView;
@property (strong, nonatomic) UIView *rightViewStyleView;

@property (assign, nonatomic) BOOL savedStatusBarHidden;
@property (assign, nonatomic) UIStatusBarStyle savedStatusBarStyle;
@property (assign, nonatomic, getter=isWaitingForUpdateStatusBar) BOOL waitingForUpdateStatusBar;

@property (assign, nonatomic) BOOL currentShouldAutorotate;
@property (assign, nonatomic) BOOL currentPreferredStatusBarHidden;
@property (assign, nonatomic) UIStatusBarStyle currentPreferredStatusBarStyle;
@property (assign, nonatomic) UIStatusBarAnimation currentPreferredStatusBarUpdateAnimation;

@property (strong, nonatomic) NSNumber *leftViewGestireStartX;
@property (strong, nonatomic) NSNumber *rightViewGestireStartX;

@property (assign, nonatomic, getter=isLeftViewShowingBeforeGesture) BOOL leftViewShowingBeforeGesture;
@property (assign, nonatomic, getter=isRightViewShowingBeforeGesture) BOOL rightViewShowingBeforeGesture;

@property (strong, nonatomic) UIPanGestureRecognizer *panGesture;

@property (assign, nonatomic, getter=isUserRootViewScaleForLeftView) BOOL userRootViewScaleForLeftView;
@property (assign, nonatomic, getter=isUserRootViewCoverColorForLeftView) BOOL userRootViewCoverColorForLeftView;
@property (assign, nonatomic, getter=isUserLeftViewCoverColor) BOOL userLeftViewCoverColor;
@property (assign, nonatomic, getter=isUserLeftViewBackgroundImageInitialScale) BOOL userLeftViewBackgroundImageInitialScale;
@property (assign, nonatomic, getter=isUserLeftViewInititialScale) BOOL userLeftViewInititialScale;
@property (assign, nonatomic, getter=isUserLeftViewInititialOffsetX) BOOL userLeftViewInititialOffsetX;

@property (assign, nonatomic, getter=isUserRootViewScaleForRightView) BOOL userRootViewScaleForRightView;
@property (assign, nonatomic, getter=isUserRootViewCoverColorForRightView) BOOL userRootViewCoverColorForRightView;
@property (assign, nonatomic, getter=isUserRightViewCoverColor) BOOL userRightViewCoverColor;
@property (assign, nonatomic, getter=isUserRightViewBackgroundImageInitialScale) BOOL userRightViewBackgroundImageInitialScale;
@property (assign, nonatomic, getter=isUserRightViewInititialScale) BOOL userRightViewInititialScale;
@property (assign, nonatomic, getter=isUserRightViewInititialOffsetX) BOOL userRightViewInititialOffsetX;

@end

@implementation LGSideMenuController

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
        [self setRootViewController:rootViewController];

        [self setupDefaultProperties];
        [self setupDefaults];
    }
    return self;
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

- (void)setupDefaultProperties {
    self.leftViewAnimationSpeed = 0.5;
    self.rightViewAnimationSpeed = 0.5;

    self.leftViewHidesOnTouch = YES;
    self.rightViewHidesOnTouch = YES;

    self.leftViewSwipeGestureEnabled = YES;
    self.rightViewSwipeGestureEnabled = YES;

    self.rootViewLayerShadowColor = [UIColor colorWithWhite:0.0 alpha:0.5];
    self.rootViewLayerShadowRadius = 5.0;

    self.leftViewLayerShadowColor = [UIColor colorWithWhite:0.0 alpha:0.5];
    self.leftViewLayerShadowRadius = 5.0;

    self.rightViewLayerShadowColor = [UIColor colorWithWhite:0.0 alpha:0.5];
    self.rightViewLayerShadowRadius = 5.0;
}

- (void)setupDefaults {
    self.view.clipsToBounds = YES;

    // -----

    self.shouldShowLeftView = YES;
    self.shouldShowRightView = YES;

    // -----

    self.backgroundImageViewForLeftView = [UIImageView new];
    self.backgroundImageViewForLeftView.hidden = YES;
    self.backgroundImageViewForLeftView.contentMode = UIViewContentModeScaleAspectFill;
    self.backgroundImageViewForLeftView.backgroundColor = [UIColor clearColor];
    self.backgroundImageViewForLeftView.clipsToBounds = YES;
    [self.view addSubview:self.backgroundImageViewForLeftView];

    self.backgroundImageViewForRightView = [UIImageView new];
    self.backgroundImageViewForRightView.hidden = YES;
    self.backgroundImageViewForRightView.contentMode = UIViewContentModeScaleAspectFill;
    self.backgroundImageViewForRightView.backgroundColor = [UIColor clearColor];
    self.backgroundImageViewForRightView.clipsToBounds = YES;
    [self.view addSubview:self.backgroundImageViewForRightView];

    // -----

    self.rootViewStyleView = [UIView new];
    self.rootViewStyleView.hidden = YES;
    self.rootViewStyleView.backgroundColor = [UIColor blackColor];
    self.rootViewStyleView.layer.masksToBounds = NO;
    self.rootViewStyleView.layer.shadowOffset = CGSizeZero;
    self.rootViewStyleView.layer.shadowOpacity = 1.0;
    self.rootViewStyleView.layer.shouldRasterize = YES;
    [self.view addSubview:self.rootViewStyleView];

    if (self.rootVC) {
        [self addChildViewController:self.rootVC];
        [self.view addSubview:self.rootVC.view];
    }

    // -----

    self.gesturesCancelsTouchesInView = YES;

    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesture:)];
    tapGesture.delegate = self;
    tapGesture.numberOfTapsRequired = 1;
    tapGesture.numberOfTouchesRequired = 1;
    tapGesture.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapGesture];

    self.panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGesture:)];
    self.panGesture.minimumNumberOfTouches = 1;
    self.panGesture.maximumNumberOfTouches = 1;
    self.panGesture.cancelsTouchesInView = YES;
    [self.view addGestureRecognizer:self.panGesture];
}

#pragma mark - Appearing

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];

    CGSize size = self.view.frame.size;

    if (!CGSizeEqualToSize(self.savedSize, size)) {
        BOOL appeared = !CGSizeEqualToSize(self.savedSize, CGSizeZero);

        self.savedSize = size;

        // -----

        [self colorsInvalidate];
        [self rootViewLayoutInvalidateWithPercentage:(self.isLeftViewShowing || self.isRightViewShowing ? 1.0 : 0.0)];
        [self leftViewLayoutInvalidateWithPercentage:(self.isLeftViewShowing ? 1.0 : 0.0)];
        [self rightViewLayoutInvalidateWithPercentage:(self.isRightViewShowing ? 1.0 : 0.0)];
        [self hiddensInvalidateWithDelay:(appeared ? 0.25 : 0.0)];
    }
}

#pragma mark -

- (BOOL)shouldAutorotate {
    if (kLGSideMenuIsMenuShowing) {
        return self.currentShouldAutorotate;
    }
    else {
        return self.rootVC ? self.rootVC.shouldAutorotate : YES;
    }
}

- (BOOL)prefersStatusBarHidden {
    if (kLGSideMenuIsMenuShowing) {
        return self.currentPreferredStatusBarHidden;
    }
    else {
        if (self.rootVC) {
            return self.rootVC.prefersStatusBarHidden;
        }
        else {
            return (UIInterfaceOrientationIsLandscape([UIApplication sharedApplication].statusBarOrientation) && UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone);
        }
    }
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    if (kLGSideMenuIsMenuShowing) {
        return self.currentPreferredStatusBarStyle;
    }
    else {
        return self.rootVC ? self.rootVC.preferredStatusBarStyle : UIStatusBarStyleDefault;
    }
}

- (UIStatusBarAnimation)preferredStatusBarUpdateAnimation {
    UIStatusBarAnimation animation = UIStatusBarAnimationNone;

    if (self.isWaitingForUpdateStatusBar) {
        self.waitingForUpdateStatusBar = NO;

        animation = self.currentPreferredStatusBarUpdateAnimation;
    }
    else if (self.rootVC) {
        animation = self.rootVC.preferredStatusBarUpdateAnimation;
    }

    return animation;
}

#if __IPHONE_OS_VERSION_MIN_REQUIRED < __IPHONE_9_0
- (void)statusBarAppearanceUpdate {
    if (![[[NSBundle mainBundle] objectForInfoDictionaryKey:@"UIViewControllerBasedStatusBarAppearance"] boolValue]) {
        [[UIApplication sharedApplication] setStatusBarHidden:self.currentPreferredStatusBarHidden withAnimation:self.currentPreferredStatusBarUpdateAnimation];
        [[UIApplication sharedApplication] setStatusBarStyle:self.currentPreferredStatusBarStyle animated:self.currentPreferredStatusBarUpdateAnimation];
    }
}
#endif

#pragma mark - Setters and Getters

- (void)setRootViewScaleForLeftView:(CGFloat)rootViewScaleForLeftView {
    _rootViewScaleForLeftView = rootViewScaleForLeftView;
    self.userRootViewScaleForLeftView = YES;
}

- (void)setRootViewScaleForRightView:(CGFloat)rootViewScaleForRightView {
    _rootViewScaleForRightView = rootViewScaleForRightView;
    self.userRootViewScaleForRightView = YES;
}

- (void)setRootViewCoverColorForLeftView:(UIColor *)rootViewCoverColorForLeftView {
    _rootViewCoverColorForLeftView = rootViewCoverColorForLeftView;
    self.userRootViewCoverColorForLeftView = YES;
}

- (void)setRootViewCoverColorForRightView:(UIColor *)rootViewCoverColorForRightView {
    _rootViewCoverColorForRightView = rootViewCoverColorForRightView;
    self.userRootViewCoverColorForRightView = YES;
}

- (void)setLeftViewCoverColor:(UIColor *)leftViewCoverColor {
    _leftViewCoverColor = leftViewCoverColor;
    self.userLeftViewCoverColor = YES;
}

- (void)setRightViewCoverColor:(UIColor *)rightViewCoverColor {
    _rightViewCoverColor = rightViewCoverColor;
    self.userRightViewCoverColor = YES;
}

- (void)setLeftViewBackgroundImageInitialScale:(CGFloat)leftViewBackgroundImageInitialScale {
    _leftViewBackgroundImageInitialScale = leftViewBackgroundImageInitialScale;
    self.userLeftViewBackgroundImageInitialScale = YES;
}

- (void)setRightViewBackgroundImageInitialScale:(CGFloat)rightViewBackgroundImageInitialScale {
    _rightViewBackgroundImageInitialScale = rightViewBackgroundImageInitialScale;
    self.userRightViewBackgroundImageInitialScale = YES;
}

- (void)setLeftViewInititialScale:(CGFloat)leftViewInititialScale {
    _leftViewInititialScale = leftViewInititialScale;
    self.userLeftViewInititialScale = YES;
}

- (void)setRightViewInititialScale:(CGFloat)rightViewInititialScale {
    _rightViewInititialScale = rightViewInititialScale;
    self.userRightViewInititialScale = YES;
}

- (void)setLeftViewInititialOffsetX:(CGFloat)leftViewInititialOffsetX {
    _leftViewInititialOffsetX = leftViewInititialOffsetX;
    self.userLeftViewInititialOffsetX = YES;
}

- (void)setRightViewInititialOffsetX:(CGFloat)rightViewInititialOffsetX {
    _rightViewInititialOffsetX = rightViewInititialOffsetX;
    self.userRightViewInititialOffsetX = YES;
}

- (void)setGesturesCancelsTouchesInView:(BOOL)gesturesCancelsTouchesInView {
    _gesturesCancelsTouchesInView = gesturesCancelsTouchesInView;
    self.panGesture.cancelsTouchesInView = gesturesCancelsTouchesInView;
}

- (void)setRootViewController:(UIViewController *)rootViewController {
    if (!rootViewController) return;

    // -----

    if (self.rootVC) {
        [self.rootVC.view removeFromSuperview];
        [self.rootVC removeFromParentViewController];
    }

    self.rootVC = rootViewController;

    [self addChildViewController:self.rootVC];
    [self.view addSubview:self.rootVC.view];

    // -----

    if (self.leftView) {
        [self.view addSubview:self.rootViewCoverViewForLeftView];

        if (self.leftViewPresentationStyle == LGSideMenuPresentationStyleSlideAbove) {
            [self.view addSubview:self.leftView];
            [self.view insertSubview:self.leftViewStyleView belowSubview:self.leftView];
        }
        else {
            [self.view insertSubview:self.leftView belowSubview:self.rootVC.view];
            [self.view insertSubview:self.leftViewCoverView aboveSubview:self.leftView];
        }
    }

    if (self.rightView) {
        [self.view addSubview:self.rootViewCoverViewForRightView];

        if (self.rightViewPresentationStyle == LGSideMenuPresentationStyleSlideAbove) {
            [self.view addSubview:self.rightView];
            [self.view insertSubview:self.rightViewStyleView belowSubview:self.rightView];
        }
        else {
            [self.view insertSubview:self.rightView belowSubview:self.rootVC.view];
            [self.view insertSubview:self.rightViewCoverView aboveSubview:self.rightView];
        }
    }

    // -----

    [self rootViewLayoutInvalidateWithPercentage:(self.isLeftViewShowing || self.isRightViewShowing ? 1.0 : 0.0)];
}

- (nullable UIViewController *)rootViewController {
    return self.rootVC;
}

- (nullable UIView *)leftView {
    return _leftView;
}

- (nullable UIView *)rightView {
    return _rightView;
}

- (BOOL)isLeftViewAlwaysVisible {
    return kLGSideMenuIsLeftViewAlwaysVisible;
}

- (BOOL)isRightViewAlwaysVisible {
    return kLGSideMenuIsRightViewAlwaysVisible;
}

- (BOOL)isLeftViewAlwaysVisibleForInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return kLGSideMenuIsLeftViewAlwaysVisibleForInterfaceOrientation(interfaceOrientation);
}

- (BOOL)isRightViewAlwaysVisibleForInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return kLGSideMenuIsRightViewAlwaysVisibleForInterfaceOrientation(interfaceOrientation);
}

#pragma mark - Layout Subviews

- (void)leftViewWillLayoutSubviewsWithSize:(CGSize)size {
    // override this method
}

- (void)rightViewWillLayoutSubviewsWithSize:(CGSize)size {
    // override this method
}

#pragma mark -

- (void)rootViewLayoutInvalidateWithPercentage:(CGFloat)percentage {
    self.rootVC.view.transform = CGAffineTransformIdentity;
    self.rootViewStyleView.transform = CGAffineTransformIdentity;

    if (self.rootViewCoverViewForLeftView) {
        self.rootViewCoverViewForLeftView.transform = CGAffineTransformIdentity;
    }

    if (self.rootViewCoverViewForRightView) {
        self.rootViewCoverViewForRightView.transform = CGAffineTransformIdentity;
    }

    // -----

    CGSize size = self.view.frame.size;

    CGRect rootViewViewFrame = CGRectMake(0.0, 0.0, size.width, size.height);
    CGAffineTransform transform = CGAffineTransformIdentity;

    BOOL leftViewAlwaysVisible = NO;
    BOOL rightViewAlwaysVisible = NO;

    if (kLGSideMenuIsLeftViewAlwaysVisible) {
        leftViewAlwaysVisible = YES;

        rootViewViewFrame.origin.x += self.leftViewWidth;
        rootViewViewFrame.size.width -= self.leftViewWidth;
    }

    if (kLGSideMenuIsRightViewAlwaysVisible) {
        rightViewAlwaysVisible = YES;

        rootViewViewFrame.size.width -= self.rightViewWidth;
    }

    if (!leftViewAlwaysVisible && !rightViewAlwaysVisible) {
        if (self.isLeftViewShowing && self.leftViewPresentationStyle != LGSideMenuPresentationStyleSlideAbove) {
            CGFloat rootViewScale = 1.0+(self.rootViewScaleForLeftView-1.0)*percentage;

            transform = CGAffineTransformMakeScale(rootViewScale, rootViewScale);

            CGFloat shift = size.width*(1.0-rootViewScale)/2;

            rootViewViewFrame = CGRectMake((self.leftViewWidth-shift)*percentage, 0.0, size.width, size.height);
            if ([UIScreen mainScreen].scale == 1.0)
                rootViewViewFrame = CGRectIntegral(rootViewViewFrame);
        }
        else if (self.isRightViewShowing && self.rightViewPresentationStyle != LGSideMenuPresentationStyleSlideAbove) {
            CGFloat rootViewScale = 1.0+(self.rootViewScaleForRightView-1.0)*percentage;

            transform = CGAffineTransformMakeScale(rootViewScale, rootViewScale);

            CGFloat shift = size.width*(1.0-rootViewScale)/2;

            rootViewViewFrame = CGRectMake(-(self.rightViewWidth-shift)*percentage, 0.0, size.width, size.height);
            if ([UIScreen mainScreen].scale == 1.0)
                rootViewViewFrame = CGRectIntegral(rootViewViewFrame);
        }
    }

    self.rootVC.view.frame = rootViewViewFrame;
    self.rootVC.view.transform = transform;

    // -----

    CGFloat borderWidth = self.rootViewStyleView.layer.borderWidth;
    self.rootViewStyleView.frame = CGRectMake(rootViewViewFrame.origin.x-borderWidth,
                                              rootViewViewFrame.origin.y-borderWidth,
                                              rootViewViewFrame.size.width+borderWidth*2,
                                              rootViewViewFrame.size.height+borderWidth*2);
    self.rootViewStyleView.transform = transform;

    // -----

    if (self.leftView) {
        self.rootViewCoverViewForLeftView.frame = rootViewViewFrame;
        self.rootViewCoverViewForLeftView.transform = transform;
    }

    if (self.rightView) {
        self.rootViewCoverViewForRightView.frame = rootViewViewFrame;
        self.rootViewCoverViewForRightView.transform = transform;
    }
}

- (void)leftViewLayoutInvalidateWithPercentage:(CGFloat)percentage {
    if (!self.leftView) return;

    // -----

    CGSize size = self.view.frame.size;

    // -----

    self.leftView.transform = CGAffineTransformIdentity;
    self.backgroundImageViewForLeftView.transform = CGAffineTransformIdentity;
    self.leftViewStyleView.transform = CGAffineTransformIdentity;

    // -----

    CGFloat originX = 0.0;
    CGAffineTransform leftViewTransform = CGAffineTransformIdentity;
    CGAffineTransform backgroundViewTransform = CGAffineTransformIdentity;

    if (!kLGSideMenuIsLeftViewAlwaysVisible) {
        self.rootViewCoverViewForLeftView.alpha = percentage;
        self.leftViewCoverView.alpha = 1.0-percentage;

        if (self.leftViewPresentationStyle == LGSideMenuPresentationStyleSlideAbove) {
            originX = -(self.leftViewWidth+self.leftViewStyleView.layer.shadowRadius*2)*(1.0-percentage);
        }
        else {
            CGFloat leftViewScale = 1.0+(self.leftViewInititialScale-1.0)*(1.0-percentage);
            CGFloat backgroundViewScale = 1.0+(self.leftViewBackgroundImageInitialScale-1.0)*(1.0-percentage);

            leftViewTransform = CGAffineTransformMakeScale(leftViewScale, leftViewScale);
            backgroundViewTransform = CGAffineTransformMakeScale(backgroundViewScale, backgroundViewScale);

            originX = (-(self.leftViewWidth*(1.0-leftViewScale)/2)+(self.leftViewInititialOffsetX*leftViewScale))*(1.0-percentage);
        }
    }

    // -----

    CGRect leftViewFrame = CGRectMake(originX, 0.0, self.leftViewWidth, size.height);

    if ([UIScreen mainScreen].scale == 1.0) {
        leftViewFrame = CGRectIntegral(leftViewFrame);
    }

    self.leftView.frame = leftViewFrame;

    self.leftView.transform = leftViewTransform;

    // -----

    if (self.leftViewPresentationStyle != LGSideMenuPresentationStyleSlideAbove) {
        CGRect backgroundViewFrame = CGRectMake(0.0, 0.0, size.width, size.height);

        if (kLGSideMenuIsLeftViewAlwaysVisible && kLGSideMenuIsRightViewAlwaysVisible) {
            CGFloat multiplier = self.rightViewWidth/self.leftViewWidth;

            backgroundViewFrame.size.width = (size.width/(multiplier+1.0));
        }

        if ([UIScreen mainScreen].scale == 1.0) {
            backgroundViewFrame = CGRectIntegral(backgroundViewFrame);
        }

        self.backgroundImageViewForLeftView.frame = backgroundViewFrame;

        self.backgroundImageViewForLeftView.transform = backgroundViewTransform;

        // -----

        if (self.leftViewCoverView) {
            CGRect leftViewCoverViewFrame = CGRectMake(0.0, 0.0, size.width, size.height);

            if ([UIScreen mainScreen].scale == 1.0) {
                leftViewCoverViewFrame = CGRectIntegral(leftViewCoverViewFrame);
            }

            self.leftViewCoverView.frame = leftViewCoverViewFrame;
        }
    }
    else {
        CGFloat borderWidth = self.leftViewStyleView.layer.borderWidth;
        self.leftViewStyleView.frame = CGRectMake(leftViewFrame.origin.x-borderWidth,
                                                  leftViewFrame.origin.y-borderWidth,
                                                  leftViewFrame.size.width+borderWidth*2,
                                                  leftViewFrame.size.height+borderWidth*2);
        self.leftViewStyleView.transform = leftViewTransform;
    }
}

- (void)rightViewLayoutInvalidateWithPercentage:(CGFloat)percentage {
    if (!self.rightView) return;

    // -----

    CGSize size = self.view.frame.size;

    // -----

    self.rightView.transform = CGAffineTransformIdentity;
    self.backgroundImageViewForRightView.transform = CGAffineTransformIdentity;
    self.rightViewStyleView.transform = CGAffineTransformIdentity;

    // -----

    CGFloat originX = size.width-self.rightViewWidth;
    CGAffineTransform rightViewTransform = CGAffineTransformIdentity;
    CGAffineTransform backgroundViewTransform = CGAffineTransformIdentity;

    if (!kLGSideMenuIsRightViewAlwaysVisible) {
        self.rootViewCoverViewForRightView.alpha = percentage;
        self.rightViewCoverView.alpha = 1.0-percentage;

        if (self.rightViewPresentationStyle == LGSideMenuPresentationStyleSlideAbove) {
            originX = size.width-self.rightViewWidth+(self.rightViewWidth+self.rightViewStyleView.layer.shadowRadius*2)*(1.0-percentage);
        }
        else {
            CGFloat rightViewScale = 1.0+(self.rightViewInititialScale-1.0)*(1.0-percentage);
            CGFloat backgroundViewScale = 1.0+(self.rightViewBackgroundImageInitialScale-1.0)*(1.0-percentage);

            rightViewTransform = CGAffineTransformMakeScale(rightViewScale, rightViewScale);
            backgroundViewTransform = CGAffineTransformMakeScale(backgroundViewScale, backgroundViewScale);

            originX = size.width-self.rightViewWidth+((self.rightViewWidth*(1.0-rightViewScale)/2)+(self.rightViewInititialOffsetX*rightViewScale))*(1.0-percentage);
        }
    }

    // -----

    CGRect rightViewFrame = CGRectMake(originX, 0.0, self.rightViewWidth, size.height);

    if ([UIScreen mainScreen].scale == 1.0) {
        rightViewFrame = CGRectIntegral(rightViewFrame);
    }

    self.rightView.frame = rightViewFrame;

    self.rightView.transform = rightViewTransform;

    // -----

    if (self.rightViewPresentationStyle != LGSideMenuPresentationStyleSlideAbove) {
        CGRect backgroundViewFrame = CGRectMake(0.0, 0.0, size.width, size.height);

        if (kLGSideMenuIsLeftViewAlwaysVisible && kLGSideMenuIsRightViewAlwaysVisible) {
            CGFloat multiplier = self.leftViewWidth/self.rightViewWidth;

            backgroundViewFrame.size.width = (size.width/(multiplier+1.0));
            backgroundViewFrame.origin.x = size.width - backgroundViewFrame.size.width;
        }

        if ([UIScreen mainScreen].scale == 1.0) {
            backgroundViewFrame = CGRectIntegral(backgroundViewFrame);
        }

        self.backgroundImageViewForRightView.frame = backgroundViewFrame;

        self.backgroundImageViewForRightView.transform = backgroundViewTransform;

        // -----

        if (self.rightViewCoverView) {
            CGRect rightViewCoverViewFrame = CGRectMake(0.0, 0.0, size.width, size.height);

            if ([UIScreen mainScreen].scale == 1.0) {
                rightViewCoverViewFrame = CGRectIntegral(rightViewCoverViewFrame);
            }

            self.rightViewCoverView.frame = rightViewCoverViewFrame;
        }
    }
    else {
        CGFloat borderWidth = self.rightViewStyleView.layer.borderWidth;
        self.rightViewStyleView.frame = CGRectMake(rightViewFrame.origin.x-borderWidth,
                                                   rightViewFrame.origin.y-borderWidth,
                                                   rightViewFrame.size.width+borderWidth*2,
                                                   rightViewFrame.size.height+borderWidth*2);
        self.rightViewStyleView.transform = rightViewTransform;
    }
}

- (void)colorsInvalidate {
    if (self.rootViewStyleView) {
        self.rootViewStyleView.layer.borderWidth = self.rootViewLayerBorderWidth;
        self.rootViewStyleView.layer.borderColor = self.rootViewLayerBorderColor.CGColor;
        self.rootViewStyleView.layer.shadowColor = self.rootViewLayerShadowColor.CGColor;
        self.rootViewStyleView.layer.shadowRadius = self.rootViewLayerShadowRadius;
    }

    if (kLGSideMenuIsLeftViewAlwaysVisible || self.isLeftViewShowing) {
        self.view.backgroundColor = [self.leftViewBackgroundColor colorWithAlphaComponent:1.0];

        self.rootViewCoverViewForLeftView.backgroundColor = self.rootViewCoverColorForLeftView;

        if (self.leftViewCoverView) {
            self.leftViewCoverView.backgroundColor = self.leftViewCoverColor;
        }

        if (self.leftViewStyleView) {
            self.leftViewStyleView.backgroundColor = kLGSideMenuIsLeftViewAlwaysVisible ? [self.leftViewBackgroundColor colorWithAlphaComponent:1.0] : self.leftViewBackgroundColor;
            self.leftViewStyleView.layer.borderWidth = self.leftViewLayerBorderWidth;
            self.leftViewStyleView.layer.borderColor = self.leftViewLayerBorderColor.CGColor;
            self.leftViewStyleView.layer.shadowColor = self.leftViewLayerShadowColor.CGColor;
            self.leftViewStyleView.layer.shadowRadius = self.leftViewLayerShadowRadius;
        }

        if (self.leftViewBackgroundImage) {
            self.backgroundImageViewForLeftView.image = self.leftViewBackgroundImage;
        }
    }

    if (kLGSideMenuIsRightViewAlwaysVisible || self.isRightViewShowing) {
        self.view.backgroundColor = [self.rightViewBackgroundColor colorWithAlphaComponent:1.0];

        self.rootViewCoverViewForRightView.backgroundColor = self.rootViewCoverColorForRightView;

        if (self.rightViewCoverView) {
            self.rightViewCoverView.backgroundColor = self.rightViewCoverColor ? self.rightViewCoverColor : kLGSideMenuCoverColor;
        }

        if (self.rightViewStyleView) {
            self.rightViewStyleView.backgroundColor = kLGSideMenuIsRightViewAlwaysVisible ? [self.rightViewBackgroundColor colorWithAlphaComponent:1.0] : self.rightViewBackgroundColor;
            self.rightViewStyleView.layer.borderWidth = self.rightViewLayerBorderWidth;
            self.rightViewStyleView.layer.borderColor = self.rightViewLayerBorderColor.CGColor;
            self.rightViewStyleView.layer.shadowColor = self.rightViewLayerShadowColor.CGColor;
            self.rightViewStyleView.layer.shadowRadius = self.rightViewLayerShadowRadius;
        }

        if (self.rightViewBackgroundImage) {
            self.backgroundImageViewForRightView.image = self.rightViewBackgroundImage;
        }
    }
}

- (void)hiddensInvalidate {
    [self hiddensInvalidateWithDelay:0.0];
}

- (void)hiddensInvalidateWithDelay:(NSTimeInterval)delay {
    BOOL rootViewStyleViewHiddenForLeftView = YES;
    BOOL rootViewStyleViewHiddenForRightView = YES;

    // -----

    if (kLGSideMenuIsLeftViewAlwaysVisible) {
        self.rootViewCoverViewForLeftView.hidden = YES;
        self.leftViewCoverView.hidden = YES;
        self.leftView.hidden = NO;
        self.leftViewStyleView.hidden = NO;
        self.backgroundImageViewForLeftView.hidden = NO;

        rootViewStyleViewHiddenForLeftView = NO;
    }
    else if (!self.isLeftViewShowing) {
        if (delay) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^(void) {
                self.rootViewCoverViewForLeftView.hidden = YES;
                self.leftViewCoverView.hidden = YES;
                self.leftView.hidden = YES;
                self.leftViewStyleView.hidden = YES;
                self.backgroundImageViewForLeftView.hidden = YES;
            });
        }
        else {
            self.rootViewCoverViewForLeftView.hidden = YES;
            self.leftViewCoverView.hidden = YES;
            self.leftView.hidden = YES;
            self.leftViewStyleView.hidden = YES;
            self.backgroundImageViewForLeftView.hidden = YES;
        }

        rootViewStyleViewHiddenForLeftView = YES;
    }
    else if (self.isLeftViewShowing) {
        self.rootViewCoverViewForLeftView.hidden = NO;
        self.leftViewCoverView.hidden = NO;
        self.leftView.hidden = NO;
        self.leftViewStyleView.hidden = NO;
        self.backgroundImageViewForLeftView.hidden = NO;

        rootViewStyleViewHiddenForLeftView = NO;
    }

    // -----

    if (kLGSideMenuIsRightViewAlwaysVisible) {
        self.rootViewCoverViewForRightView.hidden = YES;
        self.rightViewCoverView.hidden = YES;
        self.rightView.hidden = NO;
        self.rightViewStyleView.hidden = NO;
        self.backgroundImageViewForRightView.hidden = NO;

        rootViewStyleViewHiddenForRightView = NO;
    }
    else if (!self.isRightViewShowing) {
        if (delay) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^(void) {
                self.rootViewCoverViewForRightView.hidden = YES;
                self.rightViewCoverView.hidden = YES;
                self.rightView.hidden = YES;
                self.rightViewStyleView.hidden = YES;
                self.backgroundImageViewForRightView.hidden = YES;
            });
        }
        else {
            self.rootViewCoverViewForRightView.hidden = YES;
            self.rightViewCoverView.hidden = YES;
            self.rightView.hidden = YES;
            self.rightViewStyleView.hidden = YES;
            self.backgroundImageViewForRightView.hidden = YES;
        }

        rootViewStyleViewHiddenForRightView = YES;
    }
    else if (self.isRightViewShowing) {
        self.rootViewCoverViewForRightView.hidden = NO;
        self.rightViewCoverView.hidden = NO;
        self.rightView.hidden = NO;
        self.rightViewStyleView.hidden = NO;
        self.backgroundImageViewForRightView.hidden = NO;

        rootViewStyleViewHiddenForRightView = NO;
    }

    // -----

    if (rootViewStyleViewHiddenForLeftView && rootViewStyleViewHiddenForRightView) {
        if (delay) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^(void) {
                self.rootViewStyleView.hidden = YES;
            });
        }
        else {
            self.rootViewStyleView.hidden = (rootViewStyleViewHiddenForLeftView && rootViewStyleViewHiddenForRightView);
        }
    }
    else {
        self.rootViewStyleView.hidden = NO;
    }
}

#pragma mark - Side Views

- (void)setLeftViewEnabledWithWidth:(CGFloat)width
                  presentationStyle:(LGSideMenuPresentationStyle)presentationStyle
               alwaysVisibleOptions:(LGSideMenuAlwaysVisibleOptions)alwaysVisibleOptions {
    NSAssert(self.leftView == nil, @"Left view already exists");

    // -----

    self.rootViewCoverViewForLeftView = [UIView new];
    self.rootViewCoverViewForLeftView.hidden = YES;

    if (self.rootVC) {
        if (self.rootViewCoverViewForRightView) {
            [self.view insertSubview:self.rootViewCoverViewForLeftView aboveSubview:self.rootViewCoverViewForRightView];
        }
        else {
            [self.view addSubview:self.rootViewCoverViewForLeftView];
        }
    }

    // -----

    __weak typeof(self) wself = self;

    self.leftView = [[LGSideMenuView alloc] initWithLayoutSubviewsHandler:^(void) {
        if (!wself) return;

        __strong typeof(wself) sself = wself;

        [sself leftViewWillLayoutSubviewsWithSize:CGSizeMake(sself.leftViewWidth, CGRectGetHeight(sself.view.frame))];
    }];

    self.leftView.backgroundColor = [UIColor clearColor];
    self.leftView.hidden = YES;

    if (self.rootVC) {
        if (presentationStyle == LGSideMenuPresentationStyleSlideAbove) {
            [self.view addSubview:self.leftView];
        }
        else {
            [self.view insertSubview:self.leftView belowSubview:self.rootVC.view];
        }
    }

    // -----

    self.leftViewWidth = width;

    self.leftViewPresentationStyle = presentationStyle;

    self.leftViewAlwaysVisibleOptions = alwaysVisibleOptions;

    // -----

    if (presentationStyle != LGSideMenuPresentationStyleSlideAbove) {
        self.leftViewCoverView = [UIView new];
        self.leftViewCoverView.hidden = YES;
        [self.view insertSubview:self.leftViewCoverView aboveSubview:self.leftView];
    }
    else {
        self.leftViewStyleView = [UIView new];
        self.leftViewStyleView.hidden = YES;
        self.leftViewStyleView.layer.masksToBounds = NO;
        self.leftViewStyleView.layer.shadowOffset = CGSizeZero;
        self.leftViewStyleView.layer.shadowOpacity = 1.0;
        self.leftViewStyleView.layer.shouldRasterize = YES;
        [self.view insertSubview:self.leftViewStyleView belowSubview:self.leftView];
    }

    // -----

    [self.view insertSubview:self.rootViewStyleView belowSubview:self.rootVC.view];

    // -----

    if (!self.isUserRootViewScaleForLeftView) {
        if (self.leftViewPresentationStyle == LGSideMenuPresentationStyleSlideAbove || self.leftViewPresentationStyle == LGSideMenuPresentationStyleSlideBelow) {
            self.rootViewScaleForLeftView = 1.0;
        }
        else {
            self.rootViewScaleForLeftView = 0.8;
        }
    }

    if (self.leftViewPresentationStyle == LGSideMenuPresentationStyleSlideAbove) {
        if (!self.isUserRootViewCoverColorForLeftView) {
            self.rootViewCoverColorForLeftView = kLGSideMenuCoverColor;
        }
    }
    else {
        if (!self.isUserLeftViewCoverColor) {
            self.leftViewCoverColor = kLGSideMenuCoverColor;
        }
    }

    if (!self.isUserLeftViewBackgroundImageInitialScale) {
        if (self.leftViewPresentationStyle == LGSideMenuPresentationStyleSlideBelow || self.leftViewPresentationStyle == LGSideMenuPresentationStyleSlideAbove) {
            self.leftViewBackgroundImageInitialScale = 1.0;
        }
        else {
            self.leftViewBackgroundImageInitialScale = 1.4;
        }
    }

    if (!self.isUserLeftViewInititialScale) {
        if (self.leftViewPresentationStyle == LGSideMenuPresentationStyleSlideBelow || self.leftViewPresentationStyle == LGSideMenuPresentationStyleSlideAbove) {
            self.leftViewInititialScale = 1.0;
        }
        else if (self.leftViewPresentationStyle == LGSideMenuPresentationStyleScaleFromBig) {
            self.leftViewInititialScale = 1.2;
        }
        else {
            self.leftViewInititialScale = 0.8;
        }
    }

    if (!self.isUserLeftViewInititialOffsetX) {
        if (self.leftViewPresentationStyle == LGSideMenuPresentationStyleSlideBelow) {
            self.leftViewInititialOffsetX = -self.leftViewWidth/2;
        }
    }

    // -----

    [self leftViewLayoutInvalidateWithPercentage:0.0];
}

- (void)setRightViewEnabledWithWidth:(CGFloat)width
                   presentationStyle:(LGSideMenuPresentationStyle)presentationStyle
                alwaysVisibleOptions:(LGSideMenuAlwaysVisibleOptions)alwaysVisibleOptions {
    NSAssert(self.rightView == nil, @"Right view already exists");

    // -----

    self.rootViewCoverViewForRightView = [UIView new];
    self.rootViewCoverViewForRightView.hidden = YES;

    if (self.rootVC) {
        if (self.rootViewCoverViewForLeftView) {
            [self.view insertSubview:self.rootViewCoverViewForRightView aboveSubview:self.rootViewCoverViewForLeftView];
        }
        else {
            [self.view addSubview:self.rootViewCoverViewForRightView];
        }
    }

    // -----

    __weak typeof(self) wself = self;

    self.rightView = [[LGSideMenuView alloc] initWithLayoutSubviewsHandler:^(void) {
        if (!wself) return;

        __strong typeof(wself) sself = wself;

        [sself rightViewWillLayoutSubviewsWithSize:CGSizeMake(sself.rightViewWidth, CGRectGetHeight(self.view.frame))];
    }];

    self.rightView.backgroundColor = [UIColor clearColor];
    self.rightView.hidden = YES;

    if (self.rootVC) {
        if (presentationStyle == LGSideMenuPresentationStyleSlideAbove) {
            [self.view addSubview:self.rightView];
        }
        else {
            [self.view insertSubview:self.rightView belowSubview:self.rootVC.view];
        }
    }

    // -----

    self.rightViewWidth = width;

    self.rightViewPresentationStyle = presentationStyle;

    self.rightViewAlwaysVisibleOptions = alwaysVisibleOptions;

    // -----

    if (presentationStyle != LGSideMenuPresentationStyleSlideAbove) {
        self.rightViewCoverView = [UIView new];
        self.rightViewCoverView.hidden = YES;
        [self.view insertSubview:self.rightViewCoverView aboveSubview:self.rightView];
    }
    else {
        self.rightViewStyleView = [UIView new];
        self.rightViewStyleView.hidden = YES;
        self.rightViewStyleView.backgroundColor = [UIColor colorWithWhite:0.3 alpha:0.9];
        self.rightViewStyleView.layer.masksToBounds = NO;
        self.rightViewStyleView.layer.borderWidth = 2.0;
        self.rightViewStyleView.layer.borderColor = [UIColor colorWithRed:0.0 green:0.5 blue:1.0 alpha:1.0].CGColor;
        self.rightViewStyleView.layer.shadowColor = [UIColor colorWithWhite:0.0 alpha:0.5].CGColor;
        self.rightViewStyleView.layer.shadowOffset = CGSizeZero;
        self.rightViewStyleView.layer.shadowOpacity = 1.0;
        self.rightViewStyleView.layer.shadowRadius = 5.0;
        self.rightViewStyleView.layer.shouldRasterize = YES;
        [self.view insertSubview:self.rightViewStyleView belowSubview:self.rightView];
    }

    // -----

    [self.view insertSubview:self.rootViewStyleView belowSubview:self.rootVC.view];

    // -----

    if (!self.isUserRootViewScaleForRightView) {
        if (self.rightViewPresentationStyle == LGSideMenuPresentationStyleSlideAbove || self.rightViewPresentationStyle == LGSideMenuPresentationStyleSlideBelow) {
            self.rootViewScaleForRightView = 1.0;
        }
        else {
            self.rootViewScaleForRightView = 0.8;
        }
    }

    if (self.rightViewPresentationStyle == LGSideMenuPresentationStyleSlideAbove) {
        if (!self.isUserRootViewCoverColorForRightView) {
            self.rootViewCoverColorForRightView = kLGSideMenuCoverColor;
        }
    }
    else {
        if (!self.isUserRightViewCoverColor) {
            self.rightViewCoverColor = kLGSideMenuCoverColor;
        }
    }

    if (!self.isUserRightViewBackgroundImageInitialScale) {
        if (self.rightViewPresentationStyle == LGSideMenuPresentationStyleSlideBelow || self.rightViewPresentationStyle == LGSideMenuPresentationStyleSlideAbove) {
            self.rightViewBackgroundImageInitialScale = 1.0;
        }
        else {
            self.rightViewBackgroundImageInitialScale = 1.4;
        }
    }

    if (!self.isUserRightViewInititialScale) {
        if (self.rightViewPresentationStyle == LGSideMenuPresentationStyleSlideBelow || self.rightViewPresentationStyle == LGSideMenuPresentationStyleSlideAbove) {
            self.rightViewInititialScale = 1.0;
        }
        else if (self.rightViewPresentationStyle == LGSideMenuPresentationStyleScaleFromBig) {
            self.rightViewInititialScale = 1.2;
        }
        else {
            self.rightViewInititialScale = 0.8;
        }
    }

    if (!self.isUserRightViewInititialOffsetX) {
        if (self.rightViewPresentationStyle == LGSideMenuPresentationStyleSlideBelow) {
            self.rightViewInititialOffsetX = self.rightViewWidth/2;
        }
    }

    // -----

    [self rightViewLayoutInvalidateWithPercentage:0.0];
}

#pragma mark - Show/Hide left view

- (void)showLeftViewPrepare {
    [self.view endEditing:YES];

    self.leftViewShowing = YES;

    // -----

    self.savedStatusBarHidden = kLGSideMenuStatusBarHidden;
    self.savedStatusBarStyle = kLGSideMenuStatusBarStyle;

    [self.rootVC removeFromParentViewController];

    self.currentShouldAutorotate = NO;
    self.currentPreferredStatusBarHidden = (kLGSideMenuStatusBarHidden || !kLGSideMenuIsLeftViewStatusBarVisible);
    self.currentPreferredStatusBarStyle = self.leftViewStatusBarStyle;
    self.currentPreferredStatusBarUpdateAnimation = self.leftViewStatusBarUpdateAnimation;

    self.waitingForUpdateStatusBar = YES;

    [self statusBarAppearanceUpdate];
    [self setNeedsStatusBarAppearanceUpdate];

    // -----

    [self leftViewLayoutInvalidateWithPercentage:0.0];
    [self colorsInvalidate];
    [self hiddensInvalidate];

    [[NSNotificationCenter defaultCenter] postNotificationName:LGSideMenuControllerWillShowLeftViewNotification object:self userInfo:nil];
}

- (void)showLeftViewAnimated:(BOOL)animated fromPercentage:(CGFloat)percentage completionHandler:(LGSideMenuControllerCompletionHandler)completionHandler {
    if (animated) {
        [LGSideMenuController
         animateStandardWithDuration:self.leftViewAnimationSpeed
         animations:^(void) {
             [self rootViewLayoutInvalidateWithPercentage:1.0];
             [self leftViewLayoutInvalidateWithPercentage:1.0];
         }
         completion:^(BOOL finished) {
             if (finished) [self hiddensInvalidate];

             [[NSNotificationCenter defaultCenter] postNotificationName:LGSideMenuControllerDidShowLeftViewNotification object:self userInfo:nil];

             if (completionHandler) completionHandler();
         }];
    }
    else {
        [self rootViewLayoutInvalidateWithPercentage:1.0];
        [self leftViewLayoutInvalidateWithPercentage:1.0];

        [self hiddensInvalidate];

        [[NSNotificationCenter defaultCenter] postNotificationName:LGSideMenuControllerDidShowLeftViewNotification object:self userInfo:nil];

        if (completionHandler) completionHandler();
    }
}

- (void)hideLeftViewAnimated:(BOOL)animated fromPercentage:(CGFloat)percentage completionHandler:(LGSideMenuControllerCompletionHandler)completionHandler {
    [[NSNotificationCenter defaultCenter] postNotificationName:LGSideMenuControllerWillDismissLeftViewNotification object:self userInfo:nil];

    if (animated) {
        [LGSideMenuController
         animateStandardWithDuration:self.leftViewAnimationSpeed
         animations:^(void) {
             [self rootViewLayoutInvalidateWithPercentage:0.0];
             [self leftViewLayoutInvalidateWithPercentage:0.0];
         }
         completion:^(BOOL finished) {
             self.leftViewShowing = NO;

             [self hideLeftViewDone];

             if (finished) [self hiddensInvalidate];

             [[NSNotificationCenter defaultCenter] postNotificationName:LGSideMenuControllerDidDismissLeftViewNotification object:self userInfo:nil];

             if (completionHandler) completionHandler();
         }];
    }
    else {
        [self rootViewLayoutInvalidateWithPercentage:0.0];
        [self leftViewLayoutInvalidateWithPercentage:0.0];
        [self hideLeftViewDone];

        self.leftViewShowing = NO;

        [self hiddensInvalidate];

        [[NSNotificationCenter defaultCenter] postNotificationName:LGSideMenuControllerDidDismissLeftViewNotification object:self userInfo:nil];

        if (completionHandler) completionHandler();
    }
}

- (void)hideLeftViewDone {
    [self addChildViewController:self.rootVC];

    self.currentPreferredStatusBarHidden = self.savedStatusBarHidden;
    self.currentPreferredStatusBarStyle = self.savedStatusBarStyle;

    self.waitingForUpdateStatusBar = YES;

    [self statusBarAppearanceUpdate];
    [self setNeedsStatusBarAppearanceUpdate];
}

- (void)hideLeftViewComleteAfterGesture {
    [[NSNotificationCenter defaultCenter] postNotificationName:LGSideMenuControllerWillDismissLeftViewNotification object:self userInfo:nil];

    self.leftViewShowing = NO;

    [self hideLeftViewDone];
    [self hiddensInvalidate];

    [[NSNotificationCenter defaultCenter] postNotificationName:LGSideMenuControllerDidDismissLeftViewNotification object:self userInfo:nil];
}

#pragma mark -

- (void)showLeftViewAnimated:(BOOL)animated completionHandler:(LGSideMenuControllerCompletionHandler)completionHandler {
    if (!kLGSideMenuIsLeftViewAlwaysVisible && !self.isLeftViewShowing && self.shouldShowLeftView &&
        !(kLGSideMenuIsRightViewAlwaysVisible && self.leftViewPresentationStyle != LGSideMenuPresentationStyleSlideAbove)) {
        [self showLeftViewPrepare];
        [self showLeftViewAnimated:animated fromPercentage:0.0 completionHandler:completionHandler];
    }
}

- (void)hideLeftViewAnimated:(BOOL)animated completionHandler:(LGSideMenuControllerCompletionHandler)completionHandler {
    if (!kLGSideMenuIsLeftViewAlwaysVisible && self.isLeftViewShowing) {
        [self hideLeftViewAnimated:animated fromPercentage:1.0 completionHandler:completionHandler];
    }
}

- (void)toggleLeftViewAnimated:(BOOL)animated completionHandler:(LGSideMenuControllerCompletionHandler)completionHandler {
    if (kLGSideMenuIsLeftViewAlwaysVisible) return;

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

#pragma mark - Show/Hide right view

- (void)showRightViewPrepare {
    [self.view endEditing:YES];

    self.rightViewShowing = YES;

    // -----

    self.savedStatusBarHidden = kLGSideMenuStatusBarHidden;
    self.savedStatusBarStyle = kLGSideMenuStatusBarStyle;

    [self.rootVC removeFromParentViewController];

    self.currentShouldAutorotate = NO;
    self.currentPreferredStatusBarHidden = (kLGSideMenuStatusBarHidden || !kLGSideMenuIsRightViewStatusBarVisible);
    self.currentPreferredStatusBarStyle = self.rightViewStatusBarStyle;
    self.currentPreferredStatusBarUpdateAnimation = self.rightViewStatusBarUpdateAnimation;

    self.waitingForUpdateStatusBar = YES;

    [self statusBarAppearanceUpdate];
    [self setNeedsStatusBarAppearanceUpdate];

    // -----

    [self rightViewLayoutInvalidateWithPercentage:0.0];
    [self colorsInvalidate];
    [self hiddensInvalidate];

    [[NSNotificationCenter defaultCenter] postNotificationName:LGSideMenuControllerWillShowRightViewNotification object:self userInfo:nil];
}

- (void)showRightViewAnimated:(BOOL)animated fromPercentage:(CGFloat)percentage completionHandler:(LGSideMenuControllerCompletionHandler)completionHandler {
    if (animated) {
        [LGSideMenuController
         animateStandardWithDuration:self.rightViewAnimationSpeed
         animations:^(void) {
             [self rootViewLayoutInvalidateWithPercentage:1.0];
             [self rightViewLayoutInvalidateWithPercentage:1.0];
         }
         completion:^(BOOL finished) {
             if (finished) [self hiddensInvalidate];

             [[NSNotificationCenter defaultCenter] postNotificationName:LGSideMenuControllerDidShowRightViewNotification object:self userInfo:nil];

             if (completionHandler) completionHandler();
         }];
    }
    else {
        [self rootViewLayoutInvalidateWithPercentage:1.0];
        [self rightViewLayoutInvalidateWithPercentage:1.0];

        [self hiddensInvalidate];

        [[NSNotificationCenter defaultCenter] postNotificationName:LGSideMenuControllerDidShowRightViewNotification object:self userInfo:nil];

        if (completionHandler) completionHandler();
    }
}

- (void)hideRightViewAnimated:(BOOL)animated fromPercentage:(CGFloat)percentage completionHandler:(LGSideMenuControllerCompletionHandler)completionHandler {
    [[NSNotificationCenter defaultCenter] postNotificationName:LGSideMenuControllerWillDismissRightViewNotification object:self userInfo:nil];

    if (animated) {
        [LGSideMenuController
         animateStandardWithDuration:self.rightViewAnimationSpeed
         animations:^(void) {
             [self rootViewLayoutInvalidateWithPercentage:0.0];
             [self rightViewLayoutInvalidateWithPercentage:0.0];
         }
         completion:^(BOOL finished) {
             self.rightViewShowing = NO;

             [self hideRightViewDone];

             if (finished) [self hiddensInvalidate];

             [[NSNotificationCenter defaultCenter] postNotificationName:LGSideMenuControllerDidDismissRightViewNotification object:self userInfo:nil];

             if (completionHandler) completionHandler();
         }];
    }
    else {
        [self rootViewLayoutInvalidateWithPercentage:0.0];
        [self rightViewLayoutInvalidateWithPercentage:0.0];
        [self hideRightViewDone];

        self.rightViewShowing = NO;

        [self hiddensInvalidate];

        [[NSNotificationCenter defaultCenter] postNotificationName:LGSideMenuControllerDidDismissRightViewNotification object:self userInfo:nil];

        if (completionHandler) completionHandler();
    }
}

- (void)hideRightViewDone {
    [self addChildViewController:self.rootVC];

    self.currentPreferredStatusBarHidden = self.savedStatusBarHidden;
    self.currentPreferredStatusBarStyle = self.savedStatusBarStyle;

    self.waitingForUpdateStatusBar = YES;

    [self statusBarAppearanceUpdate];
    [self setNeedsStatusBarAppearanceUpdate];
}

- (void)hideRightViewComleteAfterGesture {
    [[NSNotificationCenter defaultCenter] postNotificationName:LGSideMenuControllerWillDismissRightViewNotification object:self userInfo:nil];

    self.rightViewShowing = NO;

    [self hideRightViewDone];
    [self hiddensInvalidate];

    [[NSNotificationCenter defaultCenter] postNotificationName:LGSideMenuControllerDidDismissRightViewNotification object:self userInfo:nil];
}

#pragma mark -

- (void)showRightViewAnimated:(BOOL)animated completionHandler:(LGSideMenuControllerCompletionHandler)completionHandler {
    if (!kLGSideMenuIsRightViewAlwaysVisible && !self.isRightViewShowing && self.shouldShowRightView &&
        !(kLGSideMenuIsLeftViewAlwaysVisible && self.rightViewPresentationStyle != LGSideMenuPresentationStyleSlideAbove)) {
        [self showRightViewPrepare];
        [self showRightViewAnimated:animated fromPercentage:0.0 completionHandler:completionHandler];
    }
}

- (void)hideRightViewAnimated:(BOOL)animated completionHandler:(LGSideMenuControllerCompletionHandler)completionHandler {
    if (!kLGSideMenuIsRightViewAlwaysVisible && self.isRightViewShowing) {
        [self hideRightViewAnimated:animated fromPercentage:1.0 completionHandler:completionHandler];
    }
}

- (void)toggleRightViewAnimated:(BOOL)animated completionHandler:(LGSideMenuControllerCompletionHandler)completionHandler {
    if (kLGSideMenuIsRightViewAlwaysVisible) return;

    if (self.isRightViewShowing)
        [self hideRightViewAnimated:animated completionHandler:completionHandler];
    else
        [self showRightViewAnimated:animated completionHandler:completionHandler];
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

#pragma mark - UIGestureRecognizers

- (void)tapGesture:(UITapGestureRecognizer *)gesture {
    [self hideLeftViewAnimated:YES completionHandler:nil];
    [self hideRightViewAnimated:YES completionHandler:nil];
}

- (void)panGesture:(UIPanGestureRecognizer *)gestureRecognizer {
    CGPoint location = [gestureRecognizer locationInView:self.view];
    CGPoint velocity = [gestureRecognizer velocityInView:self.view];

    // -----

    CGSize size = self.view.frame.size;

    // -----

    if (self.leftView && self.isLeftViewSwipeGestureEnabled && !kLGSideMenuIsLeftViewAlwaysVisible && !self.rightViewGestireStartX && !self.isRightViewShowing && self.shouldShowLeftView) {
        if (!self.leftViewGestireStartX && (gestureRecognizer.state == UIGestureRecognizerStateBegan || gestureRecognizer.state == UIGestureRecognizerStateChanged)) {
            CGFloat interactiveX = self.isLeftViewShowing ? self.leftViewWidth : 0.0;
            BOOL velocityDone = self.isLeftViewShowing ? velocity.x < 0.0 : velocity.x > 0.0;

            CGFloat shiftLeft = -44.0;
            CGFloat shiftRight = 0.0;

            if (self.swipeGestureArea == LGSideMenuSwipeGestureAreaBorders) {
                shiftRight = self.isLeftViewShowing ? 22.0 : 44.0;
            }
            else {
                shiftRight = self.rootVC.view.bounds.size.width;
            }

            if (velocityDone && location.x >= interactiveX+shiftLeft && location.x <= interactiveX+shiftRight) {
                self.leftViewGestireStartX = [NSNumber numberWithFloat:location.x];
                self.leftViewShowingBeforeGesture = self.leftViewShowing;

                if (!self.isLeftViewShowing) {
                    [self showLeftViewPrepare];
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
                [self rootViewLayoutInvalidateWithPercentage:percentage];
                [self leftViewLayoutInvalidateWithPercentage:percentage];
            }
            else if (gestureRecognizer.state == UIGestureRecognizerStateEnded && self.leftViewGestireStartX) {
                if ((percentage < 1.0 && velocity.x > 0.0) || (velocity.x == 0.0 && percentage >= 0.5)) {
                    [self showLeftViewAnimated:YES fromPercentage:percentage completionHandler:nil];
                }
                else if ((percentage > 0.0 && velocity.x < 0.0) || (velocity.x == 0.0 && percentage < 0.5)) {
                    [self hideLeftViewAnimated:YES fromPercentage:percentage completionHandler:nil];
                }
                else if (percentage == 0.0) {
                    [self hideLeftViewComleteAfterGesture];
                }
                else if (percentage == 1.0) {
                    [[NSNotificationCenter defaultCenter] postNotificationName:LGSideMenuControllerDidShowLeftViewNotification object:self userInfo:nil];
                }

                self.leftViewGestireStartX = nil;
            }
        }
    }

    // -----

    if (self.rightView && self.isRightViewSwipeGestureEnabled && !kLGSideMenuIsRightViewAlwaysVisible && !self.leftViewGestireStartX && !self.isLeftViewShowing && self.shouldShowRightView) {
        if (!self.rightViewGestireStartX && (gestureRecognizer.state == UIGestureRecognizerStateBegan || gestureRecognizer.state == UIGestureRecognizerStateChanged)) {
            CGFloat interactiveX = self.isRightViewShowing ? size.width-self.rightViewWidth : size.width;
            BOOL velocityDone = self.isRightViewShowing ? velocity.x > 0.0 : velocity.x < 0.0;

            CGFloat shiftLeft = 0.0;
            CGFloat shiftRight = 44.0;

            if (self.swipeGestureArea == LGSideMenuSwipeGestureAreaBorders) {
                shiftLeft = self.isRightViewShowing ? 22.0 : 44.0;
            }
            else {
                shiftLeft = self.rootVC.view.bounds.size.width;
            }

            if (velocityDone && location.x >= interactiveX-shiftLeft && location.x <= interactiveX+shiftRight) {
                self.rightViewGestireStartX = [NSNumber numberWithFloat:location.x];
                self.rightViewShowingBeforeGesture = self.rightViewShowing;

                if (!self.isRightViewShowing) {
                    [self showRightViewPrepare];
                }
            }
        }
        else if (self.rightViewGestireStartX) {
            CGFloat firstVar = 0.0;

            if (self.isRightViewShowingBeforeGesture) {
                firstVar = (location.x-(size.width-self.rightViewWidth))-(self.rightViewWidth-(size.width-self.rightViewGestireStartX.floatValue));
            }
            else {
                firstVar = (location.x-(size.width-self.rightViewWidth))+(size.width-self.rightViewGestireStartX.floatValue);
            }

            CGFloat percentage = 1.0-firstVar/self.rightViewWidth;

            if (percentage < 0.0) {
                percentage = 0.0;
            }
            else if (percentage > 1.0) {
                percentage = 1.0;
            }

            if (gestureRecognizer.state == UIGestureRecognizerStateChanged) {
                [self rootViewLayoutInvalidateWithPercentage:percentage];
                [self rightViewLayoutInvalidateWithPercentage:percentage];
            }
            else if (gestureRecognizer.state == UIGestureRecognizerStateEnded && self.rightViewGestireStartX) {
                if ((percentage < 1.0 && velocity.x < 0.0) || (velocity.x == 0.0 && percentage >= 0.5)) {
                    [self showRightViewAnimated:YES fromPercentage:percentage completionHandler:nil];
                }
                else if ((percentage > 0.0 && velocity.x > 0.0) || (velocity.x == 0.0 && percentage < 0.5)) {
                    [self hideRightViewAnimated:YES fromPercentage:percentage completionHandler:nil];
                }
                else if (percentage == 0.0) {
                    [self hideRightViewComleteAfterGesture];
                }
                else if (percentage == 1.0) {
                    [[NSNotificationCenter defaultCenter] postNotificationName:LGSideMenuControllerDidShowRightViewNotification object:self userInfo:nil];
                }
                
                self.rightViewGestireStartX = nil;
            }
        }
    }
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    return ([touch.view isEqual:self.rootViewCoverViewForLeftView] || [touch.view isEqual:self.rootViewCoverViewForRightView]);
}

#pragma mark - Helpers

+ (void)animateStandardWithDuration:(NSTimeInterval)duration animations:(LGSideMenuControllerCompletionHandler)animations completion:(void(^)(BOOL finished))completion {
    [UIView animateWithDuration:duration
                          delay:0.0
         usingSpringWithDamping:1.0
          initialSpringVelocity:0.5
                        options:0
                     animations:animations
                     completion:completion];
    
}

@end

# pragma mark - Deprecated

@implementation LGSideMenuController (Deprecated)

- (void)showHideLeftViewAnimated:(BOOL)animated completionHandler:(LGSideMenuControllerCompletionHandler)completionHandler {
    [self toggleLeftViewAnimated:animated completionHandler:completionHandler];
}

- (void)showHideRightViewAnimated:(BOOL)animated completionHandler:(LGSideMenuControllerCompletionHandler)completionHandler {
    [self toggleRightViewAnimated:animated completionHandler:completionHandler];
}

@end
