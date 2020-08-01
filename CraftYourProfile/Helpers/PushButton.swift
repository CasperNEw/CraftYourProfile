//
//  PushButton.swift
//  CraftYourProfile
//
//  Created by Дмитрий Константинов on 26.07.2020.
//  Copyright © 2020 Дмитрий Константинов. All rights reserved.
//

import UIKit

class PushButton: UIButton {

    // MARK: - Initialization
    convenience init(image: UIImage?,
                     alpha: CGFloat = 1,
                     transformScale: CGFloat = 0.7) {
        self.init()

        adjustsImageWhenHighlighted = false
        setImage(image, for: .normal)
        self.alpha = alpha
        self.transformScale = transformScale
    }

    convenience init(title: String,
                     titleColor: UIColor,
                     backgroundColor: UIColor,
                     font: UIFont?,
                     cornerRadius: CGFloat,
                     transformScale: CGFloat = 0.7) {
        self.init()

        adjustsImageWhenHighlighted = false
        layer.cornerRadius = cornerRadius
        self.backgroundColor = backgroundColor
        self.transformScale = transformScale
        addLabel(text: title, font: font, color: titleColor)
    }

    // MARK: - Properties
    private var transformScale: CGFloat = 0.7

    override var isHighlighted: Bool {
        willSet {
            animate(with: newValue)
        }
    }

    // MARK: - Module function
    private func animate(with value: Bool) {

        var transform = CGAffineTransform.identity

        if value {
            transform = CGAffineTransform(scaleX: transformScale,
                                          y: transformScale)
        }

        UIView.animate(withDuration: 0.2) {
            self.transform = transform
        }
    }

    private func addLabel(text: String, font: UIFont?, color: UIColor) {

        let label = UILabel(text: text, font: font, color: color,
                            lines: 1, alignment: .center)

        addSubviews([label])

        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: bounds.width / 4),
            label.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -bounds.width / 4),
            label.topAnchor.constraint(equalTo: topAnchor, constant: bounds.height / 3),
            label.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -bounds.height / 3)
        ])
    }
}
