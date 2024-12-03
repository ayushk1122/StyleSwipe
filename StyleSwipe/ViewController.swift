import UIKit
import FirebaseDatabase

class ViewController: UIViewController {
    var cardStack: [SwipeableCard] = [] // Stack of swipeable cards
    var products = [(name: String, details: [String: Any])]() // All products from Firebase
    var filteredProducts = [(name: String, details: [String: Any])]() // Filtered products based on preferences
    var currentIndex = 0 // Tracks the current product index
    var favoritesManager: FavoritesManager // Reference to FavoritesManager

    // Initializer
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
        loadProducts() // Load products from Firebase
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        print("Home page opened. Rerunning filtering...")
        currentIndex = 0 // Reset the card stack index
        filterProducts() // Reapply filtering based on preferences
        reloadCardStack() // Reload the stack with filtered products
    }

    // Load products from Firebase
    private func loadProducts() {
        let ref = Database.database().reference()
        ref.child("products").observeSingleEvent(of: .value) { snapshot in
            if let productDict = snapshot.value as? [String: [String: Any]] {
                self.products = productDict.map { (key, value) in (name: key, details: value) }
                print("Fetched Products Details:", self.products.map { $0.details }) // Debugging output
                self.filterProducts() // Apply filtering after fetching
                self.addNewCard() // Add the first card
            } else {
                print("No products found in Firebase.")
            }
        }
    }

    // Filter products based on user preferences
    private func filterProducts() {
        let preferences = UserDefaults.standard.dictionary(forKey: "userPreferences") ?? [:]
        print("Loaded preferences:", preferences)

        let selectedSizes = preferences["sizes"] as? [String] ?? (preferences["sizes"] as? NSArray)?.compactMap { $0 as? String } ?? []
        let selectedClothingTypes = preferences["clothingTypes"] as? [String] ?? (preferences["clothingTypes"] as? NSArray)?.compactMap { $0 as? String } ?? []
        let selectedGenderOptions = preferences["gender"] as? [String] ?? (preferences["gender"] as? NSArray)?.compactMap { $0 as? String } ?? []
        let maxPrice = preferences["price"] as? Int ?? Int.max

        print("Filtering with Sizes: \(selectedSizes), Types: \(selectedClothingTypes), Gender: \(selectedGenderOptions), Max Price: \(maxPrice)")

        self.filteredProducts = products.filter { product in
            let details = product.details
            let sizeString = details["Sizes"] as? String ?? ""
            let availableSizes = sizeString.split(separator: ",").map { $0.trimmingCharacters(in: .whitespaces) }
            let type = details["Product Category"] as? String ?? "Unknown"
            let gender = details["Gender"] as? String ?? "Unisex"
            let price = details["Price"] as? Int ?? Int.max

            // Normalize gender for comparison
            let normalizedGender = gender.lowercased()
            let normalizedSelectedGenders = selectedGenderOptions.map { $0.lowercased() }
            let genderMatches = normalizedSelectedGenders.isEmpty ||
                (normalizedGender == "unisex" || normalizedSelectedGenders.contains(normalizedGender) ||
                 (normalizedGender == "men" && normalizedSelectedGenders.contains("male")) ||
                 (normalizedGender == "women" && normalizedSelectedGenders.contains("female")))

            // Check if any preferred size matches the available sizes
            let matchesSize = selectedSizes.isEmpty || !availableSizes.isEmpty && selectedSizes.contains { availableSizes.contains($0) }
            let matchesType = selectedClothingTypes.isEmpty || selectedClothingTypes.contains(type)
            let matchesPrice = price <= maxPrice

            print("Product: \(product.name), Sizes: \(availableSizes), Type: \(type), Gender: \(gender), Price: \(price), Matches: \(matchesSize && matchesType && genderMatches && matchesPrice)")

            return matchesSize && matchesType && genderMatches && matchesPrice
        }

        print("Filtered Products: \(filteredProducts.map { $0.name })")
    }



    // Reload the card stack with filtered products
    private func reloadCardStack() {
        if filteredProducts.isEmpty {
            print("No products match the current preferences.")
            return
        }

        // Remove all existing cards
        cardStack.forEach { $0.removeFromSuperview() }
        cardStack.removeAll()

        // Add new cards based on the updated filteredProducts
        addNewCard()
    }

    // Add a new card to the stack
    func addNewCard() {
        guard currentIndex < filteredProducts.count else {
            print("No more products to display")
            return
        }

        let card = SwipeableCard(frame: CGRect(x: 40, y: -10, width: self.view.frame.width - 80, height: 450))
        let product = filteredProducts[currentIndex]
        card.updateCard(with: product.details, name: product.name)
        currentIndex += 1

        self.view.addSubview(card)
        self.view.bringSubviewToFront(card)
        cardStack.append(card)
    }

    // Handle swipe right
    func swipeRight() {
        guard let topCard = cardStack.last else { return }
        topCard.swipeOffScreen(direction: .right)
        cardStack.removeLast()
        
        // Add product to favorites when swiped right
        if currentIndex > 0 {
            let favoritedProduct = filteredProducts[currentIndex - 1]
            favoritesManager.addFavorite(product: favoritedProduct)
        }
        
        addNewCard()
    }

    // Handle swipe left
    func swipeLeft() {
        guard let topCard = cardStack.last else { return }
        topCard.swipeOffScreen(direction: .left)
        cardStack.removeLast()
        addNewCard()
    }
}
