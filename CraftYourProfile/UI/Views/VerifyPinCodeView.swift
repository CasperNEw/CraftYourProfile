//
//  VerifyPinCodeView.swift
//  CraftYourProfile
//
//  Created by Дмитрий Константинов on 10.06.2020.
//  Copyright © 2020 Дмитрий Константинов. All rights reserved.
//

import UIKit

class VerifyPinCodeView: UIView {

    lazy private var designer: ViewDesignerService = { return ViewDesignerService(self) }()
    private let backButton = UIButton(image: UIImage(named: "back"))
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

    private let resendCodeButton = UIButton(title: "Resend code", titleColor: .white,
                                      backgroundColor: .blueButton(),
                                      font: .compactRounded(style: .semibold, size: 20),
                                      cornerRadius: 20)

    weak var delegate: VerifyPinCodeViewDelegate?

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

    @objc func backButtonTapped() {
        backButton.clickAnimation()
        delegate?.backButtonTapped()
    }

    @objc func resendCodeButtonTapped() {
        resendCodeButton.clickAnimation(with: 0.9)
        delegate?.resendCodeButtonTapped()
    }
}

// MARK: Setup Views
extension VerifyPinCodeView {
    private func addSubviews() {
        backButton.translatesAutoresizingMaskIntoConstraints = false
        mainLabel.translatesAutoresizingMaskIntoConstraints = false
        additionalLabel.translatesAutoresizingMaskIntoConstraints = false
        pinCodeView.translatesAutoresizingMaskIntoConstraints = false
        resendCodeLabel.translatesAutoresizingMaskIntoConstraints = false
        resendCodeButton.translatesAutoresizingMaskIntoConstraints = false
        resendCodeButton.alpha = 0

        addSubview(backButton)
        addSubview(mainLabel)
        addSubview(additionalLabel)
        addSubview(pinCodeView)
        addSubview(resendCodeLabel)
        addSubview(resendCodeButton)
    }
}

// MARK: VerifyPinCodeViewUpdater
extension VerifyPinCodeView: VerifyPinCodeViewUpdater {

    func updateResendCodeLabel(with timer: Int) {
        let text = "Resend code after \(timer) sec"
        resendCodeLabel.text = text
    }

    func updateResendCodeLabel(with text: String) {
        resendCodeLabel.text = text
    }

    func hideResendCodeLabel() {

        UIView.animate(withDuration: 1,
                       animations: { self.resendCodeLabel.alpha = 0 },
                       completion: { _ in self.showResendCodeButton() })
    }

    private func showResendCodeButton() {

        resendCodeButton.transform = CGAffineTransform(scaleX: 0.2, y: 0.2)

        UIView.animate(withDuration: 1.5,
                       delay: 0,
                       usingSpringWithDamping: 0.7,
                       initialSpringVelocity: 0.6,
                       options: .allowUserInteraction,
                       animations: {
                        self.resendCodeButton.transform = CGAffineTransform.identity
                        self.resendCodeButton.alpha = 1
        })
    }

    func hideResendCodeButton() {

        UIView.animate(withDuration: 1,
                       animations: { self.resendCodeButton.alpha = 0 },
                       completion: { _ in self.showResendCodeLabel() })
    }

    private func showResendCodeLabel() {

        resendCodeLabel.transform = CGAffineTransform(scaleX: 0.2, y: 0.2)

        UIView.animate(withDuration: 1.5,
                       delay: 0,
                       usingSpringWithDamping: 0.7,
                       initialSpringVelocity: 0.6,
                       options: .allowUserInteraction,
                       animations: {
                        self.resendCodeLabel.transform = CGAffineTransform.identity
                        self.resendCodeLabel.alpha = 1
        })
    }

    func shakePinCodeView() {
        let animation = CAKeyframeAnimation(keyPath: "transform.translation.x")
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
        animation.duration = 0.6
        animation.values = [-20.0, 20.0, -20.0, 20.0, -10.0, 10.0, -5.0, 5.0, 0.0 ]
        pinCodeView.layer.add(animation, forKey: "shake")
        pinCodeView.eraseView()

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
            self.pinCodeView.becomeFirstResponder()
        }
    }
}
