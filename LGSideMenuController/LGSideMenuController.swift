//
//  LGSideMenuController.swift
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

import Foundation
import CoreGraphics
import QuartzCore
import UIKit

open class LGSideMenuController: UIViewController, UIGestureRecognizerDelegate {

    public typealias Completion = () -> Void
    public typealias Callback = (LGSideMenuController) -> Void
    public typealias AnimationsCallback = (LGSideMenuController, TimeInterval, CAMediaTimingFunction) -> Void
    public typealias TransformCallback = (LGSideMenuController, CGFloat) -> Void

    /// Notification names and keys to observe behaviour of LGSideMenuController
    public struct Notification {

        public static let willShowLeftView = NSNotification.Name("LGSideMenuController.Notification.willShowLeftView")
        public static let didShowLeftView  = NSNotification.Name("LGSideMenuController.Notification.didShowLeftView")

        public static let willHideLeftView = NSNotification.Name("LGSideMenuController.Notification.willHideLeftView")
        public static let didHideLeftView  = NSNotification.Name("LGSideMenuController.Notification.didHideLeftView")

        public static let willShowRightView = NSNotification.Name("LGSideMenuController.Notification.willShowRightView")
        public static let didShowRightView  = NSNotification.Name("LGSideMenuController.Notification.didShowRightView")

        public static let willHideRightView = NSNotification.Name("LGSideMenuController.Notification.willHideRightView")
        public static let didHideRightView  = NSNotification.Name("LGSideMenuController.Notification.didHideRightView")

        /// This notification is posted inside animation block for showing left view.
        /// You can retrieve duration and timing function of the animation from userInfo dictionary.
        /// Use it to add some custom animations.
        public static let showAnimationsForLeftView = NSNotification.Name("LGSideMenuController.Notification.showAnimationsForLeftView")

        /// This notification is posted inside animation block for hiding left view.
        /// You can retrieve duration and timing function of the animation from userInfo dictionary.
        /// Use it to add some custom animations.
        public static let hideAnimationsForLeftView = NSNotification.Name("LGSideMenuController.Notification.hideAnimationsForLeftView")

        /// This notification is posted inside animation block for showing right view.
        /// You can retrieve duration and timing function of the animation from userInfo dictionary.
        /// Use it to add some custom animations.
        public static let showAnimationsForRightView = NSNotification.Name("LGSideMenuController.Notification.showAnimationsForRightView")

        /// This notification is posted inside animation block for hiding right view.
        /// You can retrieve duration and timing function of the animation from userInfo dictionary.
        /// Use it to add some custom animations.
        public static let hideAnimationsForRightView = NSNotification.Name("LGSideMenuController.Notification.hideAnimationsForRightView")

        /// This notification is posted on every transformation of root view during showing/hiding of side views.
        /// You can retrieve percentage between `0.0` and `1.0` from userInfo dictionary, where
        ///   - `0.0` - view is fully shown
        ///   - `1.0` - view is fully hidden
        public static let didTransformRootView = NSNotification.Name("LGSideMenuController.Notification.didTransformRootView")

        /// This notification is posted on every transformation of left view during showing/hiding.
        /// You can retrieve percentage between `0.0` and `1.0` from userInfo dictionary, where
        ///   - `0.0` - view is fully hidden
        ///   - `1.0` - view is fully shown
        public static let didTransformLeftView = NSNotification.Name("LGSideMenuController.Notification.didTransformLeftView")

        /// This notification is posted on every transformation of right view during showing/hiding.
        /// You can retrieve percentage between `0.0` and `1.0` from userInfo dictionary, where
        ///   - `0.0` - view is fully hidden
        ///   - `1.0` - view is fully shown
        public static let didTransformRightView  = NSNotification.Name("LGSideMenuController.Notification.didTransformRightView")

        /// Key names to retrieve data from userInfo dictionary passed with notification.
        public struct Key {
            /// Key for userInfo dictionary which represents duration of the animation.
            static let duration = "duration"

            /// Key for userInfo dictionary which represents timing function of the animation.
            static let timigFunction = "timigFunction"

            /// Key for userInfo dictionary which represents current transformation percentage.
            static let percentage = "percentage"
        }

    }

    /// Options which determine when side view should be always visible.
    /// For example you might want to always show side view on iPad with landscape orientation.
    public struct AlwaysVisibleOptions: OptionSet {
        public let rawValue: Int

        public static let padLandscape   = AlwaysVisibleOptions(rawValue: 1 << 0)
        public static let padPortrait    = AlwaysVisibleOptions(rawValue: 1 << 1)
        public static let phoneLandscape = AlwaysVisibleOptions(rawValue: 1 << 2)
        public static let phonePortrait  = AlwaysVisibleOptions(rawValue: 1 << 3)

        /// Based on horizontalSizeClass of current traitCollection.
        public static let padRegular   = AlwaysVisibleOptions(rawValue: 1 << 4)
        /// Based on horizontalSizeClass of current traitCollection.
        public static let padCompact   = AlwaysVisibleOptions(rawValue: 1 << 5)
        /// Based on horizontalSizeClass of current traitCollection.
        public static let phoneRegular = AlwaysVisibleOptions(rawValue: 1 << 6)
        /// Based on horizontalSizeClass of current traitCollection.
        public static let phoneCompact = AlwaysVisibleOptions(rawValue: 1 << 7)

        public static let landscape: AlwaysVisibleOptions = [.padLandscape, .phoneLandscape]
        public static let portrait: AlwaysVisibleOptions  = [.padPortrait, .phonePortrait]
        /// Based on horizontalSizeClass of current traitCollection.
        public static let regular: AlwaysVisibleOptions   = [.padRegular, .phoneRegular]
        /// Based on horizontalSizeClass of current traitCollection.
        public static let compact: AlwaysVisibleOptions   = [.padCompact, .phoneCompact]
        public static let pad: AlwaysVisibleOptions       = [.padLandscape, .padPortrait, .padRegular, .padCompact]
        public static let phone: AlwaysVisibleOptions     = [.phoneLandscape, .phonePortrait, .phoneRegular, .phoneCompact]
        public static let all: AlwaysVisibleOptions       = [.pad, .phone]

        public init(rawValue: Int = 0) {
            self.rawValue = rawValue
        }

        public func isVisible(sizeClass: UIUserInterfaceSizeClass) -> Bool {
            guard let orientation = LGSideMenuHelper.getInterfaceOrientation() else { return false }

            return isVisible(orientation: orientation, sizeClass: sizeClass)
        }

        public func isVisible(orientation: UIInterfaceOrientation, sizeClass: UIUserInterfaceSizeClass) -> Bool {
            if LGSideMenuHelper.isPad() {
                if orientation.isLandscape && contains(.padLandscape) {
                    return true
                }
                if orientation.isPortrait && contains(.padPortrait) {
                    return true
                }
                if sizeClass == .regular && contains(.padRegular) {
                    return true
                }
                if sizeClass == .compact && contains(.padCompact) {
                    return true
                }
            }
            if LGSideMenuHelper.isPhone() {
                if orientation.isLandscape && contains(.phoneLandscape) {
                    return true
                }
                if orientation.isPortrait && contains(.phonePortrait) {
                    return true
                }
                if sizeClass == .regular && contains(.phoneRegular) {
                    return true
                }
                if sizeClass == .compact && contains(.phoneCompact) {
                    return true
                }
            }
            return false
        }
    }

    /// Default styles to present side views
    public enum PresentationStyle {
        /// Side view is located below the root view and when appearing is changing its scale from large to normal.
        /// Root view also is going to be minimized and moved aside.
        case scaleFromBig
        /// Side view is located below the root view and when appearing is changing its scale from small to normal.
        /// Root view also is going to be minimized and moved aside.
        case scaleFromLittle
        /// Side view is located above the root view and when appearing is sliding from a side.
        /// Root view is staying still.
        case slideAbove
        /// Side view is located above the root view and when appearing is sliding from a side.
        /// Root view is staying still.
        /// Side view has blurred background.
        case slideAboveBlurred
        /// Side view is located below the root view.
        /// Root view is going to be moved aside.
        case slideBelow
        /// Side view is located below the root view.
        /// Root view is going to be moved aside.
        /// Also content of the side view has extra shifting.
        case slideBelowShifted
        /// Side view is located at the same level as root view and when appearing is sliding from a side.
        /// Root view is going to be moved together with the side view.
        case slideAside

        public init() {
            self = .slideAbove
        }

        /// Tells if a side view is located above the root view.
        public var isAbove: Bool {
            return
                self == .slideAbove ||
                self == .slideAboveBlurred
        }

        /// Tells if a side view is located below the root view.
        public var isBelow: Bool {
            return
                self == .slideBelow ||
                self == .slideBelowShifted ||
                self == .scaleFromBig ||
                self == .scaleFromLittle
        }

        /// Tells if a side view is located on the same level as the root view.
        public var isAside: Bool {
            return self == .slideAside
        }

        /// Tells if a side view is appearing from a side.
        public var isHiddenAside: Bool {
            return
                self == .slideAbove ||
                self == .slideAboveBlurred ||
                self == .slideAside
        }

        /// Tells if a side view width needs to take whole space of the container.
        public var isWidthFull: Bool {
            return
                self == .slideBelow ||
                self == .slideBelowShifted ||
                self == .scaleFromBig ||
                self == .scaleFromLittle
        }

        /// Tells if a side view width needs to take only necessary space.
        public var isWidthCompact: Bool {
            return
                self == .slideAbove ||
                self == .slideAboveBlurred ||
                self == .slideAside
        }

        /// Tells if the root view is going to move.
        public var shouldRootViewMove: Bool {
            return
                self == .slideBelow ||
                self == .slideBelowShifted ||
                self == .slideAside ||
                self == .scaleFromBig ||
                self == .scaleFromLittle
        }

        /// Tells if the root view is going to change its scale.
        public var shouldRootViewScale: Bool {
            return
                self == .scaleFromBig ||
                self == .scaleFromLittle
        }
    }

    /// The area which should be responsive to gestures.
    public enum SwipeGestureArea {
        /// When root view is opened then gestures are going to work only at the edges of the root view.
        /// When root view is hidden by the side view, whole root view is responsive to gestures.
        case borders
        /// Whole root view is always responsive to gestures.
        case full

        public init() {
            self = .borders
        }
    }

    /// When `SwipeGestureArea` is `borders` this range is used to determine the area around borders of the root view,
    /// which should be responsive to gestures.
    /// When `SwipeGestureArea` is `full` this range is used to determine only the outside area around borders of the root view,
    /// which should be responsive to gestures.
    public struct SwipeGestureRange {
        /// Distance to the left side from an edge of the root view
        public let left: CGFloat
        /// Distance to the right side from an edge of the root view
        public let right: CGFloat

        public init(left: CGFloat = 44.0, right: CGFloat = 44.0) {
            self.left = left
            self.right = right
        }
    }

    /// Needs to keep internal state of LGSideMenuController.
    /// Describes which view is showing/hidden or is going to be shown/hidden
    public enum State {
        case rootViewIsShowing

        case leftViewWillShow
        case leftViewIsShowing
        case leftViewWillHide

        case rightViewWillShow
        case rightViewIsShowing
        case rightViewWillHide

        public init() {
            self = .rootViewIsShowing
        }

        public var isLeftViewVisible: Bool {
            return self == .leftViewIsShowing || self == .leftViewWillShow || self == .leftViewWillHide
        }

        public var isRightViewVisible: Bool {
            return self == .rightViewIsShowing || self == .rightViewWillShow || self == .rightViewWillHide
        }

        public var isRootViewHidden: Bool {
            return self == .leftViewIsShowing || self == .rightViewIsShowing
        }

        public var isLeftViewHidden: Bool {
            return !isLeftViewVisible
        }

        public var isRightViewHidden: Bool {
            return !isRightViewVisible
        }
    }

    // MARK: - Base View Controllers -

    /// Main view controller which view is presented as the root view.
    /// User needs to provide this view controller.
    /// - Note:
    ///   - Either one of the properties can be used at a time: `rootViewController` or `rootView`.
    ///   - If `rootViewController` is assigned, then `rootView` will return `rootViewController.view`.
    open var rootViewController: UIViewController? {
        set {
            removeViewController(_rootViewController)
            _rootViewController = newValue

            _rootView?.removeFromSuperview()
            _rootView = nil

            guard let viewController = _rootViewController else {
                removeRootViews()
                return
            }

            _rootView = viewController.view
            LGSideMenuHelper.setSideMenuController(self, to: viewController)
            setNeedsUpdateRootViewLayoutsAndStyles()
        }
        get {
            if _rootViewController == nil && storyboard != nil {
                tryPerformRootSegueIfNeeded()
            }
            return _rootViewController
        }
    }
    private var _rootViewController: UIViewController? = nil

    /// View controller which view is presented as the left side view.
    /// User needs to provide this view controller.
    /// - Note:
    ///   - Either one of the properties can be used at a time: `leftViewController` or `leftView`.
    ///   - If `leftViewController` is assigned, then `leftView` will return `leftViewController.view`.
    open var leftViewController: UIViewController? {
        set {
            removeViewController(_leftViewController)
            _leftViewController = newValue

            _leftView?.removeFromSuperview()
            _leftView = nil

            guard let viewController = _leftViewController else {
                removeLeftViews()
                return
            }

            _leftView = viewController.view
            LGSideMenuHelper.setSideMenuController(self, to: viewController)
            setNeedsUpdateLeftViewLayoutsAndStyles()
        }
        get {
            if _leftViewController == nil && storyboard != nil {
                tryPerformLeftSegueIfNeeded()
            }
            return _leftViewController
        }
    }
    private var _leftViewController: UIViewController? = nil

    /// View controller which view is presented as the right side view.
    /// User needs to provide this view controller.
    /// - Note:
    ///   - Either one of the properties can be used at a time: `rightViewController` or `rightView`.
    ///   - If `rightViewController` is assigned, then `rightView` will return `rightViewController.view`.
    open var rightViewController: UIViewController? {
        set {
            removeViewController(_rightViewController)
            _rightViewController = newValue

            _rightView?.removeFromSuperview()
            _rightView = nil

            guard let viewController = _rightViewController else {
                removeRightViews()
                return
            }

            _rightView = viewController.view
            LGSideMenuHelper.setSideMenuController(self, to: viewController)
            setNeedsUpdateRightViewLayoutsAndStyles()
        }
        get {
            if _rightViewController == nil && storyboard != nil {
                tryPerformRightSegueIfNeeded()
            }
            return _rightViewController
        }
    }
    private var _rightViewController: UIViewController? = nil

    // MARK: - Base Views -

    /// View which is presented as the root view.
    /// User needs to provide this view.
    /// - Note:
    ///   - Either one of the properties can be used at a time: `rootViewController` or `rootView`.
    ///   - If `rootViewController` is assigned, then `rootView` will return `rootViewController.view`.
    open var rootView: UIView? {
        set {
            _rootView?.removeFromSuperview()
            _rootView = newValue

            removeViewController(_rootViewController)
            _rootViewController = nil

            guard _rootView != nil else {
                removeRootViews()
                return
            }

            setNeedsUpdateRootViewLayoutsAndStyles()
        }
        get {
            return _rootView
        }
    }
    private var _rootView: UIView? = nil

    /// View which is presented as the left side view.
    /// User needs to provide this view.
    /// - Note:
    ///   - Either one of the properties can be used at a time: `leftViewController` or `leftView`.
    ///   - If `leftViewController` is assigned, then `leftView` will return `leftViewController.view`.
    open var leftView: UIView? {
        set {
            _leftView?.removeFromSuperview()
            _leftView = newValue

            removeViewController(_leftViewController)
            _leftViewController = nil

            guard _leftView != nil else {
                removeLeftViews()
                return
            }

            setNeedsUpdateLeftViewLayoutsAndStyles()
        }
        get {
            return _leftView
        }
    }
    private var _leftView: UIView? = nil

    /// View which is presented as the right side view.
    /// User needs to provide this view.
    /// - Note:
    ///   - Either one of the properties can be used at a time: `rightViewController` or `rightView`.
    ///   - If `rightViewController` is assigned, then `rightView` will return `rightViewController.view`.
    open var rightView: UIView? {
        set {
            _rightView?.removeFromSuperview()
            _rightView = newValue

            removeViewController(_rightViewController)
            _rightViewController = nil

            guard _rightView != nil else {
                removeRightViews()
                return
            }

            setNeedsUpdateRightViewLayoutsAndStyles()
        }
        get {
            return _rightView
        }
    }
    private var _rightView: UIView? = nil

    // MARK: - Gestures -

    /// Gesture recognizer which is used to handle tap gestures on the rootView when it is hidden to close any opened side view.
    /// Usually shouldn't be manipulated by user.
    public let tapGesture: UITapGestureRecognizer

    /// Gesture recognizer which is used to handle pan gestures on the rootView to show and hide left side views.
    /// Usually shouldn't be manipulated by user.
    public let panGestureForLeftView: UIPanGestureRecognizer

    /// Gesture recognizer which is used to handle pan gestures on the rootView to show and hide right side views.
    /// Usually shouldn't be manipulated by user.
    public let panGestureForRightView: UIPanGestureRecognizer

    // MARK: - Side Views Availability -

    /// Use this property when you want to temporarily disable left side view.
    /// When view is disabled, it won't respond to gestures and show/hide requests.
    @IBInspectable
    open var isLeftViewEnabled: Bool = true

    /// Use this property when you want to temporarily disable right side view.
    /// When view is disabled, it won't respond to gestures and show/hide requests.
    @IBInspectable
    open var isRightViewEnabled: Bool = true

    /// Use this property when you want to temporarily disable left side view.
    /// When view is disabled, it won't respond to gestures and show/hide requests.
    open var isLeftViewDisabled: Bool {
        set {
            self.isLeftViewEnabled = !newValue
        }
        get {
            return !isLeftViewEnabled
        }
    }

    /// Use this property when you want to temporarily disable right side view.
    /// When view is disabled, it won't respond to gestures and show/hide requests.
    open var isRightViewDisabled: Bool {
        set {
            self.isRightViewEnabled = !newValue
        }
        get {
            return !isRightViewEnabled
        }
    }

    // MARK: - Width -

    /// Basic property to determine width of the left side view.
    /// User assignable.
    /// - Returns: Default:
    ///   - `min(ScreenSize.minSide - 44.0, 320.0)`
    @IBInspectable
    open var leftViewWidth: CGFloat = {
        let minScreenSide = min(UIScreen.main.bounds.width, UIScreen.main.bounds.height)
        return min(minScreenSide - 44.0, 320.0)
    }() {
        didSet {
            setNeedsUpdateLayoutsAndStyles()
        }
    }

    /// Basic property to determine width of the right side view.
    /// User assignable.
    /// - Returns: Default:
    ///   - `min(ScreenSize.minSide - 44.0, 320.0)`
    @IBInspectable
    open var rightViewWidth: CGFloat = {
        let minScreenSide = min(UIScreen.main.bounds.width, UIScreen.main.bounds.height)
        return min(minScreenSide - 44.0, 320.0)
    }() {
        didSet {
            setNeedsUpdateLayoutsAndStyles()
        }
    }

    // MARK: - Presentation Style -

    /// Basic property to determine style of left side view presentation. User assignable.
    open var leftViewPresentationStyle: PresentationStyle = .slideAbove {
        didSet {
            setNeedsUpdateLayoutsAndStyles()
        }
    }

    /// Basic property to determine style of right side view presentation. User assignable.
    open var rightViewPresentationStyle: PresentationStyle = .slideAbove {
        didSet {
            setNeedsUpdateLayoutsAndStyles()
        }
    }

    // MARK: - Always Visible Options -

    /// Options which determine when the left side view should be always visible.
    /// For example you might want to always show side view on iPad with landscape orientation.
    open var leftViewAlwaysVisibleOptions: AlwaysVisibleOptions = [] {
        didSet {
            setNeedsUpdateLayoutsAndStyles()
        }
    }

    /// Options which determine when the right side view should be always visible.
    /// For example you might want to always show side view on iPad with landscape orientation.
    open var rightViewAlwaysVisibleOptions: AlwaysVisibleOptions = [] {
        didSet {
            setNeedsUpdateLayoutsAndStyles()
        }
    }

    // MARK: - Gestures Availability -

    /// Set it to true to be able to hide left view without animation by touching root view.
    @IBInspectable
    open var shouldLeftViewHideOnTouch: Bool = true

    /// Set it to true to be able to hide right view without animation by touching root view.
    @IBInspectable
    open var shouldRightViewHideOnTouch: Bool = true

    /// Set it to true to be able to hide left view with animation by touching root view.
    @IBInspectable
    open var shouldLeftViewHideOnTouchAnimated: Bool = true

    /// Set it to true to be able to hide right view with animation by touching root view.
    @IBInspectable
    open var shouldRightViewHideOnTouchAnimated: Bool = true

    /// Use this property to disable pan gestures to show/hide left side view.
    @IBInspectable
    open var isLeftViewSwipeGestureEnabled: Bool = true

    /// Use this property to disable pan gestures to show/hide right side view.
    @IBInspectable
    open var isRightViewSwipeGestureEnabled: Bool = true

    /// Use this property to disable pan gestures to show/hide left side view.
    open var isLeftViewSwipeGestureDisabled: Bool {
        set {
            self.isLeftViewSwipeGestureEnabled = !newValue
        }
        get {
            return !isLeftViewSwipeGestureEnabled
        }
    }

    /// Use this property to disable pan gestures to show/hide right side view.
    open var isRightViewSwipeGestureDisabled: Bool {
        set {
            self.isRightViewSwipeGestureEnabled = !newValue
        }
        get {
            return !isRightViewSwipeGestureEnabled
        }
    }

    // MARK: - Swipe Gesture Area -

    /// The area which should be responsive to pan gestures to show/hide left side view.
    open var leftViewSwipeGestureArea: SwipeGestureArea = .borders

    /// The area which should be responsive to pan gestures to show/hide right side view.
    open var rightViewSwipeGestureArea: SwipeGestureArea = .borders

    // MARK: - Swipe Gesture Range -

    /// This range is used to determine the area around left border of the root view,
    /// which should be responsive to gestures.
    /// - Description:
    ///   - For `SwipeGestureRange(left: 44.0, right: 44.0)` => leftView 44.0 | 44.0 rootView.
    ///   - For `SwipeGestureRange(left: 0.0, right: 44.0)`  => leftView  0.0 | 44.0 rootView.
    ///   - For `SwipeGestureRange(left: 44.0, right: 0.0)`  => leftView 44.0 | 0.0  rootView.
    /// - Note:
    ///   - if `leftSwipeGestureArea == .full` then right part is ignored.
    open var leftViewSwipeGestureRange = SwipeGestureRange(left: 0.0, right: 44.0)

    /// This range is used to determine the area around right border of the root view,
    /// which should be responsive to gestures.
    /// - Description:
    ///   - For `SwipeGestureRange(left: 44.0, right: 44.0)` => rootView 44.0 | 44.0 rightView.
    ///   - For `SwipeGestureRange(left: 0.0, right: 44.0)`  => rootView  0.0 | 44.0 rightView.
    ///   - For `SwipeGestureRange(left: 44.0, right: 0.0)`  => rootView 44.0 | 0.0  rightView.
    /// - Note:
    ///   - if `rightSwipeGestureArea == .full` then left part is ignored.
    open var rightViewSwipeGestureRange = SwipeGestureRange(left: 44.0, right: 0.0)

    // MARK: - Animations Properties -

    /// Duration of the animation to show/hide left side view.
    @IBInspectable
    open var leftViewAnimationDuration: TimeInterval = 0.45

    /// Duration of the animation to show/hide right side view.
    @IBInspectable
    open var rightViewAnimationDuration: TimeInterval = 0.45

    /// Timing Function to describe animation to show/hide left side view.
    @IBInspectable
    open var leftViewAnimationTimingFunction = CAMediaTimingFunction(controlPoints: 0.33333, 0.66667, 0.33333, 1.0)

    /// Timing Function to describe animation to show/hide right side view.
    @IBInspectable
    open var rightViewAnimationTimingFunction = CAMediaTimingFunction(controlPoints: 0.33333, 0.66667, 0.33333, 1.0)

    // MARK: - Background Color -

    /// Color for the background view, located behind the root view.
    /// - Note:
    ///   - Not equal to `rootView.backgroundColor`.
    @IBInspectable
    open var rootViewBackgroundColor: UIColor = .clear {
        didSet {
            setNeedsUpdateLayoutsAndStyles()
        }
    }

    /// Color for the background view, located behind the left side view.
    /// - Note:
    ///   - Not equal to `leftView.backgroundColor`.
    @IBInspectable
    open var leftViewBackgroundColor: UIColor = .clear {
        didSet {
            setNeedsUpdateLayoutsAndStyles()
        }
    }

    /// Color for the background view, located behind the right side view.
    /// - Note:
    ///   - Not equal to `rightView.backgroundColor`.
    @IBInspectable
    open var rightViewBackgroundColor: UIColor = .clear {
        didSet {
            setNeedsUpdateLayoutsAndStyles()
        }
    }

    // MARK: - Background View -

    /// Use this property to provide custom background view, located behind the left side view.
    /// - Note:
    ///   - Can't be used together with `leftViewBackgroundImage`.
    @IBInspectable
    open var leftViewBackgroundView: UIView? {
        willSet {
            if newValue == nil {
                leftViewBackgroundView?.removeFromSuperview()
            }
        }
        didSet {
            if leftViewBackgroundView != nil {
                leftViewBackgroundImage = nil
            }
            setNeedsUpdateLayoutsAndStyles()
        }
    }

    /// Use this property to provide custom background view, located behind the right side view.
    /// - Note:
    ///   - Can't be used together with `rightViewBackgroundImage`.
    @IBInspectable
    open var rightViewBackgroundView: UIView? {
        willSet {
            if newValue == nil {
                rightViewBackgroundView?.removeFromSuperview()
            }
        }
        didSet {
            if rightViewBackgroundView != nil {
                rightViewBackgroundImage = nil
            }
            setNeedsUpdateLayoutsAndStyles()
        }
    }

    // MARK: - Background Image -

    /// Use this property to provide custom background image, located behind the left side view.
    /// - Note:
    ///   - Can't be used together with `leftViewBackgroundView`.
    @IBInspectable
    open var leftViewBackgroundImage: UIImage? {
        willSet {
            if newValue == nil,
               let leftViewBackgroundImageView = self.leftViewBackgroundImageView {
                leftViewBackgroundImageView.removeFromSuperview()
                self.leftViewBackgroundImageView = nil
            }
        }
        didSet {
            if leftViewBackgroundImage != nil,
               let leftViewBackgroundView = self.leftViewBackgroundView {
                leftViewBackgroundView.removeFromSuperview()
                self.leftViewBackgroundView = nil
            }
            setNeedsUpdateLayoutsAndStyles()
        }
    }

    /// Use this property to provide custom background image, located behind the right side view.
    /// - Note:
    ///   - Can't be used together with `rightViewBackgroundView`.
    @IBInspectable
    open var rightViewBackgroundImage: UIImage? {
        willSet {
            if newValue == nil,
               let rightViewBackgroundImageView = self.rightViewBackgroundImageView {
                rightViewBackgroundImageView.removeFromSuperview()
                self.rightViewBackgroundImageView = nil
            }
        }
        didSet {
            if rightViewBackgroundImage != nil,
               let rightViewBackgroundView = self.rightViewBackgroundView {
                rightViewBackgroundView.removeFromSuperview()
                self.rightViewBackgroundView = nil
            }
            setNeedsUpdateLayoutsAndStyles()
        }
    }

    // MARK: - Background Blur Effect -

    /// Use this property to set `UIBlurEffect` for background view, located behind the left side view.
    /// - Returns: Default:
    ///   - `.regular` if `presentationStyle == .slideAboveBlurred`
    ///   - `nil` otherwise
    @IBInspectable
    open var leftViewBackgroundBlurEffect: UIBlurEffect? {
        set {
            _leftViewBackgroundBlurEffect = newValue
            _isLeftViewBackgroundBlurEffectAssigned = true
        }
        get {
            if _isLeftViewBackgroundBlurEffectAssigned {
                return _leftViewBackgroundBlurEffect
            }
            if leftViewPresentationStyle == .slideAboveBlurred {
                if #available(iOS 10.0, *) {
                    return UIBlurEffect(style: .regular)
                } else {
                    return UIBlurEffect(style: .light)
                }
            }
            return nil
        }
    }
    private var _leftViewBackgroundBlurEffect: UIBlurEffect?
    private var _isLeftViewBackgroundBlurEffectAssigned: Bool = false

    /// Use this property to set `UIBlurEffect` for background view, located behind the right side view.
    /// - Returns: Default:
    ///   - `.regular` if `presentationStyle == .slideAboveBlurred`
    ///   - `nil` otherwise
    @IBInspectable
    open var rightViewBackgroundBlurEffect: UIBlurEffect? {
        set {
            _rightViewBackgroundBlurEffect = newValue
            _isRightViewBackgroundBlurEffectAssigned = true
        }
        get {
            if _isRightViewBackgroundBlurEffectAssigned {
                return _rightViewBackgroundBlurEffect
            }
            if rightViewPresentationStyle == .slideAboveBlurred {
                if #available(iOS 10.0, *) {
                    return UIBlurEffect(style: .regular)
                } else {
                    return UIBlurEffect(style: .light)
                }
            }
            return nil
        }
    }
    private var _rightViewBackgroundBlurEffect: UIBlurEffect?
    private var _isRightViewBackgroundBlurEffectAssigned: Bool = false

    // MARK: - Background Alpha -

    /// Use this property to set `alpha` for background view, located behind the left side view.
    @IBInspectable
    open var leftViewBackgroundAlpha: CGFloat = 1.0

    /// Use this property to set `alpha` for background view, located behind the left side view.
    @IBInspectable
    open var rightViewBackgroundAlpha: CGFloat = 1.0

    // MARK: - Layer Border Color -

    /// Use this property to decorate the root view with border.
    /// - Note:
    ///   - Make sense only together with `rootViewLayerBorderWidth`
    @IBInspectable
    open var rootViewLayerBorderColor: UIColor?

    /// Use this property to decorate the root view with border,
    /// which is visible only when the left side view is showing.
    /// - Returns: Default:
    ///   - `rootViewLayerBorderColor` if assigned
    ///   - `.clear` otherwise
    /// - Note:
    ///   - Make sense only together with `rootViewLayerBorderWidthForLeftView`
    @IBInspectable
    open var rootViewLayerBorderColorForLeftView: UIColor {
        set {
            _rootViewLayerBorderColorForLeftView = newValue
        }
        get {
            if let rootViewLayerBorderColorForLeftView = _rootViewLayerBorderColorForLeftView {
                return rootViewLayerBorderColorForLeftView
            }
            if let rootViewLayerBorderColorForLeftView = rootViewLayerBorderColor {
                return rootViewLayerBorderColorForLeftView
            }
            return .clear
        }
    }
    private var _rootViewLayerBorderColorForLeftView: UIColor?

    /// Use this property to decorate the root view with border,
    /// which is visible only when the right side view is showing.
    /// - Returns: Default:
    ///   - `rootViewLayerBorderColor` if assigned
    ///   - `.clear` otherwise
    /// - Note:
    ///   - Make sense only together with `rootViewLayerBorderWidthForRightView`
    @IBInspectable
    open var rootViewLayerBorderColorForRightView: UIColor {
        set {
            _rootViewLayerBorderColorForRightView = newValue
        }
        get {
            if let rootViewLayerBorderColorForRightView = _rootViewLayerBorderColorForRightView {
                return rootViewLayerBorderColorForRightView
            }
            if let rootViewLayerBorderColorForRightView = rootViewLayerBorderColor {
                return rootViewLayerBorderColorForRightView
            }
            return .clear
        }
    }
    private var _rootViewLayerBorderColorForRightView: UIColor?

    /// Use this property to decorate the left side view with border.
    /// - Note:
    ///   - Make sense only together with `leftViewLayerBorderWidth`
    @IBInspectable
    open var leftViewLayerBorderColor: UIColor = .clear

    /// Use this property to decorate the right side view with border.
    /// - Note:
    ///   - Make sense only together with `rightViewLayerBorderWidth`
    @IBInspectable
    open var rightViewLayerBorderColor: UIColor = .clear

    // MARK: - Layer Border Width -

    /// Use this property to decorate the root view with border.
    /// - Note:
    ///   - Make sense only together with `rootViewLayerBorderColor`
    open var rootViewLayerBorderWidth: CGFloat?

    /// Use this property to decorate the root view with border,
    /// which is visible only when the left side view is showing.
    /// - Returns: Default:
    ///   - `rootViewLayerBorderWidth` if assigned
    ///   - `0.0` otherwise
    /// - Note:
    ///   - Make sense only together with `rootViewLayerBorderColorForLeftView`
    @IBInspectable
    open var rootViewLayerBorderWidthForLeftView: CGFloat {
        set {
            _rootViewLayerBorderWidthForLeftView = newValue
        }
        get {
            if let rootViewLayerBorderWidthForLeftView = _rootViewLayerBorderWidthForLeftView {
                return rootViewLayerBorderWidthForLeftView
            }
            if let rootViewLayerBorderWidthForLeftView = rootViewLayerBorderWidth {
                return rootViewLayerBorderWidthForLeftView
            }
            return 0.0
        }
    }
    private var _rootViewLayerBorderWidthForLeftView: CGFloat?

    /// Use this property to decorate the root view with border,
    /// which is visible only when the right side view is showing.
    /// - Returns: Default:
    ///   - `rootViewLayerBorderWidth` if assigned
    ///   - `0.0` otherwise
    /// - Note:
    ///   - Make sense only together with `rootViewLayerBorderColorForRightView`
    @IBInspectable
    open var rootViewLayerBorderWidthForRightView: CGFloat {
        set {
            _rootViewLayerBorderWidthForRightView = newValue
        }
        get {
            if let rootViewLayerBorderWidthForRightView = _rootViewLayerBorderWidthForRightView {
                return rootViewLayerBorderWidthForRightView
            }
            if let rootViewLayerBorderWidthForRightView = rootViewLayerBorderWidth {
                return rootViewLayerBorderWidthForRightView
            }
            return 0.0
        }
    }
    private var _rootViewLayerBorderWidthForRightView: CGFloat?

    /// Use this property to decorate the left side view with border.
    /// - Note:
    ///   - Make sense only together with `leftViewLayerBorderColor`
    @IBInspectable
    open var leftViewLayerBorderWidth: CGFloat = 0.0

    /// Use this property to decorate the right side view with border.
    /// - Note:
    ///   - Make sense only together with `rightViewLayerBorderColor`
    @IBInspectable
    open var rightViewLayerBorderWidth: CGFloat = 0.0

    // MARK: - Layer Shadow Color -

    /// Use this property to decorate the root view with shadow.
    /// - Note:
    ///   - Make sense only together with `rootViewLayerShadowRadius`
    @IBInspectable
    open var rootViewLayerShadowColor: UIColor?

    /// Use this property to decorate the root view with shadow
    /// which is visible only when the left side view is showing.
    /// - Returns: Default:
    ///   - `rootViewLayerShadowColor` if assigned
    ///   - `UIColor(white: 0.0, alpha: 0.5)` if `presentationStyle.isBelow`
    ///   - `.clear` otherwise
    /// - Note:
    ///   - Make sense only together with `rootViewLayerShadowRadiusForLeftView`
    @IBInspectable
    open var rootViewLayerShadowColorForLeftView: UIColor {
        set {
            _rootViewLayerShadowColorForLeftView = newValue
        }
        get {
            if let rootViewLayerShadowColorForLeftView = _rootViewLayerShadowColorForLeftView {
                return rootViewLayerShadowColorForLeftView
            }
            if let rootViewLayerShadowColorForLeftView = rootViewLayerShadowColor {
                return rootViewLayerShadowColorForLeftView
            }
            if leftViewPresentationStyle.isBelow {
                return UIColor(white: 0.0, alpha: 0.5)
            }
            return .clear
        }
    }
    private var _rootViewLayerShadowColorForLeftView: UIColor?

    /// Use this property to decorate the root view with shadow
    /// which is visible only when the right side view is showing.
    /// - Returns: Default:
    ///   - `rootViewLayerShadowColor` if assigned
    ///   - `UIColor(white: 0.0, alpha: 0.5)` if `presentationStyle.isBelow`
    ///   - `.clear` otherwise
    /// - Note:
    ///   - Make sense only together with `rootViewLayerShadowRadiusForRightView`
    @IBInspectable
    open var rootViewLayerShadowColorForRightView: UIColor {
        set {
            _rootViewLayerShadowColorForRightView = newValue
        }
        get {
            if let rootViewLayerShadowColorForRightView = _rootViewLayerShadowColorForRightView {
                return rootViewLayerShadowColorForRightView
            }
            if let rootViewLayerShadowColorForRightView = rootViewLayerShadowColor {
                return rootViewLayerShadowColorForRightView
            }
            if rightViewPresentationStyle.isBelow {
                return UIColor(white: 0.0, alpha: 0.5)
            }
            return .clear
        }
    }
    private var _rootViewLayerShadowColorForRightView: UIColor?

    /// Use this property to decorate the left side view with shadow.
    /// - Returns: Default:
    ///   - `UIColor(white: 0.0, alpha: 0.5)` if `presentationStyle.isAbove`
    ///   - `.clear` otherwise
    /// - Note:
    ///   - Make sense only together with `leftViewLayerShadowRadius`
    @IBInspectable
    open var leftViewLayerShadowColor: UIColor {
        set {
            _leftViewLayerShadowColor = newValue
        }
        get {
            if let leftViewLayerShadowColor = _leftViewLayerShadowColor {
                return leftViewLayerShadowColor
            }
            if leftViewPresentationStyle.isAbove {
                return UIColor(white: 0.0, alpha: 0.5)
            }
            return .clear
        }
    }
    private var _leftViewLayerShadowColor: UIColor?

    /// Use this property to decorate the right side view with shadow.
    /// - Returns: Default:
    ///   - `UIColor(white: 0.0, alpha: 0.5)` if `presentationStyle.isAbove`
    ///   - `.clear` otherwise
    /// - Note:
    ///   - Make sense only together with `rightViewLayerShadowRadius`
    @IBInspectable
    open var rightViewLayerShadowColor: UIColor {
        set {
            _rightViewLayerShadowColor = newValue
        }
        get {
            if let rightViewLayerShadowColor = _rightViewLayerShadowColor {
                return rightViewLayerShadowColor
            }
            if rightViewPresentationStyle.isAbove {
                return UIColor(white: 0.0, alpha: 0.5)
            }
            return .clear
        }
    }
    private var _rightViewLayerShadowColor: UIColor?

    // MARK: - Layer Shadow Radius -

    /// Use this property to decorate the root view with shadow.
    /// - Note:
    ///   - Make sense only together with `rootViewLayerShadowColor`
    open var rootViewLayerShadowRadius: CGFloat?

    /// Use this property to decorate the root view with shadow
    /// which is visible only when the left side view is showing.
    /// - Returns: Default:
    ///   - `rootViewLayerShadowRadius` if assigned
    ///   - `8.0` if `presentationStyle.isBelow`
    ///   - `0.0` otherwise
    /// - Note:
    ///   - Make sense only together with `rootViewLayerShadowColorForLeftView`
    @IBInspectable
    open var rootViewLayerShadowRadiusForLeftView: CGFloat {
        set {
            _rootViewLayerShadowRadiusForLeftView = newValue
        }
        get {
            if let rootViewLayerShadowRadiusForLeftView = _rootViewLayerShadowRadiusForLeftView {
                return rootViewLayerShadowRadiusForLeftView
            }
            if let rootViewLayerShadowRadiusForLeftView = rootViewLayerShadowRadius {
                return rootViewLayerShadowRadiusForLeftView
            }
            if leftViewPresentationStyle.isBelow {
                return 8.0
            }
            return 0.0
        }
    }
    private var _rootViewLayerShadowRadiusForLeftView: CGFloat?

    /// Use this property to decorate the root view with shadow
    /// which is visible only when the right side view is showing.
    /// - Returns: Default:
    ///   - `rootViewLayerShadowRadius` if assigned
    ///   - `8.0` if `presentationStyle.isBelow`
    ///   - `0.0` otherwise
    /// - Note:
    ///   - Make sense only together with `rootViewLayerShadowColorForRightView`
    @IBInspectable
    open var rootViewLayerShadowRadiusForRightView: CGFloat {
        set {
            _rootViewLayerShadowRadiusForRightView = newValue
        }
        get {
            if let rootViewLayerShadowRadiusForRightView = _rootViewLayerShadowRadiusForRightView {
                return rootViewLayerShadowRadiusForRightView
            }
            if let rootViewLayerShadowRadiusForRightView = rootViewLayerShadowRadius {
                return rootViewLayerShadowRadiusForRightView
            }
            if rightViewPresentationStyle.isBelow {
                return 8.0
            }
            return 0.0
        }
    }
    private var _rootViewLayerShadowRadiusForRightView: CGFloat?

    /// Use this property to decorate the left side view with shadow.
    /// - Returns: Default:
    ///   - `8.0` if `presentationStyle.isAbove`
    ///   - `0.0` otherwise
    /// - Note:
    ///   - Make sense only together with `leftViewLayerShadowColor`
    @IBInspectable
    open var leftViewLayerShadowRadius: CGFloat {
        set {
            _leftViewLayerShadowRadius = newValue
        }
        get {
            if let leftViewLayerShadowRadius = _leftViewLayerShadowRadius {
                return leftViewLayerShadowRadius
            }
            if leftViewPresentationStyle.isAbove {
                return 8.0
            }
            return .zero
        }
    }
    private var _leftViewLayerShadowRadius: CGFloat?

    /// Use this property to decorate the right side view with shadow.
    /// - Returns: Default:
    ///   - `8.0` if `presentationStyle.isAbove`
    ///   - `0.0` otherwise
    /// - Note:
    ///   - Make sense only together with `rightViewLayerShadowColor`
    @IBInspectable
    open var rightViewLayerShadowRadius: CGFloat {
        set {
            _rightViewLayerShadowRadius = newValue
        }
        get {
            if let rightViewLayerShadowRadius = _rightViewLayerShadowRadius {
                return rightViewLayerShadowRadius
            }
            if rightViewPresentationStyle.isAbove {
                return 8.0
            }
            return .zero
        }
    }
    private var _rightViewLayerShadowRadius: CGFloat?

    // MARK: - Cover Blur Effect -

    /// Use this property to set `UIBlurEffect` for cover view, located above the root view.
    /// - Note:
    ///   - Cover view is visible only when the root view is hidden. Animated between show/hide states.
    ///   - Make sense to use if you want to hide the content of the root view or lower the attention.
    @IBInspectable
    open var rootViewCoverBlurEffect: UIBlurEffect?

    /// Use this property to set `UIBlurEffect` for cover view, located above the root view,
    /// which is visible only when the left side view is showing.
    /// - Returns: Default:
    ///   - `rootViewCoverBlurEffect` if assigned
    /// - Note:
    ///   - Cover view is visible only when the root view is hidden. Animated between show/hide states.
    ///   - Make sense to use if you want to hide the content of the root view or lower the attention.
    @IBInspectable
    open var rootViewCoverBlurEffectForLeftView: UIBlurEffect? {
        set {
            _rootViewCoverBlurEffectForLeftView = newValue
        }
        get {
            if let rootViewCoverBlurEffectForLeftView = rootViewCoverBlurEffect {
                return rootViewCoverBlurEffectForLeftView
            }
            return _rootViewCoverBlurEffectForLeftView
        }
    }
    private var _rootViewCoverBlurEffectForLeftView: UIBlurEffect?

    /// Use this property to set `UIBlurEffect` for cover view, located above the root view,
    /// which is visible only when the right side view is showing.
    /// - Returns: Default:
    ///   - `rootViewCoverBlurEffect` if assigned
    /// - Note:
    ///   - Cover view is visible only when the root view is hidden. Animated between show/hide states.
    ///   - Make sense to use if you want to hide the content of the root view or lower the attention.
    @IBInspectable
    open var rootViewCoverBlurEffectForRightView: UIBlurEffect? {
        set {
            _rootViewCoverBlurEffectForRightView = newValue
        }
        get {
            if let rootViewCoverBlurEffectForRightView = rootViewCoverBlurEffect {
                return rootViewCoverBlurEffectForRightView
            }
            return _rootViewCoverBlurEffectForRightView
        }
    }
    private var _rootViewCoverBlurEffectForRightView: UIBlurEffect?

    /// Use this property to set `UIBlurEffect` for cover view, located above the left side view.
    /// - Note:
    ///   - Cover view is visible only when the left side view is hidden. Animated between show/hide states.
    @IBInspectable
    open var leftViewCoverBlurEffect: UIBlurEffect?

    /// Use this property to set `UIBlurEffect` for cover view, located above the left side view,
    /// which is visible only if the `leftViewAlwaysVisibleOptions` is true for current conditions.
    /// - Returns: Default:
    ///   - `rootViewCoverBlurEffectForRightView`
    /// - Note:
    ///   - Cover view is visible only when the left side view is hidden. Animated between show/hide states.
    @IBInspectable
    open var leftViewCoverBlurEffectWhenAlwaysVisible: UIBlurEffect? {
        set {
            _leftViewCoverBlurEffectWhenAlwaysVisible = newValue
            _isLeftViewCoverBlurEffectWhenAlwaysVisibleAssigned = true
        }
        get {
            if _isLeftViewCoverBlurEffectWhenAlwaysVisibleAssigned {
                return _leftViewCoverBlurEffectWhenAlwaysVisible
            }
            return rootViewCoverBlurEffectForRightView
        }
    }
    private var _leftViewCoverBlurEffectWhenAlwaysVisible: UIBlurEffect?
    private var _isLeftViewCoverBlurEffectWhenAlwaysVisibleAssigned: Bool = false

    /// Use this property to set `UIBlurEffect` for cover view, located above the right side view.
    /// - Note:
    ///   - Cover view is visible only when the right side view is hidden. Animated between show/hide states.
    @IBInspectable
    open var rightViewCoverBlurEffect: UIBlurEffect?

    /// Use this property to set `UIBlurEffect` for cover view, located above the right side view,
    /// which is visible only if the `rightViewAlwaysVisibleOptions` is true for current conditions.
    /// - Returns: Default:
    ///   - `rootViewCoverBlurEffectForLeftView`
    /// - Note:
    ///   - Cover view is visible only when the right side view is hidden. Animated between show/hide states.
    @IBInspectable
    open var rightViewCoverBlurEffectWhenAlwaysVisible: UIBlurEffect? {
        set {
            _rightViewCoverBlurEffectWhenAlwaysVisible = newValue
            _isRightViewCoverBlurEffectWhenAlwaysVisibleAssigned = true
        }
        get {
            if _isRightViewCoverBlurEffectWhenAlwaysVisibleAssigned {
                return _rightViewCoverBlurEffectWhenAlwaysVisible
            }
            return rootViewCoverBlurEffectForLeftView
        }
    }
    private var _rightViewCoverBlurEffectWhenAlwaysVisible: UIBlurEffect?
    private var _isRightViewCoverBlurEffectWhenAlwaysVisibleAssigned: Bool = false

    // MARK: - Cover Alpha -

    /// Use this property to set `alpha` for cover view, located above the root view.
    /// - Note:
    ///   - Cover view is visible only when the root view is hidden. Animated between show/hide states.
    open var rootViewCoverAlpha: CGFloat?

    /// Use this property to set `alpha` for cover view, located above the root view,
    /// which is visible only when the left side view is showing.
    /// - Returns: Default:
    ///   - `rootViewCoverAlpha` if assigned
    ///   - `1.0` otherwise
    /// - Note:
    ///   - Cover view is visible only when the root view is hidden. Animated between show/hide states.
    @IBInspectable
    open var rootViewCoverAlphaForLeftView: CGFloat {
        set {
            _rootViewCoverAlphaForLeftView = newValue
        }
        get {
            if let rootViewCoverAlphaForLeftView = _rootViewCoverAlphaForLeftView {
                return rootViewCoverAlphaForLeftView
            }
            if let rootViewCoverAlphaForLeftView = rootViewCoverAlpha {
                return rootViewCoverAlphaForLeftView
            }
            return 1.0
        }
    }
    private var _rootViewCoverAlphaForLeftView: CGFloat?

    /// Use this property to set `alpha` for cover view, located above the root view,
    /// which is visible only when the right side view is showing.
    /// - Returns: Default:
    ///   - `rootViewCoverAlpha` if assigned
    ///   - `1.0` otherwise
    /// - Note:
    ///   - Cover view is visible only when the root view is hidden. Animated between show/hide states.
    @IBInspectable
    open var rootViewCoverAlphaForRightView: CGFloat {
        set {
            _rootViewCoverAlphaForRightView = newValue
        }
        get {
            if let rootViewCoverAlphaForRightView = _rootViewCoverAlphaForRightView {
                return rootViewCoverAlphaForRightView
            }
            if let rootViewCoverAlphaForRightView = rootViewCoverAlpha {
                return rootViewCoverAlphaForRightView
            }
            return 1.0
        }
    }
    private var _rootViewCoverAlphaForRightView: CGFloat?

    /// Use this property to set `alpha` for cover view, located above the left side view.
    /// - Note:
    ///   - Cover view is visible only when the left side view is hidden. Animated between show/hide states.
    @IBInspectable
    open var leftViewCoverAlpha: CGFloat = 1.0

    /// Use this property to set `alpha` for cover view, located above the left side view,
    /// which is visible only if the `leftViewAlwaysVisibleOptions` is true for current conditions.
    /// - Returns: Default:
    ///   - `rootViewCoverAlphaForRightView`
    /// - Note:
    ///   - Cover view is visible only when the left side view is hidden. Animated between show/hide states.
    @IBInspectable
    open var leftViewCoverAlphaWhenAlwaysVisible: CGFloat {
        set {
            _leftViewCoverAlphaWhenAlwaysVisible = newValue
        }
        get {
            if let leftViewCoverAlphaWhenAlwaysVisible = _leftViewCoverAlphaWhenAlwaysVisible {
                return leftViewCoverAlphaWhenAlwaysVisible
            }
            return rootViewCoverAlphaForRightView
        }
    }
    private var _leftViewCoverAlphaWhenAlwaysVisible: CGFloat?

    /// Use this property to set `alpha` for cover view, located above the right side view.
    /// - Note:
    ///   - Cover view is visible only when the right side view is hidden. Animated between show/hide states.
    @IBInspectable
    open var rightViewCoverAlpha: CGFloat = 1.0

    /// Use this property to set `alpha` for cover view, located above the right side view,
    /// which is visible only if the `rightViewAlwaysVisibleOptions` is true for current conditions.
    /// - Returns: Default:
    ///   - `rootViewCoverAlphaForLeftView`
    /// - Note:
    ///   - Cover view is visible only when the right side view is hidden. Animated between show/hide states.
    @IBInspectable
    open var rightViewCoverAlphaWhenAlwaysVisible: CGFloat {
        set {
            _rightViewCoverAlphaWhenAlwaysVisible = newValue
        }
        get {
            if let rightViewCoverAlphaWhenAlwaysVisible = _rightViewCoverAlphaWhenAlwaysVisible {
                return rightViewCoverAlphaWhenAlwaysVisible
            }
            return rootViewCoverAlphaForLeftView
        }
    }
    private var _rightViewCoverAlphaWhenAlwaysVisible: CGFloat?

    // MARK: - Cover Color -

    /// Use this property to set color for cover view, located above the root view.
    /// - Note:
    ///   - Cover view is visible only when the root view is hidden. Animated between show/hide states.
    ///   - Make sense to use if you want to hide the content of the root view or lower the attention.
    @IBInspectable
    open var rootViewCoverColor: UIColor?

    /// Use this property to set color for cover view, located above the root view,
    /// which is visible only when the left side view is showing.
    /// - Returns: Default:
    ///   - `rootViewCoverColor` if assigned
    ///   - `.clear` otherwise
    /// - Note:
    ///   - Cover view is visible only when the root view is hidden. Animated between show/hide states.
    ///   - Make sense to use if you want to hide the content of the root view or lower the attention.
    @IBInspectable
    open var rootViewCoverColorForLeftView: UIColor {
        set {
            _rootViewCoverColorForLeftView = newValue
        }
        get {
            if let rootViewCoverColorForLeftView = _rootViewCoverColorForLeftView {
                return rootViewCoverColorForLeftView
            }
            if let rootViewCoverColorForLeftView = rootViewCoverColor {
                return rootViewCoverColorForLeftView
            }
            return .clear
        }
    }
    private var _rootViewCoverColorForLeftView: UIColor?

    /// Use this property to set color for cover view, located above the root view,
    /// which is visible only when the right side view is showing.
    /// - Returns: Default:
    ///   - `rootViewCoverColor` if assigned
    ///   - `.clear` otherwise
    /// - Note:
    ///   - Cover view is visible only when the root view is hidden. Animated between show/hide states.
    ///   - Make sense to use if you want to hide the content of the root view or lower the attention.
    @IBInspectable
    open var rootViewCoverColorForRightView: UIColor {
        set {
            _rootViewCoverColorForRightView = newValue
        }
        get {
            if let rootViewCoverColorForRightView = _rootViewCoverColorForRightView {
                return rootViewCoverColorForRightView
            }
            if let rootViewCoverColorForRightView = rootViewCoverColor {
                return rootViewCoverColorForRightView
            }
            return .clear
        }
    }
    private var _rootViewCoverColorForRightView: UIColor?

    /// Use this property to set color for cover view, located above the left side view.
    /// - Returns: Default:
    ///   - `UIColor(white: 0.0, alpha: 0.5)` if `presentationStyle.isBelow`
    ///   - `.clear` otherwise
    /// - Note:
    ///   - Cover view is visible only when the left side view is hidden. Animated between show/hide states.
    @IBInspectable
    open var leftViewCoverColor: UIColor {
        set {
            _leftViewCoverColor = newValue
        }
        get {
            if let leftViewCoverColor = _leftViewCoverColor {
                return leftViewCoverColor
            }
            if leftViewPresentationStyle.isBelow {
                return UIColor(white: 0.0, alpha: 0.5)
            }
            return .clear
        }
    }
    private var _leftViewCoverColor: UIColor?

    /// Use this property to set color for cover view, located above the left side view,
    /// which is visible only if the `leftViewAlwaysVisibleOptions` is true for current conditions.
    /// - Returns: Default:
    ///   - `rootViewCoverColorForRightView`
    /// - Note:
    ///   - Cover view is visible only when the left side view is hidden. Animated between show/hide states.
    @IBInspectable
    open var leftViewCoverColorWhenAlwaysVisible: UIColor {
        set {
            _leftViewCoverColorWhenAlwaysVisible = newValue
        }
        get {
            if let leftViewCoverColorWhenAlwaysVisible = _leftViewCoverColorWhenAlwaysVisible {
                return leftViewCoverColorWhenAlwaysVisible
            }
            return rootViewCoverColorForRightView
        }
    }
    private var _leftViewCoverColorWhenAlwaysVisible: UIColor?

    /// Use this property to set color for cover view, located above the right side view.
    /// - Returns: Default:
    ///   - `UIColor(white: 0.0, alpha: 0.5)` if `presentationStyle.isBelow`
    ///   - `.clear` otherwise
    /// - Note:
    ///   - Cover view is visible only when the right side view is hidden. Animated between show/hide states.
    @IBInspectable
    open var rightViewCoverColor: UIColor {
        set {
            _rightViewCoverColor = newValue
        }
        get {
            if let rightViewCoverColor = _rightViewCoverColor {
                return rightViewCoverColor
            }
            if rightViewPresentationStyle.isBelow {
                return UIColor(white: 0.0, alpha: 0.5)
            }
            return .clear
        }
    }
    private var _rightViewCoverColor: UIColor?

    /// Use this property to set color for cover view, located above the right side view,
    /// which is visible only if the `rightViewAlwaysVisibleOptions` is true for current conditions.
    /// - Returns: Default:
    ///   - `rootViewCoverColorForLeftView`
    /// - Note:
    ///   - Cover view is visible only when the right side view is hidden. Animated between show/hide states.
    @IBInspectable
    open var rightViewCoverColorWhenAlwaysVisible: UIColor {
        set {
            _rightViewCoverColorWhenAlwaysVisible = newValue
        }
        get {
            if let rightViewCoverColorWhenAlwaysVisible = _rightViewCoverColorWhenAlwaysVisible {
                return rightViewCoverColorWhenAlwaysVisible
            }
            return rootViewCoverColorForLeftView
        }
    }
    private var _rightViewCoverColorWhenAlwaysVisible: UIColor?

    // MARK: - Status Bar -

    /// Duration of the animation with which status bar update its style while swipe gesture to show/hide side view.
    @IBInspectable
    open var statusBarAnimationDuration: TimeInterval = 0.2

    // MARK: - Status Bar Hidden -

    /// Determines if the status bar should be hidden when the root view is showing.
    /// - Returns: Default:
    ///   - `rootViewController.prefersStatusBarHidden ?? prefersStatusBarHidden`
    /// - Note:
    ///   - The recommended way is to override `prefersStatusBarHidden` method inside `rootViewController`.
    @IBInspectable
    open var isRootViewStatusBarHidden: Bool {
        set {
            _isRootViewStatusBarHidden = newValue
        }
        get {
            return _isRootViewStatusBarHidden ?? rootViewController?.prefersStatusBarHidden ?? prefersStatusBarHidden
        }
    }
    private var _isRootViewStatusBarHidden: Bool?

    /// Determines if the status bar should be hidden when the left side view is showing.
    /// - Returns: Default:
    ///   - `leftViewController.prefersStatusBarHidden ?? rootViewStatusBarHidden`
    /// - Note:
    ///   - The recommended way is to override `prefersStatusBarHidden` method inside `leftViewController`.
    @IBInspectable
    open var isLeftViewStatusBarHidden: Bool {
        set {
            _isLeftViewStatusBarHidden = newValue
        }
        get {
            return _isLeftViewStatusBarHidden ?? leftViewController?.prefersStatusBarHidden ?? isRootViewStatusBarHidden
        }
    }
    private var _isLeftViewStatusBarHidden: Bool?

    /// Determines if the status bar should be hidden when the right side view is showing.
    /// - Returns: Default:
    ///   - `rightViewController.prefersStatusBarHidden ?? rootViewStatusBarHidden`
    /// - Note:
    ///   - The recommended way is to override `prefersStatusBarHidden` method inside `rightViewController`.
    @IBInspectable
    open var isRightViewStatusBarHidden: Bool {
        set {
            _isRightViewStatusBarHidden = newValue
        }
        get {
            return _isRightViewStatusBarHidden ?? rightViewController?.prefersStatusBarHidden ?? isRootViewStatusBarHidden
        }
    }
    private var _isRightViewStatusBarHidden: Bool?

    // MARK: - Status Bar Style -

    /// Determines the status bar style when the root view is showing.
    /// - Returns: Default:
    ///   - `rootViewController.preferredStatusBarStyle ?? preferredStatusBarStyle`
    /// - Note:
    ///   - The recommended way is to override `preferredStatusBarStyle` method inside `rootViewController`.
    @IBInspectable
    open var rootViewStatusBarStyle: UIStatusBarStyle {
        set {
            _rootViewStatusBarStyle = newValue
        }
        get {
            return _rootViewStatusBarStyle ?? rootViewController?.preferredStatusBarStyle ?? preferredStatusBarStyle
        }
    }
    private var _rootViewStatusBarStyle: UIStatusBarStyle?

    /// Determines the status bar style when the left side view is showing.
    /// - Returns: Default:
    ///   - `leftViewController.preferredStatusBarStyle ?? rootViewStatusBarStyle`
    /// - Note:
    ///   - The recommended way is to override `preferredStatusBarStyle` method inside `leftViewController`.
    @IBInspectable
    open var leftViewStatusBarStyle: UIStatusBarStyle {
        set {
            _leftViewStatusBarStyle = newValue
        }
        get {
            return _leftViewStatusBarStyle ?? leftViewController?.preferredStatusBarStyle ?? rootViewStatusBarStyle
        }
    }
    private var _leftViewStatusBarStyle: UIStatusBarStyle?

    /// Determines the status bar style when the right side view is showing.
    /// - Returns: Default:
    ///   - `rightViewController.preferredStatusBarStyle ?? rootViewStatusBarStyle`
    /// - Note:
    ///   - The recommended way is to override `preferredStatusBarStyle` method inside `rightViewController`.
    @IBInspectable
    open var rightViewStatusBarStyle: UIStatusBarStyle {
        set {
            _rightViewStatusBarStyle = newValue
        }
        get {
            return _rightViewStatusBarStyle ?? rightViewController?.preferredStatusBarStyle ?? rootViewStatusBarStyle
        }
    }
    private var _rightViewStatusBarStyle: UIStatusBarStyle?

    // MARK: - Status Bar Update Animation -

    /// Determines the status bar update animation when the root view is showing.
    /// - Returns: Default:
    ///   - `rootViewController.preferredStatusBarUpdateAnimation ?? preferredStatusBarUpdateAnimation`
    /// - Note:
    ///   - The recommended way is to override `preferredStatusBarUpdateAnimation` method inside `rootViewController`.
    @IBInspectable
    open var rootViewStatusBarUpdateAnimation: UIStatusBarAnimation {
        set {
            _rootViewStatusBarUpdateAnimation = newValue
        }
        get {
            return _rootViewStatusBarUpdateAnimation ?? rootViewController?.preferredStatusBarUpdateAnimation ?? preferredStatusBarUpdateAnimation
        }
    }
    private var _rootViewStatusBarUpdateAnimation: UIStatusBarAnimation?

    /// Determines the status bar update animation when the left side view is showing.
    /// - Returns: Default:
    ///   - `leftViewController.preferredStatusBarUpdateAnimation ?? rootViewStatusBarUpdateAnimation`
    /// - Note:
    ///   - The recommended way is to override `preferredStatusBarUpdateAnimation` method inside `leftViewController`.
    @IBInspectable
    open var leftViewStatusBarUpdateAnimation: UIStatusBarAnimation {
        set {
            _leftViewStatusBarUpdateAnimation = newValue
        }
        get {
            return _leftViewStatusBarUpdateAnimation ?? leftViewController?.preferredStatusBarUpdateAnimation ?? rootViewStatusBarUpdateAnimation
        }
    }
    private var _leftViewStatusBarUpdateAnimation: UIStatusBarAnimation?

    /// Determines the status bar update animation when the right side view is showing.
    /// - Returns: Default:
    ///   - `rightViewController.preferredStatusBarUpdateAnimation ?? rootViewStatusBarUpdateAnimation`
    /// - Note:
    ///   - The recommended way is to override `preferredStatusBarUpdateAnimation` method inside `rightViewController`.
    @IBInspectable
    open var rightViewStatusBarUpdateAnimation: UIStatusBarAnimation {
        set {
            _rightViewStatusBarUpdateAnimation = newValue
        }
        get {
            return _rightViewStatusBarUpdateAnimation ?? rightViewController?.preferredStatusBarUpdateAnimation ?? rootViewStatusBarUpdateAnimation
        }
    }
    private var _rightViewStatusBarUpdateAnimation: UIStatusBarAnimation?

    // MARK: - Status Bar Background Visibility -

    /// Most of the time side view contains table view but not navigation bar.
    /// In this case we provide default background view for status bar,
    /// to not interfere with the content of the side view.
    /// If this status bar background is unwanted, you can hide it using this property.
    @IBInspectable
    open var isLeftViewStatusBarBackgroundVisible: Bool = true

    /// Most of the time side view contains table view but not navigation bar.
    /// In this case we provide default background view for status bar,
    /// to not interfere with the content of the side view.
    /// If this status bar background is unwanted, you can hide it using this property.
    open var isLeftViewStatusBarBackgroundHidden: Bool {
        set {
            isLeftViewStatusBarBackgroundVisible = !newValue
        }
        get {
            return !isLeftViewStatusBarBackgroundVisible
        }
    }

    /// Most of the time side view contains table view but not navigation bar.
    /// In this case we provide default background view for status bar,
    /// to not interfere with the content of the side view.
    /// If this status bar background is unwanted, you can hide it using this property.
    @IBInspectable
    open var isRightViewStatusBarBackgroundVisible: Bool = true

    /// Most of the time side view contains table view but not navigation bar.
    /// In this case we provide default background view for status bar,
    /// to not interfere with the content of the side view.
    /// If this status bar background is unwanted, you can hide it using this property.
    open var isRightViewStatusBarBackgroundHidden: Bool {
        set {
            isRightViewStatusBarBackgroundVisible = !newValue
        }
        get {
            return !isRightViewStatusBarBackgroundVisible
        }
    }

    // MARK: - Status Bar Background Color -

    /// Color for the background view of the status bar, which is visible when the left side view is showing.
    /// - Note:
    ///   - `isLeftViewStatusBarBackgroundVisible` should be enabled to use this property.
    @IBInspectable
    open var leftViewStatusBarBackgroundColor: UIColor = .clear

    /// Color for the background view of the status bar, which is visible when the right side view is showing.
    /// - Note:
    ///   - `isRightViewStatusBarBackgroundVisible` should be enabled to use this property.
    @IBInspectable
    open var rightViewStatusBarBackgroundColor: UIColor = .clear

    // MARK: - Status Bar Background Blur Effect -

    /// `UIBlurEffect` for the background view of the status bar, which is visible when the left side view is showing.
    /// - Note:
    ///   - `isLeftViewStatusBarBackgroundVisible` should be enabled to use this property.
    @IBInspectable
    open var leftViewStatusBarBackgroundBlurEffect: UIBlurEffect? {
        set {
            _leftViewStatusBarBackgroundBlurEffect = newValue
            _isLeftViewStatusBarBackgroundBlurEffectAssigned = true
        }
        get {
            if _isLeftViewStatusBarBackgroundBlurEffectAssigned {
                return _leftViewStatusBarBackgroundBlurEffect
            }
            if leftViewStatusBarStyle == .lightContent {
                return UIBlurEffect(style: .dark)
            }
            if #available(iOS 13.0, *) {
                if leftViewStatusBarStyle == .darkContent {
                    return UIBlurEffect(style: .light)
                }
            }
            if #available(iOS 10.0, *) {
                return UIBlurEffect(style: .regular)
            }
            return UIBlurEffect(style: .dark)
        }
    }
    private var _leftViewStatusBarBackgroundBlurEffect: UIBlurEffect?
    private var _isLeftViewStatusBarBackgroundBlurEffectAssigned: Bool = false

    /// `UIBlurEffect` for the background view of the status bar, which is visible when the right side view is showing.
    /// - Note:
    ///   - `isRightViewStatusBarBackgroundVisible` should be enabled to use this property.
    @IBInspectable
    open var rightViewStatusBarBackgroundBlurEffect: UIBlurEffect? {
        set {
            _rightViewStatusBarBackgroundBlurEffect = newValue
            _isRightViewStatusBarBackgroundBlurEffectAssigned = true
        }
        get {
            if _isRightViewStatusBarBackgroundBlurEffectAssigned {
                return _rightViewStatusBarBackgroundBlurEffect
            }
            if rightViewStatusBarStyle == .lightContent {
                return UIBlurEffect(style: .dark)
            }
            if #available(iOS 13.0, *) {
                if rightViewStatusBarStyle == .darkContent {
                    return UIBlurEffect(style: .light)
                }
            }
            if #available(iOS 10.0, *) {
                return UIBlurEffect(style: .regular)
            }
            return UIBlurEffect(style: .dark)
        }
    }
    private var _rightViewStatusBarBackgroundBlurEffect: UIBlurEffect?
    private var _isRightViewStatusBarBackgroundBlurEffectAssigned: Bool = false

    // MARK: - Status Bar Background Alpha -

    /// `alpha` for the background view of the status bar, which is visible when the left side view is showing.
    /// - Note:
    ///   - `isLeftViewStatusBarBackgroundVisible` should be enabled to use this property.
    @IBInspectable
    open var leftViewStatusBarBackgroundAlpha: CGFloat = 1.0

    /// `alpha` for the background view of the status bar, which is visible when the right side view is showing.
    /// - Note:
    ///   - `isRightViewStatusBarBackgroundVisible` should be enabled to use this property.
    @IBInspectable
    open var rightViewStatusBarBackgroundAlpha: CGFloat = 1.0

    // MARK: - Status Bar Background Shadow Color -

    /// Shadow color for the background view of the status bar, which is visible when the left side view is showing.
    /// - Note:
    ///   - `isLeftViewStatusBarBackgroundVisible` should be enabled to use this property.
    ///   - Make sense only together with `leftViewStatusBarBackgroundShadowRadius`
    @IBInspectable
    open var leftViewStatusBarBackgroundShadowColor: UIColor = .clear

    /// Shadow color for the background view of the status bar, which is visible when the right side view is showing.
    /// - Note:
    ///   - `isRightViewStatusBarBackgroundVisible` should be enabled to use this property.
    ///   - Make sense only together with `rightViewStatusBarBackgroundShadowRadius`
    @IBInspectable
    open var rightViewStatusBarBackgroundShadowColor: UIColor = .clear

    // MARK: - Status Bar Background Shadow Radius -

    /// Shadow radius for the background view of the status bar, which is visible when the left side view is showing.
    /// - Note:
    ///   - `isLeftViewStatusBarBackgroundVisible` should be enabled to use this property.
    ///   - Make sense only together with `leftViewStatusBarBackgroundShadowColor`
    @IBInspectable
    open var leftViewStatusBarBackgroundShadowRadius: CGFloat = 0.0

    /// Shadow radius for the background view of the status bar, which is visible when the right side view is showing.
    /// - Note:
    ///   - `isRightViewStatusBarBackgroundVisible` should be enabled to use this property.
    ///   - Make sense only together with `rightViewStatusBarBackgroundShadowColor`
    @IBInspectable
    open var rightViewStatusBarBackgroundShadowRadius: CGFloat = 0.0

    // MARK: - Alpha -

    /// Use this property to set `alpha` for the root view when it is hidden.
    /// - Note:
    ///   - Animated between show/hide states.
    ///   - Make sense to use if you want to hide the content of the root view or lower the attention.
    open var rootViewAlphaWhenHidden: CGFloat?

    /// Use this property to set `alpha` for the root view when it is hidden,
    /// which is applied only when the left side view is showing.
    /// - Returns: Default:
    ///   - `rootViewAlphaWhenHidden` if assigned
    ///   - `1.0` otherwise
    /// - Note:
    ///   - Animated between show/hide states.
    ///   - Make sense to use if you want to hide the content of the root view or lower the attention.
    @IBInspectable
    open var rootViewAlphaWhenHiddenForLeftView: CGFloat {
        set {
            _rootViewAlphaWhenHiddenForLeftView = newValue
        }
        get {
            if let rootViewAlphaWhenHiddenForLeftView = _rootViewAlphaWhenHiddenForLeftView {
                return rootViewAlphaWhenHiddenForLeftView
            }
            if let rootViewAlphaWhenHiddenForLeftView = rootViewAlphaWhenHidden {
                return rootViewAlphaWhenHiddenForLeftView
            }
            return 1.0
        }
    }
    private var _rootViewAlphaWhenHiddenForLeftView: CGFloat?

    /// Use this property to set `alpha` for the root view when it is hidden,
    /// which is applied only when the right side view is showing.
    /// - Returns: Default:
    ///   - `rootViewAlphaWhenHidden` if assigned
    ///   - `1.0` otherwise
    /// - Note:
    ///   - Animated between show/hide states.
    ///   - Make sense to use if you want to hide the content of the root view or lower the attention.
    @IBInspectable
    open var rootViewAlphaWhenHiddenForRightView: CGFloat {
        set {
            _rootViewAlphaWhenHiddenForRightView = newValue
        }
        get {
            if let rootViewAlphaWhenHiddenForRightView = _rootViewAlphaWhenHiddenForRightView {
                return rootViewAlphaWhenHiddenForRightView
            }
            if let rootViewAlphaWhenHiddenForRightView = rootViewAlphaWhenHidden {
                return rootViewAlphaWhenHiddenForRightView
            }
            return 1.0
        }
    }
    private var _rootViewAlphaWhenHiddenForRightView: CGFloat?

    /// Use this property to set `alpha` for the left side view when it is hidden.
    /// - Returns: Default:
    ///   - `0.0` if `presentationStyle == .scaleFromBig`
    ///   - `0.0` if `presentationStyle == .scaleFromLittle`
    ///   - `1.0` otherwise
    /// - Note:
    ///   - Animated between show/hide states.
    @IBInspectable
    open var leftViewAlphaWhenHidden: CGFloat {
        set {
            _leftViewAlphaWhenHidden = newValue
        }
        get {
            if let leftViewAlphaWhenHidden = _leftViewAlphaWhenHidden {
                return leftViewAlphaWhenHidden
            }
            if leftViewPresentationStyle == .scaleFromBig ||
                leftViewPresentationStyle == .scaleFromLittle {
                return 0.0
            }
            return 1.0
        }
    }
    private var _leftViewAlphaWhenHidden: CGFloat?

    /// Use this property to set `alpha` for the right side view when it is hidden.
    /// - Returns: Default:
    ///   - `0.0` if `presentationStyle == .scaleFromBig`
    ///   - `0.0` if `presentationStyle == .scaleFromLittle`
    ///   - `1.0` otherwise
    /// - Note:
    ///   - Animated between show/hide states.
    @IBInspectable
    open var rightViewAlphaWhenHidden: CGFloat {
        set {
            _rightViewAlphaWhenHidden = newValue
        }
        get {
            if let rightViewAlphaWhenHidden = _rightViewAlphaWhenHidden {
                return rightViewAlphaWhenHidden
            }
            if rightViewPresentationStyle == .scaleFromBig ||
                rightViewPresentationStyle == .scaleFromLittle {
                return 0.0
            }
            return 1.0
        }
    }
    private var _rightViewAlphaWhenHidden: CGFloat?

    // MARK: - Offset -

    /// Use this property to set extra offset for the root view when it is hidden.
    open var rootViewOffsetWhenHidden: CGPoint?

    /// Use this property to set extra offset for the root view when it is hidden,
    /// which is applied only when the left side view is showing.
    /// - Returns: Default:
    ///   - `rootViewOffsetWhenHidden` if assigned
    ///   - `.zero` otherwise
    @IBInspectable
    open var rootViewOffsetWhenHiddenForLeftView: CGPoint {
        set {
            _rootViewOffsetWhenHiddenForLeftView = newValue
        }
        get {
            if let rootViewOffsetWhenHiddenForLeftView = _rootViewOffsetWhenHiddenForLeftView {
                return rootViewOffsetWhenHiddenForLeftView
            }
            if let rootViewOffsetWhenHiddenForLeftView = rootViewOffsetWhenHidden {
                return rootViewOffsetWhenHiddenForLeftView
            }
            return .zero
        }
    }
    private var _rootViewOffsetWhenHiddenForLeftView: CGPoint?

    /// Use this property to set extra offset for the root view when it is hidden,
    /// which is applied only when the right side view is showing.
    /// - Returns: Default:
    ///   - `rootViewOffsetWhenHidden` if assigned
    ///   - `.zero` otherwise
    @IBInspectable
    open var rootViewOffsetWhenHiddenForRightView: CGPoint {
        set {
            _rootViewOffsetWhenHiddenForRightView = newValue
        }
        get {
            if let rootViewOffsetWhenHiddenForRightView = _rootViewOffsetWhenHiddenForRightView {
                return rootViewOffsetWhenHiddenForRightView
            }
            if let rootViewOffsetWhenHiddenForRightView = rootViewOffsetWhenHidden {
                return rootViewOffsetWhenHiddenForRightView
            }
            return .zero
        }
    }
    private var _rootViewOffsetWhenHiddenForRightView: CGPoint?

    /// Use this property to set extra offset for the left side view when it is hidden.
    /// - Returns: Default:
    ///   - `CGPoint(x: -(leftViewWidth / 2.0), y: 0.0)` if `presentationStyle == .slideBelowShifted`
    ///   - `.zero` otherwise
    @IBInspectable
    open var leftViewOffsetWhenHidden: CGPoint {
        set {
            _leftViewOffsetWhenHidden = newValue
        }
        get {
            if let leftViewOffsetWhenHidden = _leftViewOffsetWhenHidden {
                return leftViewOffsetWhenHidden
            }
            if leftViewPresentationStyle == .slideBelowShifted {
                return CGPoint(x: -(leftViewWidth / 2.0), y: 0.0)
            }
            return .zero
        }
    }
    private var _leftViewOffsetWhenHidden: CGPoint?

    /// Use this property to set extra offset for the right side view when it is hidden.
    /// - Returns: Default:
    ///   - `CGPoint(x: rightViewWidth / 2.0, y: 0.0)` if `presentationStyle == .slideBelowShifted`
    ///   - `.zero` otherwise
    @IBInspectable
    open var rightViewOffsetWhenHidden: CGPoint {
        set {
            _rightViewOffsetWhenHidden = newValue
        }
        get {
            if let rightViewOffsetWhenHidden = _rightViewOffsetWhenHidden {
                return rightViewOffsetWhenHidden
            }
            if rightViewPresentationStyle == .slideBelowShifted {
                return CGPoint(x: rightViewWidth / 2.0, y: 0.0)
            }
            return .zero
        }
    }
    private var _rightViewOffsetWhenHidden: CGPoint?

    /// Use this property to set extra offset for the left side view when it is showing.
    @IBInspectable
    open var leftViewOffsetWhenShowing: CGPoint = .zero

    /// Use this property to set extra offset for the right side view when it is showing.
    @IBInspectable
    open var rightViewOffsetWhenShowing: CGPoint = .zero

    // MARK: - Scale -

    /// Use this property to set scale for the root view when it is hidden.
    open var rootViewScaleWhenHidden: CGFloat?

    /// Use this property to set scale for the root view when it is hidden,
    /// which is applied only when the left side view is showing.
    /// - Returns: Default:
    ///   - `rootViewScaleWhenHidden` if assigned
    ///   - `0.8` if `presentationStyle.shouldRootViewScale`
    ///   - `1.0` otherwise
    @IBInspectable
    open var rootViewScaleWhenHiddenForLeftView: CGFloat {
        set {
            _rootViewScaleWhenHiddenForLeftView = newValue
        }
        get {
            if let rootViewScaleWhenHiddenForLeftView = _rootViewScaleWhenHiddenForLeftView {
                return rootViewScaleWhenHiddenForLeftView
            }
            if let rootViewScaleWhenHiddenForLeftView = rootViewScaleWhenHidden {
                return rootViewScaleWhenHiddenForLeftView
            }
            if leftViewPresentationStyle.shouldRootViewScale {
                return 0.8
            }
            return 1.0
        }
    }
    private var _rootViewScaleWhenHiddenForLeftView: CGFloat?

    /// Use this property to set scale for the root view when it is hidden,
    /// which is applied only when the right side view is showing.
    /// - Returns: Default:
    ///   - `rootViewScaleWhenHidden` if assigned
    ///   - `0.8` if `presentationStyle.shouldRootViewScale`
    ///   - `1.0` otherwise
    @IBInspectable
    open var rootViewScaleWhenHiddenForRightView: CGFloat {
        set {
            _rootViewScaleWhenHiddenForRightView = newValue
        }
        get {
            if let rootViewScaleWhenHiddenForRightView = _rootViewScaleWhenHiddenForRightView {
                return rootViewScaleWhenHiddenForRightView
            }
            if let rootViewScaleWhenHiddenForRightView = rootViewScaleWhenHidden {
                return rootViewScaleWhenHiddenForRightView
            }
            if rightViewPresentationStyle.shouldRootViewScale {
                return 0.8
            }
            return 1.0
        }
    }
    private var _rootViewScaleWhenHiddenForRightView: CGFloat?

    /// Use this property to set scale for the left side view when it is hidden.
    /// - Returns: Default:
    ///   - `1.2` if `presentationStyle == .scaleFromBig`
    ///   - `0.8` if `presentationStyle == .scaleFromLittle`
    ///   - `1.0` otherwise
    @IBInspectable
    open var leftViewScaleWhenHidden: CGFloat {
        set {
            _leftViewScaleWhenHidden = newValue
        }
        get {
            if let leftViewScaleWhenHidden = _leftViewScaleWhenHidden {
                return leftViewScaleWhenHidden
            }
            if leftViewPresentationStyle == .scaleFromBig {
                return 1.2
            }
            if leftViewPresentationStyle == .scaleFromLittle {
                return 0.8
            }
            return 1.0
        }
    }
    private var _leftViewScaleWhenHidden: CGFloat?

    /// Use this property to set scale for the right side view when it is hidden.
    /// - Returns: Default:
    ///   - `1.2` if `presentationStyle == .scaleFromBig`
    ///   - `0.8` if `presentationStyle == .scaleFromLittle`
    ///   - `1.0` otherwise
    @IBInspectable
    open var rightViewScaleWhenHidden: CGFloat {
        set {
            _rightViewScaleWhenHidden = newValue
        }
        get {
            if let rightViewScaleWhenHidden = _rightViewScaleWhenHidden {
                return rightViewScaleWhenHidden
            }
            if rightViewPresentationStyle == .scaleFromBig {
                return 1.2
            }
            if rightViewPresentationStyle == .scaleFromLittle {
                return 0.8
            }
            return 1.0
        }
    }
    private var _rightViewScaleWhenHidden: CGFloat?

    // MARK: - Background Image Scale -

    /// Use this property to set scale for background view, located behind the left side view, when it is hidden.
    /// - Returns: Default:
    ///   - `1.4` if `presentationStyle == .scaleFromBig`
    ///   - `1.0` otherwise
    @IBInspectable
    open var leftViewBackgroundScaleWhenHidden: CGFloat {
        set {
            _leftViewBackgroundScaleWhenHidden = newValue
        }
        get {
            if let leftViewBackgroundScaleWhenHidden = _leftViewBackgroundScaleWhenHidden {
                return leftViewBackgroundScaleWhenHidden
            }
            if leftViewPresentationStyle == .scaleFromBig {
                return 1.4
            }
            return 1.0
        }
    }
    private var _leftViewBackgroundScaleWhenHidden: CGFloat?

    /// Use this property to set scale for background view, located behind the right side view, when it is hidden.
    /// - Returns: Default:
    ///   - `1.4` if `presentationStyle == .scaleFromBig`
    ///   - `1.0` otherwise
    @IBInspectable
    open var rightViewBackgroundScaleWhenHidden: CGFloat {
        set {
            _rightViewBackgroundScaleWhenHidden = newValue
        }
        get {
            if let rightViewBackgroundScaleWhenHidden = _rightViewBackgroundScaleWhenHidden {
                return rightViewBackgroundScaleWhenHidden
            }
            if rightViewPresentationStyle == .scaleFromBig {
                return 1.4
            }
            return 1.0
        }
    }
    private var _rightViewBackgroundScaleWhenHidden: CGFloat?

    /// Use this property to set scale for background view, located behind the left side view, when it is showing.
    /// - Returns: Default:
    ///   - `1.4` if `presentationStyle == .scaleFromLittle`
    ///   - `1.0` otherwise
    @IBInspectable
    open var leftViewBackgroundScaleWhenShowing: CGFloat {
        set {
            _leftViewBackgroundScaleWhenShowing = newValue
        }
        get {
            if let leftViewBackgroundScaleWhenShowing = _leftViewBackgroundScaleWhenShowing {
                return leftViewBackgroundScaleWhenShowing
            }
            if leftViewPresentationStyle == .scaleFromLittle {
                return 1.4
            }
            return 1.0
        }
    }
    private var _leftViewBackgroundScaleWhenShowing: CGFloat?

    /// Use this property to set scale for background view, located behind the right side view, when it is showing.
    /// - Returns: Default:
    ///   - `1.4` if `presentationStyle == .scaleFromLittle`
    ///   - `1.0` otherwise
    @IBInspectable
    open var rightViewBackgroundScaleWhenShowing: CGFloat {
        set {
            _rightViewBackgroundScaleWhenShowing = newValue
        }
        get {
            if let rightViewBackgroundScaleWhenShowing = _rightViewBackgroundScaleWhenShowing {
                return rightViewBackgroundScaleWhenShowing
            }
            if rightViewPresentationStyle == .scaleFromLittle {
                return 1.4
            }
            return 1.0
        }
    }
    private var _rightViewBackgroundScaleWhenShowing: CGFloat?

    // MARK: - Background Image Offset -

    /// Use this property to set offset for background view, located behind the left side view, when it is hidden.
    /// - Returns: Default:
    ///   - `CGPoint(x: -(leftViewWidth / 2.0), y: 0.0)` if `presentationStyle == .slideBelowShifted`
    ///   - `.zero` otherwise
    @IBInspectable
    open var leftViewBackgroundOffsetWhenHidden: CGPoint {
        set {
            _leftViewBackgroundOffsetWhenHidden = newValue
        }
        get {
            if let leftViewBackgroundOffsetWhenHidden = _leftViewBackgroundOffsetWhenHidden {
                return leftViewBackgroundOffsetWhenHidden
            }
            if leftViewPresentationStyle == .slideBelowShifted {
                return CGPoint(x: -(leftViewWidth / 2.0), y: 0.0)
            }
            return .zero
        }
    }
    private var _leftViewBackgroundOffsetWhenHidden: CGPoint?

    /// Use this property to set offset for background view, located behind the right side view, when it is hidden.
    /// - Returns: Default:
    ///   - `CGPoint(x: rightViewWidth / 2.0, y: 0.0)` if `presentationStyle == .slideBelowShifted`
    ///   - `.zero` otherwise
    @IBInspectable
    open var rightViewBackgroundOffsetWhenHidden: CGPoint {
        set {
            _rightViewBackgroundOffsetWhenHidden = newValue
        }
        get {
            if let rightViewBackgroundOffsetWhenHidden = _rightViewBackgroundOffsetWhenHidden {
                return rightViewBackgroundOffsetWhenHidden
            }
            if rightViewPresentationStyle == .slideBelowShifted {
                return CGPoint(x: rightViewWidth / 2.0, y: 0.0)
            }
            return .zero
        }
    }
    private var _rightViewBackgroundOffsetWhenHidden: CGPoint?

    /// Use this property to set offset for background view, located behind the left side view, when it is showing.
    @IBInspectable
    open var leftViewBackgroundOffsetWhenShowing: CGPoint = .zero

    /// Use this property to set offset for background view, located behind the right side view, when it is showing.
    @IBInspectable
    open var rightViewBackgroundOffsetWhenShowing: CGPoint = .zero

    // MARK: - Callbacks -

    open var willShowLeftView: Callback?
    open var didShowLeftView: Callback?

    open var willHideLeftView: Callback?
    open var didHideLeftView: Callback?

    open var willShowRightView: Callback?
    open var didShowRightView: Callback?

    open var willHideRightView: Callback?
    open var didHideRightView: Callback?

    /// This callback is executed inside animation block for showing left view.
    /// You can use it to add some custom animations.
    open var showAnimationsForLeftView: AnimationsCallback?

    /// This callback is executed inside animation block for hiding left view.
    /// You can use it to add some custom animations
    open var hideAnimationsForLeftView: AnimationsCallback?

    /// This callback is executed inside animation block for showing right view.
    /// You can use this notification to add some custom animations
    open var showAnimationsForRightView: AnimationsCallback?

    /// This callback is executed inside animation block for hiding right view.
    /// You can use this notification to add some custom animations
    open var hideAnimationsForRightView: AnimationsCallback?

    /// This callback is executed on every transformation of root view during showing/hiding of side views
    /// You can retrieve percentage between `0.0` and `1.0` from userInfo dictionary, where
    ///   - `0.0` - view is fully shown
    ///   - `1.0` - view is fully hidden
    open var didTransformRootView: TransformCallback?

    /// This callback is executed on every transformation of left view during showing/hiding
    /// You can retrieve percentage between `0.0` and `1.0` from userInfo dictionary, where
    ///   - `0.0` - view is fully hidden
    ///   - `1.0` - view is fully shown
    open var didTransformLeftView: TransformCallback?

    /// This callback is executed on every transformation of right view during showing/hiding
    /// You can retrieve percentage between `0.0` and `1.0` from userInfo dictionary, where
    ///   - `0.0` - view is fully hidden
    ///   - `1.0` - view is fully shown
    open var didTransformRightView: TransformCallback?

    // MARK: - Delegate -

    /// Delegate object to observe behaviour of LGSideMenuController
    open var delegate: LGSideMenuDelegate?

    // MARK: - Internal Properties -

    /// Keeps current state. Describes which view is showing/hidden or is going to be shown/hidden.
    /// For internal purposes. Usually shouldn't be accessed by user.
    open internal(set) var state: State = .rootViewIsShowing

    /// Tells if any animations are currently in process.
    /// For internal purposes. Usually shouldn't be accessed by user.
    open internal(set) var isAnimating = false

    /// Tells if layouts and styles should be updated.
    /// For internal purposes. Usually shouldn't be accessed by user.
    open internal(set) var isNeedsUpdateLayoutsAndStyles: Bool = false

    /// Tells if root view layouts and styles should be updated.
    /// For internal purposes. Usually shouldn't be accessed by user.
    open internal(set) var isNeedsUpdateRootViewLayoutsAndStyles: Bool = false

    /// Tells if left view layouts and styles should be updated.
    /// For internal purposes. Usually shouldn't be accessed by user.
    open internal(set) var isNeedsUpdateLeftViewLayoutsAndStyles: Bool = false

    /// Tells if right view layouts and styles should be updated.
    /// For internal purposes. Usually shouldn't be accessed by user.
    open internal(set) var isNeedsUpdateRightViewLayoutsAndStyles: Bool = false

    internal var savedSize: CGSize = .zero

    internal var leftViewGestureStartX: CGFloat?
    internal var rightViewGestureStartX: CGFloat?

    internal var isLeftViewShowingBeforeGesture: Bool = false
    internal var isRightViewShowingBeforeGesture: Bool = false

    internal var shouldUpdateVisibility: Bool = true

    internal var isRotationInvalidatedLayout: Bool = false

    internal var isRootViewLayoutingEnabled: Bool = true
    internal var isRootViewControllerLayoutingEnabled: Bool = true

    // MARK: - Internal Root Views -

    /// View that contains all root-related views.
    /// This view does not clip to bounds.
    /// Usually shouldn't be accessed by user.
    open internal(set) var rootContainerView: UIView?

    /// View that contains all root-related views except background views.
    /// This view located right inside border and clips to bounds.
    /// Usually shouldn't be accessed by user.
    open internal(set) var rootContainerClipToBorderView: UIView?

    /// View that responcible for shadow, border and background of the root view.
    /// Usually shouldn't be accessed by user.
    open internal(set) var rootViewBackgroundDecorationView: LGSideMenuBackgroundDecorationView?

    /// View that responcible for shadow of the root view. Located inside `rootViewBackgroundDecorationView`.
    /// Usually shouldn't be accessed by user.
    open internal(set) var rootViewBackgroundShadowView: LGSideMenuBackgroundShadowView?

    /// View that wraps user-provided root view.
    /// Usually shouldn't be accessed by user.
    /// Might be useful to make animated transition to a new root view.
    open internal(set) var rootViewWrapperView: LGSideMenuWrapperView?

    /// View that located on top of all root-related views to hide their content if necessary.
    /// Usually shouldn't be accessed by user.
    open internal(set) var rootViewCoverView: UIVisualEffectView?

    // MARK: - Internal Left Views -

    /// View that contains all left-related views.
    /// This view clips to bounds.
    /// Usually shouldn't be accessed by user.
    open internal(set) var leftContainerView: UIView?

    /// View that contains all left-related views except background views.
    /// This view located right inside border and clips to bounds.
    /// Usually shouldn't be accessed by user.
    open internal(set) var leftContainerClipToBorderView: UIView?

    /// View that responcible for shadow, border and background of the left view.
    /// Usually shouldn't be accessed by user.
    open internal(set) var leftViewBackgroundDecorationView: LGSideMenuBackgroundDecorationView?

    /// View that responcible for shadow of the left view. Located inside `leftViewBackgroundDecorationView`.
    /// Usually shouldn't be accessed by user.
    open internal(set) var leftViewBackgroundShadowView: LGSideMenuBackgroundShadowView?

    /// View that wraps user-provided background view for left view.
    /// Usually shouldn't be accessed by user.
    open internal(set) var leftViewBackgroundWrapperView: UIView?

    /// View that shows user-provided background image for left view.
    /// Usually shouldn't be accessed by user.
    open internal(set) var leftViewBackgroundImageView: UIImageView?

    /// View that shows background visual effect for left view.
    /// Usually shouldn't be accessed by user.
    open internal(set) var leftViewBackgroundEffectView: UIVisualEffectView?

    /// View that wraps user-provided left view.
    /// Usually shouldn't be accessed by user.
    open internal(set) var leftViewWrapperView: LGSideMenuWrapperView?

    /// View that located on top of all left-related views to hide their content if necessary.
    /// Usually shouldn't be accessed by user.
    open internal(set) var leftViewCoverView: UIVisualEffectView?

    /// View that located right below status bar to avoid interference of user's content with status bar.
    /// Responcible for shadow, border and background of the status bar.
    /// Usually shouldn't be accessed by user.
    open internal(set) var leftViewStatusBarBackgroundView: LGSideMenuStatusBarBackgroundView?

    /// View that adds visual effect to status bar background.
    /// Usually shouldn't be accessed by user.
    open internal(set) var leftViewStatusBarBackgroundEffectView: UIVisualEffectView?

    // MARK: - Internal Right Views -

    /// View that contains all right-related views.
    /// This view clips to bounds.
    /// Usually shouldn't be accessed by user.
    open internal(set) var rightContainerView: UIView?

    /// View that contains all right-related views except background views.
    /// This view located right inside border and clips to bounds.
    /// Usually shouldn't be accessed by user.
    open internal(set) var rightContainerClipToBorderView: UIView?

    /// View that responcible for shadow, border and background of the right view.
    /// Usually shouldn't be accessed by user.
    open internal(set) var rightViewBackgroundDecorationView: LGSideMenuBackgroundDecorationView?

    /// View that responcible for shadow of the right view. Located inside `rightViewBackgroundDecorationView`.
    /// Usually shouldn't be accessed by user.
    open internal(set) var rightViewBackgroundShadowView: LGSideMenuBackgroundShadowView?

    /// View that wraps user-provided background view for right view.
    /// Usually shouldn't be accessed by user.
    open internal(set) var rightViewBackgroundWrapperView: UIView?

    /// View that shows user-provided background image for right view.
    /// Usually shouldn't be accessed by user.
    open internal(set) var rightViewBackgroundImageView: UIImageView?

    /// View that shows background visual effect for right view.
    /// Usually shouldn't be accessed by user.
    open internal(set) var rightViewBackgroundEffectView: UIVisualEffectView?

    /// View that wraps user-provided right view.
    /// Usually shouldn't be accessed by user.
    open internal(set) var rightViewWrapperView: LGSideMenuWrapperView?

    /// View that located on top of all right-related views to hide their content if necessary.
    /// Usually shouldn't be accessed by user.
    open internal(set) var rightViewCoverView: UIVisualEffectView?

    /// View that located right below status bar to avoid interference of user's content with status bar.
    /// Responcible for shadow, border and background of the status bar.
    /// Usually shouldn't be accessed by user.
    open internal(set) var rightViewStatusBarBackgroundView: LGSideMenuStatusBarBackgroundView?

    /// View that adds visual effect to status bar background.
    /// Usually shouldn't be accessed by user.
    open internal(set) var rightViewStatusBarBackgroundEffectView: UIVisualEffectView?

    // MARK: - Initialization -

    public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        self.tapGesture = UITapGestureRecognizer()
        self.panGestureForLeftView = UIPanGestureRecognizer()
        self.panGestureForRightView = UIPanGestureRecognizer()

        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    required public init?(coder: NSCoder) {
        self.tapGesture = UITapGestureRecognizer()
        self.panGestureForLeftView = UIPanGestureRecognizer()
        self.panGestureForRightView = UIPanGestureRecognizer()

        super.init(coder: coder)
    }

    convenience public init() {
        self.init(nibName: nil, bundle: nil)
    }

    convenience public init(rootViewController: UIViewController? = nil, leftViewController: UIViewController? = nil, rightViewController: UIViewController? = nil) {
        self.init()

        // We need to use `defer` here to trigger `willSet` and `didSet` callbacks
        defer {
            self.rootViewController = rootViewController
            self.leftViewController = leftViewController
            self.rightViewController = rightViewController
        }
    }

    convenience public init(rootView: UIView? = nil, leftView: UIView? = nil, rightView: UIView? = nil) {
        self.init()

        // We need to use `defer` here to trigger `willSet` and `didSet` callbacks
        defer {
            self.rootView = rootView
            self.leftView = leftView
            self.rightView = rightView
        }
    }

    open override func viewDidLoad() {
        super.viewDidLoad()

        self.tapGesture.addTarget(self, action: #selector(handleTapGesture))
        self.tapGesture.delegate = self
        self.tapGesture.numberOfTapsRequired = 1
        self.tapGesture.numberOfTouchesRequired = 1
        self.view.addGestureRecognizer(self.tapGesture)

        self.panGestureForLeftView.addTarget(self, action: #selector(handlePanGestureForLeftView))
        self.panGestureForLeftView.delegate = self
        self.panGestureForLeftView.minimumNumberOfTouches = 1
        self.panGestureForLeftView.maximumNumberOfTouches = 1
        self.view.addGestureRecognizer(self.panGestureForLeftView)

        self.panGestureForRightView.addTarget(self, action: #selector(handlePanGestureForRightView))
        self.panGestureForRightView.delegate = self
        self.panGestureForRightView.minimumNumberOfTouches = 1
        self.panGestureForRightView.maximumNumberOfTouches = 1
        self.view.addGestureRecognizer(self.panGestureForRightView)

        // Try to initialize root, left and right view controllers from storyboard by segues
        if self.storyboard != nil {
            self.tryPerformRootSegueIfNeeded()
            self.tryPerformLeftSegueIfNeeded()
            self.tryPerformRightSegueIfNeeded()
        }
    }

    // MARK: - Segues -

    /// Is trying to initialize root view controller by performing segue if possible.
    /// Normally shouldn't be executed by user.
    open func tryPerformRootSegueIfNeeded() {
        guard self.storyboard != nil,
              _rootViewController == nil,
              LGSideMenuHelper.canPerformSegue(self, withIdentifier: LGSideMenuSegue.Identifier.root) else { return }
        self.performSegue(withIdentifier: LGSideMenuSegue.Identifier.root, sender: self)
    }

    /// Is trying to initialize left view controller by performing segue if possible.
    /// Normally shouldn't be executed by user.
    open func tryPerformLeftSegueIfNeeded() {
        guard self.storyboard != nil,
              _leftViewController == nil,
              LGSideMenuHelper.canPerformSegue(self, withIdentifier: LGSideMenuSegue.Identifier.left) else { return }
        self.performSegue(withIdentifier: LGSideMenuSegue.Identifier.left, sender: self)
    }

    /// Is trying to initialize right view controller by performing segue if possible.
    /// Normally shouldn't be executed by user.
    open func tryPerformRightSegueIfNeeded() {
        guard self.storyboard != nil,
              _rightViewController == nil,
              LGSideMenuHelper.canPerformSegue(self, withIdentifier: LGSideMenuSegue.Identifier.right) else { return }
        self.performSegue(withIdentifier: LGSideMenuSegue.Identifier.right, sender: self)
    }

    // MARK: - Layouting -

    /// Called when root view is layouting subviews.
    /// Use this to update root view related layout if necessary.
    open func rootViewLayoutSubviews() {
        // only for overriding
    }

    /// Called when left view is layouting subviews.
    /// Use this to update left view related layout if necessary.
    open func leftViewLayoutSubviews() {
        // only for overriding
    }

    /// Called when right view is layouting subviews.
    /// Use this to update right view related layout if necessary.
    open func rightViewLayoutSubviews() {
        // only for overriding
    }

    // MARK: - deinit -

    deinit {
        if let rootViewController = rootViewController {
            LGSideMenuHelper.setSideMenuController(nil, to: rootViewController)
        }
        if let leftViewController = leftViewController {
            LGSideMenuHelper.setSideMenuController(nil, to: leftViewController)
        }
        if let rightViewController = rightViewController {
            LGSideMenuHelper.setSideMenuController(nil, to: rightViewController)
        }
    }

}
