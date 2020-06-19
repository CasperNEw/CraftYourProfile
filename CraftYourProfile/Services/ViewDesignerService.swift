//
//  ViewDesignerService.swift
//  CraftYourProfile
//
//  Created by Дмитрий Константинов on 10.06.2020.
//  Copyright © 2020 Дмитрий Константинов. All rights reserved.
//

import UIKit

class ViewDesignerService {

    let view: UIView

    init(_ view: UIView) {
        self.view = view
    }

    func setBackButton(_ button: UIView) {

        NSLayoutConstraint.activate([
            button.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 12),
            button.heightAnchor.constraint(equalToConstant: 44),
            button.widthAnchor.constraint(equalToConstant: 44),
            button.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 18)
        ])
    }

    func setView(_ view: UIView, with topView: UIView, trailingIsShort: Bool = true,
                 withHeight: Bool = false, specialHeight: Bool = false) {

        var trailingAnchor: CGFloat = -48
        if !trailingIsShort { trailingAnchor = -24 }

        NSLayoutConstraint.activate([
            view.topAnchor.constraint(equalTo: topView.bottomAnchor, constant: 24),
            view.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 24),
            view.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: trailingAnchor)
        ])

        if withHeight {
            var height: CGFloat = 50
            if specialHeight { height = (self.view.bounds.width - 48 - 30) / 6 }
            view.heightAnchor.constraint(equalToConstant: height).isActive = true
        }
    }

    func setBottomView(_ view: UIView, with topView: UIView, specialSpacing: Bool = false) {

        var topSpacing: CGFloat = 170
        if specialSpacing { topSpacing += 16 }

        NSLayoutConstraint.activate([
            view.topAnchor.constraint(equalTo: topView.bottomAnchor, constant: topSpacing),
            view.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 24),
            view.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -24),
            view.heightAnchor.constraint(equalToConstant: 50)
        ])
    }

    func setBottomView(_ view: UIView, with topView: UIView, multiplier: Int, constant: CGFloat) {

        let topSpacing: CGFloat = 24 * CGFloat(multiplier) + constant

        NSLayoutConstraint.activate([
            view.topAnchor.constraint(equalTo: topView.bottomAnchor, constant: topSpacing),
            view.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 24),
            view.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -24),
            view.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
}
