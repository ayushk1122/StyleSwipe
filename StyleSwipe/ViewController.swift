import UIKit
import FirebaseDatabase

class ViewController: UIViewController {
    var cardStack: [SwipeableCard] = []
    var products = [(name: String, details: [String: Any])]()  // Array to store product name and details as tuples
    var currentIndex = 0  // Track the index of the current product
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        loadProducts()  // Load products from Firebase
    }
    
    // Load products from Firebase
    private func loadProducts() {
        let ref = Database.database().reference()
        ref.child("products").observeSingleEvent(of: .value) { snapshot in
            if let productDict = snapshot.value as? [String: [String: Any]] {
                // Convert dictionary to an array of (name, details) tuples
                self.products = productDict.map { (key, value) in (name: key, details: value) }
                self.addNewCard()  // Display the first product
            }
        }
    }
    
    // Function to create and add a new card to the stack
    func addNewCard() {
        let card = SwipeableCard(frame: CGRect(x: 40, y: -10, width: self.view.frame.width - 80, height: 450))
        
        // If there are more products, display the next one
        if currentIndex < products.count {
            let product = products[currentIndex]
            card.updateCard(with: product.details, name: product.name)  // Pass details and name
            currentIndex += 1  // Move to the next product for subsequent cards
        } else {
            print("No more products to display")
        }
        
        self.view.addSubview(card)
        self.view.bringSubviewToFront(card)
        cardStack.append(card)
        
        print("New card added. Total cards in stack: \(cardStack.count)")
    }
    
    // Swipe Right Action (for Like/Heart button)
    func swipeRight() {
        guard let topCard = cardStack.last else { return }
        topCard.swipeOffScreen(direction: .right)
        cardStack.removeLast()
        addNewCard()  // Add a new card to replace the swiped card
    }
    
    // Swipe Left Action (for Dislike/X button)
    func swipeLeft() {
        guard let topCard = cardStack.last else { return }
        topCard.swipeOffScreen(direction: .left)
        cardStack.removeLast()
        addNewCard()  // Add a new card to replace the swiped card
    }
}
