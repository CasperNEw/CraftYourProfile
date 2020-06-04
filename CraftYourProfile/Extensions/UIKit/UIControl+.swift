//
//  UIControl+.swift
//  CraftYourProfile
//
//  Created by Дмитрий Константинов on 18.05.2020.
//  Copyright © 2020 Дмитрий Константинов. All rights reserved.
//

import UIKit

extension UIControl {

    convenience init(image: UIImage?) {
        self.init()
        addImage(image: image)
    }

    convenience init(title: String,
                     titleColor: UIColor,
                     backgroundColor: UIColor,
                     font: UIFont?,
                     cornerRadius: CGFloat) {
        self.init()

        self.backgroundColor = backgroundColor
        self.layer.cornerRadius = cornerRadius
        addLabel(text: title, font: font, color: titleColor)
    }

    private func addImage(image: UIImage?) {
        self.backgroundColor = .clear
        let imageView = UIImageView(image: image)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(imageView)

        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            imageView.topAnchor.constraint(equalTo: self.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }

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

    private func addLabel(text: String, font: UIFont?, color: UIColor) {
        let label = UILabel(text: text, font: font, color: color)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        self.addSubview(label)

        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: self.bounds.width / 4),
            label.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -self.bounds.width / 4),
            label.topAnchor.constraint(equalTo: self.topAnchor, constant: self.bounds.height / 3),
            label.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -self.bounds.height / 3)
        ])
    }

    func clickAnimation() {
        self.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)

        UIView.animate(withDuration: 1.5,
                       delay: 0,
                       usingSpringWithDamping: 0.2,
                       initialSpringVelocity: 3.0,
                       options: .allowUserInteraction,
                       animations: {
                        self.transform = CGAffineTransform.identity })
    }
}
