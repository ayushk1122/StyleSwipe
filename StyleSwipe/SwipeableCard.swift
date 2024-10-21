import UIKit
import FirebaseFirestore

class SwipeableCard: UIView {

    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 10
        return imageView
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
        return label
    }()
    
    var isFlipped = false

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupTapGesture()
        fetchCardData()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
        setupTapGesture()
        fetchCardData()
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

    private func fetchCardData() {
        let db = Firestore.firestore()
        db.collection("clothing").document("N8XgVVP3CuxVTbwYctwp").getDocument { [weak self] (document, error) in
            guard let self = self else { return }
            if let document = document, document.exists {
                let data = document.data()
                
                if let brand = data?["Brand"] as? String {
                    self.infoLabel.text = brand
                }
            } else {
                print("Document does not exist or an error occurred: \(String(describing: error))")
            }
        }
    }
    
    @objc private func handlePanGesture(_ gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: self.superview)
        self.center = CGPoint(x: self.center.x + translation.x, y: self.center.y + translation.y)
        gesture.setTranslation(CGPoint.zero, in: self.superview)

        if gesture.state == .ended {
            if self.center.x < 100 {
                swipeOffScreen(direction: .left)
            } else if self.center.x > (self.superview?.frame.width ?? 0) - 100 {
                swipeOffScreen(direction: .right)
            } else {
                UIView.animate(withDuration: 0.3) {
                    self.center = self.superview!.center
                }
            }
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
