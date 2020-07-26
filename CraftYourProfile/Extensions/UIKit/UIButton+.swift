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
        imageView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(imageView)

        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalToConstant: side),
            imageView.heightAnchor.constraint(equalToConstant: side),
            imageView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: offset),
            imageView.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
    }
}
