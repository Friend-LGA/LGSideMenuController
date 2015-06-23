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

@interface LeftViewController ()

@property (strong, nonatomic) NSArray *titlesArray;

@end

@implementation LeftViewController

- (id)init
{
    self = [super initWithStyle:UITableViewStylePlain];
    if (self)
    {
        _titlesArray = @[@"Set View Controllers",
                         @"Open Right View",
                         @"",
                         @"Profile",
                         @"News",
                         @"Articles",
                         @"Video",
                         @"Music"];
        
        [self.tableView registerClass:[LeftViewCell class] forCellReuseIdentifier:@"cell"];
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.tableView.contentInset = UIEdgeInsetsMake(20.f, 0.f, 20.f, 0.f);
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
    LeftViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    cell.textLabel.text = _titlesArray[indexPath.row];
    cell.separatorView.hidden = !(indexPath.row != _titlesArray.count-1 && indexPath.row != 1 && indexPath.row != 2);
    cell.userInteractionEnabled = (indexPath.row != 2);
    
    cell.tintColor = _tintColor;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 2) return 22.f;
    else return 44.f;
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
        
        [kMainViewController hideLeftViewAnimated:YES completionHandler:nil];
    }
    else if (indexPath.row == 1)
    {
        if (!kMainViewController.isLeftViewAlwaysVisible)
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
