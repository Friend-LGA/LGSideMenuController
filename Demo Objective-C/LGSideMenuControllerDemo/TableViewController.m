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

- (id)init {
    self = [super initWithStyle:UITableViewStylePlain];
    if (self)
    {
        self.title = @"LGSideMenuController";

        self.titlesArray = @[@"Style Scale From Big",
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

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.titlesArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];

    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.font = [UIFont systemFontOfSize:16.0];
    cell.textLabel.text = self.titlesArray[indexPath.row];
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ViewController *viewController = [ViewController new];
    NavigationController *navigationController = [[NavigationController alloc] initWithRootViewController:viewController];
    MainViewController *mainViewController = nil;

    switch (indexPath.row) {
        case 0:
            mainViewController = [[MainViewController alloc] initWithRootViewController:navigationController
                                                                      presentationStyle:LGSideMenuPresentationStyleScaleFromBig
                                                                                   type:0];
            break;
        case 1:
            mainViewController = [[MainViewController alloc] initWithRootViewController:navigationController
                                                                      presentationStyle:LGSideMenuPresentationStyleSlideAbove
                                                                                   type:0];
            break;
        case 2:
            mainViewController = [[MainViewController alloc] initWithRootViewController:navigationController
                                                                      presentationStyle:LGSideMenuPresentationStyleSlideBelow
                                                                                   type:0];
            break;
        case 3:
            mainViewController = [[MainViewController alloc] initWithRootViewController:navigationController
                                                                      presentationStyle:LGSideMenuPresentationStyleScaleFromLittle
                                                                                   type:0];
            break;
        case 4:
            mainViewController = [[MainViewController alloc] initWithRootViewController:navigationController
                                                                      presentationStyle:LGSideMenuPresentationStyleScaleFromBig
                                                                                   type:1];
            break;
        case 5:
            mainViewController = [[MainViewController alloc] initWithRootViewController:navigationController
                                                                      presentationStyle:LGSideMenuPresentationStyleSlideAbove
                                                                                   type:2];
            break;
        case 6:
            mainViewController = [[MainViewController alloc] initWithRootViewController:navigationController
                                                                      presentationStyle:LGSideMenuPresentationStyleSlideAbove
                                                                                   type:3];
            break;
        case 7:
            mainViewController = [[MainViewController alloc] initWithRootViewController:navigationController
                                                                      presentationStyle:LGSideMenuPresentationStyleSlideAbove
                                                                                   type:4];
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
