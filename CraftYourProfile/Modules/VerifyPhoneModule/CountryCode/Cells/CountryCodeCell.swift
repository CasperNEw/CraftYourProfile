//
//  CountryCodeCell.swift
//  CraftYourProfile
//
//  Created by Дмитрий Константинов on 08.06.2020.
//  Copyright © 2020 Дмитрий Константинов. All rights reserved.
//

import UIKit

class CountryCodeCell: UICollectionViewCell {

    // MARK: - Properties
    static let identifier = String(describing: CountryCodeCell.self)

    private let codeLabel = UILabel(text: "",
                                    font: UIFont.compactRounded(style: .semibold, size: 20),
                                    color: .mainBlackText(),
                                    lines: 1,
                                    alignment: .left)

    private let titleLabel = UILabel(text: "",
                                     font: UIFont.compactRounded(style: .semibold, size: 20),
                                     color: .mainBlackText(),
                                     lines: 1,
                                     alignment: .left)

    private let flagImageView = UIImageView()

    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    required init?(coder: NSCoder) {
        fatalError("not implemented")
    }

    // MARK: - Lifecycle
    override func prepareForReuse() {
        super.prepareForReuse()

        codeLabel.text = ""
        titleLabel.text = ""
        flagImageView.image = nil
    }

    // MARK: - Public function
    public func setupCell(code: String,
                          country: String,
                          imageUrl: String) {

        codeLabel.text = code
        titleLabel.text = country

        ImageCache.publicCache.load(urlString: imageUrl) { image in
            self.flagImageView.image = image
        }
    }

    // MARK: - Module functions
    private func setupViews() {

        addSubviews([codeLabel, flagImageView, titleLabel])
        flagImageView.contentMode = .scaleAspectFit
        titleLabel.adjustsFontSizeToFitWidth = false
        setupConstraints()
    }

    private func setupConstraints() {

        NSLayoutConstraint.activate([
            codeLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            codeLabel.widthAnchor.constraint(equalToConstant: 60),
            codeLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),

            flagImageView.leadingAnchor.constraint(equalTo: codeLabel.trailingAnchor, constant: 5),
            flagImageView.widthAnchor.constraint(equalToConstant: 40),
            flagImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            flagImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),

            titleLabel.leadingAnchor.constraint(equalTo: flagImageView.trailingAnchor, constant: 10),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
}
