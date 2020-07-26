//
//  CountryCodeCell.swift
//  CraftYourProfile
//
//  Created by Дмитрий Константинов on 08.06.2020.
//  Copyright © 2020 Дмитрий Константинов. All rights reserved.
//

import UIKit

class CountryCodeCell: UICollectionViewCell {
    static let reuseIdentifier = "countryCode-cell-reuse-identifier"
    private let label = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCell()
    }
    required init?(coder: NSCoder) {
        fatalError("not implemented")
    }

    func configure(with text: String) {
        self.label.text = text
    }
}

extension CountryCodeCell {
    func setupCell() {
        label.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(label)
        label.font = UIFont.compactRounded(style: .semibold, size: 18)
        label.adjustsFontForContentSizeCategory = true
        layer.cornerRadius = 10
        layer.borderWidth = 0.8
        layer.borderColor = UIColor.grayText().cgColor
        let view = UIView(frame: bounds)
        view.backgroundColor = .backgroundGray()
        view.layer.cornerRadius = 10
        selectedBackgroundView = view
        let inset = CGFloat(10)
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: inset),
            label.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -inset),
            label.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
}
