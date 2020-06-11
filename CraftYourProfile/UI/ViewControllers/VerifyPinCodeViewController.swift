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
    private var mainView: ScrollViewContainer? { return self.view as? ScrollViewContainer }
    private var viewControllerFactory: ViewControllerFactory
    private var updater: VerifyPinCodeViewUpdater?

    lazy var resizeScrollViewService: ResizeScrollViewService = {
        let resizeScrollView = ResizeScrollViewService(view: self.view)
        return resizeScrollView
    }()

    init(_ factory: ViewControllerFactory) {

        self.viewControllerFactory = factory

        super.init(nibName: nil, bundle: nil)
        self.updater = mainView?.view as? VerifyPinCodeViewUpdater
        self.view.backgroundColor = .white
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

// MARK: lifeCycle
    override func loadView() {
        self.view = ScrollViewContainer(frame: UIScreen.main.bounds, type: VerifyPinCodeView.self)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        (mainView?.view as? VerifyPinCodeView)?.delegate = self
        resizeScrollViewService.setupKeyboard()
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
                self.updater?.shakePinCodeView()
                self.updater?.hideResendCodeButton()
            }
            updater?.hideResendCodeButton()
        } catch let error {
            showAlert(with: "Keychain Error", and: error.localizedDescription)
        }

//        updater?.hideResendCodeLabel() //TODO: add timer logic and swith button with label

    }

    func didFinishedEnterCode(_ code: String) {

        do {
            let pinCode = try AuthorizationService.shared.getExpectedPinCode()
            if pinCode != code {
                updater?.shakePinCodeView()
            } else {
                showAlert(with: "Success", and: "Go to Create Your Profile! 😍") {
                    let viewController = self.viewControllerFactory.makeIntroduceYourselfViewController()
                    self.navigationController?.pushViewController(viewController, animated: true)
                }
            }
        } catch let error {
            showAlert(with: "Keychain Error", and: error.localizedDescription)
        }
    }
}
