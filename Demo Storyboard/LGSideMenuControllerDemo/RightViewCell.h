//
//  RightViewCell.h
//  LGSideMenuControllerDemo
//
//  Created by Grigory Lutkov on 26.04.15.
//  Copyright (c) 2015 Grigory Lutkov. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RightViewCell : UITableViewCell

@property (assign, nonatomic) IBOutlet UIView *separatorView;
@property (strong, nonatomic) UIColor *tintColor;

@end
