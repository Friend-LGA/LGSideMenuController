//
//  ChooseNavigationController.m
//  LGSideMenuControllerDemo
//
//  Created by Grigory Lutkov on 05.11.15.
//  Copyright (c) 2015 Grigory Lutkov. All rights reserved.
//

#import "ChooseNavigationController.h"

@implementation ChooseNavigationController

- (BOOL)shouldAutorotate {
    return YES;
}

- (BOOL)prefersStatusBarHidden {
    return (UIInterfaceOrientationIsLandscape([UIApplication sharedApplication].statusBarOrientation) && UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone);
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (UIStatusBarAnimation)preferredStatusBarUpdateAnimation {
    return UIStatusBarAnimationNone;
}

@end
