//
//  BXBWorkIntroVC.swift
//  BXB
//
//  Created by equalriver on 2018/9/30.
//  Copyright © 2018年 tobosoft. All rights reserved.
//

import UIKit
import WebKit

enum BXBWorkIntroType {
    case agenda
    case client
    case team
    case notice
}

class BXBWorkIntroVC: BXBBaseNavigationVC {
    
    
    private var handle: (() -> Void)?
    
    lazy var webView: WKWebView = {
        let v = WKWebView.init()
        v.backgroundColor = UIColor.white
        return v
    }()
    lazy var rightBtn: UIButton = {
        let b = UIButton()
        b.titleLabel?.font = kFont_naviBtn_weight
        b.setTitle("跳过", for: .normal)
        b.setTitleColor(kColor_theme, for: .normal)
        return b
    }()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        naviBar.rightBarButtons = [rightBtn]
    }
    
    convenience init(type: BXBWorkIntroType, callback: @escaping () -> Void) {
        self.init()
        view.addSubview(webView)
        webView.snp.makeConstraints { (make) in
            make.width.centerX.bottom.equalToSuperview()
            make.top.equalTo(naviBar.snp.bottom)
        }
        self.handle = callback
        
        guard let agendaPath = Bundle.main.path(forResource: "schedule.html", ofType: nil) else { return }
        guard let clientPath = Bundle.main.path(forResource: "client_management.html", ofType: nil) else { return }
        guard let teamPath = Bundle.main.path(forResource: "team_management.html", ofType: nil) else { return }
        guard let noticePath = Bundle.main.path(forResource: "smart_reminder.html", ofType: nil) else { return }
        
        switch type {
        case .agenda:
            let req = URLRequest.init(url: URL.init(fileURLWithPath: agendaPath))
            webView.load(req)
            break
            
        case .client:
            let req = URLRequest.init(url: URL.init(fileURLWithPath: clientPath))
            webView.load(req)
            break
            
        case .team:
            let req = URLRequest.init(url: URL.init(fileURLWithPath: teamPath))
            webView.load(req)
            break
            
        case .notice:
            let req = URLRequest.init(url: URL.init(fileURLWithPath: noticePath))
            webView.load(req)
            break
            
        }
    }
    
    override func rightButtonsAction(sender: UIButton) {
        if handle != nil {
            handle!()
            navigationController?.popViewController(animated: false)
        }
    }
    

}
