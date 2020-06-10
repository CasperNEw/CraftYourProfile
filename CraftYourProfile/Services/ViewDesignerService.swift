//
//  ViewDesignerService.swift
//  CraftYourProfile
//
//  Created by Дмитрий Константинов on 10.06.2020.
//  Copyright © 2020 Дмитрий Константинов. All rights reserved.
//

import UIKit

struct ViewDesignerService {

    let view: UIView

    init(_ view: UIView) {
        self.view = view
    }

    func backButtonPlacement(_ button: UIControl) {

        NSLayoutConstraint.activate([
            button.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 12),
            button.heightAnchor.constraint(equalToConstant: 44),
            button.widthAnchor.constraint(equalToConstant: 44),
            button.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 18)
        ])
    }

    func mainLabelPlacement(_ mainLabel: UIView, _ topElement: UIView) {

        NSLayoutConstraint.activate([
            mainLabel.topAnchor.constraint(equalTo: topElement.bottomAnchor, constant: 24),
            mainLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 24),
            mainLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -48)
        ])
    }

    func additionalLabelPlacement(_ additionalLabel: UIView, _ topElement: UIView) {

        NSLayoutConstraint.activate([
            additionalLabel.topAnchor.constraint(equalTo: topElement.bottomAnchor, constant: 24),
            additionalLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            additionalLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -48)
        ])
    }

    func mainTextFieldPlacement(_ textField: UIView, _ topElement: UIView, _ specialHeight: Bool = false) {

        var textFieldHeight: CGFloat = 50
        if specialHeight { textFieldHeight = (view.bounds.width - 48 - 30) / 6 }

        NSLayoutConstraint.activate([
            textField.topAnchor.constraint(equalTo: topElement.bottomAnchor, constant: 24),
            textField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            textField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            textField.heightAnchor.constraint(equalToConstant: textFieldHeight)
        ])
    }
}
