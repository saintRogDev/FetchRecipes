//
//  RecipeListItemViewModelTest.swift
//  Fetch.TakeHomeTests
//
//  Created by Roger Jones Work  on 3/20/25.
//

@testable import Fetch_TakeHome
import XCTest
import SwiftUI

class MockNetwork: NetworkProtocol {
    let result: Result<RecipeList, Error>
    
    init(result: Result<RecipeList, Error>) {
        self.result = result
    }
    
    func fetchData<T: Decodable>(_ url: URL) async throws -> T {
        switch result {
        case .success(let data as T):
            return data
        case .failure(let error):
            throw error
        default:
            fatalError("Invalid mock response type")
        }
    }
}

final class RecipeListItemViewModelTest: XCTestCase {
    @MainActor func testImageToCache() {
        let mockCache = MockImageCache()
        let testObject = RecipeListItemViewModel(recipe: mockRecipe,
                                                 imageCach: mockCache)
        let image = Image("logo")
        guard let url = URL(string: "www.google.com") else {
            XCTFail("failed creating url")
            return
        }
        testObject.save(image, url: url)
        
        XCTAssertTrue(mockCache.saveCalled)
    }
    
    @MainActor func testGetCachedImage() {
        let mockCache = MockImageCache()
        let testObject = RecipeListItemViewModel(recipe: mockRecipe,
                                                 imageCach: mockCache)
        let image = testObject.cachedImage(urlString: "www.google.com")
        XCTAssertTrue(mockCache.getCalled)
    }
    
}
