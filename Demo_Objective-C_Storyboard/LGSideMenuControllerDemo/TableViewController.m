//
//  TableViewController.m
//  LGSideMenuControllerDemo
//

#import "TableViewController.h"
#import "MainViewController.h"

@interface TableViewController ()

@property (strong, nonatomic) NSArray *titlesArray;

@end

@implementation TableViewController

- (void)viewDidLoad {
    [super viewDidLoad];

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
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.titlesArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];

    cell.textLabel.text = self.titlesArray[indexPath.row];

    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UINavigationController *navigationController = [storyboard instantiateViewControllerWithIdentifier:@"NavigationController"];

    if (indexPath.row == self.titlesArray.count - 2) {
        [navigationController setViewControllers:@[[storyboard instantiateViewControllerWithIdentifier:@"OtherViewController"]]];
    }
    else {
        [navigationController setViewControllers:@[[storyboard instantiateViewControllerWithIdentifier:@"ViewController"]]];
    }

    MainViewController *mainViewController = [storyboard instantiateInitialViewController];
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
