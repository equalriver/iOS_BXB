//
//  LoginValidate.swift
//  BXB
//
//  Created by equalriver on 2018/7/5.
//  Copyright © 2018年 tobosoft. All rights reserved.
//

import Foundation


public func loginValidate(currentVC: UIViewController, isLogin: (_ isLogin: Bool) -> Void) {
    
    switch YYReachability.init().status {
    case .none:
        SVProgressHUD.showInfo(withStatus: "咦～竟然没有检测到网络")
        return
    default:
        break
    }
    guard UserDefaults.standard.string(forKey: "token") != nil else {
        
        let vc = BXBNavigationController.init(rootViewController: BXBLoginVC())
        currentVC.present(vc, animated: true, completion: nil)
        isLogin(false)
        return
    }
    isLogin(true)

}
