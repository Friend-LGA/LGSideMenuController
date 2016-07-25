//
//  AppDelegate.m
//  LGSideMenuControllerDemo
//
//  Created by Grigory Lutkov on 28.07.15.
//  Copyright (c) 2015 Grigory Lutkov. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    return YES;
}

- (void)application:(UIApplication *)application didChangeStatusBarOrientation:(UIInterfaceOrientation)oldStatusBarOrientation {
    application.statusBarHidden = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone && UIInterfaceOrientationIsLandscape(application.statusBarOrientation));
}

@end
