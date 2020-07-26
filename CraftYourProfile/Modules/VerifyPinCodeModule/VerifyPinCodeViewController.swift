//
//  VerifyPinCodeViewController.swift
//  CraftYourProfile
//
//  Created by Дмитрий Константинов on 10.06.2020.
//  Copyright © 2020 Дмитрий Константинов. All rights reserved.
//

import UIKit

class VerifyPinCodeViewController: UIViewController {

    // MARK: Init
    private var viewControllerFactory: ViewControllerFactory
    private var viewUpdater: VerifyPinCodeViewUpdater

    lazy private var timer: Timer = {
        let timer = Timer(timeInterval: 1, target: self, selector: #selector(fireTimer), userInfo: nil, repeats: true)
        timer.tolerance = 0.1
        return timer
    }()
    private var repeatTimerInterval = 20

    init(factory: ViewControllerFactory,
         view: UIView,
         viewUpdater: VerifyPinCodeViewUpdater) {

        self.viewControllerFactory = factory
        self.viewUpdater = viewUpdater

        super.init(nibName: nil, bundle: nil)
        self.view = view
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        startTimer()
        viewUpdater.shakePinCodeView()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)

        viewUpdater.hideResendCodeButton()
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
                self.viewUpdater.shakePinCodeView()
                self.viewUpdater.hideResendCodeButton()
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
        viewUpdater.updateResendCodeLabel(with: repeatTimerInterval)

        if repeatTimerInterval == 0 {
            timer.invalidate()
            repeatTimerInterval = 20
            viewUpdater.hideResendCodeLabel()
        }
    }

    func didFinishedEnterCode(_ code: String) {

        do {
            let pinCode = try AuthorizationService.shared.getExpectedPinCode()
            if pinCode != code {
                viewUpdater.shakePinCodeView()
            } else {
                showAlert(with: "Success", and: "Go to Create Your Profile! 😍") {
                    let viewController = self.viewControllerFactory.makeIntroduceYourselfViewController()
                    self.navigationController?.pushViewController(viewController, animated: true)
                }
                timer.invalidate()
                viewUpdater.updateResendCodeLabel(with: "Perfect 😌")
            }
        } catch let error {
            showAlert(with: "Keychain Error", and: error.localizedDescription)
        }
    }
}
