//
//  RecipeListItemViewModel.swift
//  Fetch.TakeHome
//
//  Created by Roger Jones Work  on 3/20/25.
//

import Foundation
import SwiftUI

@MainActor
final class RecipeListItemViewModel  {
    let recipe: Recipe
    private let imageCache: ImageCacheProtocol
    
    init(recipe: Recipe, imageCach: ImageCacheProtocol = ImageCache()) {
        self.recipe = recipe
        self.imageCache = imageCach
    }
    
    func cachedImage(urlString: String) -> UIImage? {
        imageCache.get(urlString)
    }
    
    func save(_ image: Image, url: URL) {
        if let uiImage = ImageRenderer(content: image).uiImage {
            imageCache.saveImge(uiImage, url: url)
        }
    }
}
