//
//  ValidationService.swift
//  CraftYourProfile
//
//  Created by Дмитрий Константинов on 02.06.2020.
//  Copyright © 2020 Дмитрий Константинов. All rights reserved.
//

import libPhoneNumber_iOS

struct ValidationService {

    private let phoneUtil = NBPhoneNumberUtil()

    func isValid(phone: String, region: String) -> Bool {
        do {
            let phoneNumber: NBPhoneNumber = try phoneUtil.parse(phone, defaultRegion: region)
            return phoneUtil.isValidNumber(phoneNumber)
        } catch let error as NSError {
            print(error.localizedDescription)
            return false
        }
    }

    func format(phone: String, region: String) -> String {
        do {
            let phoneNumber: NBPhoneNumber = try phoneUtil.parse(phone, defaultRegion: region)
            do {
                let formattedString: String = try phoneUtil.format(phoneNumber, numberFormat: .RFC3966)
                return(phoneUtil.extractPossibleNumber(formattedString))
            } catch let error {
                print(error.localizedDescription)
                return "error" // TODO: it's not goot
            }
        } catch let error {
            print(error.localizedDescription)
            return "error" // TODO: it's not goot
        }
    }
}
