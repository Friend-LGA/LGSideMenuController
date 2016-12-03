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
#import "UIViewController+LGSideMenuController.h"

@interface ViewController ()

@property (strong, nonatomic) UIImageView *imageView;
@property (strong, nonatomic) UIButton *button;

@end

@implementation ViewController

- (id)init {
    self = [super init];
    if (self) {
        self.title = @"LGSideMenuController";

        self.view.backgroundColor = [UIColor whiteColor];

        // -----

        self.imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"image3"]];
        self.imageView.contentMode = UIViewContentModeScaleAspectFill;
        [self.view addSubview:self.imageView];

        self.button = [UIButton new];
        self.button.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.5];
        [self.button setTitle:@"Show Choose Controller" forState:UIControlStateNormal];
        [self.button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.button setTitleColor:[UIColor colorWithRed:0.0 green:0.5 blue:1.0 alpha:1.0] forState:UIControlStateHighlighted];
        [self.button addTarget:self action:@selector(showChooseController) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:self.button];

        // -----

        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Left" style:UIBarButtonItemStylePlain target:self action:@selector(showLeftView)];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Right" style:UIBarButtonItemStylePlain target:self action:@selector(showRightView)];
    }
    return self;
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];

    self.imageView.frame = CGRectMake(0.0, 0.0, self.view.frame.size.width, self.view.frame.size.height);

    self.button.frame = CGRectMake(0.0, self.view.frame.size.height-44.0, self.view.frame.size.width, 44.0);
}

#pragma mark -

- (void)showLeftView {
    [self.sideMenuController showLeftViewAnimated:YES completionHandler:nil];
}

- (void)showRightView {
    [self.sideMenuController showRightViewAnimated:YES completionHandler:nil];
}

- (void)showChooseController {
    ChooseNavigationController *navigationController = [ChooseNavigationController new];

    UIWindow *window = [UIApplication sharedApplication].delegate.window;
    window.rootViewController = navigationController;

    [UIView transitionWithView:window
                      duration:0.3
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:nil
                    completion:nil];
}

@end
