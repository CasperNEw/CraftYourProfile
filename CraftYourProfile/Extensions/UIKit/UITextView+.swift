//
//  UITextView+.swift
//  CraftYourProfile
//
//  Created by Дмитрий Константинов on 16.05.2020.
//  Copyright © 2020 Дмитрий Константинов. All rights reserved.
//

import UIKit

extension UITextView {

    convenience init(text: String,
                     couples: [(String, String)],
                     font: UIFont?,
                     textColor: UIColor,
                     backgroundColor: UIColor,
                     tintColor: UIColor) {
        self.init()

        self.text = text
        let attributedString = NSAttributedString.makeHyperlinks(for: couples, in: text)
        self.attributedText = attributedString
        self.isEditable = false
        self.font = font
        self.textColor = textColor
        self.backgroundColor = backgroundColor
        self.tintColor = tintColor
        self.textAlignment = .center
    }
}
