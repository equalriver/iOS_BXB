//
//  AddNewAgendaStep_2_delegate.swift
//  BXB
//
//  Created by equalriver on 2018/8/22.
//  Copyright © 2018年 tobosoft. All rights reserved.
//

import Foundation


extension BXBAddNewAgendaStep_2_VC {
    
    //MARK: - action
    @objc func keyBoardFrameChange(noti: Notification) {
        
        if addressRemarkTF.isFirstResponder { return }
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
            self.view.transform = CGAffineTransform.init(translationX: 0, y: keyboardOffset)
        }
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    @objc func addressSelect() {
        
        guard checkNetwork() == true else { return }
        
        switch CLLocationManager.authorizationStatus() {
        case .authorizedAlways, .authorizedWhenInUse, .notDetermined:
            let vc = BXBSelectedLocationVC()
            vc.delegate = self
            navigationController?.pushViewController(vc, animated: true)
            
        default:
            gotoAuthorizationView(vc: self)
        }
    }
    
    @objc func noticeSelect() {
        let alert = UIAlertController.init(title: nil, message: nil, preferredStyle: .actionSheet)
        
        for (index, item) in noticeDataArr.enumerated() {
            
            if noticeSelectedItem == index {
                let action = UIAlertAction.init(title: item, style: .destructive) { (ac) in
                    
                    self.data.remindTime = self.noticeDataArr[index]
                    //                    BXBNetworkTool.BXBRequest(router: .editAgenda(name: self.data.name, id: self.data.id, params: ["remindTime": self.data.remindTime]), success: { (resp) in
                    //
                    //                        self.isEditNotice = true
                    //                        self.tableView.reloadData()
                    //
                    //                    }, failure: { (error) in
                    //
                    //                    })
                    
                }
                alert.addAction(action)
            }
            else if index == noticeDataArr.endIndex - 1 {
                let action = UIAlertAction.init(title: item, style: .default) { (ac) in
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.25, execute: {
                        self.noticeCustomAlert()
                    })
                }
                alert.addAction(action)
            }
            else{
                let action = UIAlertAction.init(title: item, style: .default) { (ac) in
                    self.noticeSelectedItem = index
                    self.data.remindTime = self.noticeDataArr[index]
                    self.noticeLabel.text = self.noticeDataArr[index]
                    //                    BXBNetworkTool.BXBRequest(router: .editAgenda(name: self.data.name, id: self.data.id, params: ["remindTime": self.data.remindTime]), success: { (resp) in
                    //
                    //                        self.isEditNotice = true
                    //                        self.tableView.reloadData()
                    //
                    //                    }, failure: { (error) in
                    //
                    //                    })
                    
                }
                alert.addAction(action)
            }
            
        }
        
        let cacel = UIAlertAction.init(title: "取消", style: .cancel, handler: nil)
        alert.addAction(cacel)
        DispatchQueue.main.async {
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func noticeCustomAlert() {
        let alert = UIAlertController.init(title: "请输入自定义分钟数", message: nil, preferredStyle: .alert)
        let action = UIAlertAction.init(title: "确定", style: .default) { (ac) in
            if let tf = alert.textFields?.first {
                if tf.text != nil {
                    self.noticeLabel.text = "\(tf.text!)分钟前"
                    self.data.remindTime = "\(tf.text!)分钟前"
                    //                    BXBNetworkTool.BXBRequest(router: .editAgenda(name: self.data.name, id: self.data.id, params: ["remindTime": self.data.remindTime]), success: { (resp) in
                    //
                    //                        self.isEditNotice = true
                    //
                    //                    }, failure: { (error) in
                    //
                    //                    })
                }
            }
        }
        let cancel = UIAlertAction.init(title: "取消", style: .cancel, handler: nil)
        alert.addAction(action)
        alert.addAction(cancel)
        alert.addTextField { (tf) in
            tf.attributedPlaceholder = NSAttributedString.init(string: "请输入分钟数", attributes: [NSAttributedString.Key.font: kFont_text_3, NSAttributedString.Key.foregroundColor: kColor_subText!])
            tf.font = kFont_text_3
            tf.textColor = kColor_text
            tf.keyboardType = .numberPad
        }
        DispatchQueue.main.async {
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    //语音输入
    @objc func voiceInput() {
        
        view.endEditing(true)
        if remarkTV.text == "未设置" { remarkTV.text = nil }
        
        let rect = remarkContentView.convert(remarkTV.frame, to: view)
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.25) {
            if #available(iOS 10.0, *) {
                let speech = BXBSpeech.init(frame: CGRect.init(x: 0, y: 0, width: kScreenWidth, height: kScreenHeight), showHandle: {
                    
                    self.view.transform = CGAffineTransform.init(translationX: 0, y: (kScreenHeight - rect.origin.y - rect.height) - speechContentHeight - 30)
                    
                }, dismissHandle: {
                    UIView.animate(withDuration: 0.25) {
                        self.view.transform = CGAffineTransform.init(translationX: 0, y: 0)
                    }
                })
                
                UIApplication.shared.keyWindow?.addSubview(speech)
                
                speech.showSpeechView { (str) in
                    if (self.remarkTV.text + str).count > kRemarkTextLimitCount_1 {
                        self.view.makeToast("超出字数限制")
                        return
                    }
                    self.remarkTV.text = self.remarkTV.text + str
                    print("语音输入: \(str)")
                }
            } else {
                SVProgressHUD.showInfo(withStatus: "语音输入需要iOS 10以上的系统")
            }
        }
       
    }
    
    func gotoConfirm() {
        let vc = BXBAgendaFinishMatterVC()
        vc.data = data
        if data.visitTypeName == "增员" {
            vc.dataArr = ["增员面谈", "事业说明会", "面试", "入职培训"]
        }
        else if data.visitTypeName == "接洽" || data.visitTypeName == "面谈" || data.visitTypeName == "建议书" {
            vc.dataArr = ["开启面谈", "转介名单", "建议书", "签单", "保单服务"]
        }
        else if data.visitTypeName == "签单" {
            let vc = BXBAgendaDetailSigningVC()
            vc.data = data
            navigationController?.pushViewController(vc, animated: true)
            return
        }
//        else if data.visitTypeName == "客户服务" {
//            vc.dataArr = ["运动", "羽毛球", "吃饭", "美容", "健身", "娱乐", "旅游"]
//
//        }
        else{//保单服务 客户服务
            let vc = BXBAgendaDetailEditVC()
            vc.titleText = "说点什么吧..."
            vc.data = data
            vc.isNeedPopToRootVC = true
            navigationController?.pushViewController(vc, animated: true)
            return
        }
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func confirmAction(sender: UIButton) {
        
        if addressRemarkTF.hasText && (locationLabel.text == "请选择定位" || data.address == "" || data.lat == "" || data.lng == "") {
            view.makeToast("未设置主要位置")
            return
        }
        if data.isOldAgenda {//补录的日程
            gotoConfirm()
            return
        }
        
        sender.isUserInteractionEnabled = false
        let date = dateFormatter.date(from: data.visitDate) ?? dateFormatterStd.date(from: data.visitDate)
        if date == nil {
            sender.isUserInteractionEnabled = true
            return
        }
        let dateStr = dateFormatterStd.string(from: date!)
        //提醒时间
        let fireDate = BXBLocalizeNotification.getDateWithRemindName(name: data.remindTime, date: date!)
        let remindDate = fireDate == nil ? "" : dateFormatterStd.string(from: fireDate!)
        
        var args: [String: Any] = ["name": data.name, "visitDate": dateStr, "remindTime": data.remindTime, "address": data.address, "visitTepyName": data.visitTypeName, "remarks": data.remarks, "remindDate": remindDate, "latitude": data.lat, "longitude": data.lng, "unitAddress": addressRemarkTF.text ?? ""]
        
        var id = self.data.id
        if data.isOldAgenda == true { args["status"] = 1 }
        
        BXBNetworkTool.BXBRequest(router: .addNewAgenda(args: args), success: { (resp) in
            
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
            
            //add noti
            if self.data.isOldAgenda == false { id = resp["id"].intValue }
            BXBLocalizeNotification.sendLocalizeNotification(id: id, alertTitle: "日程提醒: 你有一条日程需要处理", alertBody: "\(self.data.visitDate)  \(self.data.visitTypeName)  \(self.data.name)", image: nil, fireDate: fireDate)
            
            NotificationCenter.default.post(name: .kNotiClientShouldRefreshData, object: nil)
            if self.data.isWorkData == true {
                NotificationCenter.default.post(name: .kNotiWorkDidFinishNotice, object: nil, userInfo: ["workNoticeId": self.data.noticeId])
            }
            
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.0, execute: {
                
                sender.isUserInteractionEnabled = true
                
                let d = self.data.formatter.date(from: self.data.visitDate) ?? Date()
                NotificationCenter.default.post(name: .kNotiAgendaShouldRefreshData, object: nil, userInfo: ["selectedDate": d])
                if let t = UIApplication.shared.keyWindow?.rootViewController {
                    
                    if t.isKind(of: BXBTabBarController.self) {
                        let tab = t as! BXBTabBarController
                        tab.selectedIndex = self.data.isWorkData ? 0 : 1
                    }
                }
                
                if self.navigationController != nil && self.navigationController!.viewControllers.count > 1 {
                    self.navigationController?.popToRootViewController(animated: true)
                }
                else {
                    self.dismiss(animated: true, completion: {
                        if self.isGoHeartPage == true {
                            NotificationCenter.default.post(name: .kNotiAddNewAgendaDismissWay, object: nil, userInfo: ["data": self.data, "title": "说点什么吧...", "isPopRoot": false])
                            
                        }
                        else{
                            NotificationCenter.default.post(name: .kNotiAddNewAgendaDismissWay, object: nil, userInfo: ["data": self.data, "title": "说点什么吧...", "isPopRoot": true])
                        }
                    })
                }
                
            })
            
        }) { (error) in
            sender.isUserInteractionEnabled = true
        }
    }
}




extension BXBAddNewAgendaStep_2_VC: YYTextViewDelegate {
    
    func textViewDidChange(_ textView: YYTextView) {
        
        if textView.hasText && textView.text.isIncludeEmoji {
            
            textView.text = textView.text!.filter({ (c) -> Bool in
                return String(c).isIncludeEmoji == false
            })
            return
        }
        
        if textView.text.count > kRemarkTextLimitCount_1 {
            let sub = textView.text.prefix(kRemarkTextLimitCount_1)
            textView.text = String(sub)
            view.makeToast("超出字数限制")
            return
        }
        let s1 = "\(textView.text.count)"
        let s2 = "/\(kRemarkTextLimitCount_1)"
        let att = NSMutableAttributedString.init(string: s1 + s2)
        att.addAttributes([NSAttributedString.Key.font: kFont_text_3, NSAttributedString.Key.foregroundColor: kColor_theme!], range: NSMakeRange(0, s1.count))
        att.addAttributes([NSAttributedString.Key.font: kFont_text_3, NSAttributedString.Key.foregroundColor: kColor_subText!], range: NSMakeRange(s1.count, s2.count))
        remarkCountLabel.attributedText = att
        data.remarks = textView.text ?? ""
    }
}

//MARK: - SelectedLocationDelegate
extension BXBAddNewAgendaStep_2_VC: SelectedLocationDelegate {
    
    func didSelectedAddress(poi: AMapPOI) {
        
        locationLabel.font = kFont_text_2_weight
        locationLabel.textColor = kColor_dark
        locationLabel.text = poi.name
        data.lat = "\(poi.location.latitude)"
        data.lng = "\(poi.location.longitude)"
        data.address = poi.name
    }
    
}
