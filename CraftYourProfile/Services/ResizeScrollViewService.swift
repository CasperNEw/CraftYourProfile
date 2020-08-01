//
//  ResizeScrollViewService.swift
//  CraftYourProfile
//
//  Created by Дмитрий Константинов on 10.06.2020.
//  Copyright © 2020 Дмитрий Константинов. All rights reserved.
//

import UIKit

// TODO: need rebuild
class ResizeScrollViewService {

    let view: UIView

    init(view: UIView) {
        self.view = view
    }

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

        var contentInset = (view as? ScrollViewContainer)?.scrollView.getContentInset()
        contentInset?.bottom = keyboardFrameSize.height - view.safeAreaInsets.bottom
        (view as? ScrollViewContainer)?.scrollView.setContentInset(contentInset)
    }

    @objc func keyboardWillHide() {
        let contentInset: UIEdgeInsets = UIEdgeInsets.zero
        (view as? ScrollViewContainer)?.scrollView.setContentInset(contentInset)
    }

    @objc func hideKeyboard() {
        view.endEditing(true)
    }
}
