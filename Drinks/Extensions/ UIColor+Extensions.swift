//
//   UIColor+Extensions.swift
//  Coctails
//
//  Created by admin on 24.04.2023.
//

import UIKit

extension UIColor {
    static func rgb(red: CGFloat, green: CGFloat, blue: CGFloat) -> UIColor {
        return UIColor.init(red: red / 255, green: green / 255, blue: blue / 255, alpha: 1.0)
    }

    static let lightBrownBackgroundColor = UIColor.rgb(red: 241, green: 232, blue: 230)
    static let textColor = UIColor.rgb(red: 54, green: 29, blue: 50)
}
