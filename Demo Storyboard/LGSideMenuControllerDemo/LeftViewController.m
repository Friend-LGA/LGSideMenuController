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
#import "UIViewController+LGSideMenuController.h"

@interface LeftViewController ()

@property (strong, nonatomic) NSArray *titlesArray;

@end

@implementation LeftViewController

- (void)viewDidLoad {
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

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _titlesArray.count;
}

#pragma mark - UITableView Delegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LeftViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.textLabel.text = _titlesArray[indexPath.row];
    cell.separatorView.hidden = indexPath.row <= 1 || indexPath.row == _titlesArray.count - 1;
    cell.userInteractionEnabled = indexPath.row != 1;
    cell.tintColor = _tintColor;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return indexPath.row == 1 ? 22.f : 44.f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        if (![[self sideMenuController] isLeftViewAlwaysVisible]) {
            [[self sideMenuController] hideLeftViewAnimated:YES completionHandler:^(void) {
                [[self sideMenuController] showRightViewAnimated:YES completionHandler:nil];
            }];
        } else {
            [[self sideMenuController] showRightViewAnimated:YES completionHandler:nil];
        }
    } else {
        UIViewController *viewController = [UIViewController new];
        viewController.view.backgroundColor = [UIColor whiteColor];
        viewController.title = _titlesArray[indexPath.row];
        [(UINavigationController *)[self sideMenuController].rootViewController pushViewController:viewController animated:YES];

        [[self sideMenuController] hideLeftViewAnimated:YES completionHandler:nil];
    }
}

@end
