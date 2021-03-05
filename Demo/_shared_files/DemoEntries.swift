//
//  DemoEntries.swift
//  LGSideMenuControllerDemo
//

import Foundation

enum DemoSection: Int, CaseIterable {
    case defaultStyles
    case usage
    case conflictingGestures
    case statusBar

    var description: String {
        switch self {
        case .defaultStyles:
            return "Default Styles"
        case .usage:
            return "Usage"
        case .conflictingGestures:
            return "Conflicting Gestures"
        case .statusBar:
            return "Status Bar"
        }
    }

    var items: [DemoRow] {
        switch self {
        case .defaultStyles:
            return [.styleScaleFromBig,
                    .styleScaleFromLittle,
                    .styleSlideAbove,
                    .styleSlideAboveBlurred,
                    .styleSlideBelow,
                    .styleSlideBelowShifted,
                    .styleSlideAside]
        case .usage:
            return [.usageAsWindowRootViewController,
                    .usageInsideNavigationController]
        case .conflictingGestures:
            return [.conflictingGesturesScrollView,
                    .conflictingGesturesTableView]
        case .statusBar:
            return [.statusBarRootAndSide,
                    .statusBarOnlyRoot,
                    .statusBarOnlySide,
                    .statusBarHidden,
                    .statusBarDifferentStyles,
                    .statusBarCustomBackground,
                    .statusBarNoBackground]
        }
    }
}

enum DemoRow {
    case styleScaleFromBig
    case styleScaleFromLittle
    case styleSlideAbove
    case styleSlideAboveBlurred
    case styleSlideBelow
    case styleSlideBelowShifted
    case styleSlideAside

    case usageAsWindowRootViewController
    case usageInsideNavigationController

    case conflictingGesturesScrollView
    case conflictingGesturesTableView

    case statusBarRootAndSide
    case statusBarOnlyRoot
    case statusBarOnlySide
    case statusBarHidden
    case statusBarDifferentStyles
    case statusBarCustomBackground
    case statusBarNoBackground

    case blurredRootViewCover
    case blurredCoversOfSideViews
    case blurredBackgroundsOfSideViews
    case landscapeIsAlwaysVisible
    case statusBarIsAlwaysVisible
    case gestureAreaIsFullScreen
    case concurrentTouchActions
    case customStyleExample

    var title: String {
        switch self {
        case .styleScaleFromBig:
            return getTitle(for: .scaleFromBig)
        case .styleScaleFromLittle:
            return getTitle(for: .scaleFromLittle)
        case .styleSlideAbove:
            return getTitle(for: .slideAbove)
        case .styleSlideAboveBlurred:
            return getTitle(for: .slideAboveBlurred)
        case .styleSlideBelow:
            return getTitle(for: .slideBelow)
        case .styleSlideBelowShifted:
            return getTitle(for: .slideBelowShifted)
        case .styleSlideAside:
            return getTitle(for: .slideAside)

        case .usageAsWindowRootViewController:
            return "As Window RootViewController"
        case .usageInsideNavigationController:
            return "Inside UINavigationController"

        case .conflictingGesturesScrollView:
            return "With UIScrollView inside"
        case .conflictingGesturesTableView:
            return "With UITableView inside"

        case .statusBarRootAndSide:
            return "Root and Side"
        case .statusBarOnlyRoot:
            return "Root"
        case .statusBarOnlySide:
            return "Side"
        case .statusBarHidden:
            return "Hidden"
        case .statusBarDifferentStyles:
            return "Different Styles"
        case .statusBarCustomBackground:
            return "Custom Background"
        case .statusBarNoBackground:
            return "No Background"

        default:
            return "Default"
        }
    }

    var presentationStyles: [LGSideMenuController.PresentationStyle] {
        switch self {
        case .styleScaleFromBig:
            return [.scaleFromBig]
        case .styleScaleFromLittle:
            return [.scaleFromLittle]
        case .styleSlideAbove:
            return [.slideAbove]
        case .styleSlideAboveBlurred:
            return [.slideAboveBlurred]
        case .styleSlideBelow:
            return [.slideBelow]
        case .styleSlideBelowShifted:
            return [.slideBelowShifted]
        case .styleSlideAside:
            return [.slideAside]

        case .usageAsWindowRootViewController,
             .usageInsideNavigationController,
             .statusBarRootAndSide,
             .statusBarOnlyRoot,
             .statusBarOnlySide,
             .statusBarHidden,
             .statusBarDifferentStyles,
             .statusBarCustomBackground,
             .statusBarNoBackground:
            return [.scaleFromBig, .scaleFromLittle, .slideAbove, .slideAboveBlurred, .slideBelow, .slideBelowShifted, .slideAside]

        default:
            return [.slideBelowShifted]
        }
    }
}

struct DemoType {
    let demoRow: DemoRow
    let presentationStyle: LGSideMenuController.PresentationStyle

    var description: String? {
        switch demoRow {
        case .styleScaleFromBig:
            return """
                Try to open left and right side views by buttons in navigation bar and by swipe gestures from the edges of the screen.

                presentationStyle = .scaleFromBig
                """
        case .styleSlideAboveBlurred:
            return """
                Try to open left and right side views by buttons in navigation bar and by swipe gestures from the edges of the screen.

                presentationStyle = .slideAboveBlurred
                """
        case .styleSlideAbove:
            return """
                Try to open left and right side views by buttons in navigation bar and by swipe gestures from the edges of the screen.

                presentationStyle = .slideAbove
                """
        case .styleSlideBelowShifted:
            return """
                Try to open left and right side views by buttons in navigation bar and by swipe gestures from the edges of the screen.

                presentationStyle = .slideBelowShifted
                """
        case .styleSlideBelow:
            return """
                Try to open left and right side views by buttons in navigation bar and by swipe gestures from the edges of the screen.

                presentationStyle = .slideBelow
                """
        case .styleSlideAside:
            return """
                Try to open left and right side views by buttons in navigation bar and by swipe gestures from the edges of the screen.

                presentationStyle = .slideAside
                """
        case .styleScaleFromLittle:
            return """
                Try to open left and right side views by buttons in navigation bar and by swipe gestures from the edges of the screen.

                presentationStyle = .scaleFromLittle
                """

        case .usageAsWindowRootViewController:
            return """
                Current view controllers hierarchy:

                LGSideMenuController {
                    rootViewController: UINavigationController
                }
                """
        case .usageInsideNavigationController:
            return """
                Current view controllers hierarchy:

                UINavigationController {
                    viewControllers: [LGSideMenuController]
                }
                """

        case .statusBarRootAndSide:
            return "Status bar is always visible, try to open side views."
        case .statusBarOnlyRoot:
            return "Status bar is visible only when side views are hidden, try to open side views."
        case .statusBarOnlySide:
            return "Status bar is visible only when side view is open, try to open side views."
        case .statusBarHidden:
            return "Status bar is always hidden, try to open side views."
        case .statusBarDifferentStyles:
            return "Status bar has different styles for root and side views, try to open side views."
        case .statusBarCustomBackground:
            return "By default side views have background under status bar and it can be customised, try to open side views."
        case .statusBarNoBackground:
            return "By default side views have background under status bar and it can be hidden, try to open side views."

        case .conflictingGesturesScrollView:
            return "If you have UIScrollView as a rootView, you still able to scroll it and use gestures to open side views. Try to scroll image and open side views."
        case .conflictingGesturesTableView:
            return "If you have editable UITableView as a rootView, you still able to edit it and use gestures to open side views. Try to remove rows by swiping and open side views."

        default:
            return nil
        }
    }
}
