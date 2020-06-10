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
    private var viewControllerFactory: ViewControllerFactory

    init(_ factory: ViewControllerFactory) {

        self.viewControllerFactory = factory
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

// MARK: lifeCycle
    override func loadView() {
        self.view = WelcomeView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        (view as? WelcomeView)?.delegate = self
        setupNavigationBar()
    }

    private func setupNavigationBar() {
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
}

// MARK: WelcomeViewDelegate
extension WelcomeViewController: WelcomeViewDelegate {

    func letsGoButtonTapped() {
        let viewController = viewControllerFactory.makeVerifyPhoneViewController()
        navigationController?.pushViewController(viewController, animated: true)
    }

    func circleButtonTapped() { print(#function) }
    func safariButtonTapped() { print(#function) }
    func homeButtonTapped() { print(#function) }
}
