//
//  AppDelegate.h
//  LGSideMenuControllerDemo
//
//  Created by Grigory Lutkov on 28.07.15.
//  Copyright (c) 2015 Grigory Lutkov. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kMainViewController                            (MainViewController *)[UIApplication sharedApplication].delegate.window.rootViewController
#define kNavigationController (NavigationController *)[(MainViewController *)[UIApplication sharedApplication].delegate.window.rootViewController rootViewController]

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@end
