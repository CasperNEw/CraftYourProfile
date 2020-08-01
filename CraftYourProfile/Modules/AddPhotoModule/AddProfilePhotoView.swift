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
    func addPhotoButtonTapped(state: AddButtonState)
}

enum AddButtonState: String {
    case add = "Add Photo"
    case done = "Done"
}

class AddProfilePhotoView: UIView {

    // MARK: - Properties
    private let backButton = PushButton(image: UIImage(named: "back"))
    private let mainLabel = UILabel(text: "Add profile photo ❤️",
                                    font: .compactRounded(style: .black, size: 32),
                                    color: .mainBlackText(), lines: 1, alignment: .left)

    private lazy var photoView: AddPhotoView = {
        let photoView = AddPhotoView()
        photoView.delegate = self
        return photoView
    }()

    private let skipButton = PushButton(title: "Skip for now", titleColor: .gray,
                                        backgroundColor: .clear,
                                        font: .compactRounded(style: .medium, size: 16),
                                        cornerRadius: 0)

    private let addPhotoButton = PushButton(title: "Add Photo", titleColor: .white,
                                            backgroundColor: .blueButton(),
                                            font: .compactRounded(style: .semibold, size: 20),
                                            cornerRadius: 20,
                                            transformScale: 0.9)

    weak var delegate: AddProfilePhotoViewDelegate?
    private var didSetupConstraints = false

    private var buttonState: AddButtonState = .add {
        didSet { changeAddButtonText() }
    }

    lazy private var designer: ViewDesignerService = {
        return ViewDesignerService(self)
    }()

    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle
    override func updateConstraints() {
        super.updateConstraints()

        if !didSetupConstraints {
            setupConstraints()
            didSetupConstraints = true
        }
    }

    // MARK: - Public function
    public func setImage(_ image: UIImage?) {
        photoView.setImage(image)
        buttonState = image == nil ? .add : .done
    }

    // MARK: - Module functions
    private func setupViews() {

        self.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)

        addSubviews([backButton, mainLabel, photoView,
                     skipButton, addPhotoButton])

        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        skipButton.addTarget(self, action: #selector(skipButtonTapped), for: .touchUpInside)

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

    private func changeAddButtonText() {

        for view in addPhotoButton.subviews {
            if let label = (view as? UILabel) {

                UIView.animate(withDuration: 0.4,
                               animations: { label.alpha = 0 },
                               completion: { _ in

                                label.text = self.buttonState.rawValue
                                UIView.animate(withDuration: 0.4,
                                               animations: { label.alpha = 1 })
                })
            }
        }
    }

    // MARK: - Actions
    @objc func backButtonTapped() {
        delegate?.backButtonTapped()
    }

    @objc func skipButtonTapped() {
        delegate?.skipButtonTapped()
    }

    @objc func addPhotoButtonTapped() {
        delegate?.addPhotoButtonTapped(state: buttonState)
    }
}

// MARK: - AddPhotoViewDelegate
extension AddProfilePhotoView: AddPhotoViewDelegate {

    func editButtonTapped() {
        delegate?.editButtonTapped()
    }
}
