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

@property (strong, nonatomic) UIImageView *imageView;
@property (strong, nonatomic) UIButton *button;

@end

@implementation ViewController

- (id)init
{
    self = [super init];
    if (self)
    {
        self.title = @"LGSideMenuController";

        self.view.backgroundColor = [UIColor whiteColor];

        // -----

        _imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"image3"]];
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        [self.view addSubview:_imageView];

        _button = [UIButton new];
        _button.backgroundColor = [UIColor colorWithWhite:1.f alpha:0.5];
        [_button setTitle:@"Show Choose Controller" forState:UIControlStateNormal];
        [_button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_button setTitleColor:[UIColor colorWithRed:0.f green:0.5 blue:1.f alpha:1.f] forState:UIControlStateHighlighted];
        [_button addTarget:self action:@selector(showChooseController) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_button];

        // -----

        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Left" style:UIBarButtonItemStylePlain target:self action:@selector(openLeftView)];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Right" style:UIBarButtonItemStylePlain target:self action:@selector(openRightView)];
    }
    return self;
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];

    _imageView.frame = CGRectMake(0.f, 0.f, self.view.frame.size.width, self.view.frame.size.height);

    _button.frame = CGRectMake(0.f, self.view.frame.size.height-44.f, self.view.frame.size.width, 44.f);
}

#pragma mark -

- (void)openLeftView
{
    [kMainViewController showLeftViewAnimated:YES completionHandler:nil];
}

- (void)openRightView
{
    [kMainViewController showRightViewAnimated:YES completionHandler:nil];
}

- (void)showChooseController
{
    TableViewController *viewController = [TableViewController new];
    ChooseNavigationController *navigationController = [[ChooseNavigationController alloc] initWithRootViewController:viewController];

    UIWindow *window = [UIApplication sharedApplication].delegate.window;

    window.rootViewController = navigationController;

    [UIView transitionWithView:window
                      duration:0.3
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:nil
                    completion:nil];
}

@end
