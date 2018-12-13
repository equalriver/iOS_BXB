//
//  BXBUserGuideDetailVC.swift
//  BXB
//
//  Created by equalriver on 2018/10/31.
//  Copyright © 2018年 tobosoft. All rights reserved.
//

import UIKit
import WebKit

class BXBUserGuideDetailVC: BXBBaseNavigationVC {

    lazy var webView: WKWebView = {
        let wv = WKWebView.init()
        wv.backgroundColor = UIColor.white
        return wv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(webView)
        webView.snp.makeConstraints { (make) in
            make.top.equalTo(naviBar.snp.bottom)
            make.bottom.width.centerX.equalToSuperview()
        }
        
        if let url = URL.init(string: "") {
            let req = URLRequest.init(url: url)
            webView.load(req)
        }
    }
    

}
