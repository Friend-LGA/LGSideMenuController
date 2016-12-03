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

Then import header files where you need to use the library

#### Objective-C
```objective-c
#import "LGSideMenuController.h"
#import "UIViewController+LGSideMenuController.h"
```

#### Swift

For swift you need to create [bridging header](https://developer.apple.com/library/content/documentation/Swift/Conceptual/BuildingCocoaApps/MixandMatch.html)

```objective-c
// BridgingHeader.h
#import "LGSideMenuController.h"
#import "UIViewController+LGSideMenuController.h"
```

### With CocoaPods

CocoaPods is a dependency manager for Objective-C, which automates and simplifies the process of using 3rd-party libraries in your projects. To install with cocoaPods, follow the "Get Started" section on [CocoaPods](https://cocoapods.org/).

#### Podfile
```ruby
platform :ios, '8.0'
use_frameworks!
pod 'LGSideMenuController'
```

Then import framework where you need to use the library

#### Objective-C
```objective-c
#import <LGSideMenuController/LGSideMenuController.h>
#import <LGSideMenuController/UIViewController+LGSideMenuController.h>
// OR
@import LGSideMenuController;
// OR
@import LGSideMenuController.LGSideMenuController;
@import LGSideMenuController.UIViewController_LGSideMenuController;
```

#### Swift

```swift
import LGSideMenuController
// OR
import LGSideMenuController.LGSideMenuController
import LGSideMenuController.UIViewController_LGSideMenuController
```

### With Carthage

Carthage is a lightweight dependency manager for Swift and Objective-C. It leverages CocoaTouch modules and is less invasive than CocoaPods. To install with carthage, follow the instruction on [Carthage](https://github.com/Carthage/Carthage/).

#### Cartfile
```ruby
github "Friend-LGA/LGSideMenuController"
```

Then import framework where you need to use the library

#### Objective-C
```objective-c
#import <LGSideMenuController/LGSideMenuController.h>
#import <LGSideMenuController/UIViewController+LGSideMenuController.h>
// OR
@import LGSideMenuController;
// OR
@import LGSideMenuController.LGSideMenuController;
@import LGSideMenuController.UIViewController_LGSideMenuController;
```

#### Swift

```swift
import LGSideMenuController
// OR
import LGSideMenuController.LGSideMenuController
import LGSideMenuController.UIViewController_LGSideMenuController
```

## Usage

### Initialization

#### Objective-C
```objective-c
- (nonnull instancetype)initWithRootViewController:(nullable UIViewController *)rootViewController;
```

#### Swift
```swift
public init(rootViewController: UIViewController?)
```

### Setup

To enable left or right or both views call:

#### Objective-C
```objective-c
- (void)setLeftViewEnabledWithWidth:(CGFloat)width
                  presentationStyle:(LGSideMenuPresentationStyle)presentationStyle
               alwaysVisibleOptions:(LGSideMenuAlwaysVisibleOptions)alwaysVisibleOptions;

- (void)setRightViewEnabledWithWidth:(CGFloat)width
                   presentationStyle:(LGSideMenuPresentationStyle)presentationStyle
                alwaysVisibleOptions:(LGSideMenuAlwaysVisibleOptions)alwaysVisibleOptions;
```

#### Swift
```swift
open func setLeftViewEnabledWithWidth(_ width: CGFloat,
                            presentationStyle: LGSideMenuPresentationStyle,
                         alwaysVisibleOptions: LGSideMenuAlwaysVisibleOptions)

open func setRightViewEnabledWithWidth(_ width: CGFloat,
                             presentationStyle: LGSideMenuPresentationStyle,
                          alwaysVisibleOptions: LGSideMenuAlwaysVisibleOptions)
```

### Quick Example

#### Objective-C
```objective-c
ViewController *viewController = [ViewController new];

UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:viewController];

LGSideMenuController *sideMenuController = [[LGSideMenuController alloc] initWithRootViewController:navigationController];

[sideMenuController setLeftViewEnabledWithWidth:250.0
                              presentationStyle:LGSideMenuPresentationStyleScaleFromBig
                           alwaysVisibleOptions:LGSideMenuAlwaysVisibleOnNone];

TableViewController *leftViewController = [TableViewController new];

[sideMenuController.leftView addSubview:leftViewController.tableView];
```

#### Swift
```swift
let viewController = UIViewController()
        
let navigationController = UINavigationController(rootViewController: viewController)
        
let sideMenuController = LGSideMenuController(rootViewController: navigationController)
        
sideMenuController.setLeftViewEnabledWithWidth(250.0, presentationStyle: .scaleFromBig, alwaysVisibleOptions: [])
        
let leftViewController = UITableViewController()
        
sideMenuController.leftView().addSubview(leftViewController.tableView)
```

#### Notifications

Here is also some notifications, that you can add to NSNotificationsCenter:

```
LGSideMenuControllerWillShowLeftViewNotification
LGSideMenuControllerWillDismissLeftViewNotification
LGSideMenuControllerDidShowLeftViewNotification
LGSideMenuControllerDidDismissLeftViewNotification

LGSideMenuControllerWillShowRightViewNotification
LGSideMenuControllerWillDismissRightViewNotification
LGSideMenuControllerDidShowRightViewNotification
LGSideMenuControllerDidDismissRightViewNotification
```

### More

For more details see [header files](https://github.com/Friend-LGA/LGSideMenuController/tree/master/LGSideMenuController) and try Xcode demo projects: 
* [Objective-C](https://github.com/Friend-LGA/LGSideMenuController/tree/master/Demo_Objective-C)
* [Objective-C + Storyboard](https://github.com/Friend-LGA/LGSideMenuController/tree/master/Demo_Objective-C_Storyboard)
* [Swift](https://github.com/Friend-LGA/LGSideMenuController/tree/master/Demo_Swift)
* [Swift + Storyboard](https://github.com/Friend-LGA/LGSideMenuController/tree/master/Demo_Swift_Storyboard)

## Frameworks

If you like LGSideMenuController, check out my other useful libraries:
* [LGAlertView](https://github.com/Friend-LGA/LGAlertView)
  Customizable implementation of UIAlertViewController, UIAlertView and UIActionSheet. All in one. You can customize every detail. Make AlertView of your dream! :)
* [LGPlusButtonsView](https://github.com/Friend-LGA/LGPlusButtonsView)
  Customizable iOS implementation of Floating Action Button (Google Plus Button, fab).

## License

LGSideMenuController is released under the MIT license. See [LICENSE](https://raw.githubusercontent.com/Friend-LGA/LGSideMenuController/master/LICENSE) for details.
