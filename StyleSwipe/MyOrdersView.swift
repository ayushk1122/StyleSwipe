//
//  MyOrdersView.swift
//  StyleSwipe
//
//  Created by Rylan Wade on 11/3/24.
//

import SwiftUI

struct MyOrdersView: View {
    @ObservedObject var orderManager: OrderManager

    var body: some View {
        VStack {
            Text("My Orders")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding()

            List(orderManager.orders) { order in
                VStack(alignment: .leading) {
                    Text("Order ID: \(order.serialID)")
                        .font(.headline)

                    ForEach(order.items) { item in
                        HStack {
                            Text(item.details["Brand"] as? String ?? "Unknown Brand")
                                .font(.subheadline)
                            Spacer()
                            if let price = item.details["Price"] as? Double {
                                Text(String(format: "$%.2f", price))
                                    .font(.subheadline)
                                    .foregroundColor(.green)
                            }
                        }
                    }
                }
                .padding(.vertical)
            }
            .listStyle(InsetGroupedListStyle())
        }
    }
}
