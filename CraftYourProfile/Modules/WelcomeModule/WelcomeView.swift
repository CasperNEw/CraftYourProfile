//
//  WelcomeView.swift
//  CraftYourProfile
//
//  Created by Дмитрий Константинов on 09.06.2020.
//  Copyright © 2020 Дмитрий Константинов. All rights reserved.
//

import UIKit

protocol WelcomeViewDelegate: AnyObject {

    func letsGoButtonTapped()
    func circleButtonTapped()
    func safariButtonTapped()
    func homeButtonTapped()
}

class WelcomeView: UIView {

    // MARK: - Properties
    private let mainLabel = UILabel(text: "Craft Your Profile",
                                    font: .compactRounded(style: .bold, size: 26),
                                    color: .white)

    private let additionalLabel = UILabel(text: "Create a profile, follow other accounts, make your own lives!",
                                          font: .compactRounded(style: .medium, size: 20),
                                          color: .mainGrayText(), lines: 2)

    private let smileView = UIImageView(image: UIImage(named: "whiteSmile"))

    private let letsGoButton = UIControl(title: "LET'S GO!!!",
                                         titleColor: .mainBlackText(),
                                         backgroundColor: .mainWhite(),
                                         font: .compactRounded(style: .bold, size: 20),
                                         cornerRadius: 23)

    private let bottomTextView = UITextView(text: "By signing up, you agree to our Terms and Privacy Policy",
                                            couples: [("Terms", "https://developer.apple.com/terms/"),
                                                      ("Privacy Policy", "https://www.apple.com/legal/privacy/en-ww/")],
                                            font: .compactRounded(style: .medium, size: 16),
                                            textColor: .mainGrayText(), backgroundColor: .clear, tintColor: .white)

    private let circleButton = UIControl(image: UIImage(named: "circle"), alpha: 0.9)
    private let safariButton = UIControl(image: UIImage(named: "safari"), alpha: 0.9)
    private let homeButton = UIControl(image: UIImage(named: "home"))

    private let animator = EmitterLayerAnimator()
    private let emoji = ["😍", "🥰", "😘", "😜", "💋", "❤️"]

    weak var delegate: WelcomeViewDelegate?

    private var didSetupConstraints = false

    // MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func updateConstraints() {
        super.updateConstraints()

        if !didSetupConstraints {

            setGradientBackground(colorTop: .mainBlue(),
                                  colorBottom: .black,
                                  startPoint: CGPoint(x: 0.5, y: 1.3),
                                  endPoint: CGPoint(x: 0.5, y: 0.8),
                                  locations: [0, 1])

            setupConstraints()
            didSetupConstraints = true
        }
    }

    // MARK: - Module functions
    private func setupViews() {

        addSubviews([mainLabel, additionalLabel, smileView, letsGoButton, bottomTextView])
        setupAnimation()
        addSubviews([safariButton, homeButton, circleButton])

        letsGoButton.addTarget(self, action: #selector(letsGoButtonTapped), for: .touchUpInside)
        circleButton.addTarget(self, action: #selector(circleButtonTapped), for: .touchUpInside)
        safariButton.addTarget(self, action: #selector(safariButtonTapped), for: .touchUpInside)
        homeButton.addTarget(self, action: #selector(homeButtonTapped), for: .touchUpInside)
    }

    private func setupConstraints() {
        setupCenterElementConstraints()
        setupBottomTextViewConstraints()
        setupBottomButtonsConstraints()
    }

    private func setupAnimation() {
        let emitter = animator.createEmitterLayer(with: emoji)
        layer.addSublayer(emitter)
    }

    // MARK: - Actions
    @objc private func letsGoButtonTapped() {
        letsGoButton.clickAnimation(with: 0.8)
        delegate?.letsGoButtonTapped()
    }
    @objc private func circleButtonTapped() {
        circleButton.clickAnimation()
        delegate?.circleButtonTapped()
    }
    @objc private func safariButtonTapped() {
        safariButton.clickAnimation()
        delegate?.safariButtonTapped()
    }
    @objc private func homeButtonTapped() {
        homeButton.clickAnimation()
        delegate?.homeButtonTapped()
    }
}

// MARK: setupConstraints
extension WelcomeView {

    private func setupCenterElementConstraints() {

        NSLayoutConstraint.activate([
            mainLabel.centerYAnchor.constraint(lessThanOrEqualTo: centerYAnchor, constant: -50),
            mainLabel.centerXAnchor.constraint(equalTo: centerXAnchor),

            additionalLabel.topAnchor.constraint(equalTo: mainLabel.bottomAnchor, constant: 6),
            additionalLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 60),
            additionalLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -60),

            smileView.heightAnchor.constraint(equalToConstant: 70),
            smileView.widthAnchor.constraint(equalToConstant: 70),
            smileView.centerXAnchor.constraint(equalTo: centerXAnchor),
            smileView.bottomAnchor.constraint(equalTo: mainLabel.topAnchor, constant: -30),

            letsGoButton.topAnchor.constraint(equalTo: additionalLabel.bottomAnchor, constant: 30),
            letsGoButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            letsGoButton.widthAnchor.constraint(equalToConstant: frame.width / 2),
            letsGoButton.heightAnchor.constraint(equalToConstant: 55)
        ])
    }

    private func setupBottomTextViewConstraints() {

        NSLayoutConstraint.activate([
            bottomTextView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 60),
            bottomTextView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -60),
            bottomTextView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -120),
            bottomTextView.heightAnchor.constraint(equalToConstant: 80),
            bottomTextView.topAnchor.constraint(greaterThanOrEqualTo: letsGoButton.bottomAnchor, constant: 30)
        ])
    }

    private func setupBottomButtonsConstraints() {

        NSLayoutConstraint.activate([
            safariButton.heightAnchor.constraint(equalToConstant: 60),
            safariButton.widthAnchor.constraint(equalToConstant: 60),
            safariButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            safariButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -60),

            homeButton.heightAnchor.constraint(equalToConstant: 64),
            homeButton.widthAnchor.constraint(equalToConstant: 64),
            homeButton.leadingAnchor.constraint(equalTo: safariButton.trailingAnchor, constant: 26),
            homeButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -50),

            circleButton.heightAnchor.constraint(equalToConstant: 56),
            circleButton.widthAnchor.constraint(equalToConstant: 56),
            circleButton.trailingAnchor.constraint(equalTo: safariButton.leadingAnchor, constant: -30),
            circleButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -45)
        ])
    }
}
