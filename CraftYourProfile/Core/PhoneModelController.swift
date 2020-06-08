//
//  PhoneModelController.swift
//  CraftYourProfile
//
//  Created by Дмитрий Константинов on 05.06.2020.
//  Copyright © 2020 Дмитрий Константинов. All rights reserved.
//

import Foundation

class PhoneModelController {

    private let networkService = NetworkService()
    private let validatingService = ValidationService()

    private var sourceCodes: [CountryCode] = []
    private var countryCodes: [CountryCode] = []
    private var lastSelected: CountryCode?

    init() {
        networkService.getCountriesInformation { [weak self] (result) in
            switch result {
            case .success(let data):
                self?.makeCountryCodesFromNetworkData(data)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }

    private func makeCountryCodesFromNetworkData(_ source: [CountryFromServer]) {
        var countryCodes: [CountryCode] = []
        for country in source {
            for code in country.callingCodes {
                countryCodes.append(CountryCode(code: "+" + code,
                                                name: country.name,
                                                shortName: country.alpha2Code))
            }
        }
        countryCodes.sort { $0.name < $1.name }

        self.sourceCodes = countryCodes
        self.countryCodes = countryCodes
    }

    func getCodesCount() -> Int {
        return countryCodes.count
    }

    func getCodesDescription(at index: Int) -> String {
        return countryCodes[index].description
    }

    func getTheSelectedCode(at index: Int) -> String {
        lastSelected = countryCodes[index]
        return countryCodes[index].code
    }

    func filterCodes(searchText: String) {

        if !searchText.isEmpty {
            countryCodes = sourceCodes.filter { $0.description.lowercased().contains(searchText.lowercased()) }
        } else {
            countryCodes = sourceCodes
        }
    }

    func isValid(phone: String?) -> Bool {
        guard let phone = phone else { return false }
        guard let region = lastSelected?.shortName else { return false }
        return validatingService.isValid(phone: phone, region: region)
    }

    private func format(phone: String) -> String {
        guard let region = lastSelected?.shortName else { return "RU" }
        return validatingService.format(phone: phone, region: region)
    }

    func getFormattedPhoneNumber(phone: String) -> String {
        let fullString = self.format(phone: phone)
        guard let code = lastSelected?.code else { return phone }
        let prefix = code + "-"
        guard fullString.hasPrefix(prefix) else { return phone }
        return String(fullString.dropFirst(prefix.count))
    }

    func getCountryCodes(with filter: String?) -> [CountryCode] {
        guard let filter = filter else { return countryCodes }
        filterCodes(searchText: filter)
        return countryCodes
    }
}
