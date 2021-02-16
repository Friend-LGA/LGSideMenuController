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

    public struct SegueIdentifier {
        public static let root  = "root"
        public static let left  = "left"
        public static let right = "right"
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

        public init(rawValue: Int = 0) {
            self.rawValue = rawValue
        }

        public var isEmpty: Bool {
            return self == []
        }

        public var isAlwaysVisibleForCurrentOrientation: Bool {
            return self.isAlwaysVisibleForOrientation(UIApplication.shared.statusBarOrientation)
        }

        public func isAlwaysVisibleForOrientation(_ orientation: UIInterfaceOrientation) -> Bool {
            return self.contains(.all) ||
                (orientation.isPortrait && self.contains(.portrait)) ||
                (orientation.isLandscape && self.contains(.landscape)) ||
                (LGSideMenuHelper.isPhone() &&
                    (self.contains(.phone) ||
                        (orientation.isPortrait && self.contains(.phonePortrait)) ||
                        (orientation.isLandscape && self.contains(.phoneLandscape)))) ||
                (LGSideMenuHelper.isPad() &&
                    (self.contains(.pad) ||
                        (orientation.isPortrait && self.contains(.padPortrait)) ||
                        (orientation.isLandscape && self.contains(.padLandscape))))
        }
    }

    public enum PresentationStyle {
        case slideAbove
        case slideBelow
        case scaleFromBig
        case scaleFromLittle
        // TODO: Add slideAside

        public init() {
            self = .slideAbove
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
            return !self.isLeftViewVisible
        }

        public var isRightViewHidden: Bool {
            return !self.isRightViewVisible
        }
    }

    // MARK: - Public Basic Properties

    open var rootViewController: UIViewController? {
        willSet {
            self.removeRootViewController()
        }
        didSet {
            guard let rootViewController = rootViewController else { return }
            LGSideMenuHelper.setSideMenuController(self, to: rootViewController)
            rootViewController.removeFromParent()
            if self.isRootViewShowing {
                self.addChild(rootViewController)
            }
            self.rootView = rootViewController.view
        }
    }

    open var leftViewController: UIViewController? {
        willSet {
            self.removeLeftViewController()
        }
        didSet {
            guard let leftViewController = leftViewController else { return }
            LGSideMenuHelper.setSideMenuController(self, to: leftViewController)
            leftViewController.removeFromParent()
            if self.isLeftViewShowing {
                self.addChild(leftViewController)
            }
            self.leftView = leftViewController.view
        }
    }

    open var rightViewController: UIViewController? {
        willSet {
            self.removeRightViewController()
        }
        didSet {
            guard let rightViewController = rightViewController else { return }
            LGSideMenuHelper.setSideMenuController(self, to: rightViewController)
            rightViewController.removeFromParent()
            if self.isRightViewShowing {
                self.addChild(rightViewController)
            }
            self.rightView = rightViewController.view
        }
    }

    open var rootView: UIView? {
        willSet {
            if newValue == nil {
                self.removeRootViews()
            }
        }
        didSet {
            guard self.rootView != nil else { return }
            self.setNeedsUpdateRootViewLayoutsAndStyles()
        }
    }

    open var leftView: UIView? {
        willSet {
            if newValue == nil {
                self.removeLeftViews()
            }
        }
        didSet {
            guard self.leftView != nil else { return }
            self.setNeedsUpdateLeftViewLayoutsAndStyles()
        }
    }

    open var rightView: UIView? {
        willSet {
            if newValue == nil {
                self.removeRightViews()
            }
        }
        didSet {
            guard self.rightView != nil else { return }
            self.setNeedsUpdateRightViewLayoutsAndStyles()
        }
    }

    public let tapGesture: UITapGestureRecognizer
    public let panGestureForLeftView: UIPanGestureRecognizer
    public let panGestureForRightView: UIPanGestureRecognizer

    // MARK: - Public Non-Conditional Configurable Properties

    /// Default:
    /// if iPhone { MainScreen.size.min - 44.0 }
    /// else 320.0
    @IBInspectable open var leftViewWidth: CGFloat = {
        var sideMenuWidth: CGFloat = 320.0
        if LGSideMenuHelper.isPhone() {
            let minSide = min(UIScreen.main.bounds.width, UIScreen.main.bounds.height)
            sideMenuWidth = minSide - 44.0
        }
        return sideMenuWidth
    }() {
        didSet {
            self.setNeedsUpdateLayoutsAndStyles()
        }
    }

    /// Default:
    /// if iPhone { MainScreen.size.min - 44.0 }
    /// else 320.0
    @IBInspectable open var rightViewWidth: CGFloat = {
        var sideMenuWidth: CGFloat = 320.0
        if LGSideMenuHelper.isPhone() {
            let minSide = min(UIScreen.main.bounds.width, UIScreen.main.bounds.height)
            sideMenuWidth = minSide - 44.0
        }
        return sideMenuWidth
    }() {
        didSet {
            self.setNeedsUpdateLayoutsAndStyles()
        }
    }

    open var leftViewPresentationStyle: PresentationStyle = .slideAbove {
        didSet {
            self.validateAlwaysVisibleConflict()
            self.setNeedsUpdateLayoutsAndStyles()
        }
    }

    open var rightViewPresentationStyle: PresentationStyle = .slideAbove {
        didSet {
            self.validateAlwaysVisibleConflict()
            self.setNeedsUpdateLayoutsAndStyles()
        }
    }

    open var leftViewAlwaysVisibleOptions: AlwaysVisibleOptions = [] {
        didSet {
            self.validateAlwaysVisibleConflict()
            self.setNeedsUpdateLayoutsAndStyles()
        }
    }

    open var rightViewAlwaysVisibleOptions: AlwaysVisibleOptions = [] {
        didSet {
            self.validateAlwaysVisibleConflict()
            self.setNeedsUpdateLayoutsAndStyles()
        }
    }

    @IBInspectable open var isLeftViewHidesOnTouch: Bool = true
    @IBInspectable open var isRightViewHidesOnTouch: Bool = true

    @IBInspectable open var isLeftViewSwipeGestureEnabled: Bool = true
    @IBInspectable open var isRightViewSwipeGestureEnabled: Bool = true

    open var isLeftViewSwipeGestureDisabled: Bool {
        set {
            self.isLeftViewSwipeGestureEnabled = !newValue
        }
        get {
            return !self.isLeftViewSwipeGestureEnabled
        }
    }

    open var isRightViewSwipeGestureDisabled: Bool {
        set {
            self.isRightViewSwipeGestureEnabled = !newValue
        }
        get {
            return !self.isRightViewSwipeGestureEnabled
        }
    }

    open var swipeGestureArea: SwipeGestureArea = .borders

    /// Only if swipeGestureArea == .borders
    /// Default is SwipeGestureRange(left: 0.0, right: 44.0)
    /// Explanation:
    /// For SwipeGestureRange(left: 44.0, right: 44.0) => leftView 44.0 | 44.0 rootView
    /// For SwipeGestureRange(left: 0.0, right: 44.0)  => leftView  0.0 | 44.0 rootView
    /// For SwipeGestureRange(left: 44.0, right: 0.0)  => leftView 44.0 | 0.0  rootView
    open var leftViewSwipeGestureRange = SwipeGestureRange(left: 0.0, right: 44.0)

    /// Only if swipeGestureArea == .borders
    /// Default is SwipeGestureRange(left: 44.0, right: 0.0)
    /// Explanation:
    /// For SwipeGestureRange(left: 44.0, right: 44.0) => rootView 44.0 | 44.0 rightView
    /// For SwipeGestureRange(left: 0.0, right: 44.0)  => rootView  0.0 | 44.0 rightView
    /// For SwipeGestureRange(left: 44.0, right: 0.0)  => rootView 44.0 | 0.0  rightView
    open var rightViewSwipeGestureRange = SwipeGestureRange(left: 44.0, right: 0.0)

    @IBInspectable open var leftViewAnimationDuration: TimeInterval = 0.5
    @IBInspectable open var rightViewAnimationDuration: TimeInterval = 0.5

    // TODO: Add custom timing function

    @IBInspectable open var shouldHideLeftViewAnimated: Bool = true
    @IBInspectable open var shouldHideRightViewAnimated: Bool = true

    @IBInspectable open var isLeftViewEnabled: Bool = true
    @IBInspectable open var isRightViewEnabled: Bool = true

    open var isLeftViewDisabled: Bool {
        set {
            self.isLeftViewEnabled = !newValue
        }
        get {
            return !self.isLeftViewEnabled
        }
    }

    open var isRightViewDisabled: Bool {
        set {
            self.isRightViewEnabled = !newValue
        }
        get {
            return !self.isRightViewEnabled
        }
    }

    @IBInspectable open var rootViewBackgroundColor: UIColor = .clear {
        didSet {
            self.setNeedsUpdateLayoutsAndStyles()
        }
    }

    @IBInspectable open var leftViewBackgroundColor: UIColor = .clear {
        didSet {
            self.setNeedsUpdateLayoutsAndStyles()
        }
    }

    @IBInspectable open var rightViewBackgroundColor: UIColor = .clear {
        didSet {
            self.setNeedsUpdateLayoutsAndStyles()
        }
    }

    /// Only if presentationStyle != .slideAbove
    @IBInspectable open var leftViewBackgroundImage: UIImage? {
        didSet {
            self.setNeedsUpdateLayoutsAndStyles()
        }
    }

    /// Only if presentationStyle != .slideAbove
    @IBInspectable open var rightViewBackgroundImage: UIImage? {
        didSet {
            self.setNeedsUpdateLayoutsAndStyles()
        }
    }

    /// Only if presentationStyle == .slideAbove
    @IBInspectable open var leftViewBackgroundBlurEffect: UIBlurEffect?
    /// Only if presentationStyle == .slideAbove
    @IBInspectable open var rightViewBackgroundBlurEffect: UIBlurEffect?

    /// Only if presentationStyle == .slideAbove
    @IBInspectable open var leftViewBackgroundAlpha: CGFloat = 1.0
    /// Only if presentationStyle == .slideAbove
    @IBInspectable open var rightViewBackgroundAlpha: CGFloat = 1.0

    @IBInspectable open var rootViewLayerBorderColor: UIColor = .clear
    /// Only if presentationStyle == .slideAbove
    @IBInspectable open var leftViewLayerBorderColor: UIColor = .clear
    /// Only if presentationStyle == .slideAbove
    @IBInspectable open var rightViewLayerBorderColor: UIColor = .clear

    @IBInspectable open var rootViewLayerBorderWidth: CGFloat = 0.0
    /// Only if presentationStyle == .slideAbove
    @IBInspectable open var leftViewLayerBorderWidth: CGFloat = 0.0
    /// Only if presentationStyle == .slideAbove
    @IBInspectable open var rightViewLayerBorderWidth: CGFloat = 0.0

    @IBInspectable open var rootViewLayerShadowColor = UIColor(white: 0.0, alpha: 0.5)
    /// Only if presentationStyle == .slideAbove
    @IBInspectable open var leftViewLayerShadowColor = UIColor(white: 0.0, alpha: 0.5)
    /// Only if presentationStyle == .slideAbove
    @IBInspectable open var rightViewLayerShadowColor = UIColor(white: 0.0, alpha: 0.5)

    @IBInspectable open var rootViewLayerShadowRadius: CGFloat = 5.0
    /// Only if presentationStyle == .slideAbove
    @IBInspectable open var leftViewLayerShadowRadius: CGFloat = 5.0
    /// Only if presentationStyle == .slideAbove
    @IBInspectable open var rightViewLayerShadowRadius: CGFloat = 5.0

    @IBInspectable open var rootViewCoverBlurEffectForLeftView: UIBlurEffect?
    @IBInspectable open var rootViewCoverBlurEffectForRightView: UIBlurEffect?
    /// Only if presentationStyle != .slideAbove
    @IBInspectable open var leftViewCoverBlurEffect: UIBlurEffect?
    /// Only if presentationStyle != .slideAbove
    @IBInspectable open var rightViewCoverBlurEffect: UIBlurEffect?

    @IBInspectable open var rootViewCoverAlphaForLeftView: CGFloat = 1.0
    @IBInspectable open var rootViewCoverAlphaForRightView: CGFloat = 1.0
    /// Only if presentationStyle != .slideAbove
    @IBInspectable open var leftViewCoverAlpha: CGFloat = 1.0
    /// Only if presentationStyle != .slideAbove
    @IBInspectable open var rightViewCoverAlpha: CGFloat = 1.0

    // MARK: - Public Conditional Configurable Properties

    /// Default:
    /// if rootViewController != nil then rootViewController.prefersStatusBarHidden
    /// else self.prefersStatusBarHidden
    @IBInspectable open var isRootViewStatusBarHidden: Bool {
        set {
            _isRootViewStatusBarHidden = newValue
        }
        get {
            if let isRootViewStatusBarHidden = _isRootViewStatusBarHidden {
                return isRootViewStatusBarHidden
            }
            if let rootViewController = self.rootViewController {
                return rootViewController.prefersStatusBarHidden
            }
            return self.prefersStatusBarHidden
        }
    }
    private var _isRootViewStatusBarHidden: Bool?

    /// Default:
    /// if leftViewController != nil then leftViewController.prefersStatusBarHidden
    /// else self.rootViewStatusBarHidden
    @IBInspectable open var isLeftViewStatusBarHidden: Bool {
        set {
            _isLeftViewStatusBarHidden = newValue
        }
        get {
            if let isLeftViewStatusBarHidden = _isLeftViewStatusBarHidden {
                return isLeftViewStatusBarHidden
            }
            if let leftViewController = self.leftViewController {
                return leftViewController.prefersStatusBarHidden
            }
            return self.isRootViewStatusBarHidden
        }
    }
    private var _isLeftViewStatusBarHidden: Bool?

    /// Default:
    /// if rightViewController != nil then rightViewController.prefersStatusBarHidden
    /// else self.rootViewStatusBarHidden
    @IBInspectable open var isRightViewStatusBarHidden: Bool {
        set {
            _isRightViewStatusBarHidden = newValue
        }
        get {
            if let isRightViewStatusBarHidden = _isRightViewStatusBarHidden {
                return isRightViewStatusBarHidden
            }
            if let rightViewController = self.rightViewController {
                return rightViewController.prefersStatusBarHidden
            }
            return self.isRootViewStatusBarHidden
        }
    }
    private var _isRightViewStatusBarHidden: Bool?

    /// Default:
    /// if rootViewController != nil then rootViewController.preferredStatusBarStyle
    /// else self.preferredStatusBarStyle
    @IBInspectable open var rootViewStatusBarStyle: UIStatusBarStyle {
        set {
            _rootViewStatusBarStyle = newValue
        }
        get {
            if let rootViewStatusBarStyle = _rootViewStatusBarStyle {
                return rootViewStatusBarStyle
            }
            if let rootViewController = self.rootViewController {
                return rootViewController.preferredStatusBarStyle
            }
            return self.preferredStatusBarStyle
        }
    }
    private var _rootViewStatusBarStyle: UIStatusBarStyle?

    /// Default:
    /// if leftViewController != nil then leftViewController.preferredStatusBarStyle
    /// else self.rootViewStatusBarStyle
    @IBInspectable open var leftViewStatusBarStyle: UIStatusBarStyle {
        set {
            _leftViewStatusBarStyle = newValue
        }
        get {
            if let leftViewStatusBarStyle = _leftViewStatusBarStyle {
                return leftViewStatusBarStyle
            }
            if let leftViewController = self.leftViewController {
                return leftViewController.preferredStatusBarStyle
            }
            return self.rootViewStatusBarStyle
        }
    }
    private var _leftViewStatusBarStyle: UIStatusBarStyle?

    /// Default:
    /// if rightViewController != nil then rightViewController.preferredStatusBarStyle
    /// else self.rootViewStatusBarStyle
    @IBInspectable open var rightViewStatusBarStyle: UIStatusBarStyle {
        set {
            _rightViewStatusBarStyle = newValue
        }
        get {
            if let rightViewStatusBarStyle = _rightViewStatusBarStyle {
                return rightViewStatusBarStyle
            }
            if let rightViewController = self.rightViewController {
                return rightViewController.preferredStatusBarStyle
            }
            return self.rootViewStatusBarStyle
        }
    }
    private var _rightViewStatusBarStyle: UIStatusBarStyle?

    /// Default:
    /// if rootViewController != nil then rootViewController.preferredStatusBarUpdateAnimation
    /// else self.preferredStatusBarUpdateAnimation
    @IBInspectable open var rootViewStatusBarUpdateAnimation: UIStatusBarAnimation {
        set {
            _rootViewStatusBarUpdateAnimation = newValue
        }
        get {
            if let rootViewStatusBarUpdateAnimation = _rootViewStatusBarUpdateAnimation {
                return rootViewStatusBarUpdateAnimation
            }
            if let rootViewController = self.rootViewController {
                return rootViewController.preferredStatusBarUpdateAnimation
            }
            return self.preferredStatusBarUpdateAnimation
        }
    }
    private var _rootViewStatusBarUpdateAnimation: UIStatusBarAnimation?

    /// Default:
    /// if leftViewController != nil then leftViewController.preferredStatusBarUpdateAnimation
    /// else self.rootViewStatusBarUpdateAnimation
    @IBInspectable open var leftViewStatusBarUpdateAnimation: UIStatusBarAnimation {
        set {
            _leftViewStatusBarUpdateAnimation = newValue
        }
        get {
            if let leftViewStatusBarUpdateAnimation = _leftViewStatusBarUpdateAnimation {
                return leftViewStatusBarUpdateAnimation
            }
            if let leftViewController = self.leftViewController {
                return leftViewController.preferredStatusBarUpdateAnimation
            }
            return self.rootViewStatusBarUpdateAnimation
        }
    }
    private var _leftViewStatusBarUpdateAnimation: UIStatusBarAnimation?

    /// Default:
    /// if rightViewController != nil then rightViewController.preferredStatusBarUpdateAnimation
    /// else self.rootViewStatusBarUpdateAnimation
    @IBInspectable open var rightViewStatusBarUpdateAnimation: UIStatusBarAnimation {
        set {
            _rightViewStatusBarUpdateAnimation = newValue
        }
        get {
            if let rightViewStatusBarUpdateAnimation = _rightViewStatusBarUpdateAnimation {
                return rightViewStatusBarUpdateAnimation
            }
            if let rightViewController = self.rightViewController {
                return rightViewController.preferredStatusBarUpdateAnimation
            }
            return self.rootViewStatusBarUpdateAnimation
        }
    }
    private var _rightViewStatusBarUpdateAnimation: UIStatusBarAnimation?

    /// Color that hides root view, when left view is showing
    /// Default:
    /// if presentationStyle == .slideAbove then UIColor(white: 0.0, alpha: 0.5)
    /// else .clear
    @IBInspectable open var rootViewCoverColorForLeftView: UIColor {
        set {
            _rootViewCoverColorForLeftView = newValue
        }
        get {
            if let rootViewCoverColorForLeftView = _rootViewCoverColorForLeftView {
                return rootViewCoverColorForLeftView
            }
            if self.leftViewPresentationStyle == .slideAbove {
                return UIColor(white: 0.0, alpha: 0.5)
            }
            return .clear
        }
    }
    private var _rootViewCoverColorForLeftView: UIColor?

    /// Color that hides root view, when right view is showing
    /// Default:
    /// if presentationStyle == .slideAbove then UIColor(white: 0.0, alpha: 0.5)
    /// else .clear
    @IBInspectable open var rootViewCoverColorForRightView: UIColor {
        set {
            _rootViewCoverColorForRightView = newValue
        }
        get {
            if let rootViewCoverColorForRightView = _rootViewCoverColorForRightView {
                return rootViewCoverColorForRightView
            }
            if self.rightViewPresentationStyle == .slideAbove {
                return UIColor(white: 0.0, alpha: 0.5)
            }
            return .clear
        }
    }
    private var _rootViewCoverColorForRightView: UIColor?

    /// Color that hides left view, when it is not showing
    /// Default:
    /// if presentationStyle == .slideAbove then .clear
    /// else UIColor(white: 0.0, alpha: 0.5)
    @IBInspectable open var leftViewCoverColor: UIColor {
        set {
            _leftViewCoverColor = newValue
        }
        get {
            if let leftViewCoverColor = _leftViewCoverColor {
                return leftViewCoverColor
            }
            if self.leftViewPresentationStyle == .slideAbove {
                return .clear
            }
            return UIColor(white: 0.0, alpha: 0.5)
        }
    }
    private var _leftViewCoverColor: UIColor?

    /// Color that hides right view, when it is not showing
    /// Default:
    /// if presentationStyle == .slideAbove then .clear
    /// else UIColor(white: 0.0, alpha: 0.5)
    @IBInspectable open var rightViewCoverColor: UIColor {
        set {
            _rightViewCoverColor = newValue
        }
        get {
            if let rightViewCoverColor = _rightViewCoverColor {
                return rightViewCoverColor
            }
            if self.rightViewPresentationStyle == .slideAbove {
                return .clear
            }
            return UIColor(white: 0.0, alpha: 0.5)
        }
    }
    private var _rightViewCoverColor: UIColor?

    /// Only if presentationStyle != .slideAbove
    /// Default:
    /// if presentationStyle == .scaleFromBig then 0.8
    /// if presentationStyle == .scaleFromLittle then 0.8
    /// else 1.0
    @IBInspectable open var rootViewScaleForLeftView: CGFloat {
        set {
            _rootViewScaleForLeftView = newValue
        }
        get {
            guard self.leftViewPresentationStyle != .slideAbove else {
                return 1.0
            }
            if let rootViewScaleForLeftView = _rootViewScaleForLeftView {
                return rootViewScaleForLeftView
            }
            if self.leftViewPresentationStyle == .scaleFromBig || self.leftViewPresentationStyle == .scaleFromLittle {
                return 0.8
            }
            return 1.0
        }
    }
    private var _rootViewScaleForLeftView: CGFloat?

    /// Only if presentationStyle != .slideAbove
    /// Default:
    /// if presentationStyle == .scaleFromBig then 0.8
    /// if presentationStyle == .scaleFromLittle then 0.8
    /// else 1.0
    @IBInspectable open var rootViewScaleForRightView: CGFloat {
        set {
            _rootViewScaleForRightView = newValue
        }
        get {
            guard self.rightViewPresentationStyle != .slideAbove else {
                return 1.0
            }
            if let rootViewScaleForRightView = _rootViewScaleForRightView {
                return rootViewScaleForRightView
            }
            if self.rightViewPresentationStyle == .scaleFromBig || self.rightViewPresentationStyle == .scaleFromLittle {
                return 0.8
            }
            return 1.0
        }
    }
    private var _rootViewScaleForRightView: CGFloat?

    /// Only if presentationStyle != .slideAbove
    /// Default:
    /// if presentationStyle == .scaleFromBig then 1.2
    /// if presentationStyle == .scaleFromLittle then 0.8
    /// else 1.0
    @IBInspectable open var leftViewInitialScale: CGFloat {
        set {
            _leftViewInitialScale = newValue
        }
        get {
            guard self.leftViewPresentationStyle != .slideAbove else {
                return 1.0
            }
            if let leftViewInitialScale = _leftViewInitialScale {
                return leftViewInitialScale
            }
            if self.leftViewPresentationStyle == .scaleFromBig {
                return 1.2
            }
            if self.leftViewPresentationStyle == .scaleFromLittle {
                return 0.8
            }
            return 1.0
        }
    }
    private var _leftViewInitialScale: CGFloat?

    /// Only if presentationStyle != .slideAbove
    /// Default:
    /// if presentationStyle == .scaleFromBig then 1.2
    /// if presentationStyle == .scaleFromLittle then 0.8
    /// else 1.0
    @IBInspectable open var rightViewInitialScale: CGFloat {
        set {
            _rightViewInitialScale = newValue
        }
        get {
            guard self.rightViewPresentationStyle != .slideAbove else {
                return 1.0
            }
            if let rightViewInitialScale = _rightViewInitialScale {
                return rightViewInitialScale
            }
            if self.rightViewPresentationStyle == .scaleFromBig {
                return 1.2
            }
            if self.rightViewPresentationStyle == .scaleFromLittle {
                return 0.8
            }
            return 1.0
        }
    }
    private var _rightViewInitialScale: CGFloat?

    /// Only if presentationStyle != .slideAbove
    /// Default:
    /// if presentationStyle == .slideBelow then -width/2
    /// else 0.0
    @IBInspectable open var leftViewInitialOffsetX: CGFloat {
        set {
            _leftViewInitialOffsetX = newValue
        }
        get {
            guard self.leftViewPresentationStyle != .slideAbove else {
                return 0.0
            }
            if let leftViewInitialOffsetX = _leftViewInitialOffsetX {
                return leftViewInitialOffsetX
            }
            if self.leftViewPresentationStyle == .slideBelow {
                return -(self.leftViewWidth / 2.0)
            }
            return 0.0
        }
    }
    private var _leftViewInitialOffsetX: CGFloat?

    /// Only if presentationStyle != .slideAbove
    /// Default:
    /// if presentationStyle == .slideBelow then width/2
    /// else 0.0
    @IBInspectable open var rightViewInitialOffsetX: CGFloat {
        set {
            _rightViewInitialOffsetX = newValue
        }
        get {
            guard self.rightViewPresentationStyle != .slideAbove else {
                return 0.0
            }
            if let rightViewInitialOffsetX = _rightViewInitialOffsetX {
                return rightViewInitialOffsetX
            }
            if self.rightViewPresentationStyle == .slideBelow {
                return self.rightViewWidth / 2.0
            }
            return 0.0
        }
    }
    private var _rightViewInitialOffsetX: CGFloat?

    /// Only if presentationStyle != .slideAbove
    /// Default:
    /// if presentationStyle == .scaleFromBig then 1.4
    /// else 1.0
    @IBInspectable open var leftViewBackgroundImageInitialScale: CGFloat {
        set {
            _leftViewBackgroundImageInitialScale = newValue
        }
        get {
            guard self.leftViewPresentationStyle != .slideAbove else {
                return 1.0
            }
            if let leftViewBackgroundImageInitialScale = _leftViewBackgroundImageInitialScale {
                return leftViewBackgroundImageInitialScale
            }
            if self.leftViewPresentationStyle == .scaleFromBig {
                return 1.4
            }
            return 1.0
        }
    }
    private var _leftViewBackgroundImageInitialScale: CGFloat?

    /// Only if presentationStyle != .slideAbove
    /// Default:
    /// if presentationStyle == .scaleFromBig then 1.4
    /// else 1.0
    @IBInspectable open var rightViewBackgroundImageInitialScale: CGFloat {
        set {
            _rightViewBackgroundImageInitialScale = newValue
        }
        get {
            guard self.rightViewPresentationStyle != .slideAbove else {
                return 1.0
            }
            if let rightViewBackgroundImageInitialScale = _rightViewBackgroundImageInitialScale {
                return rightViewBackgroundImageInitialScale
            }
            if self.rightViewPresentationStyle == .scaleFromBig {
                return 1.4
            }
            return 1.0
        }
    }
    private var _rightViewBackgroundImageInitialScale: CGFloat?

    /// Only if presentationStyle != .slideAbove
    /// Default:
    /// if presentationStyle == .scaleFromLittle then 1.4
    /// else 1.0
    @IBInspectable open var leftViewBackgroundImageFinalScale: CGFloat {
        set {
            _leftViewBackgroundImageFinalScale = newValue
        }
        get {
            guard self.leftViewPresentationStyle != .slideAbove else {
                return 1.0
            }
            if let leftViewBackgroundImageFinalScale = _leftViewBackgroundImageFinalScale {
                return leftViewBackgroundImageFinalScale
            }
            if self.leftViewPresentationStyle == .scaleFromLittle {
                return 1.4
            }
            return 1.0
        }
    }
    private var _leftViewBackgroundImageFinalScale: CGFloat?

    /// Only if presentationStyle != .slideAbove
    /// Default:
    /// if presentationStyle == .scaleFromLittle then 1.4
    /// else 1.0
    @IBInspectable open var rightViewBackgroundImageFinalScale: CGFloat {
        set {
            _rightViewBackgroundImageFinalScale = newValue
        }
        get {
            guard self.rightViewPresentationStyle != .slideAbove else {
                return 1.0
            }
            if let rightViewBackgroundImageFinalScale = _rightViewBackgroundImageFinalScale {
                return rightViewBackgroundImageFinalScale
            }
            if self.rightViewPresentationStyle == .scaleFromLittle {
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

    open internal(set) var leftViewBackgroundView: UIImageView?
    open internal(set) var rightViewBackgroundView: UIImageView?

    open internal(set) var isNeedsUpdateLayoutsAndStyles: Bool = false
    open internal(set) var isNeedsUpdateRootViewLayoutsAndStyles: Bool = false
    open internal(set) var isNeedsUpdateLeftViewLayoutsAndStyles: Bool = false
    open internal(set) var isNeedsUpdateRightViewLayoutsAndStyles: Bool = false

    /// Container for rootViewController or rootView. Usually you do not need to use it
    open internal(set) var rootContainerView: UIView?
    open internal(set) var rootViewBorderView: LGSideMenuBorderView?
    open internal(set) var rootViewWrapperView: UIView?
    open internal(set) var rootViewCoverView: UIVisualEffectView?

    /// Container for leftViewController or leftView. Usually you do not need to use it
    open internal(set) var leftContainerView: UIView?
    open internal(set) var leftViewBorderView: LGSideMenuBorderView?
    open internal(set) var leftViewEffectView: UIVisualEffectView?
    open internal(set) var leftViewWrapperView: UIView?
    open internal(set) var leftViewCoverView: UIVisualEffectView?

    /// Container for rightViewController or rightView. Usually you do not need to use it
    open internal(set) var rightContainerView: UIView?
    open internal(set) var rightViewBorderView: LGSideMenuBorderView?
    open internal(set) var rightViewEffectView: UIVisualEffectView?
    open internal(set) var rightViewWrapperView: UIView?
    open internal(set) var rightViewCoverView: UIVisualEffectView?

    internal var savedSize: CGSize = .zero

    internal var leftViewGestureStartX: CGFloat?
    internal var rightViewGestureStartX: CGFloat?

    internal var isLeftViewShowingBeforeGesture: Bool = false
    internal var isRightViewShowingBeforeGesture: Bool = false

    internal var shouldUpdateVisibility: Bool = true

    // MARK: - Initialization

    public init() {
        self.tapGesture = UITapGestureRecognizer()
        self.panGestureForLeftView = UIPanGestureRecognizer()
        self.panGestureForRightView = UIPanGestureRecognizer()

        super.init(nibName: nil, bundle: nil)

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
    }

    convenience public init(rootViewController: UIViewController? = nil, leftViewController: UIViewController? = nil, rightViewController: UIViewController? = nil) {
        self.init()

        self.rootViewController = rootViewController
        self.leftViewController = leftViewController
        self.rightViewController = rightViewController
    }

    convenience public init(rootView: UIView? = nil, leftView: UIView? = nil, rightView: UIView? = nil) {
        self.init()

        self.rootView = rootView
        self.leftView = leftView
        self.rightView = rightView
    }

    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    open override class func awakeFromNib() {
        super.awakeFromNib()
        // TODO: Check if this needs to be overriden
    }

    open override func viewDidLoad() {
        super.viewDidLoad()

        // Try to initialize root, left and right view controllers from storyboard by segues
        // TODO: Check if this needs to be wrapped into try - catch block
        if self.storyboard != nil {
            self.performSegue(withIdentifier: SegueIdentifier.root, sender: self)
            self.performSegue(withIdentifier: SegueIdentifier.left, sender: self)
            self.performSegue(withIdentifier: SegueIdentifier.right, sender: self)
        }
    }

    // TODO: Check if this method is appropriate
    open override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)

        guard let sender = sender as? LGSideMenuController, sender === self else { return }
        guard let source = segue.source as? LGSideMenuController else { return }

        if segue.identifier == SegueIdentifier.root {
            source.rootViewController = segue.destination
        }
        else if segue.identifier == SegueIdentifier.left {
            source.leftViewController = segue.destination
        }
        else if segue.identifier == SegueIdentifier.right {
            source.rightViewController = segue.destination
        }
    }

}
