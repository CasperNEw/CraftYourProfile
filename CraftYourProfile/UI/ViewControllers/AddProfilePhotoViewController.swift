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
    private var viewControllerFactory: ViewControllerFactory?
    private var viewUpdater: AddProfilePhotoViewUpdater?

    lazy private var resizeScrollViewService: ResizeScrollViewService = {
        let resizeScrollView = ResizeScrollViewService(view: self.view)
        return resizeScrollView
    }()

    private var imagePicker: ImagePicker?

    lazy private var addProfilePhotoView: AddProfilePhotoView = {
        let view = AddProfilePhotoView(delegate: self)
        return view
    }()

    private var photoIsEmpty = true

    init(_ factory: ViewControllerFactory? = nil) {
        self.viewControllerFactory = factory

        super.init(nibName: nil, bundle: nil)
        self.viewUpdater = addProfilePhotoView
        self.view.backgroundColor = .white
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: lifeCycle
    override func loadView() {
        self.view = addProfilePhotoView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        loadImagePicker()
        resizeScrollViewService.setupKeyboard()
    }

    private func loadImagePicker() {
        DispatchQueue.main.async {
            self.imagePicker = ImagePicker(presentationController: self, delegate: self)
        }
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
            self.viewUpdater?.updatePhotoView(image: image)
            self.viewUpdater?.editAddPhotoButton()
            self.viewUpdater?.showEditButton()
            self.photoIsEmpty = false
        }
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
