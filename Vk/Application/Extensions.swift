//
//  UIViewExtension.swift
//  Navigation
//
//  Created by Табункин Вадим on 26.03.2022.
//

import UIKit
import SwiftUI
import iOSIntPackage

extension UIView {
    static var identifier:String {String(describing: self)}

    func  toAutoLayout () {
        translatesAutoresizingMaskIntoConstraints = false
    }

    func addSubviews(_ subviews: UIView...) {
        subviews.forEach {addSubview($0)}
    }
}

extension String {
    var localized: String {
        NSLocalizedString(self, comment: "")
    }
}

extension UIColor {
    static var backgroundColor: UIColor {
        Self.makeColor(light: .systemGray6, dark: .darkGray)
    }

    static var backgroundCellColor: UIColor {
        Self.makeColor(light: .white, dark: UIColor(red: 0.2, green: 0.2, blue: 0.2, alpha: 1))
    }

    static var textColor: UIColor {
        Self.makeColor(light: .black, dark: .white)
    }

    static var delButtomColor: UIColor {
        Self.makeColor(light: #colorLiteral(red: 1, green: 0.4451128062, blue: 0.3478579359, alpha: 1), dark: #colorLiteral(red: 0.5605350417, green: 0.2495013254, blue: 0.1949865626, alpha: 1) )
    }

    static var statusTextColor: UIColor {
        Self.makeColor(light: .systemGray, dark: .secondaryLabel )
    }

    static var borderColor: UIColor {
        Self.makeColor(light: .black, dark: .white )
    }

    private static func makeColor(light: UIColor, dark: UIColor) -> UIColor {
        if #available(iOS 13.0, *) {
            return UIColor { traitCollection -> UIColor in
                switch traitCollection.userInterfaceStyle {
                case .light, .unspecified:
                    return light
                case .dark:
                    return dark
                @unknown default:
                    assertionFailure("Case is not supported")
                    return light
                }
            }
        } else {
            return light
        }
    }


}
