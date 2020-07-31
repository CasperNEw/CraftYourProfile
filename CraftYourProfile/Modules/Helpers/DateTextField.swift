//
//  DateTextField.swift
//  CraftYourProfile
//
//  Created by Дмитрий Константинов on 31.07.2020.
//  Copyright © 2020 Дмитрий Константинов. All rights reserved.
//

import UIKit

protocol DateTextFieldDelegate: AnyObject {
    func dateChanged(to date: Date)
}

class DateTextField: OffsetTextField {

    // MARK: - Properties
    private let datePicker = UIDatePicker()
    weak var dateDelegate: DateTextFieldDelegate?

    lazy private var formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter
    }()

    private var isFirstStart = true

    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)

        setupView()
        setupDatePicker()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Module Functions
    private func setupView() {

        delegate = self
        inputView = datePicker
        tintColor = .clear

        addRightButton(button: createRightButton(), side: 30, offset: -10)
        datePicker.addTarget(self, action: #selector(datePickerChanged), for: .valueChanged)
    }

    private func setupDatePicker() {

        datePicker.datePickerMode = .date
        datePicker.backgroundColor = .white

        let minDate = Date(timeIntervalSince1970: 0)
        datePicker.maximumDate = Calendar.current.date(byAdding: .year, value: -18, to: Date())
        datePicker.minimumDate = minDate
        datePicker.date = minDate

        guard let locale = Locale.preferredLanguages.first else { return }
        datePicker.locale = Locale(identifier: locale)
    }

    private func createRightButton() -> UIButton {

        let button = PushButton(image: UIImage(named: "rexona"))
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        return button
    }

    // MARK: - Actions
    @objc func datePickerChanged() {
        text = formatter.string(from: datePicker.date)
        dateDelegate?.dateChanged(to: datePicker.date)
    }

    @objc func buttonTapped() {
        becomeFirstResponder()
    }
}

extension DateTextField: UITextFieldDelegate {

    func textField(_ textField: UITextField,
                   shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {

        return false
    }

    func textFieldDidEndEditing(_ textField: UITextField) {

        if isFirstStart {
            if textField.text?.isEmpty ?? true {
                datePickerChanged()
                dateDelegate?.dateChanged(to: datePicker.date)
            }
            isFirstStart = false
        }
    }
}
