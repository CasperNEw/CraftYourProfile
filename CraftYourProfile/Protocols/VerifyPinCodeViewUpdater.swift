//
//  VerifyPinCodeViewUpdater.swift
//  CraftYourProfile
//
//  Created by Дмитрий Константинов on 11.06.2020.
//  Copyright © 2020 Дмитрий Константинов. All rights reserved.
//

protocol VerifyPinCodeViewUpdater {
    func updateResendCodeLabel(with text: String)
    func hideResendCodeLabel()
    func hideResendCodeButton()
    func shakePinCodeView()
}
