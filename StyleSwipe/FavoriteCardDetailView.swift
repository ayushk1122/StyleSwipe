import SwiftUI

struct FavoriteCardDetailView: View {
    let name: String
    let details: [String: Any]
    var onAddToCart: () -> Void
    var onRemoveFromFavorites: () -> Void

    @State private var image: UIImage? = nil

    var body: some View {
        VStack {
            if let uiImage = image {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 300)
                    .clipped()
                    .cornerRadius(10)
                    .padding()
            } else {
                Rectangle()
                    .fill(Color.gray)
                    .frame(height: 300)
                    .cornerRadius(10)
                    .padding()
                Text("Image could not be loaded")
                    .foregroundColor(.gray)
            }

            Text(name)
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(.top)

            Text(details["Description"] as? String ?? "No description available")
                .font(.body)
                .padding()

            Spacer()

            HStack {
                Button(action: onAddToCart) {
                    Text("Add to Cart")
                        .font(.title2)
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(10)
                }
                
                Button(action: onRemoveFromFavorites) {
                    Text("Remove from Favorites")
                        .font(.title2)
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.red)
                        .cornerRadius(10)
                }
            }
            .padding(.bottom, 30)
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
