//
//  TableViewController.m
//  LGSideMenuControllerDemo
//

#import "ChooseTableViewController.h"
#import "MainViewController.h"

@interface ChooseTableViewController ()

@property (strong, nonatomic) NSArray *titlesArray;

@end

@implementation ChooseTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];

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
