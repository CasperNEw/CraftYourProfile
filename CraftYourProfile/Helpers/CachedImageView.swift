//
//  CachedImageView.swift
//  CraftYourProfile
//
//  Created by Дмитрий Константинов on 01.08.2020.
//  Copyright © 2020 Дмитрий Константинов. All rights reserved.
//

//  Created by Brian Voong on 7/29/16.
//  Copyright © 2016 luxeradio. All rights reserved.
//

import UIKit

/**
 A convenient UIImageView to load and cache images.
 */

open class CachedImageView: UIImageView {

    public static let imageCache = NSCache<NSString, DiscardableImageCacheItem>()

    open var shouldUseEmptyImage = true

    private var urlStringForChecking: String?
    private var emptyImage: UIImage?

    public convenience init(cornerRadius: CGFloat = 0, tapCallback: @escaping (() -> Void)) {
        self.init(cornerRadius: cornerRadius, emptyImage: nil)
        self.tapCallback = tapCallback
        isUserInteractionEnabled = true
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap)))
    }

    @objc func handleTap() {
        tapCallback?()
    }

    private var tapCallback: (() -> Void)?

    public init(cornerRadius: CGFloat = 0, emptyImage: UIImage? = nil) {
        super.init(frame: .zero)
        contentMode = .scaleAspectFill
        clipsToBounds = true
        layer.cornerRadius = cornerRadius
        self.emptyImage = emptyImage
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    /**
     Easily load an image from a URL string and cache it to reduce network overhead later.

     - parameter urlString: The url location of your image, usually on a remote server somewhere.
     - parameter completion: Optionally execute some task after the image download completes
     */

    open func loadImage(urlString: String, completion: (() -> Void)? = nil) {
        image = nil

        self.urlStringForChecking = urlString

        let urlKey = urlString as NSString

        if let cachedItem = CachedImageView.imageCache.object(forKey: urlKey) {
            image = cachedItem.image
            completion?()
            return
        }

        guard let url = URL(string: urlString) else {
            if shouldUseEmptyImage {
                image = emptyImage
            }
            return
        }

        URLSession.shared.dataTask(with: url, completionHandler: { [weak self] (data, _, error) in
            if error != nil {
                return
            }

            DispatchQueue.main.async {
                if let image = UIImage(data: data!) {
                    let cacheItem = DiscardableImageCacheItem(image: image)
                    CachedImageView.imageCache.setObject(cacheItem, forKey: urlKey)

                    if urlString == self?.urlStringForChecking {
                        self?.image = image
                        completion?()
                    }
                }
            }

            }).resume()
    }
}

open class DiscardableImageCacheItem: NSObject, NSDiscardableContent {

    private(set) public var image: UIImage?
    var accessCount: UInt = 0

    public init(image: UIImage) {
        self.image = image
    }

    public func beginContentAccess() -> Bool {
        if image == nil {
            return false
        }

        accessCount += 1
        return true
    }

    public func endContentAccess() {
        if accessCount > 0 {
            accessCount -= 1
        }
    }

    public func discardContentIfPossible() {
        if accessCount == 0 {
            image = nil
        }
    }

    public func isContentDiscarded() -> Bool {
        return image == nil
    }
}
