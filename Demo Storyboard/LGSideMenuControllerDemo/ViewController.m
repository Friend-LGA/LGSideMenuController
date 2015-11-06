//
//  ViewController.m
//  LGSideMenuControllerDemo
//
//  Created by Grigory Lutkov on 18.02.15.
//  Copyright (c) 2015 Grigory Lutkov. All rights reserved.
//

#import "ViewController.h"
#import "AppDelegate.h"
#import "ChooseNavigationController.h"
#import "TableViewController.h"
#import "MainViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

#pragma mark -

- (IBAction)openLeftView:(id)sender
{
    [kMainViewController showLeftViewAnimated:YES completionHandler:nil];
}

- (IBAction)openRightView:(id)sender
{
    [kMainViewController showRightViewAnimated:YES completionHandler:nil];
}

- (IBAction)showChooseController:(id)sender
{
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
