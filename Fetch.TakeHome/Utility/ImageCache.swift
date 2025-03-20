//
//  ImageCache.swift
//  Fetch.TakeHome
//
//  Created by Roger Jones Work  on 3/20/25.
//

import Foundation
import SwiftUI

protocol ImageCacheProtocol {
    func get(_ url: String) -> UIImage?
    func saveImge(_ image: UIImage, url: URL)
}

class ImageCache: ImageCacheProtocol {
    var cacheDirectory: URL = FileManager.default.urls(for: .cachesDirectory,
                                                       in: .userDomainMask)[0]
    func get(_ url: String) -> UIImage? {
        let fileURL = cacheDirectory.appendingPathComponent(url.hashValue.description)
        guard let data = try? Data(contentsOf: fileURL) else { return nil }
        return UIImage(data: data)
    }
    
    func saveImge(_ image: UIImage, url: URL) {
        if let data = image.jpegData(compressionQuality: 0.8) {
            try? data.write(to: url)
        }
    }
}
