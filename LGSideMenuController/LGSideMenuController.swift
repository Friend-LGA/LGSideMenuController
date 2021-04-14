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

        /// This notification is posted on every transformation of root view during showing/hiding of side views
        /// You can retrieve percentage between 0.0 and 1.0 from userInfo dictionary, where
        /// 0.0 - view is fully shown
        /// 1.0 - view is fully hidden
        public static let didTransformRootView = NSNotification.Name("LGSideMenuController.Notification.didTransformRootView")

        /// This notification is posted on every transformation of left view during showing/hiding
        /// You can retrieve percentage between 0.0 and 1.0 from userInfo dictionary, where
        /// 0.0 - view is fully hidden
        /// 1.0 - view is fully shown
        public static let didTransformLeftView = NSNotification.Name("LGSideMenuController.Notification.didTransformLeftView")

        /// This notification is posted on every transformation of right view during showing/hiding
        /// You can retrieve percentage between 0.0 and 1.0 from userInfo dictionary, where
        /// 0.0 - view is fully hidden
        /// 1.0 - view is fully shown
        public static let didTransformRightView  = NSNotification.Name("LGSideMenuController.Notification.didTransformRightView")

        public struct Key {
            /// Key for userInfo dictionary which represents duration of the animation
            static let duration = "duration"

            /// Key for userInfo dictionary which represents timing function of the animation
            static let timigFunction = "timigFunction"

            /// Key for userInfo dictionary which represents current transformation percentage
            static let percentage = "percentage"
        }

    }

    /// Options which determine when side view should be always visible
    /// For example you might want to always show side view on iPad with landscape orientation
    public struct AlwaysVisibleOptions: OptionSet {
        public let rawValue: Int

        public static let padLandscape   = AlwaysVisibleOptions(rawValue: 1 << 0)
        public static let padPortrait    = AlwaysVisibleOptions(rawValue: 1 << 1)
        public static let phoneLandscape = AlwaysVisibleOptions(rawValue: 1 << 2)
        public static let phonePortrait  = AlwaysVisibleOptions(rawValue: 1 << 3)

        /// Based on horizontalSizeClass of current traitCollection
        public static let padRegular   = AlwaysVisibleOptions(rawValue: 1 << 4)
        /// Based on horizontalSizeClass of current traitCollection
        public static let padCompact   = AlwaysVisibleOptions(rawValue: 1 << 5)
        /// Based on horizontalSizeClass of current traitCollection
        public static let phoneRegular = AlwaysVisibleOptions(rawValue: 1 << 6)
        /// Based on horizontalSizeClass of current traitCollection
        public static let phoneCompact = AlwaysVisibleOptions(rawValue: 1 << 7)

        public static let landscape: AlwaysVisibleOptions = [.padLandscape, .phoneLandscape]
        public static let portrait: AlwaysVisibleOptions  = [.padPortrait, .phonePortrait]
        /// Based on horizontalSizeClass of current traitCollection
        public static let regular: AlwaysVisibleOptions   = [.padRegular, .phoneRegular]
        /// Based on horizontalSizeClass of current traitCollection
        public static let compact: AlwaysVisibleOptions   = [.padCompact, .phoneCompact]
        public static let pad: AlwaysVisibleOptions       = [.padLandscape, .padPortrait, .padRegular, .padCompact]
        public static let phone: AlwaysVisibleOptions     = [.phoneLandscape, .phonePortrait, .phoneRegular, .phoneCompact]
        public static let all: AlwaysVisibleOptions       = [.pad, .phone]

        public init(rawValue: Int = 0) {
            self.rawValue = rawValue
        }

        public var isEmpty: Bool {
            return self == []
        }

        public func isCurrentlyAlwaysVisible(sizeClass: UIUserInterfaceSizeClass) -> Bool {
            if LGSideMenuHelper.isPad() {
                if LGSideMenuHelper.isLandscape() && contains(.padLandscape) {
                    return true
                }
                if LGSideMenuHelper.isPortrait() && contains(.padPortrait) {
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
                if LGSideMenuHelper.isLandscape() && contains(.phoneLandscape) {
                    return true
                }
                if LGSideMenuHelper.isPortrait() && contains(.phonePortrait) {
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

    public enum PresentationStyle {
        case slideAbove
        case slideAboveBlurred
        case slideBelow
        case slideBelowShifted
        case slideAside
        case scaleFromBig
        case scaleFromLittle
        // TODO: Add more

        public init() {
            self = .slideAbove
        }

        public var isAbove: Bool {
            return
                self == .slideAbove ||
                self == .slideAboveBlurred
        }

        public var isBelow: Bool {
            return
                self == .slideBelow ||
                self == .slideBelowShifted ||
                self == .scaleFromBig ||
                self == .scaleFromLittle
        }

        public var isAside: Bool {
            return self == .slideAside
        }

        public var isHiddenAside: Bool {
            return
                self == .slideAbove ||
                self == .slideAboveBlurred ||
                self == .slideAside
        }

        public var isWidthFull: Bool {
            return
                self == .slideBelow ||
                self == .slideBelowShifted ||
                self == .scaleFromBig ||
                self == .scaleFromLittle
        }

        public var isWidthCompact: Bool {
            return
                self == .slideAbove ||
                self == .slideAboveBlurred ||
                self == .slideAside
        }

        public var shouldRootViewMove: Bool {
            return
                self == .slideBelow ||
                self == .slideBelowShifted ||
                self == .slideAside ||
                self == .scaleFromBig ||
                self == .scaleFromLittle
        }

        public var shouldRootViewScale: Bool {
            return
                self == .scaleFromBig ||
                self == .scaleFromLittle
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

    // MARK: - Base View Controllers -

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

    public let tapGesture: UITapGestureRecognizer
    public let panGestureForLeftView: UIPanGestureRecognizer
    public let panGestureForRightView: UIPanGestureRecognizer

    // MARK: - Side Views Availability -

    @IBInspectable
    open var isLeftViewEnabled: Bool = true

    @IBInspectable
    open var isRightViewEnabled: Bool = true

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

    // MARK: - Width -

    /// Default is min(MainScreenSize.minSide - 44.0, 320.0)
    @IBInspectable
    open var leftViewWidth: CGFloat = {
        let minScreenSide = min(UIScreen.main.bounds.width, UIScreen.main.bounds.height)
        return min(minScreenSide - 44.0, 320.0)
    }() {
        didSet {
            setNeedsUpdateLayoutsAndStyles()
        }
    }

    /// Default is min(MainScreenSize.minSide - 44.0, 320.0)
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

    // MARK: - Always Visible Options -

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

    // MARK: - Gestures Availability -

    @IBInspectable
    open var shouldLeftViewHideOnTouch: Bool = true

    @IBInspectable
    open var shouldRightViewHideOnTouch: Bool = true

    @IBInspectable
    open var shouldLeftViewHideOnTouchAnimated: Bool = true

    @IBInspectable
    open var shouldRightViewHideOnTouchAnimated: Bool = true

    @IBInspectable
    open var isLeftViewSwipeGestureEnabled: Bool = true

    @IBInspectable
    open var isRightViewSwipeGestureEnabled: Bool = true

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

    // MARK: - Swipe Gesture Area -

    open var leftViewSwipeGestureArea: SwipeGestureArea = .borders
    open var rightViewSwipeGestureArea: SwipeGestureArea = .borders

    // MARK: - Swipe Gesture Range -

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

    // MARK: - Animations Properties -

    @IBInspectable
    open var leftViewAnimationDuration: TimeInterval = 0.45

    @IBInspectable
    open var rightViewAnimationDuration: TimeInterval = 0.45

    @IBInspectable
    open var leftViewAnimationTimingFunction = CAMediaTimingFunction(controlPoints: 0.33333, 0.66667, 0.33333, 1.0)

    @IBInspectable
    open var rightViewAnimationTimingFunction = CAMediaTimingFunction(controlPoints: 0.33333, 0.66667, 0.33333, 1.0)

    // MARK: - Background Color -

    @IBInspectable
    open var rootViewBackgroundColor: UIColor = .clear {
        didSet {
            setNeedsUpdateLayoutsAndStyles()
        }
    }

    @IBInspectable
    open var leftViewBackgroundColor: UIColor = .clear {
        didSet {
            setNeedsUpdateLayoutsAndStyles()
        }
    }

    @IBInspectable
    open var rightViewBackgroundColor: UIColor = .clear {
        didSet {
            setNeedsUpdateLayoutsAndStyles()
        }
    }

    // MARK: - Background View -

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

    /// Default:
    /// if presentationStyle == .slideAboveBlurred then .regular
    /// else nil
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
    open var _leftViewBackgroundBlurEffect: UIBlurEffect?
    open var _isLeftViewBackgroundBlurEffectAssigned: Bool = false

    /// Default:
    /// if presentationStyle == .slideAboveBlurred then .regular
    /// else nil
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
    open var _rightViewBackgroundBlurEffect: UIBlurEffect?
    open var _isRightViewBackgroundBlurEffectAssigned: Bool = false

    // MARK: - Background Alpha -

    @IBInspectable
    open var leftViewBackgroundAlpha: CGFloat = 1.0

    @IBInspectable
    open var rightViewBackgroundAlpha: CGFloat = 1.0

    // MARK: - Layer Border Color -

    @IBInspectable
    open var rootViewLayerBorderColor: UIColor?

    /// Default:
    /// rootViewLayerBorderColor if assigned
    /// else .clear
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

    /// Default:
    /// rootViewLayerBorderColor if assigned
    /// else .clear
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

    @IBInspectable
    open var leftViewLayerBorderColor: UIColor = .clear

    @IBInspectable
    open var rightViewLayerBorderColor: UIColor = .clear

    // MARK: - Layer Border Width -

    open var rootViewLayerBorderWidth: CGFloat?

    /// Default:
    /// rootViewLayerBorderWidth if assigned
    /// else 0.0
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

    /// Default:
    /// rootViewLayerBorderWidth if assigned
    /// else 0.0
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

    @IBInspectable
    open var leftViewLayerBorderWidth: CGFloat = 0.0

    @IBInspectable
    open var rightViewLayerBorderWidth: CGFloat = 0.0

    // MARK: - Layer Shadow Color -

    @IBInspectable
    open var rootViewLayerShadowColor: UIColor?

    /// Default:
    /// rootViewLayerShadowColor if assigned
    /// if presentationStyle.isBelow then UIColor(white: 0.0, alpha: 0.5)
    /// else .clear
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

    /// Default:
    /// rootViewLayerShadowColor if assigned
    /// if presentationStyle.isBelow then UIColor(white: 0.0, alpha: 0.5)
    /// else .clear
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

    /// Default:
    /// if presentationStyle.isAbove then UIColor(white: 0.0, alpha: 0.5)
    /// else .clear
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

    /// Default:
    /// if presentationStyle.isAbove then UIColor(white: 0.0, alpha: 0.5)
    /// else .clear
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

    open var rootViewLayerShadowRadius: CGFloat?

    /// Default:
    /// rootViewLayerShadowRadius if assigned
    /// if presentationStyle.isBelow then 8.0
    /// else 0.0
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

    /// Default:
    /// rootViewLayerShadowRadius if assigned
    /// if presentationStyle.isBelow then 8.0
    /// else 0.0
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

    /// Default:
    /// if presentationStyle.isAbove then 8.0
    /// else 0.0
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

    /// Default:
    /// if presentationStyle.isAbove then 8.0
    /// else 0.0
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

    @IBInspectable
    open var rootViewCoverBlurEffect: UIBlurEffect?

    /// Default:
    /// rootViewCoverBlurEffect if assigned
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

    /// Default:
    /// rootViewCoverBlurEffect if assigned
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

    @IBInspectable
    open var leftViewCoverBlurEffect: UIBlurEffect?

    /// This cover is only visible if left view is always visible for current orientation
    /// Default: rootViewCoverBlurEffectForRightView
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

    @IBInspectable
    open var rightViewCoverBlurEffect: UIBlurEffect?

    /// This cover is only visible if right view is always visible for current orientation
    /// Default: rootViewCoverBlurEffectForLeftView
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

    open var rootViewCoverAlpha: CGFloat?

    /// Default:
    /// rootViewCoverAlpha if assigned
    /// else 1.0
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

    /// Default:
    /// rootViewCoverAlpha if assigned
    /// else 1.0
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

    @IBInspectable
    open var leftViewCoverAlpha: CGFloat = 1.0

    /// This cover is only visible if left view is always visible for current orientation
    /// Default: rootViewCoverAlphaForRightView
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

    @IBInspectable
    open var rightViewCoverAlpha: CGFloat = 1.0

    /// This cover is only visible if right view is always visible for current orientation
    /// Default: rootViewCoverAlphaForLeftView
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

    @IBInspectable
    open var rootViewCoverColor: UIColor?

    /// Color that hides root view, when left view is showing
    /// Default:
    /// rootViewCoverColor if assigned
    /// else .clear
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

    /// Color that hides root view, when right view is showing
    /// Default:
    /// rootViewCoverColor if assigned
    /// else .clear
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

    /// Color that hides left view, when it is not showing
    /// Default:
    /// if presentationStyle.isBelow then UIColor(white: 0.0, alpha: 0.5)
    /// else .clear
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

    /// This cover is only visible if left view is always visible for current orientation
    /// Default: rootViewCoverColorForRightView
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

    /// Color that hides right view, when it is not showing
    /// Default:
    /// if presentationStyle.isBelow then UIColor(white: 0.0, alpha: 0.5)
    /// else .clear
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

    /// This cover is only visible if right view is always visible for current orientation
    /// Default: rootViewCoverColorForLeftView
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

    /// Duration with which status bar will update its style while swipe gesture
    @IBInspectable
    open var statusBarAnimationDuration: TimeInterval = 0.2

    // MARK: - Status Bar Hidden -

    /// Default: rootViewController.prefersStatusBarHidden ?? prefersStatusBarHidden
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

    /// Default: leftViewController.prefersStatusBarHidden ?? rootViewStatusBarHidden
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

    /// Default: rightViewController.prefersStatusBarHidden ?? rootViewStatusBarHidden
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

    /// Default: rootViewController.preferredStatusBarStyle ?? preferredStatusBarStyle
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

    /// Default: leftViewController.preferredStatusBarStyle ?? rootViewStatusBarStyle
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

    /// Default: rightViewController.preferredStatusBarStyle ?? rootViewStatusBarStyle
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

    /// Default: rootViewController.preferredStatusBarUpdateAnimation ?? preferredStatusBarUpdateAnimation
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

    /// Default: leftViewController.preferredStatusBarUpdateAnimation ?? rootViewStatusBarUpdateAnimation
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

    /// Default: rightViewController.preferredStatusBarUpdateAnimation ?? rootViewStatusBarUpdateAnimation
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

    @IBInspectable
    open var isLeftViewStatusBarBackgroundVisible: Bool = true

    open var isLeftViewStatusBarBackgroundHidden: Bool {
        set {
            isLeftViewStatusBarBackgroundVisible = !newValue
        }
        get {
            return !isLeftViewStatusBarBackgroundVisible
        }
    }

    @IBInspectable
    open var isRightViewStatusBarBackgroundVisible: Bool = true

    open var isRightViewStatusBarBackgroundHidden: Bool {
        set {
            isRightViewStatusBarBackgroundVisible = !newValue
        }
        get {
            return !isRightViewStatusBarBackgroundVisible
        }
    }

    // MARK: - Status Bar Background Color -

    @IBInspectable
    open var leftViewStatusBarBackgroundColor: UIColor = .clear

    @IBInspectable
    open var rightViewStatusBarBackgroundColor: UIColor = .clear

    // MARK: - Status Bar Background Blur Effect -

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
    open var _leftViewStatusBarBackgroundBlurEffect: UIBlurEffect?
    open var _isLeftViewStatusBarBackgroundBlurEffectAssigned: Bool = false

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
    open var _rightViewStatusBarBackgroundBlurEffect: UIBlurEffect?
    open var _isRightViewStatusBarBackgroundBlurEffectAssigned: Bool = false

    // MARK: - Status Bar Background Alpha -

    @IBInspectable
    open var leftViewStatusBarBackgroundAlpha: CGFloat = 1.0

    @IBInspectable
    open var rightViewStatusBarBackgroundAlpha: CGFloat = 1.0

    // MARK: - Status Bar Background Shadow Color -

    @IBInspectable
    open var leftViewStatusBarBackgroundShadowColor: UIColor = .clear

    @IBInspectable
    open var rightViewStatusBarBackgroundShadowColor: UIColor = .clear

    // MARK: - Status Bar Background Shadow Radius -

    @IBInspectable
    open var leftViewStatusBarBackgroundShadowRadius: CGFloat = 0.0

    @IBInspectable
    open var rightViewStatusBarBackgroundShadowRadius: CGFloat = 0.0

    // MARK: - Alpha -

    open var rootViewAlphaWhenHidden: CGFloat?

    /// Default:
    /// rootViewAlphaWhenHidden if assigned
    /// else 1.0
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

    /// Default:
    /// rootViewAlphaWhenHidden if assigned
    /// else 1.0
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

    /// Default:
    /// if presentationStyle == .scaleFromBig then 0.0
    /// if presentationStyle == .scaleFromLittle then 0.0
    /// else 1.0
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

    /// Default:
    /// if presentationStyle == .scaleFromBig then 0.0
    /// if presentationStyle == .scaleFromLittle then 0.0
    /// else 1.0
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

    open var rootViewOffsetWhenHidden: CGPoint?

    /// Default:
    /// rootViewOffsetWhenHidden if assigned
    /// else .zero
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

    /// Default:
    /// rootViewOffsetWhenHidden if assigned
    /// else .zero
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

    /// Default:
    /// if presentationStyle == .slideBelowShifted then CGPoint(x: -(leftViewWidth / 2.0), y: 0.0)
    /// else .zero
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

    /// Default:
    /// if presentationStyle == .slideBelowShifted then CGPoint(x: rightViewWidth / 2.0, y: 0.0)
    /// else .zero
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

    @IBInspectable
    open var leftViewOffsetWhenShowing: CGPoint = .zero

    @IBInspectable
    open var rightViewOffsetWhenShowing: CGPoint = .zero

    // MARK: - Scale -

    open var rootViewScaleWhenHidden: CGFloat?

    /// Default:
    /// rootViewScaleWhenHidden if assigned
    /// if presentationStyle.shouldRootViewScale then 0.8
    /// else 1.0
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

    /// Default:
    /// rootViewScaleWhenHidden if assigned
    /// if presentationStyle.shouldRootViewScale then 0.8
    /// else 1.0
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

    /// Default:
    /// if presentationStyle == .scaleFromBig then 1.2
    /// if presentationStyle == .scaleFromLittle then 0.8
    /// else 1.0
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

    /// Default:
    /// if presentationStyle == .scaleFromBig then 1.2
    /// if presentationStyle == .scaleFromLittle then 0.8
    /// else 1.0
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

    /// Default:
    /// if presentationStyle == .scaleFromBig then 1.4
    /// else 1.0
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

    /// Default:
    /// if presentationStyle == .scaleFromBig then 1.4
    /// else 1.0
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

    /// Default:
    /// if presentationStyle == .scaleFromLittle then 1.4
    /// else 1.0
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

    /// Default:
    /// if presentationStyle == .scaleFromLittle then 1.4
    /// else 1.0
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

    /// Default:
    /// if presentationStyle == .slideBelowShifted then CGPoint(x: -(leftViewWidth / 2.0), y: 0.0)
    /// else .zero
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

    /// Default:
    /// if presentationStyle == .slideBelowShifted then CGPoint(x: rightViewWidth / 2.0, y: 0.0)
    /// else .zero
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

    @IBInspectable
    open var leftViewBackgroundOffsetWhenShowing: CGPoint = .zero

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
    /// You can retrieve percentage between 0.0 and 1.0 from userInfo dictionary, where
    /// 0.0 - view is fully shown
    /// 1.0 - view is fully hidden
    open var didTransformRootView: TransformCallback?

    /// This callback is executed on every transformation of left view during showing/hiding
    /// You can retrieve percentage between 0.0 and 1.0 from userInfo dictionary, where
    /// 0.0 - view is fully hidden
    /// 1.0 - view is fully shown
    open var didTransformLeftView: TransformCallback?

    /// This callback is executed on every transformation of right view during showing/hiding
    /// You can retrieve percentage between 0.0 and 1.0 from userInfo dictionary, where
    /// 0.0 - view is fully hidden
    /// 1.0 - view is fully shown
    open var didTransformRightView: TransformCallback?

    // MARK: - Delegate -

    open var delegate: LGSideMenuDelegate?

    // MARK: - Internal Properties -

    open internal(set) var state: State = .rootViewIsShowing

    open internal(set) var isAnimating = false

    open internal(set) var isNeedsUpdateLayoutsAndStyles: Bool = false
    open internal(set) var isNeedsUpdateRootViewLayoutsAndStyles: Bool = false
    open internal(set) var isNeedsUpdateLeftViewLayoutsAndStyles: Bool = false
    open internal(set) var isNeedsUpdateRightViewLayoutsAndStyles: Bool = false

    /// View that contains all root-related views
    /// This view does not clip to bounds
    open internal(set) var rootContainerView: UIView?

    /// View that contains all root-related views except background views
    /// This view located right inside border and clips to bounds
    open internal(set) var rootContainerClipToBorderView: UIView?

    open internal(set) var rootViewBackgroundDecorationView: LGSideMenuBackgroundDecorationView?
    open internal(set) var rootViewBackgroundShadowView: LGSideMenuBackgroundShadowView?
    open internal(set) var rootViewWrapperView: LGSideMenuWrapperView?
    open internal(set) var rootViewCoverView: UIVisualEffectView?

    /// View that contains all left-related views
    /// This view clips to bounds
    open internal(set) var leftContainerView: UIView?

    /// View that contains all left-related views except background views
    /// This view located right inside border and clips to bounds
    open internal(set) var leftContainerClipToBorderView: UIView?

    open internal(set) var leftViewBackgroundDecorationView: LGSideMenuBackgroundDecorationView?
    open internal(set) var leftViewBackgroundShadowView: LGSideMenuBackgroundShadowView?
    open internal(set) var leftViewBackgroundWrapperView: UIView?
    open internal(set) var leftViewBackgroundImageView: UIImageView?
    open internal(set) var leftViewBackgroundEffectView: UIVisualEffectView?
    open internal(set) var leftViewWrapperView: LGSideMenuWrapperView?
    open internal(set) var leftViewCoverView: UIVisualEffectView?
    open internal(set) var leftViewStatusBarBackgroundView: LGSideMenuStatusBarBackgroundView?
    open internal(set) var leftViewStatusBarBackgroundEffectView: UIVisualEffectView?

    /// View that contains all right-related views
    /// This view clips to bounds
    open internal(set) var rightContainerView: UIView?

    /// View that contains all right-related views except background views
    /// This view located right inside border and clips to bounds
    open internal(set) var rightContainerClipToBorderView: UIView?

    open internal(set) var rightViewBackgroundDecorationView: LGSideMenuBackgroundDecorationView?
    open internal(set) var rightViewBackgroundShadowView: LGSideMenuBackgroundShadowView?
    open internal(set) var rightViewBackgroundWrapperView: UIView?
    open internal(set) var rightViewBackgroundImageView: UIImageView?
    open internal(set) var rightViewBackgroundEffectView: UIVisualEffectView?
    open internal(set) var rightViewWrapperView: LGSideMenuWrapperView?
    open internal(set) var rightViewCoverView: UIVisualEffectView?
    open internal(set) var rightViewStatusBarBackgroundView: LGSideMenuStatusBarBackgroundView?
    open internal(set) var rightViewStatusBarBackgroundEffectView: UIVisualEffectView?

    internal var savedSize: CGSize = .zero

    internal var leftViewGestureStartX: CGFloat?
    internal var rightViewGestureStartX: CGFloat?

    internal var isLeftViewShowingBeforeGesture: Bool = false
    internal var isRightViewShowingBeforeGesture: Bool = false

    internal var shouldUpdateVisibility: Bool = true

    internal var isRotationInvalidatedLayout: Bool = false

    internal var isRootViewLayoutingEnabled: Bool = true
    internal var isRootViewControllerLayoutingEnabled: Bool = true

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
            self.tryPerformRootSegueIfNeeded()
            self.tryPerformLeftSegueIfNeeded()
            self.tryPerformRightSegueIfNeeded()
        }
    }

    // MARK: - Segues -

    open func tryPerformRootSegueIfNeeded() {
        guard self.storyboard != nil,
              _rootViewController == nil,
              LGSideMenuHelper.canPerformSegue(self, withIdentifier: LGSideMenuSegue.Identifier.root) else { return }
        self.performSegue(withIdentifier: LGSideMenuSegue.Identifier.root, sender: self)
    }

    open func tryPerformLeftSegueIfNeeded() {
        guard self.storyboard != nil,
              _leftViewController == nil,
              LGSideMenuHelper.canPerformSegue(self, withIdentifier: LGSideMenuSegue.Identifier.left) else { return }
        self.performSegue(withIdentifier: LGSideMenuSegue.Identifier.left, sender: self)
    }

    open func tryPerformRightSegueIfNeeded() {
        guard self.storyboard != nil,
              _rightViewController == nil,
              LGSideMenuHelper.canPerformSegue(self, withIdentifier: LGSideMenuSegue.Identifier.right) else { return }
        self.performSegue(withIdentifier: LGSideMenuSegue.Identifier.right, sender: self)
    }

    // MARK: - Layouting -

    /// Called when root view is layouting subviews
    open func rootViewLayoutSubviews() {
        // only for overriding
    }

    /// Called when left view is layouting subviews
    open func leftViewLayoutSubviews() {
        // only for overriding
    }

    /// Called when right view is layouting subviews
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
