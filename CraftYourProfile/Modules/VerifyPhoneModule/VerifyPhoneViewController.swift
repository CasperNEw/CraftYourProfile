//
//  VerifyPhoneViewController.swift
//  CraftYourProfile
//
//  Created by Дмитрий Константинов on 27.05.2020.
//  Copyright © 2020 Дмитрий Константинов. All rights reserved.
//

import UIKit

class VerifyPhoneViewController: UIViewController {

    // MARK: - Properties
    private lazy var presentationView: VerifyPhoneView = {
        let view = VerifyPhoneView()
        view.delegate = self
        return view
    }()

    var networkService: NetworkServiceLimitedProtocol?
    var validationService: ValidationService?

    private var selectedCode: CountryCode? {
        didSet {
            guard let code = selectedCode?.code else { return }
            presentationView.setCountryCode(string: code)
        }
    }

    lazy private var countryCodeViewController: CountryCodeViewController = {
        let viewController = CountryCodeConfigurator.create()
        CountryCodeConfigurator.configure(with: viewController)
        viewController.delegate = self
        return viewController
    }()

    // MARK: - Phone Validation
    private var shouldChangeValidation: Bool = false
    private var didChangeValidtion: Bool = false {
        didSet { shouldChangeValidation = didChangeValidtion }
    }

    // MARK: - Lifecycle
    override func loadView() {
        view = ScrollViewContainer(with: presentationView)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        loadData()
    }

    // MARK: - Module functions
    private func loadData() {

        let regionCode = Locale.current.regionCode ?? "RU"
        networkService?.getCountryInformation(shortCode: regionCode,
                                              completion: { [weak self] result in

            switch result {
            case .success(let country):
                guard let code = country.callingCodes.first else { return }
                self?.selectedCode = CountryCode(code: "+" + code,
                                                name: country.name,
                                                shortName: country.alpha2Code)
            case .failure(let error):
                self?.showAlert(with: "Network Error", and: error.localizedDescription)
            }
        })
    }
}

// MARK: VerifyPhoneViewDelegate
extension VerifyPhoneViewController: VerifyPhoneViewDelegate {

    func shouldChangeCharactersIn(_ textField: UITextField, string: String) -> Bool {

        if string.isEmpty {
            textField.text?.removeAll { $0 == "-" }
            return true
        }
        if Int(string) == nil { return false }

        return !shouldChangeValidation
    }

    func textFieldDidChangeSelection(_ textField: UITextField) {

        guard let phone = textField.text else { return }
        didChangeValidtion = validationStatus(phone: phone)

        presentationView.setNextButtonIsEnabled(didChangeValidtion, animate: true)
        if didChangeValidtion {

            validationService?.phoneFormatting(phone: phone,
                                               code: selectedCode?.shortName ?? "",
                                               completion: { [weak self] result in

                switch result {
                case .success(let formattedPhone):
                    textField.text = formattedPhone
                case .failure(let error):
                    self?.showAlert(with: "Validation Error", and: error.localizedDescription)
                }
            })
        }
    }

    func crossButtonTapped() {
        dismiss(animated: true)
    }

    func codeButtonTapped(_ view: UIView) {
        present(countryCodeViewController, animated: true)
    }

    func nextButtonTapped(phone: String) {

        let pinCode = AuthorizationService.shared.generationPinCode(with: 6)
        do {
            try AuthorizationService.shared.signIn(account: phone, pinCode: pinCode)
        } catch let error {
            showAlert(with: "Keychain Error", and: error.localizedDescription)
            return
        }
        view.endEditing(true)
        showAlert(with: "Success", and: "A PIN code \(pinCode) has been sent to your phone number") {

            let viewController = VerifyPinCodeViewController()
            viewController.timerService = self.createTimerService()
            self.navigationController?.pushViewController(viewController, animated: true)
        }
    }
}

// MARK: - Module functions
extension VerifyPhoneViewController {

    private func validationStatus(phone: String?) -> Bool {

        guard let phone = phone else { return false }
        if phone.count < 5 { return false }
        if selectedCode?.shortName.isEmpty ?? true { return false }

        var validationStatus = false

        validationService?.isValid(phone: phone,
                                   region: selectedCode?.shortName ?? "",
                                   completion: { [weak self] result in

            switch result {
            case .success(let isValid):
                validationStatus = isValid
            case .failure(let error):
                self?.showAlert(with: "Validation Error", and: error.localizedDescription)
            }
        })

        return validationStatus
    }

    private func createTimerService() -> TimerService {

        let timerService = TimerService()
        timerService.startTimer(with: 20)
        return timerService
    }
}

// MARK: CountryCodeViewControllerDelegate
extension VerifyPhoneViewController: CountryCodeViewControllerDelegate {

    func didSelectItem(code: CountryCode) {
        selectedCode = code
    }
}
