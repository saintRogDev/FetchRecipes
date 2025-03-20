//
//  Recipe.swift
//  Fetch.TakeHome
//
//  Created by Roger Jones Work  on 3/19/25.
//

import Foundation

struct Recipe: Codable {
    let uuid: String
    let name: String
    let cuisine: String
    let photoUrlSmall: String?
    let photoUrlLarge: String?
    let sourceUrl: String?
    let youtubeUrl: String?
}

struct RecipeList: Codable {
    let recipes: [Recipe]
}
