//
//  CheckoutView.swift
//  StyleSwipe
//
//  Created by Rylan Wade on 11/3/24.
//

import SwiftUI

struct CheckoutView: View {
    @ObservedObject var cartManager: CartManager
    @ObservedObject var orderManager: OrderManager
    @Binding var creditCard: String
    @Binding var address: String
    @Binding var showCheckoutModal: Bool

    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                TextField("Credit Card Number", text: $creditCard)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()

                TextField("Shipping Address", text: $address)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()

                Spacer()

                Button(action: {
                    if !creditCard.isEmpty && !address.isEmpty {
                        // Create the order
                        orderManager.createOrder(
                            from: cartManager.cartProducts,
                            totalPrice: cartManager.totalPrice()
                        )

                        // Clear the cart
                        cartManager.cartProducts.removeAll()

                        // Dismiss modal
                        showCheckoutModal = false
                    } else {
                        print("Credit card and address are required.")
                    }
                }) {
                    Text("Confirm Order")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.green)
                        .cornerRadius(10)
                }
                .padding()

                Spacer()
            }
            .padding()
            .navigationTitle("Checkout")
        }
    }
}
