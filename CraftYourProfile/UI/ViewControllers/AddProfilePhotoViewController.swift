//
//  AddProfilePhotoViewController.swift
//  CraftYourProfile
//
//  Created by Дмитрий Константинов on 12.06.2020.
//  Copyright © 2020 Дмитрий Константинов. All rights reserved.
//

import UIKit

class AddProfilePhotoViewController: UIViewController {

    // MARK: Init
    private var viewControllerFactory: ViewControllerFactory
    private var viewUpdater: AddProfilePhotoViewUpdater

    private var photoIsEmpty = true
    var imagePicker: ImagePicker?

    init(factory: ViewControllerFactory,
         view: UIView,
         viewUpdater: AddProfilePhotoViewUpdater) {

        self.viewControllerFactory = factory
        self.viewUpdater = viewUpdater

        super.init(nibName: nil, bundle: nil)
        self.view = view
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: AddProfilePhotoViewDelegate
extension AddProfilePhotoViewController: AddProfilePhotoViewDelegate {

    func backButtonTapped() {
        perform(#selector(popViewController), with: nil, afterDelay: 0.5)
    }

    @objc func popViewController() {
        navigationController?.popViewController(animated: true)
    }

    func editButtonTapped() {
        imagePicker?.present()
    }

    func skipButtonTapped() {
        finish()
    }

    func addPhotoButtonTapped(image: UIImage?) {
        if photoIsEmpty {
            imagePicker?.present()
            return
        }
        AuthorizationService.shared.updateUserPhoto(image: image)
        finish()
    }

    private func finish() {
        showAlert(with: "Success", and: "You did it! 🙃") {
            print("Congratulation!", #function)
        }
    }
}

// MARK: ImagePickerDelegate
extension AddProfilePhotoViewController: ImagePickerDelegate {
    func didSelect(image: UIImage?) {

        DispatchQueue.main.async {
            guard let image = image else { return }
            self.viewUpdater.updatePhotoView(image: image)
            self.viewUpdater.editAddPhotoButton()
            self.viewUpdater.showEditButton()
            self.photoIsEmpty = false
        }
    }
}
