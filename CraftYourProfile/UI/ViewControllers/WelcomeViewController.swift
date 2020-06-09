//
//  WelcomeViewController.swift
//  CraftYourProfile
//
//  Created by Дмитрий Константинов on 16.05.2020.
//  Copyright © 2020 Дмитрий Константинов. All rights reserved.
//

import UIKit

class WelcomeViewController: UIViewController {

// MARK: Init
    private var mainView: WelcomeView? { return self.view as? WelcomeView }

// MARK: loadView
    override func loadView() {
        self.view = WelcomeView()
    }

// MARK: viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()

        mainView?.delegate = self
        setupNavigationBar()
    }
}

// MARK: WelcomeViewDelegate
extension WelcomeViewController: WelcomeViewDelegate {

    func letsGoButtonTapped() {
        navigationController?.pushViewController(VerifyPhoneViewController(), animated: true)
    }

    func circleButtonTapped() { print(#function) }
    func safariButtonTapped() { print(#function) }
    func homeButtonTapped() { print(#function) }
}

// MARK: setupNavigationBar
extension WelcomeViewController {

    func setupNavigationBar() {
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
}

// MARK: SwiftUI
import SwiftUI

struct WelcomeVCProvider: PreviewProvider {
    static var previews: some View {
        ContainerView().edgesIgnoringSafeArea(.all)
    }

    struct ContainerView: UIViewControllerRepresentable {
        let welcomeVC = WelcomeViewController()
        // swiftlint:disable line_length
        func makeUIViewController(context: UIViewControllerRepresentableContext<WelcomeVCProvider.ContainerView>) -> WelcomeViewController {
            return welcomeVC
        }
        func updateUIViewController(_ uiViewController: WelcomeVCProvider.ContainerView.UIViewControllerType, context: UIViewControllerRepresentableContext<WelcomeVCProvider.ContainerView>) {
        }
        // swiftlint:enable line_length
    }
}
