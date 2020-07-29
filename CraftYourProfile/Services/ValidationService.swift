//
//  ValidationService.swift
//  CraftYourProfile
//
//  Created by Дмитрий Константинов on 02.06.2020.
//  Copyright © 2020 Дмитрий Константинов. All rights reserved.
//

import libPhoneNumber_iOS

class ValidationService {

    // MARK: - Properties
    private let phoneUtil = NBPhoneNumberUtil()

    // MARK: - Public functions
    public func isValid(phone: String, region: String, completion: @escaping (Result<Bool, Error>) -> Void) {
        do {
            let phoneNumber: NBPhoneNumber = try phoneUtil.parse(phone, defaultRegion: region)
            completion(.success(phoneUtil.isValidNumber(phoneNumber)))
        } catch let error as NSError {
            completion(.failure(ValidationError.serverError(error: error)))
        }
    }

    public func phoneFormatting(phone: String, code: String, completion: @escaping (Result<String, Error>) -> Void) {

        if code.isEmpty {
            completion(.success(phone))
            return
        }

        do {
            let phoneNumber: NBPhoneNumber = try phoneUtil.parse(phone, defaultRegion: code)
            do {
                let formattedString: String = try phoneUtil.format(phoneNumber, numberFormat: .RFC3966)

                guard let fullString = phoneUtil.extractPossibleNumber(formattedString) else {
                    completion(.success(phone))
                    return
                }

                let prefix = code + "-"
                if fullString.hasPrefix(prefix) {
                    completion(.success(phone))
                    return
                }
                completion(.success(String(fullString.dropFirst(prefix.count))))

            } catch let error {
                completion(.failure(ValidationError.serverError(error: error)))
                return
            }
        } catch let error {
            completion(.failure(ValidationError.serverError(error: error)))
            return
        }
    }
}
