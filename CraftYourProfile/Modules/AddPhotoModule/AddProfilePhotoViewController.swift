//
//  AddProfilePhotoViewController.swift
//  CraftYourProfile
//
//  Created by Дмитрий Константинов on 12.06.2020.
//  Copyright © 2020 Дмитрий Константинов. All rights reserved.
//

import UIKit

class AddProfilePhotoViewController: UIViewController {

    // MARK: - Properties
    private lazy var presentationView: AddProfilePhotoView = {
        let view = AddProfilePhotoView()
        view.delegate = self
        return view
    }()

    private lazy var imagePicker: ImagePicker = {
        let imagePicker = ImagePicker(presentationController: self,
                                      delegate: self)
        return imagePicker
    }()

    private var currentImage: UIImage? {
        didSet { presentationView.setImage(currentImage) }
    }

    // MARK: - Lifecycle
    override func loadView() {
        view = presentationView
    }

    // MARK: - Module function
    private func finish() {
        showAlert(with: "Success", and: "You did it! 🙃")
    }
}

// MARK: - AddProfilePhotoViewDelegate
extension AddProfilePhotoViewController: AddProfilePhotoViewDelegate {

    func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }

    func editButtonTapped() {
        imagePicker.present(imageIsEmpty: currentImage == nil ? true : false)
    }

    func skipButtonTapped() {
        finish()
    }

    func addPhotoButtonTapped(state: AddButtonState) {

        switch state {
        case .add:
            imagePicker.present(imageIsEmpty: currentImage == nil ? true : false)
        case .done:
            AuthorizationService.shared.updateUserPhoto(image: currentImage)
            finish()
        }
    }
}

// MARK: ImagePickerDelegate
extension AddProfilePhotoViewController: ImagePickerDelegate {

    func didSelect(image: UIImage?) {
        currentImage = image
    }
}
