//
//  BXBButtonTools.swift
//  BXB
//
//  Created by equalriver on 2018/8/17.
//  Copyright © 2018年 tobosoft. All rights reserved.
//

import Foundation


extension UIButton {
    
    open override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: [], animations: {
            
             self.transform = self.transform.scaledBy(x: 1.1, y: 1.1)
            
        }) { (isFinish) in
            
        }
    }
    
    open override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: [], animations: {
            
            self.transform = CGAffineTransform.identity
            
        }) { (isFinish) in
            
        }
    }
    
    open override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        self.transform = CGAffineTransform.identity
    }
    
}


extension UIButton {
    open override func draw(_ rect: CGRect) {
        super.draw(rect)
        self.adjustsImageWhenHighlighted = false
    }
}
