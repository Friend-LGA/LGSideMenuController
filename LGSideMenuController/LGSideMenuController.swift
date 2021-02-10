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

        static let willShowLeftView = NSNotification.Name("LGSideMenuController.Notification.willShowLeftView")
        static let didShowLeftView  = NSNotification.Name("LGSideMenuController.Notification.didShowLeftView")

        static let willHideLeftView = NSNotification.Name("LGSideMenuController.Notification.willHideLeftView")
        static let didHideLeftView  = NSNotification.Name("LGSideMenuController.Notification.didHideLeftView")

        static let willShowRightView = NSNotification.Name("LGSideMenuController.Notification.willShowRightView")
        static let didShowRightView  = NSNotification.Name("LGSideMenuController.Notification.didShowRightView")

        static let willHideRightView = NSNotification.Name("LGSideMenuController.Notification.willHideRightView")
        static let didHideRightView  = NSNotification.Name("LGSideMenuController.Notification.didHideRightView")

        /// You can use this notification to add some custom animations
        static let showAnimationsForLeftView = NSNotification.Name("LGSideMenuController.Notification.showAnimationsForLeftView")
        /// You can use this notification to add some custom animations
        static let hideAnimationsForLeftView = NSNotification.Name("LGSideMenuController.Notification.hideAnimationsForLeftView")

        /// You can use this notification to add some custom animations
        static let showAnimationsForRightView = NSNotification.Name("LGSideMenuController.Notification.showAnimationsForRightView")
        /// You can use this notification to add some custom animations
        static let hideAnimationsForRightView = NSNotification.Name("LGSideMenuController.Notification.hideAnimationsForRightView")

        public struct Key {
            /// Key for userInfo dictionary which represents duration of the animation
            static let duration = "duration"
        }

    }

    public struct SegueIdentifier {
        static let root  = "root"
        static let left  = "left"
        static let right = "right"
    }

    public struct AlwaysVisibleOptions: OptionSet {
        public let rawValue: Int

        static let padLandscape   = AlwaysVisibleOptions(rawValue: 1 << 0)
        static let padPortrait    = AlwaysVisibleOptions(rawValue: 1 << 1)
        static let phoneLandscape = AlwaysVisibleOptions(rawValue: 1 << 2)
        static let phonePortrait  = AlwaysVisibleOptions(rawValue: 1 << 3)

        static let landscape: AlwaysVisibleOptions = [.padLandscape, .phoneLandscape]
        static let portrait: AlwaysVisibleOptions  = [.padPortrait, .phonePortrait]
        static let pad: AlwaysVisibleOptions       = [.padLandscape, .padPortrait]
        static let phone: AlwaysVisibleOptions     = [.phoneLandscape, .phonePortrait]
        static let all: AlwaysVisibleOptions       = [.padLandscape, .padPortrait, .phoneLandscape, .phonePortrait]

        public init(rawValue: Int) {
            self.rawValue = rawValue
        }

        var isAlwaysVisibleForCurrentOrientation: Bool {
            return self.isAlwaysVisibleForOrientation(UIApplication.shared.statusBarOrientation)
        }

        func isAlwaysVisibleForOrientation(_ orientation: UIInterfaceOrientation) -> Bool {
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

    // TODO: Make different style settings for each style
    public enum PresentationStyle {
        case slideAbove
        case slideBelow
        case scaleFromBig
        case scaleFromLittle
        // TODO: Add slideAside

        init() {
            self = .slideAbove
        }
    }

    public enum SwipeGestureArea {
        case borders
        case full

        init() {
            self = .borders
        }
    }

    public struct SwipeGestureRange {
        let left: CGFloat
        let right: CGFloat

        init(left: CGFloat = 44.0, right: CGFloat = 44.0) {
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

        init() {
            self = .rootViewIsShowing
        }

        var isLeftViewVisible: Bool {
            return self == .leftViewIsShowing || self == .leftViewWillShow || self == .leftViewWillHide
        }

        var isRightViewVisible: Bool {
            return self == .rightViewIsShowing || self == .rightViewWillShow || self == .rightViewWillHide
        }

        var isRootViewHidden: Bool {
            return self == .leftViewIsShowing || self == .rightViewIsShowing
        }

        var isLeftViewHidden: Bool {
            return !self.isLeftViewVisible
        }

        var isRightViewHidden: Bool {
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

    /// Container for rootViewController or rootView. Usually you do not need to use it
    open internal(set) var rootContainerView: UIView?
    /// Container for leftViewController or leftView. Usually you do not need to use it
    open internal(set) var leftContainerView: UIView?
    /// Container for rightViewController or rightView. Usually you do not need to use it
    open internal(set) var rightContainerView: UIView?

    open internal(set) var leftViewBackgroundView: UIImageView?
    open internal(set) var rightViewBackgroundView: UIImageView?

    /// tapGesture.cancelsTouchesInView = NO
    public let tapGesture: UITapGestureRecognizer
    /// panGesture.cancelsTouchesInView = YES, only inside your swipeGestureArea
    public let panGesture: UIPanGestureRecognizer

    // MARK: - Public Non-Conditional Configurable Properties

    /// Default:
    /// if iPhone { MainScreen.size.min - 44.0 }
    /// else 320.0
    @IBInspectable public var leftViewWidth: CGFloat = {
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
    @IBInspectable public var rightViewWidth: CGFloat = {
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

    public var leftViewPresentationStyle: PresentationStyle = .slideAbove {
        didSet {
            self.validateAlwaysVisibleConflict()
            self.setNeedsUpdateLayoutsAndStyles()
        }
    }

    public var rightViewPresentationStyle: PresentationStyle = .slideAbove {
        didSet {
            self.validateAlwaysVisibleConflict()
            self.setNeedsUpdateLayoutsAndStyles()
        }
    }

    public var leftViewAlwaysVisibleOptions: AlwaysVisibleOptions = [] {
        didSet {
            self.validateAlwaysVisibleConflict()
            self.setNeedsUpdateLayoutsAndStyles()
        }
    }

    public var rightViewAlwaysVisibleOptions: AlwaysVisibleOptions = [] {
        didSet {
            self.validateAlwaysVisibleConflict()
            self.setNeedsUpdateLayoutsAndStyles()
        }
    }

    @IBInspectable public var isLeftViewHidesOnTouch: Bool = true
    @IBInspectable public var isRightViewHidesOnTouch: Bool = true

    @IBInspectable public var isLeftViewSwipeGestureEnabled: Bool = true
    @IBInspectable public var isRightViewSwipeGestureEnabled: Bool = true

    public var isLeftViewSwipeGestureDisabled: Bool {
        set {
            self.isLeftViewSwipeGestureEnabled = !newValue
        }
        get {
            return !self.isLeftViewSwipeGestureEnabled
        }
    }

    public var isRightViewSwipeGestureDisabled: Bool {
        set {
            self.isRightViewSwipeGestureEnabled = !newValue
        }
        get {
            return !self.isRightViewSwipeGestureEnabled
        }
    }

    public var swipeGestureArea: SwipeGestureArea = .borders

    /// Only if swipeGestureArea == .borders
    /// Default is SwipeGestureRange(left: 44.0, right: 44.0)
    /// Explanation:
    /// For SwipeGestureRange(left: 44.0, right: 44.0) => leftView 44.0 | 44.0 rootView
    /// For SwipeGestureRange(left: 0.0, right: 44.0)  => leftView  0.0 | 44.0 rootView
    /// For SwipeGestureRange(left: 44.0, right: 0.0)  => leftView 44.0 | 0.0  rootView
    public var leftViewSwipeGestureRange = SwipeGestureRange()

    /// Only if swipeGestureArea == .borders
    /// Default is SwipeGestureRange(left: 44.0, right: 44.0)
    /// Explanation:
    /// For SwipeGestureRange(left: 44.0, right: 44.0) => rootView 44.0 | 44.0 rightView
    /// For SwipeGestureRange(left: 0.0, right: 44.0)  => rootView  0.0 | 44.0 rightView
    /// For SwipeGestureRange(left: 44.0, right: 0.0)  => rootView 44.0 | 0.0  rightView
    public var rightViewSwipeGestureRange = SwipeGestureRange()

    @IBInspectable public var leftViewAnimationDuration: TimeInterval = 0.5
    @IBInspectable public var rightViewAnimationDuration: TimeInterval = 0.5

    // TODO: Add custom timing function

    @IBInspectable public var shouldHideLeftViewAnimated: Bool = true
    @IBInspectable public var shouldHideRightViewAnimated: Bool = true

    @IBInspectable public var isLeftViewEnabled: Bool = true
    @IBInspectable public var isRightViewEnabled: Bool = true

    public var isLeftViewDisabled: Bool {
        set {
            self.isLeftViewEnabled = !newValue
        }
        get {
            return !self.isLeftViewEnabled
        }
    }

    public var isRightViewDisabled: Bool {
        set {
            self.isRightViewEnabled = !newValue
        }
        get {
            return !self.isRightViewEnabled
        }
    }

    @IBInspectable public var leftViewBackgroundColor: UIColor = .clear {
        didSet {
            self.setNeedsUpdateLayoutsAndStyles()
        }
    }

    @IBInspectable public var rightViewBackgroundColor: UIColor = .clear {
        didSet {
            self.setNeedsUpdateLayoutsAndStyles()
        }
    }

    /// Only if presentationStyle != .slideAbove
    @IBInspectable public var leftViewBackgroundImage: UIImage? {
        didSet {
            self.setNeedsUpdateLayoutsAndStyles()
        }
    }

    /// Only if presentationStyle != .slideAbove
    @IBInspectable public var rightViewBackgroundImage: UIImage? {
        didSet {
            self.setNeedsUpdateLayoutsAndStyles()
        }
    }

    /// Only if presentationStyle == .slideAbove
    @IBInspectable public var leftViewBackgroundBlurEffect: UIBlurEffect?
    /// Only if presentationStyle == .slideAbove
    @IBInspectable public var rightViewBackgroundBlurEffect: UIBlurEffect?

    /// Only if presentationStyle == .slideAbove
    @IBInspectable public var leftViewBackgroundAlpha: CGFloat = 1.0
    /// Only if presentationStyle == .slideAbove
    @IBInspectable public var rightViewBackgroundAlpha: CGFloat = 1.0

    @IBInspectable public var rootViewLayerBorderColor: UIColor = .clear
    /// Only if presentationStyle == .slideAbove
    @IBInspectable public var leftViewLayerBorderColor: UIColor = .clear
    /// Only if presentationStyle == .slideAbove
    @IBInspectable public var rightViewLayerBorderColor: UIColor = .clear

    @IBInspectable public var rootViewLayerBorderWidth: CGFloat = 0.0
    /// Only if presentationStyle == .slideAbove
    @IBInspectable public var leftViewLayerBorderWidth: CGFloat = 0.0
    /// Only if presentationStyle == .slideAbove
    @IBInspectable public var rightViewLayerBorderWidth: CGFloat = 0.0

    @IBInspectable public var rootViewLayerShadowColor = UIColor(white: 0.0, alpha: 0.5)
    /// Only if presentationStyle == .slideAbove
    @IBInspectable public var leftViewLayerShadowColor = UIColor(white: 0.0, alpha: 0.5)
    /// Only if presentationStyle == .slideAbove
    @IBInspectable public var rightViewLayerShadowColor = UIColor(white: 0.0, alpha: 0.5)

    @IBInspectable public var rootViewLayerShadowRadius: CGFloat = 5.0
    /// Only if presentationStyle == .slideAbove
    @IBInspectable public var leftViewLayerShadowRadius: CGFloat = 5.0
    /// Only if presentationStyle == .slideAbove
    @IBInspectable public var rightViewLayerShadowRadius: CGFloat = 5.0

    @IBInspectable public var rootViewCoverBlurEffectForLeftView: UIBlurEffect?
    @IBInspectable public var rootViewCoverBlurEffectForRightView: UIBlurEffect?
    /// Only if presentationStyle != .slideAbove
    @IBInspectable public var leftViewCoverBlurEffect: UIBlurEffect?
    /// Only if presentationStyle != .slideAbove
    @IBInspectable public var rightViewCoverBlurEffect: UIBlurEffect?

    @IBInspectable public var rootViewCoverAlphaForLeftView: CGFloat = 1.0
    @IBInspectable public var rootViewCoverAlphaForRightView: CGFloat = 1.0
    /// Only if presentationStyle != .slideAbove
    @IBInspectable public var leftViewCoverAlpha: CGFloat = 1.0
    /// Only if presentationStyle != .slideAbove
    @IBInspectable public var rightViewCoverAlpha: CGFloat = 1.0

    // MARK: - Public Conditional Configurable Properties

    /// Default:
    /// if rootViewController != nil then rootViewController.prefersStatusBarHidden
    /// else self.prefersStatusBarHidden
    @IBInspectable public var isRootViewStatusBarHidden: Bool {
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
    @IBInspectable public var isLeftViewStatusBarHidden: Bool {
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
    @IBInspectable public var isRightViewStatusBarHidden: Bool {
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
    @IBInspectable public var rootViewStatusBarStyle: UIStatusBarStyle {
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
    @IBInspectable public var leftViewStatusBarStyle: UIStatusBarStyle {
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
    @IBInspectable public var rightViewStatusBarStyle: UIStatusBarStyle {
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
    @IBInspectable public var rootViewStatusBarUpdateAnimation: UIStatusBarAnimation {
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
    @IBInspectable public var leftViewStatusBarUpdateAnimation: UIStatusBarAnimation {
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
    @IBInspectable public var rightViewStatusBarUpdateAnimation: UIStatusBarAnimation {
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
    @IBInspectable public var rootViewCoverColorForLeftView: UIColor {
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
    @IBInspectable public var rootViewCoverColorForRightView: UIColor {
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
    @IBInspectable public var leftViewCoverColor: UIColor {
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
    @IBInspectable public var rightViewCoverColor: UIColor {
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
    @IBInspectable public var rootViewScaleForLeftView: CGFloat {
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
    @IBInspectable public var rootViewScaleForRightView: CGFloat {
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
    @IBInspectable public var leftViewInitialScale: CGFloat {
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
    @IBInspectable public var rightViewInitialScale: CGFloat {
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
    @IBInspectable public var leftViewInitialOffsetX: CGFloat {
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
    @IBInspectable public var rightViewInitialOffsetX: CGFloat {
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
    @IBInspectable public var leftViewBackgroundImageInitialScale: CGFloat {
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
    @IBInspectable public var rightViewBackgroundImageInitialScale: CGFloat {
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
    @IBInspectable public var leftViewBackgroundImageFinalScale: CGFloat {
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
    @IBInspectable public var rightViewBackgroundImageFinalScale: CGFloat {
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

    public var willShowLeftView: Callback?
    public var didShowLeftView: Callback?

    public var willHideLeftView: Callback?
    public var didHideLeftView: Callback?

    public var willShowRightView: Callback?
    public var didShowRightView: Callback?

    public var willHideRightView: Callback?
    public var didHideRightView: Callback?

    /// You can use this callback to add some custom animations
    public var showAnimationsForLeftView: AnimationsCallback?
    /// You can use this callback to add some custom animations
    public var hideAnimationsForLeftView: AnimationsCallback?

    /// You can use this callback to add some custom animations
    public var showAnimationsForRightView: AnimationsCallback?
    /// You can use this callback to add some custom animations
    public var hideAnimationsForRightView: AnimationsCallback?

    // MARK: - Delegate

    public var delegate: LGSideMenuDelegate?

    // MARK: - Internal Properties

    public internal(set) var state: State = .rootViewIsShowing

    public internal(set) var isAnimating = false

    internal var isNeedsUpdateLayoutsAndStyles: Bool = false
    internal var isNeedsUpdateRootViewLayoutsAndStyles: Bool = false
    internal var isNeedsUpdateLeftViewLayoutsAndStyles: Bool = false
    internal var isNeedsUpdateRightViewLayoutsAndStyles: Bool = false

    internal var savedSize: CGSize = .zero

    internal var rootViewBorderView: LGSideMenuBorderView?
    internal var rootViewCoverView: UIVisualEffectView?

    internal var leftViewBorderView: LGSideMenuBorderView?
    internal var leftViewStyleView: UIVisualEffectView?
    internal var leftViewCoverView: UIVisualEffectView?

    internal var rightViewBorderView: LGSideMenuBorderView?
    internal var rightViewStyleView: UIVisualEffectView?
    internal var rightViewCoverView: UIVisualEffectView?

    internal var leftViewGestureStartX: CGFloat?
    internal var rightViewGestureStartX: CGFloat?

    internal var isLeftViewShowingBeforeGesture: Bool = false
    internal var isRightViewShowingBeforeGesture: Bool = false

    // MARK: - Initialization

    public init() {
        self.tapGesture = UITapGestureRecognizer()
        self.panGesture = UIPanGestureRecognizer()

        super.init(nibName: nil, bundle: nil)

        self.tapGesture.addTarget(self, action: #selector(handleTapGesture))
        self.tapGesture.delegate = self
        self.tapGesture.numberOfTapsRequired = 1
        self.tapGesture.numberOfTouchesRequired = 1
        self.tapGesture.cancelsTouchesInView = false // TODO: Make settings to enable/disable this
        self.view.addGestureRecognizer(self.tapGesture)

        self.panGesture.addTarget(self, action: #selector(handlePanGesture))
        self.panGesture.delegate = self
        self.panGesture.minimumNumberOfTouches = 1
        self.panGesture.maximumNumberOfTouches = 1
        self.panGesture.cancelsTouchesInView = false // TODO: Make settings to enable/disable this
        self.view.addGestureRecognizer(self.panGesture)
    }

    public convenience init(rootViewController: UIViewController? = nil, leftViewController: UIViewController? = nil, rightViewController: UIViewController? = nil) {
        self.init()

        self.rootViewController = rootViewController
        self.leftViewController = leftViewController
        self.rightViewController = rightViewController
    }

    public convenience init(rootView: UIView? = nil, leftView: UIView? = nil, rightView: UIView? = nil) {
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
