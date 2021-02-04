//
//  RootViewControllerWithTableView.m
//  LGSideMenuControllerDemo
//

#import "RootViewControllerWithTableView.h"
#import "ChooseNavigationController.h"

@interface RootViewControllerWithTableView ()

@property (assign, nonatomic) NSUInteger numberOfCells;

@end

@implementation RootViewControllerWithTableView

- (void)viewDidLoad {
    [super viewDidLoad];
    static unsigned int counter = 0;
    counter++;
    NSLog(@"[RootOtherViewController viewDidLoad], counter: %i", counter);

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

#pragma mark - Logging

- (void)dealloc {
    static unsigned int counter = 0;
    counter++;
    NSLog(@"[RootOtherViewController dealloc], counter: %i", counter);
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    static unsigned int counter = 0;
    counter++;
    NSLog(@"[RootOtherViewController viewWillAppear: %@], counter: %i", (animated ? @"true" : @"false"), counter);
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    static unsigned int counter = 0;
    counter++;
    NSLog(@"[RootOtherViewController viewDidAppear: %@], counter: %i", (animated ? @"true" : @"false"), counter);
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    static unsigned int counter = 0;
    counter++;
    NSLog(@"[RootOtherViewController viewWillDisappear: %@], counter: %i", (animated ? @"true" : @"false"), counter);
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    static unsigned int counter = 0;
    counter++;
    NSLog(@"[RootOtherViewController viewDidDisappear: %@], counter: %i", (animated ? @"true" : @"false"), counter);
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    static unsigned int counter = 0;
    counter++;
    NSLog(@"[RootOtherViewController viewWillLayoutSubviews], counter: %i", counter);
}

@end
