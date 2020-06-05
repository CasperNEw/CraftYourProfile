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
    var popOver = PopoverViewController()
    let manager = PhoneManager()

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

        mainView?.scrollView?.view?.phoneTextField.delegate = self
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
        mainView?.scrollView?.view?.phoneTextField.resignFirstResponder()
    }
}

// MARK: setupButtons
extension VerifyPhoneViewController {

    private func setupButtons() {
        guard let view = mainView?.scrollView?.view else { return }

        view.crossButton.addTarget(self, action: #selector(crossButtonTapped), for: .touchUpInside)
        view.codeButton.addTarget(self, action: #selector(codeButtonTapped), for: .touchUpInside)
        view.nextButton.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
    }

    @objc func crossButtonTapped() {
        mainView?.scrollView?.view?.crossButton.clickAnimation()
        perform(#selector(popViewController), with: nil, afterDelay: 0.5)
    }

    @objc func popViewController() {
        navigationController?.popViewController(animated: true)
    }

    @objc func codeButtonTapped() {
        setupAndPresentPopOverVC()
    }

    @objc func nextButtonTapped() {
        mainView?.scrollView?.view?.nextButton.clickAnimation(with: 0.9)

        guard let phone = mainView?.scrollView?.view?.phoneTextField.text else { return }
        if manager.isValid(phone: phone) {
            let alert = UIAlertController(title: "Success",
                                          message: "A PIN code has been sent to your phone number",
                                          preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in
//                navigationController?.pushViewController(NewAmazingVC(), animated: true)
                print("success, go to the next VC")
            })
            self.present(alert, animated: true)
        } else {
            let alert = UIAlertController(title: "Error",
                                          message: "Unable to complete validation procedure",
                                          preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            self.present(alert, animated: true)
        }
    }

// MARK: setupAndPresentPopOverVC
    private func setupAndPresentPopOverVC() {
        popOver.tableView?.dataSource = self
        popOver.tableView?.delegate = self
        popOver.searchController.searchResultsUpdater = self
        popOver.modalPresentationStyle = .popover
        guard let popOverPC = popOver.popoverPresentationController else { return }
        popOverPC.delegate = self
        popOverPC.sourceView = mainView?.scrollView?.view?.codeButton
        guard let bounds = mainView?.scrollView?.view?.codeButton.bounds else { return }
        popOverPC.sourceRect = CGRect(x: bounds.midX, y: bounds.midY, width: 0, height: 0)
        popOver.preferredContentSize = CGSize(width: 250, height: 250)
        self.present(popOver, animated: true)
    }
}

// MARK: UITextFieldDelegate
extension VerifyPhoneViewController: UITextFieldDelegate {

    func textField(_ textField: UITextField,
                   shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {

        if string == "" {
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

    func test(textField: UITextField) -> Int? {
        if let selectedRange = textField.selectedTextRange {
            let cursorPosition = textField.offset(from: textField.beginningOfDocument, to: selectedRange.start)
            print("\(cursorPosition)")
            return cursorPosition
        }
        return nil
    }
}

// MARK: UIPopoverPresentationControllerDelegate
extension VerifyPhoneViewController: UIPopoverPresentationControllerDelegate {

    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
}

// MARK: Pop UITableViewDataSource
extension VerifyPhoneViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return manager.getCodesCount()
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = manager.getCodesDescription(at: indexPath.row)
        return cell
    }
}
// MARK: Pop UITableViewDelegate
extension VerifyPhoneViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let codeTextField = mainView?.scrollView?.view?.codeTextField else { return }
        codeTextField.text = manager.getTheSelectedCode(at: indexPath.row)
        DispatchQueue.main.async {
            self.dismiss(animated: true, completion: nil)
        }
    }
}

// MARK: Pop UISearchResultsUpdating
extension VerifyPhoneViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else { return }
        filterContentForSearchText(text)
    }

    private func filterContentForSearchText(_ searchText: String) {
        manager.filterCodes(searchText: searchText)
        DispatchQueue.main.async {
            self.popOver.tableView?.reloadData()
        }
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
