//
//  BXBFPSLabel.swift
//  BXB
//
//  Created by equalriver on 2018/9/29.
//  Copyright © 2018年 tobosoft. All rights reserved.
//

import UIKit

class BXBFPSLabel: UILabel {

    lazy var link: CADisplayLink = {
        let l = CADisplayLink.init(target: YYWeakProxy.init(target: self), selector: #selector(tick(sender:)))
        return l
    }()
    
    var count = 0
    
    var lastTime: TimeInterval = 0
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = kColor_background
        self.textAlignment = .center
        self.textColor = kColor_blue
        self.font = kFont_text_3
        link.add(to: RunLoop.main, forMode: RunLoop.Mode.common)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        link.invalidate()
    }
    
    @objc func tick(sender: CADisplayLink) {
        if lastTime == 0 {
            lastTime = sender.timestamp
            return
        }
        count += 1
        let delta = sender.timestamp - lastTime
        if delta < 1 { return }
        lastTime = link.timestamp
        let fps = Float(Double(count) / delta)
        count = 0
        
        let progress = Int(round(fps))
        self.text = "\(progress)"
        
    }
    
}
