//
//  SwipeableCard.swift
//  StyleSwipe
//
//  Created by Ayush Krishnappa on 10/2/24.
//

import UIKit

class SwipeableCard: UIView {

    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 10
        return imageView
    }()
    
    // Back view for displaying item information
    let backView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 10
        view.isHidden = true  // Start with the back view hidden
        return view
    }()
    
    let infoLabel: UILabel = {
        let label = UILabel()
        label.text = "Item Info"
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    var isFlipped = false  // Track the current state of the card (flipped or not)

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupTapGesture()  // Set up tap gesture to flip the card
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

    // Add tap gesture recognizer for flipping the card
    private func setupTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleCardTap))
        self.addGestureRecognizer(tapGesture)
    }

    @objc private func handleCardTap() {
        flipCard()
    }

    // Flip the card between front and back
    private func flipCard() {
        let fromView = isFlipped ? backView : imageView
        let toView = isFlipped ? imageView : backView

        // Animate the flip
        UIView.transition(from: fromView, to: toView, duration: 0.5, options: [.transitionFlipFromRight, .showHideTransitionViews]) { _ in
            self.isFlipped.toggle()  // Toggle the flipped state
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
        print("Swiping off screen to the \(direction == .left ? "left" : "right")")

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
            print("Card removed from view")
            self.removeFromSuperview()
        })
    }
}

enum SwipeDirection {
    case left
    case right
}

