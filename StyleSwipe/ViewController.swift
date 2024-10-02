import UIKit

class ViewController: UIViewController {

    var cardStack: [SwipeableCard] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white

        
        // sample card
        let card = SwipeableCard(frame: CGRect(x: 23.5, y: -10, width: self.view.frame.width - 80, height: 450))
        card.imageView.image = UIImage(named: "test_clothing_image")
        self.view.addSubview(card)
        cardStack.append(card)
        
    }
    
    // Function to create and add a new card to the stack
    func addNewCard() {
        let card = SwipeableCard(frame: CGRect(x: 40, y: -10, width: self.view.frame.width - 80, height: 450))
        card.backgroundColor = UIColor(
            red: CGFloat.random(in: 0.6...1.0),
            green: CGFloat.random(in: 0.6...1.0),
            blue: CGFloat.random(in: 0.6...1.0),
            alpha: 1.0
        ) // Randomize the background color for each card (will switch to actual images later)
        
        // Add the card to the view and stack
        self.view.addSubview(card)
        self.view.bringSubviewToFront(card)
        cardStack.append(card)
        
        print("New card added. Total cards in stack: \(cardStack.count)")
    }

    // Swipe Right Action (for Like/Heart button)
    func swipeRight() {
        print("Attempting to swipe right")
        guard let topCard = cardStack.last else {
            print("No card to swipe right!")
            return
        }
        print("Swiping right on card: \(topCard)")
        topCard.swipeOffScreen(direction: .right)
        cardStack.removeLast()
        addNewCard()
    }

    // Swipe Left Action (for Dislike/X button)
    func swipeLeft() {
        print("Attempting to swipe left")
        guard let topCard = cardStack.last else {
            print("No card to swipe left!")
            return
        }
        print("Swiping left on card: \(topCard)")
        topCard.swipeOffScreen(direction: .left)
        cardStack.removeLast()
        addNewCard()
    }
}


