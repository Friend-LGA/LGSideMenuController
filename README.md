# LGSideMenuController

iOS view controller shows left and right views on top of everything by pressing button or gesture.

## Preview

<img src="https://raw.githubusercontent.com/Friend-LGA/ReadmeFiles/master/LGSideMenuController/Preview1.gif" width="218"/>
<img src="https://raw.githubusercontent.com/Friend-LGA/ReadmeFiles/master/LGSideMenuController/Preview2.gif" width="218"/>
<img src="https://raw.githubusercontent.com/Friend-LGA/ReadmeFiles/master/LGSideMenuController/Preview3.gif" width="218"/>
<img src="https://raw.githubusercontent.com/Friend-LGA/ReadmeFiles/master/LGSideMenuController/1.png" width="218"/>
<img src="https://raw.githubusercontent.com/Friend-LGA/ReadmeFiles/master/LGSideMenuController/2.png" width="218"/>
<img src="https://raw.githubusercontent.com/Friend-LGA/ReadmeFiles/master/LGSideMenuController/3.png" width="218"/>
<img src="https://raw.githubusercontent.com/Friend-LGA/ReadmeFiles/master/LGSideMenuController/4.png" width="218"/>
<img src="https://raw.githubusercontent.com/Friend-LGA/ReadmeFiles/master/LGSideMenuController/5.png" width="218"/>
<img src="https://raw.githubusercontent.com/Friend-LGA/ReadmeFiles/master/LGSideMenuController/6.png" width="218"/>

## Installation

### With source code

[Download repository](https://github.com/Friend-LGA/LGSideMenuController/archive/master.zip), then add [LGSideMenuController directory](https://github.com/Friend-LGA/LGSideMenuController/blob/master/LGSideMenuController/) to your project.

### With CocoaPods

CocoaPods is a dependency manager for Objective-C, which automates and simplifies the process of using 3rd-party libraries in your projects. To install with cocoaPods, follow the "Get Started" section on [CocoaPods](https://cocoapods.org/).

#### Podfile
```ruby
platform :ios, '6.0'
pod 'LGSideMenuController', '~> 1.0.0'
```

### With Carthage

Carthage is a lightweight dependency manager for Swift and Objective-C. It leverages CocoaTouch modules and is less invasive than CocoaPods. To install with carthage, follow the instruction on [Carthage](https://github.com/Carthage/Carthage/).

#### Cartfile
```
github "Friend-LGA/LGSideMenuController" ~> 1.0.0
```

## Usage

In the source files where you need to use the library, import the header file:

```objective-c
#import "LGSideMenuController.h"
```

### Initialization

```objective-c
- (instancetype)initWithRootViewController:(UIViewController *)rootViewController;
```

### Setup

To enable left or right or both views call:

```objective-c
- (void)setLeftViewEnabledWithWidth:(CGFloat)width
                  presentationStyle:(LGSideMenuPresentationStyle)presentationStyle
               alwaysVisibleOptions:(LGSideMenuAlwaysVisibleOptions)alwaysVisibleOptions;   // for example you can make view always visible on ipad landscape orientation

- (void)setRightViewEnabledWithWidth:(CGFloat)width
                   presentationStyle:(LGSideMenuPresentationStyle)presentationStyle
                alwaysVisibleOptions:(LGSideMenuAlwaysVisibleOptions)alwaysVisibleOptions;  // for example you can make view always visible on ipad landscape orientation
```

### Quick Example

```objective-c
ViewController *viewController = [ViewController new];

UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:viewController];

LGSideMenuController *sideMenuController = [[LGSideMenuController alloc] initWithRootViewController:navigationController];

[sideMenuController setLeftViewEnabledWithWidth:250.f
                              presentationStyle:LGSideMenuPresentationStyleScaleFromBig
                           alwaysVisibleOptions:0];

TableViewController *leftViewController = [TableViewController new];

[sideMenuController.leftView addSubview:leftViewController.tableView];
```

#### Notifications

Here is also some notifications, that you can add to NSNotificationsCenter:

```objective-c
kLGSideMenuControllerWillShowLeftViewNotification;
kLGSideMenuControllerWillDismissLeftViewNotification;
kLGSideMenuControllerDidShowLeftViewNotification;
kLGSideMenuControllerDidDismissLeftViewNotification;

kLGSideMenuControllerWillShowRightViewNotification;
kLGSideMenuControllerWillDismissRightViewNotification;
kLGSideMenuControllerDidShowRightViewNotification;
kLGSideMenuControllerDidDismissRightViewNotification;
```

### More

For more details try Xcode [Demo project](https://github.com/Friend-LGA/LGSideMenuController/blob/master/Demo) and see [LGSideMenuController.h](https://github.com/Friend-LGA/LGSideMenuController/blob/master/LGSideMenuController/LGSideMenuController.h)

## License

LGSideMenuController is released under the MIT license. See [LICENSE](https://raw.githubusercontent.com/Friend-LGA/LGSideMenuController/master/LICENSE) for details.
