//
//  ImagePicker.swift
//  CraftYourProfile
//
//  Created by Дмитрий Константинов on 16.06.2020.
//  Copyright © 2020 Дмитрий Константинов. All rights reserved.
//

import UIKit

protocol ImagePickerDelegate: class {
    func didSelect(image: UIImage?)
}

class ImagePicker: NSObject {

    // MARK: - Properties
    private lazy var pickerController: UIImagePickerController = {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        picker.mediaTypes = ["public.image"]
        return picker
    }()

    private weak var presentationController: UIViewController?
    private weak var delegate: ImagePickerDelegate?

    // MARK: - Initialization
    init(presentationController: UIViewController,
         delegate: ImagePickerDelegate) {

        super.init()

        self.presentationController = presentationController
        self.delegate = delegate
    }

    // MARK: - Public function
    public func present(imageIsEmpty: Bool) {

        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .alert)

        if let action = self.action(for: .camera, title: "Take photo") {
            alertController.addAction(action)
        }
        if let action = self.action(for: .savedPhotosAlbum, title: "Camera roll") {
            alertController.addAction(action)
        }
        if let action = self.action(for: .photoLibrary, title: "Photo library") {
            alertController.addAction(action)
        }

        if !imageIsEmpty {
            alertController.addAction(UIAlertAction(title: "Remove photo",
                                                    style: .destructive,
                                                    handler: { (_) in
                                                        self.delegate?.didSelect(image: nil)
            }))
        }

        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))

        presentationController?.present(alertController, animated: true)
    }

    // MARK: - Module functions
    private func action(for type: UIImagePickerController.SourceType, title: String) -> UIAlertAction? {

        guard UIImagePickerController.isSourceTypeAvailable(type) else {
            return nil
        }

        return UIAlertAction(title: title, style: .default) { [unowned self] _ in
            self.pickerController.sourceType = type
            self.presentationController?.present(self.pickerController, animated: true)
        }
    }

    private func pickerController(_ controller: UIImagePickerController, didSelect image: UIImage?) {

        delegate?.didSelect(image: image)
        controller.dismiss(animated: true, completion: nil)
    }
}

// MARK: UIImagePickerControllerDelegate
extension ImagePicker: UIImagePickerControllerDelegate {

    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        pickerController(picker, didSelect: nil)
    }

    public func imagePickerController(_ picker: UIImagePickerController,
                                      didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {

        guard let image = info[.editedImage] as? UIImage else {
            return pickerController(picker, didSelect: nil)
        }
        pickerController(picker, didSelect: image)
    }
}

// MARK: UINavigationControllerDelegate
extension ImagePicker: UINavigationControllerDelegate { }
