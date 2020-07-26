//
//  VerifyPhoneView.swift
//  CraftYourProfile
//
//  Created by Дмитрий Константинов on 03.06.2020.
//  Copyright © 2020 Дмитрий Константинов. All rights reserved.
//

import UIKit

protocol VerifyPhoneViewDelegate: AnyObject {

    func shouldChangeCharactersIn(_ textField: UITextField, string: String) -> Bool
    func textFieldDidChangeSelection(_ textField: UITextField)

    func crossButtonTapped()
    func codeButtonTapped(_ view: UIView)
    func nextButtonTapped(string: String?)
}

protocol VerifyPhoneViewUpdater {

    func setNewValue(string: String)
}

class VerifyPhoneView: UIView {

    // MARK: Init
    private let crossButton = PushButton(image: UIImage(named: "cross"))
    private let mainLabel = UILabel(text: "Let's verify your phone number 😘",
                                    font: .compactRounded(style: .black, size: 32),
                                    color: .mainBlackText(), lines: 2, alignment: .left)
    private let additionalLabel = UILabel(text: "PHONE NUMBER",
                                          font: .compactRounded(style: .semibold, size: 15),
                                          color: .gray, lines: 1, alignment: .left)

    lazy private var phoneView: PhoneViewUpdater = {
        let view = PhoneView(delegate: self)
        return view
    }()

    private let nextButton = PushButton(title: "Next", titleColor: .white,
                                        backgroundColor: .blueButton(),
                                        font: .compactRounded(style: .semibold, size: 20),
                                        cornerRadius: 20,
                                        transformScale: 0.9)

    weak var delegate: VerifyPhoneViewDelegate?
    lazy private var designer: ViewDesignerService = {
        return ViewDesignerService(self)
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)

        self.backgroundColor = .white
        setupViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        setupConstraints()
    }

    private func setupViews() {
        setupNextButton()
        addSubviews()

        crossButton.addTarget(self, action: #selector(crossButtonTapped), for: .touchUpInside)
        nextButton.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
    }

    private func setupConstraints() {
        setupMainConstraints()
    }

    @objc private func crossButtonTapped() {
        delegate?.crossButtonTapped()
    }

    @objc private func nextButtonTapped() {
        let string = phoneView.getPhoneString()
        delegate?.nextButtonTapped(string: string)
    }
}

// MARK: setupViews
extension VerifyPhoneView {

    private func addSubviews() {
        crossButton.translatesAutoresizingMaskIntoConstraints = false
        mainLabel.translatesAutoresizingMaskIntoConstraints = false
        additionalLabel.translatesAutoresizingMaskIntoConstraints = false
        phoneView.translatesAutoresizingMaskIntoConstraints = false
        nextButton.translatesAutoresizingMaskIntoConstraints = false

        addSubview(crossButton)
        addSubview(mainLabel)
        addSubview(additionalLabel)
        addSubview(phoneView)
        addSubview(nextButton)
    }

    private func setupNextButton() {
        nextButton.addRightImage(image: UIImage(named: "next"), side: 30, offset: -10)
    }
}

// MARK: setupConstraints
extension VerifyPhoneView {

    private func setupMainConstraints() {

        designer.setBackButton(crossButton)
        designer.setView(mainLabel, with: crossButton)
        designer.setView(additionalLabel, with: mainLabel)
        designer.setView(phoneView, with: additionalLabel, trailingIsShort: false,
                         withHeight: true, specialHeight: false)
        designer.setBottomView(nextButton, with: phoneView)
    }
}

// MARK: VerifyPhoneViewUpdater
extension VerifyPhoneView: VerifyPhoneViewUpdater {

    func setNewValue(string: String) {
        phoneView.setCodeValue(string: string)
    }
}

// MARK: PhoneViewDelegate
extension VerifyPhoneView: PhoneViewDelegate {

    func shouldChangeCharactersIn(textField: UITextField, string: String) -> Bool {
        return delegate?.shouldChangeCharactersIn(textField, string: string) ?? true
    }

    func textFieldDidChangeSelection(textField: UITextField) {
        delegate?.textFieldDidChangeSelection(textField)
    }

    func codeButtonTapped(view: UIView) {
        delegate?.codeButtonTapped(view)
    }
}
