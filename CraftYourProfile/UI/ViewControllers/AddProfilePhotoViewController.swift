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
//    private var viewControllerFactory: ViewControllerFactory
    private var updater: AddProfilePhotoViewUpdater?

    lazy var resizeScrollViewService: ResizeScrollViewService = {
        let resizeScrollView = ResizeScrollViewService(view: self.view)
        return resizeScrollView
    }()

    lazy var imagePickerController: UIImagePickerController = {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        return picker
    }()

    var photoIsEmpty = true

    init(/*_ factory: ViewControllerFactory*/) {

//        self.viewControllerFactory = factory

        super.init(nibName: nil, bundle: nil)
        self.updater = view as? AddProfilePhotoViewUpdater
        self.view.backgroundColor = .white
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: lifeCycle
    override func loadView() {
        self.view = AddProfilePhotoView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        (view as? AddProfilePhotoView)?.delegate = self
        resizeScrollViewService.setupKeyboard()
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
        present(imagePickerController, animated: true)
    }

    func skipButtonTapped() {
        finish()
    }

    func addPhotoButtonTapped(image: UIImage?) {
        if photoIsEmpty {
            present(imagePickerController, animated: true)
            updater?.editAddPhotoButton()
            return
        }
        AuthorizationService.shared.updateUserPhoto(image: image)
        finish()
    }

    private func finish() {
        showAlert(with: "Success", and: "You did it! 🙃") {
            print("Congratulation!")
        }
    }
}

// MARK: UIImagePickerControllerDelegate & UINavigationControllerDelegate
extension AddProfilePhotoViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {

        picker.dismiss(animated: true, completion: nil)
        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else { return }
        updater?.updatePhotoView(image: image)
        updater?.showEditButton()
        photoIsEmpty = false
    }
}

// MARK: SwiftUI
import SwiftUI

struct AddProfilePhotoVCProvider: PreviewProvider {
    static var previews: some View {
        ContainerView().edgesIgnoringSafeArea(.all)
    }

    struct ContainerView: UIViewControllerRepresentable {
        let viewController = AddProfilePhotoViewController()
        // swiftlint:disable line_length
        func makeUIViewController(context: UIViewControllerRepresentableContext<AddProfilePhotoVCProvider.ContainerView>) -> AddProfilePhotoViewController {
            return viewController
        }
        func updateUIViewController(_ uiViewController: AddProfilePhotoViewController, context: UIViewControllerRepresentableContext<AddProfilePhotoVCProvider.ContainerView>) {
        }
        // swiftlint:enable line_length
    }
}
