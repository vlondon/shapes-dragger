//
//  ViewController.swift
//  grtest
//
//  Created by Vladimirs Matusevics on 22/06/2016.
//  Copyright © 2016 vmatusevic. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var blackHoleView: HoleView!
    
    private lazy var animator: UIDynamicAnimator = self.initAnimator()
    private var dragAttachmentBehavior: UIAttachmentBehavior? = nil
    private var dragStartingPoint = CGPoint.zero
    
    private var squareViews = [SquareView]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for _ in 1...3 {
            addSquareToView()
        }
    }
    
    private func addSquareToView() {
        // Random square size
        
        let squareSize = 40 + Double(arc4random_uniform(UInt32(20)))
        let squareView = SquareView(size: squareSize)
        
        // Random square position
        
        let minX = self.view.bounds.minX + 50.0
        let maxX = self.view.bounds.maxX - 50.0
        let xRange = maxX - minX
        let x = minX + CGFloat(arc4random_uniform(UInt32(xRange)))
        
        let minY = self.view.bounds.minY + 50.0
        let maxY = self.view.bounds.midY
        let yRange = maxY - minY
        let y = minY + CGFloat(arc4random_uniform(UInt32(yRange)))
        
        squareView.center = CGPoint(x: x, y: y)
        
        // Pan Gesture handler
        
        let dragRecognizer = UIPanGestureRecognizer(target: self, action: #selector(self.tokenDidPan(panRecognizer:)))
        squareView.addGestureRecognizer(dragRecognizer)
        
        squareViews.append(squareView)
        self.view.addSubview(squareView)
    }
    
    private func initAnimator() -> UIDynamicAnimator {
        let animator = UIDynamicAnimator(referenceView: self.view)
        return animator
    }
    
    func tokenDidPan(panRecognizer: UIPanGestureRecognizer) {
        if panRecognizer.state == .began {
            if let viewToDrag = panRecognizer.view as? SquareView {
                self.dragStartingPoint = viewToDrag.center
                self.dragAttachmentBehavior = UIAttachmentBehavior(item: viewToDrag, attachedToAnchor: viewToDrag.center)
                self.animator.addBehavior(self.dragAttachmentBehavior!)
            }
        } else if panRecognizer.state == .ended {
            if let viewBeingDragged = panRecognizer.view as? SquareView {
                if self.intersection(for: viewBeingDragged) {
                    // overlapping
                    suckSqare(viewBeingDragged, delay: 0)
                }
                
                self.dragStartingPoint = .zero
                self.animator.removeBehavior(self.dragAttachmentBehavior!)
                self.dragAttachmentBehavior = nil
            }
        } else if panRecognizer.state == .changed {
            let translation = panRecognizer.translation(in: self.view)
            let newPoint = CGPoint(x: self.dragStartingPoint.x + translation.x, y: self.dragStartingPoint.y + translation.y)
            if let dragAttachmentBehavior = self.dragAttachmentBehavior {
                dragAttachmentBehavior.anchorPoint = newPoint
            }
            
            if let viewDragging = panRecognizer.view as? SquareView {
                blackHoleView.active = self.intersection(for: viewDragging)
            }
        }
    }
    
    func suckSqare(_ squareView: SquareView, delay: Double) {
        squareView.gestureRecognizers?.forEach(squareView.removeGestureRecognizer)
        UIView.animate(withDuration: 0.3, delay: 0.02 * delay, options: [.curveEaseIn], animations: {
            squareView.frame = CGRect(x: self.blackHoleView.center.x, y: self.blackHoleView.center.y, width: 0, height: 0)
            squareView.transform = squareView.transform.rotated(by: CGFloat(Double.pi))
        }, completion: { (_) in
            if let index = self.squareViews.index(of: squareView) {
                self.squareViews.remove(at: index)
            }
            squareView.removeFromSuperview()
            self.blackHoleView.active = false
        })
    }
    
    // MARK: Calculate intersection
    
    func distanceBetweenTwoPoints(_ p1: CGPoint, _ p2: CGPoint) -> CGFloat {
        let dx = p2.x - p1.x
        let dy = p2.y - p1.y
        return sqrt(dx * dx + dy * dy)
    }
    
    private func intersection(for squareView: SquareView) -> Bool {
        let squareCenter = CGPoint(
            x: squareView.frame.origin.x + squareView.bounds.size.width / 2.0,
            y: squareView.frame.origin.y + squareView.bounds.size.width / 2.0
        )
        
        let distance = distanceBetweenTwoPoints(blackHoleView.circleCenter, squareCenter)
        if(distance < blackHoleView.circleRadius){
            //inside the circle
            return true
        }
        
        return false
    }
    
    // MARK: Actions
    
    @IBAction func blackHoleAction(_ sender: UIButton) {
        // Suck all squares in to the black hole
        var i = 0
        for squareView in squareViews {
            suckSqare(squareView, delay: Double(i))
            i += 1
        }
    }
    
    @IBAction func addSquareAction(_ sender: UIButton) {
        // Add new random Square to the View
        addSquareToView()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

