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
    private var mainView: ViewWithScrollView? { return self.view as? ViewWithScrollView }
    private let popOver = CountryCodeViewController()
    private let manager = PhoneModelController()
    private var destinationView: VerifyPhoneView?

// MARK: loadView
    override func loadView() {
        self.view = ViewWithScrollView(frame: UIScreen.main.bounds)
    }

// MARK: viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupKeyboard()

        mainView?.scrollView?.view?.updater = self
        destinationView = mainView?.scrollView?.view
    }
}

// MARK: setupKeyboard
extension VerifyPhoneViewController {

    func setupKeyboard() {

        let hideAction = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        view.addGestureRecognizer(hideAction)

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
    }

    @objc func keyboardWillShow(_ notification: NSNotification) {
        let userInfo = notification.userInfo
        guard let keyboardFrameSize = (userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?
            .cgRectValue else { return }

        guard let scroll = mainView?.scrollView else { return } //TODO: fix it
        var contentInset: UIEdgeInsets = scroll.contentInset
        contentInset.bottom = keyboardFrameSize.height - view.safeAreaInsets.bottom
        mainView?.scrollView?.contentInset = contentInset // TODO: fix it
    }

    @objc func keyboardWillHide() {
        let contentInset: UIEdgeInsets = UIEdgeInsets.zero
        mainView?.scrollView?.contentInset = contentInset // TODO: fix it
    }

    @objc func hideKeyboard() {
        view.endEditing(true)
    }
}

// MARK: setupAndPresentPopOverVC
extension VerifyPhoneViewController {

    private func setupAndPresentPopOverVC(_ view: UIView) {
        popOver.delegate = self
        popOver.modalPresentationStyle = .popover
        guard let popOverPC = popOver.popoverPresentationController else { return }
        popOverPC.delegate = self
        popOverPC.sourceView = view
        let bounds = view.bounds
        popOverPC.sourceRect = CGRect(x: bounds.midX, y: bounds.midY, width: 0, height: 0)
        popOver.preferredContentSize = CGSize(width: UIScreen.main.bounds.width * 3/4,
                                              height: UIScreen.main.bounds.height * 1/3)
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
        if manager.isValid(phone: textField.text) { return false }
        return true
    }

    func textFieldDidChangeSelection(_ textField: UITextField) {
        guard let text = textField.text else { return }

        if manager.isValid(phone: text) {
            textField.text = manager.getFormattedPhoneNumber(phone: text)
        }
    }

    func crossButtonTapped() {
        perform(#selector(popViewController), with: nil, afterDelay: 0.5)
    }

    @objc func popViewController() {
        navigationController?.popViewController(animated: true)
    }

    func codeButtonTapped(_ view: UIView) {
        setupAndPresentPopOverVC(view)
    }

    func nextButtonTapped(string: String?) {

        guard let string = string else { return }
        if manager.isValid(phone: string) {
            showAlert(with: "Success", and: "A PIN code has been sent to your phone number") {
                print("success, go to the next VC")
            }
        } else {
            showAlert(with: "Error", and: "Unable to complete validation procedure")
        }
    }
}

// MARK: CountryCodeDataProviderProtocol
extension VerifyPhoneViewController: CountryCodeDataProviderProtocol {

    func getCountryCodes(with filter: String?) -> [CountryCode] {
        return manager.getCountryCodes(with: filter)
    }

    func didSelectItemAt(index: Int) {
        let code = manager.getTheSelectedCode(at: index)
        destinationView?.setNewValue(string: code)
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
