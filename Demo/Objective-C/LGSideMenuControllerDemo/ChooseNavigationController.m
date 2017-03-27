//
//  ChooseNavigationController.m
//  LGSideMenuControllerDemo
//

#import "ChooseNavigationController.h"
#import "TableViewController.h"

@implementation ChooseNavigationController

- (instancetype)init {
    TableViewController *viewController = [TableViewController new];

    self = [super initWithRootViewController:viewController];

    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationBar.translucent = YES;
    self.navigationBar.barTintColor = [UIColor colorWithRed:0.0 green:0.5 blue:1.0 alpha:1.0];
    self.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor whiteColor]};
    self.navigationBar.tintColor = [UIColor colorWithWhite:1.0 alpha:0.5];
}

- (BOOL)shouldAutorotate {
    return YES;
}

- (BOOL)prefersStatusBarHidden {
    return UIInterfaceOrientationIsLandscape(UIApplication.sharedApplication.statusBarOrientation) && UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (UIStatusBarAnimation)preferredStatusBarUpdateAnimation {
    return UIStatusBarAnimationNone;
}

@end
