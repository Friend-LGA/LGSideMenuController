//
//  TableViewController.m
//  LGSideMenuControllerDemo
//

#import "TableViewController.h"
#import "MainViewController.h"
#import "NavigationController.h"
#import "ViewController.h"
#import "OtherViewController.h"

@interface TableViewController ()

@property (strong, nonatomic) NSArray *titlesArray;

@end

@implementation TableViewController

- (id)init {
    self = [super initWithStyle:UITableViewStylePlain];
    if (self) {
        self.title = @"LGSideMenuController";

        self.titlesArray = @[@"Style \"Scale From Big\"",
                             @"Style \"Slide Above\"",
                             @"Style \"Slide Below\"",
                             @"Style \"Scale From Little\"",
                             @"Blurred root view cover",
                             @"Blurred side views covers",
                             @"Blurred side views backgrounds",
                             @"Landscape always visible",
                             @"Status bar always visible",
                             @"Gesture area full screen",
                             @"Editable table view",
                             @"Custom style"];

        [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
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
    UIViewController *viewController;

    if (indexPath.row == self.titlesArray.count - 2) {
        viewController = [OtherViewController new];
    }
    else {
        viewController = [ViewController new];
    }

    NavigationController *navigationController = [[NavigationController alloc] initWithRootViewController:viewController];

    MainViewController *mainViewController = [MainViewController new];
    mainViewController.rootViewController = navigationController;
    [mainViewController setupWithType:indexPath.row];

    UIWindow *window = UIApplication.sharedApplication.delegate.window;
    window.rootViewController = mainViewController;

    [UIView transitionWithView:window
                      duration:0.3
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:nil
                    completion:nil];
}

@end
