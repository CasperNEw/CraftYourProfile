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
    func nextButtonTapped(_ nameTextField: UITextField, _ birthdayTextField: UITextField, _ date: Date)
}

protocol IntroduceYourselfViewUpdater {

    func shakeTextFieldView(_ textField: UITextField)
}

class IntroduceYourselfView: UIView {

    private let backButton = PushButton(image: UIImage(named: "back"))
    private let mainLabel = UILabel(text: "Let's introduce yourself 🤪",
                                    font: .compactRounded(style: .black, size: 32),
                                    color: .mainBlackText(), lines: 2, alignment: .left)

    private let nameLabel = UILabel(text: "NAME",
                                    font: .compactRounded(style: .semibold, size: 15),
                                    color: .gray, lines: 1, alignment: .left)

    private let nameTextField = UITextField(font: .compactRounded(style: .semibold, size: 20),
                                            textColor: .black, backgroundColor: .backgroundGray(),
                                            cornerRadius: 15)

    private let birthdayLabel = UILabel(text: "BIRTHDAY",
                                        font: .compactRounded(style: .semibold, size: 15),
                                        color: .gray, lines: 1, alignment: .left)

    private let birthdayTextField = UITextField(font: .compactRounded(style: .semibold, size: 20),
                                                textColor: .black, backgroundColor: .backgroundGray(),
                                                cornerRadius: 15)
    private let datePicker = UIDatePicker()
    private let dateButton = PushButton(image: UIImage(named: "rexona"))

    private let nextButton = PushButton(title: "Next", titleColor: .white,
                                        backgroundColor: .blueButton(),
                                        font: .compactRounded(style: .semibold, size: 20),
                                        cornerRadius: 20,
                                        transformScale: 0.9)

    lazy private var formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter
    }()

    weak var delegate: IntroduceYourselfViewDelegate?
    lazy private var designer: ViewDesignerService = {
        return ViewDesignerService(self)
    }()

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
        setupNextButton()
        setupTextFields()
        addSubviews()

        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        nextButton.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
        dateButton.addTarget(self, action: #selector(dateButtonTapped), for: .touchUpInside)
        datePicker.addTarget(self, action: #selector(datePickerChanged), for: .valueChanged)
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

    @objc func backButtonTapped() {
        delegate?.backButtonTapped()
    }

    @objc func nextButtonTapped() {
        delegate?.nextButtonTapped(nameTextField, birthdayTextField, datePicker.date)
    }

    @objc func dateButtonTapped() {
        birthdayTextField.becomeFirstResponder()
    }

    @objc func datePickerChanged() {
        birthdayTextField.text = formatter.string(from: datePicker.date)
    }
}

// MARK: setupViews
extension IntroduceYourselfView {
    private func addSubviews() {
        backButton.translatesAutoresizingMaskIntoConstraints = false
        mainLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameTextField.translatesAutoresizingMaskIntoConstraints = false
        birthdayLabel.translatesAutoresizingMaskIntoConstraints = false
        birthdayTextField.translatesAutoresizingMaskIntoConstraints = false
        nextButton.translatesAutoresizingMaskIntoConstraints = false

        addSubview(backButton)
        addSubview(mainLabel)
        addSubview(nameLabel)
        addSubview(nameTextField)
        addSubview(birthdayLabel)
        addSubview(birthdayTextField)
        addSubview(nextButton)
    }

    private func setupNextButton() {
        nextButton.addRightImage(image: UIImage(named: "next"), side: 30, offset: -10)
    }

    private func setupTextFields() {
        birthdayTextField.addRightButton(button: dateButton, side: 30, offset: -10)

        birthdayTextField.inputView = datePicker
        nameTextField.delegate = self
        birthdayTextField.delegate = self
        datePicker.datePickerMode = .date
        datePicker.backgroundColor = .white

        let minDate = Date(timeIntervalSince1970: 0)
        datePicker.maximumDate = Calendar.current.date(byAdding: .year, value: -18, to: Date())
        datePicker.minimumDate = minDate
        datePicker.date = minDate

        guard let locale = Locale.preferredLanguages.first else { return }
        datePicker.locale = Locale(identifier: locale)
    }
}

// MARK: UITextFieldDelegate
extension IntroduceYourselfView: UITextFieldDelegate {

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {

        if textField == birthdayTextField { return false }
        if textField.text?.count == 20 { return false }
        return true
    }
}

// MARK: IntroduceYourselfViewUpdater
extension IntroduceYourselfView: IntroduceYourselfViewUpdater {
    func shakeTextFieldView(_ textField: UITextField) {
        textField.shakeAnimation()
    }
}
