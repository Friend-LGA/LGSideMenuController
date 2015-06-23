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

@end

@implementation MainViewController

- (id)initWithRootViewController:(UIViewController *)rootViewController
{
    self = [super initWithRootViewController:rootViewController];
    if (self)
    {
        self.view.backgroundColor = [UIColor whiteColor];

        // -----
        
        if (TYPE == 1)
        {
            [self setLeftViewEnabledWithWidth:250.f
                            presentationStyle:LGSideMenuPresentationStyleScaleFromBig
                         alwaysVisibleOptions:0];
            
            self.leftViewBackgroundImage = [UIImage imageNamed:@"Image"];
            
            // -----
            
            [self setRightViewEnabledWithWidth:100.f
                             presentationStyle:LGSideMenuPresentationStyleScaleFromBig
                          alwaysVisibleOptions:0];
            
            self.rightViewBackgroundImage = [UIImage imageNamed:@"Image2"];
            
            // -----
            
            _leftViewController = [LeftViewController new];
            _leftViewController.tableView.backgroundColor = [UIColor clearColor];
            _leftViewController.tintColor = [UIColor whiteColor];
            [_leftViewController.tableView reloadData];
            
            [self.leftView addSubview:_leftViewController.tableView];
            
            // -----
            
            _rightViewController = [RightViewController new];
            _rightViewController.tableView.backgroundColor = [UIColor clearColor];
            _rightViewController.tintColor = [UIColor whiteColor];
            [_rightViewController.tableView reloadData];
            
            [self.rightView addSubview:_rightViewController.tableView];
        }
        else if (TYPE == 2)
        {
            [self setLeftViewEnabledWithWidth:250.f
                            presentationStyle:LGSideMenuPresentationStyleSlideAbove
                         alwaysVisibleOptions:0];
            
            self.leftViewBackgroundColor = [UIColor colorWithWhite:1.f alpha:0.9];
            
            // -----
            
            [self setRightViewEnabledWithWidth:100.f
                             presentationStyle:LGSideMenuPresentationStyleSlideAbove
                          alwaysVisibleOptions:0];
            
            self.rightViewBackgroundColor = [UIColor colorWithWhite:1.f alpha:0.9];
            
            // -----
            
            _leftViewController = [LeftViewController new];
            _leftViewController.tableView.backgroundColor = [UIColor clearColor];
            _leftViewController.tintColor = [UIColor blackColor];
            [_leftViewController.tableView reloadData];
            
            [self.leftView addSubview:_leftViewController.tableView];
            
            // -----
            
            _rightViewController = [RightViewController new];
            _rightViewController.tableView.backgroundColor = [UIColor clearColor];
            _rightViewController.tintColor = [UIColor blackColor];
            [_rightViewController.tableView reloadData];
            
            [self.rightView addSubview:_rightViewController.tableView];
        }
        else if (TYPE == 3)
        {
            [self setLeftViewEnabledWithWidth:250.f
                            presentationStyle:LGSideMenuPresentationStyleSlideBelow
                         alwaysVisibleOptions:0];
            
            self.leftViewBackgroundImage = [UIImage imageNamed:@"Image"];
            
            // -----
            
            [self setRightViewEnabledWithWidth:100.f
                             presentationStyle:LGSideMenuPresentationStyleSlideBelow
                          alwaysVisibleOptions:0];
            
            self.rightViewBackgroundImage = [UIImage imageNamed:@"Image2"];
            
            // -----
            
            _leftViewController = [LeftViewController new];
            _leftViewController.tableView.backgroundColor = [UIColor clearColor];
            _leftViewController.tintColor = [UIColor whiteColor];
            [_leftViewController.tableView reloadData];
            
            [self.leftView addSubview:_leftViewController.tableView];
            
            // -----
            
            _rightViewController = [RightViewController new];
            _rightViewController.tableView.backgroundColor = [UIColor clearColor];
            _rightViewController.tintColor = [UIColor whiteColor];
            [_rightViewController.tableView reloadData];
            
            [self.rightView addSubview:_rightViewController.tableView];
        }
        else if (TYPE == 4)
        {
            [self setLeftViewEnabledWithWidth:200.f
                            presentationStyle:LGSideMenuPresentationStyleScaleFromLittle
                         alwaysVisibleOptions:LGSideMenuAlwaysVisibleOnPadLandscape|LGSideMenuAlwaysVisibleOnPhoneLandscape];
            
            self.leftViewBackgroundImage = [UIImage imageNamed:@"Image"];
            self.leftViewStatusBarVisibleOptions = LGSideMenuStatusBarVisibleOnPadLandscape;
            
            // -----
            
            [self setRightViewEnabledWithWidth:100.f
                             presentationStyle:LGSideMenuPresentationStyleSlideAbove
                          alwaysVisibleOptions:0];
            
            self.rightViewBackgroundColor = [UIColor colorWithWhite:1.f alpha:0.9];
            self.rightViewStatusBarVisibleOptions = LGSideMenuStatusBarVisibleOnPadLandscape;
            
            // -----
            
            _leftViewController = [LeftViewController new];
            _leftViewController.tableView.backgroundColor = [UIColor clearColor];
            _leftViewController.tintColor = [UIColor whiteColor];
            [_leftViewController.tableView reloadData];
            
            [self.leftView addSubview:_leftViewController.tableView];
            
            // -----
            
            _rightViewController = [RightViewController new];
            _rightViewController.tableView.backgroundColor = [UIColor clearColor];
            _rightViewController.tintColor = [UIColor blackColor];
            [_rightViewController.tableView reloadData];
            
            [self.rightView addSubview:_rightViewController.tableView];
        }
        else if (TYPE == 5)
        {
            [self setLeftViewEnabledWithWidth:200.f
                            presentationStyle:LGSideMenuPresentationStyleScaleFromBig
                         alwaysVisibleOptions:LGSideMenuAlwaysVisibleOnPadLandscape|LGSideMenuAlwaysVisibleOnPhoneLandscape];
            
            self.leftViewBackgroundImage = [UIImage imageNamed:@"Image"];
            self.leftViewStatusBarVisibleOptions = LGSideMenuStatusBarVisibleOnPadLandscape;
            self.leftViewBackgroundImageInitialScale = 1.5;
            self.leftViewInititialOffsetX = -200.f;
            self.leftViewInititialScale = 1.5;
            
            self.rootViewCoverColorForLeftView = [UIColor colorWithRed:0.f green:1.f blue:0.5 alpha:0.3];
            self.rootViewScaleForLeftView = 0.6;
            self.rootViewLayerBorderWidth = 3.f;
            self.rootViewLayerBorderColor = [UIColor whiteColor];
            self.rootViewLayerShadowRadius = 10.f;
            
            // -----
            
            [self setRightViewEnabledWithWidth:100.f
                             presentationStyle:LGSideMenuPresentationStyleSlideAbove
                          alwaysVisibleOptions:LGSideMenuAlwaysVisibleOnPadLandscape|LGSideMenuAlwaysVisibleOnPhoneLandscape];
            
            self.rightViewBackgroundColor = [UIColor colorWithWhite:1.f alpha:0.7];
            self.rightViewStatusBarVisibleOptions = LGSideMenuStatusBarVisibleOnPadLandscape;
            self.rightViewLayerBorderWidth = 3.f;
            self.rightViewLayerBorderColor = [UIColor blackColor];
            self.rightViewLayerShadowRadius = 10.f;
            
            self.rootViewCoverColorForRightView = [UIColor colorWithRed:0.f green:0.5 blue:1.f alpha:0.3];
            
            // -----
            
            _leftViewController = [LeftViewController new];
            _leftViewController.tableView.backgroundColor = [UIColor clearColor];
            _leftViewController.tintColor = [UIColor whiteColor];
            [_leftViewController.tableView reloadData];
            
            [self.leftView addSubview:_leftViewController.tableView];
            
            // -----
            
            _rightViewController = [RightViewController new];
            _rightViewController.tableView.backgroundColor = [UIColor clearColor];
            _rightViewController.tintColor = [UIColor blackColor];
            [_rightViewController.tableView reloadData];
            
            [self.rightView addSubview:_rightViewController.tableView];
        }
    }
    return self;
}

- (void)leftViewWillLayoutSubviewsWithSize:(CGSize)size
{
    [super leftViewWillLayoutSubviewsWithSize:size];
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad && (TYPE == 4 || TYPE == 5))
    {
        if (self.isLeftViewAlwaysVisible)
        {
            _leftViewController.tableView.frame = CGRectMake(0.f , 20.f, size.width, size.height-20.f);
            _leftViewController.tableView.contentInset = UIEdgeInsetsMake(0.f, 0.f, 20.f, 0.f);
        }
        else
        {
            _leftViewController.tableView.frame = CGRectMake(0.f , 0.f, size.width, size.height);
            _leftViewController.tableView.contentInset = UIEdgeInsetsMake(20.f, 0.f, 20.f, 0.f);
        }
    }
    else _leftViewController.tableView.frame = CGRectMake(0.f , 0.f, size.width, size.height);
}

- (void)rightViewWillLayoutSubviewsWithSize:(CGSize)size
{
    [super rightViewWillLayoutSubviewsWithSize:size];
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad && (TYPE == 4 || TYPE == 5))
    {
        if (self.isLeftViewAlwaysVisible)
            _rightViewController.tableView.frame = CGRectMake(0.f , 20.f, size.width, size.height-20.f);
        else
            _rightViewController.tableView.frame = CGRectMake(0.f , 0.f, size.width, size.height);
    }
    else _rightViewController.tableView.frame = CGRectMake(0.f , 0.f, size.width, size.height);
}

@end
