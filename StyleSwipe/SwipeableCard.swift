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
    
    let backView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 10
        view.isHidden = true // Initially hidden, will be shown on card flip
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
        
        // Add front view (image)
        addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: self.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            imageView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        ])
        
        // Add back view (info)
        addSubview(backView)
        backView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            backView.topAnchor.constraint(equalTo: self.topAnchor),
            backView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            backView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            backView.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        ])
        
        // Add label to back view
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
        print("Attempting to fetch data from Realtime Database...")
        
        let ref = Database.database().reference()
        let userRef = ref.child("users").child("user1").child("name")
        
        userRef.observeSingleEvent(of: .value) { [weak self] snapshot in
            guard let self = self else {
                print("Self is nil, exiting fetchCardData")
                return
            }
            
            if let userName = snapshot.value as? String {
                print("User Name: \(userName)")
                DispatchQueue.main.async {
                    self.infoLabel.text = userName
                }
            } else {
                print("User Name field not found in Realtime Database.")
            }
        } withCancel: { error in
            print("Failed to fetch data: \(error.localizedDescription)")
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
