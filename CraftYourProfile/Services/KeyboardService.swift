//
//  KeyboardService.swift
//  CraftYourProfile
//
//  Created by Дмитрий Константинов on 10.06.2020.
//  Copyright © 2020 Дмитрий Константинов. All rights reserved.
//

import UIKit

class KeyboardService {

    // MARK: - Properties
    weak private var view: ScrollViewContainer?

    // MARK: - Initialization
    init(container: ScrollViewContainer) {
        self.view = container
    }

    // MARK: - Public function
    public func setupKeyboard() {

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(endEditing))
        view?.addGestureRecognizer(tapGesture)

        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillChangeFrame),
                                               name: UIResponder.keyboardWillChangeFrameNotification,
                                               object: nil)

        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillHide),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
    }

    // MARK: - Actions
    @objc func endEditing() {
        view?.endEditing(true)
    }

    @objc func keyboardWillChangeFrame(_ notification: NSNotification) {

        let userInfo = notification.userInfo
        let keyboardFrameInWindow = (userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
        let keyboardFrameInView = view?.convert(keyboardFrameInWindow!, from: view?.window)

        var contentInset = view?.scrollView.contentInset
        contentInset?.bottom = keyboardFrameInView?.height ?? 0

        view?.scrollView.contentInset = contentInset ?? UIEdgeInsets.zero
    }

    @objc func keyboardWillHide() {
        view?.scrollView.contentInset = UIEdgeInsets.zero
    }
}
