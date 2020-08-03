//
//  ThanksView.swift
//  CraftYourProfile
//
//  Created by Дмитрий Константинов on 03.08.2020.
//  Copyright © 2020 Дмитрий Константинов. All rights reserved.
//

import UIKit

protocol ThanksViewDelegate: AnyObject {

    func backButtonTapped()
    func closeButtonTapped()
}

class ThanksView: UIView {

    // MARK: - Properties
    private let backButton = PushButton(image: UIImage(named: "back"))

    private let mainLabel = UILabel(text: "Thanks for watching 🥳",
                                    font: .compactRounded(style: .black, size: 32),
                                    color: .mainBlackText(), lines: 2, alignment: .center)

    private let cancelButton = PushButton(title: "Cancel", titleColor: .white,
                                        backgroundColor: .blueButton(),
                                        font: .compactRounded(style: .semibold, size: 20),
                                        cornerRadius: 20,
                                        transformScale: 0.9)

    weak var delegate: ThanksViewDelegate?
    private var didSetupConstraints = false

    lazy private var designer: ViewDesignerService = {
        return ViewDesignerService(self)
    }()

    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle
    override func updateConstraints() {
        super.updateConstraints()

        if !didSetupConstraints {
            setupConstraints()
            didSetupConstraints = true
        }
    }

    // MARK: - Actions
    @objc func backButtonTapped() {
        delegate?.backButtonTapped()
    }

    @objc func cancelButtonTapped() {
        delegate?.closeButtonTapped()
    }
}

// MARK: - Module functions
extension ThanksView {

    private func setupViews() {

        backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        addSubviews([backButton, mainLabel, cancelButton])

        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        cancelButton.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
    }

    private func setupConstraints() {

        designer.setBackButton(backButton)

        NSLayoutConstraint.activate([

            mainLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24),
            mainLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -24),
            mainLabel.centerYAnchor.constraint(equalTo: centerYAnchor),

            cancelButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24),
            cancelButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -24),
            cancelButton.heightAnchor.constraint(equalToConstant: 50),
            cancelButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -46)
        ])
    }
}
