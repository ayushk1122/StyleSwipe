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
    
    let brandInfoLabel = UILabel()
    let descriptionLabel = UILabel()
    let genderLabel = UILabel()
    let priceLabel = UILabel()
    let categoryLabel = UILabel()
    let sizesLabel = UILabel()
    
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
        
        // Image container and image
        addSubview(imageContainerView)
        imageContainerView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageContainerView.topAnchor.constraint(equalTo: self.topAnchor, constant: 20),
            imageContainerView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            imageContainerView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20),
            imageContainerView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -80)
        ])
        
        imageContainerView.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: imageContainerView.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: imageContainerView.bottomAnchor),
            imageView.leadingAnchor.constraint(equalTo: imageContainerView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: imageContainerView.trailingAnchor)
        ])
        
        addSubview(productNameLabel)
        addSubview(brandLabel)
        
        productNameLabel.translatesAutoresizingMaskIntoConstraints = false
        brandLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            productNameLabel.bottomAnchor.constraint(equalTo: brandLabel.topAnchor, constant: -5),
            productNameLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            productNameLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
            productNameLabel.heightAnchor.constraint(equalToConstant: 30),
            
            brandLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10),
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
        
        setupBackViewLabels()
    }
    
    private func setupBackViewLabels() {
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

    // Update card with product information
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
            
            self.brandInfoLabel.text = "Brand: \(brand)"
            self.descriptionLabel.text = "Description: \(description)"
            self.genderLabel.text = "Gender: \(gender)"
            self.priceLabel.text = "Price: $\(price)"
            self.categoryLabel.text = "Category: \(category)"
            self.sizesLabel.text = "Available Sizes: \(sizes)"
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
}

enum SwipeDirection {
    case left
    case right
}
