//
//  OtherViewController.m
//  LGSideMenuControllerDemo
//

#import "OtherViewController.h"
#import "ChooseNavigationController.h"

@interface OtherViewController ()

@property (assign, nonatomic) NSUInteger numberOfCells;

@end

@implementation OtherViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.numberOfCells = 100;
}

#pragma mark -

- (IBAction)showChooseController:(id)sender {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Choose" bundle:NSBundle.mainBundle];

    ChooseNavigationController *navigationController = [storyboard instantiateInitialViewController];

    UIWindow *window = UIApplication.sharedApplication.delegate.window;
    window.rootViewController = navigationController;

    [UIView transitionWithView:window
                      duration:0.3
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:nil
                    completion:nil];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.numberOfCells;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [tableView dequeueReusableCellWithIdentifier:@"cell"];
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        self.numberOfCells--;
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}

@end
