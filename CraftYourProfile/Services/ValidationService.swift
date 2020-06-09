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

    func isValid(phone: String, region: String, completion: @escaping (Result<Bool, Error>) -> Void) {
        do {
            let phoneNumber: NBPhoneNumber = try phoneUtil.parse(phone, defaultRegion: region)
            completion(.success(phoneUtil.isValidNumber(phoneNumber)))
        } catch let error as NSError {
            completion(.failure(error))
        }
    }

    func format(phone: String, region: String, completion: @escaping (Result<String, Error>) -> Void) {
        do {
            let phoneNumber: NBPhoneNumber = try phoneUtil.parse(phone, defaultRegion: region)
            do {
                let formattedString: String = try phoneUtil.format(phoneNumber, numberFormat: .RFC3966)
                completion(.success(phoneUtil.extractPossibleNumber(formattedString)))
            } catch let error {
                completion(.failure(error))
            }
        } catch let error {
            completion(.failure(error))
        }
    }
}
