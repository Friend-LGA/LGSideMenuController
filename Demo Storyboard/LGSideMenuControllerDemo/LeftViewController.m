//
//  LeftViewController.m
//  LGSideMenuControllerDemo
//
//  Created by Grigory Lutkov on 18.02.15.
//  Copyright (c) 2015 Grigory Lutkov. All rights reserved.
//

#import "LeftViewController.h"
#import "AppDelegate.h"
#import "LeftViewCell.h"
#import "ViewController.h"
#import "MainViewController.h"
#import "NavigationController.h"

@interface LeftViewController ()

@property (strong, nonatomic) NSArray *titlesArray;

@end

@implementation LeftViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    // -----

    _titlesArray = @[@"Open Right View",
                     @"",
                     @"Profile",
                     @"News",
                     @"Articles",
                     @"Video",
                     @"Music"];

    // -----

    self.tableView.contentInset = UIEdgeInsetsMake(44.f, 0.f, 44.f, 0.f);
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
    LeftViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];

    cell.textLabel.text = _titlesArray[indexPath.row];
    cell.separatorView.hidden = !(indexPath.row != 0 && indexPath.row != 1 && indexPath.row != _titlesArray.count-1);
    cell.userInteractionEnabled = (indexPath.row != 1);

    cell.tintColor = _tintColor;

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 1) return 22.f;
    else return 44.f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0)
    {
        if (![kMainViewController isLeftViewAlwaysVisible])
        {
            [kMainViewController hideLeftViewAnimated:YES completionHandler:^(void)
             {
                 [kMainViewController showRightViewAnimated:YES completionHandler:nil];
             }];
        }
        else [kMainViewController showRightViewAnimated:YES completionHandler:nil];
    }
    else
    {
        UIViewController *viewController = [UIViewController new];
        viewController.view.backgroundColor = [UIColor whiteColor];
        viewController.title = _titlesArray[indexPath.row];
        [kNavigationController pushViewController:viewController animated:YES];

        [kMainViewController hideLeftViewAnimated:YES completionHandler:nil];
    }
}

@end
