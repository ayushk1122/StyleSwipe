////
////  CheckoutView.swift
////  StyleSwipe
////
////  Created by Rylan Wade on 11/3/24.
////
//
//import SwiftUI
//
//struct CheckoutView: View {
//    @ObservedObject var cartManager: CartManager
//    @ObservedObject var orderManager: OrderManager
//    @Binding var creditCard: String
//    @Binding var address: String
//    @Binding var showCheckoutModal: Bool
//
//    var body: some View {
//        NavigationView {
//            VStack(alignment: .leading) {
//                TextField("Credit Card Number", text: $creditCard)
//                    .textFieldStyle(RoundedBorderTextFieldStyle())
//                    .padding()
//
//                TextField("Shipping Address", text: $address)
//                    .textFieldStyle(RoundedBorderTextFieldStyle())
//                    .padding()
//
//                Spacer()
//
//                Button(action: {
//                    if !creditCard.isEmpty && !address.isEmpty {
//                        // Create the order
//                        orderManager.createOrder(
//                            from: cartManager.cartProducts,
//                            totalPrice: cartManager.totalPrice()
//                        )
//
//                        // Clear the cart
//                        cartManager.cartProducts.removeAll()
//
//                        // Dismiss modal
//                        showCheckoutModal = false
//                    } else {
//                        print("Credit card and address are required.")
//                    }
//                }) {
//                    Text("Confirm Order")
//                        .font(.headline)
//                        .foregroundColor(.white)
//                        .padding()
//                        .frame(maxWidth: .infinity)
//                        .background(Color.green)
//                        .cornerRadius(10)
//                }
//                .padding()
//
//                Spacer()
//            }
//            .padding()
//            .navigationTitle("Checkout")
//        }
//    }
//}
//
//
//
//  CheckoutView.swift
//  StyleSwipe
//
//  Created by Rylan Wade on 11/3/24.
//

//
//  CheckoutView.swift
//  StyleSwipe
//
//  Created by Rylan Wade on 11/3/24.
//

//
//  CheckoutView.swift
//  StyleSwipe
//
//  Created by Rylan Wade on 11/3/24.
//

import SwiftUI

struct CheckoutView: View {
    @State private var firstName: String = ""
    @State private var lastName: String = ""
    @State private var city: String = ""
    @State private var state: String = ""
    @State private var zipCode: String = ""
    @State private var expirationDate: String = ""
    @State private var cvv: String = ""
    @ObservedObject var cartManager: CartManager
    @ObservedObject var orderManager: OrderManager
    @Binding var creditCard: String
    @Binding var address: String
      @Binding var showCheckoutModal: Bool

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {

                    // Billing Section
                    VStack(alignment: .leading, spacing: 15) {
                        Text("Billing Information")
                            .font(.title2)
                            .fontWeight(.bold)

                        TextField("First Name", text: $firstName).textFieldStyle(RoundedBorderTextFieldStyle())
                            .textFieldStyle(RoundedBorderTextFieldStyle())

                        TextField("Last Name", text: $lastName).textFieldStyle(RoundedBorderTextFieldStyle())
                            .textFieldStyle(RoundedBorderTextFieldStyle())

                        TextField("Address", text: $address)
                            .textFieldStyle(RoundedBorderTextFieldStyle())

                        TextField("City", text: $city).textFieldStyle(RoundedBorderTextFieldStyle())
                            .textFieldStyle(RoundedBorderTextFieldStyle())

                        TextField("State", text: $state).textFieldStyle(RoundedBorderTextFieldStyle())
                            .textFieldStyle(RoundedBorderTextFieldStyle())

                        TextField("ZIP Code", text: $zipCode).textFieldStyle(RoundedBorderTextFieldStyle())
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                    }
                    .padding()
                    .background(Color(UIColor.systemGray6))
                    .cornerRadius(10)
                    .padding(.horizontal)

                    // Payment Section
                    VStack(alignment: .leading, spacing: 15) {
                        Text("Payment Information")
                            .font(.title2)
                            .fontWeight(.bold)

                        TextField("Credit Card Number", text: $creditCard)
                            .textFieldStyle(RoundedBorderTextFieldStyle())

                        HStack {
                            TextField("Expiration Date (MM/YY)", text: $expirationDate).textFieldStyle(RoundedBorderTextFieldStyle())
                                .textFieldStyle(RoundedBorderTextFieldStyle())

                            TextField("CVV", text: $cvv).textFieldStyle(RoundedBorderTextFieldStyle())
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                        }
                    }
                    .padding()
                    .background(Color(UIColor.systemGray6))
                    .cornerRadius(10)
                    .padding(.horizontal)

                    // Confirm Button
                    Button(action: {
                        if !creditCard.isEmpty && !address.isEmpty {
                            // Create the order
                            orderManager.createOrder(
                                from: cartManager.cartProducts,
                                totalPrice: cartManager.totalPrice()
                            )

                            // Clear the cart
                            cartManager.cartProducts.removeAll()

                            // Reset fields
                            creditCard = ""
                            address = ""
                            firstName = ""
                            lastName = ""
                            city = ""
                            state = ""
                            zipCode = ""
                            expirationDate = ""
                            cvv = ""

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
                    .padding(.horizontal)

                }
                .padding(.top)
                .navigationTitle("Checkout")
            }
        }
    }
}

struct CheckoutView_Previews: PreviewProvider {
    static var previews: some View {
        CheckoutView(
            cartManager: CartManager(),
            orderManager: OrderManager(),
            creditCard: .constant(""),
            address: .constant(""),
            showCheckoutModal: .constant(true)
        )
    }
}
