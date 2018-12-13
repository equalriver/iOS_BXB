//
//  BXBUserFeedbackVC.swift
//  BXB
//
//  Created by equalriver on 2018/9/4.
//  Copyright © 2018年 tobosoft. All rights reserved.
//

import UIKit

class BXBUserFeedbackVC: BXBBaseNavigationVC {

    
    lazy var inputTV: YYTextView = {
        let v = YYTextView()
        v.placeholderText = "您的每一个意见都将帮助我们改善服务品质"
        v.placeholderFont = kFont_text_2
        v.placeholderTextColor = kColor_subText
        v.font = kFont_text_2_weight
        v.textColor = kColor_dark
        v.delegate = self
        v.backgroundColor = UIColor.white
        v.layer.cornerRadius = kCornerRadius
        v.layer.masksToBounds = true
        
        v.textContainerInset = UIEdgeInsets.init(top: 15 * KScreenRatio_6, left: 15 * KScreenRatio_6, bottom: 15 * KScreenRatio_6, right: 15 * KScreenRatio_6)
        return v
    }()
    lazy var phoneTF: UITextField = {
        let f = UITextField()
        f.font = kFont_text_2_weight
        f.textColor = kColor_dark
        f.clearButtonMode = .whileEditing
        f.keyboardType = .numbersAndPunctuation
        f.attributedPlaceholder = NSAttributedString.init(string: "选填，便于我们联系你", attributes: [NSAttributedString.Key.font: kFont_text_2, NSAttributedString.Key.foregroundColor: kColor_subText!])
        f.addTarget(self, action: #selector(phoneEditChange(sender:)), for: .editingChanged)
        return f
    }()
    lazy var phoneContent: UIView = {
        let v = UIView()
        v.backgroundColor = UIColor.white
        v.layer.cornerRadius = kCornerRadius
        v.layer.masksToBounds = true
        return v
    }()
    lazy var phoneTitleLabel: UILabel = {
        let l = UILabel()
        l.font = kFont_text_2_weight
        l.textColor = kColor_dark
        l.text = "联系电话"
        return l
    }()
    lazy var countLabel: UILabel = {
        let l = UILabel()
        l.textAlignment = .right
        return l
    }()
    lazy var confirmBtn: UIButton = {
        let b = UIButton()
        b.titleLabel?.font = kFont_btn_weight
        b.setTitle("提交", for: .normal)
        b.setTitleColor(UIColor.white, for: .normal)
        b.backgroundColor = kColor_theme
        b.layer.cornerRadius = 25 * KScreenRatio_6
        b.layer.masksToBounds = true
        b.addTarget(self, action: #selector(confirmAction(sender:)), for: .touchUpInside)
        return b
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        naviBar.naviBackgroundColor = UIColor.white
        title = "用户反馈"
        initUI()
        view.backgroundColor = kColor_background
    }
    
    func initUI() {
        view.addSubview(inputTV)
        view.addSubview(phoneContent)
        view.addSubview(countLabel)
        view.addSubview(confirmBtn)
        phoneContent.addSubview(phoneTitleLabel)
        phoneContent.addSubview(phoneTF)
        inputTV.snp.makeConstraints { (make) in
            make.size.equalTo(CGSize.init(width: 345 * KScreenRatio_6, height: 170 * KScreenRatio_6))
            make.centerX.equalTo(view)
            make.top.equalTo(naviBar.snp.bottom).offset(15 * KScreenRatio_6)
        }
        countLabel.snp.makeConstraints { (make) in
            make.height.equalTo(30 * KScreenRatio_6)
            make.right.equalTo(view).offset(-25 * KScreenRatio_6)
            make.top.equalTo(inputTV.snp.bottom)
        }
        phoneContent.snp.makeConstraints { (make) in
            make.size.equalTo(CGSize.init(width: 345 * KScreenRatio_6, height: 55 * KScreenRatio_6))
            make.centerX.equalTo(view)
            make.top.equalTo(countLabel.snp.bottom)
        }
        phoneTitleLabel.snp.makeConstraints { (make) in
            make.height.centerY.equalTo(phoneContent)
            make.left.equalTo(phoneContent).offset(15 * KScreenRatio_6)
        }
        phoneTF.snp.makeConstraints { (make) in
            make.height.centerY.equalTo(phoneContent)
            make.left.equalTo(phoneTitleLabel.snp.right).offset(20 * KScreenRatio_6)
            make.right.equalTo(phoneContent).offset(-15 * KScreenRatio_6)
        }
        confirmBtn.snp.makeConstraints { (make) in
            make.size.equalTo(CGSize.init(width: 280 * KScreenRatio_6, height: 50 * KScreenRatio_6))
            make.centerX.equalTo(view)
            make.bottom.equalTo(view).offset(-kIphoneXBottomInsetHeight - 15 * KScreenRatio_6)
        }
    }

    //MARK: - action
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    @objc func phoneEditChange(sender: UITextField) {
        
        guard sender.markedTextRange == nil else { return }
        
        if sender.hasText {
            sender.text = String(sender.text!.prefix(11)).filter({ (c) -> Bool in
                return String(c).isAllNumber
            })
        }
    }
    
    @objc func confirmAction(sender: UIButton) {
        guard inputTV.hasText == true else {
            view.makeToast("未填写反馈信息")
            return
        }
        var args: [String: Any] = ["remarks": inputTV.text]
        if phoneTF.hasText && phoneTF.text!.isPhoneNumber {
            args["remarkPhone"] = phoneTF.text!
        }
        sender.isUserInteractionEnabled = false
        BXBNetworkTool.BXBRequest(router: .editUser(args: args), success: { (resp) in
            
            sender.isUserInteractionEnabled = true
            
            SVProgressHUD.showInfo(withStatus: "提交成功，感谢您的反馈")
    
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1, execute: {
                self.navigationController?.popViewController(animated: true)
            })
            
        }) { (error) in
            sender.isUserInteractionEnabled = true
        }
    }

}

extension BXBUserFeedbackVC: YYTextViewDelegate {
    
    func textViewDidChange(_ textView: YYTextView) {
        
        if textView.hasText && textView.text.isIncludeEmoji {
            textView.text = textView.text!.filter({ (c) -> Bool in
                return String(c).isIncludeEmoji == false
            })
        }
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.1) {
            
            guard textView.markedTextRange == nil else { return }
            
            if textView.hasText {
                if textView.text.count > 140 {
                    self.view.makeToast("超出字数限制")
                    textView.text = String(textView.text.prefix(140))
                    return
                }
                
            }
            let current = "\(textView.text.count)"
            let total = "/140"
            let att = NSMutableAttributedString.init(string: current + total)
            att.addAttributes([NSAttributedString.Key.font: kFont_text_3, NSAttributedString.Key.foregroundColor: kColor_theme!], range: NSMakeRange(0, current.count))
            att.addAttributes([NSAttributedString.Key.font: kFont_text_3, NSAttributedString.Key.foregroundColor: kColor_subText!], range: NSMakeRange(current.count, total.count))
            self.countLabel.attributedText = att
        }
        
    }
}




