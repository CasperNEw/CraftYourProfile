//
//  PinView.swift
//  CraftYourProfile
//
//  Created by Дмитрий Константинов on 10.06.2020.
//  Copyright © 2020 Дмитрий Константинов. All rights reserved.
//

import UIKit

class PinView: UIView {

    let pin = UIView()
    let number = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .backgroundGray()
        layer.cornerRadius = 15
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        pin.backgroundColor = .gray
        pin.layer.cornerRadius = 5
        pin.layer.masksToBounds = true
        pin.translatesAutoresizingMaskIntoConstraints = false
        translatesAutoresizingMaskIntoConstraints = false
        addSubview(pin)

        number.font = .compactRounded(style: .semibold, size: 18)
        number.textAlignment = .center
        number.adjustsFontSizeToFitWidth = true
        number.translatesAutoresizingMaskIntoConstraints = false
        number.isHidden = true
        addSubview(number)

        NSLayoutConstraint.activate([
            pin.centerXAnchor.constraint(equalTo: centerXAnchor),
            pin.centerYAnchor.constraint(equalTo: centerYAnchor),
            pin.widthAnchor.constraint(equalToConstant: 10),
            pin.heightAnchor.constraint(equalToConstant: 10),

            number.centerXAnchor.constraint(equalTo: centerXAnchor),
            number.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
}
