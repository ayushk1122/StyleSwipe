
import Foundation

struct Order: Identifiable {
    let id: UUID
    let serialID: String
    let items: [FavoriteProduct]
    let totalPrice: Double
}

class OrderManager: ObservableObject {
    @Published var orders: [Order] = []

    func createOrder(from products: [FavoriteProduct], totalPrice: Double) {
        let serialID = UUID().uuidString.prefix(8)  // Generate a random unique serial ID
        let newOrder = Order(id: UUID(), serialID: String(serialID), items: products, totalPrice: totalPrice)
        orders.append(newOrder)
    }
}
