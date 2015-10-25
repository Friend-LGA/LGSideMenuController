//
//  RightViewController.m
//  LGSideMenuControllerDemo
//
//  Created by Grigory Lutkov on 18.02.15.
//  Copyright (c) 2015 Grigory Lutkov. All rights reserved.
//

#import "RightViewController.h"
#import "AppDelegate.h"
#import "RightViewCell.h"
#import "ViewController.h"

@interface RightViewController ()

@property (strong, nonatomic) NSArray *titlesArray;

@end

@implementation RightViewController

- (id)init
{
    self = [super initWithStyle:UITableViewStylePlain];
    if (self)
    {
        _titlesArray = @[@"Set VC",
                         @"Open Left View",
                         @"",
                         @"1",
                         @"2",
                         @"3",
                         @"4",
                         @"5",
                         @"6",
                         @"7",
                         @"8",
                         @"9",
                         @"10"];

        [self.tableView registerClass:[RightViewCell class] forCellReuseIdentifier:@"cell"];
        self.tableView.separatorStyle = UITableViewCellSelectionStyleNone;
        self.tableView.showsVerticalScrollIndicator = NO;
    }
    return self;
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
    RightViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];

    cell.textLabel.text = _titlesArray[indexPath.row];
    if (indexPath.row < 3)
        cell.textLabel.font = [UIFont boldSystemFontOfSize:15.f];
    else
        cell.textLabel.font = [UIFont boldSystemFontOfSize:30.f];
    cell.separatorView.hidden = !(indexPath.row != _titlesArray.count-1 && indexPath.row != 1 && indexPath.row != 2);
    cell.userInteractionEnabled = (indexPath.row != 2);

    cell.tintColor = _tintColor;

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 2) return 50.f;
    else return 100.f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0)
    {
        ViewController *viewController = [ViewController new];

        UIViewController *viewController2 = [UIViewController new];
        viewController2.view.backgroundColor = [UIColor whiteColor];
        viewController2.title = @"Test";

        [kNavigationController setViewControllers:@[viewController, viewController2]];

        [kMainViewController hideRightViewAnimated:YES completionHandler:nil];
    }
    else if (indexPath.row == 1)
    {
        if (!kMainViewController.isRightViewAlwaysVisible)
        {
            [kMainViewController hideRightViewAnimated:YES completionHandler:^(void)
             {
                 [kMainViewController showLeftViewAnimated:YES completionHandler:nil];
             }];
        }
        else [kMainViewController showLeftViewAnimated:YES completionHandler:nil];
    }
    else
    {
        UIViewController *viewController = [UIViewController new];
        viewController.view.backgroundColor = [UIColor whiteColor];
        viewController.title = [NSString stringWithFormat:@"Test %@", _titlesArray[indexPath.row]];
        [kNavigationController pushViewController:viewController animated:YES];

        [kMainViewController hideRightViewAnimated:YES completionHandler:nil];
    }
}

@end
