//
//  RecipeListView.swift
//  Fetch.TakeHome
//
//  Created by Roger Jones Work  on 3/19/25.
//

import Combine
import SwiftUI

struct RecipesView<ViewModel>: View where ViewModel: RecipesViewModelProtocol  {
    @ObservedObject var viewModel: ViewModel
    
    var body: some View {
        NavigationView(content: {
            VStack(spacing: 0) {
                switch viewModel.state {
                case .loading:
                    ProgressView()
                case .loaded(let recipes):
                    if recipes.recipes.isEmpty {
                        simpleErrorView(message: "Oh no, there are no recipes to show")
                    } else {
                        recipesListView(list: recipes)
                            .refreshable {
                                await viewModel.fetchRecipes()
                            }
                    }
                case .error(_):
                    simpleErrorView(message: "Opps, there was a problem getting the recipes")
                }
            }
            .navigationTitle("Recipes")
        })
        .task {
            await viewModel.fetchRecipes()
        }
    }
    
    @ViewBuilder
    func recipesListView(list: RecipeList) -> some View {
        List {
            ForEach(list.recipes, id: \.uuid) { recipe in
                let viewModel = RecipeListItemViewModel(recipe: recipe)
                RecipeListItemView(viewModel: viewModel)
            }
        }
    }
    
    @ViewBuilder
    func simpleErrorView(message: String) -> some View{
        VStack {
            Text(message)
            Button("Retry", action: {
                Task {
                    await viewModel.fetchRecipes()
                }
            })
        }
    }
}

#Preview {
    RecipesView(viewModel: RecipesViewModel())
}
