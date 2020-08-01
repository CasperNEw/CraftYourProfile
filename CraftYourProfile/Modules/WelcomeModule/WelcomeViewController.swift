//
//  WelcomeViewController.swift
//  CraftYourProfile
//
//  Created by Дмитрий Константинов on 16.05.2020.
//  Copyright © 2020 Дмитрий Константинов. All rights reserved.
//

import UIKit

class WelcomeViewController: UIViewController {

    // MARK: - Lifecycle
    override func loadView() {
        let view = WelcomeView()
        view.delegate = self
        self.view = view
    }
}

// MARK: WelcomeViewDelegate
extension WelcomeViewController: WelcomeViewDelegate {

    func letsGoButtonTapped() {
        createAndPresentVerifyPhoneVC()
    }

    func circleButtonTapped() { print(#function) }
    func safariButtonTapped() { print(#function) }
    func homeButtonTapped() { print(#function) }
}

// MARK: - Module functions
extension WelcomeViewController {

    private func createAndPresentVerifyPhoneVC() {

        let viewController = VerifyPhoneConfigurator.create()
        VerifyPhoneConfigurator.configure(with: viewController)
        let navController = UINavigationController(rootViewController: viewController)
        navController.interactivePopGestureRecognizer?.delegate = self
        navController.modalPresentationStyle = .fullScreen
        navController.setNavigationBarHidden(true, animated: true)
        present(navController, animated: true)
    }
}

extension WelcomeViewController: UIGestureRecognizerDelegate {

    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer,
                           shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
