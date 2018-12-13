//
//  BXBNavigationController.swift
//  BXB
//
//  Created by 尹平江 on 2018/6/4.
//  Copyright © 2018年 tobosoft. All rights reserved.
//

import UIKit

class BXBNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationBar.isHidden = true
        
    }
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        
        if children.count != 0 {
            viewController.hidesBottomBarWhenPushed = true
        }
        super.pushViewController(viewController, animated: animated)
    }



}
