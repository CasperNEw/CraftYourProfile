//
//  AddProfilePhotoView.swift
//  CraftYourProfile
//
//  Created by Дмитрий Константинов on 12.06.2020.
//  Copyright © 2020 Дмитрий Константинов. All rights reserved.
//

import UIKit

protocol AddProfilePhotoViewDelegate: AnyObject {
    func backButtonTapped()
    func editButtonTapped()
    func skipButtonTapped()
    func addPhotoButtonTapped(image: UIImage?)
}

protocol AddProfilePhotoViewUpdater {
    func showEditButton()
    func editAddPhotoButton()
    func updatePhotoView(image: UIImage)
}

class AddProfilePhotoView: UIView {

    lazy private var designer: ViewDesignerService = { return ViewDesignerService(self) }()
    private let backButton = UIButton(image: UIImage(named: "back"))
    private let mainLabel = UILabel(text: "Add profile photo ❤️",
                                    font: .compactRounded(style: .black, size: 32),
                                    color: .mainBlackText(), lines: 1, alignment: .left)

    private let photoView = UIImageView(image: UIImage(named: "addPhoto"))
    private let editButton = UIButton(title: "Edit", titleColor: .white,
                                      backgroundColor: .black,
                                      font: .compactRounded(style: .semibold, size: 18),
                                      cornerRadius: 20)

    private let skipButton = UIButton(title: "Skip for now", titleColor: .gray,
                                      backgroundColor: .clear,
                                      font: .compactRounded(style: .medium, size: 16),
                                      cornerRadius: 0)

    private let addPhotoButton = UIButton(title: "Add Photo", titleColor: .white,
                                      backgroundColor: .blueButton(),
                                      font: .compactRounded(style: .semibold, size: 20),
                                      cornerRadius: 20)

    weak var delegate: AddProfilePhotoViewDelegate?

    override init(frame: CGRect) {
        super.init(frame: frame)

        self.backgroundColor = .white
        setupViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        setupConstraints()
    }

    private func setupViews() {
        addSubviews()

        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        skipButton.addTarget(self, action: #selector(skipButtonTapped), for: .touchUpInside)
        editButton.addTarget(self, action: #selector(editButtonTapped), for: .touchUpInside)
        addPhotoButton.addTarget(self, action: #selector(addPhotoButtonTapped), for: .touchUpInside)
    }

    private func setupConstraints() {
        designer.setBackButton(backButton)
        designer.setView(mainLabel, with: backButton, trailingIsShort: false)

        NSLayoutConstraint.activate([
            photoView.heightAnchor.constraint(equalToConstant: bounds.width / 2),
            photoView.widthAnchor.constraint(equalToConstant: bounds.width / 2),
            photoView.centerYAnchor.constraint(equalTo: centerYAnchor),
            photoView.centerXAnchor.constraint(equalTo: centerXAnchor),

            editButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            editButton.widthAnchor.constraint(equalToConstant: bounds.width / 5),
            editButton.heightAnchor.constraint(equalToConstant: 44),
            editButton.bottomAnchor.constraint(equalTo: photoView.bottomAnchor,
                                               constant: -22),

            skipButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -120),
            skipButton.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])

        designer.setView(addPhotoButton, with: skipButton, trailingIsShort: false, withHeight: true)
    }

    @objc func backButtonTapped() {
        backButton.clickAnimation()
        delegate?.backButtonTapped()
    }

    @objc func skipButtonTapped() {
        skipButton.clickAnimation()
        delegate?.skipButtonTapped()
    }

    @objc func editButtonTapped() {
        editButton.clickAnimation()
        delegate?.editButtonTapped()
    }

    @objc func addPhotoButtonTapped() {
        addPhotoButton.clickAnimation(with: 0.9)
        delegate?.addPhotoButtonTapped(image: photoView.image)
    }
}

// MARK: Setup Views
extension AddProfilePhotoView {
    private func addSubviews() {
        backButton.translatesAutoresizingMaskIntoConstraints = false
        mainLabel.translatesAutoresizingMaskIntoConstraints = false
        photoView.translatesAutoresizingMaskIntoConstraints = false
        editButton.translatesAutoresizingMaskIntoConstraints = false
        skipButton.translatesAutoresizingMaskIntoConstraints = false
        addPhotoButton.translatesAutoresizingMaskIntoConstraints = false

        addPhotoButton.layer.masksToBounds = true
        photoView.contentMode = .scaleAspectFill
        editButton.alpha = 0

        addSubview(backButton)
        addSubview(mainLabel)
        addSubview(photoView)
        addSubview(editButton)
        addSubview(skipButton)
        addSubview(addPhotoButton)
    }
}

// MARK: AddProfilePhotoViewUpdater
extension AddProfilePhotoView: AddProfilePhotoViewUpdater {
    func showEditButton() {

        editButton.transform = CGAffineTransform(scaleX: 0.2, y: 0.2)

        UIView.animate(withDuration: 1.5,
                       delay: 0,
                       usingSpringWithDamping: 0.7,
                       initialSpringVelocity: 0.6,
                       options: .allowUserInteraction,
                       animations: {
                        self.editButton.transform = CGAffineTransform.identity
                        self.editButton.alpha = 0.2
        })
    }

    func editAddPhotoButton() {
        addPhotoButton.titleLabel?.text = "Done"
    }

    func updatePhotoView(image: UIImage) {
        photoView.image = image
    }
}

// MARK: SwiftUI
import SwiftUI

struct AddProfilePhotoVProvider: PreviewProvider {
    static var previews: some View {
        ContainerView().edgesIgnoringSafeArea(.all)
    }

    struct ContainerView: UIViewControllerRepresentable {
        let viewController = AddProfilePhotoViewController()
        // swiftlint:disable line_length
        func makeUIViewController(context: UIViewControllerRepresentableContext<AddProfilePhotoVProvider.ContainerView>) -> AddProfilePhotoViewController {
            return viewController
        }
        func updateUIViewController(_ uiViewController: AddProfilePhotoViewController, context: UIViewControllerRepresentableContext<AddProfilePhotoVProvider.ContainerView>) {
        }
        // swiftlint:enable line_length
    }
}
