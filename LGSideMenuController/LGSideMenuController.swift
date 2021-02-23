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
import UIKit

open class LGSideMenuController: UIViewController, UIGestureRecognizerDelegate {

    public typealias Completion = () -> Void
    public typealias Callback = (LGSideMenuController) -> Void
    public typealias AnimationsCallback = (LGSideMenuController, TimeInterval) -> Void

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

        /// You can use this notification to add some custom animations
        public static let showAnimationsForLeftView = NSNotification.Name("LGSideMenuController.Notification.showAnimationsForLeftView")
        /// You can use this notification to add some custom animations
        public static let hideAnimationsForLeftView = NSNotification.Name("LGSideMenuController.Notification.hideAnimationsForLeftView")

        /// You can use this notification to add some custom animations
        public static let showAnimationsForRightView = NSNotification.Name("LGSideMenuController.Notification.showAnimationsForRightView")
        /// You can use this notification to add some custom animations
        public static let hideAnimationsForRightView = NSNotification.Name("LGSideMenuController.Notification.hideAnimationsForRightView")

        public struct Key {
            /// Key for userInfo dictionary which represents duration of the animation
            static let duration = "duration"
        }

    }

    public struct AlwaysVisibleOptions: OptionSet {
        public let rawValue: Int

        public static let padLandscape   = AlwaysVisibleOptions(rawValue: 1 << 0)
        public static let padPortrait    = AlwaysVisibleOptions(rawValue: 1 << 1)
        public static let phoneLandscape = AlwaysVisibleOptions(rawValue: 1 << 2)
        public static let phonePortrait  = AlwaysVisibleOptions(rawValue: 1 << 3)

        public static let landscape: AlwaysVisibleOptions = [.padLandscape, .phoneLandscape]
        public static let portrait: AlwaysVisibleOptions  = [.padPortrait, .phonePortrait]
        public static let pad: AlwaysVisibleOptions       = [.padLandscape, .padPortrait]
        public static let phone: AlwaysVisibleOptions     = [.phoneLandscape, .phonePortrait]
        public static let all: AlwaysVisibleOptions       = [.padLandscape, .padPortrait, .phoneLandscape, .phonePortrait]

        // TODO: Add options for different trait collections

        public init(rawValue: Int = 0) {
            self.rawValue = rawValue
        }

        public var isEmpty: Bool {
            return self == []
        }

        public var isAlwaysVisibleForCurrentOrientation: Bool {
            return isAlwaysVisibleForOrientation(UIApplication.shared.statusBarOrientation)
        }

        public func isAlwaysVisibleForOrientation(_ orientation: UIInterfaceOrientation) -> Bool {
            return contains(.all) ||
                (orientation.isPortrait && contains(.portrait)) ||
                (orientation.isLandscape && contains(.landscape)) ||
                (LGSideMenuHelper.isPhone() &&
                    (contains(.phone) ||
                        (orientation.isPortrait && contains(.phonePortrait)) ||
                        (orientation.isLandscape && contains(.phoneLandscape)))) ||
                (LGSideMenuHelper.isPad() &&
                    (contains(.pad) ||
                        (orientation.isPortrait && contains(.padPortrait)) ||
                        (orientation.isLandscape && contains(.padLandscape))))
        }
    }

    public enum PresentationStyle {
        case slideAbove
        case slideBelow
        case slideAside
        case scaleFromBig
        case scaleFromLittle

        public init() {
            self = .slideAbove
        }

        public var isAbove: Bool {
            return self == .slideAbove
        }

        public var isBelow: Bool {
            return self == .slideBelow || self == .scaleFromBig || self == .scaleFromLittle
        }

        public var isHiddenAside: Bool {
            return self == .slideAbove || self == .slideAside
        }

        public var isWidthFull: Bool {
            return self == .slideBelow || self == .scaleFromBig || self == .scaleFromLittle
        }

        public var isWidthCompact: Bool {
            return self == .slideAbove || self == .slideAside
        }

        public var shouldRootViewMove: Bool {
            return self == .slideBelow || self == .slideAside || self == .scaleFromBig || self == .scaleFromLittle
        }

        public var shouldRootViewScale: Bool {
            return self == .scaleFromBig || self == .scaleFromLittle
        }
    }

    public enum SwipeGestureArea {
        case borders
        case full

        public init() {
            self = .borders
        }
    }

    public struct SwipeGestureRange {
        public let left: CGFloat
        public let right: CGFloat

        public init(left: CGFloat = 44.0, right: CGFloat = 44.0) {
            self.left = left
            self.right = right
        }
    }

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

    // MARK: - Public Basic Properties

    open var rootViewController: UIViewController? {
        willSet {
            removeRootViewController()
        }
        didSet {
            guard let rootViewController = rootViewController else {
                if self.rootView != nil {
                    self.rootView = nil
                }
                return
            }
            self.rootView = rootViewController.view
            LGSideMenuHelper.setSideMenuController(self, to: rootViewController)
            if isRootViewControllerLayoutingEnabled {
                addChild(rootViewController)
            }
        }
    }

    open var leftViewController: UIViewController? {
        willSet {
            removeLeftViewController()
        }
        didSet {
            guard let leftViewController = leftViewController else {
                if self.leftView != nil {
                    self.leftView = nil
                }
                return
            }
            self.leftView = leftViewController.view
            LGSideMenuHelper.setSideMenuController(self, to: leftViewController)
            addChild(leftViewController)
        }
    }

    open var rightViewController: UIViewController? {
        willSet {
            removeRightViewController()
        }
        didSet {
            guard let rightViewController = rightViewController else {
                if self.rightView != nil {
                    self.rightView = nil
                }
                return
            }
            self.rightView = rightViewController.view
            LGSideMenuHelper.setSideMenuController(self, to: rightViewController)
            addChild(rightViewController)
        }
    }

    open var rootView: UIView? {
        willSet {
            removeRootView()
            if newValue == nil {
                removeRootDependentViews()
            }
        }
        didSet {
            guard rootView != nil else {
                if self.rootViewController != nil {
                    self.rootViewController = nil
                }
                return
            }
            setNeedsUpdateRootViewLayoutsAndStyles()
        }
    }

    open var leftView: UIView? {
        willSet {
            removeLeftView()
            if newValue == nil {
                removeLeftDependentViews()
            }
        }
        didSet {
            guard leftView != nil else {
                if self.leftViewController != nil {
                    self.leftViewController = nil
                }
                return
            }
            setNeedsUpdateLeftViewLayoutsAndStyles()
        }
    }

    open var rightView: UIView? {
        willSet {
            removeRightView()
            if newValue == nil {
                removeRightDependentViews()
            }
        }
        didSet {
            guard rightView != nil else {
                if self.rightViewController != nil {
                    self.rightViewController = nil
                }
                return
            }
            setNeedsUpdateRightViewLayoutsAndStyles()
        }
    }

    public let tapGesture: UITapGestureRecognizer
    public let panGestureForLeftView: UIPanGestureRecognizer
    public let panGestureForRightView: UIPanGestureRecognizer

    // MARK: - Public Non-Conditional Configurable Properties

    /// Default is min(MainScreenSize.minSide - 44.0, 320.0)
    @IBInspectable open var leftViewWidth: CGFloat = {
        let minScreenSide = min(UIScreen.main.bounds.width, UIScreen.main.bounds.height)
        return min(minScreenSide - 44.0, 320.0)
    }() {
        didSet {
            setNeedsUpdateLayoutsAndStyles()
        }
    }

    /// Default is min(MainScreenSize.minSide - 44.0, 320.0)
    @IBInspectable open var rightViewWidth: CGFloat = {
        let minScreenSide = min(UIScreen.main.bounds.width, UIScreen.main.bounds.height)
        return min(minScreenSide - 44.0, 320.0)
    }() {
        didSet {
            setNeedsUpdateLayoutsAndStyles()
        }
    }

    open var leftViewPresentationStyle: PresentationStyle = .slideAbove {
        didSet {
            setNeedsUpdateLayoutsAndStyles()
        }
    }

    open var rightViewPresentationStyle: PresentationStyle = .slideAbove {
        didSet {
            setNeedsUpdateLayoutsAndStyles()
        }
    }

    open var leftViewAlwaysVisibleOptions: AlwaysVisibleOptions = [] {
        didSet {
            setNeedsUpdateLayoutsAndStyles()
        }
    }

    open var rightViewAlwaysVisibleOptions: AlwaysVisibleOptions = [] {
        didSet {
            setNeedsUpdateLayoutsAndStyles()
        }
    }

    @IBInspectable open var shouldLeftViewHideOnTouch: Bool = true
    @IBInspectable open var shouldRightViewHideOnTouch: Bool = true

    @IBInspectable open var shouldLeftViewHideOnTouchAnimated: Bool = true
    @IBInspectable open var shouldRightViewHideOnTouchAnimated: Bool = true

    @IBInspectable open var isLeftViewSwipeGestureEnabled: Bool = true
    @IBInspectable open var isRightViewSwipeGestureEnabled: Bool = true

    open var isLeftViewSwipeGestureDisabled: Bool {
        set {
            self.isLeftViewSwipeGestureEnabled = !newValue
        }
        get {
            return !isLeftViewSwipeGestureEnabled
        }
    }

    open var isRightViewSwipeGestureDisabled: Bool {
        set {
            self.isRightViewSwipeGestureEnabled = !newValue
        }
        get {
            return !isRightViewSwipeGestureEnabled
        }
    }

    open var leftViewSwipeGestureArea: SwipeGestureArea = .borders
    open var rightViewSwipeGestureArea: SwipeGestureArea = .borders

    /// Explanation:
    /// For SwipeGestureRange(left: 44.0, right: 44.0) => leftView 44.0 | 44.0 rootView
    /// For SwipeGestureRange(left: 0.0, right: 44.0)  => leftView  0.0 | 44.0 rootView
    /// For SwipeGestureRange(left: 44.0, right: 0.0)  => leftView 44.0 | 0.0  rootView
    /// Note:
    /// If leftSwipeGestureArea == .full then right part is ignored
    open var leftViewSwipeGestureRange = SwipeGestureRange(left: 0.0, right: 44.0)

    /// Explanation:
    /// For SwipeGestureRange(left: 44.0, right: 44.0) => rootView 44.0 | 44.0 rightView
    /// For SwipeGestureRange(left: 0.0, right: 44.0)  => rootView  0.0 | 44.0 rightView
    /// For SwipeGestureRange(left: 44.0, right: 0.0)  => rootView 44.0 | 0.0  rightView
    /// Note:
    /// If rightSwipeGestureArea == .full then left part is ignored
    open var rightViewSwipeGestureRange = SwipeGestureRange(left: 44.0, right: 0.0)

    @IBInspectable open var leftViewAnimationDuration: TimeInterval = 0.5
    @IBInspectable open var rightViewAnimationDuration: TimeInterval = 0.5

    // TODO: Add custom timing function

    @IBInspectable open var isLeftViewEnabled: Bool = true
    @IBInspectable open var isRightViewEnabled: Bool = true

    open var isLeftViewDisabled: Bool {
        set {
            self.isLeftViewEnabled = !newValue
        }
        get {
            return !isLeftViewEnabled
        }
    }

    open var isRightViewDisabled: Bool {
        set {
            self.isRightViewEnabled = !newValue
        }
        get {
            return !isRightViewEnabled
        }
    }

    @IBInspectable open var rootViewBackgroundColor: UIColor = .clear {
        didSet {
            setNeedsUpdateLayoutsAndStyles()
        }
    }

    @IBInspectable open var leftViewBackgroundColor: UIColor = .clear {
        didSet {
            setNeedsUpdateLayoutsAndStyles()
        }
    }

    @IBInspectable open var rightViewBackgroundColor: UIColor = .clear {
        didSet {
            setNeedsUpdateLayoutsAndStyles()
        }
    }

    @IBInspectable open var leftViewBackgroundImage: UIImage? {
        didSet {
            setNeedsUpdateLayoutsAndStyles()
        }
    }

    @IBInspectable open var rightViewBackgroundImage: UIImage? {
        didSet {
            setNeedsUpdateLayoutsAndStyles()
        }
    }

    @IBInspectable open var leftViewBackgroundBlurEffect: UIBlurEffect?
    @IBInspectable open var rightViewBackgroundBlurEffect: UIBlurEffect?

    @IBInspectable open var leftViewBackgroundAlpha: CGFloat = 1.0
    @IBInspectable open var rightViewBackgroundAlpha: CGFloat = 1.0

    @IBInspectable open var rootViewLayerBorderColor: UIColor?

    /// Default:
    /// rootViewLayerBorderColor if assigned
    /// else .clear
    @IBInspectable open var rootViewLayerBorderColorForLeftView: UIColor {
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

    /// Default:
    /// rootViewLayerBorderColor if assigned
    /// else .clear
    @IBInspectable open var rootViewLayerBorderColorForRightView: UIColor {
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

    @IBInspectable open var leftViewLayerBorderColor: UIColor = .clear
    @IBInspectable open var rightViewLayerBorderColor: UIColor = .clear

    open var rootViewLayerBorderWidth: CGFloat?

    /// Default:
    /// rootViewLayerBorderWidth if assigned
    /// else 0.0
    @IBInspectable open var rootViewLayerBorderWidthForLeftView: CGFloat {
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

    /// Default:
    /// rootViewLayerBorderWidth if assigned
    /// else 0.0
    @IBInspectable open var rootViewLayerBorderWidthForRightView: CGFloat {
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

    @IBInspectable open var leftViewLayerBorderWidth: CGFloat = 0.0
    @IBInspectable open var rightViewLayerBorderWidth: CGFloat = 0.0

    @IBInspectable open var rootViewLayerShadowColor: UIColor?

    /// Default:
    /// rootViewLayerShadowColor if assigned
    /// if presentationStyle.isBelow then UIColor(white: 0.0, alpha: 0.5)
    /// else .clear
    @IBInspectable open var rootViewLayerShadowColorForLeftView: UIColor {
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

    /// Default:
    /// rootViewLayerShadowColor if assigned
    /// if presentationStyle.isBelow then UIColor(white: 0.0, alpha: 0.5)
    /// else .clear
    @IBInspectable open var rootViewLayerShadowColorForRightView: UIColor {
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

    /// Default:
    /// if presentationStyle.isAbove then UIColor(white: 0.0, alpha: 0.5)
    /// else .clear
    @IBInspectable open var leftViewLayerShadowColor: UIColor {
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

    /// Default:
    /// if presentationStyle.isAbove then UIColor(white: 0.0, alpha: 0.5)
    /// else .clear
    @IBInspectable open var rightViewLayerShadowColor: UIColor {
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

    open var rootViewLayerShadowRadius: CGFloat?

    /// Default:
    /// rootViewLayerShadowRadius if assigned
    /// if presentationStyle.isBelow then 8.0
    /// else 0.0
    @IBInspectable open var rootViewLayerShadowRadiusForLeftView: CGFloat {
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

    /// Default:
    /// rootViewLayerShadowRadius if assigned
    /// if presentationStyle.isBelow then 8.0
    /// else 0.0
    @IBInspectable open var rootViewLayerShadowRadiusForRightView: CGFloat {
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

    /// Default:
    /// if presentationStyle.isAbove then 8.0
    /// else 0.0
    @IBInspectable open var leftViewLayerShadowRadius: CGFloat {
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

    /// Default:
    /// if presentationStyle.isAbove then 8.0
    /// else 0.0
    @IBInspectable open var rightViewLayerShadowRadius: CGFloat {
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

    @IBInspectable open var rootViewCoverBlurEffect: UIBlurEffect?

    /// Default:
    /// rootViewCoverBlurEffect if assigned
    @IBInspectable open var rootViewCoverBlurEffectForLeftView: UIBlurEffect? {
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

    /// Default:
    /// rootViewCoverBlurEffect if assigned
    @IBInspectable open var rootViewCoverBlurEffectForRightView: UIBlurEffect? {
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

    @IBInspectable open var leftViewCoverBlurEffect: UIBlurEffect?

    /// This cover is only visible if left view is always visible for current orientation
    /// Default: rootViewCoverBlurEffectForRightView
    @IBInspectable open var leftViewCoverBlurEffectWhenAlwaysVisible: UIBlurEffect? {
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

    @IBInspectable open var rightViewCoverBlurEffect: UIBlurEffect?

    /// This cover is only visible if right view is always visible for current orientation
    /// Default: rootViewCoverBlurEffectForLeftView
    @IBInspectable open var rightViewCoverBlurEffectWhenAlwaysVisible: UIBlurEffect? {
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

    open var rootViewCoverAlpha: CGFloat?

    /// Default:
    /// rootViewCoverAlpha if assigned
    /// else 1.0
    @IBInspectable open var rootViewCoverAlphaForLeftView: CGFloat {
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

    /// Default:
    /// rootViewCoverAlpha if assigned
    /// else 1.0
    @IBInspectable open var rootViewCoverAlphaForRightView: CGFloat {
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

    @IBInspectable open var leftViewCoverAlpha: CGFloat = 1.0

    /// This cover is only visible if left view is always visible for current orientation
    /// Default: rootViewCoverAlphaForRightView
    @IBInspectable open var leftViewCoverAlphaWhenAlwaysVisible: CGFloat {
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

    @IBInspectable open var rightViewCoverAlpha: CGFloat = 1.0

    /// This cover is only visible if right view is always visible for current orientation
    /// Default: rootViewCoverAlphaForLeftView
    @IBInspectable open var rightViewCoverAlphaWhenAlwaysVisible: CGFloat {
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

    @IBInspectable open var rootViewCoverColor: UIColor?

    /// Color that hides root view, when left view is showing
    /// Default:
    /// rootViewCoverColor if assigned
    /// if presentationStyle.isAbove then UIColor(white: 0.0, alpha: 0.5)
    /// else .clear
    @IBInspectable open var rootViewCoverColorForLeftView: UIColor {
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
            if leftViewPresentationStyle.isAbove {
                return UIColor(white: 0.0, alpha: 0.5)
            }
            return .clear
        }
    }
    private var _rootViewCoverColorForLeftView: UIColor?

    /// Color that hides root view, when right view is showing
    /// Default:
    /// rootViewCoverColor if assigned
    /// if presentationStyle.isAbove then UIColor(white: 0.0, alpha: 0.5)
    /// else .clear
    @IBInspectable open var rootViewCoverColorForRightView: UIColor {
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
            if rightViewPresentationStyle.isAbove {
                return UIColor(white: 0.0, alpha: 0.5)
            }
            return .clear
        }
    }
    private var _rootViewCoverColorForRightView: UIColor?

    /// Color that hides left view, when it is not showing
    /// Default:
    /// if presentationStyle.isBelow then UIColor(white: 0.0, alpha: 0.5)
    /// else .clear
    @IBInspectable open var leftViewCoverColor: UIColor {
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

    /// This cover is only visible if left view is always visible for current orientation
    /// Default: rootViewCoverColorForRightView
    @IBInspectable open var leftViewCoverColorWhenAlwaysVisible: UIColor {
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

    /// Color that hides right view, when it is not showing
    /// Default:
    /// if presentationStyle.isBelow then UIColor(white: 0.0, alpha: 0.5)
    /// else .clear
    @IBInspectable open var rightViewCoverColor: UIColor {
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

    /// This cover is only visible if right view is always visible for current orientation
    /// Default: rootViewCoverColorForLeftView
    @IBInspectable open var rightViewCoverColorWhenAlwaysVisible: UIColor {
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

    /// Duration with which status bar will update its style while swipe gesture
    @IBInspectable open var statusBarAnimationDuration: TimeInterval = 0.2

    // MARK: - Public Conditional Configurable Properties

    /// Default: rootViewController.prefersStatusBarHidden ?? prefersStatusBarHidden
    @IBInspectable open var isRootViewStatusBarHidden: Bool {
        set {
            _isRootViewStatusBarHidden = newValue
        }
        get {
            return _isRootViewStatusBarHidden ?? rootViewController?.prefersStatusBarHidden ?? prefersStatusBarHidden
        }
    }
    private var _isRootViewStatusBarHidden: Bool?

    /// Default: leftViewController.prefersStatusBarHidden ?? rootViewStatusBarHidden
    @IBInspectable open var isLeftViewStatusBarHidden: Bool {
        set {
            _isLeftViewStatusBarHidden = newValue
        }
        get {
            return _isLeftViewStatusBarHidden ?? leftViewController?.prefersStatusBarHidden ?? isRootViewStatusBarHidden
        }
    }
    private var _isLeftViewStatusBarHidden: Bool?

    /// Default: rightViewController.prefersStatusBarHidden ?? rootViewStatusBarHidden
    @IBInspectable open var isRightViewStatusBarHidden: Bool {
        set {
            _isRightViewStatusBarHidden = newValue
        }
        get {
            return _isRightViewStatusBarHidden ?? rightViewController?.prefersStatusBarHidden ?? isRootViewStatusBarHidden
        }
    }
    private var _isRightViewStatusBarHidden: Bool?

    /// Default: rootViewController.preferredStatusBarStyle ?? preferredStatusBarStyle
    @IBInspectable open var rootViewStatusBarStyle: UIStatusBarStyle {
        set {
            _rootViewStatusBarStyle = newValue
        }
        get {
            return _rootViewStatusBarStyle ?? rootViewController?.preferredStatusBarStyle ?? preferredStatusBarStyle
        }
    }
    private var _rootViewStatusBarStyle: UIStatusBarStyle?

    /// Default: leftViewController.preferredStatusBarStyle ?? rootViewStatusBarStyle
    @IBInspectable open var leftViewStatusBarStyle: UIStatusBarStyle {
        set {
            _leftViewStatusBarStyle = newValue
        }
        get {
            return _leftViewStatusBarStyle ?? leftViewController?.preferredStatusBarStyle ?? rootViewStatusBarStyle
        }
    }
    private var _leftViewStatusBarStyle: UIStatusBarStyle?

    /// Default: rightViewController.preferredStatusBarStyle ?? rootViewStatusBarStyle
    @IBInspectable open var rightViewStatusBarStyle: UIStatusBarStyle {
        set {
            _rightViewStatusBarStyle = newValue
        }
        get {
            return _rightViewStatusBarStyle ?? rightViewController?.preferredStatusBarStyle ?? rootViewStatusBarStyle
        }
    }
    private var _rightViewStatusBarStyle: UIStatusBarStyle?

    /// Default: rootViewController.preferredStatusBarUpdateAnimation ?? preferredStatusBarUpdateAnimation
    @IBInspectable open var rootViewStatusBarUpdateAnimation: UIStatusBarAnimation {
        set {
            _rootViewStatusBarUpdateAnimation = newValue
        }
        get {
            return _rootViewStatusBarUpdateAnimation ?? rootViewController?.preferredStatusBarUpdateAnimation ?? preferredStatusBarUpdateAnimation
        }
    }
    private var _rootViewStatusBarUpdateAnimation: UIStatusBarAnimation?

    /// Default: leftViewController.preferredStatusBarUpdateAnimation ?? rootViewStatusBarUpdateAnimation
    @IBInspectable open var leftViewStatusBarUpdateAnimation: UIStatusBarAnimation {
        set {
            _leftViewStatusBarUpdateAnimation = newValue
        }
        get {
            return _leftViewStatusBarUpdateAnimation ?? leftViewController?.preferredStatusBarUpdateAnimation ?? rootViewStatusBarUpdateAnimation
        }
    }
    private var _leftViewStatusBarUpdateAnimation: UIStatusBarAnimation?

    /// Default: rightViewController.preferredStatusBarUpdateAnimation ?? rootViewStatusBarUpdateAnimation
    @IBInspectable open var rightViewStatusBarUpdateAnimation: UIStatusBarAnimation {
        set {
            _rightViewStatusBarUpdateAnimation = newValue
        }
        get {
            return _rightViewStatusBarUpdateAnimation ?? rightViewController?.preferredStatusBarUpdateAnimation ?? rootViewStatusBarUpdateAnimation
        }
    }
    private var _rightViewStatusBarUpdateAnimation: UIStatusBarAnimation?

    open var rootViewScale: CGFloat?

    /// Default:
    /// rootViewScale if assigned
    /// if presentationStyle.shouldRootViewScale then 0.8
    /// else 1.0
    @IBInspectable open var rootViewScaleForLeftView: CGFloat {
        set {
            _rootViewScaleForLeftView = newValue
        }
        get {
            if let rootViewScaleForLeftView = _rootViewScaleForLeftView {
                return rootViewScaleForLeftView
            }
            if let rootViewScaleForLeftView = rootViewScale {
                return rootViewScaleForLeftView
            }
            if leftViewPresentationStyle.shouldRootViewScale {
                return 0.8
            }
            return 1.0
        }
    }
    private var _rootViewScaleForLeftView: CGFloat?

    /// Default:
    /// rootViewScale if assigned
    /// if presentationStyle.shouldRootViewScale then 0.8
    /// else 1.0
    @IBInspectable open var rootViewScaleForRightView: CGFloat {
        set {
            _rootViewScaleForRightView = newValue
        }
        get {
            if let rootViewScaleForRightView = _rootViewScaleForRightView {
                return rootViewScaleForRightView
            }
            if let rootViewScaleForRightView = rootViewScale {
                return rootViewScaleForRightView
            }
            if rightViewPresentationStyle.shouldRootViewScale {
                return 0.8
            }
            return 1.0
        }
    }
    private var _rootViewScaleForRightView: CGFloat?

    /// Default:
    /// if presentationStyle == .scaleFromBig then 1.2
    /// if presentationStyle == .scaleFromLittle then 0.8
    /// else 1.0
    @IBInspectable open var leftViewInitialScale: CGFloat {
        set {
            _leftViewInitialScale = newValue
        }
        get {
            if let leftViewInitialScale = _leftViewInitialScale {
                return leftViewInitialScale
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
    private var _leftViewInitialScale: CGFloat?

    /// Default:
    /// if presentationStyle == .scaleFromBig then 1.2
    /// if presentationStyle == .scaleFromLittle then 0.8
    /// else 1.0
    @IBInspectable open var rightViewInitialScale: CGFloat {
        set {
            _rightViewInitialScale = newValue
        }
        get {
            if let rightViewInitialScale = _rightViewInitialScale {
                return rightViewInitialScale
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
    private var _rightViewInitialScale: CGFloat?

    /// Default:
    /// if presentationStyle == .slideBelow then -(leftViewWidth / 2.0)
    /// else 0.0
    @IBInspectable open var leftViewInitialOffsetX: CGFloat {
        set {
            _leftViewInitialOffsetX = newValue
        }
        get {
            if let leftViewInitialOffsetX = _leftViewInitialOffsetX {
                return leftViewInitialOffsetX
            }
            if leftViewPresentationStyle == .slideBelow {
                return -(leftViewWidth / 2.0)
            }
            return 0.0
        }
    }
    private var _leftViewInitialOffsetX: CGFloat?

    /// Default:
    /// if presentationStyle == .slideBelow then rightViewWidth / 2.0
    /// else 0.0
    @IBInspectable open var rightViewInitialOffsetX: CGFloat {
        set {
            _rightViewInitialOffsetX = newValue
        }
        get {
            if let rightViewInitialOffsetX = _rightViewInitialOffsetX {
                return rightViewInitialOffsetX
            }
            if rightViewPresentationStyle == .slideBelow {
                return rightViewWidth / 2.0
            }
            return 0.0
        }
    }
    private var _rightViewInitialOffsetX: CGFloat?

    /// Default:
    /// if presentationStyle == .scaleFromBig then 1.4
    /// else 1.0
    @IBInspectable open var leftViewBackgroundImageInitialScale: CGFloat {
        set {
            _leftViewBackgroundImageInitialScale = newValue
        }
        get {
            if let leftViewBackgroundImageInitialScale = _leftViewBackgroundImageInitialScale {
                return leftViewBackgroundImageInitialScale
            }
            if leftViewPresentationStyle == .scaleFromBig {
                return 1.4
            }
            return 1.0
        }
    }
    private var _leftViewBackgroundImageInitialScale: CGFloat?

    /// Default:
    /// if presentationStyle == .scaleFromBig then 1.4
    /// else 1.0
    @IBInspectable open var rightViewBackgroundImageInitialScale: CGFloat {
        set {
            _rightViewBackgroundImageInitialScale = newValue
        }
        get {
            if let rightViewBackgroundImageInitialScale = _rightViewBackgroundImageInitialScale {
                return rightViewBackgroundImageInitialScale
            }
            if rightViewPresentationStyle == .scaleFromBig {
                return 1.4
            }
            return 1.0
        }
    }
    private var _rightViewBackgroundImageInitialScale: CGFloat?

    /// Default:
    /// if presentationStyle == .scaleFromLittle then 1.4
    /// else 1.0
    @IBInspectable open var leftViewBackgroundImageFinalScale: CGFloat {
        set {
            _leftViewBackgroundImageFinalScale = newValue
        }
        get {
            if let leftViewBackgroundImageFinalScale = _leftViewBackgroundImageFinalScale {
                return leftViewBackgroundImageFinalScale
            }
            if leftViewPresentationStyle == .scaleFromLittle {
                return 1.4
            }
            return 1.0
        }
    }
    private var _leftViewBackgroundImageFinalScale: CGFloat?

    /// Default:
    /// if presentationStyle == .scaleFromLittle then 1.4
    /// else 1.0
    @IBInspectable open var rightViewBackgroundImageFinalScale: CGFloat {
        set {
            _rightViewBackgroundImageFinalScale = newValue
        }
        get {
            if let rightViewBackgroundImageFinalScale = _rightViewBackgroundImageFinalScale {
                return rightViewBackgroundImageFinalScale
            }
            if rightViewPresentationStyle == .scaleFromLittle {
                return 1.4
            }
            return 1.0
        }
    }
    private var _rightViewBackgroundImageFinalScale: CGFloat?

    // MARK: - Callbacks

    open var willShowLeftView: Callback?
    open var didShowLeftView: Callback?

    open var willHideLeftView: Callback?
    open var didHideLeftView: Callback?

    open var willShowRightView: Callback?
    open var didShowRightView: Callback?

    open var willHideRightView: Callback?
    open var didHideRightView: Callback?

    /// You can use this callback to add some custom animations
    open var showAnimationsForLeftView: AnimationsCallback?
    /// You can use this callback to add some custom animations
    open var hideAnimationsForLeftView: AnimationsCallback?

    /// You can use this callback to add some custom animations
    open var showAnimationsForRightView: AnimationsCallback?
    /// You can use this callback to add some custom animations
    open var hideAnimationsForRightView: AnimationsCallback?

    // MARK: - Delegate

    open var delegate: LGSideMenuDelegate?

    // MARK: - Internal Properties

    open internal(set) var state: State = .rootViewIsShowing

    open internal(set) var isAnimating = false

    open internal(set) var isNeedsUpdateLayoutsAndStyles: Bool = false
    open internal(set) var isNeedsUpdateRootViewLayoutsAndStyles: Bool = false
    open internal(set) var isNeedsUpdateLeftViewLayoutsAndStyles: Bool = false
    open internal(set) var isNeedsUpdateRightViewLayoutsAndStyles: Bool = false

    open internal(set) var rootContainerView: UIView?
    open internal(set) var rootViewShadowView: LGSideMenuShadowView?
    open internal(set) var rootViewBackgroundView: LGSideMenuBackgroundView?
    open internal(set) var rootViewWrapperView: LGSideMenuWrapperView?
    open internal(set) var rootViewCoverView: UIVisualEffectView?

    open internal(set) var leftContainerView: UIView?
    open internal(set) var leftViewShadowView: LGSideMenuShadowView?
    open internal(set) var leftViewBackgroundView: LGSideMenuBackgroundView?
    open internal(set) var leftViewBackgroundImageView: UIImageView?
    open internal(set) var leftViewEffectView: UIVisualEffectView?
    open internal(set) var leftViewWrapperView: LGSideMenuWrapperView?
    open internal(set) var leftViewCoverView: UIVisualEffectView?
    // TODO: Add leftViewStatusBarBackgroundView

    open internal(set) var rightContainerView: UIView?
    open internal(set) var rightViewShadowView: LGSideMenuShadowView?
    open internal(set) var rightViewBackgroundView: LGSideMenuBackgroundView?
    open internal(set) var rightViewBackgroundImageView: UIImageView?
    open internal(set) var rightViewEffectView: UIVisualEffectView?
    open internal(set) var rightViewWrapperView: LGSideMenuWrapperView?
    open internal(set) var rightViewCoverView: UIVisualEffectView?
    // TODO: Add rightViewStatusBarBackgroundView

    internal var savedSize: CGSize = .zero

    internal var leftViewGestureStartX: CGFloat?
    internal var rightViewGestureStartX: CGFloat?

    internal var isLeftViewShowingBeforeGesture: Bool = false
    internal var isRightViewShowingBeforeGesture: Bool = false

    internal var shouldUpdateVisibility: Bool = true

    internal var isRotationInvalidatedLayout: Bool = false

    internal var isRootViewLayoutingEnabled: Bool = true
    internal var isRootViewControllerLayoutingEnabled: Bool = true

    // MARK: - Initialization

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

        // We need to use defer here to trigger willSet and didSet callbacks
        defer {
            self.rootViewController = rootViewController
            self.leftViewController = leftViewController
            self.rightViewController = rightViewController
        }
    }

    convenience public init(rootView: UIView? = nil, leftView: UIView? = nil, rightView: UIView? = nil) {
        self.init()

        // We need to use defer here to trigger willSet and didSet callbacks
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
            if LGSideMenuHelper.canPerformSegue(self, withIdentifier: LGSideMenuSegue.Identifier.root) {
                self.performSegue(withIdentifier: LGSideMenuSegue.Identifier.root, sender: self)
            }
            if LGSideMenuHelper.canPerformSegue(self, withIdentifier: LGSideMenuSegue.Identifier.left) {
                self.performSegue(withIdentifier: LGSideMenuSegue.Identifier.left, sender: self)
            }
            if LGSideMenuHelper.canPerformSegue(self, withIdentifier: LGSideMenuSegue.Identifier.right) {
                self.performSegue(withIdentifier: LGSideMenuSegue.Identifier.right, sender: self)
            }
        }
    }

}
