//
//  PinCodeView.swift
//  CraftYourProfile
//
//  Created by Дмитрий Константинов on 10.06.2020.
//  Copyright © 2020 Дмитрий Константинов. All rights reserved.
//

import UIKit

class PinCodeView: UIView, UITextInputTraits {

    private var maxLenght = 6
    private var pinCode: String = "" {
        didSet {
            updateStack(by: pinCode)
            if pinCode.count == maxLenght, let didFinishedEnterCode = didFinishedEnterCode {
                self.resignFirstResponder()
                didFinishedEnterCode(pinCode)
            }
        }
    }
    private let stack = UIStackView()
    var didFinishedEnterCode: ((String) -> Void)?
    var keyboardType: UIKeyboardType = .phonePad

    override init(frame: CGRect) {
        super.init(frame: frame)
        showKeyboardIfNeeded()
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        addSubview(stack)
        stack.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            stack.leadingAnchor.constraint(equalTo: leadingAnchor),
            stack.trailingAnchor.constraint(equalTo: trailingAnchor),
            stack.topAnchor.constraint(equalTo: topAnchor),
            stack.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])

        stack.axis = .horizontal
        stack.spacing = 6
        stack.distribution = .fillEqually
        updateStack(by: pinCode)
    }

    private func updateStack(by code: String) {

        var emptryPins: [UIView] = Array(0..<maxLenght).map {_ in emptyPin()}
        let userPinLength = code.count
        let pins: [UIView] = Array(0..<userPinLength).map {_ in pin()}

        for (index, element) in pins.enumerated() {
            emptryPins[index] = element

            if let stringIndex = code.index(code.startIndex, offsetBy: index, limitedBy: code.endIndex) {

                (emptryPins[index] as? PinView)?.number.text = String(code[stringIndex])
            }
        }

        stack.removeAllArrangedSubviews()
        for view in emptryPins {
            stack.addArrangedSubview(view)
        }
    }

    private func emptyPin() -> UIView {
        let pin = PinView()
        return pin
    }

    private func pin() -> UIView {
        let pin = PinView()
        (pin.pin.isHidden, pin.number.isHidden) = (true, false)
        return pin
    }
}

// MARK: Setup Keyboard
extension PinCodeView {

    override var canBecomeFirstResponder: Bool {
        return true
    }

    private func showKeyboardIfNeeded() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(showKeyboard))
        self.addGestureRecognizer(tapGesture)
    }

    @objc func showKeyboard() {
        self.becomeFirstResponder()
    }
}

// MARK: UIKeyInput
extension PinCodeView: UIKeyInput {

    var hasText: Bool {
        return pinCode.count > 0
    }

    func insertText(_ text: String) {
        if pinCode.count == maxLenght { return }
        pinCode.append(contentsOf: text)
    }

    func deleteBackward() {
        if hasText { pinCode.removeLast() }
    }
}
