//
//  RootViewController.m
//  LGSideMenuControllerDemo
//

#import "RootViewController.h"
#import "ChooseNavigationController.h"
#import "UIViewController+LGSideMenuController.h"
#import "Helper.h"

@interface RootViewController () <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) UIImageView *imageView;
@property (strong, nonatomic) UIButton *button;

@property (strong, nonatomic) UITableView *tableView;
@property (assign, nonatomic) NSUInteger numberOfCells;

@end

@implementation RootViewController

- (instancetype)init {
    self = [super init];
    if (self) {
        self.title = @"LGSideMenuController";

        // -----

        self.imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"imageRoot"]];
        self.imageView.contentMode = UIViewContentModeScaleAspectFill;
        self.imageView.clipsToBounds = YES;
        [self.view addSubview:self.imageView];

        self.button = [UIButton new];
        [self.button setTitle:@"Show Choose Controller" forState:UIControlStateNormal];
        [self.button addTarget:self action:@selector(showChooseController) forControlEvents:UIControlEventTouchUpInside];
        [self.button setTitleColor:[UIColor colorWithRed:0.0 green:0.5 blue:1.0 alpha:1.0] forState:UIControlStateHighlighted];
        [self.view addSubview:self.button];

        // -----

        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Left"
                                                                                 style:UIBarButtonItemStylePlain
                                                                                target:self
                                                                                action:@selector(showLeftView)];

        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Right"
                                                                                  style:UIBarButtonItemStylePlain
                                                                                 target:self
                                                                                 action:@selector(showRightView)];

        // -----

        [self setColors];
    }
    return self;
}

- (instancetype)initWithTableView {
    self = [self init];
    if (self) {
        self.numberOfCells = 100;

        self.tableView = [UITableView new];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        [self.tableView registerClass:UITableViewCell.class forCellReuseIdentifier:@"cell"];
        [self.view insertSubview:self.tableView aboveSubview:self.imageView];

        // -----

        [self setColors];
    }
    return self;
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    static unsigned int counter = 0;
    counter++;
    NSLog(@"[RootViewController viewWillLayoutSubviews], counter: %i", counter);

    CGFloat buttonHeight = 44.0;

    self.imageView.frame = self.view.bounds;
    self.button.frame = CGRectMake(0.0, self.view.frame.size.height - buttonHeight, self.view.frame.size.width, buttonHeight);

    if (self.tableView != nil) {
        self.tableView.frame = CGRectMake(0.0, 0.0, self.view.frame.size.width, self.view.frame.size.height - buttonHeight);
    }
}

- (void)traitCollectionDidChange:(UITraitCollection *)previousTraitCollection {
    [super traitCollectionDidChange:previousTraitCollection];
    [self setColors];
}

#pragma mark -

- (void)setColors {
    self.button.backgroundColor = [UIColor colorWithWhite:(Helper.isLightTheme ? 1.0 : 0.0) alpha:0.75];
    [self.button setTitleColor:(Helper.isLightTheme ? UIColor.blackColor : UIColor.whiteColor) forState:UIControlStateNormal];
    self.tableView.backgroundColor = [UIColor colorWithWhite:(Helper.isLightTheme ? 1.0 : 0.0) alpha:0.5];
}

- (void)showLeftView {
    [self.sideMenuController showLeftViewAnimated:YES completionHandler:nil];
}

- (void)showRightView {
    [self.sideMenuController showRightViewAnimated:YES completionHandler:nil];
}

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
    cell.textLabel.text = @"You can delete me by swiping";
    cell.backgroundColor = UIColor.clearColor;

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

#pragma mark - Logging

- (void)dealloc {
    static unsigned int counter = 0;
    counter++;
    NSLog(@"[RootViewController dealloc], counter: %i", counter);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    static unsigned int counter = 0;
    counter++;
    NSLog(@"[RootViewController viewDidLoad], counter: %i", counter);
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    static unsigned int counter = 0;
    counter++;
    NSLog(@"[RootViewController viewWillAppear: %@], counter: %i", (animated ? @"true" : @"false"), counter);
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    static unsigned int counter = 0;
    counter++;
    NSLog(@"[RootViewController viewDidAppear: %@], counter: %i", (animated ? @"true" : @"false"), counter);
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    static unsigned int counter = 0;
    counter++;
    NSLog(@"[RootViewController viewWillDisappear: %@], counter: %i", (animated ? @"true" : @"false"), counter);
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    static unsigned int counter = 0;
    counter++;
    NSLog(@"[RootViewController viewDidDisappear: %@], counter: %i", (animated ? @"true" : @"false"), counter);
}

@end
