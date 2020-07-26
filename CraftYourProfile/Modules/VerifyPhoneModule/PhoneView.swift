//
//  PhoneView.swift
//  CraftYourProfile
//
//  Created by Дмитрий Константинов on 22.06.2020.
//  Copyright © 2020 Дмитрий Константинов. All rights reserved.
//

import UIKit

protocol PhoneViewDelegate: AnyObject {
    func shouldChangeCharactersIn(textField: UITextField, string: String) -> Bool
    func textFieldDidChangeSelection(textField: UITextField)
    func codeButtonTapped(view: UIView)
}

protocol PhoneViewUpdater: UIView {
    func setCodeValue(string: String)
    func getPhoneString() -> String?
}

class PhoneView: UIView {

    private let codeTextField = UITextField()
    private let codeButton = UIButton(image: UIImage(named: "rexona"))
    private let lineView = UIView()
    private let phoneTextField = UITextField()

    weak var delegate: PhoneViewDelegate?

    init(delegate: PhoneViewDelegate) {
        self.init()
        self.delegate = delegate
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        setupView()
        setupConstraints()

        codeButton.addTarget(self, action: #selector(codeButtonTapped), for: .touchUpInside)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc private func codeButtonTapped() {
        codeButton.clickAnimation()
        delegate?.codeButtonTapped(view: codeButton)
    }

    private func setupView() {
        codeTextField.translatesAutoresizingMaskIntoConstraints = false
        codeButton.translatesAutoresizingMaskIntoConstraints = false
        lineView .translatesAutoresizingMaskIntoConstraints = false
        phoneTextField.translatesAutoresizingMaskIntoConstraints = false

        backgroundColor = .backgroundGray()
        layer.cornerRadius = 15

        codeTextField.backgroundColor = .clear
        phoneTextField.backgroundColor = .clear
        lineView.backgroundColor = .grayText()
        codeTextField.font = .compactRounded(style: .semibold, size: 20)
        codeTextField.textAlignment = .right
        codeTextField.isUserInteractionEnabled = false
        phoneTextField.font = .compactRounded(style: .semibold, size: 20)
        phoneTextField.keyboardType = .phonePad

        codeTextField.minimumFontSize = 16
        phoneTextField.minimumFontSize = 16

        codeTextField.adjustsFontSizeToFitWidth = true
        phoneTextField.adjustsFontSizeToFitWidth = true
        phoneTextField.delegate = self

        addSubview(codeTextField)
        addSubview(codeButton)
        addSubview(lineView)
        addSubview(phoneTextField)
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            codeTextField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            codeTextField.centerYAnchor.constraint(equalTo: centerYAnchor),
            codeTextField.widthAnchor.constraint(equalToConstant: 50),

            codeButton.leadingAnchor.constraint(equalTo: codeTextField.trailingAnchor, constant: 0),
            codeButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            codeButton.heightAnchor.constraint(equalToConstant: 40),
            codeButton.widthAnchor.constraint(equalToConstant: 40),

            lineView.leadingAnchor.constraint(equalTo: codeButton.trailingAnchor, constant: 0),
            lineView.topAnchor.constraint(equalTo: topAnchor),
            lineView.bottomAnchor.constraint(equalTo: bottomAnchor),
            lineView.widthAnchor.constraint(equalToConstant: 1),

            phoneTextField.leadingAnchor.constraint(equalTo: lineView.trailingAnchor, constant: 12),
            phoneTextField.centerYAnchor.constraint(equalTo: centerYAnchor),
            phoneTextField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12)
        ])
    }
}

// MARK: PhoneViewUpdater
extension PhoneView: PhoneViewUpdater {
    func setCodeValue(string: String) {
        codeTextField.text = string
    }

    func getPhoneString() -> String? {
        return phoneTextField.text
    }
}

// MARK: UITextFieldDelegate
extension PhoneView: UITextFieldDelegate {
    func textField(_ textField: UITextField,
                   shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {

        return delegate?.shouldChangeCharactersIn(textField: textField, string: string) ?? true
    }

    func textFieldDidChangeSelection(_ textField: UITextField) {
        delegate?.textFieldDidChangeSelection(textField: textField)
    }
}
