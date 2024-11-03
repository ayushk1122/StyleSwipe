//
//  FavoritesView.swift
//  StyleSwipe
//
//  Created by Rylan Wade on 11/3/24.
//

import SwiftUI

struct FavoritesView: View {
    @ObservedObject var favoritesManager: FavoritesManager
    @State private var selectedProduct: FavoriteProduct?  // Track selected product for overlay

    let columns = [
        GridItem(.flexible(), spacing: 15),
        GridItem(.flexible(), spacing: 15)
    ]

    var body: some View {
        ZStack {
            // Main content with favorites grid
            ScrollView {
                LazyVGrid(columns: columns, spacing: 20) {
                    ForEach(favoritesManager.favoritedProducts) { product in
                        MinimizedCardView(name: product.name, details: product.details)
                            .frame(width: 160, height: 240)
                            .background(Color.white)
                            .cornerRadius(10)
                            .shadow(radius: 5)
                            .onTapGesture {
                                selectedProduct = product  // Set selected product for overlay
                            }
                    }
                }
                .padding()
            }
            .navigationTitle("Favorites")
            
            // Full-screen overlay for selected card detail view
            if let selectedProduct = selectedProduct {
                Color.black.opacity(0.4)
                    .ignoresSafeArea()  // Dimmed background for overlay

                VStack {
                    if let image = loadImage(from: selectedProduct.details["Clothing AWS URL"] as? String) {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFit()
                            .frame(height: 400)
                            .cornerRadius(15)
                            .padding()
                    } else {
                        Rectangle()
                            .fill(Color.gray)
                            .frame(height: 400)
                            .cornerRadius(15)
                            .padding()
                    }

                    Spacer()
                    
                    // Cleaner button styles for actions
                    HStack(spacing: 30) {
                        Button(action: {
                            // Implement add to cart functionality here
                            print("Add to Cart tapped")
                        }) {
                            Label("Add to Cart", systemImage: "cart")
                                .font(.headline)
                                .padding()
                                .frame(width: 140)
                                .background(Color.white)
                                .cornerRadius(12)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(Color.blue, lineWidth: 1)
                                )
                        }
                        
                        Button(action: {
                            // Remove from favorites using unique identifier
                            favoritesManager.removeProduct(byID: selectedProduct.id)
                            self.selectedProduct = nil  // Dismiss overlay
                        }) {
                            Label("Remove", systemImage: "heart.slash")
                                .font(.headline)
                                .padding()
                                .frame(width: 140)
                                .background(Color.white)
                                .cornerRadius(12)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(Color.red, lineWidth: 1)
                                )
                        }
                    }
                    .padding(.bottom, 40)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.white)
                .cornerRadius(20)
                .padding()
                .onTapGesture {
                    self.selectedProduct = nil  // Dismiss overlay on background tap
                }
            }
        }
    }

    // Helper function to load image from URL
    private func loadImage(from urlString: String?) -> UIImage? {
        guard let urlString = urlString, let url = URL(string: urlString),
              let data = try? Data(contentsOf: url) else { return nil }
        return UIImage(data: data)
    }
}






struct MinimizedCardView: View {
    let name: String
    let details: [String: Any]
    
    @State private var image: UIImage? = nil

    var body: some View {
        VStack {
            if let uiImage = image {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 160, height: 200)
                    .clipped()
                    .cornerRadius(10)
            } else {
                Rectangle()
                    .fill(Color.gray)
                    .frame(width: 160, height: 200)
                    .cornerRadius(10)
            }
        }
        .onAppear {
            loadImage()
        }
    }
    
    private func loadImage() {
        if let imageURLString = details["Clothing AWS URL"] as? String,
           let imageURL = URL(string: imageURLString) {
            URLSession.shared.dataTask(with: imageURL) { data, response, error in
                if let data = data, let loadedImage = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self.image = loadedImage
                    }
                } else {
                    print("Failed to load image: \(error?.localizedDescription ?? "Unknown error")")
                }
            }.resume()
        } else {
            print("Invalid or missing image URL")
        }
    }
}
