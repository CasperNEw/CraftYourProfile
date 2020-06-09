//
//  VerifyPhoneView.swift
//  CraftYourProfile
//
//  Created by Дмитрий Константинов on 03.06.2020.
//  Copyright © 2020 Дмитрий Константинов. All rights reserved.
//

import UIKit

class VerifyPhoneView: UIView {

// MARK: Init
    private let crossButton = UIButton(image: UIImage(named: "cross"))
    private let mainLabel = UILabel(text: "Let's verify your phone number 😘",
                            font: .compactRounded(style: .black, size: 32),
                            color: .mainBlackText(), lines: 2, alignment: .left)
    private let additionalLabel = UILabel(text: "PHONE NUMBER",
                                  font: .compactRounded(style: .semibold, size: 15),
                                  color: .gray, lines: 1, alignment: .left)

    private let phoneView = UIView()
    private let phoneTextField = UITextField()
    private let codeTextField = UITextField()
    private let codeButton = UIButton(image: UIImage(named: "rexona"))
    private let lineView = UIView()

    private let nextButton = UIButton(title: "Next", titleColor: .white,
                               backgroundColor: .blueButton(),
                               font: .compactRounded(style: .semibold, size: 20),
                               cornerRadius: 20)

    weak var delegate: VerifyPhoneViewDelegate?

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
        setupPhoneView()
        setupNextButton()
        addSubviews()

        crossButton.addTarget(self, action: #selector(crossButtonTapped), for: .touchUpInside)
        codeButton.addTarget(self, action: #selector(codeButtonTapped), for: .touchUpInside)
        nextButton.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
    }

    private func setupConstraints() {
        setupMainConstraints()
        setupPhoneViewConstraints()
    }

    @objc private func crossButtonTapped() {
        crossButton.clickAnimation()
        delegate?.crossButtonTapped()
    }
    @objc private func codeButtonTapped() {
        codeButton.clickAnimation()
        delegate?.codeButtonTapped(codeButton)
    }
    @objc private func nextButtonTapped() {
        nextButton.clickAnimation(with: 0.9)
        delegate?.nextButtonTapped(string: phoneTextField.text)
    }
}

// MARK: Setup Views
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

    private func setupPhoneView() {
        codeTextField.translatesAutoresizingMaskIntoConstraints = false
        codeButton.translatesAutoresizingMaskIntoConstraints = false
        lineView .translatesAutoresizingMaskIntoConstraints = false
        phoneTextField.translatesAutoresizingMaskIntoConstraints = false

        phoneView.backgroundColor = .backgroundGray()
        phoneView.layer.cornerRadius = 15

        codeTextField.backgroundColor = .clear
        phoneTextField.backgroundColor = .clear
        lineView.backgroundColor = .grayText()
        codeTextField.font = .compactRounded(style: .semibold, size: 20)
        codeTextField.contentMode = .center
        codeTextField.isUserInteractionEnabled = false
        phoneTextField.font = .compactRounded(style: .semibold, size: 20)
        phoneTextField.keyboardType = .phonePad

        codeTextField.adjustsFontSizeToFitWidth = true
        phoneTextField.adjustsFontSizeToFitWidth = true
        phoneTextField.delegate = self

        phoneView.addSubview(codeTextField)
        phoneView.addSubview(codeButton)
        phoneView.addSubview(lineView)
        phoneView.addSubview(phoneTextField)
    }

    private func setupNextButton() {
        nextButton.addRightImage(image: UIImage(named: "next"), side: 30, offset: -10)
    }
}

// MARK: Setup Constraints
extension VerifyPhoneView {

    private func setupPhoneViewConstraints() {
        NSLayoutConstraint.activate([
            codeTextField.leadingAnchor.constraint(equalTo: phoneView.leadingAnchor, constant: 12),
            codeTextField.centerYAnchor.constraint(equalTo: phoneView.centerYAnchor),
            codeTextField.widthAnchor.constraint(equalToConstant: bounds.width * 0.13),

            codeButton.leadingAnchor.constraint(equalTo: codeTextField.trailingAnchor, constant: 0),
            codeButton.centerYAnchor.constraint(equalTo: phoneView.centerYAnchor),
            codeButton.heightAnchor.constraint(equalToConstant: 40),
            codeButton.widthAnchor.constraint(equalToConstant: 40),

            lineView.leadingAnchor.constraint(equalTo: codeButton.trailingAnchor, constant: 0),
            lineView.topAnchor.constraint(equalTo: phoneView.topAnchor),
            lineView.bottomAnchor.constraint(equalTo: phoneView.bottomAnchor),
            lineView.widthAnchor.constraint(equalToConstant: 1),

            phoneTextField.leadingAnchor.constraint(equalTo: lineView.trailingAnchor, constant: 12),
            phoneTextField.centerYAnchor.constraint(equalTo: phoneView.centerYAnchor),
            phoneTextField.trailingAnchor.constraint(equalTo: phoneView.trailingAnchor, constant: -12)
        ])
    }

    private func setupMainConstraints() {

        NSLayoutConstraint.activate([
            crossButton.leftAnchor.constraint(equalTo: leftAnchor, constant: 12),
            crossButton.heightAnchor.constraint(equalToConstant: 44),
            crossButton.widthAnchor.constraint(equalToConstant: 44),
            crossButton.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 18),

            mainLabel.topAnchor.constraint(equalTo: crossButton.bottomAnchor, constant: 24),
            mainLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 24),
            mainLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -48),

            additionalLabel.topAnchor.constraint(equalTo: mainLabel.bottomAnchor, constant: 24),
            additionalLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24),
            additionalLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -48),

            phoneView.topAnchor.constraint(equalTo: additionalLabel.bottomAnchor, constant: 24),
            phoneView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24),
            phoneView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -24),
            phoneView.heightAnchor.constraint(equalToConstant: 50),

            nextButton.topAnchor.constraint(equalTo: phoneView.bottomAnchor, constant: 170),
            nextButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24),
            nextButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -24),
            nextButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
}

// MARK: UITextFieldDelegate
extension VerifyPhoneView: UITextFieldDelegate {
    func textField(_ textField: UITextField,
                   shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {

        return delegate?.shouldChangeCharactersIn(textField, string: string) ?? true
    }
    func textFieldDidChangeSelection(_ textField: UITextField) {
        delegate?.textFieldDidChangeSelection(textField)
    }
}

// MARK: VerifyPhoneViewUpdater
extension VerifyPhoneView: VerifyPhoneViewUpdater {

    func setNewValue(string: String) {
        codeTextField.text = string
    }
}

// MARK: SwiftUI
import SwiftUI

struct VerifyPhoneViewProvider: PreviewProvider {
    static var previews: some View {
        ContainerView().edgesIgnoringSafeArea(.all)
    }

    struct ContainerView: UIViewControllerRepresentable {
        let verifyPhoneVC = VerifyPhoneViewController()
        // swiftlint:disable line_length
        func makeUIViewController(context: UIViewControllerRepresentableContext<VerifyPhoneViewProvider.ContainerView>) -> VerifyPhoneViewController {
            return verifyPhoneVC
        }
        func updateUIViewController(_ uiViewController: VerifyPhoneViewProvider.ContainerView.UIViewControllerType, context: UIViewControllerRepresentableContext<VerifyPhoneViewProvider.ContainerView>) {
        }
        // swiftlint:enable line_length
    }
}
