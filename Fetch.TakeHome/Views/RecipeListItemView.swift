//
//  RecipeListItemView.swift
//  Fetch.TakeHome
//
//  Created by Roger Jones Work  on 3/20/25.
//

import SwiftUI
import WebKit

struct RecipeListItemView: View {
    var viewModel: RecipeListItemViewModel
    @State var imageSelected: Bool = false
    @State var itemSelected: Bool = false
    
    var body: some View {
        HStack(spacing: 0) {
            imageView(urlString: viewModel.recipe.photoUrlSmall)
                .frame(width: 75, height: 75)
                .padding(.trailing, 15)
                .onTapGesture {
                    imageSelected = true
                }
            VStack(alignment: .leading, spacing: 0) {
                Text(viewModel.recipe.name)
                    .font(.headline)
                Text(viewModel.recipe.cuisine)
                    .font(.subheadline)
            }
        }
        .contentShape(Rectangle())
        .onTapGesture {
            itemSelected = true
        }
        .swipeActions(allowsFullSwipe: false) {
            viewOption(iconName: "video.fill", title: "Youtube", urlString: viewModel.recipe.youtubeUrl)
            viewOption(iconName: "globe", title: "Web", urlString: viewModel.recipe.sourceUrl)
        }
        .fullScreenCover(isPresented: $imageSelected, content: {
            ZStack {
                Color.white
                imageView(urlString: viewModel.recipe.photoUrlLarge)
                    .frame(maxWidth: .infinity)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .onTapGesture {
                imageSelected.toggle()
            }
        })
        .sheet(isPresented: $itemSelected, content: {
            VStack(spacing: 10) {
                Text("How would you like to view \(viewModel.recipe.name)")
                    .font(.headline)
                    .padding()
                HStack(spacing: 10) {
                    viewOption(iconName: "video.fill",
                               title: "Youtube",
                               urlString: viewModel.recipe.youtubeUrl)
                    viewOption(iconName: "globe",
                               title: "Web",
                               urlString: viewModel.recipe.sourceUrl)
                }
            }
            .presentationDetents([.height(200)])
        })
    }
    
    @ViewBuilder
    func viewOption(iconName: String, title: String, urlString: String?) -> some View {
        if let url = URL(string: urlString ?? "") {
            Button(action: {
                UIApplication.shared.open(url)
            }, label: {
                swipeView(imageName: iconName, title: title, url: url)
                    .padding()
            })
        }
    }
    
    @ViewBuilder
    func swipeView(imageName: String, title: String, url: URL) -> some View {
        VStack(spacing: 0) {
            Image(systemName: imageName)
                .imageScale(.medium)
            Text(title)
        }
    }
    
    @MainActor @ViewBuilder
    func imageView(urlString: String?) -> some View {
        if let urlString {
            if let image = viewModel.cachedImage(urlString: urlString) {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
            } else if let url = URL(string: urlString) {
                AsyncImage(url: url) { image in
                    image
                        .resizable()
                        .scaledToFit()
                        .task {
                            viewModel.save(image, url: url)
                        }
                } placeholder: {
                    ProgressView()
                }
            }
        } else {
            Rectangle()
                .fill(.secondary)
                .frame(width: 100, height: 100)
                .overlay(content: {
                    Image(systemName: "fork.knife")
                        .foregroundStyle(.primary)
                })
            
        }
    }
}

struct WebView: UIViewRepresentable {
    let url: URL
    
    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        let request = URLRequest(url: url)
        webView.load(request)
        return webView
    }
    
    func updateUIView(_ webView: WKWebView, context: Context) {}
}

#Preview {
    RecipeListItemView(viewModel: RecipeListItemViewModel(recipe: Recipe(uuid: "UUID", name: "Name", cuisine: "Cuisine", photoUrlSmall: nil, photoUrlLarge: nil, sourceUrl: nil, youtubeUrl: nil)))
}
