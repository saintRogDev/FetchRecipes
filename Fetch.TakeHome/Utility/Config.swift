//
//  Config.swift
//  Fetch.TakeHome
//
//  Created by Roger Jones Work  on 3/19/25.
//

import Foundation
struct Config {
    static let baseURL = URL(string: "https://d3jbb8n5wk0qxi.cloudfront.net")
    static let recipesEndpoint = URL(string: "/recipes.json", relativeTo: baseURL)
    static let recipesMalformedEndpoint = URL(string: "/recipes-malformed.json", relativeTo: baseURL)
    static let recipesEmptyEndpoint = URL(string: "/recipes-empty.json", relativeTo: baseURL)
}
