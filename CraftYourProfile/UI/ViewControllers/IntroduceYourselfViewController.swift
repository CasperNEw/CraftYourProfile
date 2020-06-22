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
    private var viewControllerFactory: ViewControllerFactory
    private var viewUpdater: IntroduceYourselfViewUpdater

    init(factory: ViewControllerFactory,
         view: UIView,
         viewUpdater: IntroduceYourselfViewUpdater) {

        self.viewControllerFactory = factory
        self.viewUpdater = viewUpdater

        super.init(nibName: nil, bundle: nil)
        self.view = view
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
            viewUpdater.shakeTextFieldView(nameTextField)
        }
        if birthday.isEmpty {
            check = false
            viewUpdater.shakeTextFieldView(birthdayTextField)
        }

        if check {
            AuthorizationService.shared.createUserData(name: name, birthday: date)
            let viewController = viewControllerFactory.makeAddProfilePhotoViewController()
            navigationController?.pushViewController(viewController, animated: true)
        }
    }
}
