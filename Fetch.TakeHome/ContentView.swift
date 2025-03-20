//
//  ContentView.swift
//  Fetch.TakeHome
//
//  Created by Roger Jones Work  on 3/19/25.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        RecipesView(viewModel: RecipesViewModel())
    }
}

#Preview {
    ContentView()
}
