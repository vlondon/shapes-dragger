//
//  SquareView.swift
//  grtest
//
//  Created by Vladimirs Matusevics on 22/06/2016.
//  Copyright © 2016 vmatusevic. All rights reserved.
//

import UIKit

extension UIColor {
    class func random() -> UIColor {
        let red = CGFloat(drand48())
        let green = CGFloat(drand48())
        let blue = CGFloat(drand48())
        return UIColor(red: red, green: green, blue: blue, alpha: 1.0)
    }
}

class SquareView: UIView {
    
    init(size: Double) {
        let frame = CGRect(x: 0.0, y: 0.0, width: size, height: size)
        super.init(frame: frame)
        
        self.commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.commonInit()
    }
    
    func commonInit() {
        self.backgroundColor = UIColor.random()

        let doubleTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.squareTappedTwice(sender:)))
        doubleTapRecognizer.numberOfTapsRequired = 2
        doubleTapRecognizer.numberOfTouchesRequired = 1
        self.addGestureRecognizer(doubleTapRecognizer)
    }
    
    func squareTappedTwice(sender: AnyObject?) {
        self.backgroundColor = UIColor.random()
    }
    
}
