//
//  LGSideMenuController.m
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

#import "LGSideMenuController.h"

#define kLGSideMenuStatusBarOrientationIsPortrait   UIInterfaceOrientationIsPortrait(UIApplication.sharedApplication.statusBarOrientation)
#define kLGSideMenuStatusBarOrientationIsLandscape  UIInterfaceOrientationIsLandscape(UIApplication.sharedApplication.statusBarOrientation)
#define kLGSideMenuStatusBarHidden                  UIApplication.sharedApplication.statusBarHidden
#define kLGSideMenuStatusBarStyle                   UIApplication.sharedApplication.statusBarStyle
#define kLGSideMenuDeviceIsPad                      (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define kLGSideMenuDeviceIsPhone                    (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define kLGSideMenuSystemVersion                    UIDevice.currentDevice.systemVersion.floatValue
#define kLGSideMenuCoverColor                       [UIColor colorWithWhite:0.f alpha:0.5]
#define kLGSideMenuIsMenuShowing                    (self.isLeftViewShowing || self.isRightViewShowing)

#define kLGSideMenuIsLeftViewAlwaysVisible \
((_leftViewAlwaysVisibleOptions & LGSideMenuAlwaysVisibleOnAll) || \
((kLGSideMenuDeviceIsPhone && \
((kLGSideMenuStatusBarOrientationIsPortrait && (_leftViewAlwaysVisibleOptions & LGSideMenuAlwaysVisibleOnPhonePortrait)) || \
(kLGSideMenuStatusBarOrientationIsLandscape && (_leftViewAlwaysVisibleOptions & LGSideMenuAlwaysVisibleOnPhoneLandscape)))) || \
(kLGSideMenuDeviceIsPad && \
((kLGSideMenuStatusBarOrientationIsPortrait && (_leftViewAlwaysVisibleOptions & LGSideMenuAlwaysVisibleOnPadPortrait)) || \
(kLGSideMenuStatusBarOrientationIsLandscape && (_leftViewAlwaysVisibleOptions & LGSideMenuAlwaysVisibleOnPadLandscape))))))

#define kLGSideMenuIsRightViewAlwaysVisible \
((_rightViewAlwaysVisibleOptions & LGSideMenuAlwaysVisibleOnAll) || \
((kLGSideMenuDeviceIsPhone && \
((kLGSideMenuStatusBarOrientationIsPortrait && (_rightViewAlwaysVisibleOptions & LGSideMenuAlwaysVisibleOnPhonePortrait)) || \
(kLGSideMenuStatusBarOrientationIsLandscape && (_rightViewAlwaysVisibleOptions & LGSideMenuAlwaysVisibleOnPhoneLandscape)))) || \
(kLGSideMenuDeviceIsPad && \
((kLGSideMenuStatusBarOrientationIsPortrait && (_rightViewAlwaysVisibleOptions & LGSideMenuAlwaysVisibleOnPadPortrait)) || \
(kLGSideMenuStatusBarOrientationIsLandscape && (_rightViewAlwaysVisibleOptions & LGSideMenuAlwaysVisibleOnPadLandscape))))))

#define kLGSideMenuIsLeftViewAlwaysVisibleForInterfaceOrientation(interfaceOrientation) \
((_leftViewAlwaysVisibleOptions & LGSideMenuAlwaysVisibleOnAll) || \
((kLGSideMenuDeviceIsPhone && \
((UIInterfaceOrientationIsPortrait(interfaceOrientation) && (_leftViewAlwaysVisibleOptions & LGSideMenuAlwaysVisibleOnPhonePortrait)) || \
(UIInterfaceOrientationIsLandscape(interfaceOrientation) && (_leftViewAlwaysVisibleOptions & LGSideMenuAlwaysVisibleOnPhoneLandscape)))) || \
(kLGSideMenuDeviceIsPad && \
((UIInterfaceOrientationIsPortrait(interfaceOrientation) && (_leftViewAlwaysVisibleOptions & LGSideMenuAlwaysVisibleOnPadPortrait)) || \
(UIInterfaceOrientationIsLandscape(interfaceOrientation) && (_leftViewAlwaysVisibleOptions & LGSideMenuAlwaysVisibleOnPadLandscape))))))

#define kLGSideMenuIsRightViewAlwaysVisibleForInterfaceOrientation(interfaceOrientation) \
((_rightViewAlwaysVisibleOptions & LGSideMenuAlwaysVisibleOnAll) || \
((kLGSideMenuDeviceIsPhone && \
((UIInterfaceOrientationIsPortrait(interfaceOrientation) && (_rightViewAlwaysVisibleOptions & LGSideMenuAlwaysVisibleOnPhonePortrait)) || \
(UIInterfaceOrientationIsLandscape(interfaceOrientation) && (_rightViewAlwaysVisibleOptions & LGSideMenuAlwaysVisibleOnPhoneLandscape)))) || \
(kLGSideMenuDeviceIsPad && \
((UIInterfaceOrientationIsPortrait(interfaceOrientation) && (_rightViewAlwaysVisibleOptions & LGSideMenuAlwaysVisibleOnPadPortrait)) || \
(UIInterfaceOrientationIsLandscape(interfaceOrientation) && (_rightViewAlwaysVisibleOptions & LGSideMenuAlwaysVisibleOnPadLandscape))))))

#define kLGSideMenuIsLeftViewStatusBarVisible \
((_leftViewStatusBarVisibleOptions & LGSideMenuStatusBarVisibleOnAll) || \
((kLGSideMenuDeviceIsPhone && \
((kLGSideMenuStatusBarOrientationIsPortrait && (_leftViewStatusBarVisibleOptions & LGSideMenuStatusBarVisibleOnPhonePortrait)) || \
(kLGSideMenuStatusBarOrientationIsLandscape && (_leftViewStatusBarVisibleOptions & LGSideMenuStatusBarVisibleOnPhoneLandscape)))) || \
(kLGSideMenuDeviceIsPad && \
((kLGSideMenuStatusBarOrientationIsPortrait && (_leftViewStatusBarVisibleOptions & LGSideMenuStatusBarVisibleOnPadPortrait)) || \
(kLGSideMenuStatusBarOrientationIsLandscape && (_leftViewStatusBarVisibleOptions & LGSideMenuStatusBarVisibleOnPadLandscape))))))

#define kLGSideMenuIsRightViewStatusBarVisible \
((_rightViewStatusBarVisibleOptions & LGSideMenuStatusBarVisibleOnAll) || \
((kLGSideMenuDeviceIsPhone && \
((kLGSideMenuStatusBarOrientationIsPortrait && (_rightViewStatusBarVisibleOptions & LGSideMenuStatusBarVisibleOnPhonePortrait)) || \
(kLGSideMenuStatusBarOrientationIsLandscape && (_rightViewStatusBarVisibleOptions & LGSideMenuStatusBarVisibleOnPhoneLandscape)))) || \
(kLGSideMenuDeviceIsPad && \
((kLGSideMenuStatusBarOrientationIsPortrait && (_rightViewStatusBarVisibleOptions & LGSideMenuStatusBarVisibleOnPadPortrait)) || \
(kLGSideMenuStatusBarOrientationIsLandscape && (_rightViewStatusBarVisibleOptions & LGSideMenuStatusBarVisibleOnPadLandscape))))))

@interface LGSideMenuView : UIView

@property (strong, nonatomic) void (^layoutSubviewsHandler)();

@end

@implementation LGSideMenuView

- (instancetype)initWithLayoutSubviewsHandler:(void(^)())layoutSubviewsHandler
{
    self = [super init];
    if (self)
    {
        _layoutSubviewsHandler = layoutSubviewsHandler;
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];

    if (_layoutSubviewsHandler) _layoutSubviewsHandler();
}

@end

#pragma mark -

@interface LGSideMenuController () <UIGestureRecognizerDelegate>

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

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        [self setupDefaultProperties];
        [self setupDefaults];
    }
    return self;
}

- (instancetype)initWithRootViewController:(UIViewController *)rootViewController
{
    self = [super init];
    if (self)
    {
        _rootVC = rootViewController;

        [self setupDefaultProperties];
        [self setupDefaults];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        [self setupDefaultProperties];
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];

    [self setupDefaults];
}

- (void)setupDefaultProperties
{
    _leftViewAnimationSpeed = 0.5;
    _rightViewAnimationSpeed = 0.5;

    _leftViewHidesOnTouch = YES;
    _rightViewHidesOnTouch = YES;

    _leftViewSwipeGestureEnabled = YES;
    _rightViewSwipeGestureEnabled = YES;

    _rootViewLayerShadowColor = [UIColor colorWithWhite:0.f alpha:0.5];
    _rootViewLayerShadowRadius = 5.f;

    _leftViewLayerShadowColor = [UIColor colorWithWhite:0.f alpha:0.5];
    _leftViewLayerShadowRadius = 5.f;

    _rightViewLayerShadowColor = [UIColor colorWithWhite:0.f alpha:0.5];
    _rightViewLayerShadowRadius = 5.f;
}

- (void)setupDefaults
{
    self.view.clipsToBounds = YES;

    // -----

    _shouldShowLeftView = YES;
    _shouldShowRightView = YES;

    // -----

    _backgroundImageViewForLeftView = [UIImageView new];
    _backgroundImageViewForLeftView.hidden = YES;
    _backgroundImageViewForLeftView.contentMode = UIViewContentModeScaleAspectFill;
    _backgroundImageViewForLeftView.backgroundColor = [UIColor clearColor];
    _backgroundImageViewForLeftView.clipsToBounds = YES;
    [self.view addSubview:_backgroundImageViewForLeftView];

    _backgroundImageViewForRightView = [UIImageView new];
    _backgroundImageViewForRightView.hidden = YES;
    _backgroundImageViewForRightView.contentMode = UIViewContentModeScaleAspectFill;
    _backgroundImageViewForRightView.backgroundColor = [UIColor clearColor];
    _backgroundImageViewForRightView.clipsToBounds = YES;
    [self.view addSubview:_backgroundImageViewForRightView];

    // -----

    _rootViewStyleView = [UIView new];
    _rootViewStyleView.hidden = YES;
    _rootViewStyleView.backgroundColor = [UIColor blackColor];
    _rootViewStyleView.layer.masksToBounds = NO;
    _rootViewStyleView.layer.shadowOffset = CGSizeZero;
    _rootViewStyleView.layer.shadowOpacity = 1.f;
    _rootViewStyleView.layer.shouldRasterize = YES;
    [self.view addSubview:_rootViewStyleView];

    if (_rootVC)
    {
        [self addChildViewController:_rootVC];
        [self.view addSubview:_rootVC.view];
    }

    // -----

    _gesturesCancelsTouchesInView = YES;

    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesture:)];
    tapGesture.delegate = self;
    tapGesture.numberOfTapsRequired = 1;
    tapGesture.numberOfTouchesRequired = 1;
    tapGesture.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapGesture];

    _panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGesture:)];
    _panGesture.minimumNumberOfTouches = 1;
    _panGesture.maximumNumberOfTouches = 1;
    _panGesture.cancelsTouchesInView = YES;
    [self.view addGestureRecognizer:_panGesture];
}

#pragma mark - Dealloc

- (void)dealloc
{
    //
}

#pragma mark - Appearing

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];

    CGSize size = self.view.frame.size;

    if (kLGSideMenuSystemVersion < 8.0)
    {
        if (kLGSideMenuStatusBarOrientationIsPortrait)
            size = CGSizeMake(MIN(size.width, size.height), MAX(size.width, size.height));
        else
            size = CGSizeMake(MAX(size.width, size.height), MIN(size.width, size.height));
    }

    if (!CGSizeEqualToSize(_savedSize, size))
    {
        BOOL appeared = !CGSizeEqualToSize(_savedSize, CGSizeZero);

        _savedSize = size;

        // -----

        [self colorsInvalidate];
        [self rootViewLayoutInvalidateWithPercentage:(self.isLeftViewShowing || self.isRightViewShowing ? 1.f : 0.f)];
        [self leftViewLayoutInvalidateWithPercentage:(self.isLeftViewShowing ? 1.f : 0.f)];
        [self rightViewLayoutInvalidateWithPercentage:(self.isRightViewShowing ? 1.f : 0.f)];
        [self hiddensInvalidateWithDelay:(appeared ? 0.25 : 0.0)];
    }
}

#pragma mark -

- (BOOL)shouldAutorotate
{
    return (kLGSideMenuIsMenuShowing ? _currentShouldAutorotate : (_rootVC ? _rootVC.shouldAutorotate : YES));
}

- (BOOL)prefersStatusBarHidden
{
    return (kLGSideMenuIsMenuShowing ? _currentPreferredStatusBarHidden : (_rootVC ? _rootVC.prefersStatusBarHidden : (UIInterfaceOrientationIsLandscape([UIApplication sharedApplication].statusBarOrientation) && UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)));
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return (kLGSideMenuIsMenuShowing ? _currentPreferredStatusBarStyle : (_rootVC ? _rootVC.preferredStatusBarStyle : UIStatusBarStyleDefault));
}

- (UIStatusBarAnimation)preferredStatusBarUpdateAnimation
{
    UIStatusBarAnimation animation = UIStatusBarAnimationNone;

    if (self.isWaitingForUpdateStatusBar)
    {
        _waitingForUpdateStatusBar = NO;

        animation = _currentPreferredStatusBarUpdateAnimation;
    }
    else if (_rootVC)
        animation = _rootVC.preferredStatusBarUpdateAnimation;

    return animation;
}

- (void)statusBarAppearanceUpdate
{
#if __IPHONE_OS_VERSION_MIN_REQUIRED < __IPHONE_9_0
    if (![[[NSBundle mainBundle] objectForInfoDictionaryKey:@"UIViewControllerBasedStatusBarAppearance"] boolValue])
    {
        [[UIApplication sharedApplication] setStatusBarHidden:_currentPreferredStatusBarHidden withAnimation:_currentPreferredStatusBarUpdateAnimation];
        [[UIApplication sharedApplication] setStatusBarStyle:_currentPreferredStatusBarStyle animated:_currentPreferredStatusBarUpdateAnimation];
    }
#endif
}

#pragma mark - Setters and Getters

- (void)setRootViewScaleForLeftView:(CGFloat)rootViewScaleForLeftView
{
    _rootViewScaleForLeftView = rootViewScaleForLeftView;

    _userRootViewScaleForLeftView = YES;
}

- (void)setRootViewScaleForRightView:(CGFloat)rootViewScaleForRightView
{
    _rootViewScaleForRightView = rootViewScaleForRightView;

    _userRootViewScaleForRightView = YES;
}

- (void)setRootViewCoverColorForLeftView:(UIColor *)rootViewCoverColorForLeftView
{
    _rootViewCoverColorForLeftView = rootViewCoverColorForLeftView;

    _userRootViewCoverColorForLeftView = YES;
}

- (void)setRootViewCoverColorForRightView:(UIColor *)rootViewCoverColorForRightView
{
    _rootViewCoverColorForRightView = rootViewCoverColorForRightView;

    _userRootViewCoverColorForRightView = YES;
}

- (void)setLeftViewCoverColor:(UIColor *)leftViewCoverColor
{
    _leftViewCoverColor = leftViewCoverColor;

    _userLeftViewCoverColor = YES;
}

- (void)setRightViewCoverColor:(UIColor *)rightViewCoverColor
{
    _rightViewCoverColor = rightViewCoverColor;

    _userRightViewCoverColor = YES;
}

- (void)setLeftViewBackgroundImageInitialScale:(CGFloat)leftViewBackgroundImageInitialScale
{
    _leftViewBackgroundImageInitialScale = leftViewBackgroundImageInitialScale;

    _userLeftViewBackgroundImageInitialScale = YES;
}

- (void)setRightViewBackgroundImageInitialScale:(CGFloat)rightViewBackgroundImageInitialScale
{
    _rightViewBackgroundImageInitialScale = rightViewBackgroundImageInitialScale;

    _userRightViewBackgroundImageInitialScale = YES;
}

- (void)setLeftViewInititialScale:(CGFloat)leftViewInititialScale
{
    _leftViewInititialScale = leftViewInititialScale;

    _userLeftViewInititialScale = YES;
}

- (void)setRightViewInititialScale:(CGFloat)rightViewInititialScale
{
    _rightViewInititialScale = rightViewInititialScale;

    _userRightViewInititialScale = YES;
}

- (void)setLeftViewInititialOffsetX:(CGFloat)leftViewInititialOffsetX
{
    _leftViewInititialOffsetX = leftViewInititialOffsetX;

    _userLeftViewInititialOffsetX = YES;
}

- (void)setRightViewInititialOffsetX:(CGFloat)rightViewInititialOffsetX
{
    _rightViewInititialOffsetX = rightViewInititialOffsetX;

    _userRightViewInititialOffsetX = YES;
}

- (void)setRootViewController:(UIViewController *)rootViewController
{
    if (rootViewController)
    {
        if (_rootVC)
        {
            [_rootVC.view removeFromSuperview];
            [_rootVC removeFromParentViewController];
        }

        _rootVC = rootViewController;

        [self addChildViewController:_rootVC];
        [self.view addSubview:_rootVC.view];

        if (_leftView)
        {
            [_leftView removeFromSuperview];
            [_rootViewCoverViewForLeftView removeFromSuperview];

            [self.view addSubview:_rootViewCoverViewForLeftView];

            if (_leftViewPresentationStyle == LGSideMenuPresentationStyleSlideAbove)
                [self.view addSubview:_leftView];
            else
                [self.view insertSubview:_leftView belowSubview:_rootVC.view];

        }

        if (_rightView)
        {
            [_rightView removeFromSuperview];
            [_rootViewCoverViewForRightView removeFromSuperview];

            [self.view insertSubview:_rootViewCoverViewForRightView aboveSubview:_rootViewCoverViewForLeftView];

            if (_rightViewPresentationStyle == LGSideMenuPresentationStyleSlideAbove)
                [self.view addSubview:_rightView];
            else
                [self.view insertSubview:_rightView belowSubview:_rootVC.view];
        }

        // -----

        [self rootViewLayoutInvalidateWithPercentage:(self.isLeftViewShowing || self.isRightViewShowing ? 1.f : 0.f)];
    }
}

- (UIViewController *)rootViewController
{
    return _rootVC;
}

- (UIView *)leftView
{
    return _leftView;
}

- (UIView *)rightView
{
    return _rightView;
}

- (BOOL)isLeftViewAlwaysVisible
{
    return kLGSideMenuIsLeftViewAlwaysVisible;
}

- (BOOL)isRightViewAlwaysVisible
{
    return kLGSideMenuIsRightViewAlwaysVisible;
}

- (BOOL)isLeftViewAlwaysVisibleForInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return kLGSideMenuIsLeftViewAlwaysVisibleForInterfaceOrientation(interfaceOrientation);
}

- (BOOL)isRightViewAlwaysVisibleForInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return kLGSideMenuIsRightViewAlwaysVisibleForInterfaceOrientation(interfaceOrientation);
}

- (void)setGesturesCancelsTouchesInView:(BOOL)gesturesCancelsTouchesInView
{
    _gesturesCancelsTouchesInView = gesturesCancelsTouchesInView;

    _panGesture.cancelsTouchesInView = gesturesCancelsTouchesInView;
}

#pragma mark - Layout Subviews

- (void)leftViewWillLayoutSubviewsWithSize:(CGSize)size
{
    //
}

- (void)rightViewWillLayoutSubviewsWithSize:(CGSize)size
{
    //
}

#pragma mark -

- (void)rootViewLayoutInvalidateWithPercentage:(CGFloat)percentage
{
    _rootVC.view.transform = CGAffineTransformIdentity;
    _rootViewStyleView.transform = CGAffineTransformIdentity;

    if (_rootViewCoverViewForLeftView)
        _rootViewCoverViewForLeftView.transform = CGAffineTransformIdentity;

    if (_rootViewCoverViewForRightView)
        _rootViewCoverViewForRightView.transform = CGAffineTransformIdentity;

    // -----

    CGSize size = self.view.frame.size;

    if (kLGSideMenuSystemVersion < 8.0)
    {
        if (kLGSideMenuStatusBarOrientationIsPortrait)
            size = CGSizeMake(MIN(size.width, size.height), MAX(size.width, size.height));
        else
            size = CGSizeMake(MAX(size.width, size.height), MIN(size.width, size.height));
    }

    // -----

    CGRect rootViewViewFrame = CGRectMake(0.f, 0.f, size.width, size.height);
    CGAffineTransform transform = CGAffineTransformIdentity;

    BOOL leftViewAlwaysVisible = NO;
    BOOL rightViewAlwaysVisible = NO;

    if (kLGSideMenuIsLeftViewAlwaysVisible)
    {
        leftViewAlwaysVisible = YES;

        rootViewViewFrame.origin.x += _leftViewWidth;
        rootViewViewFrame.size.width -= _leftViewWidth;
    }

    if (kLGSideMenuIsRightViewAlwaysVisible)
    {
        rightViewAlwaysVisible = YES;

        rootViewViewFrame.size.width -= _rightViewWidth;
    }

    if (!leftViewAlwaysVisible && !rightViewAlwaysVisible)
    {
        if (self.isLeftViewShowing && _leftViewPresentationStyle != LGSideMenuPresentationStyleSlideAbove)
        {
            CGFloat rootViewScale = 1.f+(_rootViewScaleForLeftView-1.f)*percentage;

            transform = CGAffineTransformMakeScale(rootViewScale, rootViewScale);

            CGFloat shift = size.width*(1.f-rootViewScale)/2;

            rootViewViewFrame = CGRectMake((_leftViewWidth-shift)*percentage, 0.f, size.width, size.height);
            if ([UIScreen mainScreen].scale == 1.f)
                rootViewViewFrame = CGRectIntegral(rootViewViewFrame);
        }
        else if (self.isRightViewShowing && _rightViewPresentationStyle != LGSideMenuPresentationStyleSlideAbove)
        {
            CGFloat rootViewScale = 1.f+(_rootViewScaleForRightView-1.f)*percentage;

            transform = CGAffineTransformMakeScale(rootViewScale, rootViewScale);

            CGFloat shift = size.width*(1.f-rootViewScale)/2;

            rootViewViewFrame = CGRectMake(-(_rightViewWidth-shift)*percentage, 0.f, size.width, size.height);
            if ([UIScreen mainScreen].scale == 1.f)
                rootViewViewFrame = CGRectIntegral(rootViewViewFrame);
        }
    }

    _rootVC.view.frame = rootViewViewFrame;
    _rootVC.view.transform = transform;

    // -----

    CGFloat borderWidth = _rootViewStyleView.layer.borderWidth;
    _rootViewStyleView.frame = CGRectMake(rootViewViewFrame.origin.x-borderWidth, rootViewViewFrame.origin.y-borderWidth, rootViewViewFrame.size.width+borderWidth*2, rootViewViewFrame.size.height+borderWidth*2);
    _rootViewStyleView.transform = transform;

    // -----

    if (_leftView)
    {
        _rootViewCoverViewForLeftView.frame = rootViewViewFrame;
        _rootViewCoverViewForLeftView.transform = transform;
    }

    if (_rightView)
    {
        _rootViewCoverViewForRightView.frame = rootViewViewFrame;
        _rootViewCoverViewForRightView.transform = transform;
    }
}

- (void)leftViewLayoutInvalidateWithPercentage:(CGFloat)percentage
{
    if (_leftView)
    {
        CGSize size = self.view.frame.size;

        if (kLGSideMenuSystemVersion < 8.0)
        {
            if (kLGSideMenuStatusBarOrientationIsPortrait)
                size = CGSizeMake(MIN(size.width, size.height), MAX(size.width, size.height));
            else
                size = CGSizeMake(MAX(size.width, size.height), MIN(size.width, size.height));
        }

        // -----

        _leftView.transform = CGAffineTransformIdentity;
        _backgroundImageViewForLeftView.transform = CGAffineTransformIdentity;
        _leftViewStyleView.transform = CGAffineTransformIdentity;

        // -----

        CGFloat originX = 0.f;
        CGAffineTransform leftViewTransform = CGAffineTransformIdentity;
        CGAffineTransform backgroundViewTransform = CGAffineTransformIdentity;

        if (!kLGSideMenuIsLeftViewAlwaysVisible)
        {
            _rootViewCoverViewForLeftView.alpha = percentage;
            _leftViewCoverView.alpha = 1.f-percentage;

            if (_leftViewPresentationStyle == LGSideMenuPresentationStyleSlideAbove)
                originX = -(_leftViewWidth+_leftViewStyleView.layer.shadowRadius*2)*(1.f-percentage);
            else
            {
                CGFloat leftViewScale = 1.f+(_leftViewInititialScale-1.f)*(1.f-percentage);
                CGFloat backgroundViewScale = 1.f+(_leftViewBackgroundImageInitialScale-1.f)*(1.f-percentage);

                leftViewTransform = CGAffineTransformMakeScale(leftViewScale, leftViewScale);
                backgroundViewTransform = CGAffineTransformMakeScale(backgroundViewScale, backgroundViewScale);

                originX = (-(_leftViewWidth*(1.f-leftViewScale)/2)+(_leftViewInititialOffsetX*leftViewScale))*(1.f-percentage);
            }
        }

        // -----

        CGRect leftViewFrame = CGRectMake(originX, 0.f, _leftViewWidth, size.height);
        if ([UIScreen mainScreen].scale == 1.f)
            leftViewFrame = CGRectIntegral(leftViewFrame);
        _leftView.frame = leftViewFrame;

        _leftView.transform = leftViewTransform;

        // -----

        if (_leftViewPresentationStyle != LGSideMenuPresentationStyleSlideAbove)
        {
            CGRect backgroundViewFrame = CGRectMake(0.f, 0.f, size.width, size.height);

            if (kLGSideMenuIsLeftViewAlwaysVisible && kLGSideMenuIsRightViewAlwaysVisible)
            {
                CGFloat multiplier = _rightViewWidth/_leftViewWidth;

                backgroundViewFrame.size.width = (size.width/(multiplier+1.f));
            }

            if ([UIScreen mainScreen].scale == 1.f)
                backgroundViewFrame = CGRectIntegral(backgroundViewFrame);
            _backgroundImageViewForLeftView.frame = backgroundViewFrame;

            _backgroundImageViewForLeftView.transform = backgroundViewTransform;

            // -----

            if (_leftViewCoverView)
            {
                CGRect leftViewCoverViewFrame = CGRectMake(0.f, 0.f, size.width, size.height);
                if ([UIScreen mainScreen].scale == 1.f)
                    leftViewCoverViewFrame = CGRectIntegral(leftViewCoverViewFrame);
                _leftViewCoverView.frame = leftViewCoverViewFrame;
            }
        }
        else
        {
            CGFloat borderWidth = _leftViewStyleView.layer.borderWidth;
            _leftViewStyleView.frame = CGRectMake(leftViewFrame.origin.x-borderWidth, leftViewFrame.origin.y-borderWidth, leftViewFrame.size.width+borderWidth*2, leftViewFrame.size.height+borderWidth*2);
            _leftViewStyleView.transform = leftViewTransform;
        }
    }
}

- (void)rightViewLayoutInvalidateWithPercentage:(CGFloat)percentage
{
    if (_rightView)
    {
        CGSize size = self.view.frame.size;

        if (kLGSideMenuSystemVersion < 8.0)
        {
            if (kLGSideMenuStatusBarOrientationIsPortrait)
                size = CGSizeMake(MIN(size.width, size.height), MAX(size.width, size.height));
            else
                size = CGSizeMake(MAX(size.width, size.height), MIN(size.width, size.height));
        }

        // -----

        _rightView.transform = CGAffineTransformIdentity;
        _backgroundImageViewForRightView.transform = CGAffineTransformIdentity;
        _rightViewStyleView.transform = CGAffineTransformIdentity;

        // -----

        CGFloat originX = size.width-_rightViewWidth;
        CGAffineTransform rightViewTransform = CGAffineTransformIdentity;
        CGAffineTransform backgroundViewTransform = CGAffineTransformIdentity;

        if (!kLGSideMenuIsRightViewAlwaysVisible)
        {
            _rootViewCoverViewForRightView.alpha = percentage;
            _rightViewCoverView.alpha = 1.f-percentage;

            if (_rightViewPresentationStyle == LGSideMenuPresentationStyleSlideAbove)
                originX = size.width-_rightViewWidth+(_rightViewWidth+_rightViewStyleView.layer.shadowRadius*2)*(1.f-percentage);
            else
            {
                CGFloat rightViewScale = 1.f+(_rightViewInititialScale-1.f)*(1.f-percentage);
                CGFloat backgroundViewScale = 1.f+(_rightViewBackgroundImageInitialScale-1.f)*(1.f-percentage);

                rightViewTransform = CGAffineTransformMakeScale(rightViewScale, rightViewScale);
                backgroundViewTransform = CGAffineTransformMakeScale(backgroundViewScale, backgroundViewScale);

                originX = size.width-_rightViewWidth+((_rightViewWidth*(1.f-rightViewScale)/2)+(_rightViewInititialOffsetX*rightViewScale))*(1.f-percentage);
            }
        }

        // -----

        CGRect rightViewFrame = CGRectMake(originX, 0.f, _rightViewWidth, size.height);
        if ([UIScreen mainScreen].scale == 1.f)
            rightViewFrame = CGRectIntegral(rightViewFrame);
        _rightView.frame = rightViewFrame;

        _rightView.transform = rightViewTransform;

        // -----

        if (_rightViewPresentationStyle != LGSideMenuPresentationStyleSlideAbove)
        {
            CGRect backgroundViewFrame = CGRectMake(0.f, 0.f, size.width, size.height);

            if (kLGSideMenuIsLeftViewAlwaysVisible && kLGSideMenuIsRightViewAlwaysVisible)
            {
                CGFloat multiplier = _leftViewWidth/_rightViewWidth;

                backgroundViewFrame.size.width = (size.width/(multiplier+1.f));
                backgroundViewFrame.origin.x = size.width - backgroundViewFrame.size.width;
            }

            if ([UIScreen mainScreen].scale == 1.f)
                backgroundViewFrame = CGRectIntegral(backgroundViewFrame);
            _backgroundImageViewForRightView.frame = backgroundViewFrame;

            _backgroundImageViewForRightView.transform = backgroundViewTransform;

            // -----

            if (_rightViewCoverView)
            {
                CGRect rightViewCoverViewFrame = CGRectMake(0.f, 0.f, size.width, size.height);
                if ([UIScreen mainScreen].scale == 1.f)
                    rightViewCoverViewFrame = CGRectIntegral(rightViewCoverViewFrame);
                _rightViewCoverView.frame = rightViewCoverViewFrame;
            }
        }
        else
        {
            CGFloat borderWidth = _rightViewStyleView.layer.borderWidth;
            _rightViewStyleView.frame = CGRectMake(rightViewFrame.origin.x-borderWidth, rightViewFrame.origin.y-borderWidth, rightViewFrame.size.width+borderWidth*2, rightViewFrame.size.height+borderWidth*2);
            _rightViewStyleView.transform = rightViewTransform;
        }
    }
}

- (void)colorsInvalidate
{
    if (_rootViewStyleView)
    {
        _rootViewStyleView.layer.borderWidth = _rootViewLayerBorderWidth;
        _rootViewStyleView.layer.borderColor = _rootViewLayerBorderColor.CGColor;
        _rootViewStyleView.layer.shadowColor = _rootViewLayerShadowColor.CGColor;
        _rootViewStyleView.layer.shadowRadius = _rootViewLayerShadowRadius;
    }

    if (kLGSideMenuIsLeftViewAlwaysVisible || self.isLeftViewShowing)
    {
        self.view.backgroundColor = [_leftViewBackgroundColor colorWithAlphaComponent:1.f];

        _rootViewCoverViewForLeftView.backgroundColor = _rootViewCoverColorForLeftView;

        if (_leftViewCoverView)
            _leftViewCoverView.backgroundColor = _leftViewCoverColor;

        if (_leftViewStyleView)
        {
            _leftViewStyleView.backgroundColor = (kLGSideMenuIsLeftViewAlwaysVisible ? [_leftViewBackgroundColor colorWithAlphaComponent:1.f] : _leftViewBackgroundColor);
            _leftViewStyleView.layer.borderWidth = _leftViewLayerBorderWidth;
            _leftViewStyleView.layer.borderColor = _leftViewLayerBorderColor.CGColor;
            _leftViewStyleView.layer.shadowColor = _leftViewLayerShadowColor.CGColor;
            _leftViewStyleView.layer.shadowRadius = _leftViewLayerShadowRadius;
        }

        if (_leftViewBackgroundImage)
            _backgroundImageViewForLeftView.image = _leftViewBackgroundImage;
    }

    if (kLGSideMenuIsRightViewAlwaysVisible || self.isRightViewShowing)
    {
        self.view.backgroundColor = [_rightViewBackgroundColor colorWithAlphaComponent:1.f];

        _rootViewCoverViewForRightView.backgroundColor = _rootViewCoverColorForRightView;

        if (_rightViewCoverView)
            _rightViewCoverView.backgroundColor = (_rightViewCoverColor ? _rightViewCoverColor : kLGSideMenuCoverColor);

        if (_rightViewStyleView)
        {
            _rightViewStyleView.backgroundColor = (kLGSideMenuIsRightViewAlwaysVisible ? [_rightViewBackgroundColor colorWithAlphaComponent:1.f] : _rightViewBackgroundColor);
            _rightViewStyleView.layer.borderWidth = _rightViewLayerBorderWidth;
            _rightViewStyleView.layer.borderColor = _rightViewLayerBorderColor.CGColor;
            _rightViewStyleView.layer.shadowColor = _rightViewLayerShadowColor.CGColor;
            _rightViewStyleView.layer.shadowRadius = _rightViewLayerShadowRadius;
        }

        if (_rightViewBackgroundImage)
            _backgroundImageViewForRightView.image = _rightViewBackgroundImage;
    }
}

- (void)hiddensInvalidate
{
    [self hiddensInvalidateWithDelay:0.0];
}

- (void)hiddensInvalidateWithDelay:(NSTimeInterval)delay
{
    BOOL rootViewStyleViewHiddenForLeftView = YES;
    BOOL rootViewStyleViewHiddenForRightView = YES;

    // -----

    if (kLGSideMenuIsLeftViewAlwaysVisible)
    {
        _rootViewCoverViewForLeftView.hidden = YES;
        _leftViewCoverView.hidden = YES;
        _leftView.hidden = NO;
        _leftViewStyleView.hidden = NO;
        _backgroundImageViewForLeftView.hidden = NO;

        rootViewStyleViewHiddenForLeftView = NO;
    }
    else if (!self.isLeftViewShowing)
    {
        if (delay)
        {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^(void)
                           {
                               _rootViewCoverViewForLeftView.hidden = YES;
                               _leftViewCoverView.hidden = YES;
                               _leftView.hidden = YES;
                               _leftViewStyleView.hidden = YES;
                               _backgroundImageViewForLeftView.hidden = YES;
                           });
        }
        else
        {
            _rootViewCoverViewForLeftView.hidden = YES;
            _leftViewCoverView.hidden = YES;
            _leftView.hidden = YES;
            _leftViewStyleView.hidden = YES;
            _backgroundImageViewForLeftView.hidden = YES;
        }

        rootViewStyleViewHiddenForLeftView = YES;
    }
    else if (self.isLeftViewShowing)
    {
        _rootViewCoverViewForLeftView.hidden = NO;
        _leftViewCoverView.hidden = NO;
        _leftView.hidden = NO;
        _leftViewStyleView.hidden = NO;
        _backgroundImageViewForLeftView.hidden = NO;

        rootViewStyleViewHiddenForLeftView = NO;
    }

    // -----

    if (kLGSideMenuIsRightViewAlwaysVisible)
    {
        _rootViewCoverViewForRightView.hidden = YES;
        _rightViewCoverView.hidden = YES;
        _rightView.hidden = NO;
        _rightViewStyleView.hidden = NO;
        _backgroundImageViewForRightView.hidden = NO;

        rootViewStyleViewHiddenForRightView = NO;
    }
    else if (!self.isRightViewShowing)
    {
        if (delay)
        {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^(void)
                           {
                               _rootViewCoverViewForRightView.hidden = YES;
                               _rightViewCoverView.hidden = YES;
                               _rightView.hidden = YES;
                               _rightViewStyleView.hidden = YES;
                               _backgroundImageViewForRightView.hidden = YES;
                           });
        }
        else
        {
            _rootViewCoverViewForRightView.hidden = YES;
            _rightViewCoverView.hidden = YES;
            _rightView.hidden = YES;
            _rightViewStyleView.hidden = YES;
            _backgroundImageViewForRightView.hidden = YES;
        }

        rootViewStyleViewHiddenForRightView = YES;
    }
    else if (self.isRightViewShowing)
    {
        _rootViewCoverViewForRightView.hidden = NO;
        _rightViewCoverView.hidden = NO;
        _rightView.hidden = NO;
        _rightViewStyleView.hidden = NO;
        _backgroundImageViewForRightView.hidden = NO;

        rootViewStyleViewHiddenForRightView = NO;
    }

    // -----

    if (rootViewStyleViewHiddenForLeftView && rootViewStyleViewHiddenForRightView)
    {
        if (delay)
        {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^(void)
                           {
                               _rootViewStyleView.hidden = YES;
                           });
        }
        else _rootViewStyleView.hidden = (rootViewStyleViewHiddenForLeftView && rootViewStyleViewHiddenForRightView);
    }
    else _rootViewStyleView.hidden = NO;
}

#pragma mark - Side Views

- (void)setLeftViewEnabledWithWidth:(CGFloat)width
                  presentationStyle:(LGSideMenuPresentationStyle)presentationStyle
               alwaysVisibleOptions:(LGSideMenuAlwaysVisibleOptions)alwaysVisibleOptions
{
    NSAssert(_leftView == nil, @"Left view already exists");

    _rootViewCoverViewForLeftView = [UIView new];
    _rootViewCoverViewForLeftView.hidden = YES;
    if (_rootVC)
    {
        if (_rootViewCoverViewForRightView)
            [self.view insertSubview:_rootViewCoverViewForLeftView aboveSubview:_rootViewCoverViewForRightView];
        else
            [self.view addSubview:_rootViewCoverViewForLeftView];
    }

    // -----

    __weak typeof(self) wself = self;

    _leftView = [[LGSideMenuView alloc] initWithLayoutSubviewsHandler:^(void)
                 {
                     if (wself)
                     {
                         __strong typeof(wself) self = wself;

                         CGSize size = self.view.frame.size;

                         if (kLGSideMenuSystemVersion < 8.0)
                         {
                             if (kLGSideMenuStatusBarOrientationIsPortrait)
                                 size = CGSizeMake(MIN(size.width, size.height), MAX(size.width, size.height));
                             else
                                 size = CGSizeMake(MAX(size.width, size.height), MIN(size.width, size.height));
                         }

                         [self leftViewWillLayoutSubviewsWithSize:CGSizeMake(self.leftViewWidth, size.height)];
                     }
                 }];
    _leftView.backgroundColor = [UIColor clearColor];
    _leftView.hidden = YES;
    if (_rootVC)
    {
        if (presentationStyle == LGSideMenuPresentationStyleSlideAbove)
            [self.view addSubview:_leftView];
        else
            [self.view insertSubview:_leftView belowSubview:_rootVC.view];
    }

    // -----

    _leftViewWidth = width;

    _leftViewPresentationStyle = presentationStyle;

    _leftViewAlwaysVisibleOptions = alwaysVisibleOptions;

    // -----

    if (presentationStyle != LGSideMenuPresentationStyleSlideAbove)
    {
        _leftViewCoverView = [UIView new];
        _leftViewCoverView.hidden = YES;
        [self.view insertSubview:_leftViewCoverView aboveSubview:_leftView];
    }
    else
    {
        _leftViewStyleView = [UIView new];
        _leftViewStyleView.hidden = YES;
        _leftViewStyleView.layer.masksToBounds = NO;
        _leftViewStyleView.layer.shadowOffset = CGSizeZero;
        _leftViewStyleView.layer.shadowOpacity = 1.f;
        _leftViewStyleView.layer.shouldRasterize = YES;
        [self.view insertSubview:_leftViewStyleView belowSubview:_leftView];
    }

    // -----

    [_rootViewStyleView removeFromSuperview];
    [self.view insertSubview:_rootViewStyleView belowSubview:_rootVC.view];

    // -----

    if (!self.isUserRootViewScaleForLeftView)
    {
        if (_leftViewPresentationStyle == LGSideMenuPresentationStyleSlideAbove || _leftViewPresentationStyle == LGSideMenuPresentationStyleSlideBelow)
            _rootViewScaleForLeftView = 1.f;
        else
            _rootViewScaleForLeftView = 0.8;
    }

    if (_leftViewPresentationStyle == LGSideMenuPresentationStyleSlideAbove)
    {
        if (!self.isUserRootViewCoverColorForLeftView)
            _rootViewCoverColorForLeftView = kLGSideMenuCoverColor;
    }
    else
    {
        if (!self.isUserLeftViewCoverColor)
            _leftViewCoverColor = kLGSideMenuCoverColor;
    }

    if (!self.isUserLeftViewBackgroundImageInitialScale)
    {
        if (_leftViewPresentationStyle == LGSideMenuPresentationStyleSlideBelow || _leftViewPresentationStyle == LGSideMenuPresentationStyleSlideAbove)
            _leftViewBackgroundImageInitialScale = 1.f;
        else
            _leftViewBackgroundImageInitialScale = 1.4;
    }

    if (!self.isUserLeftViewInititialScale)
    {
        if (_leftViewPresentationStyle == LGSideMenuPresentationStyleSlideBelow || _leftViewPresentationStyle == LGSideMenuPresentationStyleSlideAbove)
            _leftViewInititialScale = 1.f;
        else if (_leftViewPresentationStyle == LGSideMenuPresentationStyleScaleFromBig)
            _leftViewInititialScale = 1.2;
        else
            _leftViewInititialScale = 0.8;
    }

    if (!self.isUserLeftViewInititialOffsetX)
    {
        if (_leftViewPresentationStyle == LGSideMenuPresentationStyleSlideBelow)
            _leftViewInititialOffsetX = -_leftViewWidth/2;
    }

    // -----

    [self leftViewLayoutInvalidateWithPercentage:0.f];
}

- (void)setRightViewEnabledWithWidth:(CGFloat)width
                   presentationStyle:(LGSideMenuPresentationStyle)presentationStyle
                alwaysVisibleOptions:(LGSideMenuAlwaysVisibleOptions)alwaysVisibleOptions
{
    NSAssert(_rightView == nil, @"Right view already exists");

    _rootViewCoverViewForRightView = [UIView new];
    _rootViewCoverViewForRightView.hidden = YES;
    if (_rootVC)
    {
        if (_rootViewCoverViewForLeftView)
            [self.view insertSubview:_rootViewCoverViewForRightView aboveSubview:_rootViewCoverViewForLeftView];
        else
            [self.view addSubview:_rootViewCoverViewForRightView];
    }

    // -----

    __weak typeof(self) wself = self;

    _rightView = [[LGSideMenuView alloc] initWithLayoutSubviewsHandler:^(void)
                  {
                      if (wself)
                      {
                          __strong typeof(wself) self = wself;

                          CGSize size = self.view.frame.size;

                          if (kLGSideMenuSystemVersion < 8.0)
                          {
                              if (kLGSideMenuStatusBarOrientationIsPortrait)
                                  size = CGSizeMake(MIN(size.width, size.height), MAX(size.width, size.height));
                              else
                                  size = CGSizeMake(MAX(size.width, size.height), MIN(size.width, size.height));
                          }

                          [self rightViewWillLayoutSubviewsWithSize:CGSizeMake(self.rightViewWidth, size.height)];
                      }
                  }];
    _rightView.backgroundColor = [UIColor clearColor];
    _rightView.hidden = YES;
    if (_rootVC)
    {
        if (presentationStyle == LGSideMenuPresentationStyleSlideAbove)
            [self.view addSubview:_rightView];
        else
            [self.view insertSubview:_rightView belowSubview:_rootVC.view];
    }

    // -----

    _rightViewWidth = width;

    _rightViewPresentationStyle = presentationStyle;

    _rightViewAlwaysVisibleOptions = alwaysVisibleOptions;

    // -----

    if (presentationStyle != LGSideMenuPresentationStyleSlideAbove)
    {
        _rightViewCoverView = [UIView new];
        _rightViewCoverView.hidden = YES;
        [self.view insertSubview:_rightViewCoverView aboveSubview:_rightView];
    }
    else
    {
        _rightViewStyleView = [UIView new];
        _rightViewStyleView.hidden = YES;
        _rightViewStyleView.backgroundColor = [UIColor colorWithWhite:0.3 alpha:0.9];
        _rightViewStyleView.layer.masksToBounds = NO;
        _rightViewStyleView.layer.borderWidth = 2.f;
        _rightViewStyleView.layer.borderColor = [UIColor colorWithRed:0.f green:0.5 blue:1.f alpha:1.f].CGColor;
        _rightViewStyleView.layer.shadowColor = [UIColor colorWithWhite:0.f alpha:0.5].CGColor;
        _rightViewStyleView.layer.shadowOffset = CGSizeZero;
        _rightViewStyleView.layer.shadowOpacity = 1.f;
        _rightViewStyleView.layer.shadowRadius = 5.f;
        _rightViewStyleView.layer.shouldRasterize = YES;
        [self.view insertSubview:_rightViewStyleView belowSubview:_rightView];
    }

    // -----

    [_rootViewStyleView removeFromSuperview];
    [self.view insertSubview:_rootViewStyleView belowSubview:_rootVC.view];

    // -----

    if (!self.isUserRootViewScaleForRightView)
    {
        if (_rightViewPresentationStyle == LGSideMenuPresentationStyleSlideAbove || _rightViewPresentationStyle == LGSideMenuPresentationStyleSlideBelow)
            _rootViewScaleForRightView = 1.f;
        else
            _rootViewScaleForRightView = 0.8;
    }

    if (_rightViewPresentationStyle == LGSideMenuPresentationStyleSlideAbove)
    {
        if (!self.isUserRootViewCoverColorForRightView)
            _rootViewCoverColorForRightView = kLGSideMenuCoverColor;
    }
    else
    {
        if (!self.isUserRightViewCoverColor)
            _rightViewCoverColor = kLGSideMenuCoverColor;
    }

    if (!self.isUserRightViewBackgroundImageInitialScale)
    {
        if (_rightViewPresentationStyle == LGSideMenuPresentationStyleSlideBelow || _rightViewPresentationStyle == LGSideMenuPresentationStyleSlideAbove)
            _rightViewBackgroundImageInitialScale = 1.f;
        else
            _rightViewBackgroundImageInitialScale = 1.4;
    }

    if (!self.isUserRightViewInititialScale)
    {
        if (_rightViewPresentationStyle == LGSideMenuPresentationStyleSlideBelow || _rightViewPresentationStyle == LGSideMenuPresentationStyleSlideAbove)
            _rightViewInititialScale = 1.f;
        else if (_rightViewPresentationStyle == LGSideMenuPresentationStyleScaleFromBig)
            _rightViewInititialScale = 1.2;
        else
            _rightViewInititialScale = 0.8;
    }

    if (!self.isUserRightViewInititialOffsetX)
    {
        if (_rightViewPresentationStyle == LGSideMenuPresentationStyleSlideBelow)
            _rightViewInititialOffsetX = _rightViewWidth/2;
    }

    // -----

    [self rightViewLayoutInvalidateWithPercentage:0.f];
}

#pragma mark - Show Hide

- (void)showLeftViewPrepare
{
    [self.view endEditing:YES];

    _leftViewShowing = YES;

    // -----

    if (kLGSideMenuSystemVersion >= 7.0)
    {
        _savedStatusBarHidden = kLGSideMenuStatusBarHidden;
        _savedStatusBarStyle = kLGSideMenuStatusBarStyle;

        [_rootVC removeFromParentViewController];

        _currentShouldAutorotate = NO;
        _currentPreferredStatusBarHidden = (kLGSideMenuStatusBarHidden || !kLGSideMenuIsLeftViewStatusBarVisible);
        _currentPreferredStatusBarStyle = _leftViewStatusBarStyle;
        _currentPreferredStatusBarUpdateAnimation = _leftViewStatusBarUpdateAnimation;

        _waitingForUpdateStatusBar = YES;

        [self statusBarAppearanceUpdate];
        [self setNeedsStatusBarAppearanceUpdate];
    }

    // -----

    [self leftViewLayoutInvalidateWithPercentage:0.f];
    [self colorsInvalidate];
    [self hiddensInvalidate];

    [[NSNotificationCenter defaultCenter] postNotificationName:kLGSideMenuControllerWillShowLeftViewNotification object:self userInfo:nil];
}

- (void)showLeftViewAnimated:(BOOL)animated completionHandler:(void(^)())completionHandler
{
    if (!kLGSideMenuIsLeftViewAlwaysVisible && !self.isLeftViewShowing && self.shouldShowLeftView &&
        !(kLGSideMenuIsRightViewAlwaysVisible && _leftViewPresentationStyle != LGSideMenuPresentationStyleSlideAbove))
    {
        [self showLeftViewPrepare];

        [self showLeftViewAnimated:animated fromPercentage:0.f completionHandler:completionHandler];
    }
}

- (void)showLeftViewAnimated:(BOOL)animated fromPercentage:(CGFloat)percentage completionHandler:(void(^)())completionHandler
{
    if (animated)
    {
        [LGSideMenuController animateStandardWithDuration:_leftViewAnimationSpeed
                                               animations:^(void)
         {
             [self rootViewLayoutInvalidateWithPercentage:1.f];
             [self leftViewLayoutInvalidateWithPercentage:1.f];
         }
                                               completion:^(BOOL finished)
         {
             if (finished)
                 [self hiddensInvalidate];

             [[NSNotificationCenter defaultCenter] postNotificationName:kLGSideMenuControllerDidShowLeftViewNotification object:self userInfo:nil];

             if (completionHandler) completionHandler();
         }];
    }
    else
    {
        [self rootViewLayoutInvalidateWithPercentage:1.f];
        [self leftViewLayoutInvalidateWithPercentage:1.f];

        [self hiddensInvalidate];

        [[NSNotificationCenter defaultCenter] postNotificationName:kLGSideMenuControllerDidShowLeftViewNotification object:self userInfo:nil];

        if (completionHandler) completionHandler();
    }
}

- (void)hideLeftViewAnimated:(BOOL)animated completionHandler:(void(^)())completionHandler
{
    if (!kLGSideMenuIsLeftViewAlwaysVisible && self.isLeftViewShowing)
        [self hideLeftViewAnimated:animated fromPercentage:1.f completionHandler:completionHandler];
}

- (void)hideLeftViewAnimated:(BOOL)animated fromPercentage:(CGFloat)percentage completionHandler:(void(^)())completionHandler
{
    [[NSNotificationCenter defaultCenter] postNotificationName:kLGSideMenuControllerWillDismissLeftViewNotification object:self userInfo:nil];

    if (animated)
    {
        [LGSideMenuController animateStandardWithDuration:_leftViewAnimationSpeed
                                               animations:^(void)
         {
             [self rootViewLayoutInvalidateWithPercentage:0.f];
             [self leftViewLayoutInvalidateWithPercentage:0.f];
         }
                                               completion:^(BOOL finished)
         {
             _leftViewShowing = NO;

             [self hideLeftViewDone];

             if (finished)
                 [self hiddensInvalidate];

             [[NSNotificationCenter defaultCenter] postNotificationName:kLGSideMenuControllerDidDismissLeftViewNotification object:self userInfo:nil];

             if (completionHandler) completionHandler();
         }];
    }
    else
    {
        [self rootViewLayoutInvalidateWithPercentage:0.f];
        [self leftViewLayoutInvalidateWithPercentage:0.f];
        [self hideLeftViewDone];

        _leftViewShowing = NO;

        [self hiddensInvalidate];

        [[NSNotificationCenter defaultCenter] postNotificationName:kLGSideMenuControllerDidDismissLeftViewNotification object:self userInfo:nil];

        if (completionHandler) completionHandler();
    }
}

- (void)hideLeftViewDone
{
    if (kLGSideMenuSystemVersion >= 7.0)
    {
        [self addChildViewController:_rootVC];

        _currentPreferredStatusBarHidden = _savedStatusBarHidden;
        _currentPreferredStatusBarStyle = _savedStatusBarStyle;

        _waitingForUpdateStatusBar = YES;

        [self statusBarAppearanceUpdate];
        [self setNeedsStatusBarAppearanceUpdate];
    }
}

- (void)hideLeftViewComleteAfterGesture
{
    [[NSNotificationCenter defaultCenter] postNotificationName:kLGSideMenuControllerWillDismissLeftViewNotification object:self userInfo:nil];

    _leftViewShowing = NO;

    [self hideLeftViewDone];
    [self hiddensInvalidate];

    [[NSNotificationCenter defaultCenter] postNotificationName:kLGSideMenuControllerDidDismissLeftViewNotification object:self userInfo:nil];
}

- (void)showHideLeftViewAnimated:(BOOL)animated completionHandler:(void (^)())completionHandler
{
    if (!kLGSideMenuIsLeftViewAlwaysVisible)
    {
        if (self.isLeftViewShowing)
            [self hideLeftViewAnimated:animated completionHandler:completionHandler];
        else
            [self showLeftViewAnimated:animated completionHandler:completionHandler];
    }
}

#pragma mark -

- (void)showRightViewPrepare
{
    [self.view endEditing:YES];

    _rightViewShowing = YES;

    // -----

    if (kLGSideMenuSystemVersion >= 7.0)
    {
        _savedStatusBarHidden = kLGSideMenuStatusBarHidden;
        _savedStatusBarStyle = kLGSideMenuStatusBarStyle;

        [_rootVC removeFromParentViewController];

        _currentShouldAutorotate = NO;
        _currentPreferredStatusBarHidden = (kLGSideMenuStatusBarHidden || !kLGSideMenuIsRightViewStatusBarVisible);
        _currentPreferredStatusBarStyle = _rightViewStatusBarStyle;
        _currentPreferredStatusBarUpdateAnimation = _rightViewStatusBarUpdateAnimation;

        _waitingForUpdateStatusBar = YES;

        [self statusBarAppearanceUpdate];
        [self setNeedsStatusBarAppearanceUpdate];
    }

    // -----

    [self rightViewLayoutInvalidateWithPercentage:0.f];
    [self colorsInvalidate];
    [self hiddensInvalidate];

    [[NSNotificationCenter defaultCenter] postNotificationName:kLGSideMenuControllerWillShowRightViewNotification object:self userInfo:nil];
}

- (void)showRightViewAnimated:(BOOL)animated completionHandler:(void(^)())completionHandler
{
    if (!kLGSideMenuIsRightViewAlwaysVisible && !self.isRightViewShowing && self.shouldShowRightView &&
        !(kLGSideMenuIsLeftViewAlwaysVisible && _rightViewPresentationStyle != LGSideMenuPresentationStyleSlideAbove))
    {
        [self showRightViewPrepare];

        [self showRightViewAnimated:animated fromPercentage:0.f completionHandler:completionHandler];
    }
}

- (void)showRightViewAnimated:(BOOL)animated fromPercentage:(CGFloat)percentage completionHandler:(void(^)())completionHandler
{
    if (animated)
    {
        [LGSideMenuController animateStandardWithDuration:_rightViewAnimationSpeed
                                               animations:^(void)
         {
             [self rootViewLayoutInvalidateWithPercentage:1.f];
             [self rightViewLayoutInvalidateWithPercentage:1.f];
         }
                                               completion:^(BOOL finished)
         {
             if (finished)
                 [self hiddensInvalidate];

             [[NSNotificationCenter defaultCenter] postNotificationName:kLGSideMenuControllerDidShowRightViewNotification object:self userInfo:nil];

             if (completionHandler) completionHandler();
         }];
    }
    else
    {
        [self rootViewLayoutInvalidateWithPercentage:1.f];
        [self rightViewLayoutInvalidateWithPercentage:1.f];

        [self hiddensInvalidate];

        [[NSNotificationCenter defaultCenter] postNotificationName:kLGSideMenuControllerDidShowRightViewNotification object:self userInfo:nil];

        if (completionHandler) completionHandler();
    }
}

- (void)hideRightViewAnimated:(BOOL)animated completionHandler:(void(^)())completionHandler
{
    if (!kLGSideMenuIsRightViewAlwaysVisible && self.isRightViewShowing)
        [self hideRightViewAnimated:animated fromPercentage:1.f completionHandler:completionHandler];
}

- (void)hideRightViewAnimated:(BOOL)animated fromPercentage:(CGFloat)percentage completionHandler:(void(^)())completionHandler
{
    [[NSNotificationCenter defaultCenter] postNotificationName:kLGSideMenuControllerWillDismissRightViewNotification object:self userInfo:nil];

    if (animated)
    {
        [LGSideMenuController animateStandardWithDuration:_rightViewAnimationSpeed
                                               animations:^(void)
         {
             [self rootViewLayoutInvalidateWithPercentage:0.f];
             [self rightViewLayoutInvalidateWithPercentage:0.f];
         }
                                               completion:^(BOOL finished)
         {
             _rightViewShowing = NO;

             [self hideRightViewDone];

             if (finished)
                 [self hiddensInvalidate];

             [[NSNotificationCenter defaultCenter] postNotificationName:kLGSideMenuControllerDidDismissRightViewNotification object:self userInfo:nil];

             if (completionHandler) completionHandler();
         }];
    }
    else
    {
        [self rootViewLayoutInvalidateWithPercentage:0.f];
        [self rightViewLayoutInvalidateWithPercentage:0.f];
        [self hideRightViewDone];

        _rightViewShowing = NO;

        [self hiddensInvalidate];

        [[NSNotificationCenter defaultCenter] postNotificationName:kLGSideMenuControllerDidDismissRightViewNotification object:self userInfo:nil];

        if (completionHandler) completionHandler();
    }
}

- (void)hideRightViewDone
{
    if (kLGSideMenuSystemVersion >= 7.0)
    {
        [self addChildViewController:_rootVC];

        _currentPreferredStatusBarHidden = _savedStatusBarHidden;
        _currentPreferredStatusBarStyle = _savedStatusBarStyle;

        _waitingForUpdateStatusBar = YES;

        [self statusBarAppearanceUpdate];
        [self setNeedsStatusBarAppearanceUpdate];
    }
}

- (void)hideRightViewComleteAfterGesture
{
    [[NSNotificationCenter defaultCenter] postNotificationName:kLGSideMenuControllerWillDismissRightViewNotification object:self userInfo:nil];

    _rightViewShowing = NO;

    [self hideRightViewDone];
    [self hiddensInvalidate];

    [[NSNotificationCenter defaultCenter] postNotificationName:kLGSideMenuControllerDidDismissRightViewNotification object:self userInfo:nil];
}

- (void)showHideRightViewAnimated:(BOOL)animated completionHandler:(void (^)())completionHandler
{
    if (!kLGSideMenuIsRightViewAlwaysVisible)
    {
        if (self.isRightViewShowing)
            [self hideRightViewAnimated:animated completionHandler:completionHandler];
        else
            [self showRightViewAnimated:animated completionHandler:completionHandler];
    }
}

#pragma mark - UIGestureRecognizers

- (void)tapGesture:(UITapGestureRecognizer *)gesture
{
    [self hideLeftViewAnimated:YES completionHandler:nil];
    [self hideRightViewAnimated:YES completionHandler:nil];
}

- (void)panGesture:(UIPanGestureRecognizer *)gestureRecognizer
{
    CGPoint location = [gestureRecognizer locationInView:self.view];
    CGPoint velocity = [gestureRecognizer velocityInView:self.view];

    // -----

    CGSize size = self.view.frame.size;

    if (kLGSideMenuSystemVersion < 8.0)
    {
        if (kLGSideMenuStatusBarOrientationIsPortrait)
            size = CGSizeMake(MIN(size.width, size.height), MAX(size.width, size.height));
        else
            size = CGSizeMake(MAX(size.width, size.height), MIN(size.width, size.height));
    }

    // -----

    if (_leftView && self.isLeftViewSwipeGestureEnabled && !kLGSideMenuIsLeftViewAlwaysVisible && !_rightViewGestireStartX && !self.isRightViewShowing && self.shouldShowLeftView)
    {
        if (!_leftViewGestireStartX && (gestureRecognizer.state == UIGestureRecognizerStateBegan || gestureRecognizer.state == UIGestureRecognizerStateChanged))
        {
            CGFloat interactiveX = (self.isLeftViewShowing ? _leftViewWidth : 0.f);
            BOOL velocityDone = (self.isLeftViewShowing ? velocity.x < 0.f : velocity.x > 0.f);

            CGFloat shiftLeft = -44.f;
            CGFloat shiftRight = (_swipeGestureArea == LGSideMenuSwipeGestureAreaBorders ? (self.isLeftViewShowing ? 22.f : 44.f) :  _rootVC.view.bounds.size.width);

            if (velocityDone && location.x >= interactiveX+shiftLeft && location.x <= interactiveX+shiftRight)
            {
                _leftViewGestireStartX = [NSNumber numberWithFloat:location.x];
                _leftViewShowingBeforeGesture = _leftViewShowing;

                if (!self.isLeftViewShowing)
                    [self showLeftViewPrepare];
            }
        }
        else if (_leftViewGestireStartX)
        {
            CGFloat firstVar = (self.isLeftViewShowingBeforeGesture ?
                                location.x+(_leftViewWidth-_leftViewGestireStartX.floatValue) :
                                location.x-_leftViewGestireStartX.floatValue);
            
            CGFloat percentage = firstVar/_leftViewWidth;

            if (percentage < 0.f) percentage = 0.f;
            else if (percentage > 1.f) percentage = 1.f;

            if (gestureRecognizer.state == UIGestureRecognizerStateChanged)
            {
                [self rootViewLayoutInvalidateWithPercentage:percentage];
                [self leftViewLayoutInvalidateWithPercentage:percentage];
            }
            else if (gestureRecognizer.state == UIGestureRecognizerStateEnded && _leftViewGestireStartX)
            {
                if ((percentage < 1.f && velocity.x > 0.f) || (velocity.x == 0.f && percentage >= 0.5))
                    [self showLeftViewAnimated:YES fromPercentage:percentage completionHandler:nil];
                else if ((percentage > 0.f && velocity.x < 0.f) || (velocity.x == 0.f && percentage < 0.5))
                    [self hideLeftViewAnimated:YES fromPercentage:percentage completionHandler:nil];
                else if (percentage == 0.f)
                    [self hideLeftViewComleteAfterGesture];
                else if (percentage == 1.f)
                    [[NSNotificationCenter defaultCenter] postNotificationName:kLGSideMenuControllerDidShowLeftViewNotification object:self userInfo:nil];

                _leftViewGestireStartX = nil;
            }
        }
    }

    // -----

    if (_rightView && self.isRightViewSwipeGestureEnabled && !kLGSideMenuIsRightViewAlwaysVisible && !_leftViewGestireStartX && !self.isLeftViewShowing && self.shouldShowRightView)
    {
        if (!_rightViewGestireStartX && (gestureRecognizer.state == UIGestureRecognizerStateBegan || gestureRecognizer.state == UIGestureRecognizerStateChanged))
        {
            CGFloat interactiveX = (self.isRightViewShowing ? size.width-_rightViewWidth : size.width);
            BOOL velocityDone = (self.isRightViewShowing ? velocity.x > 0.f : velocity.x < 0.f);

            CGFloat shiftLeft = (_swipeGestureArea == LGSideMenuSwipeGestureAreaBorders ? (self.isRightViewShowing ? 22.f : 44.f) : _rootVC.view.bounds.size.width);
            CGFloat shiftRight = 44.f;

            if (velocityDone && location.x >= interactiveX-shiftLeft && location.x <= interactiveX+shiftRight)
            {
                _rightViewGestireStartX = [NSNumber numberWithFloat:location.x];
                _rightViewShowingBeforeGesture = _rightViewShowing;

                if (!self.isRightViewShowing)
                    [self showRightViewPrepare];
            }
        }
        else if (_rightViewGestireStartX)
        {
            CGFloat firstVar = (self.isRightViewShowingBeforeGesture ?
                                (location.x-(size.width-_rightViewWidth))-(_rightViewWidth-(size.width-_rightViewGestireStartX.floatValue)) :
                                (location.x-(size.width-_rightViewWidth))+(size.width-_rightViewGestireStartX.floatValue));
            CGFloat percentage = 1.f-firstVar/_rightViewWidth;

            if (percentage < 0.f) percentage = 0.f;
            else if (percentage > 1.f) percentage = 1.f;

            if (gestureRecognizer.state == UIGestureRecognizerStateChanged)
            {
                [self rootViewLayoutInvalidateWithPercentage:percentage];
                [self rightViewLayoutInvalidateWithPercentage:percentage];
            }
            else if (gestureRecognizer.state == UIGestureRecognizerStateEnded && _rightViewGestireStartX)
            {
                if ((percentage < 1.f && velocity.x < 0.f) || (velocity.x == 0.f && percentage >= 0.5))
                    [self showRightViewAnimated:YES fromPercentage:percentage completionHandler:nil];
                else if ((percentage > 0.f && velocity.x > 0.f) || (velocity.x == 0.f && percentage < 0.5))
                    [self hideRightViewAnimated:YES fromPercentage:percentage completionHandler:nil];
                else if (percentage == 0.f)
                    [self hideRightViewComleteAfterGesture];
                else if (percentage == 1.f)
                    [[NSNotificationCenter defaultCenter] postNotificationName:kLGSideMenuControllerDidShowRightViewNotification object:self userInfo:nil];
                
                _rightViewGestireStartX = nil;
            }
        }
    }
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    return ([touch.view isEqual:_rootViewCoverViewForLeftView] || [touch.view isEqual:_rootViewCoverViewForRightView]);
}

#pragma mark - Support

+ (void)animateStandardWithDuration:(NSTimeInterval)duration animations:(void(^)())animations completion:(void(^)(BOOL finished))completion
{
    if ([UIDevice currentDevice].systemVersion.floatValue >= 7.0)
    {
        [UIView animateWithDuration:duration
                              delay:0.0
             usingSpringWithDamping:1.f
              initialSpringVelocity:0.5
                            options:0
                         animations:animations
                         completion:completion];
    }
    else
    {
        [UIView animateWithDuration:duration*0.66
                              delay:0.0
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:animations
                         completion:completion];
    }
}

@end
