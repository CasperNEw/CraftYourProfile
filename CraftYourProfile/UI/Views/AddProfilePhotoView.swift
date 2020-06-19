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

    private let backButton = UIButton(image: UIImage(named: "back"))
    private let mainLabel = UILabel(text: "Add profile photo ❤️",
                                    font: .compactRounded(style: .black, size: 32),
                                    color: .mainBlackText(), lines: 1, alignment: .left)

    private let photoView = AddPhotoView()
    private let skipButton = UIButton(title: "Skip for now", titleColor: .gray,
                                      backgroundColor: .clear,
                                      font: .compactRounded(style: .medium, size: 16),
                                      cornerRadius: 0)

    private let addPhotoButton = UIButton(title: "Add Photo", titleColor: .white,
                                      backgroundColor: .blueButton(),
                                      font: .compactRounded(style: .semibold, size: 20),
                                      cornerRadius: 20)

    weak private var delegate: AddProfilePhotoViewDelegate?
    lazy private var designer: ViewDesignerService = {
        return ViewDesignerService(self)
    }()

    convenience init(delegate: AddProfilePhotoViewDelegate) {
        self.init(frame: CGRect.zero)
        self.delegate = delegate
    }

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
        photoView.editButton.addTarget(self, action: #selector(editButtonTapped), for: .touchUpInside)
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
        photoView.editButton.clickAnimation()
        delegate?.editButtonTapped()
    }

    @objc func addPhotoButtonTapped() {
        addPhotoButton.clickAnimation(with: 0.9)
        delegate?.addPhotoButtonTapped(image: photoView.imageView.image)
    }
}

// MARK: setupViews
extension AddProfilePhotoView {
    private func addSubviews() {
        backButton.translatesAutoresizingMaskIntoConstraints = false
        mainLabel.translatesAutoresizingMaskIntoConstraints = false
        photoView.translatesAutoresizingMaskIntoConstraints = false
        skipButton.translatesAutoresizingMaskIntoConstraints = false
        addPhotoButton.translatesAutoresizingMaskIntoConstraints = false

        addSubview(backButton)
        addSubview(mainLabel)
        addSubview(photoView)
        addSubview(skipButton)
        addSubview(addPhotoButton)
    }
}

// MARK: AddProfilePhotoViewUpdater
extension AddProfilePhotoView: AddProfilePhotoViewUpdater {
    func showEditButton() {
        photoView.showButton()
    }

    func editAddPhotoButton() {
        for view in addPhotoButton.subviews {
            (view as? UILabel)?.text = "Done"
        }
    }

    func updatePhotoView(image: UIImage) {
        photoView.imageView.image = image
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
