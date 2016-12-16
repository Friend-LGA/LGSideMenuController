//
//  LGSideMenuControllerGesturesHandler.m
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

#import "LGSideMenuControllerGesturesHandler.h"

@implementation LGSideMenuControllerGesturesHandler

- (nonnull instancetype)initWithSideMenuController:(nonnull LGSideMenuController *)sideMenuController {
    self = [super init];
    if (self) {
        self.sideMenuController = sideMenuController;
    }
    return self;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if (self.isAnimating) return NO;

    if ([gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]]) {
        if (!self.sideMenuController.rootView) return NO;

        if (self.sideMenuController.swipeGestureArea == LGSideMenuSwipeGestureAreaFull &&
            ((self.sideMenuController.leftView && self.sideMenuController.isLeftViewSwipeGestureEnabled) ||
             (self.sideMenuController.rightView && self.sideMenuController.isRightViewSwipeGestureEnabled))) {
                return YES;
            }

        // -----

        CGPoint location = [touch locationInView:self.sideMenuController.view];
        CGRect leftAvailableRect = CGRectNull;
        CGRect rightAvailableRect = CGRectNull;

        if (self.sideMenuController.leftView) {
            if (self.sideMenuController.isLeftViewVisible) {
                leftAvailableRect = CGRectMake(CGRectGetWidth(self.leftViewContainer.frame) - self.sideMenuController.leftViewSwipeGestureRange.left,
                                               CGRectGetMinY(self.rootViewContainer.frame),
                                               CGRectGetWidth(self.sideMenuController.view.frame),
                                               CGRectGetHeight(self.rootViewContainer.frame));
            }
            else {
                leftAvailableRect = CGRectMake(-self.sideMenuController.leftViewSwipeGestureRange.left,
                                               CGRectGetMinY(self.rootViewContainer.frame),
                                               self.sideMenuController.leftViewSwipeGestureRange.left + self.sideMenuController.leftViewSwipeGestureRange.right,
                                               CGRectGetHeight(self.rootViewContainer.frame));
            }
        }

        if (self.sideMenuController.rightView) {
            if (self.sideMenuController.isRightViewVisible) {
                rightAvailableRect = CGRectMake(CGRectGetWidth(self.sideMenuController.view.frame) - CGRectGetWidth(self.rightViewContainer.frame) + self.sideMenuController.rightViewSwipeGestureRange.left,
                                                CGRectGetMinY(self.rootViewContainer.frame),
                                                -CGRectGetWidth(self.sideMenuController.view.frame),
                                                CGRectGetHeight(self.rootViewContainer.frame));
            }
            else {
                rightAvailableRect = CGRectMake(CGRectGetWidth(self.rootViewContainer.frame) - self.sideMenuController.rightViewSwipeGestureRange.left,
                                                CGRectGetMinY(self.rootViewContainer.frame),
                                                self.sideMenuController.rightViewSwipeGestureRange.left + self.sideMenuController.rightViewSwipeGestureRange.right,
                                                CGRectGetHeight(self.rootViewContainer.frame));
            }
        }

        return ((self.sideMenuController.leftView && self.sideMenuController.isLeftViewSwipeGestureEnabled && CGRectContainsPoint(leftAvailableRect, location)) ||
                (self.sideMenuController.rightView && self.sideMenuController.isRightViewSwipeGestureEnabled && CGRectContainsPoint(rightAvailableRect, location)));
    }
    else {
        if (!self.rootViewCoverView) return NO;

        return [touch.view isDescendantOfView:self.rootViewCoverView];
    }
}

@end
