//
//  VerifyPhoneViewController.swift
//  CraftYourProfile
//
//  Created by Дмитрий Константинов on 27.05.2020.
//  Copyright © 2020 Дмитрий Константинов. All rights reserved.
//

import UIKit

class VerifyPhoneViewController: UIViewController {

    // MARK: Init
    private var viewControllerFactory: ViewControllerFactory
    private var modelController: VerifyPhoneModelController
    private var viewUpdater: VerifyPhoneViewUpdater?
    private var popOver: UIViewController?

    lazy private var resizeScrollViewService: ResizeScrollViewService = {
        let resizeScrollView = ResizeScrollViewService(view: self.view)
        return resizeScrollView
    }()

    lazy private var verifyPhoneView: VerifyPhoneView = {
        let view = VerifyPhoneView(delegate: self)
        return view
    }()

    init(_ factory: ViewControllerFactory) {

        self.viewControllerFactory = factory
        self.modelController = VerifyPhoneModelController()

        super.init(nibName: nil, bundle: nil)
        self.viewUpdater = verifyPhoneView
        self.view.backgroundColor = .white
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: lifeCycle
    override func loadView() {
        self.view = ScrollViewContainer(with: verifyPhoneView)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        loadPopOver()
        resizeScrollViewService.setupKeyboard()
    }
}

// MARK: setupAndPresentPopOverVC
extension VerifyPhoneViewController {

    private func loadPopOver() {
        DispatchQueue.main.async {
            self.popOver = self.viewControllerFactory.makeCountryCodeViewController(self)
        }
    }

    private func setupAndPresentPopOverVC(_ view: UIView) {

        guard let popOver = popOver else { return }
        popOver.modalPresentationStyle = .popover
        guard let popOverPC = popOver.popoverPresentationController else { return }
        popOverPC.delegate = self
        popOverPC.sourceView = view
        popOverPC.sourceRect = CGRect(x: view.bounds.midX, y: view.bounds.midY,
                                      width: 0, height: 0)
        popOver.preferredContentSize = CGSize(width: self.view.bounds.width * 3/4,
                                              height: self.view.bounds.height * 1/3)
        self.present(popOver, animated: true)
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
        if modelController.isValid(phone: textField.text) { return false }

        return true
    }

    func textFieldDidChangeSelection(_ textField: UITextField) {
        guard let text = textField.text else { return }

        if modelController.isValid(phone: text) {
            let formattedPhone = modelController.getFormattedPhoneNumber(phone: text) { [weak self] (error) in
                guard let error = error else { return }
                self?.showAlert(with: "Phone Number Formatting Error", and: error.localizedDescription)
            }
            textField.text = formattedPhone
        }
    }

    func crossButtonTapped() {
        perform(#selector(popViewController), with: nil, afterDelay: 0.5)
    }

    @objc func popViewController() {
        navigationController?.popViewController(animated: true)
    }

    func codeButtonTapped(_ view: UIView) {
        modelController.networkErrorChecking { [weak self] (error) in
            guard let error = error else { return }
            showAlert(with: "Network Error", and: error.localizedDescription) {
                self?.modelController.reloadData()
            }
        }
        setupAndPresentPopOverVC(view)
    }

    func nextButtonTapped(string: String?) {

        guard let string = string else { return }

        if modelController.isValid(phone: string, completion: { [weak self] (error) in
            guard let error = error else { return }
            self?.showAlert(with: "Validation Error", and: error.localizedDescription)
        }) {
            let pinCode = AuthorizationService.shared.generationPinCode(with: 6)
            do {
                try AuthorizationService.shared.signIn(account: string, pinCode: pinCode)
            } catch let error {
                showAlert(with: "Keychain Error", and: error.localizedDescription)
                return
            }
            showAlert(with: "Success", and: "A PIN code \(pinCode) has been sent to your phone number") {
                let viewController = self.viewControllerFactory.makeVerifyPinCodeViewController()
                self.navigationController?.pushViewController(viewController, animated: true)
            }
        } else {
            showAlert(with: "Error", and: "Unable to complete validation procedure")
        }
    }
}

// MARK: CountryCodeDataProviderProtocol
extension VerifyPhoneViewController: CountryCodeViewControllerDelegate {

    func getCountryCodes(with filter: String?) -> [CountryCode] {
        return modelController.getCountryCodes(with: filter)
    }

    func didSelectItemAt(index: Int) {
        let code = modelController.getTheSelectedCode(at: index)
        viewUpdater?.setNewValue(string: code)
    }
}

// MARK: UIPopoverPresentationControllerDelegate
extension VerifyPhoneViewController: UIPopoverPresentationControllerDelegate {

    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
}
