//
//  ThanksViewController.swift
//  CraftYourProfile
//
//  Created by Дмитрий Константинов on 03.08.2020.
//  Copyright © 2020 Дмитрий Константинов. All rights reserved.
//

import UIKit

class ThanksViewController: UIViewController {

    // MARK: - Lifecycle
    override func loadView() {

        let thanksView = ThanksView()
        thanksView.delegate = self
        view = thanksView
    }
}

// MARK: ThanksViewDelegate
extension ThanksViewController: ThanksViewDelegate {

    func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }

    func closeButtonTapped() {
        navigationController?.dismiss(animated: true)
    }
}
