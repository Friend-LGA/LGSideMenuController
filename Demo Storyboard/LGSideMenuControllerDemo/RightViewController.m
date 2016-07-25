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

    _titlesArray = @[@"Open Left View",
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

    self.tableView.contentInset = UIEdgeInsetsMake(44.f, 0.f, 44.f, 0.f);
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _titlesArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    RightViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.textLabel.text = _titlesArray[indexPath.row];
    cell.textLabel.font = [UIFont boldSystemFontOfSize:indexPath.row == 0 ? 15.f : 30.f];
    cell.separatorView.hidden = indexPath.row <= 1 || indexPath.row == _titlesArray.count - 1;
    cell.userInteractionEnabled = indexPath.row != 1;
    cell.tintColor = _tintColor;
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return indexPath.row == 1 ? 50.f : 100.f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        if (![[self sideMenuController] isRightViewAlwaysVisible]) {
            [[self sideMenuController] hideRightViewAnimated:YES completionHandler:^(void) {
                [[self sideMenuController] showLeftViewAnimated:YES completionHandler:nil];
            }];
        } else {
            [[self sideMenuController] showLeftViewAnimated:YES completionHandler:nil];
        }
    } else {
        UIViewController *viewController = [UIViewController new];
        viewController.view.backgroundColor = [UIColor whiteColor];
        viewController.title = [NSString stringWithFormat:@"Test %@", _titlesArray[indexPath.row]];
        [(UINavigationController *)[self sideMenuController].rootViewController pushViewController:viewController animated:YES];

        [[self sideMenuController] hideRightViewAnimated:YES completionHandler:nil];
    }
}

@end
