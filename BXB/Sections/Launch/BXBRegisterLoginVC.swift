//
//  BXBRegisterLoginVC.swift
//  BXB
//
//  Created by equalriver on 2018/7/23.
//  Copyright © 2018年 tobosoft. All rights reserved.
//

import UIKit

class BXBRegisterLoginVC: BXBBaseNavigationVC {
    
    
    lazy var titleLabel: UILabel = {
        let l = UILabel()
        l.text = "注册/登录"
        l.textColor = UIColor.white
        l.font = UIFont.systemFont(ofSize: 27 * KScreenRatio_6, weight: .bold)
        l.textAlignment = .center
        return l
    }()
    
    lazy var phoneLoginBtn: UIButton = {
        let b = UIButton()
        b.titleLabel?.font = UIFont.systemFont(ofSize: 18 * KScreenRatio_6)
        b.setTitle("手机注册/登录", for: .normal)
        b.setTitleColor(UIColor.white, for: .normal)
        b.backgroundColor = kColor_theme
        b.layer.cornerRadius = 25 * KScreenRatio_6
        b.layer.masksToBounds = true
        b.addTarget(self, action: #selector(phoneLogin), for: .touchUpInside)
        return b
    }()
    
    lazy var sepView: UIView = {
        let v = UIView()
        v.isHidden = true
        v.backgroundColor = kColor_subText
        return v
    }()
    
    lazy var otherLoginLabel: UILabel = {
        let l = UILabel()
        l.isHidden = true
        l.font = kFont_text_2
        l.textAlignment = .center
        l.textColor = kColor_subText
        l.text = "其他方式登录"
        return l
    }()
    
    lazy var wechatLoginBtn: UIButton = {
        let b = UIButton()
        b.isHidden = true
        b.titleLabel?.font = UIFont.systemFont(ofSize: 18 * KScreenRatio_6)
        b.setTitle("微信注册/登录", for: .normal)
        b.setTitleColor(UIColor.white, for: .normal)
        b.setImage(#imageLiteral(resourceName: "login_微信"), for: .normal)
        b.layer.borderColor = UIColor.white.cgColor
        b.layer.borderWidth = 1
        b.layer.cornerRadius = 25 * KScreenRatio_6
        b.layer.masksToBounds = true
        b.backgroundColor = UIColor.clear
        b.addTarget(self, action: #selector(wechatLogin), for: .touchUpInside)
        return b
    }()

    lazy var backButton: UIButton = {
        let b = UIButton()
        b.setImage(#imageLiteral(resourceName: "bxb_返回_白"), for: .normal)
        b.addBlock(for: .touchUpInside, block: { [unowned self](sender) in
            self.navigationController?.dismiss(animated: true, completion: nil)
        })
        return b
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
        isHiddenNavi = true
        NotificationCenter.default.addObserver(self, selector: #selector(notiLoginComplete), name: .kNotiLoginComplete, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    func initUI() {
        view.backgroundColor = kColor_text
        view.addSubview(titleLabel)
        view.addSubview(phoneLoginBtn)
        view.addSubview(sepView)
        view.addSubview(otherLoginLabel)
        view.addSubview(wechatLoginBtn)
        view.addSubview(backButton)
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(view).offset(120 * KScreenRatio_6)
            make.width.centerX.equalTo(view)
        }
        phoneLoginBtn.snp.makeConstraints { (make) in
            make.size.equalTo(CGSize.init(width: 215 * KScreenRatio_6, height: 50 * KScreenRatio_6))
            make.centerX.equalTo(view)
            make.top.equalTo(titleLabel.snp.bottom).offset(55 * KScreenRatio_6)
        }
        sepView.snp.makeConstraints { (make) in
            make.size.equalTo(CGSize.init(width: 20 * KScreenRatio_6, height: 0.5))
            make.centerX.equalTo(view)
            make.top.equalTo(phoneLoginBtn.snp.bottom).offset(60 * KScreenRatio_6)
        }
        otherLoginLabel.snp.makeConstraints { (make) in
            make.centerX.width.equalTo(view)
            make.top.equalTo(sepView).offset(50 * KScreenRatio_6)
        }
        wechatLoginBtn.snp.makeConstraints { (make) in
            make.size.equalTo(CGSize.init(width: 215 * KScreenRatio_6, height: 50 * KScreenRatio_6))
            make.centerX.equalTo(view)
            make.top.equalTo(otherLoginLabel.snp.bottom).offset(30 * KScreenRatio_6)
        }
        backButton.snp.makeConstraints { (make) in
            make.left.top.equalTo(view).offset(40 * KScreenRatio_6)
        }
    }

    
    //MARK: - noti
    @objc func notiLoginComplete() {
        NotificationCenter.default.post(name: .kNotiAgendaShouldRefreshData, object: nil, userInfo: nil)
        NotificationCenter.default.post(name: .kNotiClientShouldRefreshData, object: nil)
        NotificationCenter.default.post(name: .kNotiRemindShouldRefreshData, object: nil)

        navigationController?.dismiss(animated: true, completion: nil)
    }
    
    //MARK: - action
    @objc func phoneLogin() {
        let vc = BXBPhoneLoginVC()
        vc.titleString = "登录"
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func wechatLogin() {

        view.makeToast("暂未开放")
        return
        /*
        if WXApi.isWXAppInstalled() {
            
            ShareSDK.authorize(.typeWechat, settings: nil) { (state, user, error) in
                guard error == nil else {
                    SVProgressHUD.showInfo(withStatus: "登录失败")
                    return
                }
                if state == SSDKResponseState.success {
                    guard user != nil else { return }

                    NotificationCenter.default.post(name: NSNotification.Name.init(kNotiLoginComplete), object: nil)
                }
            }
//            let req = SendAuthReq.init()
//            req.scope = "snsapi_userinfo"
//            WXApi.send(req)
        }
        else{ SVProgressHUD.showInfo(withStatus: "未安装微信") }
    */
    }
}
