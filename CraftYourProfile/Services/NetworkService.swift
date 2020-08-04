//
//  NetworkService.swift
//  CraftYourProfile
//
//  Created by Дмитрий Константинов on 02.06.2020.
//  Copyright © 2020 Дмитрий Константинов. All rights reserved.
//

import Foundation

protocol NetworkServiceSingleCountryProtocol {
    func getCountryInformation(shortCode: String, completion: @escaping (Result<CountryFromServer, Error>) -> Void)
}

class NetworkService: NetworkServiceSingleCountryProtocol {

    // MARK: - Properties
    enum RestcountriesPath: String {
        case all = "/rest/v2/all"
        case single = "/rest/v2/alpha/%@"
    }

    private let imageUrl = "https://www.countryflags.io/%@/flat/32.png"

    // MARK: - Public functions
    public func getCountryInformation(shortCode: String,
                                      completion: @escaping (Result<CountryFromServer, Error>) -> Void) {

        let path = String(format: RestcountriesPath.single.rawValue, shortCode.lowercased())
        request(path: path) { completion($0) }
    }

    public func getCountriesInformation(completion: @escaping (Result<[CountryFromServer], Error>) -> Void) {

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

// MARK: - Work with Image
extension NetworkService {

    func getImageUrl(with shortCode: String) -> String {
        return String(format: imageUrl, shortCode)
    }

    func getImageData(with shortCode: String, completion: @escaping (Data) -> Void) {

        let urlString = String(format: imageUrl, shortCode)

        guard let url = URL(string: urlString) else { return }
        let request = URLRequest(url: url)
        let task = URLSession.shared.dataTask(with: request) { (data, _, _) in
            DispatchQueue.main.async {
                guard let data = data else { return }
                completion(data)
            }
        }
        task.resume()
    }
}
