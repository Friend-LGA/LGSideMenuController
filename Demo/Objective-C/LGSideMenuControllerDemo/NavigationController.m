//
//  NavigationController.m
//  LGSideMenuControllerDemo
//

#import "NavigationController.h"
#import "UIViewController+LGSideMenuController.h"
#import "Helper.h"

@implementation NavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setColors];
}

- (BOOL)shouldAutorotate {
    return YES;
}

- (BOOL)prefersStatusBarHidden {
    return UIInterfaceOrientationIsLandscape(UIApplication.sharedApplication.statusBarOrientation) && UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleDefault;
}

- (UIStatusBarAnimation)preferredStatusBarUpdateAnimation {
    return self.sideMenuController.isRightViewVisible ? UIStatusBarAnimationSlide : UIStatusBarAnimationFade;
}

- (void)traitCollectionDidChange:(UITraitCollection *)previousTraitCollection {
    [super traitCollectionDidChange:previousTraitCollection];
    [self setColors];
}

- (void)setColors {
    self.navigationBar.barTintColor = [UIColor colorWithWhite:(Helper.isLightTheme ? 1.0 : 0.0) alpha:0.9];
    self.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: (Helper.isLightTheme ? UIColor.blackColor : UIColor.whiteColor)};
}

@end
