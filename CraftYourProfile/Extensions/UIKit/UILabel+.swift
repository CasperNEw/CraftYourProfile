//
//  UILabel+.swift
//  CraftYourProfile
//
//  Created by Дмитрий Константинов on 16.05.2020.
//  Copyright © 2020 Дмитрий Константинов. All rights reserved.
//

import UIKit

extension UILabel {

    convenience init(text: String, font: UIFont?, color: UIColor,
                     lines: Int = 1, alignment: NSTextAlignment = .center) {
        self.init()

        self.text = text
        self.textColor = color
        self.font = font
        self.adjustsFontSizeToFitWidth = true
        self.numberOfLines = lines
        self.textAlignment = alignment
    }
}
