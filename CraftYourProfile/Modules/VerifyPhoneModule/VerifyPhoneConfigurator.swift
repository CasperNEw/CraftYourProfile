//
//  VerifyPhoneConfigurator.swift
//  CraftYourProfile
//
//  Created by Дмитрий Константинов on 26.07.2020.
//  Copyright © 2020 Дмитрий Константинов. All rights reserved.
//

struct VerifyPhoneConfigurator {

    static func create() -> VerifyPhoneViewController {
        return VerifyPhoneViewController()
    }

    static func configure(with reference: VerifyPhoneViewController) {

        let model = VerifyPhoneModelController()
        let popover = CountryCodeViewController()

        popover.delegate = reference

        reference.modelController = model
        reference.popOver = popover
    }
}
