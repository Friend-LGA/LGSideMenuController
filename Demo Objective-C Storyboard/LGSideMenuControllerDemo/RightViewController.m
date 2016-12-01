//
//  RightViewController.m
//  LGSideMenuControllerDemo
//
//  Created by Grigory Lutkov on 18.02.15.
//  Copyright © 2015 Grigory Lutkov <Friend.LGA@gmail.com>. All rights reserved.
//

#import "RightViewController.h"
#import "AppDelegate.h"
#import "RightViewCell.h"
#import "ViewController.h"
#import "MainViewController.h"
#import "NavigationController.h"
#import "UIViewController+LGSideMenuController.h"

@interface RightViewController ()

@property (strong, nonatomic) NSArray *titlesArray;

@end

@implementation RightViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // -----

    self.titlesArray = @[@"Open Left View",
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

    // -----

    self.tableView.contentInset = UIEdgeInsetsMake(44.0, 0.0, 44.0, 0.0);
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.titlesArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    RightViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];

    cell.textLabel.text = self.titlesArray[indexPath.row];
    cell.textLabel.font = [UIFont boldSystemFontOfSize:indexPath.row == 0 ? 15.0 : 30.0];
    cell.separatorView.hidden = (indexPath.row <= 1 || indexPath.row == self.titlesArray.count - 1);
    cell.userInteractionEnabled = (indexPath.row != 1);
    cell.tintColor = self.tintColor;

    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return indexPath.row == 1 ? 50.0 : 100.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    MainViewController *mainViewController = (MainViewController *)[UIApplication sharedApplication].delegate.window.rootViewController;

    if (indexPath.row == 0) {
        if ([mainViewController isRightViewAlwaysVisible]) {
            [mainViewController showLeftViewAnimated:YES completionHandler:nil];
        }
        else {
            [mainViewController hideRightViewAnimated:YES completionHandler:^(void) {
                [mainViewController showLeftViewAnimated:YES completionHandler:nil];
            }];
        }
    }
    else {
        UIViewController *viewController = [UIViewController new];
        viewController.view.backgroundColor = [UIColor whiteColor];
        viewController.title = [NSString stringWithFormat:@"Test %@", self.titlesArray[indexPath.row]];

        NavigationController *navigationController = (NavigationController *)mainViewController.rootViewController;
        [navigationController pushViewController:viewController animated:YES];

        [mainViewController hideRightViewAnimated:YES completionHandler:nil];
    }
}

@end
