//
//  NetworkService.swift
//  CraftYourProfile
//
//  Created by Дмитрий Константинов on 02.06.2020.
//  Copyright © 2020 Дмитрий Константинов. All rights reserved.
//

import Foundation

struct NetworkService {

    func getCountriesInformation(completion: @escaping (Result<[CountryFromServer], Error>) -> Void) {

        var component = URLComponents()
        component.scheme = "https"
        component.host = "restcountries.eu"
        component.path = "/rest/v2/all"
        component.queryItems = [URLQueryItem(name: "fields", value: "name;callingCodes;alpha2Code")]

        guard let url = component.url else { return }

        let task = URLSession.shared.dataTask(with: url) { (data, _, error) in
            guard let data = data else { return }
            do {
                let result = try JSONDecoder().decode([CountryFromServer].self, from: data).filter {
                    $0.callingCodes != [""]
                }
                completion(.success(result))
            } catch {
                completion(.failure(error))
            }
        }
        task.resume()
    }
}
