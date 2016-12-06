//
//  NavigationController.m
//  LGSideMenuControllerDemo
//

#import "NavigationController.h"
#import "UIViewController+LGSideMenuController.h"

@implementation NavigationController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationBar.translucent = YES;
    self.navigationBar.barTintColor = [UIColor whiteColor];
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

@end
