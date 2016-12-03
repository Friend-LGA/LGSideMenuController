//
//  ViewController.m
//  LGSideMenuControllerDemo
//
//  Created by Grigory Lutkov on 18.02.15.
//  Copyright © 2015 Grigory Lutkov <Friend.LGA@gmail.com>. All rights reserved.
//

#import "ViewController.h"
#import "AppDelegate.h"
#import "ChooseNavigationController.h"
#import "TableViewController.h"
#import "MainViewController.h"

@implementation ViewController

- (IBAction)showChooseController:(id)sender {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Choose" bundle:[NSBundle mainBundle]];

    ChooseNavigationController *navigationController = [storyboard instantiateInitialViewController];

    UIWindow *window = [UIApplication sharedApplication].delegate.window;
    window.rootViewController = navigationController;

    [UIView transitionWithView:window
                      duration:0.3
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:nil
                    completion:nil];
}

@end
