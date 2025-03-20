//
//  File.swift
//  Fetch.TakeHomeTests
//
//  Created by Roger Jones Work  on 3/20/25.
//

@testable import Fetch_TakeHome
import Foundation
import UIKit

let mockRecipe = Recipe(uuid: "id",
                        name: "Name",
                        cuisine: "cuisine",
                        photoUrlSmall: "https://d3jbb8n5wk0qxi.cloudfront.net/photos/b9ab0071-b281-4bee-b361-ec340d405320/small.jpg",
                        photoUrlLarge: "https://d3jbb8n5wk0qxi.cloudfront.net/photos/b9ab0071-b281-4bee-b361-ec340d405320/large.jpg",
                        sourceUrl: "https://www.nyonyacooking.com/recipes/apam-balik~SJ5WuvsDf9WQ",
                        youtubeUrl: "https://www.youtube.com/watch?v=6R8ffRRJcrg")

class MockImageCache: ImageCacheProtocol {
    var getCalled = false
    var saveCalled = false
    
    func get(_ url: String) -> UIImage? {
        getCalled = true
        return nil
    }
    
    func saveImge(_ image: UIImage, url: URL) {
        saveCalled = true
    }
}

class MockURLSession: URLSessionProtocol {
    var data: Data?
    var response: URLResponse?
    var error: Error?
    
    func data(from url: URL) async throws -> (Data, URLResponse) {
        if let error = error {
            throw error
        }
        return (data ?? Data(),
                response ?? HTTPURLResponse(url: url,
                                            statusCode: 200,
                                            httpVersion: nil,
                                            headerFields: nil)!)
    }
}
