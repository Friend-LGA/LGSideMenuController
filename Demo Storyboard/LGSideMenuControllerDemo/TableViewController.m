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

- (void)viewDidLoad {
    [super viewDidLoad];

    _titlesArray = @[@"Style Scale From Big",
                     @"Style Slide Above",
                     @"Style Slide Below",
                     @"Style Scale From Little",
                     @"Landscape always visible",
                     @"Status bar always visible",
                     @"Status bar light content",
                     @"Custom style"];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _titlesArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.textLabel.font = [UIFont systemFontOfSize:16.f];
    cell.textLabel.text = _titlesArray[indexPath.row];
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];

    UINavigationController *navigationController = [storyboard instantiateViewControllerWithIdentifier:@"NavigationController"];
    MainViewController *mainViewController = [storyboard instantiateInitialViewController];
    mainViewController.rootViewController = navigationController;

    if (indexPath.row == 0)
        [mainViewController setupWithPresentationStyle:LGSideMenuPresentationStyleScaleFromBig type:0];
    else if (indexPath.row == 1)
        [mainViewController setupWithPresentationStyle:LGSideMenuPresentationStyleSlideAbove type:0];
    else if (indexPath.row == 2)
        [mainViewController setupWithPresentationStyle:LGSideMenuPresentationStyleSlideBelow type:0];
    else if (indexPath.row == 3)
        [mainViewController setupWithPresentationStyle:LGSideMenuPresentationStyleScaleFromLittle type:0];
    else if (indexPath.row == 4)
        [mainViewController setupWithPresentationStyle:LGSideMenuPresentationStyleScaleFromBig type:1];
    else if (indexPath.row == 5)
        [mainViewController setupWithPresentationStyle:LGSideMenuPresentationStyleSlideAbove type:2];
    else if (indexPath.row == 6)
        [mainViewController setupWithPresentationStyle:LGSideMenuPresentationStyleSlideAbove type:3];
    else if (indexPath.row == 7)
        [mainViewController setupWithPresentationStyle:0 type:4];

    UIWindow *window = [UIApplication sharedApplication].delegate.window;

    window.rootViewController = mainViewController;

    [UIView transitionWithView:window
                      duration:0.3
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:nil
                    completion:nil];
}

@end
