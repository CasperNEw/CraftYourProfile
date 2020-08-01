//
//  UIButton+.swift
//  CraftYourProfile
//
//  Created by Дмитрий Константинов on 18.05.2020.
//  Copyright © 2020 Дмитрий Константинов. All rights reserved.
//

import UIKit

extension UIButton {

    func addRightImage(image: UIImage?, side: CGFloat, offset: CGFloat) {

        let imageView = UIImageView(image: image)
        addSubviews([imageView])

        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalToConstant: side),
            imageView.heightAnchor.constraint(equalToConstant: side),
            imageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: offset),
            imageView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
}
