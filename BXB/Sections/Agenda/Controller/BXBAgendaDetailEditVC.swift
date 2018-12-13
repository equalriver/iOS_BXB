//
//  BXBAgendaDetailEditVC.swift
//  BXB
//
//  Created by equalriver on 2018/6/13.
//  Copyright © 2018年 tobosoft. All rights reserved.
//

import Foundation

class BXBAgendaDetailEditVC: BXBBaseNavigationVC, YYTextViewDelegate {
    
    public var data = AgendaData()
    
    public var titleText = "" {
        willSet{
            titleLabel.text = newValue
        }
    }
    
    public var isAddAgenda = false
    
    public var addClientParams: [String: Any]!
    
    public var isNeedPopToRootVC = false
    
    
    lazy var titleLabel: UILabel = {
        let l = UILabel.init(frame: CGRect.init(x: 20 * KScreenRatio_6, y: kNavigationBarAndStatusHeight + 40, width: kScreenWidth, height: 30 * KScreenRatio_6))
        l.backgroundColor = kColor_background
        l.textColor = kColor_dark
        l.font = kFont_btn_weight
        return l
    }()
    
    lazy var contentView: UIView = {
        let v = UIView()
        v.backgroundColor = UIColor.white
        v.layer.cornerRadius = kCornerRadius
        v.layer.masksToBounds = true
        return v
    }()
    
    lazy var textView: YYTextView = {
        let tv = YYTextView()
        tv.backgroundColor = UIColor.white
        tv.placeholderText = "每一次经历都会让你成长."
        tv.placeholderFont = kFont_text_2
        tv.textColor = kColor_dark
        tv.font = kFont_text_2_weight
        tv.delegate = self
        return tv
    }()
    lazy var countLabel: UILabel = {
        let l = UILabel()
        l.textAlignment = .right
        return l
    }()
    lazy var voiceBtn: UIButton = {
        let b = UIButton()
        b.setImage(#imageLiteral(resourceName: "语音输入"), for: .normal)
        b.addTarget(self, action: #selector(voiceInputAction(sender:)), for: .touchUpInside)
        return b
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
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        return formatter
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
//        NotificationCenter.default.addObserver(self, selector: #selector(keyBoardFrameChange(noti:)), name: .UIKeyboardWillChangeFrame, object: nil)

    }
    
//    deinit {
//        NotificationCenter.default.removeObserver(self)
//    }
    
    func initUI() {
        naviBar.naviBackgroundColor = kColor_background!
        view.backgroundColor = kColor_background
        view.addSubview(titleLabel)
        view.addSubview(contentView)
        contentView.addSubview(textView)
        view.addSubview(voiceBtn)
        view.addSubview(countLabel)
        view.addSubview(confirmBtn)
        contentView.snp.makeConstraints { (make) in
            make.size.equalTo(CGSize.init(width: 345 * KScreenRatio_6, height: 80 * KScreenRatio_6))
            make.top.equalTo(titleLabel.snp.bottom).offset(15 * KScreenRatio_6)
            make.centerX.equalTo(view)
        }
        textView.snp.makeConstraints { (make) in
            make.bottom.right.equalTo(contentView).offset(-15 * KScreenRatio_6)
            make.left.top.equalTo(contentView).offset(15 * KScreenRatio_6)
        }
        voiceBtn.snp.makeConstraints { (make) in
            make.right.equalTo(view).offset(-20 * KScreenRatio_6)
            make.bottom.equalTo(contentView.snp.top).offset(-15 * KScreenRatio_6)
            make.size.equalTo(CGSize.init(width: 100, height: 30))
        }
        countLabel.snp.makeConstraints { (make) in
            make.right.equalTo(view).offset(-25 * KScreenRatio_6)
            make.top.equalTo(contentView.snp.bottom).offset(15 * KScreenRatio_6)
            make.left.equalTo(contentView)
        }
        confirmBtn.snp.makeConstraints { (make) in
            make.size.equalTo(CGSize.init(width: 100 * KScreenRatio_6, height: 100 * KScreenRatio_6))
            make.centerX.equalTo(view)
            make.bottom.equalTo(view).offset(-15 * KScreenRatio_6 - kIphoneXBottomInsetHeight)
        }
    }
    
    
    //MARK: - action
    //语音输入
    @objc func voiceInputAction(sender: UIButton) {
        
        view.endEditing(true)
        
//        let rect = contentView.convert(textView.frame, to: view)
//        UIView.animate(withDuration: 0.25) {
//            self.view.transform = CGAffineTransform.init(translationX: 0, y: -speechContentHeight - 30 - (kScreenHeight - rect.origin.y - rect.height))
//        }
        if textView.text == "未设置" { textView.text = nil }
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.25) {
            if #available(iOS 10.0, *) {
                let speech = BXBSpeech.init(frame: CGRect.init(x: 0, y: 0, width: kScreenWidth, height: kScreenHeight), showHandle: {
                    
                    //                self.view.transform = CGAffineTransform.init(translationX: 0, y: (kScreenHeight - rect.origin.y - rect.height) - speechContentHeight - 30)
                    
                }, dismissHandle: {
                    UIView.animate(withDuration: 0.25) {
                        self.view.transform = CGAffineTransform.init(translationX: 0, y: 0)
                    }
                })
                UIApplication.shared.keyWindow?.addSubview(speech)
                
                speech.showSpeechView { (str) in
                    if (self.textView.text + str).count > kRemarkTextLimitCount_1 {
                        self.view.makeToast("超出字数限制")
                        return
                    }
                    self.textView.text = self.textView.text + str
                    print("语音输入: \(str)")
                }
            } else {
                SVProgressHUD.showInfo(withStatus: "语音输入需要iOS 10以上的系统")
            }
        }
        
    }
    
    @objc func confirmAction(sender: UIButton) {
        
        view.endEditing(true)
        if isAddAgenda {
            self.navigationController?.popViewController(animated: true)
            return
        }
        
        if self.titleText == "备注" {
            sender.isUserInteractionEnabled = false
            BXBNetworkTool.BXBRequest(router: .editAgenda(name: data.name, id: data.id, params: ["remarks": textView.text!]), success: { (resp) in
                
                sender.isUserInteractionEnabled = true
                
                let d = self.data.formatter.date(from: self.data.visitDate) ?? Date()
                NotificationCenter.default.post(name: .kNotiAgendaShouldRefreshData, object: nil, userInfo: ["selectedDate": d])

                self.navigationController?.popViewController(animated: true)
                
            }) { (error) in
                sender.isUserInteractionEnabled = true
            }
           
        }
        else{
            if self.textView.text.count <= 2000 {
                
                if self.addClientParams != nil { self.addNewClient(sender: sender) }
                
                if data.isOldAgenda {//补录的日程
                    addNewAgendaRequest(sender: sender)
                }
                else {
                    confirmReq(sender: sender)
                }
                
            }
            else  {
                self.view.makeToast("超出字数限制")
            }
        }
        
    }
    
    //添加客户
    func addNewClient(sender: UIButton) {
        
        sender.isUserInteractionEnabled = false
        BXBNetworkTool.BXBRequest(router: .addClient(args: addClientParams), success: { (resp) in
            
            sender.isUserInteractionEnabled = true
            
            NotificationCenter.default.post(name: .kNotiClientShouldRefreshData, object: nil)
            archiverUserData(datas: nil)
            
        }) { (error) in
            sender.isUserInteractionEnabled = true
        }
    }
    
    
    func confirmReq(sender: UIButton) {
        var args: [String : Any] = ["visitDate": data.visitDate, "remindTime": data.remindTime, "address": data.address, "visitTepyName": data.visitTypeName, "remarks": data.remarks, "heart": data.heart, "matter": data.matter, "latitude": data.lat, "longitude": data.lng, "unitAddress": data.detailAddress, "status": 1]
       
        if data.matter.contains("签单") || data.visitTypeName.contains("签单") {
            args["amount"] = data.amount
            args["policyNum"] = data.policyNum
        }
        
        sender.isUserInteractionEnabled = false
        BXBNetworkTool.BXBRequest(router: .editAgenda(name: data.name, id: data.id, params: args), success: { (resp) in
            
            sender.isUserInteractionEnabled = true
            
            let d = self.data.formatter.date(from: self.data.visitDate) ?? Date()
            NotificationCenter.default.post(name: .kNotiAgendaShouldRefreshData, object: nil, userInfo: ["selectedDate": d, kLastFinishedAgendaKey: self.data.id])
            NotificationCenter.default.post(name: .kNotiClientShouldRefreshData, object: nil)
         
            BXBLocalizeNotification.removeLocalizeNotification(id: self.data.id)
            
            //修改提醒跟进状态
            if self.data.isNoticeFollow {
                BXBNetworkTool.BXBRequest(router: .editClientRemind(id: self.data.noticeId, args: ["isFollow": "1"]), success: { (resp) in
                    
                    DispatchQueue.global().async {
                        NotificationCenter.default.post(name: .kNotiRemindShouldRefreshData, object: nil)
                        BXBNetworkTool.isShowSVProgressHUD = false
                    }
                    
                }) { (error) in
                    
                }
            }
            
            //点击了添加后续
            let isNeedPushAddNewAgenda = UserDefaults.standard.bool(forKey: kAgendaAddNextPlain)
            
            if isNeedPushAddNewAgenda {
                
                UserDefaults.standard.set(false, forKey: kAgendaAddNextPlain)
                NotificationCenter.default.post(name: .kNotiAddNewAgendaBySelectFollow, object: nil, userInfo: ["agendaData": self.data])
                self.navigationController?.popToRootViewController(animated: true)
                return
            }
   
            if self.isNeedPopToRootVC {
                self.navigationController?.popToRootViewController(animated: true)
            }
            else {
                self.navigationController?.popViewController(animated: true)
            }
            
        }) { (error) in
            sender.isUserInteractionEnabled = true
        }
    }
    
    func addNewAgendaRequest(sender: UIButton) {
        
        confirmBtn.isUserInteractionEnabled = false
        var args: [String : Any] = ["name": data.name, "visitDate": data.visitDate, "remindTime": data.remindTime, "address": data.address, "visitTepyName": data.visitTypeName, "remarks": data.remarks, "heart": data.heart, "matter": data.matter, "latitude": data.lat, "longitude": data.lng, "unitAddress": data.detailAddress, "status": 1]
        if data.matter.contains("签单") || data.visitTypeName.contains("签单") {
            args["amount"] = data.amount
            args["policyNum"] = data.policyNum
        }
        
        sender.isUserInteractionEnabled = false
        BXBNetworkTool.BXBRequest(router: .addNewAgenda(args: args), success: { (resp) in

            self.confirmBtn.isUserInteractionEnabled = true
            sender.isUserInteractionEnabled = true
            
            //修改提醒跟进状态
            if self.data.isNoticeFollow {
                BXBNetworkTool.BXBRequest(router: .editClientRemind(id: self.data.noticeId, args: ["isFollow": "1"]), success: { (resp) in
                    
                    DispatchQueue.global().async {
                        NotificationCenter.default.post(name: .kNotiRemindShouldRefreshData, object: nil)
                        BXBNetworkTool.isShowSVProgressHUD = false
                    }
                    
                }) { (error) in
                    
                }
            }
            
            let id = resp["id"].intValue

            let d = self.data.formatter.date(from: self.data.visitDate) ?? Date()
            NotificationCenter.default.post(name: .kNotiAgendaShouldRefreshData, object: nil, userInfo: ["selectedDate": d, kLastFinishedAgendaKey: id])
            NotificationCenter.default.post(name: .kNotiAddOldAgendaNeedDismiss, object: nil)
            NotificationCenter.default.post(name: .kNotiClientShouldRefreshData, object: nil)

            BXBLocalizeNotification.removeLocalizeNotification(id: id)
            
            if self.data.isWorkData == true {
                NotificationCenter.default.post(name: .kNotiWorkDidFinishNotice, object: nil, userInfo: ["workNoticeId": self.data.noticeId])
            }
            //点击了添加后续
            let isNeedPushAddNewAgenda = UserDefaults.standard.bool(forKey: kAgendaAddNextPlain)
            
            if isNeedPushAddNewAgenda {
                UserDefaults.standard.set(false, forKey: kAgendaAddNextPlain)
                NotificationCenter.default.post(name: .kNotiAddNewAgendaBySelectFollow, object: nil, userInfo: ["agendaData": self.data])
            }
            if let t = UIApplication.shared.keyWindow?.rootViewController {
                
                if t.isKind(of: BXBTabBarController.self) {
                    let tab = t as! BXBTabBarController
                    tab.selectedIndex = 1
                }
            }
            if self.navigationController != nil && self.navigationController!.viewControllers.count > 1 {
                
                self.navigationController?.popToRootViewController(animated: true)
            }
            else { self.dismiss(animated: true, completion: nil) }
    
        }) { (error) in
            self.confirmBtn.isUserInteractionEnabled = true
            sender.isUserInteractionEnabled = true
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        view.endEditing(true)
    }
    
    @objc func keyBoardFrameChange(noti: Notification) {
        //获取键盘弹出前的Rect
//        guard let keyBoardBeginBounds = noti.userInfo![UIKeyboardFrameBeginUserInfoKey] else { return }
//        let beginRect = (keyBoardBeginBounds as! NSValue).cgRectValue
        
        //获取键盘弹出后的Rect
        guard let keyBoardEndBounds = noti.userInfo![UIResponder.keyboardFrameEndUserInfoKey] else { return }
        let endRect = (keyBoardEndBounds as! NSValue).cgRectValue
        
        //获取键盘位置变化前后纵坐标Y的变化值
//        let deltaY = endRect.origin.y - beginRect.origin.y
        
        let off = confirmBtn.origin.y + confirmBtn.height
        let keyboardOffset = off > endRect.origin.y ? endRect.origin.y - off : 0
        
        //在0.25s内完成self.view的Frame的变化，等于是给self.view添加一个向上移动deltaY的动画
        UIView.animate(withDuration: 0.25) {
            self.confirmBtn.transform = CGAffineTransform.init(translationX: 0, y: keyboardOffset)
        }

    }
    
    //MARK: - YYTextViewDelegate
    
    func textViewDidChange(_ textView: YYTextView) {
        
        if textView.hasText && textView.text.isIncludeEmoji {
            textView.text = textView.text!.filter({ (c) -> Bool in
                return String(c).isIncludeEmoji == false
            })
            return
        }
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.1) {
            
            guard textView.markedTextRange == nil else { return }
            
            if textView.hasText {
                if textView.text.count > kRemarkTextLimitCount_1 {
                    self.view.makeToast("超出字数限制")
                    textView.text = String(textView.text.prefix(kRemarkTextLimitCount_1))
                    if self.titleText == "备注" { self.data.remarks = textView.text }
                    else { self.data.heart = textView.text }
                    return
                }
                
            }
            if self.titleText == "备注" { self.data.remarks = textView.text ?? "" }
            else { self.data.heart = textView.text ?? "" }
            
            let current = "\(textView.text.count)"
            let total = "/\(kRemarkTextLimitCount_1)"
            let att = NSMutableAttributedString.init(string: current + total)
            att.addAttributes([NSAttributedString.Key.font: kFont_text, NSAttributedString.Key.foregroundColor: kColor_theme!], range: NSMakeRange(0, current.count))
            att.addAttributes([NSAttributedString.Key.font: kFont_text, NSAttributedString.Key.foregroundColor: kColor_subText!], range: NSMakeRange(current.count, total.count))
            self.countLabel.attributedText = att
        }
        
    }
    
    
    
}
