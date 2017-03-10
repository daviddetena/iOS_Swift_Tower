//
//  ViewController.swift
//  Tower
//
//  Created by David de Tena on 10/03/2017.
//  Copyright © 2017 David de Tena. All rights reserved.
//

import UIKit

enum BoxColor : Int {
    case Blue = 0
    case Green = 1
    case Red = 2
    case Orange = 3
    case Yellow = 4
}

class ViewController: UIViewController, UICollisionBehaviorDelegate {
    
    // MARK: - Properties
    var gravity : UIGravityBehavior!
    var collision : UICollisionBehavior!
    var animator : UIDynamicAnimator!
    
    var boxCounter : Int = 0
    
    // MARK: - View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        gravity = UIGravityBehavior()
        collision = UICollisionBehavior()
        collision.collisionDelegate = self
        animator = UIDynamicAnimator(referenceView: self.view)
        
        // Tap gesture to draw a box with each tap
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(viewTapped))
        self.view.addGestureRecognizer(tapGesture)
        
        // Add behaviors to animator
        animator.addBehavior(gravity)
        animator.addBehavior(collision)
        
        // Adjust to bounds for autolayout
        collision.setTranslatesReferenceBoundsIntoBoundary(with: .zero)
    }
    
    
    // MARK: - Utils
    
    func viewTapped(tapGesture : UITapGestureRecognizer){
        // Take point selected in view with the first touch
        let point = tapGesture.location(ofTouch: 0, in: self.view)
        addBox(x: Int(point.x), y:Int(point.y))
    }
    
    func addBox(x: Int, y: Int){
        boxCounter += 1
        
        let randomColor = self.randomColor()
        let randomSize = self.randomSize()
        
        let view = UIView(frame: CGRect(x: CGFloat(x - randomSize.width/2), y: CGFloat(y), width: CGFloat(randomSize.width), height: CGFloat(randomSize.height)))
        view.tag = boxCounter
        view.backgroundColor = randomColor
        
        self.view.addSubview(view)
        
        // Apply gravity and collision to the box created
        self.gravity.addItem(view)
        self.collision.addItem(view)
    }
    
    
    func randomColor() -> UIColor {
        
        let randomNumber = Int(arc4random_uniform(UInt32(5)))
        let color : BoxColor = BoxColor(rawValue: randomNumber)!
        
        switch color {
        case .Blue:
            return #colorLiteral(red: 0.2039215686, green: 0.5960784314, blue: 0.8588235294, alpha: 1)
        case .Green:
            return #colorLiteral(red: 0.1803921569, green: 0.8, blue: 0.4431372549, alpha: 1)
        case .Red:
            return #colorLiteral(red: 0.9058823529, green: 0.2980392157, blue: 0.2352941176, alpha: 1)
        case .Orange:
            return #colorLiteral(red: 0.9019607843, green: 0.4941176471, blue: 0.1333333333, alpha: 1)
        case .Yellow:
            return #colorLiteral(red: 0.9450980392, green: 0.768627451, blue: 0.05882352941, alpha: 1)
        }
    }
    
    func randomSize() -> (width: Int, height: Int){
        // Min height/width: 30, 30-129
        let height = Int(arc4random_uniform(UInt32(100))) + 30
        let width = Int(arc4random_uniform(UInt32(100))) + 30
        
        return (width, height)
    }
    
    // MARK: - UICollisionBehaviorDelegate
    
    /// What to do when the item ended contact with a bound, in this case, with screen bounds
    /// Game over (and restart game) when a collision occurs, if not the first
    func collisionBehavior(_ behavior: UICollisionBehavior, endedContactFor item: UIDynamicItem, withBoundaryIdentifier identifier: NSCopying?) {
        if let view = item as? UIView {
            
            if view.tag > 1 {
                let alertVC = UIAlertController(title: "Game Over", message: "You lose!", preferredStyle: .alert)
                let alertAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
                alertVC.addAction(alertAction)
                
                present(alertVC, animated: true, completion: { 
                    for view in self.view.subviews {
                        self.gravity.removeItem(view)
                        self.collision.removeItem(view)
                        view.removeFromSuperview()
                    }
                    self.boxCounter = 0
                })
            }
        }
    }
}

