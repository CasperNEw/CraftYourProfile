//
//  UIView+.swift
//  CraftYourProfile
//
//  Created by Дмитрий Константинов on 04.06.2020.
//  Copyright © 2020 Дмитрий Константинов. All rights reserved.
//

import UIKit

extension UIView {

    func addMainSubviewInSafeArea(_ view: UIView?) {

        guard let view = view else { return }
        addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            view.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
            view.leftAnchor.constraint(equalTo: self.leftAnchor),
            view.rightAnchor.constraint(equalTo: self.rightAnchor),
            view.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor)
        ])
    }

    func addMainSubview(_ view: UIView?) {

        guard let view = view else { return }
        addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            view.topAnchor.constraint(equalTo: self.topAnchor),
            view.leftAnchor.constraint(equalTo: self.leftAnchor),
            view.rightAnchor.constraint(equalTo: self.rightAnchor),
            view.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }

    func addSubviews(_ views: [UIView]) {
        views.forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            addSubview($0)
        }
    }

    func setGradientBackground(colorTop: UIColor,
                               colorBottom: UIColor,
                               startPoint: CGPoint,
                               endPoint: CGPoint,
                               locations: [NSNumber]?) {

        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [colorBottom.cgColor, colorTop.cgColor]
        gradientLayer.startPoint = startPoint
        gradientLayer.endPoint = endPoint
        gradientLayer.locations = locations
        gradientLayer.frame = bounds

        layer.insertSublayer(gradientLayer, at: 0)
    }

    // swiftlint:disable all
    func shake(_ iteration: Int = 0) {
        UIView.animate(withDuration: 0.05,
                       animations: { [weak self] in self?.transform = CGAffineTransform(translationX: 8, y: 0) })
        { [weak self] (_) in
            UIView.animate(withDuration: 0.05,
                           animations: { [weak self] in self?.transform = .identity },
                           completion: { [weak self] (_) in if  iteration < 2 { self?.shake(iteration + 1) }
            })
        }
    }
    // swiftlint:enable all
}
