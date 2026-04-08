//
//  File.swift
//  t5
//
//  Created by manas dutta on 22/12/25.
//

import Foundation
import UIKit

class ImageCache {
    
    @MainActor static let shared = ImageCache()
    private let cache = NSCache<NSString, UIImage>()
    
    private init() {}
    
    func image(forKey key: String) -> UIImage? {
        return cache.object(forKey: key as NSString)
    }
    
    func save(_ image: UIImage, forKey key: String) {
        cache.setObject(image, forKey: key as NSString)
    }
   
    func clear() {
        cache.removeAllObjects()
    }
}

