//
//  MainViewController.m
//  LGSideMenuControllerDemo
//
//  Created by Grigory Lutkov on 25.04.15.
//  Copyright © 2015 Grigory Lutkov <Friend.LGA@gmail.com>. All rights reserved.
//

#import "MainViewController.h"
#import "ViewController.h"
#import "LeftViewController.h"
#import "RightViewController.h"
#import "AppDelegate.h"

@interface MainViewController ()

@property (strong, nonatomic) LeftViewController *leftViewController;
@property (strong, nonatomic) RightViewController *rightViewController;
@property (assign, nonatomic) NSUInteger type;

@end

@implementation MainViewController

- (void)setupWithPresentationStyle:(LGSideMenuPresentationStyle)style type:(NSUInteger)type {
    self.leftViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"LeftViewController"];
    self.rightViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"RightViewController"];

    // -----

    if (type == 0) {
        [self setLeftViewEnabledWithWidth:250.0
                        presentationStyle:style
                     alwaysVisibleOptions:LGSideMenuAlwaysVisibleOnNone];

        self.leftViewStatusBarStyle = UIStatusBarStyleDefault;
        self.leftViewStatusBarVisibleOptions = LGSideMenuStatusBarVisibleOnNone;

        // -----

        [self setRightViewEnabledWithWidth:100.0
                         presentationStyle:style
                      alwaysVisibleOptions:LGSideMenuAlwaysVisibleOnNone];

        self.rightViewStatusBarStyle = UIStatusBarStyleDefault;
        self.rightViewStatusBarVisibleOptions = LGSideMenuStatusBarVisibleOnNone;

        // -----

        switch (style) {
            case LGSideMenuPresentationStyleSlideAbove: {
                self.leftViewBackgroundColor = [UIColor colorWithWhite:1.0 alpha:0.9];
                self.leftViewController.tableView.backgroundColor = [UIColor clearColor];
                self.leftViewController.tintColor = [UIColor blackColor];

                self.rightViewBackgroundColor = [UIColor colorWithWhite:1.0 alpha:0.9];
                self.rightViewController.tableView.backgroundColor = [UIColor clearColor];
                self.rightViewController.tintColor = [UIColor blackColor];
                
                break;
            }
            case LGSideMenuPresentationStyleScaleFromBig:
            case LGSideMenuPresentationStyleSlideBelow:
            case LGSideMenuPresentationStyleScaleFromLittle: {
                self.leftViewBackgroundImage = [UIImage imageNamed:@"image"];
                self.leftViewController.tableView.backgroundColor = [UIColor clearColor];
                self.leftViewController.tintColor = [UIColor whiteColor];

                self.rightViewBackgroundImage = [UIImage imageNamed:@"image2"];
                self.rightViewController.tableView.backgroundColor = [UIColor clearColor];
                self.rightViewController.tintColor = [UIColor whiteColor];

                break;
            }
        }
    }
    else if (type == 1) {
        [self setLeftViewEnabledWithWidth:250.0
                        presentationStyle:style
                     alwaysVisibleOptions:LGSideMenuAlwaysVisibleOnPhoneLandscape|LGSideMenuAlwaysVisibleOnPadLandscape];

        self.leftViewStatusBarStyle = UIStatusBarStyleDefault;
        self.leftViewStatusBarVisibleOptions = LGSideMenuAlwaysVisibleOnPadLandscape;
        self.leftViewBackgroundImage = [UIImage imageNamed:@"image"];

        self.leftViewController.tableView.backgroundColor = [UIColor clearColor];
        self.leftViewController.tintColor = [UIColor whiteColor];

        // -----

        [self setRightViewEnabledWithWidth:100.0
                         presentationStyle:LGSideMenuPresentationStyleSlideAbove
                      alwaysVisibleOptions:LGSideMenuAlwaysVisibleOnNone];

        self.rightViewStatusBarStyle = UIStatusBarStyleDefault;
        self.rightViewStatusBarVisibleOptions = LGSideMenuAlwaysVisibleOnPadLandscape;
        self.rightViewBackgroundColor = [UIColor colorWithWhite:1.0 alpha:0.9];

        self.rightViewController.tableView.backgroundColor = [UIColor clearColor];
        self.rightViewController.tintColor = [UIColor blackColor];
    }
    else if (type == 2) {
        [self setLeftViewEnabledWithWidth:250.0
                        presentationStyle:style
                     alwaysVisibleOptions:LGSideMenuAlwaysVisibleOnNone];

        self.leftViewStatusBarStyle = UIStatusBarStyleDefault;
        self.leftViewStatusBarVisibleOptions = LGSideMenuStatusBarVisibleOnAll;
        self.leftViewBackgroundColor = [UIColor colorWithWhite:1.0 alpha:0.9];

        self.leftViewController.tableView.backgroundColor = [UIColor clearColor];
        self.leftViewController.tintColor = [UIColor blackColor];

        // -----

        [self setRightViewEnabledWithWidth:100.0
                         presentationStyle:style
                      alwaysVisibleOptions:LGSideMenuAlwaysVisibleOnNone];

        self.rightViewStatusBarStyle = UIStatusBarStyleDefault;
        self.rightViewStatusBarVisibleOptions = LGSideMenuStatusBarVisibleOnAll;
        self.rightViewBackgroundColor = [UIColor colorWithWhite:1.0 alpha:0.9];

        self.rightViewController.tableView.backgroundColor = [UIColor clearColor];
        self.rightViewController.tintColor = [UIColor blackColor];
    }
    else if (type == 3) {
        [self setLeftViewEnabledWithWidth:250.0
                        presentationStyle:style
                     alwaysVisibleOptions:LGSideMenuAlwaysVisibleOnNone];

        self.leftViewStatusBarStyle = UIStatusBarStyleLightContent;
        self.leftViewStatusBarVisibleOptions = LGSideMenuStatusBarVisibleOnAll;
        self.leftViewBackgroundColor = [UIColor colorWithWhite:0.0 alpha:0.5];

        self.leftViewController.tableView.backgroundColor = [UIColor clearColor];
        self.leftViewController.tintColor = [UIColor whiteColor];

        // -----

        [self setRightViewEnabledWithWidth:100.0
                         presentationStyle:style
                      alwaysVisibleOptions:LGSideMenuAlwaysVisibleOnNone];

        self.rightViewStatusBarStyle = UIStatusBarStyleLightContent;
        self.rightViewStatusBarVisibleOptions = LGSideMenuStatusBarVisibleOnAll;
        self.rightViewBackgroundColor = [UIColor colorWithWhite:0.0 alpha:0.5];

        self.rightViewController.tableView.backgroundColor = [UIColor clearColor];
        self.rightViewController.tintColor = [UIColor whiteColor];
    }
    else if (type == 4) {
        self.swipeGestureArea = LGSideMenuSwipeGestureAreaFull;
        self.rootViewCoverColorForLeftView = [UIColor colorWithRed:0.0 green:1.0 blue:0.5 alpha:0.3];
        self.rootViewScaleForLeftView = 0.6;
        self.rootViewLayerBorderWidth = 3.0;
        self.rootViewLayerBorderColor = [UIColor whiteColor];
        self.rootViewLayerShadowRadius = 10.0;
        self.rootViewCoverColorForRightView = [UIColor colorWithRed:0.0 green:0.5 blue:1.0 alpha:0.3];

        // -----

        [self setLeftViewEnabledWithWidth:250.0
                        presentationStyle:LGSideMenuPresentationStyleScaleFromBig
                     alwaysVisibleOptions:LGSideMenuAlwaysVisibleOnNone];

        self.leftViewAnimationSpeed = 0.4;
        self.leftViewStatusBarStyle = UIStatusBarStyleDefault;
        self.leftViewStatusBarVisibleOptions = LGSideMenuStatusBarVisibleOnNone;
        self.leftViewBackgroundImage = [UIImage imageNamed:@"image"];
        self.leftViewStatusBarVisibleOptions = LGSideMenuStatusBarVisibleOnPadLandscape;
        self.leftViewBackgroundImageInitialScale = 1.5;
        self.leftViewInititialOffsetX = -200.0;
        self.leftViewInititialScale = 1.5;

        self.leftViewController.tableView.backgroundColor = [UIColor clearColor];
        self.leftViewController.tintColor = [UIColor whiteColor];

        // -----

        [self setRightViewEnabledWithWidth:100.0
                         presentationStyle:LGSideMenuPresentationStyleSlideAbove
                      alwaysVisibleOptions:LGSideMenuAlwaysVisibleOnNone];

        self.rightViewAnimationSpeed = 0.3;
        self.rightViewStatusBarStyle = UIStatusBarStyleDefault;
        self.rightViewStatusBarVisibleOptions = LGSideMenuStatusBarVisibleOnNone;
        self.rightViewBackgroundColor = [UIColor colorWithWhite:1.0 alpha:0.7];
        self.rightViewStatusBarVisibleOptions = LGSideMenuStatusBarVisibleOnPadLandscape;
        self.rightViewLayerBorderWidth = 3.0;
        self.rightViewLayerBorderColor = [UIColor blackColor];
        self.rightViewLayerShadowRadius = 10.0;

        self.rightViewController.tableView.backgroundColor = [UIColor clearColor];
        self.rightViewController.tintColor = [UIColor blackColor];
    }

    // -----

    [self.leftViewController.tableView reloadData];
    [self.leftView addSubview:self.leftViewController.tableView];

    [self.rightViewController.tableView reloadData];
    [self.rightView addSubview:self.rightViewController.tableView];
}

- (void)leftViewWillLayoutSubviewsWithSize:(CGSize)size {
    [super leftViewWillLayoutSubviewsWithSize:size];

    if (![UIApplication sharedApplication].isStatusBarHidden && (self.type == 2 || self.type == 3)) {
        self.leftViewController.tableView.frame = CGRectMake(0.0, 20.0, size.width, size.height-20.0);
    }
    else {
        self.leftViewController.tableView.frame = CGRectMake(0.0, 0.0, size.width, size.height);
    }
}

- (void)rightViewWillLayoutSubviewsWithSize:(CGSize)size {
    [super rightViewWillLayoutSubviewsWithSize:size];
    
    if (![UIApplication sharedApplication].isStatusBarHidden && (self.type == 2 || self.type == 3)) {
        self.rightViewController.tableView.frame = CGRectMake(0.0, 20.0, size.width, size.height-20.0);
    }
    else {
        self.rightViewController.tableView.frame = CGRectMake(0.0, 0.0, size.width, size.height);
    }
}

@end
