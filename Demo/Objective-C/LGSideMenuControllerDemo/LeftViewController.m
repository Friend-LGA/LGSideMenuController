//
//  LeftViewController.m
//  LGSideMenuControllerDemo
//

#import "LeftViewController.h"
#import "LeftViewCell.h"
#import "MainViewController.h"
#import "UIViewController+LGSideMenuController.h"
#import "ViewController.h"
#import "OtherViewController.h"

@interface LeftViewController ()

@property (strong, nonatomic) NSArray *titlesArray;

@end

@implementation LeftViewController

- (id)init {
    self = [super initWithStyle:UITableViewStylePlain];
    if (self) {
        self.titlesArray = @[@"Open Right View",
                             @"",
                             @"Change Root VC",
                             @"",
                             @"Profile",
                             @"News",
                             @"Articles",
                             @"Video",
                             @"Music"];

        self.view.backgroundColor = [UIColor clearColor];

        [self.tableView registerClass:[LeftViewCell class] forCellReuseIdentifier:@"cell"];
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.tableView.contentInset = UIEdgeInsetsMake(44.0, 0.0, 44.0, 0.0);
        self.tableView.showsVerticalScrollIndicator = NO;
        self.tableView.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleDefault;
}

- (UIStatusBarAnimation)preferredStatusBarUpdateAnimation {
    return UIStatusBarAnimationFade;
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.titlesArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LeftViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];

    cell.textLabel.text = self.titlesArray[indexPath.row];
    cell.separatorView.hidden = (indexPath.row <= 3 || indexPath.row == self.titlesArray.count-1);
    cell.userInteractionEnabled = (indexPath.row != 1 && indexPath.row != 3);

    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return (indexPath.row == 1 || indexPath.row == 3) ? 22.0 : 44.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    MainViewController *mainViewController = (MainViewController *)self.sideMenuController;

    if (indexPath.row == 0) {
        if ([mainViewController isLeftViewAlwaysVisibleForCurrentOrientation]) {
            [mainViewController showRightViewAnimated:YES completionHandler:nil];
        }
        else {
            [mainViewController hideLeftViewAnimated:YES completionHandler:^(void) {
                [mainViewController showRightViewAnimated:YES completionHandler:nil];
            }];
        }
    }
    else if (indexPath.row == 2) {
        UINavigationController *navigationController = (UINavigationController *)mainViewController.rootViewController;
        UIViewController *viewController;

        if ([navigationController.viewControllers.firstObject isKindOfClass:[ViewController class]]) {
            viewController = [OtherViewController new];
        }
        else {
            viewController = [ViewController new];
        }

        [navigationController setViewControllers:@[viewController]];

        // Rarely you can get some visual bugs when you change view hierarchy and toggle side views in the same iteration
        // You can use delay to avoid this and probably other unexpected visual bugs
        [mainViewController hideLeftViewAnimated:YES delay:0.0 completionHandler:nil];
    }
    else {
        UIViewController *viewController = [UIViewController new];
        viewController.view.backgroundColor = [UIColor whiteColor];
        viewController.title = self.titlesArray[indexPath.row];

        UINavigationController *navigationController = (UINavigationController *)mainViewController.rootViewController;
        [navigationController pushViewController:viewController animated:YES];

        [mainViewController hideLeftViewAnimated:YES completionHandler:nil];
    }
}

@end
