//
//  UIFont+.swift
//  CraftYourProfile
//
//  Created by Дмитрий Константинов on 16.05.2020.
//  Copyright © 2020 Дмитрий Константинов. All rights reserved.
//

import UIKit

extension UIFont {

    enum FontStyle {

        case ultralight
        case black
        case thin
        case light
        case bold
        case semibold
        case heavy
        case medium
        case regular
    }

    static func compactRounded(style: FontStyle, size: CGFloat) -> UIFont? {
        return UIFont.init(name: "SFCompactRounded-\("\(style)".capitalized)", size: size)
    }
}
