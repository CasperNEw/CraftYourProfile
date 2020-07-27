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

class PhoneView: UIView {

    // MARK: - Properties
    lazy private var phoneTextField: UITextField = {

        let textField = UITextField()
        textField.backgroundColor = .clear
        textField.font = .compactRounded(style: .semibold, size: 20)
        textField.keyboardType = .phonePad
        textField.minimumFontSize = 16
        textField.adjustsFontSizeToFitWidth = true
        textField.delegate = self
        return textField
    }()

    private let codeTextField: UITextField = {

        let textField = UITextField()
        textField.backgroundColor = .clear
        textField.font = .compactRounded(style: .semibold, size: 20)
        textField.textAlignment = .right
        textField.isUserInteractionEnabled = false
        textField.minimumFontSize = 16
        textField.adjustsFontSizeToFitWidth = true
        return textField
    }()

    private let lineView: UIView = {
        let view = UIView()
        view.backgroundColor = .grayText()
        return view
    }()

    private let codeButton = PushButton(image: UIImage(named: "rexona"))

    weak var delegate: PhoneViewDelegate?

    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)

        setupView()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Module functions
    private func setupView() {

        backgroundColor = .backgroundGray()
        layer.cornerRadius = 15
        addSubviews([codeTextField, codeButton, lineView, phoneTextField])
        codeButton.addTarget(self, action: #selector(codeButtonTapped), for: .touchUpInside)
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

    // MARK: - Public functions
    public func setCodeValue(string: String) {
        codeTextField.text = string
    }

    public func getPhoneString() -> String? {
        return phoneTextField.text
    }

    // MARK: - Actions
    @objc private func codeButtonTapped() {
        delegate?.codeButtonTapped(view: codeButton)
    }
}

// MARK: UITextFieldDelegate
extension PhoneView: UITextFieldDelegate {

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {

        return delegate?.shouldChangeCharactersIn(textField: textField, string: string) ?? true
    }

    func textFieldDidChangeSelection(_ textField: UITextField) {
        delegate?.textFieldDidChangeSelection(textField: textField)
    }
}
