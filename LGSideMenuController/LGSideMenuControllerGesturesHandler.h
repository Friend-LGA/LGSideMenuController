//
//  LGSideMenuControllerGesturesHandler.h
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

#import <UIKit/UIKit.h>
#import "LGSideMenuController.h"

@interface LGSideMenuControllerGesturesHandler : NSObject <UIGestureRecognizerDelegate>

@property (assign, nonatomic, nonnull) LGSideMenuController *sideMenuController;

@property (weak, nonatomic, nullable) UIView *rootViewContainer;
@property (weak, nonatomic, nullable) UIView *leftViewContainer;
@property (weak, nonatomic, nullable) UIView *rightViewContainer;

@property (weak, nonatomic, nullable) UIView *rootViewCoverView;

@property (assign, nonatomic, getter=isAnimating) BOOL animating;

- (nonnull instancetype)initWithSideMenuController:(nonnull LGSideMenuController *)sideMenuController;

@end
