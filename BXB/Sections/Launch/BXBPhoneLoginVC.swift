//
//  BXBPhoneLoginVC.swift
//  BXB
//
//  Created by equalriver on 2018/7/23.
//  Copyright © 2018年 tobosoft. All rights reserved.
//

import UIKit
import ObjectMapper

class BXBPhoneLoginVC: BXBBaseNavigationVC {
    
    public var titleString = "" {
        willSet{
            title = newValue
            loginBtn.setTitle(newValue == "登录" ? "登录" : "确认", for: .normal)
        }
    }
    
    lazy var phoneLabel: UILabel = {
        let l = UILabel()
        l.font = UIFont.systemFont(ofSize: 18 * KScreenRatio_6, weight: .semibold)
        l.text = "手机号"
        l.textColor = UIColor.white
        return l
    }()
    
    lazy var phoneTF: BXBBottomLineTextField = {
        let tf = BXBBottomLineTextField()
        tf.font = UIFont.systemFont(ofSize: 30 * KScreenRatio_6, weight: UIFont.Weight.medium)
        tf.textColor = UIColor.white
        tf.keyboardType = .numbersAndPunctuation
        tf.clearButtonMode = .whileEditing
        tf.attributedPlaceholder = NSAttributedString.init(string: "请输入手机号", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16 * KScreenRatio_6), NSAttributedString.Key.foregroundColor: kColor_subText!])
        return tf
    }()
    
    lazy var authCodeLabel: UILabel = {
        let l = UILabel()
        l.font = UIFont.systemFont(ofSize: 18 * KScreenRatio_6, weight: .semibold)
        l.text = "验证码"
        l.textColor = UIColor.white
        return l
    }()
    
    lazy var authCodeTF: UITextField = {
        let tf = UITextField()
        tf.font = UIFont.systemFont(ofSize: 30 * KScreenRatio_6, weight: .medium)
        tf.textColor = UIColor.white
        tf.keyboardType = .numbersAndPunctuation
        tf.attributedPlaceholder = NSAttributedString.init(string: "请输入验证码", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16 * KScreenRatio_6), NSAttributedString.Key.foregroundColor: kColor_subText!])
        return tf
    }()
    
    lazy var sepView: UIView = {
        let v = UIView()
        v.backgroundColor = UIColor.white
        return v
    }()
    
    lazy var getAuthCodeBtn: UIButton = {
        let b = UIButton()
        b.titleLabel?.font = kFont_text_2
        b.setTitle("获取验证码", for: .normal)
        b.setTitleColor(UIColor.white, for: .normal)
        b.backgroundColor = kColor_theme
        b.layer.cornerRadius = 20 * KScreenRatio_6
        b.layer.masksToBounds = true
        b.addTarget(self, action: #selector(getAuthCode(sender:)), for: .touchUpInside)
        return b
    }()

    lazy var loginBtn: UIButton = {
        let b = UIButton()
        b.titleLabel?.font = UIFont.systemFont(ofSize: 18 * KScreenRatio_6)
        b.setTitleColor(UIColor.white, for: .normal)
        b.backgroundColor = kColor_theme
        b.layer.cornerRadius = 25 * KScreenRatio_6
        b.layer.masksToBounds = true
        b.addTarget(self, action: #selector(loginAction(sender:)), for: .touchUpInside)
        return b
    }()
    
    lazy var backButton: UIButton = {
        let b = UIButton()
        b.setImage(#imageLiteral(resourceName: "bxb_返回_白"), for: .normal)
        return b
    }()
    
    lazy var timer: Timer = {
        let t = Timer.init()
        return t
    }()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        phoneTF.becomeFirstResponder()
    }

    deinit {
        timer.invalidate()
    }
    
    func initUI() {
        isNeedBackButton = false
        naviBar.backgroundColor = kColor_text
        naviBar.titleColor = UIColor.white
        naviBar.bottomBlackLineView.isHidden = true
        naviBar.leftBarButtons = [backButton]
        
        view.backgroundColor = kColor_text
        view.addSubview(phoneLabel)
        view.addSubview(phoneTF)
        view.addSubview(authCodeLabel)
        view.addSubview(authCodeTF)
        view.addSubview(sepView)
        view.addSubview(getAuthCodeBtn)
        view.addSubview(loginBtn)
        phoneLabel.snp.makeConstraints { (make) in
            make.left.equalTo(view).offset(40 * KScreenRatio_6)
            make.top.equalTo(naviBar.snp.bottom).offset(30 * KScreenRatio_6)
            make.right.equalTo(view)
        }
        phoneTF.snp.makeConstraints { (make) in
            make.left.equalTo(phoneLabel)
            make.top.equalTo(phoneLabel.snp.bottom).offset(30 * KScreenRatio_6)
            make.size.equalTo(CGSize.init(width: 300 * KScreenRatio_6, height: 40 * KScreenRatio_6))
        }
        authCodeLabel.snp.makeConstraints { (make) in
            make.left.right.equalTo(phoneLabel)
            make.top.equalTo(phoneTF.snp.bottom).offset(30 * KScreenRatio_6)
        }
        authCodeTF.snp.makeConstraints { (make) in
            make.left.equalTo(phoneLabel)
            make.top.equalTo(authCodeLabel.snp.bottom).offset(30 * KScreenRatio_6)
            make.size.equalTo(CGSize.init(width: 180 * KScreenRatio_6, height: 40 * KScreenRatio_6))
        }
        sepView.snp.makeConstraints { (make) in
            make.size.equalTo(CGSize.init(width: 300 * KScreenRatio_6, height: 0.5))
            make.left.equalTo(phoneLabel)
            make.top.equalTo(authCodeTF.snp.bottom).offset(2)
        }
        getAuthCodeBtn.snp.makeConstraints { (make) in
            make.size.equalTo(CGSize.init(width: 100 * KScreenRatio_6, height: 40 * KScreenRatio_6))
            make.right.equalTo(sepView)
            make.bottom.equalTo(sepView).offset(-10 * KScreenRatio_6)
        }
        loginBtn.snp.makeConstraints { (make) in
            make.size.equalTo(CGSize.init(width: 280 * KScreenRatio_6, height: 50 * KScreenRatio_6))
            make.centerX.equalTo(view)
            make.top.equalTo(sepView).offset(40 * KScreenRatio_6)
        }
    }

    //MARK: - action
    override func leftButtonsAction(sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    
    @objc func loginAction(sender: UIButton) {

        guard authCodeTF.hasText && authCodeTF.text!.count > 0 else {
            view.makeToast("验证码输入不正确")
            return
        }
        guard phoneTF.hasText else {
            view.makeToast("请输入手机号")
            return
        }
        if phoneTF.text! != kTestName && phoneTF.text!.isPhoneNumber == false {
            view.makeToast("手机号输入不正确")
            return
        }
        if titleString == "登录" {
            sender.isUserInteractionEnabled = false
            BXBNetworkTool.BXBRequest(router: .register(userName: self.phoneTF.text!, password: authCodeTF.text!), success: { (resp) in
                
                sender.isUserInteractionEnabled = true
                
                let token = resp["token"].stringValue
                let user = Mapper<UserData>().map(JSONObject: resp["user"].object)
                
                if token.count > 0 {
                    UserDefaults.standard.set(token, forKey: "token")
                    UserDefaults.standard.synchronize()
                    
                    if user != nil && user!.name.count > 0 {
                        NotificationCenter.default.post(name: .kNotiAgendaShouldRefreshData, object: nil, userInfo: nil)
                        NotificationCenter.default.post(name: .kNotiClientShouldRefreshData, object: nil)
                        NotificationCenter.default.post(name: .kNotiRemindShouldRefreshData, object: nil)
                        self.navigationController?.dismiss(animated: true, completion: nil)
                    }
                    else {
                        let vc = BXBSetUsernameVC()
                        self.navigationController?.pushViewController(vc, animated: true)
                    }
                }
                
            }, failure: { (error) in
                sender.isUserInteractionEnabled = true
            })
        }
        else{
            
        }
    }
    
    @objc func getAuthCode(sender: UIButton) {
        view.endEditing(true)
        guard phoneTF.hasText && phoneTF.text!.isPhoneNumber else {
            view.makeToast("手机号输入不正确")
            return
        }
        
        var leftTime = 59
        sender.isUserInteractionEnabled = true
        BXBNetworkTool.BXBRequest(router: .getAuthCode(telphone: phoneTF.text!), success: { (resp) in
    
            sender.isUserInteractionEnabled = true
            
            self.timer = Timer.scheduledTimer(withTimeInterval: 1, block: { [unowned self](t) in
                leftTime -= 1
                if leftTime > 0 {
                    self.getAuthCodeBtn.isUserInteractionEnabled = false
                    self.getAuthCodeBtn.setTitle("重新发送\(leftTime)", for: .normal)
                    self.getAuthCodeBtn.setTitleColor(kColor_subText, for: .normal)
                    self.getAuthCodeBtn.backgroundColor = kColor_background
                }
                else {
                    t.invalidate()
                    self.getAuthCodeBtn.isUserInteractionEnabled = true
                    self.getAuthCodeBtn.setTitle("获取验证码", for: .normal)
                    self.getAuthCodeBtn.setTitleColor(UIColor.white, for: .normal)
                    self.getAuthCodeBtn.backgroundColor = kColor_theme
                }
                
                }, repeats: true)
            
            self.timer.fire()
            
            
            
            
        }) { (error) in
           sender.isUserInteractionEnabled = true
        }
        
        
        
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    
    
    
    
    
    
    
}




















