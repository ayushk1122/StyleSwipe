import UIKit
import FirebaseDatabase

class SwipeableCard: UIView {
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 10
        return imageView
    }()
    
    let brandLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        label.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        label.layer.cornerRadius = 5
        label.clipsToBounds = true
        return label
    }()
    
    let productNameLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        label.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        label.layer.cornerRadius = 5
        label.clipsToBounds = true
        return label
    }()
    
    let backView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 10
        view.isHidden = true
        return view
    }()
    
    let infoLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        return label
    }()
    
    var isFlipped = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupTapGesture()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
        setupTapGesture()
    }
    
    private func setupView() {
        self.backgroundColor = .white
        self.layer.cornerRadius = 10
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 0.2
        self.layer.shadowOffset = CGSize(width: 0, height: 3)
        self.layer.shadowRadius = 4
        
        addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: self.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            imageView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        ])
        
        addSubview(productNameLabel)
        addSubview(brandLabel)
        
        productNameLabel.translatesAutoresizingMaskIntoConstraints = false
        brandLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            // Position product name label at the top
            productNameLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 10),
            productNameLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            productNameLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
            productNameLabel.heightAnchor.constraint(equalToConstant: 30),
            
            // Position brand label below product name label
            brandLabel.topAnchor.constraint(equalTo: productNameLabel.bottomAnchor, constant: 5),
            brandLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            brandLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
            brandLabel.heightAnchor.constraint(equalToConstant: 25)
        ])
        
        addSubview(backView)
        backView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            backView.topAnchor.constraint(equalTo: self.topAnchor),
            backView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            backView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            backView.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        ])
        
        backView.addSubview(infoLabel)
        infoLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            infoLabel.centerXAnchor.constraint(equalTo: backView.centerXAnchor),
            infoLabel.centerYAnchor.constraint(equalTo: backView.centerYAnchor),
            infoLabel.widthAnchor.constraint(equalTo: backView.widthAnchor, multiplier: 0.8)
        ])
    }

    private func setupTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleCardTap))
        self.addGestureRecognizer(tapGesture)
    }

    @objc private func handleCardTap() {
        flipCard()
    }

    private func flipCard() {
        let fromView = isFlipped ? backView : imageView
        let toView = isFlipped ? imageView : backView

        UIView.transition(from: fromView, to: toView, duration: 0.5, options: [.transitionFlipFromRight, .showHideTransitionViews]) { _ in
            self.isFlipped.toggle()
        }
    }

    // Update card with product information, including product name
    func updateCard(with product: [String: Any], name: String) {
        let brand = product["Brand"] as? String ?? "Unknown Brand"
        let description = product["Description"] as? String ?? "No description available"
        let gender = product["Gender"] as? String ?? "Unisex"
        let price = product["Price"] as? Int ?? 0
        let category = product["Product Category"] as? String ?? "Unknown Category"
        let sizes = product["Sizes"] as? String ?? "Sizes not available"

        // Update the product name and brand labels on the front
        DispatchQueue.main.async {
            self.productNameLabel.text = name
            self.brandLabel.text = brand
        }

        let productInfo = """
        Brand: \(brand)
        Description: \(description)
        Gender: \(gender)
        Price: $\(price)
        Category: \(category)
        Sizes: \(sizes)
        """
        
        // Update the label text on the back view
        DispatchQueue.main.async {
            self.infoLabel.text = productInfo
        }
    }
    
    func swipeOffScreen(direction: SwipeDirection) {
        let offScreenPoint: CGPoint

        if direction == .left {
            offScreenPoint = CGPoint(x: -self.frame.width, y: self.center.y)
        } else {
            offScreenPoint = CGPoint(x: (self.superview?.frame.width ?? 0) + self.frame.width, y: self.center.y)
        }

        UIView.animate(withDuration: 0.5, animations: {
            self.center = offScreenPoint
            self.alpha = 0
        }, completion: { _ in
            self.removeFromSuperview()
        })
    }
}

enum SwipeDirection {
    case left
    case right
}
