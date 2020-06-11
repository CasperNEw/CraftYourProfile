//
//  VerifyPinCodeViewDelegate.swift
//  CraftYourProfile
//
//  Created by Дмитрий Константинов on 11.06.2020.
//  Copyright © 2020 Дмитрий Константинов. All rights reserved.
//

protocol VerifyPinCodeViewDelegate: AnyObject {
    func backButtonTapped()
    func resendCodeButtonTapped()
    func didFinishedEnterCode(_ code: String)
}
