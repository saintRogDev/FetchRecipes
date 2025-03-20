//
//  RecipeViewModel.swift
//  Fetch.TakeHome
//
//  Created by Roger Jones Work  on 3/19/25.
//

import Foundation
import SwiftUI

protocol RecipesViewModelProtocol: ObservableObject {
    var state: RecipesViewModel.ViewState { get }
    func fetchRecipes() async
}

final class RecipesViewModel: RecipesViewModelProtocol {
    enum ViewState {
        case loading
        case loaded(recipes: RecipeList)
        case error(message: String)
    }
    
    @Published var state: ViewState = .loading
    private let network: NetworkProtocol
    
    init(network: NetworkProtocol = Network()) {
        self.network = network
    }
    
    func fetchRecipes() async {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            self.state = .loading
        }
        guard let recipesUrl = Config.recipesEndpoint else { return }
        do {
            let recipes: RecipeList = try await network.fetchData(recipesUrl)
            DispatchQueue.main.async { [weak self] in
                guard let self else { return }
                self.state = .loaded(recipes: recipes)
            }
            
        } catch {
            DispatchQueue.main.async { [weak self] in
                guard let self else { return }
                self.state = .error(message: error.localizedDescription)
            }
        }
    }
}
