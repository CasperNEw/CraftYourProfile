//
//  KeychainRepository.swift
//  CraftYourProfile
//
//  Created by Дмитрий Константинов on 01.08.2020.
//  Copyright © 2020 Дмитрий Константинов. All rights reserved.
//

import Foundation

protocol DatabaseProtocol {

    func createAccount(account: String, pinCode: String, completion: @escaping (Error?) -> Void)
    func updateAccount(account: String, pinCode: String, completion: @escaping (Error?) -> Void)

    func searchAccount(
        account: String,
        completion: @escaping (Result<(account: String, pinCode: String), Error>) -> Void)
}

class KeychainRepository: DatabaseProtocol {

    // MARK: - Properties
    private let service = "www.CraftYourProfile.com"

    // MARK: - Public functions
    public func createAccount(account: String,
                              pinCode: String,
                              completion: @escaping (Error?) -> Void) {

        guard let pinCodeData = pinCode.data(using: .utf8) else {
            completion(KeychainError.pinCodeDataError)
            return
        }

        let query: [String: Any] = [kSecClass as String: kSecClassGenericPassword,
                                    kSecAttrService as String: service,
                                    kSecAttrAccount as String: account,
                                    kSecValueData as String: pinCodeData]

        let status = SecItemAdd(query as CFDictionary, nil)

        guard status == errSecSuccess else {
            updateAccount(account: account,
                          pinCode: pinCode) { completion($0) }
            return
        }

        print("[Keychain] Create account - Completed. Your PIN Code - \(pinCode)")
        completion(nil)
    }

    public func updateAccount(account: String,
                              pinCode: String,
                              completion: @escaping (Error?) -> Void) {

        let query: [String: Any] = [kSecClass as String: kSecClassGenericPassword,
                                    kSecAttrService as String: self.service]

        guard let pinCodeData = pinCode.data(using: .utf8) else {
            completion(KeychainError.pinCodeDataError)
            return
        }

        let attributes: [String: Any] = [kSecAttrAccount as String: account,
                                         kSecValueData as String: pinCodeData]

        let status = SecItemUpdate(query as CFDictionary, attributes as CFDictionary)

        guard status != errSecItemNotFound else {
            completion(KeychainError.accountSearchError)
            return
        }

        guard status != errSecDuplicateItem else {
            removeAccounts { error in
                if let error = error {
                    completion(error)
                    return
                }
            }
            completion(KeychainError.duplicateError)
            return
        }

        guard status == errSecSuccess else {
            completion(KeychainError.unhandledError(status: status))
            return
        }

        print("[Keychain] Update account - Completed. Your PIN Code - \(pinCode)")
        completion(nil)
    }

    public func searchAccount(
        account: String,
        completion: @escaping (Result<(account: String, pinCode: String), Error>) -> Void) {

        let query: [String: Any] = [kSecClass as String: kSecClassGenericPassword,
                                    kSecAttrAccount as String: account,
                                    kSecAttrService as String: service,
                                    kSecMatchLimit as String: kSecMatchLimitOne,
                                    kSecReturnAttributes as String: true,
                                    kSecReturnData as String: true]

        var item: CFTypeRef?
        let status = SecItemCopyMatching(query as CFDictionary, &item)

        guard status != errSecItemNotFound else {
            completion(.failure(KeychainError.accountSearchError))
            return
        }

        guard status == errSecSuccess else {
            completion(.failure(KeychainError.unhandledError(status: status)))
            return
        }

        guard let existingItem = item as? [String: Any],
            let pinCodeData = existingItem[kSecValueData as String] as? Data,
            let pinCode = String(data: pinCodeData, encoding: String.Encoding.utf8)
            else {
                completion(.failure(KeychainError.pinCodeDataError))
                return
        }

        completion(.success((account: account, pinCode: pinCode)))
    }

    // MARK: - Module functions
    private func removeAccounts(completion: @escaping (Error?) -> Void) {

        let query: [String: Any] = [kSecClass as String: kSecClassGenericPassword,
                                    kSecAttrService as String: service]

        let status = SecItemDelete(query as CFDictionary)

        guard status == errSecSuccess || status == errSecItemNotFound else {
            completion(KeychainError.unhandledError(status: status))
            return
        }
        print("[Keychain] Remove account - Completed")
        completion(nil)
    }
}
