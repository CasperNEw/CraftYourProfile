//
//  VerifyPhoneModelController.swift
//  CraftYourProfile
//
//  Created by Дмитрий Константинов on 05.06.2020.
//  Copyright © 2020 Дмитрий Константинов. All rights reserved.
//

import Foundation

protocol VerifyPhoneModelControllerProtocol {

    func networkErrorChecking(completion: (Error?) -> Void)
    func reloadData()
    func isValid(phone: String?, completion: @escaping (Error?) -> Void) -> Bool
    func getFormattedPhoneNumber(phone: String, completion: @escaping (Error?) -> Void) -> String
    func getCountryCodes(with filter: String?) -> [CountryCode]
    func getTheSelectedCode(at index: Int) -> String
}

class VerifyPhoneModelController: VerifyPhoneModelControllerProtocol {

    private let networkService = NetworkService()
    private let validatingService = ValidationService()

    private var sourceCodes: [CountryCode] = []
    private var countryCodes: [CountryCode] = []
    private var lastSelected: CountryCode?

    private var statusError: Error?

    init() {
        getNetworkData()
    }

    private func getNetworkData(completion: @escaping (Error?) -> Void = { _ in }) {
        networkService.getCountriesInformation { [weak self] (result) in
            switch result {
            case .success(let data):
                self?.statusError = nil
                completion(nil)
                self?.makeCountryCodesFromNetworkData(data)
            case .failure(let error):
                self?.statusError = error
                completion(error)
            }
        }
    }

    func networkErrorChecking(completion: (Error?) -> Void) {
        completion(statusError)
    }

    func reloadData() {
        getNetworkData()
    }

    private func makeCountryCodesFromNetworkData(_ source: [CountryFromServer]) {

        var countryCodes: [CountryCode] = []
        let item = DispatchWorkItem {
            for country in source {
                for code in country.callingCodes {
                    countryCodes.append(CountryCode(code: "+" + code,
                                                    name: country.name,
                                                    shortName: country.alpha2Code))
                }
            }
            countryCodes.sort { $0.name < $1.name }
        }

        item.notify(queue: DispatchQueue.main) {
            self.sourceCodes = countryCodes.removingDuplicates()
            self.countryCodes = countryCodes.removingDuplicates()
        }

        DispatchQueue.global(qos: .userInitiated).async(execute: item)
    }

    func getTheSelectedCode(at index: Int) -> String {
        lastSelected = countryCodes[index]
        return countryCodes[index].code
    }

    private func filterCodes(searchText: String) {

        if !searchText.isEmpty {
            countryCodes = sourceCodes.filter { $0.description.lowercased().contains(searchText.lowercased()) }
        } else {
            countryCodes = sourceCodes
        }
    }

    func isValid(phone: String?, completion: @escaping (Error?) -> Void = { _ in }) -> Bool {
        guard let phone = phone else { completion(nil); return false }
        guard let region = lastSelected?.shortName else { completion(nil); return false }

        var check: Bool = false
        validatingService.isValid(phone: phone, region: region) { (result) in
            switch result {
            case .success(let isValid):
                check = isValid
                completion(nil)
            case .failure(let error):
                completion(error)
            }
        }
        return check
    }

    private func format(phone: String, completion: @escaping (Error?) -> Void = { _ in }) -> String? {
        guard let region = lastSelected?.shortName else { return nil }

        var formattedString = ""
        validatingService.format(phone: phone, region: region) { (result) in
            switch result {
            case .success(let format):
                formattedString = format
                completion(nil)
            case .failure(let error):
                completion(error)
            }
        }
        return formattedString
    }

    func getFormattedPhoneNumber(phone: String, completion: @escaping (Error?) -> Void = { _ in }) -> String {
        guard let fullString = format(phone: phone, completion: { (error) in
            guard let error = error else { return }
            completion(error)
        }) else { completion(nil); return phone }
        guard let code = lastSelected?.code else { completion(nil); return phone }
        let prefix = code + "-"
        guard fullString.hasPrefix(prefix) else { completion(nil); return phone }
        completion(nil)
        return String(fullString.dropFirst(prefix.count))
    }

    func getCountryCodes(with filter: String?) -> [CountryCode] {
        filterCodes(searchText: filter ?? "")
        return countryCodes
    }
}
