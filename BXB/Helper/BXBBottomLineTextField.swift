//
//  BXBBottomLineTextField.swift
//  BXB
//
//  Created by equalriver on 2018/7/4.
//  Copyright © 2018年 tobosoft. All rights reserved.
//

import UIKit

class BXBBottomLineTextField: UITextField {

    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        if let context = UIGraphicsGetCurrentContext() {
            context.setFillColor(UIColor.white.cgColor)
            context.fill(CGRect.init(x: 0, y: self.height - 0.5, width: self.width, height: 0.5))
        }
    }
 

}
