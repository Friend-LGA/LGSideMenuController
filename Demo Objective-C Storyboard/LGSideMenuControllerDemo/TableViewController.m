//
//  TableViewController.m
//  LGSideMenuControllerDemo
//
//  Created by Grigory Lutkov on 05.11.15.
//  Copyright © 2015 Grigory Lutkov <Friend.LGA@gmail.com>. All rights reserved.
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

    self.titlesArray = @[@"Style Scale From Big",
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
    return self.titlesArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];

    cell.textLabel.font = [UIFont systemFontOfSize:16.0];
    cell.textLabel.text = self.titlesArray[indexPath.row];

    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];

    UINavigationController *navigationController = [storyboard instantiateViewControllerWithIdentifier:@"NavigationController"];
    MainViewController *mainViewController = [storyboard instantiateInitialViewController];
    mainViewController.rootViewController = navigationController;

    switch (indexPath.row) {
        case 0:
            [mainViewController setupWithPresentationStyle:LGSideMenuPresentationStyleScaleFromBig type:0];
            break;
        case 1:
            [mainViewController setupWithPresentationStyle:LGSideMenuPresentationStyleSlideAbove type:0];
            break;
        case 2:
            [mainViewController setupWithPresentationStyle:LGSideMenuPresentationStyleSlideBelow type:0];
            break;
        case 3:
            [mainViewController setupWithPresentationStyle:LGSideMenuPresentationStyleScaleFromLittle type:0];
            break;
        case 4:
            [mainViewController setupWithPresentationStyle:LGSideMenuPresentationStyleScaleFromBig type:1];
            break;
        case 5:
            [mainViewController setupWithPresentationStyle:LGSideMenuPresentationStyleSlideAbove type:2];
            break;
        case 6:
            [mainViewController setupWithPresentationStyle:LGSideMenuPresentationStyleSlideAbove type:3];
            break;
        case 7:
            [mainViewController setupWithPresentationStyle:LGSideMenuPresentationStyleSlideAbove type:4];
            break;
    }

    UIWindow *window = [UIApplication sharedApplication].delegate.window;
    window.rootViewController = mainViewController;

    [UIView transitionWithView:window
                      duration:0.3
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:nil
                    completion:nil];
}

@end
