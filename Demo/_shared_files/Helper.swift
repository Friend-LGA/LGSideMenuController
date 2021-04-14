//
//  Helper.swift
//  LGSideMenuControllerDemo
//

import Foundation
import UIKit

private let isStoryboardBasedKey = "IsStoryboardBased"

private let backgroundImageNames: [String] = ["imageRoot0", "imageRoot1", "imageRoot2", "imageRoot3"]
private var currentBackgroundImageNameIndex = 0

let menuIconImage: UIImage = {
    let size = CGSize(width: 24.0, height: 16.0)
    let renderer = UIGraphicsImageRenderer(size: size)
    return renderer.image { context in
        let ctx = context.cgContext
        let lineHeight: CGFloat = 2.0

        ctx.setFillColor(UIColor.black.cgColor)
        ctx.setStrokeColor(UIColor.black.cgColor)
        ctx.setLineWidth(lineHeight)
        ctx.setLineCap(.round)

        ctx.beginPath()

        ctx.move(to: CGPoint(x: lineHeight, y: lineHeight / 2.0))
        ctx.addLine(to: CGPoint(x: size.width - lineHeight, y: lineHeight / 2.0))

        ctx.move(to: CGPoint(x: lineHeight, y: size.height / 2.0))
        ctx.addLine(to: CGPoint(x: size.width - lineHeight, y: size.height / 2.0))

        ctx.move(to: CGPoint(x: lineHeight, y: size.height - lineHeight / 2.0))
        ctx.addLine(to: CGPoint(x: size.width - lineHeight, y: size.height - lineHeight / 2.0))

        ctx.strokePath()
    }
}()

func tabBarIconImage(_ title: String) -> UIImage {
    let fontSize: CGFloat = 24.0
    let insetVertical: CGFloat = 4.0
    let size = CGSize(width: fontSize, height: fontSize + insetVertical)
    let renderer = UIGraphicsImageRenderer(size: size)
    return renderer.image { context in
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        let attrs = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: fontSize),
                     NSAttributedString.Key.paragraphStyle: paragraphStyle]
        title.draw(with: CGRect(x: 0.0, y: 0.0, width: size.width, height: size.height),
                   options: .usesLineFragmentOrigin,
                   attributes: attrs,
                   context: nil)
    }
}

func isStoryboardBasedDemo() -> Bool {
    guard let dict = Bundle.main.infoDictionary else { return false }
    return dict[isStoryboardBasedKey] as! Bool
}

func isLightTheme() -> Bool {
    if #available(iOS 13.0, *) {
        let currentStyle = UITraitCollection.current.userInterfaceStyle
        return currentStyle == .light || currentStyle == .unspecified
    }
    else {
        return true
    }
}

func getBackgroundImageNameDefault() -> String {
    currentBackgroundImageNameIndex = 0
    return backgroundImageNames[currentBackgroundImageNameIndex]
}

func getBackgroundImageNameRandom() -> String {
    var newIndex = currentBackgroundImageNameIndex
    while newIndex == currentBackgroundImageNameIndex {
        newIndex = Int.random(in: 0...3)
    }
    currentBackgroundImageNameIndex = newIndex
    return backgroundImageNames[currentBackgroundImageNameIndex]
}

func getKeyWindow() -> UIWindow? {
    if #available(iOS 13.0, *) {
        return UIApplication.shared.windows.first(where: { $0.isKeyWindow })
    } else {
        return UIApplication.shared.keyWindow
    }
}

func getStatusBarFrame() -> CGRect {
    if #available(iOS 13.0, *) {
        return getKeyWindow()?.windowScene?.statusBarManager?.statusBarFrame ?? .zero
    } else {
        return UIApplication.shared.statusBarFrame
    }
}

func getTitle(for presentationStyle: LGSideMenuController.PresentationStyle) -> String {
    switch presentationStyle {
    case .scaleFromBig:
        return "Scale From Big"
    case .scaleFromLittle:
        return "Scale From Little"
    case .slideBelow:
        return "Slide Below"
    case .slideBelowShifted:
        return "Slide Below Shifted"
    case .slideAbove:
        return "Slide Above"
    case .slideAboveBlurred:
        return "Slide Above Blurred"
    case .slideAside:
        return "Slide Aside"
    }
}

extension UIView {
    class func fromNib() -> Self {
        return Bundle.main.loadNibNamed(String(describing: self), owner: nil, options: nil)!.first as! Self
    }
}

extension UIColor {
    convenience init(hexString: String, alpha: CGFloat = 1.0) {
        let hexint = Int(Self.intFromHexString(hexStr: hexString))
        let red = CGFloat((hexint & 0xff0000) >> 16) / 255.0
        let green = CGFloat((hexint & 0xff00) >> 8) / 255.0
        let blue = CGFloat((hexint & 0xff) >> 0) / 255.0
        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }

    static private func intFromHexString(hexStr: String) -> UInt32 {
        var hexInt: UInt32 = 0
        let scanner: Scanner = Scanner(string: hexStr)
        scanner.charactersToBeSkipped = CharacterSet(charactersIn: "#")
        scanner.scanHexInt32(&hexInt)
        return hexInt
    }
}

enum SideViewCellItem: Equatable {
    case close
    case openLeft
    case openRight
    case changeRootVC
    case pushVC(title: String)

    var description: String {
        switch self {
        case .close:
            return "Close"
        case .openLeft:
            return "Open Left View"
        case .openRight:
            return "Open Right View"
        case .changeRootVC:
            return "Change Root VC"
        case let .pushVC(title):
            return title
        }
    }
}
