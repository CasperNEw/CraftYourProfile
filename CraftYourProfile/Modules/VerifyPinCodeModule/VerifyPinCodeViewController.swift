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

    lazy private var timer: Timer = {
        let timer = Timer(timeInterval: 1, target: self, selector: #selector(fireTimer), userInfo: nil, repeats: true)
        timer.tolerance = 0.1
        return timer
    }()
    private var repeatTimerInterval = 20

    // MARK: - Lifecycle
    override func loadView() {
        self.view = ScrollViewContainer(with: presentationView)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        startTimer()
        presentationView.shakePinCodeView()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)

        presentationView.hideResendCodeButton()
        timer.invalidate()
        repeatTimerInterval = 20
    }
}

// MARK: VerifyPinCodeViewDelegate
extension VerifyPinCodeViewController: VerifyPinCodeViewDelegate {

    func backButtonTapped() {
        perform(#selector(popViewController), with: nil, afterDelay: 0.5)
    }

    @objc func popViewController() {
        navigationController?.popViewController(animated: true)
    }

    func resendCodeButtonTapped() {

        do {
            let newPinCode = try AuthorizationService.shared.updatePinCode(with: 6)
            showAlert(with: "Success", and: "A PIN code \(newPinCode) has been sent to your phone number") {
                self.presentationView.shakePinCodeView()
                self.presentationView.hideResendCodeButton()
                self.startTimer()
            }
        } catch let error {
            showAlert(with: "Keychain Error", and: error.localizedDescription)
        }
    }

    private func startTimer() {
        timer = Timer(timeInterval: 1, target: self, selector: #selector(fireTimer), userInfo: nil, repeats: true)
        timer.tolerance = 0.1
        RunLoop.current.add(timer, forMode: .common)
    }

    @objc func fireTimer() {
        repeatTimerInterval -= 1
        presentationView.updateResendCodeLabel(with: repeatTimerInterval)

        if repeatTimerInterval == 0 {
            timer.invalidate()
            repeatTimerInterval = 20
            presentationView.hideResendCodeLabel()
        }
    }

    func didFinishedEnterCode(_ code: String) {

        do {
            let pinCode = try AuthorizationService.shared.getExpectedPinCode()
            if pinCode != code {
                presentationView.shakePinCodeView()
            } else {
                showAlert(with: "Success", and: "Go to Create Your Profile! 😍") {
                    let viewController = ViewControllerFactory().makeIntroduceYourselfViewController()
                    self.navigationController?.pushViewController(viewController, animated: true)
                }
                timer.invalidate()
                presentationView.updateResendCodeLabel(with: "Perfect 😌")
            }
        } catch let error {
            showAlert(with: "Keychain Error", and: error.localizedDescription)
        }
    }
}
