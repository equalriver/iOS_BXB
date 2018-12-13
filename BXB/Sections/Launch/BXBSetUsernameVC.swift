//
//  BXBSetUsernameVC.swift
//  BXB
//
//  Created by equalriver on 2018/7/26.
//  Copyright © 2018年 tobosoft. All rights reserved.
//

import UIKit

class BXBSetUsernameVC: BXBBaseNavigationVC {
    
    lazy var logoIV: UIImageView = {
        let v = UIImageView.init(image: #imageLiteral(resourceName: "login_保记"))
        return v
    }()
    lazy var nameLabel: UILabel = {
        let l = UILabel()
        l.font = kFont_text_weight
        l.textColor = kColor_text
        l.text = "姓名"
        return l
    }()
    lazy var nameContentView: UIView = {
        let v = UIView()
        v.backgroundColor = UIColor.white
        v.layer.cornerRadius = kCornerRadius
        v.layer.masksToBounds = true
        return v
    }()
    lazy var nameTF: UITextField = {
        let tf = UITextField()
        tf.font = kFont_text
        tf.textColor = kColor_text
        tf.keyboardType = .numbersAndPunctuation
        tf.clearButtonMode = .whileEditing
        tf.attributedPlaceholder = NSAttributedString.init(string: "请输入姓名", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16 * KScreenRatio_6), NSAttributedString.Key.foregroundColor: kColor_subText!])
        tf.addBlock(for: .editingChanged, block: { [unowned self](t) in
            guard tf.hasText else {
                tf.text = ""
                return
            }
            guard tf.markedTextRange == nil else { return }
            if tf.text!.count > kNameTextLimitCount {
                tf.text = String(tf.text!.prefix(kNameTextLimitCount))
            }
            
        })
        return tf
    }()

    lazy var loginBtn: UIButton = {
        let b = UIButton()
        b.titleLabel?.font = kFont_btn_weight
        b.setTitleColor(UIColor.white, for: .normal)
        b.setTitle("确定", for: .normal)
        b.backgroundColor = kColor_theme
        b.layer.cornerRadius = 25 * KScreenRatio_6
        b.layer.masksToBounds = true
        b.addTarget(self, action: #selector(loginAction(sender:)), for: .touchUpInside)
        return b
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        nameTF.becomeFirstResponder()
    }
    
    func initUI() {
        title = "设置用户名"
        naviBar.naviBackgroundColor = kColor_background!
        
        view.backgroundColor = kColor_background
        view.addSubview(logoIV)
        view.addSubview(nameLabel)
        view.addSubview(nameContentView)
        nameContentView.addSubview(nameTF)
        view.addSubview(loginBtn)
        logoIV.snp.makeConstraints { (make) in
            make.size.equalTo(CGSize.init(width: 150 * KScreenRatio_6, height: 80 * KScreenRatio_6))
            make.centerX.equalTo(view)
            make.top.equalTo(view).offset(120 * KScreenRatio_6)
        }
        nameLabel.snp.makeConstraints { (make) in
            make.left.equalTo(view).offset(20 * KScreenRatio_6)
            make.size.equalTo(CGSize.init(width: 100, height: 20))
            make.top.equalTo(logoIV.snp.bottom).offset(40 * KScreenRatio_6)
        }
        nameContentView.snp.makeConstraints { (make) in
            make.size.equalTo(CGSize.init(width: 345 * KScreenRatio_6, height: 55 * KScreenRatio_6))
            make.centerX.equalTo(view)
            make.top.equalTo(nameLabel.snp.bottom).offset(20 * KScreenRatio_6)
        }
        nameTF.snp.makeConstraints { (make) in
            make.centerY.equalTo(nameContentView)
            make.left.equalTo(nameContentView).offset(20 * KScreenRatio_6)
            make.right.equalTo(nameContentView).offset(-20 * KScreenRatio_6)
            make.height.equalTo(40 * KScreenRatio_6)
        }
        loginBtn.snp.makeConstraints { (make) in
            make.size.equalTo(CGSize.init(width: 280 * KScreenRatio_6, height: 50 * KScreenRatio_6))
            make.centerX.equalTo(view)
            make.bottom.equalTo(view).offset(-40 * KScreenRatio_6)
        }
    }
    
    //MARK: - action
    
    @objc func loginAction(sender: UIButton) {
        
        guard nameTF.hasText else {
            view.makeToast("请输入姓名")
            return
        }
  
        BXBNetworkTool.BXBRequest(router: .editUser(args: ["name": nameTF.text!]), success: { (resp) in
            sender.isUserInteractionEnabled = true
            NotificationCenter.default.post(name: .kNotiAgendaShouldRefreshData, object: nil, userInfo: nil)
            NotificationCenter.default.post(name: .kNotiClientShouldRefreshData, object: nil)
            NotificationCenter.default.post(name: .kNotiRemindShouldRefreshData, object: nil)
            self.navigationController?.dismiss(animated: true, completion: nil)
            
        }) { (error) in
            sender.isUserInteractionEnabled = true
        }
        
    }

    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    
    
    
    
    
    
    
}
