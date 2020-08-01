//
//  VerifyPinCodeViewController.swift
//  CraftYourProfile
//
//  Created by Дмитрий Константинов on 10.06.2020.
//  Copyright © 2020 Дмитрий Константинов. All rights reserved.
//

import UIKit

class VerifyPinCodeViewController: UIViewController {

    // MARK: - Properties
    private lazy var presentationView: VerifyPinCodeView = {
        let view = VerifyPinCodeView()
        view.delegate = self
        return view
    }()

    var timerService: TimerService?
    private var isFirstLoad = true

    // MARK: - Lifecycle
    override func loadView() {
        view = ScrollViewContainer(with: presentationView)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        bindTimer()
    }

    // MARK: - Module functions
    private func startTimer() {
        presentationView.hideResendCodeButton()
        timerService?.startTimer(with: 20)
    }

    private func bindTimer() {

        timerService?.timerCompletion = { [weak self] timer in

            switch timer {
            case .fire(let value):
                self?.presentationView.updateResendCodeLabel(with: value)
            case .expired:
                self?.presentationView.hideResendCodeLabel()
            }
        }
    }

    private func validation(isValid: Bool) {

        if !isValid {
            presentationView.shakePinCodeView()
            return
        }

        view.endEditing(true)
        isFirstLoad = false
        showAlert(with: "Success", and: "Go to Create Your Profile! 😍") {
            let viewController = IntroduceYourselfViewController()
            self.navigationController?.pushViewController(viewController, animated: true)
        }
    }
}

// MARK: VerifyPinCodeViewDelegate
extension VerifyPinCodeViewController: VerifyPinCodeViewDelegate {

    func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }

    func resendCodeButtonTapped() {

        AuthorizationService.shared.updatePinCode { [weak self] result in

            switch result {
            case .success(let pinCode):
                self?.startTimer()
                self?.showAlert(with: "Success", and: "A PIN code \(pinCode) has been sent to your phone number")
            case .failure(let error):
                self?.showAlert(with: "Authorization Error", and: error.localizedDescription)
            }
        }
    }

    func didFinishedEnterCode(_ code: String) {

        AuthorizationService.shared.pinCodeIsValid(pinCode: code) { [weak self] result in

            switch result {
            case .success(let isValid):
                self?.validation(isValid: isValid)
            case .failure(let error):
                self?.showAlert(with: "Authorization Error", and: error.localizedDescription)
            }
        }
    }
}
