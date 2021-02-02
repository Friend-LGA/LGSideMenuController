//
//  Helper.m
//  LGSideMenuControllerDemo
//

#import <UIKit/UIKit.h>
#import "Helper.h"

@implementation Helper

+ (BOOL)isLightTheme {
    if (@available(iOS 13.0, *)) {
        UIUserInterfaceStyle currentStyle = UIApplication.sharedApplication.delegate.window.traitCollection.userInterfaceStyle;
        return currentStyle == UIUserInterfaceStyleLight || currentStyle == UIUserInterfaceStyleUnspecified;
    }
    else {
        return true;
    }
}

@end
