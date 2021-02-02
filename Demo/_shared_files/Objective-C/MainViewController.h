//
//  MainViewController.h
//  LGSideMenuControllerDemo
//

#import "LGSideMenuController.h"

typedef enum DemoType : NSInteger {
    DemoTypeStyleScaleFromBig,
    DemoTypeStyleSlideAbove,
    DemoTypeStyleSlideBelow,
    DemoTypeStyleScaleFromLittle,
    DemoTypeBlurredRootViewCover,
    DemoTypeBlurredCoversOfSideViews,
    DemoTypeBlurredBackgroundsOfSideViews,
    DemoTypeLandscapeIsAlwaysVisible,
    DemoTypeStatusBarIsAlwaysVisisble,
    DemoTypeGestureAreaIsFullScreen,
    DemoTypeConcurrentTouchActions,
    DemoTypeCustomStyleExample
} DemoType;

@interface MainViewController : LGSideMenuController

- (void)setupWithType:(DemoType)type;

@end
