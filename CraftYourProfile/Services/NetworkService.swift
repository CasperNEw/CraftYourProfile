//
//  NetworkService.swift
//  CraftYourProfile
//
//  Created by Дмитрий Константинов on 02.06.2020.
//  Copyright © 2020 Дмитрий Константинов. All rights reserved.
//

import Foundation

protocol NetworkServiceLimitedProtocol {
    func getCountryInformation(shortCode: String, completion: @escaping (Result<CountryFromServer, Error>) -> Void)
}

class NetworkService: NetworkServiceLimitedProtocol {

    // MARK: - Properties
    enum RestcountriesPath: String {
        case all = "/rest/v2/all"
        case single = "/rest/v2/alpha/%@"
    }

    // MARK: - Public functions
    public func getCountryInformation(shortCode: String,
                                      completion: @escaping (Result<CountryFromServer, Error>) -> Void) {

        let path = String(format: RestcountriesPath.single.rawValue, shortCode.lowercased())
        request(path: path) { completion($0) }
    }

    public func getCountriesInformation2(completion: @escaping (Result<[CountryFromServer], Error>) -> Void) {

        let path = RestcountriesPath.all.rawValue

        request(path: path) { (result: Result<[CountryFromServer], Error>) in

            switch result {
            case .success(let data):
                completion(.success(data.filter { $0.callingCodes != [""] }))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    // MARK: - Module function
    private func request<T: Decodable>(path: String,
                                       completion: @escaping (Result<T, Error>) -> Void) {

        var component = URLComponents()
        component.scheme = "https"
        component.host = "restcountries.eu"
        component.path = path
        component.queryItems = [URLQueryItem(name: "fields", value: "name;callingCodes;alpha2Code")]

        guard let url = component.url else { return }

        let task = URLSession.shared.dataTask(with: url) { (data, _, error) in

            guard let data = data else {
                if let error = error {
                    DispatchQueue.main.async {
                        completion(.failure(NetworkError.serverError(error: error)))
                    }
                    return
                }
                DispatchQueue.main.async {
                    completion(.failure(NetworkError.noConnectionError))
                }
                return
            }

            do {
                let result = try JSONDecoder().decode(T.self, from: data)
                DispatchQueue.main.async {
                    completion(.success(result))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(NetworkError.incorrectDataError))
                }
            }
        }
        task.resume()
    }
}
