import UIKit

class SwipeableCard: UIView {
    let imageContainerView: UIView = {
        let container = UIView()
        container.backgroundColor = .white
        container.layer.cornerRadius = 10
        container.layer.masksToBounds = true
        return container
    }()
    
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    let brandLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        label.numberOfLines = 1
        return label
    }()

    let productNameLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        label.numberOfLines = 0
        return label
    }()
    
    let backView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 10
        view.isHidden = true
        return view
    }()
    
    let brandInfoLabel = UILabel()
    let descriptionLabel = UILabel()
    let genderLabel = UILabel()
    let priceLabel = UILabel()
    let categoryLabel = UILabel()
    let sizesLabel = UILabel()
    
    var isFlipped = false
    var isMinimized = false  // To track minimized state

    // Initialize SwipeableCard with minimized option
    init(frame: CGRect = .zero, isMinimized: Bool = false) {
        self.isMinimized = isMinimized
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
        
        // Image container and image
        addSubview(imageContainerView)
        imageContainerView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageContainerView.topAnchor.constraint(equalTo: self.topAnchor),
            imageContainerView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            imageContainerView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            imageContainerView.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        ])
        
        imageContainerView.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: imageContainerView.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: imageContainerView.bottomAnchor),
            imageView.leadingAnchor.constraint(equalTo: imageContainerView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: imageContainerView.trailingAnchor)
        ])
        
        // Add gradient overlay for cleaner look
        addGradientOverlay()

        // Add productNameLabel
        addSubview(productNameLabel)
        productNameLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            productNameLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -20),
            productNameLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            productNameLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20)
        ])

        // Add brandLabel
        addSubview(brandLabel)
        brandLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            brandLabel.bottomAnchor.constraint(equalTo: productNameLabel.topAnchor, constant: -5),
            brandLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            brandLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20)
        ])

        // Add backView
        addSubview(backView)
        backView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            backView.topAnchor.constraint(equalTo: self.topAnchor),
            backView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            backView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            backView.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        ])
        
        setupBackViewLabels()
    }
    
    private func setupBackViewLabels() {
        guard !isMinimized else { return }  // Hide back view labels for minimized view
        let labels = [brandInfoLabel, descriptionLabel, genderLabel, priceLabel, categoryLabel, sizesLabel]
        
        for label in labels {
            label.numberOfLines = 0
            label.textAlignment = .left
            label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
            backView.addSubview(label)
            label.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            brandInfoLabel.topAnchor.constraint(equalTo: backView.topAnchor, constant: 20),
            brandInfoLabel.leadingAnchor.constraint(equalTo: backView.leadingAnchor, constant: 20),
            brandInfoLabel.trailingAnchor.constraint(equalTo: backView.trailingAnchor, constant: -20),
            
            descriptionLabel.topAnchor.constraint(equalTo: brandInfoLabel.bottomAnchor, constant: 10),
            descriptionLabel.leadingAnchor.constraint(equalTo: backView.leadingAnchor, constant: 20),
            descriptionLabel.trailingAnchor.constraint(equalTo: backView.trailingAnchor, constant: -20),
            
            genderLabel.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 10),
            genderLabel.leadingAnchor.constraint(equalTo: backView.leadingAnchor, constant: 20),
            genderLabel.trailingAnchor.constraint(equalTo: backView.trailingAnchor, constant: -20),
            
            priceLabel.topAnchor.constraint(equalTo: genderLabel.bottomAnchor, constant: 10),
            priceLabel.leadingAnchor.constraint(equalTo: backView.leadingAnchor, constant: 20),
            priceLabel.trailingAnchor.constraint(equalTo: backView.trailingAnchor, constant: -20),
            
            categoryLabel.topAnchor.constraint(equalTo: priceLabel.bottomAnchor, constant: 10),
            categoryLabel.leadingAnchor.constraint(equalTo: backView.leadingAnchor, constant: 20),
            categoryLabel.trailingAnchor.constraint(equalTo: backView.trailingAnchor, constant: -20),
            
            sizesLabel.topAnchor.constraint(equalTo: categoryLabel.bottomAnchor, constant: 10),
            sizesLabel.leadingAnchor.constraint(equalTo: backView.leadingAnchor, constant: 20),
            sizesLabel.trailingAnchor.constraint(equalTo: backView.trailingAnchor, constant: -20)
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
        let fromView = isFlipped ? backView : imageContainerView
        let toView = isFlipped ? imageContainerView : backView

        UIView.transition(from: fromView, to: toView, duration: 0.5, options: [.transitionFlipFromRight, .showHideTransitionViews]) { _ in
            self.isFlipped.toggle()
        }
    }

    func updateCard(with product: [String: Any], name: String) {
        let brand = product["Brand"] as? String ?? "Unknown Brand"
        let description = product["Description"] as? String ?? "No description available"
        let gender = product["Gender"] as? String ?? "Unisex"
        let price = product["Price"] as? Int ?? 0
        let category = product["Product Category"] as? String ?? "Unknown Category"
        let sizes = product["Sizes"] as? String ?? "Sizes not available"
        let imageURLString = product["Clothing AWS URL"] as? String

        DispatchQueue.main.async {
            self.productNameLabel.text = name
            self.brandLabel.text = brand
            
            if !self.isMinimized {
                self.brandInfoLabel.text = "Brand: \(brand)"
                self.descriptionLabel.text = "Description: \(description)"
                self.genderLabel.text = "Gender: \(gender)"
                self.priceLabel.text = "Price: \(price)"
                self.categoryLabel.text = "Category: \(category)"
                self.sizesLabel.text = "Available Sizes: \(sizes)"
                self.sizesLabel.text = "Available Sizes: \(sizes)"
            }
        }

        if let imageURLString = imageURLString, let imageURL = URL(string: imageURLString) {
            URLSession.shared.dataTask(with: imageURL) { data, response, error in
                if let data = data, error == nil, let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self.imageView.image = image
                    }
                } else {
                    print("Failed to load image: \(error?.localizedDescription ?? "Unknown error")")
                }
            }.resume()
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
    
    private func addGradientOverlay() {
        let gradient = CAGradientLayer()
        gradient.colors = [UIColor.clear.cgColor, UIColor.black.withAlphaComponent(0.7).cgColor]
        gradient.locations = [0.0, 1.0]
        gradient.frame = self.bounds
        imageView.layer.addSublayer(gradient)
    }
}

enum SwipeDirection {
    case left
    case right
}
