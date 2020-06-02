//
//  VerifyPhoneViewController.swift
//  CraftYourProfile
//
//  Created by Дмитрий Константинов on 27.05.2020.
//  Copyright © 2020 Дмитрий Константинов. All rights reserved.
//

import UIKit
import libPhoneNumber_iOS

class VerifyPhoneViewController: UIViewController {

// MARK: Init
    let crossButton = UIControl(image: UIImage(named: "cross"))
    let mainLabel = UILabel(text: "Let's verify your phone number 😘",
                            font: .compactRounded(style: .black, size: 32),
                            color: .mainBlackText(), lines: 2, alignment: .left)
    let additionalLabel = UILabel(text: "PHONE NUMBER",
                                  font: .compactRounded(style: .semibold, size: 15),
                                  color: .gray, lines: 1, alignment: .left)

    let magicView = UIView()
    let phoneTextField = UITextField()
    let countryCodeTextField = UITextField()
    let button = UIButton(image: UIImage(named: "rexona"))
    let lineView = UIView()

    let validationService = PhoneValidationService()
    let networkService = NetworkService()
    var countryInf: [CountryFromServer] = []

// MARK: viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white

        getCountryCodes()
        configureMagicView()
        setupTextField()
        setupConstraints()

        crossButton.addTarget(self, action: #selector(crossButtonTapped), for: .touchUpInside)
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)

        let hideAction = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        view.addGestureRecognizer(hideAction)
    }

    @objc func hideKeyboard() {
        view.endEditing(true)
    }

    @objc func crossButtonTapped() {
        crossButton.clickAnimation()
        perform(#selector(popViewController), with: nil, afterDelay: 0.5)
    }

    @objc func popViewController() {
        navigationController?.popViewController(animated: true)
    }

    @objc func buttonTapped() {
        let popOver = PopoverTableViewController()
        popOver.modalPresentationStyle = .popover
        let popOverVC = popOver.popoverPresentationController
        popOverVC?.delegate = self
        popOverVC?.sourceView = self.button
        popOverVC?.sourceRect = CGRect(x: self.button.bounds.midX, y: self.button.bounds.maxY, width: 0, height: 0)
        popOver.preferredContentSize = CGSize(width: 250, height: 250)

        self.present(popOver, animated: true)
    }

    func setupTextField() {
        phoneTextField.font = .compactRounded(style: .semibold, size: 20)
        phoneTextField.textContentType = .telephoneNumber
        phoneTextField.keyboardType = .phonePad
        phoneTextField.delegate = self
    }

    func getCountryCodes() {
        networkService.getCountriesInformation { [weak self] result in
            switch result {
            case .success(let data):
                self?.countryInf = data
                print(self?.countryInf ?? "check me - \(#function)")
                //TODO: надо форматировать в новую структуру данных подходящую для отображения в PopoverVC
            case .failure(let error):
                print(error.localizedDescription) //TODO: error processing
            }
        }
    }
}

// MARK: Setup Subviews
extension VerifyPhoneViewController {

    private func configureMagicView() {
        magicView.translatesAutoresizingMaskIntoConstraints = false

        countryCodeTextField.translatesAutoresizingMaskIntoConstraints = false
        button.translatesAutoresizingMaskIntoConstraints = false
        lineView .translatesAutoresizingMaskIntoConstraints = false
        phoneTextField.translatesAutoresizingMaskIntoConstraints = false

        magicView.backgroundColor = .backgroundGray()
        magicView.layer.cornerRadius = 15

        countryCodeTextField.backgroundColor = .black
        phoneTextField.backgroundColor = .clear
        lineView.backgroundColor = .grayText()
        countryCodeTextField.font = .compactRounded(style: .semibold, size: 20)
        countryCodeTextField.isUserInteractionEnabled = false

        magicView.addSubview(countryCodeTextField)
        magicView.addSubview(button)
        magicView.addSubview(lineView)
        magicView.addSubview(phoneTextField)

        NSLayoutConstraint.activate([
            countryCodeTextField.leadingAnchor.constraint(equalTo: magicView.leadingAnchor, constant: 12),
            countryCodeTextField.centerYAnchor.constraint(equalTo: magicView.centerYAnchor),
            countryCodeTextField.widthAnchor.constraint(equalToConstant: view.bounds.width * 0.13),

            button.leadingAnchor.constraint(equalTo: countryCodeTextField.trailingAnchor, constant: 0),
            button.centerYAnchor.constraint(equalTo: magicView.centerYAnchor),
            button.heightAnchor.constraint(equalToConstant: 40),
            button.widthAnchor.constraint(equalToConstant: 40),

            lineView.leadingAnchor.constraint(equalTo: button.trailingAnchor, constant: 0),
            lineView.topAnchor.constraint(equalTo: magicView.topAnchor),
            lineView.bottomAnchor.constraint(equalTo: magicView.bottomAnchor),
            lineView.widthAnchor.constraint(equalToConstant: 1),

            phoneTextField.leadingAnchor.constraint(equalTo: lineView.trailingAnchor, constant: 12),
            phoneTextField.centerYAnchor.constraint(equalTo: magicView.centerYAnchor),
            phoneTextField.trailingAnchor.constraint(equalTo: magicView.trailingAnchor, constant: -12)
        ])

    }

    private func setupConstraints() {

        crossButton.translatesAutoresizingMaskIntoConstraints = false
        mainLabel.translatesAutoresizingMaskIntoConstraints = false
        additionalLabel.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(crossButton)
        view.addSubview(mainLabel)
        view.addSubview(additionalLabel)
        view.addSubview(magicView)

        NSLayoutConstraint.activate([

            crossButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 12),
            crossButton.heightAnchor.constraint(equalToConstant: 44),
            crossButton.widthAnchor.constraint(equalToConstant: 44),
            crossButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 18),

            mainLabel.topAnchor.constraint(equalTo: crossButton.bottomAnchor, constant: 24),
            mainLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            mainLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -48),

            additionalLabel.topAnchor.constraint(equalTo: mainLabel.bottomAnchor, constant: 24),
            additionalLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            additionalLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -48),

            magicView.topAnchor.constraint(equalTo: additionalLabel.bottomAnchor, constant: 24),
            magicView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            magicView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            magicView.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
}

extension VerifyPhoneViewController: UITextFieldDelegate {

    func textField(_ textField: UITextField,
                   shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {

        if validationService.isValid(phone: textField.text!, region: "RU"), (string != "") {
            return false
        }
        return true
    }

    func textFieldDidChangeSelection(_ textField: UITextField) {
        guard let text = textField.text else { return }
        print(validationService.format(phone: text, region: "RU"))
    }
}

// MARK: UIPopoverPresentationControllerDelegate
extension VerifyPhoneViewController: UIPopoverPresentationControllerDelegate {
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
}

// MARK: SwiftUI
import SwiftUI

struct VerifyPhoneVCProvider: PreviewProvider {
    static var previews: some View {
        ContainerView().edgesIgnoringSafeArea(.all)
    }

    struct ContainerView: UIViewControllerRepresentable {
        let verifyPhoneVC = VerifyPhoneViewController()
        // swiftlint:disable line_length
        func makeUIViewController(context: UIViewControllerRepresentableContext<VerifyPhoneVCProvider.ContainerView>) -> VerifyPhoneViewController {
            return verifyPhoneVC
        }
        func updateUIViewController(_ uiViewController: VerifyPhoneVCProvider.ContainerView.UIViewControllerType, context: UIViewControllerRepresentableContext<VerifyPhoneVCProvider.ContainerView>) {
        }
        // swiftlint:enable line_length
    }
}
