//
//  ViewController.m
//  LGSideMenuControllerDemo
//

#import "ViewController.h"
#import "ChooseNavigationController.h"

@implementation ViewController

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

@end
