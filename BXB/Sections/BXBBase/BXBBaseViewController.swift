//
//  BXBBaseViewController.swift
//  BXB
//
//  Created by equalriver on 2018/7/5.
//  Copyright © 2018年 tobosoft. All rights reserved.
//

import UIKit
import Toast_Swift

class BXBBaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        //清除角标
        UIApplication.shared.applicationIconBadgeNumber = 0
    }

    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        ToastManager.shared.position = .center
        if SVProgressHUD.isVisible() { SVProgressHUD.dismiss() }
    }

}
