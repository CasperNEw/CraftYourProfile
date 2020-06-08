//
//  CountryCode.swift
//  CraftYourProfile
//
//  Created by Дмитрий Константинов on 05.06.2020.
//  Copyright © 2020 Дмитрий Константинов. All rights reserved.
//

struct CountryCode {

    let code: String
    let name: String
    let shortName: String

    var description: String { return code + " " + name }
}

extension CountryCode: Hashable {

    func hash(into hasher: inout Hasher) {
        hasher.combine(description)
    }
    static func == (lhs: CountryCode, rhs: CountryCode) -> Bool {
        return lhs.description == rhs.description
    }
}
