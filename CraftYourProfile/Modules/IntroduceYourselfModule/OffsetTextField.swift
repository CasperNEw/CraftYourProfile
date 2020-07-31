//
//  OffsetTextField.swift
//  CraftYourProfile
//
//  Created by Дмитрий Константинов on 31.07.2020.
//  Copyright © 2020 Дмитрий Константинов. All rights reserved.
//

import UIKit

class OffsetTextField: UITextField {

    let padding = UIEdgeInsets(top: 0, left: 24, bottom: 0, right: 24)

    override open func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }

    override open func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }

    override open func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
}
