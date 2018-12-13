//
//  BXBUserTargetVC.swift
//  BXB
//
//  Created by equalriver on 2018/7/4.
//  Copyright © 2018年 tobosoft. All rights reserved.
//

import UIKit

class BXBUserTargetVC: BXBBaseNavigationVC {

    public var targetName = ""
    
    public var data = UserData()
    
    public var aims = UserAimsData() {
        willSet{
            if targetName == "活动量目标" {
                targetTF.text = newValue.activityCount == 0 ? nil : "\(newValue.activityCount)"
                moneyTagLabel.isHidden = true
            }
            if targetName == "我的保费目标" { targetTF.text = newValue.targetAmount == 0 ? nil : "\(newValue.targetAmount)" }
            if targetName == "团队保费目标" { targetTF.text = newValue.targetAmountTeam == 0 ? nil : "\(newValue.targetAmountTeam)" }
        }
    }
    
    var currentMonth = 0
    
    
    lazy var iconIV: UIImageView = {
        let iv = UIImageView.init(image: #imageLiteral(resourceName: "me_目标"))
        return iv
    }()
    lazy var targetNameLabel: UILabel = {
        let l = UILabel()
        l.font = UIFont.systemFont(ofSize: 20 * KScreenRatio_6)
        l.textColor = kColor_theme
        l.textAlignment = .center
        return l
    }()
    lazy var targetTF: UITextField = {
        let tf = UITextField()
        tf.textColor = kColor_dark
        tf.font = UIFont.systemFont(ofSize: 30 * KScreenRatio_6, weight: UIFont.Weight.bold)
        tf.textAlignment = .center
        tf.keyboardType = .numberPad
        tf.attributedPlaceholder = NSAttributedString.init(string: "请设置本月目标", attributes: [NSAttributedString.Key.font: kFont_text, NSAttributedString.Key.foregroundColor: kColor_subText!])
        tf.addBlock(for: .editingChanged, block: { (t) in
            if tf.hasText { tf.text = String(tf.text!.prefix(9)) }
        })
        return tf
    }()
    lazy var moneyTagLabel: UILabel = {
        let l = UILabel()
        l.font = kFont_text_weight
        l.textColor = kColor_dark
        l.text = "元"
        return l
    }()
    lazy var sepView: UIView = {
        let v = UIView()
        v.backgroundColor = kColor_separatorView
        return v
    }()
    lazy var confirmBtn: ImageTopButton = {
        let b = ImageTopButton()
        b.titleLabel?.font = kFont_text_3
        b.setTitle("完成", for: .normal)
        b.setTitleColor(kColor_text, for: .normal)
        b.setImage(#imageLiteral(resourceName: "bxb_btn完成"), for: .normal)
        b.addTarget(self, action: #selector(confirmAction(sender:)), for: .touchUpInside)
        return b
    }()
    lazy var dateFormatter: DateFormatter = {
        let d = DateFormatter()
        d.dateFormat = "yyyy-MM-dd"
        return d
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
        let arr = dateFormatter.string(from: Date()).components(separatedBy: "-")
        if arr.count == 3 {
            guard Int(arr[1]) != nil else { return }
            currentMonth = Int(arr[1])!
            targetNameLabel.text = "\(currentMonth)月" + targetName
        }
    }
    
    func initUI() {
        view.addSubview(iconIV)
        view.addSubview(targetNameLabel)
        view.addSubview(targetTF)
        view.addSubview(moneyTagLabel)
        view.addSubview(sepView)
        view.addSubview(confirmBtn)
        iconIV.snp.makeConstraints { (make) in
            make.centerX.equalTo(view)
            make.top.equalTo(view).offset(190 * KScreenRatio_6)
        }
        targetNameLabel.snp.makeConstraints { (make) in
            make.centerX.width.equalTo(view)
            make.top.equalTo(iconIV.snp.bottom)
        }
        sepView.snp.makeConstraints { (make) in
            make.size.equalTo(CGSize.init(width: 200 * KScreenRatio_6, height: 0.5))
            make.centerX.equalTo(view)
            make.top.equalTo(targetNameLabel.snp.bottom).offset(105 * KScreenRatio_6)
        }
        targetTF.snp.makeConstraints { (make) in
            make.width.equalTo(180 * KScreenRatio_6)
            make.top.equalTo(targetNameLabel.snp.bottom).offset(60 * KScreenRatio_6)
            make.centerX.equalTo(sepView)
        }
        moneyTagLabel.snp.makeConstraints { (make) in
            make.left.equalTo(sepView.snp.right).offset(10)
            make.bottom.equalTo(targetTF.snp.bottom)
        }
        confirmBtn.snp.makeConstraints { (make) in
            make.size.equalTo(CGSize.init(width: 100 * KScreenRatio_6, height: 100 * KScreenRatio_6))
            make.bottom.equalTo(view).offset(-15 * KScreenRatio_6 - kIphoneXBottomInsetHeight)
            make.centerX.equalTo(view)
        }
    }
    
    //MARK: - action
    @objc func confirmAction(sender: UIButton) {
        
        guard targetTF.hasText == true else {
            view.makeToast("未输入当月目标")
            return
        }
        guard targetTF.text!.isAllNumber == true && Int(targetTF.text!) != nil else {
            view.makeToast("必须为数字")
            return
        }
        if targetName == "活动量目标" {
            
            sender.isUserInteractionEnabled = false
            
            BXBNetworkTool.BXBRequest(router: .addUserActivity(activityCount: Int(targetTF.text!)!, teamId: data.addTeamId, userId: data.id), success: { (resp) in
                sender.isUserInteractionEnabled = true
                NotificationCenter.default.post(name: .kNotiUserShouldRefreshData, object: nil)
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1, execute: {
                    self.navigationController?.popViewController(animated: true)
                })
                
            }) { (error) in
                sender.isUserInteractionEnabled = true
            }
        }
        else if targetName == "我的保费目标" {
            
            sender.isUserInteractionEnabled = false
            
            BXBNetworkTool.BXBRequest(router: .addBaoFei(targetAmount: Int(targetTF.text!)!, teamId: data.addTeamId, userId: data.id), success: { (resp) in
                sender.isUserInteractionEnabled = true
                NotificationCenter.default.post(name: .kNotiUserShouldRefreshData, object: nil)
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1, execute: {
                    self.navigationController?.popViewController(animated: true)
                })
                
            }) { (error) in
                sender.isUserInteractionEnabled = true
            }
        }
        else {
            
            sender.isUserInteractionEnabled = false
            
            BXBNetworkTool.BXBRequest(router: .addTeamBaofei(targetAmount: Int(targetTF.text!)!, teamId: data.addTeamId, userId: data.id), success: { (resp) in
                sender.isUserInteractionEnabled = true
                NotificationCenter.default.post(name: .kNotiUserShouldRefreshData, object: nil)
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1, execute: {
                    self.navigationController?.popViewController(animated: true)
                })
                
            }) { (error) in
                sender.isUserInteractionEnabled = true
            }
        }
        
        
    }
    



}











