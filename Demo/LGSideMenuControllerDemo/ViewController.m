//
//  ViewController.m
//  LGSideMenuControllerDemo
//
//  Created by Grigory Lutkov on 18.02.15.
//  Copyright (c) 2015 Grigory Lutkov. All rights reserved.
//

#import "ViewController.h"
#import "AppDelegate.h"

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
        [_button setTitle:@"Push View Controller" forState:UIControlStateNormal];
        [_button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_button setTitleColor:[UIColor colorWithRed:0.f green:0.5 blue:1.f alpha:1.f] forState:UIControlStateHighlighted];
        [_button addTarget:self action:@selector(pushViewControllerAction) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_button];
        
        // -----
        
        [self checkNavItemButtonsWithInterfaceOrientation:[UIApplication sharedApplication].statusBarOrientation];
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

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator
{
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
    
    UIInterfaceOrientation interfaceOrientation = (size.width < size.height ? UIInterfaceOrientationPortrait : UIInterfaceOrientationLandscapeLeft);
    
    [self checkNavItemButtonsWithInterfaceOrientation:interfaceOrientation];
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    [super willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
    
    [self checkNavItemButtonsWithInterfaceOrientation:toInterfaceOrientation];
}

- (void)checkNavItemButtonsWithInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if (TYPE == 4 || TYPE == 5)
    {
        if ([kMainViewController isLeftViewAlwaysVisibleForInterfaceOrientation:interfaceOrientation])
            self.navigationItem.leftBarButtonItem = nil;
        else
            self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Left" style:UIBarButtonItemStylePlain target:self action:@selector(openLeftView)];
        
        if ([kMainViewController isRightViewAlwaysVisibleForInterfaceOrientation:interfaceOrientation])
            self.navigationItem.rightBarButtonItem = nil;
        else
            self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Right" style:UIBarButtonItemStylePlain target:self action:@selector(openRightView)];
    }
    else
    {
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Left" style:UIBarButtonItemStylePlain target:self action:@selector(openLeftView)];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Right" style:UIBarButtonItemStylePlain target:self action:@selector(openRightView)];
    }
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

- (void)pushViewControllerAction
{
    UIViewController *viewController = [UIViewController new];
    viewController.view.backgroundColor = [UIColor whiteColor];
    viewController.title = @"Test";
    [self.navigationController pushViewController:viewController animated:YES];
}

@end
