//
//  ViewDesignerService.swift
//  CraftYourProfile
//
//  Created by Дмитрий Константинов on 10.06.2020.
//  Copyright © 2020 Дмитрий Константинов. All rights reserved.
//

import UIKit

class ViewDesignerService {

    // MARK: - Properties
    weak private var view: UIView?

    // MARK: - Initialization
    init(_ view: UIView) {
        self.view = view
    }

    // MARK: - Public methods
    public func setBackButton(_ button: UIView) {

        guard let view = view else { return }

        NSLayoutConstraint.activate([
            button.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 12),
            button.heightAnchor.constraint(equalToConstant: 44),
            button.widthAnchor.constraint(equalToConstant: 44),
            button.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 18)
        ])
    }

    public func setView(_ view: UIView,
                        with topView: UIView,
                        trailingIsShort: Bool = true,
                        withHeight: Bool = false,
                        specialHeight: Bool = false) {

        guard let mainView = self.view else { return }

        var trailingAnchor: CGFloat = -48
        if !trailingIsShort { trailingAnchor = -24 }

        NSLayoutConstraint.activate([
            view.topAnchor.constraint(equalTo: topView.bottomAnchor, constant: 24),
            view.leadingAnchor.constraint(equalTo: mainView.leadingAnchor, constant: 24),
            view.trailingAnchor.constraint(equalTo: mainView.trailingAnchor, constant: trailingAnchor)
        ])

        if withHeight {
            var height: CGFloat = 50

            if specialHeight { height = (UIScreen.main.bounds.width - 48 - 30) / 6 }
            view.heightAnchor.constraint(equalToConstant: height).isActive = true
        }
    }

    public func setBottomView(_ view: UIView,
                              with topView: UIView,
                              specialSpacing: Bool = false) {

        guard let mainView = self.view else { return }

        var topSpacing: CGFloat = 170
        if specialSpacing { topSpacing += 16 }

        NSLayoutConstraint.activate([
            view.topAnchor.constraint(equalTo: topView.bottomAnchor, constant: topSpacing),
            view.leadingAnchor.constraint(equalTo: mainView.leadingAnchor, constant: 24),
            view.trailingAnchor.constraint(equalTo: mainView.trailingAnchor, constant: -24),
            view.heightAnchor.constraint(equalToConstant: 50)
        ])
    }

    public func setBottomView(_ view: UIView,
                              with topView: UIView,
                              multiplier: Int,
                              constant: CGFloat) {

        guard let mainView = self.view else { return }

        let topSpacing: CGFloat = 24 * CGFloat(multiplier) + constant

        NSLayoutConstraint.activate([
            view.topAnchor.constraint(equalTo: topView.bottomAnchor, constant: topSpacing),
            view.leadingAnchor.constraint(equalTo: mainView.leadingAnchor, constant: 24),
            view.trailingAnchor.constraint(equalTo: mainView.trailingAnchor, constant: -24),
            view.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
}
