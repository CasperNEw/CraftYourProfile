//
//  CountryCodeDataProviderProtocol.swift
//  CraftYourProfile
//
//  Created by Дмитрий Константинов on 08.06.2020.
//  Copyright © 2020 Дмитрий Константинов. All rights reserved.
//

protocol CountryCodeDataProviderProtocol: AnyObject {
    func getCountryCodes(with filter: String?) -> [CountryCode]
    func didSelectItemAt(index: Int)
}
