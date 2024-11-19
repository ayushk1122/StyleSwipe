import SwiftUI

struct CartView: View {
    @ObservedObject var cartManager: CartManager

    var body: some View {
        VStack {
            // Title
            Text("My Cart")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding()

            // List of cart items
            List {
                ForEach(cartManager.cartProducts) { product in
                    HStack {
                        // Item Image
                        if let imageURL = product.details["Clothing AWS URL"] as? String,
                           let image = loadImage(from: imageURL) {
                            Image(uiImage: image)
                                .resizable()
                                .frame(width: 80, height: 80)
                                .cornerRadius(10)
                        } else {
                            Rectangle()
                                .fill(Color.gray)
                                .frame(width: 80, height: 80)
                                .cornerRadius(10)
                        }

                        // Item Details
                        VStack(alignment: .leading) {
                            Text(product.details["Brand"] as? String ?? "Unknown Brand")
                                .font(.headline)
                            Text(product.name)
                                .font(.subheadline)
                            if let price = product.details["Price"] as? Double {
                                Text(String(format: "$%.2f", price))
                                    .font(.subheadline)
                                    .fontWeight(.bold)
                                    .foregroundColor(.green)
                            }
                        }
                    }
                }
            }

            // Total Price and Checkout Button
            HStack {
                Text("Total: \(String(format: "$%.2f", cartManager.totalPrice()))")
                    .font(.title2)
                    .fontWeight(.bold)
                    .padding(.leading)

                Spacer()

                Button(action: {
                    print("Proceed to Checkout")
                }) {
                    Text("Checkout")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(width: 150)
                        .background(Color.blue)
                        .cornerRadius(10)
                }
                .padding(.trailing)
            }
            .padding()
        }
    }

    private func loadImage(from urlString: String) -> UIImage? {
        guard let url = URL(string: urlString), let data = try? Data(contentsOf: url) else { return nil }
        return UIImage(data: data)
    }
}
