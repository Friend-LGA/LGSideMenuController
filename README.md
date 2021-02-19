# LGSideMenuController

iOS view controller, shows left and right views by pressing button or gesture.

[![Platform](https://img.shields.io/cocoapods/p/LGSideMenuController.svg)](https://github.com/Friend-LGA/LGSideMenuController)
[![CocoaPods](https://img.shields.io/cocoapods/v/LGSideMenuController.svg)](http://cocoadocs.org/docsets/LGSideMenuController)
[![Carthage](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg)](https://github.com/Friend-LGA/LGSideMenuController)
[![License](http://img.shields.io/cocoapods/l/LGSideMenuController.svg)](https://raw.githubusercontent.com/Friend-LGA/LGSideMenuController/master/LICENSE)

# Preview

<img src="https://raw.githubusercontent.com/Friend-LGA/ReadmeFiles/34a53dd6dee506f5cac7e99f67d2f92720f2d24c/LGSideMenuController/Preview1.gif" height="490"/> <img src="https://raw.githubusercontent.com/Friend-LGA/ReadmeFiles/34a53dd6dee506f5cac7e99f67d2f92720f2d24c/LGSideMenuController/1.png" height="490"/> <img src="https://raw.githubusercontent.com/Friend-LGA/ReadmeFiles/34a53dd6dee506f5cac7e99f67d2f92720f2d24c/LGSideMenuController/2.png" height="490"/>
<img src="https://raw.githubusercontent.com/Friend-LGA/ReadmeFiles/34a53dd6dee506f5cac7e99f67d2f92720f2d24c/LGSideMenuController/Preview2.gif" height="490"/>  <img src="https://raw.githubusercontent.com/Friend-LGA/ReadmeFiles/34a53dd6dee506f5cac7e99f67d2f92720f2d24c/LGSideMenuController/3.png" height="490"/> <img src="https://raw.githubusercontent.com/Friend-LGA/ReadmeFiles/34a53dd6dee506f5cac7e99f67d2f92720f2d24c/LGSideMenuController/4.png" height="490"/>
<img src="https://raw.githubusercontent.com/Friend-LGA/ReadmeFiles/34a53dd6dee506f5cac7e99f67d2f92720f2d24c/LGSideMenuController/Preview3.gif" height="490"/> <img src="https://raw.githubusercontent.com/Friend-LGA/ReadmeFiles/34a53dd6dee506f5cac7e99f67d2f92720f2d24c/LGSideMenuController/5.png" height="490"/> <img src="https://raw.githubusercontent.com/Friend-LGA/ReadmeFiles/34a53dd6dee506f5cac7e99f67d2f92720f2d24c/LGSideMenuController/6.png" height="490"/>

# Installation

| LGSideMenuController Version | Min iOS Version | Language    |
|------------------------------|-----------------|-------------|
| 1.0.0 - 1.0.10               | 6.0             | Objective-C |
| 1.1.0 - 2.2.0                | 8.0             | Objective-C |
| 2.3.0                        | 9.0             | Objective-C |
| 3.0.0                        | 9.0             | Swift       |

## With Source Code

1. [Download repository](https://github.com/Friend-LGA/LGSideMenuController/archive/master.zip)
2. Add [LGSideMenuController directory](https://github.com/Friend-LGA/LGSideMenuController/blob/master/LGSideMenuController/) to your project
3. Enjoy!

## With Swift Package Manager

Starting with Xcode 9.0 you can use built-in swift package manager, follow [apple documentation](https://developer.apple.com/documentation/swift_packages).
First supported version is `2.3.0`

## With CocoaPods

CocoaPods is a dependency manager for Objective-C, which automates and simplifies the process of using 3rd-party libraries in your projects. To install with cocoaPods, follow the "Get Started" section on [CocoaPods](https://cocoapods.org/).

### Podfile

```ruby
platform :ios, '9.0'
use_frameworks!
pod 'LGSideMenuController'
```

Then import framework where you need to use the library

```swift
import LGSideMenuController
```

## With Carthage

Carthage is a lightweight dependency manager for Swift and Objective-C. It leverages CocoaTouch modules and is less invasive than CocoaPods. To install with carthage, follow the instruction on [Carthage](https://github.com/Carthage/Carthage/).

### Cartfile

```ruby
github "Friend-LGA/LGSideMenuController"
```

Then import framework where you need to use the library

```swift
import LGSideMenuController
```

# Usage

## Initialization

You can use view controllers or views to initialize LGSideMenuController:

```swift
public init()

public init(rootViewController: UIViewController?,
            leftViewController: UIViewController?,
            rightViewController: UIViewController?)

public init(rootView: UIView?,
            leftView: UIView?,
            rightView: UIView?)
```

## Setup

To set or to change root, left or right view controllers or views, call:

```swift
sideMenuController.rootViewController = rootViewController
sideMenuController.leftViewController = leftViewController
sideMenuController.rightViewController = rightViewController

sideMenuController.rootView = rootView
sideMenuController.leftView = leftView
sideMenuController.rightView = rightView
```

## Quick Example

### Without Storyboard

1. Create root view controller (for example UINavigationController)
2. Create left view controller (for example UITableViewController)
3. Create right view controller (for example UITableViewController)
4. Create instance of LGSideMenuController with these controllers
5. Configure

```swift
let rootViewController = UINavigationController()
let leftViewController = UITableViewController()
let rightViewController = UITableViewController()

let sideMenuController = LGSideMenuController(rootViewController: rootViewController,
                                              leftViewController: leftViewController,
                                              rightViewController: rightViewController)

sideMenuController.leftViewWidth = 250.0
sideMenuController.leftViewPresentationStyle = .slideAbove

sideMenuController.rightViewWidth = 100.0
sideMenuController.leftViewPresentationStyle = .slideBelow
```

### With Storyboard

1. Create instance of LGSideMenuController
2. Create root view controller (for example UINavigationController)
3. Create left view controller (for example UITableViewController)
4. Create right view controller (for example UITableViewController)
5. Now you need to connect them all using segues of class `LGSideMenuSegue` with identifiers: `root`, `left`, `right`.

<img src="https://raw.githubusercontent.com/Friend-LGA/ReadmeFiles/dcb1aa9f4ce0fc1e7ded0ab595f6d346b1698e43/LGSideMenuController/Storyboard_Instructions/Segues/Root1.png" height="300"/> <img src="https://raw.githubusercontent.com/Friend-LGA/ReadmeFiles/dcb1aa9f4ce0fc1e7ded0ab595f6d346b1698e43/LGSideMenuController/Storyboard_Instructions/Segues/Root2.png" height="300"/> <img src="https://raw.githubusercontent.com/Friend-LGA/ReadmeFiles/dcb1aa9f4ce0fc1e7ded0ab595f6d346b1698e43/LGSideMenuController/Storyboard_Instructions/Segues/Root3.png" height="300"/>
<img src="https://raw.githubusercontent.com/Friend-LGA/ReadmeFiles/dcb1aa9f4ce0fc1e7ded0ab595f6d346b1698e43/LGSideMenuController/Storyboard_Instructions/Segues/Left1.png" height="300"/> <img src="https://raw.githubusercontent.com/Friend-LGA/ReadmeFiles/dcb1aa9f4ce0fc1e7ded0ab595f6d346b1698e43/LGSideMenuController/Storyboard_Instructions/Segues/Left2.png" height="300"/> <img src="https://raw.githubusercontent.com/Friend-LGA/ReadmeFiles/dcb1aa9f4ce0fc1e7ded0ab595f6d346b1698e43/LGSideMenuController/Storyboard_Instructions/Segues/Left3.png" height="300"/>
<img src="https://raw.githubusercontent.com/Friend-LGA/ReadmeFiles/dcb1aa9f4ce0fc1e7ded0ab595f6d346b1698e43/LGSideMenuController/Storyboard_Instructions/Segues/Right1.png" height="300"/> <img src="https://raw.githubusercontent.com/Friend-LGA/ReadmeFiles/dcb1aa9f4ce0fc1e7ded0ab595f6d346b1698e43/LGSideMenuController/Storyboard_Instructions/Segues/Right2.png" height="300"/> <img src="https://raw.githubusercontent.com/Friend-LGA/ReadmeFiles/dcb1aa9f4ce0fc1e7ded0ab595f6d346b1698e43/LGSideMenuController/Storyboard_Instructions/Segues/Right3.png" height="300"/>

6. You can change `leftViewWidth`, `leftViewPresentationStyle`, `rightViewWidth` and `rightViewPresentationStyle` inside LGSideMenuController's attributes inspector. There you can also find all other properties.

<img src="https://raw.githubusercontent.com/Friend-LGA/ReadmeFiles/d46bbba932f09fc91d91ada65d7060abec2be807/LGSideMenuController/Storyboard_Instructions/Properties.png" width="280"/>

For better examples check [demo projects](https://github.com/Friend-LGA/LGSideMenuController/tree/master/Demo).

## Blur

You can use UIBlurEffect with next properties:

```swift
leftViewBackgroundBlurEffect: UIBlurEffect
rightViewBackgroundBlurEffect: UIBlurEffect

rootViewCoverBlurEffectForLeftView: UIBlurEffect
rootViewCoverBlurEffectForRightView: UIBlurEffect

leftViewCoverBlurEffect: UIBlurEffect
rightViewCoverBlurEffect: UIBlurEffect
```

For example:

```swift
sideMenuController.leftViewBackgroundBlurEffect = UIBlurEffect(style: .regular)
```

If you want to change color of blurred view, use:

```objective-c
leftViewBackgroundColor: UIColor
rightViewBackgroundColor: UIColor

rootViewCoverColorForLeftView: UIColor
rootViewCoverColorForRightView: UIColor

leftViewCoverColor: UIColor
rightViewCoverColor: UIColor
```

For example:

```swift
sideMenuController.leftViewBackgroundColor = UIColor(red: 0.0, green: 0.5, blue: 1.0, alpha: 0.1)
```

If you want to change intensity of blurred view, use:

```swift
leftViewBackgroundAlpha: CGFloat
rightViewBackgroundAlpha: CGFloat

rootViewCoverAlphaForLeftView: CGFloat
rootViewCoverAlphaForRightView: CGFloat

CGFloatleftViewCoverAlpha: CGFloat
rightViewCoverAlpha: CGFloat
```

For example:

```swift
sideMenuController.leftViewBackgroundAlpha = 0.9
```

## Status Bar

If you want to have different status bar styles for root, left and right views, then you need to override `prefersStatusBarHidden`, `preferredStatusBarStyle` and `preferredStatusBarUpdateAnimation` in corresponding view controller or instead you can use these properties:

```swift
rootViewStatusBarHidden: BOOL
rootViewStatusBarStyle: UIStatusBarStyle
rootViewStatusBarUpdateAnimation: UIStatusBarAnimation

leftViewStatusBarHidden: BOOL
leftViewStatusBarStyle: UIStatusBarStyle
leftViewStatusBarUpdateAnimation: UIStatusBarAnimation

rightViewStatusBarHidden: BOOL
rightViewStatusBarStyle: UIStatusBarStyle
rightViewStatusBarUpdateAnimation: UIStatusBarAnimation
```

These properties have greater priority than overridden inside controllers `prefersStatusBarHidden, preferredStatusBarStyle, preferredStatusBarUpdateAnimation`.

For example, you had sideMenuController with rootViewController, leftViewController and rightViewController.
For rootViewController, you can override it's default methods or use sideMenuController's properties:

```swift
// In RootViewController.swift

override var prefersStatusBarHidden : Bool {
    return false
}

override var preferredStatusBarStyle : UIStatusBarStyle {
    return .default
}

override var preferredStatusBarUpdateAnimation : UIStatusBarAnimation {
    return .none
}

// OR in SideMenuController.swift

isRootViewStatusBarHidden = false
rootViewStatusBarStyle = .default
rootViewStatusBarUpdateAnimation = .none

// OR in SideMenuController.swift

override var isRootViewStatusBarHidden: Bool {
    get { return false }
    set { super.isRootViewStatusBarHidden = newValue }
}

override var rootViewStatusBarStyle: UIStatusBarStyle {
    get { return .default }
    set { super.rootViewStatusBarStyle = newValue }
}

override var rootViewStatusBarUpdateAnimation: UIStatusBarAnimation {
    get { return .none }
    set { super.rootViewStatusBarUpdateAnimation = newValue }
}
```

For `leftViewController and rightViewController` approach is the same.

## Always Visible Options

Sometimes, for example on iPad, you need to have toggleable side menu on portrait orientation and always visible side menu on landscape orientation

You can achieve it with properties:

```swift
leftViewAlwaysVisibleOptions: LGSideMenuController.AlwaysVisibleOptions
rightViewAlwaysVisibleOptions: LGSideMenuController.AlwaysVisibleOptions
```

You can choose multiple values like this:

```swift
sideMenuController.leftViewAlwaysVisibleOptions = [.padLandscape, .phoneLandscape]
// or
sideMenuController.leftViewAlwaysVisibleOptions = [.landscape]
```

## NavigationController's Back Gesture

Back gesture for UINavigationController has greater priority then swipe gesture for LGSideMenuController.
But if you want different behaviour, you can disable `interactivePopGestureRecognizer`

```swift
navigationController.interactivePopGestureRecognizer.isEnabled = false
```

## ScrollView

If you have scroll view, or any interactable elements inside sideMenuController, they will work until you swipe outside of `swipeGestureArea` for sideMenuController.
If you need more place to interact with your view then you can decrease `leftViewSwipeGestureRange, rightViewSwipeGestureRange` or disable it.

```swift
sideMenuController.swipeGestureArea = .borders // Default

sideMenuController.leftViewSwipeGestureRange = LGSideMenuSwipeGestureRangeMake(0.0, 22.0)
sideMenuController.rightViewSwipeGestureRange = LGSideMenuSwipeGestureRangeMake(22.0, 0.0)

// OR disable gestures completely

sideMenuController.leftViewSwipeGestureEnabled = false
sideMenuController.rightViewSwipeGestureEnabled = false
```

## Handle Actions

To handle actions you can use delegate, closures or notifications:

### Delegate

```swift
// LGSideMenuDelegate.swift

func willShowLeftView(sideMenuController: LGSideMenuController)
func didShowLeftView(sideMenuController: LGSideMenuController)

func willHideLeftView(sideMenuController: LGSideMenuController)
func didHideLeftView(sideMenuController: LGSideMenuController)

func willShowRightView(sideMenuController: LGSideMenuController)
func didShowRightView(sideMenuController: LGSideMenuController)

func willHideRightView(sideMenuController: LGSideMenuController)
func didHideRightView(sideMenuController: LGSideMenuController)

func showAnimationsForLeftView(sideMenuController: LGSideMenuController, duration: TimeInterval)
func hideAnimationsForLeftView(sideMenuController: LGSideMenuController, duration: TimeInterval)

func showAnimationsForRightView(sideMenuController: LGSideMenuController, duration: TimeInterval)
func hideAnimationsForRightView(sideMenuController: LGSideMenuController, duration: TimeInterval)
```

### Closures

```swift
var willShowLeftView: (sideMenuController: LGSideMenuController) -> Void
var didShowLeftView: (sideMenuController: LGSideMenuController) -> Void

var willHideLeftView: (sideMenuController: LGSideMenuController) -> Void
var didHideLeftView: (sideMenuController: LGSideMenuController) -> Void

var willShowRightView: (sideMenuController: LGSideMenuController) -> Void
var didShowRightView: (sideMenuController: LGSideMenuController) -> Void

var willHideRightView: (sideMenuController: LGSideMenuController) -> Void
var didHideRightView: (sideMenuController: LGSideMenuController) -> Void

var showAnimationsForLeftView: (sideMenuController: LGSideMenuController, duration: TimeInterval) -> Void
var hideAnimationsForLeftView: (sideMenuController: LGSideMenuController, duration: TimeInterval) -> Void

var showAnimationsForRightView: (sideMenuController: LGSideMenuController, duration: TimeInterval) -> Void
var hideAnimationsForRightView: (sideMenuController: LGSideMenuController, duration: TimeInterval) -> Void
```

### Notifications

```swift
let LGSideMenuController.Notification.willShowLeftView
let LGSideMenuController.Notification.didShowLeftView

let LGSideMenuController.Notification.willHideLeftView
let LGSideMenuController.Notification.didHideLeftView

let LGSideMenuController.Notification.willShowRightView
let LGSideMenuController.Notification.didShowRightView

let LGSideMenuController.Notification.willHideRightView
let LGSideMenuController.Notification.didHideRightView

let LGSideMenuController.Notification.showAnimationsForLeftView
let LGSideMenuController.Notification.hideAnimationsForLeftView

let LGSideMenuController.Notification.showAnimationsForRightView
let LGSideMenuController.Notification.hideAnimationsForRightView
```

## More

For more details see [files itself](https://github.com/Friend-LGA/LGSideMenuController/tree/master/LGSideMenuController) and try Xcode [demo projects](https://github.com/Friend-LGA/LGSideMenuController/tree/master/Demo):
* [Without Storyboard](https://github.com/Friend-LGA/LGSideMenuController/tree/master/Demo/NonStoryboard)
* [With Storyboard](https://github.com/Friend-LGA/LGSideMenuController/tree/master/Demo/Storyboard)

# Frameworks

If you like LGSideMenuController, check out my other useful libraries:
* [LGAlertView](https://github.com/Friend-LGA/LGAlertView)
  Customizable implementation of UIAlertViewController, UIAlertView and UIActionSheet. All in one. You can customize every detail. Make AlertView of your dream! :)
* [LGPlusButtonsView](https://github.com/Friend-LGA/LGPlusButtonsView)
  Customizable iOS implementation of Floating Action Button (Google Plus Button, fab).

# License

LGSideMenuController is released under the MIT license. See [LICENSE](https://raw.githubusercontent.com/Friend-LGA/LGSideMenuController/master/LICENSE) for details.
