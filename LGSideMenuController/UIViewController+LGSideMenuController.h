//
//  UIViewController+LGSideMenuController.h
//  LGSideMenuController
//
//
//  The MIT License (MIT)
//
//  Copyright © 2015 Grigorii Lutkov <friend.lga@gmail.com>
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

#import <UIKit/UIKit.h>
#import "LGSideMenuController.h"

@interface UIViewController (LGSideMenuController)

/** If this view controller is root view controller of side menu controller or one of children of root view controller, return it. */
@property(nullable, nonatomic, readonly, weak) LGSideMenuController *sideMenuController;

- (IBAction)showLeftView:(nullable id)sender;
- (IBAction)hideLeftView:(nullable id)sender;
- (IBAction)toggleLeftView:(nullable id)sender;

- (IBAction)showLeftViewAnimated:(nullable id)sender;
- (IBAction)hideLeftViewAnimated:(nullable id)sender;
- (IBAction)toggleLeftViewAnimated:(nullable id)sender;

- (IBAction)showRightView:(nullable id)sender;
- (IBAction)hideRightView:(nullable id)sender;
- (IBAction)toggleRightView:(nullable id)sender;

- (IBAction)showRightViewAnimated:(nullable id)sender;
- (IBAction)hideRightViewAnimated:(nullable id)sender;
- (IBAction)toggleRightViewAnimated:(nullable id)sender;

@end

#pragma mark - Deprecated

@interface UIViewController (LGSideMenuControllerDeprecated)

- (IBAction)openLeftView:(nullable id)sender DEPRECATED_ATTRIBUTE;
- (IBAction)openRightView:(nullable id)sender DEPRECATED_ATTRIBUTE;

@end
