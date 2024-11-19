import SwiftUI

struct FavoritesView: View {
    @ObservedObject var favoritesManager: FavoritesManager
    @ObservedObject var cartManager: CartManager
    @State private var selectedProduct: FavoriteProduct?  // Track selected product for overlay

    let columns = [
        GridItem(.flexible(), spacing: 15),
        GridItem(.flexible(), spacing: 15)
    ]

    var body: some View {
        ZStack {
            // Main content with favorites grid
            VStack {
                // Title header
                Text("My Favorites")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.top, 20)
                
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
            }
            .navigationTitle("Favorites")
            
            // Full-screen overlay for selected card detail view
            if let selectedProduct = selectedProduct {
                Color.black.opacity(0.4)
                    .ignoresSafeArea()  // Dimmed background for overlay

                VStack {
                    // Add a back arrow or "X" in the top-left corner
                    HStack {
                        Button(action: {
                            self.selectedProduct = nil  // Dismiss overlay
                        }) {
                            Image(systemName: "arrow.left") // Simplistic back arrow
                                .font(.title2)
                                .foregroundColor(.black)
                                .padding()
                        }
                        .padding(.leading, 20)
                        .padding(.top, 40)
                        
                        Spacer()
                    }
                    
                    Spacer()
                    
                    // Display the item image
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

                    // Add a descriptive overlay below the image
                    VStack(spacing: 8) {
                        Text(selectedProduct.details["Brand"] as? String ?? "Unknown Brand")
                            .font(.headline)
                            .foregroundColor(.black)

                        Text(selectedProduct.name)
                            .font(.title2)
                            .fontWeight(.medium)
                            .foregroundColor(.black)

                        if let price = selectedProduct.details["Price"] as? Double {
                            Text(String(format: "$%.2f", price))
                                .font(.title3)
                                .fontWeight(.bold)
                                .foregroundColor(.green)
                        }
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 20)

                    Spacer()

                    // Icons for actions
                    HStack(spacing: 50) {
                        Button(action: {
                            // Add to Cart functionality
                            cartManager.addToCart(product: selectedProduct)  // Add to Cart
                            favoritesManager.removeProduct(byID: selectedProduct.id)  // Remove from Favorites
                            self.selectedProduct = nil  // Dismiss overlay
                        }) {
                            Image(systemName: "cart")
                                .font(.system(size: 30, weight: .regular))
                                .foregroundColor(.black)
                        }

                        Button(action: {
                            // Remove from favorites
                            favoritesManager.removeProduct(byID: selectedProduct.id)
                            self.selectedProduct = nil  // Dismiss overlay
                        }) {
                            Image(systemName: "trash")
                                .font(.system(size: 30, weight: .regular))
                                .foregroundColor(.black)
                        }
                    }
                    .padding(.bottom, 40)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.white)
                .cornerRadius(20)
                .padding()
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
