//
//  TableViewController.m
//  LGSideMenuControllerDemo
//

#import "ChooseTableViewController.h"
#import "MainViewController.h"
#import "RootNavigationController.h"
#import "RootViewController.h"

@interface ChooseTableViewController ()

@property (strong, nonatomic) NSArray *titlesArray;

@end

@implementation ChooseTableViewController

- (id)init {
    self = [super initWithStyle:UITableViewStylePlain];
    if (self) {
        self.title = @"LGSideMenuController";

        self.titlesArray = @[@"Style \"Scale From Big\"",
                             @"Style \"Slide Above\"",
                             @"Style \"Slide Below\"",
                             @"Style \"Scale From Little\"",
                             @"Blurred root view cover",
                             @"Blurred covers of side views",
                             @"Blurred backgrounds of side views",
                             @"Landscape is always visible",
                             @"Status bar is always visible",
                             @"Gesture area is full screen",
                             @"Concurrent touch actions",
                             @"Custom style example"];

        [self.tableView registerClass:UITableViewCell.class forCellReuseIdentifier:@"cell"];
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
    RootViewController *viewController;
    if (indexPath.row == self.titlesArray.count - 2) {
        viewController = [[RootViewController alloc] initWithTableView];
    }
    else {
        viewController = [RootViewController new];
    }

    RootNavigationController *navigationController = [[RootNavigationController alloc] initWithRootViewController:viewController];

    MainViewController *mainViewController = [MainViewController new];
    mainViewController.rootViewController = navigationController;
    [mainViewController setupWithType:(DemoType)indexPath.row];

    UIWindow *window = UIApplication.sharedApplication.delegate.window;
    window.rootViewController = mainViewController;

    [UIView transitionWithView:window
                      duration:0.3
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:nil
                    completion:nil];
}

@end
