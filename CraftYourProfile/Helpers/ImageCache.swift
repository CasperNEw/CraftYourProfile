//
//  ImageCache.swift
//  CraftYourProfile
//
//  Created by Дмитрий Константинов on 03.08.2020.
//  Copyright © 2020 Дмитрий Константинов. All rights reserved.
//

import UIKit

class ImageCache {

    // MARK: - Properties
    static let publicCache = ImageCache()
    private let cachedImages = NSCache<NSURL, UIImage>()

    // MARK: - Initialization
    private init() { }

    // MARK: - Public function
    public func load(urlString: String,
                     completion: @escaping (UIImage?) -> Void) {

        guard let url = NSURL(string: urlString) else {
            completion(nil)
            return
        }

        if let cachedImage = cachedImages.object(forKey: url) {
            DispatchQueue.main.async {
                completion(cachedImage)
            }
            return
        }

        URLSession
            .shared
            .dataTask(with: url as URL) { (data, _, error) in

                guard let responseData = data,
                    let image = UIImage(data: responseData),
                    error == nil else {

                        DispatchQueue.main.async {
                            completion(nil)
                        }
                        return
                }

                self.cachedImages.setObject(image, forKey: url)

                DispatchQueue.main.async {
                    completion(image)
                }

        }.resume()
    }
}
