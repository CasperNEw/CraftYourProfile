//
//  PinView.swift
//  CraftYourProfile
//
//  Created by Дмитрий Константинов on 10.06.2020.
//  Copyright © 2020 Дмитрий Константинов. All rights reserved.
//

import UIKit

class PinView: UIView {

    // MARK: - Properties
    let pin = UIView()
    let number = UILabel()

    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Module function
    private func setupUI() {

        backgroundColor = .backgroundGray()
        layer.cornerRadius = 15
        translatesAutoresizingMaskIntoConstraints = false

        pin.backgroundColor = .gray
        pin.layer.cornerRadius = 5
        pin.layer.masksToBounds = true

        number.font = .compactRounded(style: .semibold, size: 18)
        number.textAlignment = .center
        number.adjustsFontSizeToFitWidth = true
        number.isHidden = true

        addSubviews([pin, number])

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
