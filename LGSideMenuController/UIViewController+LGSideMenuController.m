//
//  UIViewController+LGSideMenuController.m
//  LGSideMenuController
//
//
//  The MIT License (MIT)
//
//  Copyright © 2015 Grigory Lutkov <Friend.LGA@gmail.com>
//  (https://github.com/Friend-LGA/LGSideMenuController)
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.
//

#import <objc/runtime.h>

#import "UIViewController+LGSideMenuController.h"

@implementation UIViewController (LGSideMenuController)

- (nullable LGSideMenuController *)sideMenuController {
    if ([self isKindOfClass:[LGSideMenuController class]]) {
        return (LGSideMenuController *)self;
    }

    LGSideMenuController *result;

    result = objc_getAssociatedObject(self, @"sideMenuController");
    if (result) return result;

    result = self.parentViewController.sideMenuController;
    if (result) return result;

    result = self.navigationController.sideMenuController;
    if (result) return result;

    result = self.presentingViewController.sideMenuController;
    if (result) return result;

    result = self.splitViewController.sideMenuController;
    if (result) return result;

    return nil;
}

#pragma mark - Show/Hide left view

- (IBAction)showLeftView:(nullable id)sender {
    [[self sideMenuController] showLeftView:sender];
}

- (IBAction)hideLeftView:(nullable id)sender {
    [[self sideMenuController] hideLeftView:sender];
}

- (IBAction)toggleLeftView:(nullable id)sender {
    [[self sideMenuController] toggleLeftView:sender];
}

#pragma mark

- (IBAction)showLeftViewAnimated:(nullable id)sender {
    [[self sideMenuController] showLeftViewAnimated:sender];
}

- (IBAction)hideLeftViewAnimated:(nullable id)sender {
    [[self sideMenuController] hideLeftViewAnimated:sender];
}

- (IBAction)toggleLeftViewAnimated:(nullable id)sender {
    [[self sideMenuController] toggleLeftViewAnimated:sender];
}

#pragma mark - Show/Hide right view

- (IBAction)showRightView:(nullable id)sender {
    [[self sideMenuController] showRightView:sender];
}

- (IBAction)hideRightView:(nullable id)sender {
    [[self sideMenuController] hideRightView:sender];
}

- (IBAction)toggleRightView:(nullable id)sender {
    [[self sideMenuController] toggleRightView:sender];
}

#pragma mark

- (IBAction)showRightViewAnimated:(nullable id)sender {
    [[self sideMenuController] showRightViewAnimated:sender];
}

- (IBAction)hideRightViewAnimated:(nullable id)sender {
    [[self sideMenuController] hideRightViewAnimated:sender];
}

- (IBAction)toggleRightViewAnimated:(nullable id)sender {
    [[self sideMenuController] toggleRightViewAnimated:sender];
}

@end

#pragma mark - Deprecated

@implementation UIViewController (LGSideMenuControllerDeprecated)

- (IBAction)openLeftView:(nullable id)sender {
    [self showLeftViewAnimated:sender];
}

- (IBAction)openRightView:(nullable id)sender {
    [self showRightViewAnimated:sender];
}

@end
