//
//  AddPhotoView.swift
//  CraftYourProfile
//
//  Created by Дмитрий Константинов on 16.06.2020.
//  Copyright © 2020 Дмитрий Константинов. All rights reserved.
//

import UIKit

protocol AddPhotoViewDelegate: AnyObject {
    func editButtonTapped()
}

class AddPhotoView: UIView {

    // MARK: - Properties
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = #imageLiteral(resourceName: "addPhoto")
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()

    private let editButton: PushButton = {
        let button = PushButton(type: .system)
        button.setTitle("Edit", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = #colorLiteral(red: 0, green: 0.02164490582, blue: 0, alpha: 0.5)
        button.titleLabel?.font = .compactRounded(style: .semibold, size: 18)
        button.isHidden = true
        return button
    }()

    weak var delegate: AddPhotoViewDelegate?

    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)

        setupViews()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle
    override func layoutSubviews() {
        super.layoutSubviews()

        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = imageView.frame.width / 2.4

        editButton.layer.masksToBounds = true
        editButton.layer.cornerRadius = 20
    }

    // MARK: - Public function
    public func setImage(_ image: UIImage?) {
        imageView.image = image == nil ? #imageLiteral(resourceName: "addPhoto") : image
        buttonIsHidden(image == nil ? true : false)
    }

    // MARK: - Module function
    private func setupViews() {

        addSubviews([imageView, editButton])
        editButton.addTarget(self, action: #selector(editButtonTapped), for: .touchUpInside)
    }

    private func setupConstraints() {

        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: self.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            imageView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            imageView.trailingAnchor.constraint(equalTo: self.trailingAnchor),

            editButton.heightAnchor.constraint(equalToConstant: 44),
            editButton.widthAnchor.constraint(equalToConstant: 75),
            editButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            editButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -18)
        ])
    }

    private func buttonIsHidden(_ value: Bool) {

        if value {
            UIView.animate(withDuration: 1,
                           animations: { self.editButton.alpha = 0 },
                           completion: { _ in self.editButton.isHidden = true })
            return
        }

        editButton.isHidden = false
        editButton.alpha = 1
        editButton.transform = CGAffineTransform(scaleX: 0.2, y: 0.2)

        UIView.animate(withDuration: 1.5,
                       delay: 0,
                       usingSpringWithDamping: 0.7,
                       initialSpringVelocity: 0.6,
                       options: .allowUserInteraction,
                       animations: { self.editButton.transform = .identity })
    }

    // MARK: - Actions
    @objc private func editButtonTapped() {
        delegate?.editButtonTapped()
    }
}
