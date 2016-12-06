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

- (id)init {
    self = [super init];
    if (self) {
        self.title = @"LGSideMenuController";

        self.view.backgroundColor = [UIColor whiteColor];

        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Choose"
                                                                                  style:UIBarButtonItemStylePlain
                                                                                 target:self
                                                                                 action:@selector(showChooseController)];

        [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];

        self.numberOfCells = 100;
    }
    return self;
}

#pragma mark -

- (void)showChooseController {
    ChooseNavigationController *navigationController = [ChooseNavigationController new];

    UIWindow *window = UIApplication.sharedApplication.delegate.window;
    window.rootViewController = navigationController;

    [UIView transitionWithView:window
                      duration:0.3
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:nil
                    completion:nil];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.numberOfCells;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];

    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.textLabel.font = [UIFont systemFontOfSize:16.0];
    cell.textLabel.text = @"You can delete me by swipe";

    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44.0;
}

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
