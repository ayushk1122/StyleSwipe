import UIKit
import FirebaseDatabase

class ViewController: UIViewController {
    var cardStack: [SwipeableCard] = []
    var products = [(name: String, details: [String: Any])]()
    var currentIndex = 0
    var favoritesManager: FavoritesManager  // Reference to FavoritesManager

    init(favoritesManager: FavoritesManager) {
        self.favoritesManager = favoritesManager
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        loadProducts()
    }

    private func loadProducts() {
        let ref = Database.database().reference()
        ref.child("products").observeSingleEvent(of: .value) { snapshot in
            if let productDict = snapshot.value as? [String: [String: Any]] {
                self.products = productDict.map { (key, value) in (name: key, details: value) }
                self.addNewCard()
            }
        }
    }

    func addNewCard() {
        let card = SwipeableCard(frame: CGRect(x: 40, y: -10, width: self.view.frame.width - 80, height: 450))
        if currentIndex < products.count {
            let product = products[currentIndex]
            card.updateCard(with: product.details, name: product.name)
            currentIndex += 1
        } else {
            print("No more products to display")
        }
        self.view.addSubview(card)
        self.view.bringSubviewToFront(card)
        cardStack.append(card)
    }

    func swipeRight() {
        guard let topCard = cardStack.last else { return }
        topCard.swipeOffScreen(direction: .right)
        cardStack.removeLast()
        
        // Add product to favorites when swiped right
        if currentIndex > 0 {
            let favoritedProduct = products[currentIndex - 1]
            favoritesManager.addFavorite(product: favoritedProduct)
        }
        
        addNewCard()
    }

    func swipeLeft() {
        guard let topCard = cardStack.last else { return }
        topCard.swipeOffScreen(direction: .left)
        cardStack.removeLast()
        addNewCard()
    }
}

