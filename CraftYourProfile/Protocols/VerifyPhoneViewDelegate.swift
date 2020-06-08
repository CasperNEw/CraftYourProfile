//
//  VerifyPhoneViewDelegate.swift
//  CraftYourProfile
//
//  Created by Дмитрий Константинов on 08.06.2020.
//  Copyright © 2020 Дмитрий Константинов. All rights reserved.
//

import UIKit

protocol VerifyPhoneViewDelegate: AnyObject {
    func shouldChangeCharactersIn(_ textField: UITextField, string: String) -> Bool
    func textFieldDidChangeSelection(_ textField: UITextField)

    func crossButtonTapped()
    func codeButtonTapped(_ view: UIView)
    func nextButtonTapped(string: String?)
}


