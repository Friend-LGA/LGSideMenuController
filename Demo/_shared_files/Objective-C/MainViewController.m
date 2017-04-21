//
//  MainViewController.m
//  LGSideMenuControllerDemo
//

#import "MainViewController.h"
#import "ViewController.h"
#import "LeftViewController.h"
#import "RightViewController.h"

@interface MainViewController ()

@property (assign, nonatomic) NSUInteger type;

@end

@implementation MainViewController

- (void)setupWithType:(NSUInteger)type {
    self.type = type;

    // -----

    if (self.storyboard) {
        // Left and Right view controllers is set in storyboard
        // Use custom segues with class "LGSideMenuSegue" and identifiers "left" and "right"

        // Sizes and styles is set in storybord
        // You can also find there all other properties

        // LGSideMenuController fully customizable from storyboard
    }
    else {
        self.leftViewController = [LeftViewController new];
        self.rightViewController = [RightViewController new];

        self.leftViewWidth = 250.0;
        self.leftViewBackgroundImage = [UIImage imageNamed:@"imageLeft"];
        self.leftViewBackgroundColor = [UIColor colorWithRed:0.5 green:0.65 blue:0.5 alpha:0.95];
        self.rootViewCoverColorForLeftView = [UIColor colorWithRed:0.0 green:1.0 blue:0.0 alpha:0.05];



        self.rightViewWidth = 100.0;
        self.rightViewBackgroundImage = [UIImage imageNamed:@"imageRight"];
        self.rightViewBackgroundColor = [UIColor colorWithRed:0.65 green:0.5 blue:0.65 alpha:0.95];
        self.rootViewCoverColorForRightView = [UIColor colorWithRed:1.0 green:0.0 blue:1.0 alpha:0.05];
    }

    // -----

    UIColor *greenCoverColor = [UIColor colorWithRed:0.0 green:0.1 blue:0.0 alpha:0.3];
    UIColor *purpleCoverColor = [UIColor colorWithRed:0.1 green:0.0 blue:0.1 alpha:0.3];
    UIBlurEffectStyle regularStyle;

    if (UIDevice.currentDevice.systemVersion.floatValue >= 10.0) {
        regularStyle = UIBlurEffectStyleRegular;
    }
    else {
        regularStyle = UIBlurEffectStyleLight;
    }

    // -----

    switch (self.type) {
        case 0: {
            self.leftViewPresentationStyle = LGSideMenuPresentationStyleScaleFromBig;
            self.rightViewPresentationStyle = LGSideMenuPresentationStyleScaleFromBig;

            break;
        }
        case 1: {
            self.leftViewPresentationStyle = LGSideMenuPresentationStyleSlideAbove;
            self.rootViewCoverColorForLeftView = greenCoverColor;

            self.rightViewPresentationStyle = LGSideMenuPresentationStyleSlideAbove;
            self.rootViewCoverColorForRightView = purpleCoverColor;

            break;
        }
        case 2: {
            self.leftViewPresentationStyle = LGSideMenuPresentationStyleSlideBelow;
            self.rightViewPresentationStyle = LGSideMenuPresentationStyleSlideBelow;

            break;
        }
        case 3: {
            self.leftViewPresentationStyle = LGSideMenuPresentationStyleScaleFromLittle;
            self.rightViewPresentationStyle = LGSideMenuPresentationStyleScaleFromLittle;

            break;
        }
        case 4: {
            self.leftViewPresentationStyle = LGSideMenuPresentationStyleScaleFromBig;
            self.rootViewCoverBlurEffectForLeftView = [UIBlurEffect effectWithStyle:regularStyle];
            self.rootViewCoverAlphaForLeftView = 0.8;

            self.rightViewPresentationStyle = LGSideMenuPresentationStyleScaleFromBig;
            self.rootViewCoverBlurEffectForRightView = [UIBlurEffect effectWithStyle:regularStyle];
            self.rootViewCoverAlphaForRightView = 0.8;

            break;
        }
        case 5: {
            self.leftViewPresentationStyle = LGSideMenuPresentationStyleScaleFromBig;
            self.leftViewCoverBlurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
            self.leftViewCoverColor = nil;

            self.rightViewPresentationStyle = LGSideMenuPresentationStyleScaleFromBig;
            self.rightViewCoverBlurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
            self.rightViewCoverColor = nil;

            break;
        }
        case 6: {
            self.leftViewPresentationStyle = LGSideMenuPresentationStyleSlideAbove;
            self.leftViewBackgroundBlurEffect = [UIBlurEffect effectWithStyle:regularStyle];
            self.leftViewBackgroundColor = [UIColor colorWithRed:0.0 green:1.0 blue:0.0 alpha:0.05];
            self.rootViewCoverColorForLeftView = greenCoverColor;

            self.rightViewPresentationStyle = LGSideMenuPresentationStyleSlideAbove;
            self.rightViewBackgroundBlurEffect = [UIBlurEffect effectWithStyle:regularStyle];
            self.rightViewBackgroundColor = [UIColor colorWithRed:1.0 green:0.0 blue:1.0 alpha:0.05];
            self.rootViewCoverColorForRightView = purpleCoverColor;

            break;
        }
        case 7: {
            self.leftViewPresentationStyle = LGSideMenuPresentationStyleSlideAbove;
            self.rootViewCoverColorForLeftView = greenCoverColor;

            self.rightViewPresentationStyle = LGSideMenuPresentationStyleSlideBelow;
            self.rightViewAlwaysVisibleOptions = LGSideMenuAlwaysVisibleOnPhoneLandscape|LGSideMenuAlwaysVisibleOnPadLandscape;

            break;
        }
        case 8: {
            self.leftViewPresentationStyle = LGSideMenuPresentationStyleScaleFromBig;
            self.leftViewStatusBarStyle = UIStatusBarStyleLightContent;

            self.rightViewPresentationStyle = LGSideMenuPresentationStyleScaleFromBig;
            self.rightViewStatusBarStyle = UIStatusBarStyleLightContent;

            break;
        }
        case 9: {
            self.swipeGestureArea = LGSideMenuSwipeGestureAreaFull;

            self.leftViewPresentationStyle = LGSideMenuPresentationStyleScaleFromBig;
            self.rightViewPresentationStyle = LGSideMenuPresentationStyleScaleFromBig;

            break;
        }
        case 10: {
            self.leftViewPresentationStyle = LGSideMenuPresentationStyleScaleFromBig;
            self.rightViewPresentationStyle = LGSideMenuPresentationStyleScaleFromBig;

            break;
        }
        case 11: {
            self.rootViewLayerBorderWidth = 5.0;
            self.rootViewLayerBorderColor = [UIColor whiteColor];
            self.rootViewLayerShadowRadius = 10.0;

            self.leftViewSwipeGestureRange = LGSideMenuSwipeGestureRangeMake(0.0, 88.0);
            self.leftViewPresentationStyle = LGSideMenuPresentationStyleScaleFromBig;
            self.leftViewAnimationDuration = 1.0;
            self.leftViewBackgroundColor = [UIColor colorWithRed:0.5 green:0.75 blue:0.5 alpha:1.0];
            self.leftViewBackgroundImageInitialScale = 1.5;
            self.leftViewInitialOffsetX = -200.0;
            self.leftViewInitialScale = 1.5;
            self.leftViewCoverBlurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
            self.leftViewBackgroundImage = nil;

            self.rootViewScaleForLeftView = 0.6;
            self.rootViewCoverColorForLeftView = [UIColor colorWithRed:1.0 green:1.0 blue:0.0 alpha:0.3];
            self.rootViewCoverBlurEffectForLeftView = [UIBlurEffect effectWithStyle:regularStyle];
            self.rootViewCoverAlphaForLeftView = 0.9;

            self.rightViewSwipeGestureRange = LGSideMenuSwipeGestureRangeMake(88.0, 0.0);
            self.rightViewPresentationStyle = LGSideMenuPresentationStyleSlideAbove;
            self.rightViewAnimationDuration = 0.25;
            self.rightViewBackgroundColor = [UIColor colorWithRed:0.75 green:0.5 blue:0.75 alpha:1.0];
            self.rightViewLayerBorderWidth = 3.0;
            self.rightViewLayerBorderColor = [UIColor blackColor];
            self.rightViewLayerShadowRadius = 10.0;

            self.rootViewCoverColorForRightView = [UIColor colorWithRed:0.0 green:0.5 blue:1.0 alpha:0.3];
            self.rootViewCoverBlurEffectForRightView = [UIBlurEffect effectWithStyle:regularStyle];
            self.rootViewCoverAlphaForRightView = 0.9;

            break;
        }
    }
}

- (void)leftViewWillLayoutSubviewsWithSize:(CGSize)size {
    [super leftViewWillLayoutSubviewsWithSize:size];

    if (!self.isLeftViewStatusBarHidden) {
        self.leftView.frame = CGRectMake(0.0, 20.0, size.width, size.height-20.0);
    }
}

- (void)rightViewWillLayoutSubviewsWithSize:(CGSize)size {
    [super rightViewWillLayoutSubviewsWithSize:size];

    if (!self.isRightViewStatusBarHidden ||
        (self.rightViewAlwaysVisibleOptions & LGSideMenuAlwaysVisibleOnPadLandscape &&
         UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad &&
         UIInterfaceOrientationIsLandscape(UIApplication.sharedApplication.statusBarOrientation))) {
        self.rightView.frame = CGRectMake(0.0, 20.0, size.width, size.height-20.0);
    }
}

- (BOOL)isLeftViewStatusBarHidden {
    if (self.type == 8) {
        return UIInterfaceOrientationIsLandscape(UIApplication.sharedApplication.statusBarOrientation) && UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone;
    }

    return super.isLeftViewStatusBarHidden;
}

- (BOOL)isRightViewStatusBarHidden {
    if (self.type == 8) {
        return UIInterfaceOrientationIsLandscape(UIApplication.sharedApplication.statusBarOrientation) && UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone;
    }

    return super.isRightViewStatusBarHidden;
}

- (void)dealloc {
    NSLog(@"MainViewController deallocated");
}

@end
