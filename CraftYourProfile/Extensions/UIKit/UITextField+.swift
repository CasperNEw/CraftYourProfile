//
//  UITextField+.swift
//  CraftYourProfile
//
//  Created by Дмитрий Константинов on 12.06.2020.
//  Copyright © 2020 Дмитрий Константинов. All rights reserved.
//

import UIKit

extension UITextField {

    convenience init(font: UIFont?, textColor: UIColor, backgroundColor: UIColor,
                     cornerRadius: CGFloat, alignment: NSTextAlignment = .center) {
        self.init()

        self.font = font
        self.textColor = textColor
        self.backgroundColor = backgroundColor
        self.layer.cornerRadius = cornerRadius
        self.textAlignment = alignment
    }

    func addRightButton(button: UIButton, side: CGFloat, offset: CGFloat) {
        button.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(button)

        NSLayoutConstraint.activate([
            button.widthAnchor.constraint(equalToConstant: side),
            button.heightAnchor.constraint(equalToConstant: side),
            button.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: offset),
            button.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
    }
}
