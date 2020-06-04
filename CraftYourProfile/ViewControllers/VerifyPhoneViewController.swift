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

    var mainView: ViewWithScrollView? { return self.view as? ViewWithScrollView }
    var popOver = PopoverTableViewController()

    let validationService = PhoneValidationService()
    let networkService = NetworkService()

// MARK: loadView
    override func loadView() {
        self.view = ViewWithScrollView(frame: UIScreen.main.bounds)
    }
// MARK: viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupKeyboard()
        setupButtons()
//        getCountryCodes()
    }

    private func setupButtons() {
        guard let view = mainView?.scrollView?.view else { return }

        view.crossButton.addTarget(self, action: #selector(crossButtonTapped), for: .touchUpInside)
        view.codeButton.addTarget(self, action: #selector(codeButtonTapped), for: .touchUpInside)
        view.nextButton.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
    }

    @objc func crossButtonTapped() {
        guard let crossButton = mainView?.scrollView?.view?.crossButton else { return }
        crossButton.clickAnimation()
        perform(#selector(popViewController), with: nil, afterDelay: 0.5)
    }

    @objc func popViewController() {
        navigationController?.popViewController(animated: true)
    }

    @objc func codeButtonTapped() {
        popOver.modalPresentationStyle = .popover
        guard let popOverVC = popOver.popoverPresentationController else { return }
        popOverVC.delegate = self
        popOverVC.sourceView = mainView?.scrollView?.view?.codeButton
        guard let bounds = mainView?.scrollView?.view?.codeButton.bounds else { return }
        popOverVC.sourceRect = CGRect(x: bounds.midX, y: bounds.maxY, width: 0, height: 0)
        popOver.preferredContentSize = CGSize(width: 250, height: 250)
        self.present(popOver, animated: true)
    }

    @objc func nextButtonTapped() {
        guard let nextButton = mainView?.scrollView?.view?.crossButton else { return }
        nextButton.clickAnimation()
    }

    func getCountryCodes() {
        networkService.getCountriesInformation { result in
            switch result {
            case .success(let data):
                print(data)
                //TODO: CountryModel -> PopoverVC
            case .failure(let error):
                print(error.localizedDescription) //TODO: Error processing
            }
        }
    }
}

// MARK: setupKeyboard
extension VerifyPhoneViewController {

    func setupKeyboard() {

        // TODO: not work!
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

        guard let scroll = mainView?.scrollView else { return }
        var contentInset: UIEdgeInsets = scroll.contentInset
        contentInset.bottom = keyboardFrameSize.height - view.safeAreaInsets.bottom
        mainView?.scrollView?.contentInset = contentInset
    }

    @objc func keyboardWillHide() {
        let contentInset: UIEdgeInsets = UIEdgeInsets.zero
        mainView?.scrollView?.contentInset = contentInset
    }

    @objc func hideKeyboard() {
        view.endEditing(true)
    }
}
/*
// MARK: UITextFieldDelegate
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
*/
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
