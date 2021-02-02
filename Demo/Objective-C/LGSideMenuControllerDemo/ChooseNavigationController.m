//
//  ChooseNavigationController.m
//  LGSideMenuControllerDemo
//

#import "ChooseNavigationController.h"
#import "ChooseTableViewController.h"
#import "Helper.h"

@implementation ChooseNavigationController

- (instancetype)init {
    self = [super initWithRootViewController:ChooseTableViewController.new];
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationBar.barTintColor = [UIColor colorWithRed:0.0 green:0.5 blue:1.0 alpha:0.9];
    self.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: UIColor.whiteColor};
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

- (void)traitCollectionDidChange:(UITraitCollection *)previousTraitCollection {
    [super traitCollectionDidChange:previousTraitCollection];
    [self setColors];
}

- (void)setColors {
    self.view.backgroundColor = (Helper.isLightTheme ? UIColor.whiteColor : UIColor.blackColor);
}

@end
