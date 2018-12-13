//
//  AddNewAgendaStep_1_delegate.swift
//  BXB
//
//  Created by equalriver on 2018/8/24.
//  Copyright © 2018年 tobosoft. All rights reserved.
//

import Foundation
import Contacts
import ObjectMapper

//MARK: - action
extension BXBAddNewAgendaStep_1_VC {
    
    //MARK: - name text field
    @objc func nameTextFieldEditChange(sender: UITextField) {
        
        if sender.hasText {
            
            guard sender.markedTextRange == nil else { return }
            if sender.text!.count > kNameTextLimitCount {
                view.makeToast("超出字数限制")
                sender.text = String(sender.text!.prefix(kNameTextLimitCount))
                return
            }
            if searchDatas.count > 0 {
                searchFilterDatas = searchDatas.filter { (obj) -> Bool in
                    return obj.contains(sender.text!)
                }
                if searchFilterDatas.count > 0 {
                    searchTV.isHidden = false
                    searchTV.reloadData()
                    view.bringSubviewToFront(searchTV)
                    let h = CGFloat(searchFilterDatas.count) * 40 * KScreenRatio_6 > 160 * KScreenRatio_6 ? 160 * KScreenRatio_6 : CGFloat(searchFilterDatas.count) * 40 * KScreenRatio_6
                    searchShadow.snp.updateConstraints { (make) in
                        make.height.equalTo(h)
                    }
                    searchTV.snp.updateConstraints { (make) in
                        make.height.equalTo(h)
                    }
                }
            }
        }
        else { searchTV.isHidden = true }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        searchTV.isHidden = true
    }
   
    
    //MARK: -
    //初始化 & 拼接 时间
    func createFullDate() {
        let currentCa = NSCalendar.current
        
        let dateStrings = dateFormatterStd.string(from: selectDate ?? Date()).components(separatedBy: " ")
        guard dateStrings.count == 2 else { return }
        
        let ymd = dateStrings.first!
        
        guard let hm = dateFormatterStd.string(from: Date()).components(separatedBy: " ").last else { return }
        
        let date = ymd + " " + hm
        
        let com = currentCa.dateComponents([.minute], from: dateFormatterStd.date(from: date) ?? Date())
        
        let ca = NSCalendar.init(calendarIdentifier: .gregorian)
        var comps = DateComponents.init()
        
        guard com.minute != nil else { return }
        comps.setValue(60 - com.minute!, for: .minute)
        
        if let d = ca?.date(byAdding: comps, to: dateFormatterStd.date(from: date) ?? Date(), options: NSCalendar.Options(rawValue: 0)) {
            selectedDate = d
            data.visitDate = dateFormatterStd.string(from: d)
            timeLabel.text = dateFormatter.string(from: d)
            datePicker.setDate(d, animated: false)
        }
    }
    
    @objc func dateChanged(sender: UIDatePicker) {
        timeLabel.text = dateFormatter.string(from: sender.date)
        data.visitDate = dateFormatterStd.string(from: sender.date)
        selectedDate = sender.date
    }
    
    //跳转联系人
    @objc func gotoContact() {
        
        let status = CNContactStore.authorizationStatus(for: .contacts)
        
        switch status {
            
        case .notDetermined:
            let store = CNContactStore()
            store.requestAccess(for: .contacts) { (finish, error) in
                
                DispatchQueue.main.async {
                    if error == nil {
                        let vc = BXBContactsVC.init { (contactData) in
                            
                            self.nameTF.text = contactData.name
                        }
                        vc.isAgendaSelected = true
                        self.navigationController?.pushViewController(vc, animated: true)
                        
                    }
                    else { gotoAuthorizationView(vc: self) }
                }
            }
            
        case .authorized:
            let vc = BXBContactsVC.init { (contactData) in
                
                self.nameTF.text = contactData.name
            }
            vc.isAgendaSelected = true
            self.navigationController?.pushViewController(vc, animated: true)
            
        default:
            gotoAuthorizationView(vc: self)
        }
        
    }
    
    @objc func checkAction() {
        checkBtn.isSelected = !checkBtn.isSelected
        confirmBtn.setTitle(checkBtn.isSelected == true ? "下一步" : "完成", for: .normal)
        confirmBtn.setImage(checkBtn.isSelected == true ? #imageLiteral(resourceName: "bxb_btn下一步") : #imageLiteral(resourceName: "bxb_btn完成"), for: .normal)
    }
    
    //date picker
    @objc func datePickerAlert() {
        let datePicker = AgendaDetailDatePickerAlert.init(frame: CGRect.init(x: 0, y: 0, width: kScreenWidth, height: kScreenHeight)) { [unowned self](date) in
            
            self.data.visitDate = date
            if let d = self.dateFormatterStd.date(from: date){
                self.timeLabel.text = self.dateFormatter.string(from: d)
            }
            
        }
        view.addSubview(datePicker)
    }
    
    func checkNoticeDate() -> Bool {
        //选择小于当前的时间点
        if dateFormatter.date(from: data.visitDate) == nil && dateFormatterStd.date(from: data.visitDate) == nil { return false }
        let date = dateFormatter.date(from: data.visitDate) ?? dateFormatterStd.date(from: data.visitDate)!
        if date.compare(Date()) == .orderedAscending {
            let alert = UIAlertController.init(title: nil, message: "当前时间大于您选择的时间，这是一个已完成的日程么?", preferredStyle: .alert)
            let action = UIAlertAction.init(title: "是", style: .default) { (ac) in
                
                self.data.isOldAgenda = true
                if self.checkBtn.isSelected {
                    let vc = BXBAddNewAgendaStep_2_VC()
                    vc.data = self.data
                    self.navigationController?.pushViewController(vc, animated: true)
                }
                else { self.gotoConfirm() }
                
            }
            let cancel = UIAlertAction.init(title: "否", style: .cancel, handler: nil)
            alert.addAction(action)
            alert.addAction(cancel)
            DispatchQueue.main.async {
                self.present(alert, animated: true, completion: nil)
            }
            return false
        }
        return true
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
        
        if nameTF.hasText == false {
            view.makeToast("请输入客户姓名")
            return
        }
        if type == "客户服务" {
            guard matterTF.hasText else {
                view.makeToast("请输入事项")
                return
            }
            data.matter = matterTF.text!
        }
        data.name = nameTF.text!
        if checkNoticeDate() == false { return }
        
        if checkBtn.isSelected {
            let vc = BXBAddNewAgendaStep_2_VC()
            vc.data = data
            navigationController?.pushViewController(vc, animated: true)
        }
        else {
            
            guard let date = dateFormatterStd.date(from: data.visitDate) else { return }
            
//            let dateStr = dateFormatterStd.string(from: date)
            
            //提醒时间
            let fireDate = BXBLocalizeNotification.getDateWithRemindName(name: "日程开始时", date: date)
            
            BXBNetworkTool.BXBRequest(router: .addNewAgenda(args: ["name": data.name,
                                                                   "matter": data.matter,
                                                                   "visitDate": data.visitDate,
                                                                   "visitTepyName": data.visitTypeName,
                                                                   "remindTime": "日程开始时",
                                                                   "remindDate": data.visitDate,
                                                                   "address": data.address,
                                                                   "latitude": data.lat,
                                                                   "longitude": data.lng,
                                                                   "unitAddress": data.detailAddress]), success: { (resp) in
                                                                    
                
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
                                                                    
                BXBLocalizeNotification.sendLocalizeNotification(id: id, alertTitle: "日程提醒: 你有一条日程需要处理", alertBody: "\(self.data.visitDate)  \(self.data.visitTypeName)  \(self.data.name)", image: nil, fireDate: fireDate)
                NotificationCenter.default.post(name: .kNotiClientShouldRefreshData, object: nil)
                NotificationCenter.default.post(name: .kNotiAgendaShouldRefreshData, object: nil, userInfo: ["selectedDate": self.dateFormatterStd.date(from: self.data.visitDate)!])
                if self.data.isWorkData == true {
                    NotificationCenter.default.post(name: .kNotiWorkDidFinishNotice, object: nil, userInfo: ["workNoticeId": self.data.noticeId])
                }
                self.navigationController?.popViewController(animated: true)
                
            }) { (error) in
                
            }
            
        }
    }
}


//MARK: - search table view
extension BXBAddNewAgendaStep_1_VC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchFilterDatas.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 38 * KScreenRatio_6
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCell") as? BXBBaseTableViewCell
        if cell == nil {
            cell = BXBBaseTableViewCell.init(style: .default, reuseIdentifier: "UITableViewCell")
        }
        if indexPath.row == searchFilterDatas.count - 1 { cell?.isNeedSeparatorView = false }
        cell?.selectionStyle = .none
        cell?.textLabel?.text = searchFilterDatas[indexPath.row]
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        nameTF.text = searchFilterDatas[indexPath.row]
        searchTV.isHidden = true
    }
}

//MARK: - collection view
extension BXBAddNewAgendaStep_1_VC: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return matters.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BXBAddNewAgendaStep_1_CVCell", for: indexPath) as! BXBAddNewAgendaStep_1_CVCell
        cell.titleLabel.text = matters[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        data.matter = matters[indexPath.item]
        matterTF.text = data.matter
    }
}

//MARK: - 筛选联系人
extension BXBAddNewAgendaStep_1_VC {
    
    func filterContact() {
        
        DispatchQueue.global().async {
            
            //打开本地联系人
            self.openContact()
            
            var clients = Array<ClientData>()
            
            //获取本地保存的远程联系人
            let data: [Data]? = NSKeyedUnarchiver.unarchiveObject(withFile: kClientDataFilePath) as? [Data]
            if data == nil {
                
                self.loadData(handle: { (nameArr) in
                    self.remoteClientNameArr = nameArr
                })
                self.compareContact()
                
            }
            else {
                clients = data!.map({ (obj) -> ClientData in
                    return NSKeyedUnarchiver.unarchiveObject(with: obj) as! ClientData
                })
                self.remoteClientNameArr = clients.map({ (obj) -> String in
                    return obj.name
                })
                self.compareContact()
            }
        }
        
    }
    
    //对比远程和本地的联系人
    func compareContact() {
        
        //合并远程和本地
        for v in remoteClientNameArr {
            searchDatas.insert(v)
        }
        
        
        for v in self.dataArr {
            
            searchDatas.insert(v.name)
            
//            for j in self.remoteClientNameArr {
//                if v.name == j {
//                    self.dataArr[i].status = 1
//                    searchDatas = searchDatas.filter { (s) -> Bool in
//                        return s != j
//                    }
//                }
//            }
        }

        searchDatas = searchDatas.filter({ (str) -> Bool in
            return str.count > 0
        })
        
    }
    
    
    //打开本地联系人
    func openContact() {
        // 获取指定的字段,并不是要获取所有字段，需要指定具体的字段
        let keysToFetch = [CNContactGivenNameKey, CNContactFamilyNameKey, CNContactPhoneNumbersKey]
        let fetchRequest = CNContactFetchRequest.init(keysToFetch: keysToFetch as [CNKeyDescriptor])
        let contactStore = CNContactStore.init()
        
        do {
            try contactStore.enumerateContacts(with: fetchRequest, usingBlock: { (contact, stop) in
                let name = contact.familyName + contact.givenName
                let phone = contact.phoneNumbers.first?.value
                let d = ClientContactData()
                d.name = name
                d.phone = phone?.stringValue ?? ""
                self.dataArr.append(d)
            })
        } catch {
            
        }
        
    }
    
    //MARK: - network
    //获取客户列表
    func loadData(handle: @escaping (_ names: [String]) -> Void) {
        
        BXBNetworkTool.BXBRequest(router: .clientFilter(remind: "", isWrite: "", matter: ""), success: { (resp) in
            
            DispatchQueue.global().async {
                
                if let data = Mapper<ClientData>().mapArray(JSONObject: resp["data"].arrayObject){
                    
                    handle(data.map({ (obj) -> String in
                        return obj.name
                    }))
                }
            }
            
        }) { (error) in
            
        }
        
    }
}



















