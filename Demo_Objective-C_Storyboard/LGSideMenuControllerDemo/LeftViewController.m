//
//  LeftViewController.m
//  LGSideMenuControllerDemo
//

#import "LeftViewController.h"
#import "LeftViewCell.h"
#import "MainViewController.h"
#import "UIViewController+LGSideMenuController.h"
#import "ViewController.h"

@interface LeftViewController ()

@property (strong, nonatomic) NSArray *titlesArray;

@end

@implementation LeftViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // -----

    self.titlesArray = @[@"Open Right View",
                         @"",
                         @"Change Root VC",
                         @"",
                         @"Profile",
                         @"News",
                         @"Articles",
                         @"Video",
                         @"Music"];

    // -----

    self.tableView.contentInset = UIEdgeInsetsMake(44.0, 0.0, 44.0, 0.0);
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.titlesArray.count;
}

#pragma mark - UITableView Delegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LeftViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];

    cell.titleLabel.text = self.titlesArray[indexPath.row];
    cell.separatorView.hidden = (indexPath.row <= 3 || indexPath.row == self.titlesArray.count-1);
    cell.userInteractionEnabled = (indexPath.row != 1 && indexPath.row != 3);

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return (indexPath.row == 1 || indexPath.row == 3) ? 22.0 : 44.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    MainViewController *mainViewController = (MainViewController *)self.sideMenuController;

    if (indexPath.row == 0) {
        if (mainViewController.isLeftViewAlwaysVisibleForCurrentOrientation) {
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
            viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"OtherViewController"];
        }
        else {
            viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"ViewController"];
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
