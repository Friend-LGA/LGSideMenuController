//
//  TableViewController.m
//  LGSideMenuControllerDemo
//
//  Created by Grigory Lutkov on 05.11.15.
//  Copyright (c) 2015 Grigory Lutkov. All rights reserved.
//

#import "TableViewController.h"
#import "MainViewController.h"
#import "NavigationController.h"
#import "ViewController.h"

@interface TableViewController ()

@property (strong, nonatomic) NSArray *titlesArray;

@end

@implementation TableViewController

- (id)init
{
    self = [super initWithStyle:UITableViewStylePlain];
    if (self)
    {
        self.title = @"LGSideMenuController";

        _titlesArray = @[@"Style Scale From Big",
                         @"Style Slide Above",
                         @"Style Slide Below",
                         @"Style Scale From Little",
                         @"Landscape always visible",
                         @"Status bar always visible",
                         @"Status bar light content",
                         @"Custom style"];

        [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];

        self.clearsSelectionOnViewWillAppear = NO;
    }
    return self;
}

#pragma mark - UITableView DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _titlesArray.count;
}

#pragma mark - UITableView Delegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];

    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

    cell.textLabel.font = [UIFont systemFontOfSize:16.f];
    cell.textLabel.text = _titlesArray[indexPath.row];

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44.f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ViewController *viewController = [ViewController new];
    NavigationController *navigationController = [[NavigationController alloc] initWithRootViewController:viewController];
    MainViewController *mainViewController = nil;

    if (indexPath.row == 0)
        mainViewController = [[MainViewController alloc] initWithRootViewController:navigationController
                                                                  presentationStyle:LGSideMenuPresentationStyleScaleFromBig
                                                                               type:0];
    else if (indexPath.row == 1)
        mainViewController = [[MainViewController alloc] initWithRootViewController:navigationController
                                                                  presentationStyle:LGSideMenuPresentationStyleSlideAbove
                                                                               type:0];
    else if (indexPath.row == 2)
        mainViewController = [[MainViewController alloc] initWithRootViewController:navigationController
                                                                  presentationStyle:LGSideMenuPresentationStyleSlideBelow
                                                                               type:0];
    else if (indexPath.row == 3)
        mainViewController = [[MainViewController alloc] initWithRootViewController:navigationController
                                                                  presentationStyle:LGSideMenuPresentationStyleScaleFromLittle
                                                                               type:0];
    else if (indexPath.row == 4)
        mainViewController = [[MainViewController alloc] initWithRootViewController:navigationController
                                                                  presentationStyle:LGSideMenuPresentationStyleScaleFromBig
                                                                               type:1];
    else if (indexPath.row == 5)
        mainViewController = [[MainViewController alloc] initWithRootViewController:navigationController
                                                                  presentationStyle:LGSideMenuPresentationStyleSlideAbove
                                                                               type:2];
    else if (indexPath.row == 6)
        mainViewController = [[MainViewController alloc] initWithRootViewController:navigationController
                                                                  presentationStyle:LGSideMenuPresentationStyleSlideAbove
                                                                               type:3];
    else if (indexPath.row == 7)
        mainViewController = [[MainViewController alloc] initWithRootViewController:navigationController
                                                                  presentationStyle:0
                                                                               type:4];

    UIWindow *window = [UIApplication sharedApplication].delegate.window;

    window.rootViewController = mainViewController;

    [UIView transitionWithView:window
                      duration:0.3
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:nil
                    completion:nil];
}

@end
