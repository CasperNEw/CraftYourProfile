//
//  AuthorizationService.swift
//  CraftYourProfile
//
//  Created by Дмитрий Константинов on 11.06.2020.
//  Copyright © 2020 Дмитрий Константинов. All rights reserved.
//

import UIKit

class AuthorizationService {

    // MARK: - Properties
    static var shared = AuthorizationService()
    var database: DatabaseProtocol?

    private var currentAccount: String = ""

    // MARK: - Initialization
    private init() { }

    public func configure(with database: DatabaseProtocol) {
        self.database = database
    }

    // MARK: - Public functions
    public func signIn(account: String,
                       completion: @escaping (Result<String, Error>) -> Void) {

        currentAccount = account
        let pinCode = generationPinCode(with: 6)

        database?.createAccount(account: account,
                                pinCode: pinCode) { error in

                    switch error {
                    case .none:
                        completion(.success(pinCode))
                    case .some(let error):
                        completion(.failure(error))
                    }
        }
    }

    public func updatePinCode(completion: @escaping (Result<String, Error>) -> Void) {

        let newPinCode = generationPinCode(with: 6)

        database?.updateAccount(account: currentAccount,
                                pinCode: newPinCode) { error in

                    switch error {
                    case .none:
                        completion(.success(newPinCode))
                    case .some(let error):
                        completion(.failure(error))
                    }
        }
    }

    public func pinCodeIsValid(pinCode: String,
                               completion: @escaping (Result<Bool, Error>) -> Void) {

        database?.searchAccount(account: currentAccount) { result in

            switch result {
            case .success(( _, let validPinCode)):
                completion(.success(pinCode == validPinCode ? true : false))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    // MARK: - Module function
    private func generationPinCode(with pinCount: Int) -> String {
        var pinCode = ""
        for _ in 1...pinCount {
            pinCode.append(contentsOf: String(Int.random(in: 0...9)))
        }
        return pinCode
    }
}

// TODO: need rebuild
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
