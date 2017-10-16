//
//  HoleView.swift
//  grtest
//
//  Created by Vladimirs Matusevics on 23/06/2016.
//  Copyright © 2016 vmatusevic. All rights reserved.
//

import UIKit

class HoleView: UIView {

    var circleCenter = CGPoint(x: 0, y: 0)
    var circleRadius: CGFloat = 0
    var active = false {
        willSet {
            if newValue != active {
                if newValue {
                    self.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.1)
                } else {
                    self.backgroundColor = .clear
                }
            }
        }
    }
    
    override func layoutSubviews() {
        self.layer.masksToBounds = true
        self.layer.borderWidth = 2.0
        self.layer.borderColor = UIColor.black.cgColor
        self.layer.cornerRadius = self.bounds.size.width / 2.0
        
        circleRadius = self.bounds.size.width / 2.0
        circleCenter = CGPoint(x: self.frame.origin.x + circleRadius, y: self.frame.origin.y + circleRadius)
        
    }
    
}
