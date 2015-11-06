//
//  MainViewController.m
//  LGSideMenuControllerDemo
//
//  Created by Grigory Lutkov on 25.04.15.
//  Copyright (c) 2015 Grigory Lutkov. All rights reserved.
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

- (void)setupWithPresentationStyle:(LGSideMenuPresentationStyle)style
                              type:(NSUInteger)type
{
    _leftViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"LeftViewController"];
    _rightViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"RightViewController"];

    // -----

    if (type == 0)
    {
        [self setLeftViewEnabledWithWidth:250.f
                        presentationStyle:style
                     alwaysVisibleOptions:LGSideMenuAlwaysVisibleOnNone];

        self.leftViewStatusBarStyle = UIStatusBarStyleDefault;
        self.leftViewStatusBarVisibleOptions = LGSideMenuStatusBarVisibleOnNone;

        // -----

        [self setRightViewEnabledWithWidth:100.f
                         presentationStyle:style
                      alwaysVisibleOptions:LGSideMenuAlwaysVisibleOnNone];

        self.rightViewStatusBarStyle = UIStatusBarStyleDefault;
        self.rightViewStatusBarVisibleOptions = LGSideMenuStatusBarVisibleOnNone;

        // -----

        if (style == LGSideMenuPresentationStyleScaleFromBig)
        {
            self.leftViewBackgroundImage = [UIImage imageNamed:@"image"];

            _leftViewController.tableView.backgroundColor = [UIColor clearColor];
            _leftViewController.tintColor = [UIColor whiteColor];

            // -----

            self.rightViewBackgroundImage = [UIImage imageNamed:@"image2"];

            _rightViewController.tableView.backgroundColor = [UIColor clearColor];
            _rightViewController.tintColor = [UIColor whiteColor];
        }
        else if (style == LGSideMenuPresentationStyleSlideAbove)
        {
            self.leftViewBackgroundColor = [UIColor colorWithWhite:1.f alpha:0.9];

            _leftViewController.tableView.backgroundColor = [UIColor clearColor];
            _leftViewController.tintColor = [UIColor blackColor];

            // -----

            self.rightViewBackgroundColor = [UIColor colorWithWhite:1.f alpha:0.9];

            _rightViewController.tableView.backgroundColor = [UIColor clearColor];
            _rightViewController.tintColor = [UIColor blackColor];
        }
        else if (style == LGSideMenuPresentationStyleSlideBelow)
        {
            self.leftViewBackgroundImage = [UIImage imageNamed:@"image"];

            _leftViewController.tableView.backgroundColor = [UIColor clearColor];
            _leftViewController.tintColor = [UIColor whiteColor];

            // -----

            self.rightViewBackgroundImage = [UIImage imageNamed:@"image2"];

            _rightViewController.tableView.backgroundColor = [UIColor clearColor];
            _rightViewController.tintColor = [UIColor whiteColor];
        }
        else if (style == LGSideMenuPresentationStyleScaleFromLittle)
        {
            self.leftViewBackgroundImage = [UIImage imageNamed:@"image"];

            _leftViewController.tableView.backgroundColor = [UIColor clearColor];
            _leftViewController.tintColor = [UIColor whiteColor];

            // -----

            self.rightViewBackgroundImage = [UIImage imageNamed:@"image2"];

            _rightViewController.tableView.backgroundColor = [UIColor clearColor];
            _rightViewController.tintColor = [UIColor whiteColor];
        }
    }
    else if (type == 1)
    {
        [self setLeftViewEnabledWithWidth:250.f
                        presentationStyle:style
                     alwaysVisibleOptions:LGSideMenuAlwaysVisibleOnPhoneLandscape|LGSideMenuAlwaysVisibleOnPadLandscape];

        self.leftViewStatusBarStyle = UIStatusBarStyleDefault;
        self.leftViewStatusBarVisibleOptions = LGSideMenuAlwaysVisibleOnPadLandscape;
        self.leftViewBackgroundImage = [UIImage imageNamed:@"image"];

        _leftViewController.tableView.backgroundColor = [UIColor clearColor];
        _leftViewController.tintColor = [UIColor whiteColor];

        // -----

        [self setRightViewEnabledWithWidth:100.f
                         presentationStyle:LGSideMenuPresentationStyleSlideAbove
                      alwaysVisibleOptions:LGSideMenuAlwaysVisibleOnNone];

        self.rightViewStatusBarStyle = UIStatusBarStyleDefault;
        self.rightViewStatusBarVisibleOptions = LGSideMenuAlwaysVisibleOnPadLandscape;
        self.rightViewBackgroundColor = [UIColor colorWithWhite:1.f alpha:0.9];

        _rightViewController.tableView.backgroundColor = [UIColor clearColor];
        _rightViewController.tintColor = [UIColor blackColor];
    }
    else if (type == 2)
    {
        [self setLeftViewEnabledWithWidth:250.f
                        presentationStyle:style
                     alwaysVisibleOptions:LGSideMenuAlwaysVisibleOnNone];

        self.leftViewStatusBarStyle = UIStatusBarStyleDefault;
        self.leftViewStatusBarVisibleOptions = LGSideMenuStatusBarVisibleOnAll;
        self.leftViewBackgroundColor = [UIColor colorWithWhite:1.f alpha:0.9];

        _leftViewController.tableView.backgroundColor = [UIColor clearColor];
        _leftViewController.tintColor = [UIColor blackColor];

        // -----

        [self setRightViewEnabledWithWidth:100.f
                         presentationStyle:style
                      alwaysVisibleOptions:LGSideMenuAlwaysVisibleOnNone];

        self.rightViewStatusBarStyle = UIStatusBarStyleDefault;
        self.rightViewStatusBarVisibleOptions = LGSideMenuStatusBarVisibleOnAll;
        self.rightViewBackgroundColor = [UIColor colorWithWhite:1.f alpha:0.9];

        _rightViewController.tableView.backgroundColor = [UIColor clearColor];
        _rightViewController.tintColor = [UIColor blackColor];
    }
    else if (type == 3)
    {
        [self setLeftViewEnabledWithWidth:250.f
                        presentationStyle:style
                     alwaysVisibleOptions:LGSideMenuAlwaysVisibleOnNone];

        self.leftViewStatusBarStyle = UIStatusBarStyleLightContent;
        self.leftViewStatusBarVisibleOptions = LGSideMenuStatusBarVisibleOnAll;
        self.leftViewBackgroundColor = [UIColor colorWithWhite:0.f alpha:0.5];

        _leftViewController.tableView.backgroundColor = [UIColor clearColor];
        _leftViewController.tintColor = [UIColor whiteColor];

        // -----

        [self setRightViewEnabledWithWidth:100.f
                         presentationStyle:style
                      alwaysVisibleOptions:LGSideMenuAlwaysVisibleOnNone];

        self.rightViewStatusBarStyle = UIStatusBarStyleLightContent;
        self.rightViewStatusBarVisibleOptions = LGSideMenuStatusBarVisibleOnAll;
        self.rightViewBackgroundColor = [UIColor colorWithWhite:0.f alpha:0.5];

        _rightViewController.tableView.backgroundColor = [UIColor clearColor];
        _rightViewController.tintColor = [UIColor whiteColor];
    }
    else if (type == 4)
    {
        self.swipeGestureArea = LGSideMenuSwipeGestureAreaFull;
        self.rootViewCoverColorForLeftView = [UIColor colorWithRed:0.f green:1.f blue:0.5 alpha:0.3];
        self.rootViewScaleForLeftView = 0.6;
        self.rootViewLayerBorderWidth = 3.f;
        self.rootViewLayerBorderColor = [UIColor whiteColor];
        self.rootViewLayerShadowRadius = 10.f;
        self.rootViewCoverColorForRightView = [UIColor colorWithRed:0.f green:0.5 blue:1.f alpha:0.3];

        // -----

        [self setLeftViewEnabledWithWidth:250.f
                        presentationStyle:LGSideMenuPresentationStyleScaleFromBig
                     alwaysVisibleOptions:LGSideMenuAlwaysVisibleOnNone];

        self.leftViewAnimationSpeed = 0.4;
        self.leftViewStatusBarStyle = UIStatusBarStyleDefault;
        self.leftViewStatusBarVisibleOptions = LGSideMenuStatusBarVisibleOnNone;
        self.leftViewBackgroundImage = [UIImage imageNamed:@"image"];
        self.leftViewStatusBarVisibleOptions = LGSideMenuStatusBarVisibleOnPadLandscape;
        self.leftViewBackgroundImageInitialScale = 1.5;
        self.leftViewInititialOffsetX = -200.f;
        self.leftViewInititialScale = 1.5;

        _leftViewController.tableView.backgroundColor = [UIColor clearColor];
        _leftViewController.tintColor = [UIColor whiteColor];

        // -----

        [self setRightViewEnabledWithWidth:100.f
                         presentationStyle:LGSideMenuPresentationStyleSlideAbove
                      alwaysVisibleOptions:LGSideMenuAlwaysVisibleOnNone];

        self.rightViewAnimationSpeed = 0.3;
        self.rightViewStatusBarStyle = UIStatusBarStyleDefault;
        self.rightViewStatusBarVisibleOptions = LGSideMenuStatusBarVisibleOnNone;
        self.rightViewBackgroundColor = [UIColor colorWithWhite:1.f alpha:0.7];
        self.rightViewStatusBarVisibleOptions = LGSideMenuStatusBarVisibleOnPadLandscape;
        self.rightViewLayerBorderWidth = 3.f;
        self.rightViewLayerBorderColor = [UIColor blackColor];
        self.rightViewLayerShadowRadius = 10.f;

        _rightViewController.tableView.backgroundColor = [UIColor clearColor];
        _rightViewController.tintColor = [UIColor blackColor];
    }

    // -----

    [_leftViewController.tableView reloadData];
    [self.leftView addSubview:_leftViewController.tableView];

    [_rightViewController.tableView reloadData];
    [self.rightView addSubview:_rightViewController.tableView];
}

- (void)leftViewWillLayoutSubviewsWithSize:(CGSize)size
{
    [super leftViewWillLayoutSubviewsWithSize:size];

    if (![UIApplication sharedApplication].isStatusBarHidden && (_type == 2 || _type == 3))
        _leftViewController.tableView.frame = CGRectMake(0.f , 20.f, size.width, size.height-20.f);
    else
        _leftViewController.tableView.frame = CGRectMake(0.f , 0.f, size.width, size.height);
}

- (void)rightViewWillLayoutSubviewsWithSize:(CGSize)size
{
    [super rightViewWillLayoutSubviewsWithSize:size];
    
    if (![UIApplication sharedApplication].isStatusBarHidden && (_type == 2 || _type == 3))
        _rightViewController.tableView.frame = CGRectMake(0.f , 20.f, size.width, size.height-20.f);
    else
        _rightViewController.tableView.frame = CGRectMake(0.f , 0.f, size.width, size.height);
}

@end
