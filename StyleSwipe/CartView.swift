//
//  CartView.swift
//  StyleSwipe
//
//  Created by Rylan Wade on 11/3/24.
//

import SwiftUI

struct CartView: View {
    @ObservedObject var cartManager: CartManager
    @ObservedObject var orderManager: OrderManager  // New manager for orders
    @State private var showCheckoutModal = false
    @State private var creditCard = ""
    @State private var address = ""

    var body: some View {
        VStack {
            // Title
            Text("My Cart")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding()

            // List of cart items with swipe-to-delete
            if cartManager.cartProducts.isEmpty {
                Text("Your cart is empty.")
                    .font(.headline)
                    .foregroundColor(.gray)
                    .padding()
            } else {
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
                    .onDelete(perform: removeItems)
                }
                .listStyle(InsetGroupedListStyle())
            }

            // Total Price and Checkout Button
            HStack {
                Text("Total: \(String(format: "$%.2f", cartManager.totalPrice()))")
                    .font(.title2)
                    .fontWeight(.bold)
                    .padding(.leading)

                Spacer()

                Button(action: {
                    self.showCheckoutModal = true
                }) {
                    Text("Checkout")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(width: 150)
                        .background(cartManager.cartProducts.isEmpty ? Color.gray : Color.blue)
                        .cornerRadius(10)
                }
                .disabled(cartManager.cartProducts.isEmpty) // Disable if cart is empty
                .padding(.trailing)
            }
            .padding()
        }
        .sheet(isPresented: $showCheckoutModal) {
            CheckoutView(
                cartManager: cartManager,
                orderManager: orderManager,
                creditCard: $creditCard,
                address: $address,
                showCheckoutModal: $showCheckoutModal
            )
        }
    }

    private func removeItems(at offsets: IndexSet) {
        for index in offsets {
            let product = cartManager.cartProducts[index]
            cartManager.removeFromCart(byID: product.id)
        }
    }

    private func loadImage(from urlString: String) -> UIImage? {
        guard let url = URL(string: urlString), let data = try? Data(contentsOf: url) else { return nil }
        return UIImage(data: data)
    }
}
