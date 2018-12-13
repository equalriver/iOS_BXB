//
//  BXBUserAgreementVC.swift
//  BXB
//
//  Created by equalriver on 2018/8/30.
//  Copyright © 2018年 tobosoft. All rights reserved.
//

import UIKit
import WebKit

class BXBUserPrivacyVC: BXBBaseNavigationVC {
    
    lazy var webView: WKWebView = {
        let w = WKWebView.init()
        w.backgroundColor = UIColor.white
        return w
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        naviBar.naviBackgroundColor = UIColor.clear
        view.addSubview(webView)
        webView.snp.makeConstraints { (make) in
            make.size.centerX.centerY.equalTo(view)
        }
        if Bundle.main.path(forResource: "privacy.html", ofType: nil) != nil {
            let req = URLRequest.init(url: URL.init(fileURLWithPath: Bundle.main.path(forResource: "privacy.html", ofType: nil)!))
            webView.load(req)
        }
        
    }

}


class BXBUserAgreementVC: BXBBaseNavigationVC {
    
    lazy var webView: WKWebView = {
        let w = WKWebView.init()
        w.backgroundColor = UIColor.white
        return w
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        naviBar.naviBackgroundColor = UIColor.clear
        view.addSubview(webView)
        webView.snp.makeConstraints { (make) in
            make.size.centerX.centerY.equalTo(view)
        }
        if Bundle.main.path(forResource: "user_agreement.html", ofType: nil) != nil {
            let req = URLRequest.init(url: URL.init(fileURLWithPath: Bundle.main.path(forResource: "user_agreement.html", ofType: nil)!))
            webView.load(req)
        }
        
    }
    
}
