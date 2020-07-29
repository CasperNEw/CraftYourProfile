//
//  CountryCodeConfigurator.swift
//  CraftYourProfile
//
//  Created by Дмитрий Константинов on 29.07.2020.
//  Copyright © 2020 Дмитрий Константинов. All rights reserved.
//

struct CountryCodeConfigurator {

    static func create() -> CountryCodeViewController {
        return CountryCodeViewController()
    }

    static func configure(with reference: CountryCodeViewController) {

        let networkService = NetworkService()
        reference.networkService = networkService
    }
}
