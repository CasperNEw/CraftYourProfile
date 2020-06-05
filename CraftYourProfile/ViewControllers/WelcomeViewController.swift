//
//  WelcomeViewController.swift
//  CraftYourProfile
//
//  Created by Дмитрий Константинов on 16.05.2020.
//  Copyright © 2020 Дмитрий Константинов. All rights reserved.
//

import UIKit

// TODO: clear VC, add UIView
class WelcomeViewController: UIViewController {

// MARK: Init
    let mainLabel = UILabel(text: "Craft Your Profile", font: .compactRounded(style: .bold, size: 26), color: .white)
    let additionalLabel = UILabel(text: "Create a profile, follow other accounts, make your own lives!",
                                  font: .compactRounded(style: .medium, size: 20),
                                  color: .mainGrayText(), lines: 2)
    let smileView = UIImageView(image: UIImage(named: "whiteSmile"))
    let letsGoButton = UIControl(title: "LET'S GO!!!",
                                 titleColor: .mainBlackText(),
                                 backgroundColor: .mainWhite(),
                                 font: .compactRounded(style: .bold, size: 20),
                                 cornerRadius: 23)
    let bottomTextView = UITextView(text: "By signing up, you agree to our Terms and Privacy Policy",
                                couples: [("Terms", "https://developer.apple.com/terms/"),
                                          ("Privacy Policy", "https://www.apple.com/legal/privacy/en-ww/")],
                                font: .compactRounded(style: .medium, size: 16),
                                textColor: .mainGrayText(), backgroundColor: .mainBlue(), tintColor: .white)

    let circleButton = UIControl(image: UIImage(named: "circle"))
    let safariButton = UIControl(image: UIImage(named: "safari"))
    let homeButton = UIControl(image: UIImage(named: "home"))

// MARK: viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.mainBlue()
        setupNavigationBar()
        setupCenterElements()
        setupBottomTextView()
        setupEmitterAnimation()
        setupBottomButtons()

        letsGoButton.addTarget(self, action: #selector(letsGoButtonPressed), for: .touchUpInside)
        circleButton.addTarget(self, action: #selector(circleButtonPressed), for: .touchUpInside)
        safariButton.addTarget(self, action: #selector(safariButtonPressed), for: .touchUpInside)
        homeButton.addTarget(self, action: #selector(homeButtonPressed), for: .touchUpInside)
    }

    @objc func letsGoButtonPressed() {
        letsGoButton.clickAnimation(with: 0.8)
        navigationController?.pushViewController(VerifyPhoneViewController(), animated: true)
    }
    @objc func circleButtonPressed() {
        circleButton.clickAnimation()
    }
    @objc func safariButtonPressed() {
        safariButton.clickAnimation()
    }
    @objc func homeButtonPressed() {
        homeButton.clickAnimation()
    }
}

// MARK: Setup NAvigation Bar
extension WelcomeViewController {

    func setupNavigationBar() {
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
}

// MARK: Setup Animation
extension WelcomeViewController {

    private func setupEmitterAnimation() {

        let emitterLayer = CAEmitterLayer()
        emitterLayer.emitterPosition = CGPoint(x: view.bounds.width / 2, y: view.bounds.height + 40)
        emitterLayer.emitterSize = CGSize(width: view.bounds.width + 50, height: 20)
        emitterLayer.emitterShape = .line
        emitterLayer.beginTime = CACurrentMediaTime()
        emitterLayer.timeOffset = 5
        emitterLayer.birthRate = 0.3

        let emoji = ["😍", "🥰", "😘", "😜", "💋", "❤️"]
        emitterLayer.emitterCells = makeEmitterCells(emoji: emoji)

        view.layer.addSublayer(emitterLayer)
    }

    private func makeEmitterCells(emoji: [String]) -> [CAEmitterCell] {

        var cells = [CAEmitterCell]()

        for index in 0..<emoji.count*3 {

            let cell = CAEmitterCell()
            let random = .pi / 180 * Float.random(in: -20...20)
            cell.contents = emoji[index % emoji.count].emojiToImage()?.rotate(radians: random)?.cgImage
            cell.scale = 0.4
            cell.scaleRange = 0.3
            cell.birthRate = Float.random(in: 0.2...0.6)
            cell.lifetime = 8.0
            cell.velocity = 0
            cell.yAcceleration = -view.bounds.height / 28
            cells.append(cell)
        }
        return cells
    }
}

// MARK: Setup Subviews
extension WelcomeViewController {

    private func setupCenterElements() {

        mainLabel.translatesAutoresizingMaskIntoConstraints = false
        additionalLabel.translatesAutoresizingMaskIntoConstraints = false
        smileView.translatesAutoresizingMaskIntoConstraints = false
        letsGoButton.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(mainLabel)
        view.addSubview(additionalLabel)
        view.addSubview(smileView)
        view.addSubview(letsGoButton)

        NSLayoutConstraint.activate([
            mainLabel.centerYAnchor.constraint(lessThanOrEqualTo: view.centerYAnchor, constant: -50),
            mainLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            additionalLabel.topAnchor.constraint(equalTo: mainLabel.bottomAnchor, constant: 6),
            additionalLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 60),
            additionalLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -60),

            smileView.heightAnchor.constraint(equalToConstant: 70),
            smileView.widthAnchor.constraint(equalToConstant: 70),
            smileView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            smileView.bottomAnchor.constraint(equalTo: mainLabel.topAnchor, constant: -30),

            letsGoButton.topAnchor.constraint(equalTo: additionalLabel.bottomAnchor, constant: 30),
            letsGoButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            letsGoButton.widthAnchor.constraint(equalToConstant: view.frame.width / 2),
            letsGoButton.heightAnchor.constraint(equalToConstant: 55)
        ])
    }

    private func setupBottomTextView() {

        bottomTextView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(bottomTextView)

        NSLayoutConstraint.activate([
            bottomTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 60),
            bottomTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -60),
            bottomTextView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -120),
            bottomTextView.heightAnchor.constraint(equalToConstant: 80),

            bottomTextView.topAnchor.constraint(greaterThanOrEqualTo: letsGoButton.bottomAnchor, constant: 30)
        ])
    }

    private func setupBottomButtons() {

        safariButton.alpha = 0.9
        circleButton.alpha = 0.9

        safariButton.translatesAutoresizingMaskIntoConstraints = false
        homeButton.translatesAutoresizingMaskIntoConstraints = false
        circleButton.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(safariButton)
        view.addSubview(homeButton)
        view.addSubview(circleButton)

        NSLayoutConstraint.activate([
            safariButton.heightAnchor.constraint(equalToConstant: 60),
            safariButton.widthAnchor.constraint(equalToConstant: 60),
            safariButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            safariButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -60),

            homeButton.heightAnchor.constraint(equalToConstant: 64),
            homeButton.widthAnchor.constraint(equalToConstant: 64),
            homeButton.leadingAnchor.constraint(equalTo: safariButton.trailingAnchor, constant: 26),
            homeButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50),

            circleButton.heightAnchor.constraint(equalToConstant: 56),
            circleButton.widthAnchor.constraint(equalToConstant: 56),
            circleButton.trailingAnchor.constraint(equalTo: safariButton.leadingAnchor, constant: -30),
            circleButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -45)
        ])
    }
}

// MARK: SwiftUI
import SwiftUI

struct WelcomeVCProvider: PreviewProvider {
    static var previews: some View {
        ContainerView().edgesIgnoringSafeArea(.all)
    }

    struct ContainerView: UIViewControllerRepresentable {
        let welcomeVC = WelcomeViewController()
        // swiftlint:disable line_length
        func makeUIViewController(context: UIViewControllerRepresentableContext<WelcomeVCProvider.ContainerView>) -> WelcomeViewController {
            return welcomeVC
        }
        func updateUIViewController(_ uiViewController: WelcomeVCProvider.ContainerView.UIViewControllerType, context: UIViewControllerRepresentableContext<WelcomeVCProvider.ContainerView>) {
        }
        // swiftlint:enable line_length
    }
}
