//
//  AppDelegate.h
//  LGSideMenuControllerDemo
//
//  Created by Grigory Lutkov on 18.02.15.
//  Copyright (c) 2015 Grigory Lutkov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainViewController.h"

#warning CHOOSE TYPE 1 .. 5

#define TYPE 3

#define kMainViewController [(AppDelegate *)[[UIApplication sharedApplication] delegate] mainViewController]
#define kNavigationController [(AppDelegate *)[[UIApplication sharedApplication] delegate] navigationController]

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) MainViewController *mainViewController;
@property (strong, nonatomic) UINavigationController *navigationController;

@end
