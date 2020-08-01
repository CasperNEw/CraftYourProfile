//
//  IntroduceYourselfViewController.swift
//  CraftYourProfile
//
//  Created by Дмитрий Константинов on 11.06.2020.
//  Copyright © 2020 Дмитрий Константинов. All rights reserved.
//

import UIKit

class IntroduceYourselfViewController: UIViewController {

    // MARK: - Properties
    private lazy var presentationView: IntroduceYourselfView = {
        let view = IntroduceYourselfView()
        view.delegate = self
        return view
    }()

    // MARK: - Lifecycle
    override func loadView() {
        view = ScrollViewContainer(with: presentationView)
    }
}

// MARK: IntroduceYourselfViewDelegate
extension IntroduceYourselfViewController: IntroduceYourselfViewDelegate {

    func nextButtonTapped(_ name: String, _ birthday: Date) {

        AuthorizationService.shared.updateUserData(name: name, birthday: birthday)
        let viewController = AddProfilePhotoViewController()
        navigationController?.pushViewController(viewController, animated: true)
    }

    func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
}
