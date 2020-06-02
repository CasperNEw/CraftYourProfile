//
//  CountryFromServer.swift
//  CraftYourProfile
//
//  Created by Дмитрий Константинов on 02.06.2020.
//  Copyright © 2020 Дмитрий Константинов. All rights reserved.
//

struct CountryFromServer: Decodable {
    let alpha2Code: String
    let callingCodes: [String]
    let name: String
}
