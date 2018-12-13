//
//  BXBAgendaDetailSigningVC.swift
//  BXB
//
//  Created by equalriver on 2018/6/12.
//  Copyright © 2018年 tobosoft. All rights reserved.
//

import UIKit

class BXBAgendaDetailSigningVC: BXBBaseNavigationVC {
    
    public var data = AgendaData()
    
    ///是否跳转新建联系人
    public var isNeedGoAddPage = false
    
    lazy var signingView: AgendaDetailSigningView = {
        let v = AgendaDetailSigningView.init(frame: .zero)
        v.title = "签单数"
        v.tfPlaceholder = "请输入数量"
        v.tagTitle = "件"
        v.inputTF.addBlock(for: .editingChanged) { [unowned self](tf) in
            
            guard v.inputTF.markedTextRange == nil else { return }
            
            if v.inputTF.hasText {
                v.inputTF.text = String(v.inputTF.text!.prefix(kSignCountTextLimitCount)).filter({ (c) -> Bool in
                    return String(c).isAllNumber
                })
            }
        }
        return v
    }()
    
    lazy var costView: AgendaDetailSigningView = {
        let v = AgendaDetailSigningView.init(frame: .zero)
        v.title = "总保费"
        v.tfPlaceholder = "请输入金额"
        v.tagTitle = "元"
        v.inputTF.addBlock(for: .editingChanged) { [unowned self](tf) in
            
            guard v.inputTF.markedTextRange == nil else { return }
            
            if v.inputTF.hasText {
    
                v.inputTF.text = String(v.inputTF.text!.prefix(kBaofeiTextLimitCount)).filter({ (c) -> Bool in
                    return String(c).isAllNumber
                })
            
            }
        }
        return v
    }()
    
    lazy var confirmBtn: ImageTopButton = {
        let b = ImageTopButton()
        b.setTitle("下一步", for: .normal)
        b.titleLabel?.font = kFont_text_3
        b.setTitleColor(kColor_text, for: .normal)
        b.setImage(#imageLiteral(resourceName: "bxb_btn下一步"), for: .normal)
        b.addTarget(self, action: #selector(confirmAction(sender:)), for: .touchUpInside)
        return b
    }()
    
    //MARK: -
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "签单"
        
        initUI()
        
    }
    
    func initUI() {
        naviBar.naviBackgroundColor = kColor_background!
        view.backgroundColor = kColor_background
        view.addSubview(signingView)
        view.addSubview(costView)
        view.addSubview(confirmBtn)
        signingView.snp.makeConstraints { (make) in
            make.size.equalTo(CGSize.init(width: 345 * KScreenRatio_6, height: 110 * KScreenRatio_6))
            make.top.equalTo(naviBar.snp.bottom).offset(60 * KScreenRatio_6)
            make.centerX.equalTo(view)
        }
        costView.snp.makeConstraints { (make) in
            make.size.equalTo(CGSize.init(width: 345 * KScreenRatio_6, height: 110 * KScreenRatio_6))
            make.top.equalTo(signingView.snp.bottom).offset(10 * KScreenRatio_6)
            make.centerX.equalTo(view)
        }
        confirmBtn.snp.makeConstraints { (make) in
            make.size.equalTo(CGSize.init(width: 100 * KScreenRatio_6, height: 100 * KScreenRatio_6))
            make.centerX.equalTo(view)
            make.bottom.equalTo(view).offset(-15 * KScreenRatio_6 - kIphoneXBottomInsetHeight)
        }
        
    }

    //MARK: - action
    @objc func confirmAction(sender: UIButton) {
        
        guard signingView.inputTF.text != nil && (signingView.inputTF.text?.count)! > 0 else{
            view.makeToast("未填写签单数")
            return
        }
        
        guard costView.inputTF.text != nil && (costView.inputTF.text?.count)! > 0 else{
            view.makeToast("未填写总保费")
            return
        }
        guard Int(self.signingView.inputTF.text!) != nil else { return }
        guard Int(self.costView.inputTF.text!) != nil else { return }
        
        if Int(self.signingView.inputTF.text!)! <= 0 {
            view.makeToast("签单数不能为空")
            return
        }
        if Int(self.costView.inputTF.text!)! <= 0 {
            view.makeToast("保费不能为空")
            return
        }
        
        data.policyNum = signingView.inputTF.text ?? ""
        data.amount = Int(self.costView.inputTF.text!) ?? 0
        
        if data.isOldAgenda {//补录的日程
            
            let d = self.data.formatter.date(from: self.data.visitDate) ?? Date()
            NotificationCenter.default.post(name: .kNotiAgendaShouldRefreshData, object: nil, userInfo: ["selectedDate": d])
            
            if self.isNeedGoAddPage {
                let vc = BXBAddNewClientVC()
                vc.agendaData = self.data
                self.navigationController?.pushViewController(vc, animated: true)
            }
            else{
                let vc = BXBAgendaDetailEditVC()
                vc.titleText = "说点什么吧..."
                vc.data = self.data
                vc.isNeedPopToRootVC = true
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
        else {
            let d = self.data.formatter.date(from: self.data.visitDate) ?? Date()
            NotificationCenter.default.post(name: .kNotiAgendaShouldRefreshData, object: nil, userInfo: ["selectedDate": d])
            
            if self.isNeedGoAddPage {
                let vc = BXBAddNewClientVC()
                vc.agendaData = self.data
                self.navigationController?.pushViewController(vc, animated: true)
            }
            else{
                let vc = BXBAgendaDetailEditVC()
                vc.titleText = "说点什么吧..."
                vc.data = self.data
                vc.isNeedPopToRootVC = true
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }

}


class AgendaDetailSigningView: UIView {
    
    public var title = "" {
        willSet{
            titleLabel.text = newValue
        }
    }
    
    public var tfPlaceholder = "" {
        willSet{
            inputTF.attributedPlaceholder = NSAttributedString.init(string: newValue, attributes: [.font: kFont_text, .foregroundColor: kColor_subText!])
        }
    }
    
    public var tagTitle = "" {
        willSet{
            tagLabel.text = newValue
        }
    }
    
    lazy var titleLabel: UILabel = {
        let l = UILabel()
        l.font = kFont_text_weight
        l.textColor = kColor_text
        return l
    }()
    
    lazy var contentView: UIView = {
        let v = UIView()
        v.backgroundColor = UIColor.white
        v.layer.cornerRadius = kCornerRadius
        v.layer.masksToBounds = true
        return v
    }()
    
    lazy var inputTF: UITextField = {
        let tf = UITextField()
        tf.font = kFont_text_weight
        tf.textColor = kColor_dark
        tf.keyboardType = .numberPad
        tf.clearButtonMode = .whileEditing
        return tf
    }()
    
    lazy var tagLabel: UILabel = {
        let l = UILabel()
        l.font = kFont_text_2
        l.textColor = kColor_text
        return l
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = kColor_background
        addSubview(titleLabel)
        addSubview(contentView)
        contentView.addSubview(inputTF)
        contentView.addSubview(tagLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self).offset(8 * KScreenRatio_6)
            make.top.equalTo(self)
        }
        contentView.snp.makeConstraints { (make) in
            make.size.equalTo(CGSize.init(width: 345 * KScreenRatio_6, height: 55 * KScreenRatio_6))
            make.left.equalTo(self)
            make.top.equalTo(titleLabel.snp.bottom).offset(20 * KScreenRatio_6)
        }
        inputTF.snp.makeConstraints { (make) in
            make.left.equalTo(contentView).offset(15 * KScreenRatio_6)
            make.centerY.equalTo(contentView)
            make.size.equalTo(CGSize.init(width: 300 * KScreenRatio_6, height: 20 * KScreenRatio_6))
        }
        tagLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(contentView)
            make.right.equalTo(contentView).offset(-15 * KScreenRatio_6)
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    
    
    
    
    
    
    
    
}
