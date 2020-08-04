//
//  IntroduceYourselfView.swift
//  CraftYourProfile
//
//  Created by Дмитрий Константинов on 12.06.2020.
//  Copyright © 2020 Дмитрий Константинов. All rights reserved.
//

import UIKit

protocol IntroduceYourselfViewDelegate: AnyObject {

    func backButtonTapped()
    func nextButtonTapped(_ name: String, _ birthday: Date)
}

class IntroduceYourselfView: UIView {

    // MARK: - Properties
    private let backButton = PushButton(image: UIImage(named: "back"))

    private let mainLabel = UILabel(text: "Let's introduce yourself 🤪",
                                    font: .compactRounded(style: .black, size: 32),
                                    color: .mainBlackText(), lines: 2, alignment: .left)

    private let nameLabel = UILabel(text: "NAME",
                                    font: .compactRounded(style: .semibold, size: 15),
                                    color: .gray, lines: 1, alignment: .left)

    private let nameTextField = OffsetTextField(font: .compactRounded(style: .semibold, size: 20),
                                                textColor: .black, backgroundColor: .backgroundGray(),
                                                cornerRadius: 15, alignment: .left)

    private let birthdayLabel = UILabel(text: "BIRTHDAY",
                                        font: .compactRounded(style: .semibold, size: 15),
                                        color: .gray, lines: 1, alignment: .left)

    private let birthdayTextField = DateTextField(font: .compactRounded(style: .semibold, size: 20),
                                                  textColor: .black,
                                                  backgroundColor: .backgroundGray(),
                                                  cornerRadius: 15,
                                                  alignment: .left)

    private let nextButton = PushButton(title: "Next", titleColor: .white,
                                        backgroundColor: .blueButton(),
                                        font: .compactRounded(style: .semibold, size: 20),
                                        cornerRadius: 20,
                                        transformScale: 0.9)

    weak var delegate: IntroduceYourselfViewDelegate?
    private var didSetupConstraints = false

    lazy private var designer: ViewDesignerService = {
        return ViewDesignerService(self)
    }()

    private var currentData: (name: String, birthday: Date?) = ("", nil) {
        didSet {
            currentData.name = currentData.name.trimmingCharacters(in: .whitespacesAndNewlines)
            if currentData.name.count < 3 || currentData.birthday == nil {
                setNextButtonIsEnabled(false, animate: true)
                return
            }
            setNextButtonIsEnabled(true, animate: true)
        }
    }

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

    // MARK: - Actions
    @objc func backButtonTapped() {
        delegate?.backButtonTapped()
    }

    @objc func nextButtonTapped() {

        guard let birthday = currentData.birthday else { return }
        endEditing(true)
        delegate?.nextButtonTapped(currentData.name, birthday)
    }
}

// MARK: - Module functions
extension IntroduceYourselfView {

    private func setupViews() {

        backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)

        setNextButtonIsEnabled(false, animate: false)
        setupNextButton()
        setupTextFields()

        addSubviews([backButton, mainLabel, nameLabel,
                     nameTextField, birthdayLabel,
                     birthdayTextField, nextButton])

        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        nextButton.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
    }

    private func setupNextButton() {
        guard let image = UIImage(named: "next") else { return }
        let tintedImage = image.withTintColor(.white, renderingMode: .alwaysOriginal)
        nextButton.addRightImage(image: tintedImage, side: 17, offset: -15)
    }

    private func setNextButtonIsEnabled(_ value: Bool, animate: Bool) {

        nextButton.isEnabled = value

        if !animate {
            nextButton.alpha = value ? 1 : 0.5
        } else {
            UIView.animate(withDuration: 0.5) {
                self.nextButton.alpha = value ? 1 : 0.5
            }
        }
    }

    private func setupTextFields() {

        birthdayTextField.dateDelegate = self
        nameTextField.delegate = self
        nameTextField.returnKeyType = .continue
        nameTextField.tintColor = .gray
    }

    private func setupConstraints() {

        designer.setBackButton(backButton)
        designer.setView(mainLabel, with: backButton)
        designer.setView(nameLabel, with: mainLabel)

        designer.setView(nameTextField, with: nameLabel, trailingIsShort: false,
                         withHeight: true, specialHeight: false)

        designer.setView(birthdayLabel, with: nameTextField)
        designer.setView(birthdayTextField, with: birthdayLabel, trailingIsShort: false,
                         withHeight: true, specialHeight: false)

        designer.setBottomView(nextButton, with: birthdayTextField, multiplier: 2,
                               constant: birthdayLabel.bounds.height)
    }
}

// MARK: - DateTextFieldDelegate
extension IntroduceYourselfView: DateTextFieldDelegate {

    func dateChanged(to date: Date) {
        currentData.birthday = date
    }
}

// MARK: - UITextFieldDelegate
extension IntroduceYourselfView: UITextFieldDelegate {

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {

        if textField.text?.count == 20 { return false }
        return true
    }

    func textFieldDidChangeSelection(_ textField: UITextField) {
        currentData.name = textField.text ?? ""
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.text = textField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {

        birthdayTextField.becomeFirstResponder()
        return false
    }
}
