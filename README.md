# LGSideMenuController

iOS view controller shows left and right views on top of everything by pressing button or gesture.

## Preview

<img src="https://raw.githubusercontent.com/Friend-LGA/ReadmeFiles/master/LGSideMenuController/Preview1.gif" width="218"/>
<img src="https://raw.githubusercontent.com/Friend-LGA/ReadmeFiles/master/LGSideMenuController/1.png" width="218"/>
<img src="https://raw.githubusercontent.com/Friend-LGA/ReadmeFiles/master/LGSideMenuController/2.png" width="218"/>    
<img src="https://raw.githubusercontent.com/Friend-LGA/ReadmeFiles/master/LGSideMenuController/Preview2.gif" width="218"/>
<img src="https://raw.githubusercontent.com/Friend-LGA/ReadmeFiles/master/LGSideMenuController/3.png" width="218"/>
<img src="https://raw.githubusercontent.com/Friend-LGA/ReadmeFiles/master/LGSideMenuController/4.png" width="218"/>    
<img src="https://raw.githubusercontent.com/Friend-LGA/ReadmeFiles/master/LGSideMenuController/Preview3.gif" width="218"/>
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

You can use view controllers or views to initialize LGSideMenuController:

#### Objective-C

```objective-c
- (nonnull instancetype)initWithRootViewController:(nullable UIViewController *)rootViewController;

- (nonnull instancetype)initWithRootViewController:(nullable UIViewController *)rootViewController
                                leftViewController:(nullable UIViewController *)leftViewController
                               rightViewController:(nullable UIViewController *)rightViewController;

- (nonnull instancetype)initWithRootView:(nullable UIView *)rootView;

- (nonnull instancetype)initWithRootView:(nullable UIView *)rootView
                                leftView:(nullable UIView *)leftView
                               rightView:(nullable UIView *)rightView;
```

#### Swift

```swift
public init(rootViewController: UIViewController?)

public init(rootViewController: UIViewController?,
            leftViewController: UIViewController?,
           rightViewController: UIViewController?)

public init(rootView: UIView?)

public init(rootView: UIView?,
            leftView: UIView?,
           rightView: UIView?)
```

### Setup

To set or change root, left or right view controllers or views, call:

```swift
sideMenuController.rootViewController = rootViewController
sideMenuController.leftViewController = leftViewController
sideMenuController.rightViewController = rightViewController

sideMenuController.rootView = rootView
sideMenuController.leftView = leftView
sideMenuController.rightView = rightView
```

If you will set, for example, `sideMenuController.rootViewController = rootViewController`, 
then `sideMenuController.rootView == rootViewController.view`.    
If you had, for example, root view controller and you will set, `sideMenuController.rootView = rootView`, 
then `sideMenuController.rootViewController == nil`.

### Quick Example

#### Objective-C

```objective-c
UIViewController *rootViewController = [UIViewController new];
UITableViewController *leftViewController = [UITableViewController new];
UITableViewController *rightViewController = [UITableViewController new];

UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:rootViewController];

LGSideMenuController *sideMenuController = [LGSideMenuController sideMenuControllerWithRootViewController:navigationController
                                                                                       leftViewController:leftViewController
                                                                                      rightViewController:rightViewController];

sideMenuController.leftViewWidth = 250.0;
sideMenuController.leftViewPresentationStyle = LGSideMenuPresentationStyleScaleFromBig;

sideMenuController.rightViewWidth = 100.0;
sideMenuController.leftViewPresentationStyle = LGSideMenuPresentationStyleSlideBelow;
```

#### Swift

```swift
let rootViewController = UIViewController()
let leftViewController = UITableViewController()
let rightViewController = UITableViewController()

let navigationController = UINavigationController(rootViewController: rootViewController)

let sideMenuController = LGSideMenuController(rootViewController: navigationController, 
                                              leftViewController: leftViewController, 
                                             rightViewController: rightViewController)

sideMenuController.leftViewWidth = 250.0;
sideMenuController.leftViewPresentationStyle = .scaleFromBig;

sideMenuController.rightViewWidth = 100.0;
sideMenuController.leftViewPresentationStyle = .slideBelow;
```

For more info check demo projects.

### Handle actions

To handle actions you can use delegate, blocks, or notifications:

#### Delegate

#### Objective-C

```objective-c
<LGSideMenuControllerDelegate>

@optional

- (void)willShowLeftView:(nonnull UIView *)leftView sideMenuController:(nonnull LGSideMenuController *)sideMenuController;
- (void)didShowLeftView:(nonnull UIView *)leftView sideMenuController:(nonnull LGSideMenuController *)sideMenuController;

- (void)willHideLeftView:(nonnull UIView *)leftView sideMenuController:(nonnull LGSideMenuController *)sideMenuController;
- (void)didHideLeftView:(nonnull UIView *)leftView sideMenuController:(nonnull LGSideMenuController *)sideMenuController;

- (void)willShowRightView:(nonnull UIView *)rightView sideMenuController:(nonnull LGSideMenuController *)sideMenuController;
- (void)didShowRightView:(nonnull UIView *)rightView sideMenuController:(nonnull LGSideMenuController *)sideMenuController;

- (void)willHideRightView:(nonnull UIView *)rightView sideMenuController:(nonnull LGSideMenuController *)sideMenuController;
- (void)didHideRightView:(nonnull UIView *)rightView sideMenuController:(nonnull LGSideMenuController *)sideMenuController;

- (void)showAnimationsBlockForLeftView:(nonnull UIView *)leftView sideMenuController:(nonnull LGSideMenuController *)sideMenuController duration:(NSTimeInterval)duration;
- (void)hideAnimationsBlockForLeftView:(nonnull UIView *)leftView sideMenuController:(nonnull LGSideMenuController *)sideMenuController duration:(NSTimeInterval)duration;

- (void)showAnimationsBlockForRightView:(nonnull UIView *)rightView sideMenuController:(nonnull LGSideMenuController *)sideMenuController duration:(NSTimeInterval)duration;
- (void)hideAnimationsBlockForRightView:(nonnull UIView *)rightView sideMenuController:(nonnull LGSideMenuController *)sideMenuController duration:(NSTimeInterval)duration;
```

#### Swift

```swift
<LGSideMenuControllerDelegate>

optional public func willShowLeftView(_ leftView: UIView, sideMenuController: LGSideMenuController)
optional public func didShowLeftView(_ leftView: UIView, sideMenuController: LGSideMenuController)

optional public func willHideLeftView(_ leftView: UIView, sideMenuController: LGSideMenuController)
optional public func didHideLeftView(_ leftView: UIView, sideMenuController: LGSideMenuController)

optional public func willShowRightView(_ rightView: UIView, sideMenuController: LGSideMenuController)
optional public func didShowRightView(_ rightView: UIView, sideMenuController: LGSideMenuController)

optional public func willHideRightView(_ rightView: UIView, sideMenuController: LGSideMenuController)
optional public func didHideRightView(_ rightView: UIView, sideMenuController: LGSideMenuController)

optional public func showAnimationsBlock(forLeftView leftView: UIView, sideMenuController: LGSideMenuController, duration: TimeInterval)
optional public func hideAnimationsBlock(forLeftView leftView: UIView, sideMenuController: LGSideMenuController, duration: TimeInterval)

optional public func showAnimationsBlock(forRightView rightView: UIView, sideMenuController: LGSideMenuController, duration: TimeInterval)
optional public func hideAnimationsBlock(forRightView rightView: UIView, sideMenuController: LGSideMenuController, duration: TimeInterval)
```

#### Blocks

#### Objective-C

```objective-c
void(^willShowLeftView)(LGSideMenuController * _Nonnull sideMenuController, UIView * _Nonnull leftView);
void(^didShowLeftView)(LGSideMenuController * _Nonnull sideMenuController, UIView * _Nonnull leftView);

void(^willHideLeftView)(LGSideMenuController * _Nonnull sideMenuController, UIView * _Nonnull leftView);
void(^didHideLeftView)(LGSideMenuController * _Nonnull sideMenuController, UIView * _Nonnull leftView);

void(^willShowRightView)(LGSideMenuController * _Nonnull sideMenuController, UIView * _Nonnull rightView);
void(^didShowRightView)(LGSideMenuController * _Nonnull sideMenuController, UIView * _Nonnull rightView);

void(^willHideRightView)(LGSideMenuController * _Nonnull sideMenuController, UIView * _Nonnull rightView);
void(^didHideRightView)(LGSideMenuController * _Nonnull sideMenuController, UIView * _Nonnull rightView);

void(^showLeftViewAnimationsBlock)(LGSideMenuController * _Nonnull sideMenuController, UIView * _Nonnull leftView, NSTimeInterval duration);
void(^hideLeftViewAnimationsBlock)(LGSideMenuController * _Nonnull sideMenuController, UIView * _Nonnull leftView, NSTimeInterval duration);

void(^showRightViewAnimationsBlock)(LGSideMenuController * _Nonnull sideMenuController, UIView * _Nonnull rightView, NSTimeInterval duration);
void(^hideRightViewAnimationsBlock)(LGSideMenuController * _Nonnull sideMenuController, UIView * _Nonnull rightView, NSTimeInterval duration);
```

#### Swift

```swift
open var willShowLeftView: ((LGSideMenuController, UIView) -> Swift.Void)?
open var didShowLeftView: ((LGSideMenuController, UIView) -> Swift.Void)?

open var willHideLeftView: ((LGSideMenuController, UIView) -> Swift.Void)?
open var didHideLeftView: ((LGSideMenuController, UIView) -> Swift.Void)?

open var willShowRightView: ((LGSideMenuController, UIView) -> Swift.Void)?
open var didShowRightView: ((LGSideMenuController, UIView) -> Swift.Void)?

open var willHideRightView: ((LGSideMenuController, UIView) -> Swift.Void)?
open var didHideRightView: ((LGSideMenuController, UIView) -> Swift.Void)?

open var showLeftViewAnimationsBlock: ((LGSideMenuController, UIView, TimeInterval) -> Swift.Void)?
open var hideLeftViewAnimationsBlock: ((LGSideMenuController, UIView, TimeInterval) -> Swift.Void)?

open var showRightViewAnimationsBlock: ((LGSideMenuController, UIView, TimeInterval) -> Swift.Void)?
open var hideRightViewAnimationsBlock: ((LGSideMenuController, UIView, TimeInterval) -> Swift.Void)?
```

#### Notifications

```
LGSideMenuControllerWillShowLeftViewNotification
LGSideMenuControllerDidShowLeftViewNotification

LGSideMenuControllerWillHideLeftViewNotification
LGSideMenuControllerDidHideLeftViewNotification

LGSideMenuControllerWillShowRightViewNotification
LGSideMenuControllerDidShowRightViewNotification

LGSideMenuControllerWillHideRightViewNotification
LGSideMenuControllerDidHideRightViewNotification
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
