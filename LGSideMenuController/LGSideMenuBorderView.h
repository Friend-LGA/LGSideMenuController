//
//  LGSideMenuBorderView.h
//  LGSideMenuControllerDemo
//
//  Created by Grigory Lutkov on 18/04/17.
//  Copyright © 2017 Grigory Lutkov. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LGSideMenuBorderView : UIView

@property (assign, nonatomic) UIRectCorner roundedCorners;
@property (assign, nonatomic) CGFloat cornerRadius;
@property (strong, nonatomic, nullable) UIColor *strokeColor;
@property (assign, nonatomic) CGFloat strokeWidth;
@property (strong, nonatomic, nullable) UIColor *shadowColor;
@property (assign, nonatomic) CGFloat shadowBlur;

@end
