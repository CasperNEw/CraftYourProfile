//
//  AuthorizationService.swift
//  CraftYourProfile
//
//  Created by Дмитрий Константинов on 11.06.2020.
//  Copyright © 2020 Дмитрий Константинов. All rights reserved.
//

import UIKit

class AuthorizationService {

    static var shared = AuthorizationService()
    private let service = "www.CraftYourProfile.com"
    private var currentAccount: String = ""

    private init() { }

    func generationPinCode(with pinCount: Int) -> String {
        var pinCode = ""
        for _ in 1...pinCount {
            pinCode.append(contentsOf: String(Int.random(in: 0...9)))
        }
        return pinCode
    }

    func signIn(account: String, pinCode: String) throws {

        guard let pinCodeData = pinCode.data(using: .utf8) else { throw KeychainError.pinCodeDataError }

        let query: [String: Any] = [kSecClass as String: kSecClassGenericPassword,
                                    kSecAttrService as String: self.service,
                                    kSecAttrAccount as String: account,
                                    kSecValueData as String: pinCodeData]

        let status = SecItemAdd(query as CFDictionary, nil)
        guard status == errSecSuccess else {
            try updateAccount(account: account, pinCode: pinCode)
            return
        }

        currentAccount = account
        print("[Keychain] Create account - Complete. Your PIN Code - \(pinCode)")
    }

    func updatePinCode(with pinCount: Int) throws -> String {
        let newPinCode = generationPinCode(with: pinCount)
        try updateAccount(account: currentAccount, pinCode: newPinCode)
        return newPinCode
    }

    private func updateAccount(account: String, pinCode: String) throws {

        let query: [String: Any] = [kSecClass as String: kSecClassGenericPassword,
                                    kSecAttrService as String: self.service]

        guard let pinCodeData = pinCode.data(using: .utf8) else { throw KeychainError.pinCodeDataError }

        let attributes: [String: Any] = [kSecAttrAccount as String: account,
                                         kSecValueData as String: pinCodeData]

        let status = SecItemUpdate(query as CFDictionary, attributes as CFDictionary)

        guard status != errSecItemNotFound else { throw KeychainError.accountSearchError }
        guard status == errSecSuccess else { throw KeychainError.unhandledError(status: status) }

        currentAccount = account
        print("[Keychain] Update account - Complete. Your PIN Code - \(pinCode)")
    }

    private func deleteAccount() throws {

        let query: [String: Any] = [kSecClass as String: kSecClassGenericPassword,
                                    kSecAttrService as String: self.service]

        let status = SecItemDelete(query as CFDictionary)
        guard status == errSecSuccess || status == errSecItemNotFound else {
            throw KeychainError.unhandledError(status: status)
        }
    }

    func getExpectedPinCode() throws -> String {

        let query: [String: Any] = [kSecClass as String: kSecClassGenericPassword,
                                    kSecAttrAccount as String: currentAccount,
                                    kSecAttrService as String: self.service,
                                    kSecMatchLimit as String: kSecMatchLimitOne,
                                    kSecReturnAttributes as String: true,
                                    kSecReturnData as String: true]

        var item: CFTypeRef?
        let status = SecItemCopyMatching(query as CFDictionary, &item)
        guard status != errSecItemNotFound else { throw KeychainError.accountSearchError }
        guard status == errSecSuccess else { throw KeychainError.unhandledError(status: status) }

        guard let existingItem = item as? [String: Any],
            let pinCodeData = existingItem[kSecValueData as String] as? Data,
            let pinCode = String(data: pinCodeData, encoding: String.Encoding.utf8)
            else {
                throw KeychainError.pinCodeDataError
        }
        return pinCode
    }
}

// MARK: fake methods
extension AuthorizationService {

    func createUserData(name: String, birthday: Date) {
        print("Name -", name)
        print("Birthday -", birthday)
    }

    func updateUserPhoto(image: UIImage?) {
        guard image != nil else {
            print("False", #function)
            return
        }
        print("Success", #function)
    }
}

extension AuthorizationService: NSCopying {

    func copy(with zone: NSZone? = nil) -> Any {
        return self
    }
}
