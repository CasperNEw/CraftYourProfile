//
//  VerifyPinCodeView.swift
//  CraftYourProfile
//
//  Created by Дмитрий Константинов on 10.06.2020.
//  Copyright © 2020 Дмитрий Константинов. All rights reserved.
//

import UIKit

protocol VerifyPinCodeViewDelegate: AnyObject {

    func backButtonTapped()
    func resendCodeButtonTapped()
    func didFinishedEnterCode(_ code: String)
}

class VerifyPinCodeView: UIView {

    // MARK: - Properties
    private let backButton = PushButton(image: UIImage(named: "back"))

    private let mainLabel = UILabel(text: "Next, enter the code we sent 😍",
                                    font: .compactRounded(style: .black, size: 32),
                                    color: .mainBlackText(), lines: 2, alignment: .left)

    private let additionalLabel = UILabel(text: "VERIFICATION CODE",
                                          font: .compactRounded(style: .semibold, size: 15),
                                          color: .gray, lines: 1, alignment: .left)

    private let pinCodeView = PinCodeView()
    
    private let resendCodeLabel = UILabel(text: "Resend code after 20 sec",
                                          font: .compactRounded(style: .medium, size: 16),
                                          color: .gray, lines: 1, alignment: .center)

    private let resendCodeButton = PushButton(title: "Resend code", titleColor: .white,
                                              backgroundColor: .blueButton(),
                                              font: .compactRounded(style: .semibold, size: 20),
                                              cornerRadius: 20,
                                              transformScale: 0.9)

    weak var delegate: VerifyPinCodeViewDelegate?
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

    // MARK: - Module function
    private func setupViews() {

        backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)

        resendCodeButton.alpha = 0
        addSubviews([backButton, mainLabel, additionalLabel,
                     pinCodeView, resendCodeLabel, resendCodeButton])

        pinCodeView.didFinishedEnterCode = { [weak self] code in
            self?.delegate?.didFinishedEnterCode(code)
        }

        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        resendCodeButton.addTarget(self, action: #selector(resendCodeButtonTapped), for: .touchUpInside)
    }

    private func setupConstraints() {
        designer.setBackButton(backButton)
        designer.setView(mainLabel, with: backButton)
        designer.setView(additionalLabel, with: mainLabel)
        designer.setView(pinCodeView, with: additionalLabel, trailingIsShort: false,
                         withHeight: true, specialHeight: true)
        designer.setBottomView(resendCodeLabel, with: pinCodeView, specialSpacing: true)
        designer.setBottomView(resendCodeButton, with: pinCodeView)
    }

    private func showView(_ view: UIView) {

        view.transform = CGAffineTransform(scaleX: 0.2, y: 0.2)

        UIView.animate(withDuration: 1.5,
                       delay: 0,
                       usingSpringWithDamping: 0.7,
                       initialSpringVelocity: 0.6,
                       options: .allowUserInteraction,
                       animations: {
                        view.transform = CGAffineTransform.identity
                        view.alpha = 1
        })
    }

    // MARK: - Actions
    @objc func backButtonTapped() {
        delegate?.backButtonTapped()
    }

    @objc func resendCodeButtonTapped() {
        delegate?.resendCodeButtonTapped()
    }
}

// MARK: - Public functions
extension VerifyPinCodeView {

    public func updateResendCodeLabel(with timer: Int) {
        let text = "Resend code after \(timer) sec"
        resendCodeLabel.text = text
    }

    public func hideResendCodeLabel() {

        UIView.animate(withDuration: 1,
                       animations: { self.resendCodeLabel.alpha = 0 },
                       completion: { _ in self.showView(self.resendCodeButton) })
    }

    public func hideResendCodeButton() {

        UIView.animate(withDuration: 1,
                       animations: { self.resendCodeButton.alpha = 0 },
                       completion: { _ in self.showView(self.resendCodeLabel) })
    }

    public func shakePinCodeView() {
        pinCodeView.shake()
        pinCodeView.eraseView()
    }
}
