//
//  IntroduceYourselfViewController.swift
//  CraftYourProfile
//
//  Created by Дмитрий Константинов on 11.06.2020.
//  Copyright © 2020 Дмитрий Константинов. All rights reserved.
//

import UIKit

class IntroduceYourselfViewController: UIViewController {

    // MARK: Init
        private var mainView: ScrollViewContainer? { return self.view as? ScrollViewContainer }
        private var viewControllerFactory: ViewControllerFactory
        private var updater: IntroduceYourselfViewUpdater?

        lazy var resizeScrollViewService: ResizeScrollViewService = {
            let resizeScrollView = ResizeScrollViewService(view: self.view)
            return resizeScrollView
        }()

        init(_ factory: ViewControllerFactory) {

            self.viewControllerFactory = factory

            super.init(nibName: nil, bundle: nil)
            self.updater = mainView?.view as? IntroduceYourselfViewUpdater
            self.view.backgroundColor = .white
        }

        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }

    // MARK: lifeCycle
        override func loadView() {
            self.view = ScrollViewContainer(frame: UIScreen.main.bounds, type: IntroduceYourselfView.self)
        }

        override func viewDidLoad() {
            super.viewDidLoad()

            (mainView?.view as? IntroduceYourselfView)?.delegate = self
            resizeScrollViewService.setupKeyboard()
        }
}

// MARK: IntroduceYourselfViewDelegate
extension IntroduceYourselfViewController: IntroduceYourselfViewDelegate {

    func backButtonTapped() {
        perform(#selector(popViewController), with: nil, afterDelay: 0.5)
    }

    @objc func popViewController() {
        navigationController?.popViewController(animated: true)
    }

    func nextButtonTapped(_ nameTextField: UITextField, _ birthdayTextField: UITextField, _ date: Date) {

        guard let name = nameTextField.text, let birthday = birthdayTextField.text else { return }
        var check = true

        if name.isEmpty {
            check = false
            updater?.shakeTextFieldView(nameTextField)
        }
        if birthday.isEmpty {
            check = false
            updater?.shakeTextFieldView(birthdayTextField)
        }

        if check {
            AuthorizationService.shared.createUserData(name: name, birthday: date)
            let viewController = viewControllerFactory.makeAddProfilePhotoViewController()
            navigationController?.pushViewController(viewController, animated: true)
        }
    }
}
