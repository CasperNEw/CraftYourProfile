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

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if !isFirstLoad { startTimer() }
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
}

// MARK: VerifyPinCodeViewDelegate
extension VerifyPinCodeViewController: VerifyPinCodeViewDelegate {

    func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }

    func resendCodeButtonTapped() {

        do {
            let newPinCode = try AuthorizationService.shared.updatePinCode(with: 6)
            showAlert(with: "Success", and: "A PIN code \(newPinCode) has been sent to your phone number")
            startTimer()
        } catch let error {
            showAlert(with: "Keychain Error", and: error.localizedDescription)
        }
    }

    func didFinishedEnterCode(_ code: String) {

        do {
            let pinCode = try AuthorizationService.shared.getExpectedPinCode()
            if pinCode != code {
                presentationView.shakePinCodeView()
            } else {
                view.endEditing(true)
                isFirstLoad = false
                showAlert(with: "Success", and: "Go to Create Your Profile! 😍") {
                    let viewController = IntroduceYourselfViewController()
                    self.navigationController?.pushViewController(viewController, animated: true)
                }
            }
        } catch let error {
            showAlert(with: "Keychain Error", and: error.localizedDescription)
        }
    }
}
