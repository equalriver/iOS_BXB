//
//  BXBLoginVC.swift
//  BXB
//
//  Created by equalriver on 2018/7/4.
//  Copyright © 2018年 tobosoft. All rights reserved.
//

import UIKit
import ObjectMapper

class BXBLoginVC: BXBBaseNavigationVC {
    
    lazy var logoIV: UIImageView = {
        let v = UIImageView.init(image: #imageLiteral(resourceName: "login_保记"))
        return v
    }()
    lazy var phoneLabel: UILabel = {
        let l = UILabel()
        l.font = kFont_text_weight
        l.textColor = kColor_text
        l.text = "手机号"
        return l
    }()
    lazy var phoneContentView: UIView = {
        let v = UIView()
        v.backgroundColor = UIColor.white
        v.layer.cornerRadius = kCornerRadius
        v.layer.masksToBounds = true
        return v
    }()
    lazy var phoneTF: UITextField = {
        let tf = UITextField()
        tf.backgroundColor = UIColor.white
        tf.font = kFont_text_2
        tf.textColor = kColor_dark
        tf.attributedPlaceholder = NSAttributedString.init(string: "请输入手机号", attributes: [NSAttributedString.Key.font: kFont_text_2, NSAttributedString.Key.foregroundColor: kColor_subText!])
        tf.keyboardType = .numberPad
        tf.clearButtonMode = .whileEditing
        tf.addBlock(for: .editingChanged, block: { (t) in
            if tf.hasText {
                tf.text = String(tf.text!.prefix(11)).filter({ (c) -> Bool in
                    return String(c).isAllNumber
                })
            }
        })
        return tf
    }()
    lazy var authCodeLabel: UILabel = {
        let l = UILabel()
        l.font = kFont_text_weight
        l.textColor = kColor_text
        l.text = "验证码"
        return l
    }()
    lazy var authContentView: UIView = {
        let v = UIView()
        v.backgroundColor = UIColor.white
        v.layer.cornerRadius = kCornerRadius
        v.layer.masksToBounds = true
        return v
    }()
    lazy var authCodeTF: UITextField = {
        let tf = UITextField()
        tf.backgroundColor = UIColor.white
        tf.font = kFont_text_2
        tf.textColor = kColor_dark
        tf.attributedPlaceholder = NSAttributedString.init(string: "请输入验证码", attributes: [NSAttributedString.Key.font: kFont_text_2, NSAttributedString.Key.foregroundColor: kColor_subText!])
        tf.clearButtonMode = .whileEditing
        tf.keyboardType = .numberPad
        tf.addBlock(for: .editingChanged, block: { (t) in
            if tf.hasText {
                tf.text = String(tf.text!.prefix(4)).filter({ (c) -> Bool in
                    return String(c).isAllNumber
                })
            }
        })
        return tf
    }()
    lazy var sepView: UIView = {
        let v = UIView()
        v.backgroundColor = kColor_background
        return v
    }()
    lazy var getCodeBtn: UIButton = {
        let b = UIButton()
        b.titleLabel?.font = kFont_text_3_weight
        b.setTitle("获取验证码", for: .normal)
        b.setTitleColor(kColor_theme, for: .normal)
        b.addTarget(self, action: #selector(getAuthCode(sender:)), for: .touchUpInside)
        return b
    }()
    lazy var loginBtn: UIButton = {
        let b = UIButton()
        b.titleLabel?.font = kFont_btn_weight
        b.setTitle("登录/注册", for: .normal)
        b.setTitleColor(UIColor.white, for: .normal)
        b.backgroundColor = kColor_theme
        b.layer.cornerRadius = 25 * KScreenRatio_6
        b.layer.masksToBounds = true
        b.addTarget(self, action: #selector(login(sender:)), for: .touchUpInside)
        return b
    }()
    lazy var userProtocolLabel: UILabel = {
        let l = UILabel()
        l.text = "登录/注册即表示同意 保记 "
        l.font = UIFont.systemFont(ofSize: 10)
        l.textColor = kColor_subText!
        return l
    }()
    lazy var userAgreementLabel: UILabel = {
        let l = UILabel()
        l.textAlignment = .center
        l.isUserInteractionEnabled = true
        let s1 = "用户协议"
        let s2 = "  和"
        let att = NSMutableAttributedString.init(string: s1 + s2)
        att.addAttributes([NSAttributedString.Key.font: UIFont.systemFont(ofSize: 10), NSAttributedString.Key.foregroundColor: kColor_subText!], range: NSMakeRange(0, (s1 + s2).count))
        att.addAttributes([NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue], range: NSMakeRange(0, s1.count))
        l.attributedText = att
        let tap = UITapGestureRecognizer.init(actionBlock: { [unowned self](t) in
            let vc = BXBUserAgreementVC()
            self.navigationController?.pushViewController(vc, animated: true)
        })
        l.addGestureRecognizer(tap)
        return l
    }()
    lazy var privacyLabel: UILabel = {
        let l = UILabel()
        l.textAlignment = .center
        l.isUserInteractionEnabled = true
        l.attributedText = NSAttributedString.init(string: "隐私政策", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 10), NSAttributedString.Key.foregroundColor: kColor_subText!, NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue])
        let tap = UITapGestureRecognizer.init(actionBlock: { [unowned self](t) in
            let vc = BXBUserPrivacyVC()
            self.navigationController?.pushViewController(vc, animated: true)
        })
        l.addGestureRecognizer(tap)
        return l
    }()
    
    lazy var backButton: UIButton = {
        let b = UIButton()
        b.setImage(#imageLiteral(resourceName: "bxb_返回_蓝"), for: .normal)
        b.addBlock(for: .touchUpInside, block: { [unowned self](sender) in
            self.navigationController?.dismiss(animated: true, completion: nil)
        })
        return b
    }()
    lazy var timer: Timer = {
        let t = Timer.init()
        return t
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
        isHiddenNavi = true
        NotificationCenter.default.addObserver(self, selector: #selector(notiLoginComplete), name: .kNotiLoginComplete, object: nil)
        
    }
    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        phoneTF.becomeFirstResponder()
//    }
  
    deinit {
        timer.invalidate()
        NotificationCenter.default.removeObserver(self)
    }
    
    func initUI() {
        view.backgroundColor = kColor_background
        view.addSubview(backButton)
        view.addSubview(logoIV)
        view.addSubview(phoneLabel)
        view.addSubview(phoneContentView)
        phoneContentView.addSubview(phoneTF)
        view.addSubview(authCodeLabel)
        view.addSubview(authContentView)
        authContentView.addSubview(authCodeTF)
        authContentView.addSubview(sepView)
        authContentView.addSubview(getCodeBtn)
        view.addSubview(loginBtn)
        view.addSubview(userProtocolLabel)
        view.addSubview(userAgreementLabel)
        view.addSubview(privacyLabel)
        backButton.snp.makeConstraints { (make) in
            make.size.equalTo(CGSize.init(width: 40 * KScreenRatio_6, height: 70 * KScreenRatio_6))
            make.top.equalTo(view).offset(15 * KScreenRatio_6)
            make.left.equalTo(view).offset(5 * KScreenRatio_6)
        }
        logoIV.snp.makeConstraints { (make) in
            make.size.equalTo(CGSize.init(width: 150 * KScreenRatio_6, height: 80 * KScreenRatio_6))
            make.centerX.equalTo(view)
            make.top.equalTo(view).offset(120 * KScreenRatio_6)
        }
        phoneLabel.snp.makeConstraints { (make) in
            make.left.equalTo(view).offset(20 * KScreenRatio_6)
            make.size.equalTo(CGSize.init(width: 100, height: 20))
            make.top.equalTo(logoIV.snp.bottom).offset(40 * KScreenRatio_6)
        }
        phoneContentView.snp.makeConstraints { (make) in
            make.size.equalTo(CGSize.init(width: 345 * KScreenRatio_6, height: 55 * KScreenRatio_6))
            make.centerX.equalTo(view)
            make.top.equalTo(phoneLabel.snp.bottom).offset(20 * KScreenRatio_6)
        }
        phoneTF.snp.makeConstraints { (make) in
            make.centerY.equalTo(phoneContentView)
            make.left.equalTo(phoneContentView).offset(20 * KScreenRatio_6)
            make.right.equalTo(phoneContentView).offset(-20 * KScreenRatio_6)
            make.height.equalTo(40 * KScreenRatio_6)
        }
        authCodeLabel.snp.makeConstraints { (make) in
            make.left.size.equalTo(phoneLabel)
            make.top.equalTo(phoneContentView.snp.bottom).offset(30 * KScreenRatio_6)
        }
        authContentView.snp.makeConstraints { (make) in
            make.centerX.size.equalTo(phoneContentView)
            make.top.equalTo(authCodeLabel.snp.bottom).offset(20 * KScreenRatio_6)
        }
        authCodeTF.snp.makeConstraints { (make) in
            make.centerY.equalTo(authContentView)
            make.left.equalTo(authContentView).offset(20 * KScreenRatio_6)
            make.size.equalTo(CGSize.init(width: 180 * KScreenRatio_6, height: 40 * KScreenRatio_6))
        }
        sepView.snp.makeConstraints { (make) in
            make.size.equalTo(CGSize.init(width: 1, height: 30 * KScreenRatio_6))
            make.centerY.equalTo(authContentView)
            make.left.equalTo(authCodeTF.snp.right).offset(15 * KScreenRatio_6)
        }
        getCodeBtn.snp.makeConstraints { (make) in
            make.size.equalTo(CGSize.init(width: 90 * KScreenRatio_6, height: 30 * KScreenRatio_6))
            make.centerY.equalTo(authContentView)
            make.right.equalTo(authContentView).offset(-20 * KScreenRatio_6)
        }
        loginBtn.snp.makeConstraints { (make) in
            make.size.equalTo(CGSize.init(width: 280 * KScreenRatio_6, height: 50 * KScreenRatio_6))
            make.centerX.equalTo(view)
            make.bottom.equalTo(view).offset(-40 * KScreenRatio_6 - kIphoneXBottomInsetHeight)
        }
        userProtocolLabel.snp.makeConstraints { (make) in
            make.left.equalTo(view).offset(72.5 * KScreenRatio_6)
            make.top.equalTo(loginBtn.snp.bottom).offset(10 * KScreenRatio_6)
        }
        userAgreementLabel.snp.makeConstraints { (make) in
            make.top.equalTo(loginBtn.snp.bottom).offset(10 * KScreenRatio_6)
            make.left.equalTo(userProtocolLabel.snp.right)
        }
        privacyLabel.snp.makeConstraints { (make) in
            make.top.equalTo(loginBtn.snp.bottom).offset(10 * KScreenRatio_6)
            make.left.equalTo(userAgreementLabel.snp.right).offset(10 * KScreenRatio_6)
        }
    }
    
    
    //MARK: - noti
    @objc func notiLoginComplete() {
        NotificationCenter.default.post(name: .kNotiAgendaShouldRefreshData, object: nil, userInfo: nil)
        NotificationCenter.default.post(name: .kNotiClientShouldRefreshData, object: nil)
        NotificationCenter.default.post(name: .kNotiRemindShouldRefreshData, object: nil)
        
        navigationController?.dismiss(animated: true, completion: nil)
    }
    
    //MARK: -
    @objc func getAuthCode(sender: UIButton) {
        view.endEditing(true)
        guard phoneTF.hasText && phoneTF.text!.isPhoneNumber else {
            view.makeToast("手机号输入不正确")
            return
        }
        
        var leftTime = 59

        sender.isUserInteractionEnabled = false
        BXBNetworkTool.BXBRequest(router: .getAuthCode(telphone: phoneTF.text!), success: { (resp) in
            
            self.view.makeToast("短信发送成功")
            sender.isUserInteractionEnabled = true
            
            self.timer = Timer.scheduledTimer(withTimeInterval: 1, block: { [unowned self](t) in
                leftTime -= 1
                if leftTime > 0 {
                    self.getCodeBtn.isUserInteractionEnabled = false
                    self.getCodeBtn.setTitle("重新发送\(leftTime)", for: .normal)
                    self.getCodeBtn.setTitleColor(kColor_subText, for: .normal)
                   
                }
                else {
                    t.invalidate()
                    self.getCodeBtn.isUserInteractionEnabled = true
                    self.getCodeBtn.setTitle("获取验证码", for: .normal)
                    self.getCodeBtn.setTitleColor(kColor_theme, for: .normal)
                    
                }
                
                }, repeats: true)
            
            self.timer.fire()
            
        }) { (error) in
            sender.isUserInteractionEnabled = true
        }
        
        
        
    }
    
    @objc func login(sender: UIButton) {
        
    #if DEBUG
        
    #else
        guard authCodeTF.hasText else {
            view.makeToast("请输入验证码哟")
            return
        }
        guard phoneTF.hasText else {
            view.makeToast("请输入手机号哟")
            return
        }
        
        if phoneTF.text!.isPhoneNumber == false && phoneTF.text! != kTestName {
            view.makeToast("手机号输入不正确")
            return
        }
        
    #endif
        
        sender.isUserInteractionEnabled = false
        BXBNetworkTool.BXBRequest(router: .register(userName: self.phoneTF.text!, password: authCodeTF.text!), success: { (resp) in
            
            sender.isUserInteractionEnabled = true
            
            let token = resp["token"].stringValue
            let user = Mapper<UserData>().map(JSONObject: resp["user"].object)
            
            //设置jpush别名
            if user != nil && user!.id != 0 {
                JPUSHService.setAlias("\(user!.id)", completion: { (num1, str, num2) in
                    print("设置jpush别名: \(num1), \(str ?? ""), \(num2)")
                }, seq: user!.id)
            }
            
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
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
  
    
}


















