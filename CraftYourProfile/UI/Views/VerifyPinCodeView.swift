//
//  VerifyPinCodeView.swift
//  CraftYourProfile
//
//  Created by Дмитрий Константинов on 10.06.2020.
//  Copyright © 2020 Дмитрий Константинов. All rights reserved.
//

import UIKit

class VerifyPinCodeView: UIView {

    lazy var designer: ViewDesignerService = { return ViewDesignerService(self) }()
    private let backButton = UIButton(image: UIImage(named: "cross"))
    private let mainLabel = UILabel(text: "Next, enter the code we sent 😍",
                            font: .compactRounded(style: .black, size: 32),
                            color: .mainBlackText(), lines: 2, alignment: .left)

    private let additionalLabel = UILabel(text: "VERIFICATION CODE",
                                          font: .compactRounded(style: .semibold, size: 15),
                                          color: .gray, lines: 1, alignment: .left)

    private let pinCodeView = PinCodeView()

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
        pinCodeView.didFinishedEnterCode = { code in
            print("code is ", code)
        }
        
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
    }

    private func setupConstraints() {
        designer.backButtonPlacement(backButton)
        designer.mainLabelPlacement(mainLabel, backButton)
        designer.additionalLabelPlacement(additionalLabel, mainLabel)
        designer.mainTextFieldPlacement(pinCodeView, additionalLabel, true)
    }

    @objc func backButtonTapped() {
        backButton.clickAnimation()
    }
}

// MARK: Setup Views
extension VerifyPinCodeView {
    private func addSubviews() {
        backButton.translatesAutoresizingMaskIntoConstraints = false
        mainLabel.translatesAutoresizingMaskIntoConstraints = false
        additionalLabel.translatesAutoresizingMaskIntoConstraints = false
        pinCodeView.translatesAutoresizingMaskIntoConstraints = false

        addSubview(backButton)
        addSubview(mainLabel)
        addSubview(additionalLabel)
        addSubview(pinCodeView)
    }
}

// MARK: Setup Constraints
extension VerifyPinCodeView {

}

// MARK: SwiftUI
import SwiftUI

struct VerifyPinCodeViewProvider: PreviewProvider {
    static var previews: some View {
        ContainerView().edgesIgnoringSafeArea(.all)
    }

    struct ContainerView: UIViewControllerRepresentable {
        let verifyPinCodeVC = VerifyPinCodeViewController()
        // swiftlint:disable line_length
        func makeUIViewController(context: UIViewControllerRepresentableContext<VerifyPinCodeViewProvider.ContainerView>) -> VerifyPinCodeViewController {
            return verifyPinCodeVC
        }
        func updateUIViewController(_ uiViewController: VerifyPinCodeViewProvider.ContainerView.UIViewControllerType, context: UIViewControllerRepresentableContext<VerifyPinCodeViewProvider.ContainerView>) {
        }
        // swiftlint:enable line_length
    }
}
