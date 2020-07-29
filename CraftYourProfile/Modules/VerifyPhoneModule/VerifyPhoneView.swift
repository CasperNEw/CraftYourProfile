//
//  VerifyPhoneView.swift
//  CraftYourProfile
//
//  Created by Дмитрий Константинов on 03.06.2020.
//  Copyright © 2020 Дмитрий Константинов. All rights reserved.
//

import UIKit

protocol VerifyPhoneViewDelegate: AnyObject {

    func shouldChangeCharactersIn(_ textField: UITextField, string: String) -> Bool
    func textFieldDidChangeSelection(_ textField: UITextField)

    func crossButtonTapped()
    func codeButtonTapped(_ view: UIView)
    func nextButtonTapped(phone: String)
}

class VerifyPhoneView: UIView {

    // MARK: - Properties
    private let crossButton = PushButton(image: UIImage(named: "cross"))

    private let mainLabel = UILabel(text: "Let's verify your phone number 😘",
                                    font: .compactRounded(style: .black, size: 32),
                                    color: .mainBlackText(), lines: 2, alignment: .left)

    private let additionalLabel = UILabel(text: "PHONE NUMBER",
                                          font: .compactRounded(style: .semibold, size: 15),
                                          color: .gray, lines: 1, alignment: .left)

    lazy private var phoneView: PhoneView = {
        let view = PhoneView()
        view.delegate = self
        return view
    }()

    private let nextButton = PushButton(title: "Next", titleColor: .white,
                                        backgroundColor: .blueButton(),
                                        font: .compactRounded(style: .semibold, size: 20),
                                        cornerRadius: 20,
                                        transformScale: 0.9)

    weak var delegate: VerifyPhoneViewDelegate?
    private var didSetupConstraints = false

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
    public func setCountryCode(string: String) {
        phoneView.setCodeValue(string: string)
    }

    public func setNextButtonIsEnabled(_ value: Bool) {

        nextButton.isEnabled = value
        nextButton.backgroundColor = value ? .blueButton() : .backgroundGray()
    }

    // MARK: - Actions
    @objc private func crossButtonTapped() {
        delegate?.crossButtonTapped()
    }

    @objc private func nextButtonTapped() {
        delegate?.nextButtonTapped(phone: phoneView.getPhoneString())
    }
}

// MARK: - Module functions
extension VerifyPhoneView {

    private func setupViews() {

        backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        nextButton.addRightImage(image: UIImage(named: "next"), side: 30, offset: -10)
        addSubviews([crossButton, mainLabel, additionalLabel, phoneView, nextButton])

        crossButton.addTarget(self, action: #selector(crossButtonTapped), for: .touchUpInside)
        nextButton.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
    }

    private func setupConstraints() {

        designer.setBackButton(crossButton)
        designer.setView(mainLabel, with: crossButton)
        designer.setView(additionalLabel, with: mainLabel)
        designer.setView(phoneView, with: additionalLabel, trailingIsShort: false,
                         withHeight: true, specialHeight: false)
        designer.setBottomView(nextButton, with: phoneView)
    }
}

// MARK: PhoneViewDelegate
extension VerifyPhoneView: PhoneViewDelegate {

    func shouldChangeCharactersIn(textField: UITextField, string: String) -> Bool {
        return delegate?.shouldChangeCharactersIn(textField, string: string) ?? true
    }

    func textFieldDidChangeSelection(textField: UITextField) {
        delegate?.textFieldDidChangeSelection(textField)
    }

    func codeButtonTapped(view: UIView) {
        delegate?.codeButtonTapped(view)
    }
}
