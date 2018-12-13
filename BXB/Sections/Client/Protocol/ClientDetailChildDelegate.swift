
//
//  ClientDetailChildDelegate.swift
//  BXB
//
//  Created by equalriver on 2018/8/28.
//  Copyright © 2018年 tobosoft. All rights reserved.
//

import Foundation
import ObjectMapper

//MARK: - 提醒事项
extension ClientDetailNoticeVC {
    
    // 添加提醒 or 取消
    @objc func addNotice(sender: UIButton) {

        editTranslationState = .normal
        
        if state == .normal {//添加提醒
            
            let arr: Array<ClientItemStyle> = [.birthday, .memorial, .baodan, .other]
            let alert = UIAlertController.init(title: nil, message: nil, preferredStyle: .actionSheet)
            for obj in arr {
                let ac = UIAlertAction.init(title: obj.description(), style: .default) { (action) in
                    let d = ClientDetailNoticeData()
                    d.cellType = .edit
                    d.matterId = obj.descriptionForID()
                    d.matter = obj.description()
                    d.time = self.dateFormatterYMD.string(from: Date())
                    d.remindTime = ClientDetailNoticeTimeType.oneWeek.descrption()
                    d.indexPath = IndexPath.init(row: 0, section: 0)
                    self.noticeArr.insert(d, at: 0)
                    
                    DispatchQueue.main.async {
                        self.state = .add
                        self.tableView.insertRow(at: IndexPath.init(row: 0, section: 0), with: .automatic)
                        self.tableView.scrollToRow(at: IndexPath.init(row: 0, section: 0), at: .top, animated: true)
                        self.tableView.stateNormal()
                        
                    }
                }
                alert.addAction(ac)
            }
            let cancel = UIAlertAction.init(title: "取消", style: .cancel, handler: nil)
            alert.addAction(cancel)
            DispatchQueue.main.async {
                self.present(alert, animated: true, completion: nil)
            }
            return
        }
        if state == .add {//取消添加
            
            let hasEdit = noticeArr.enumerated().contains { (offset, element) -> Bool in
                return element.cellType == ClientDetailCellType.edit
            }
            if hasEdit {
                self.state = .normal
                noticeArr.removeFirst()
                tableView.deleteRow(at: IndexPath.init(row: 0, section: 0), with: .none)
                if noticeArr.count == 0 {
                    self.tableView.stateEmpty(title: "暂时没有提醒事项", img: #imageLiteral(resourceName: "client_null_提醒事项"), buttonTitle: nil, handle: nil)
                }
            }
            return
        }
        if state == .edit {//取消编辑
            state = .normal
            editTranslationState = .pop
            tableView.reloadData()
        }
    }
    
    // 编辑 or 确认
    @objc func editNotice(sender: UIButton) {
        
        editTranslationState = .normal
        
        if state == .add {//确认添加
            
            let group = DispatchGroup()
            let ca = NSCalendar.init(calendarIdentifier: .gregorian)
            
            sender.isUserInteractionEnabled = false
            
            for item in self.noticeArr {
                if item.cellType == .edit {
                    guard item.remindName.count > 0 else {
                        view.makeToast("未填写备注")
                        return
                    }
                    guard let d = dateFormatterYMD.date(from: item.time) else { break }
                    guard let remindDate = BXBLocalizeNotification.getDateWithRemindName(name: item.remindTime, date: d) else { return }
                    
                    if item.matter == ClientItemStyle.baodan.description() || item.matter == ClientItemStyle.other.description() {
                        
                        if ca != nil {
                            if ca!.isDateInToday(remindDate) == false && remindDate.compare(Date()) == .orderedAscending {
                                view.makeToast("提醒或时间设置到过去的时间了")
                                return
                            }
                        }
                    }
                    
                    //线程同步并发
                    group.enter()
                    
                    let param = [[
                        "token" : UserDefaults.standard.object(forKey: "token") ?? "",
                        "clientId" : self.clientId,
                        "matterId" : item.matterId,
                        "matter" : item.matter,
                        "remindId" : item.remindId,
                        "remindName" : item.remindName,
                        "time" : item.time,
                        "remindDate" : dateFormatterYMD.string(from: remindDate),
                        "remindTime" : item.remindTime]]
                    
                    DispatchQueue.global().async(group: group, execute: DispatchWorkItem.init(block: {
                        BXBNetworkTool.isShowSVProgressHUD = false
                        BXBNetworkTool.BXBRequest(router: .addClientNotice(client: param), success: { (resp) in
                            //修改状态
                            item.cellType = .normal
                            group.leave()
                            
                        }, failure: { (error) in
                            group.leave()
                        })
                    }))
                }
            }
            
            group.notify(queue: DispatchQueue.global(), execute: {
                BXBNetworkTool.BXBRequest(router: .clientNoticeList(id: self.clientId), success: { (resp) in
                    
                    sender.isUserInteractionEnabled = true
                    
                    if let d = Mapper<ClientDetailNoticeData>().mapArray(JSONObject: resp["data"].arrayObject){
                        self.noticeArr.removeAll()
                        self.noticeArr = d
                        NotificationCenter.default.post(name: .kNotiAgendaShouldRefreshData, object: nil)
                        NotificationCenter.default.post(name: .kNotiClientShouldRefreshData, object: nil)
                        NotificationCenter.default.post(name: .kNotiRemindShouldRefreshData, object: nil)
                        self.tableView.stateNormal()
                        self.tableView.reloadData()
                        self.state = .normal
                    }
                    
                }, failure: { (error) in
                    sender.isUserInteractionEnabled = true
                })
            })
            return
        }
        
        if state == .edit {//确认编辑
            state = .normal
            editTranslationState = .pop
            tableView.reloadData()
            return
        }
        if state == .normal {//开始编辑
            state = .edit
            editTranslationState = .push
            tableView.reloadData()
            return
        }
        
    }
    
    ///添加提醒alert
    func noticeAction(array: Array<String>, callback: @escaping(_ day: String) -> Void) {
        let alert = UIAlertController.init(title: nil, message: nil, preferredStyle: .actionSheet)
        
        for item in array {
            let action = UIAlertAction.init(title: item, style: .default) { (ac) in
                if item == "自定义" {
                    self.noticeCustomAlert { (str) in
                        callback(str)
                    }
                }
                else { callback(item) }
                
            }
            
            alert.addAction(action)
        }
        
        let cacel = UIAlertAction.init(title: "取消", style: .cancel, handler: nil)
        alert.addAction(cacel)
        DispatchQueue.main.async {
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func noticeCustomAlert(callback: @escaping(_ day: String) -> Void) {
        let alert = UIAlertController.init(title: "请输入自定义天数", message: nil, preferredStyle: .alert)
        let action = UIAlertAction.init(title: "确定", style: .default) { (ac) in
            if let tf = alert.textFields?.first {
                if tf.hasText {
                    guard Int(tf.text!) != nil else { return }
                    callback(Int(tf.text!) == 0 ? "当天" : "提前\(tf.text!)天提醒")
                }
            }
        }
        let cancel = UIAlertAction.init(title: "取消", style: .cancel, handler: nil)
        alert.addAction(action)
        alert.addAction(cancel)
        alert.addTextField { (tf) in
            tf.attributedPlaceholder = NSAttributedString.init(string: "请输入天数", attributes: [NSAttributedString.Key.font: kFont_text_3, NSAttributedString.Key.foregroundColor: kColor_subText!])
            tf.font = kFont_text_3
            tf.textColor = kColor_text
            tf.keyboardType = .numberPad
            tf.addBlock(for: .editingChanged, block: { (t) in
                if tf.hasText { tf.text = String(tf.text!.prefix(3)) }
            })
        }
        DispatchQueue.main.async {
            self.present(alert, animated: true, completion: nil)
        }
    }
}


extension ClientDetailNoticeVC: ClientDetailNoticeDelegate {
    //MARK: - notice delegate
    func didClickNormalNoticeDelete(cell: UITableViewCell) {
        
        if let indexPath = tableView.indexPath(for: cell) {
            
            let alert = UIAlertController.init(title: nil, message: "确定删除该提醒吗?", preferredStyle: .alert)
            let action = UIAlertAction.init(title: "删除", style: .destructive) { (ac) in
                BXBNetworkTool.BXBRequest(router: .deleteClientNotice(id: self.noticeArr[indexPath.row].id), success: { (resp) in
                    self.noticeArr.remove(at: indexPath.row)
                    self.tableView.deleteRow(at: indexPath, with: .none)
                    if self.noticeArr.count == 0 {
                        self.tableView.stateEmpty(title: "暂时没有提醒事项", img: #imageLiteral(resourceName: "client_null_提醒事项"), buttonTitle: nil, handle: nil)
                    }
                    NotificationCenter.default.post(name: .kNotiClientShouldRefreshData, object: nil)
                    NotificationCenter.default.post(name: .kNotiAgendaShouldRefreshData, object: nil, userInfo: nil)
                    NotificationCenter.default.post(name: .kNotiRemindShouldRefreshData, object: nil, userInfo: nil)
                    
                }) { (error) in
                    
                }
            }
            let cancel = UIAlertAction.init(title: "取消", style: .cancel, handler: nil)
            alert.addAction(action)
            alert.addAction(cancel)
            DispatchQueue.main.async {
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
}


extension ClientDetailNoticeVC: ClientDetailNoticeEditDelegate {
    //MARK: - notice edit delegate
    //提醒类型
    func didClickEditNoticeType(cell: UITableViewCell, callback: @escaping (ClientItemStyle) -> Void) {
        let arr: Array<ClientItemStyle> = [.birthday, .memorial, .baodan, .other]
        let alert = UIAlertController.init(title: nil, message: nil, preferredStyle: .actionSheet)
        for obj in arr {
            let ac = UIAlertAction.init(title: obj.description(), style: .default) { (action) in
                
                if let indexPath = self.tableView.indexPath(for: cell) {
                    
                    for item in self.noticeArr {
                        guard item.indexPath != nil else { continue }
                        if item.indexPath == indexPath {
                            item.matter = obj.description()
                            callback(obj)
                        }
                    }
                }
            }
            alert.addAction(ac)
        }
        let cancel = UIAlertAction.init(title: "取消", style: .cancel, handler: nil)
        alert.addAction(cancel)
        DispatchQueue.main.async {
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    //备注
    func editNoticeRemarksTextFieldValueChange(cell: UITableViewCell, text: String) {
        
        guard let indexPath = self.tableView.indexPath(for: cell) else { return }
        
        for item in self.noticeArr {
            guard item.indexPath != nil else { continue }
            if item.indexPath == indexPath {
                item.remindName = text
            }
        }

    }
    
    //时间
    func didClickEditNoticeTimeDetail(cell: UITableViewCell, callback: @escaping (String) -> Void) {
        if let indexPath = self.tableView.indexPath(for: cell) {
            
            for item in self.noticeArr {
                guard item.indexPath != nil else { continue }
                if item.indexPath == indexPath {
                    let datePicker = AgendaDetailDatePickerAlert.init(frame: CGRect.init(x: 0, y: 0, width: kScreenWidth, height: kScreenHeight)) { (date) in
                        
                        item.time = date
                        callback(date)
                    }
                    datePicker.datePicker.datePickerMode = .date
                    datePicker.dateFormatter.dateFormat = "yyyy-MM-dd"
                    UIApplication.shared.keyWindow?.addSubview(datePicker)
                }
            }
        }
    }
    
    //提醒
    func didClickEditNoticeDetail(cell: UITableViewCell, callback: @escaping (String) -> Void) {
        if let indexPath = self.tableView.indexPath(for: cell) {
            
            for item in self.noticeArr {
                guard item.indexPath != nil else { continue }
                if item.indexPath == indexPath {
                    noticeAction(array: [ClientDetailNoticeTimeType.today.descrption(),
                                         ClientDetailNoticeTimeType.oneDay.descrption(),
                                         ClientDetailNoticeTimeType.twoDay.descrption(), ClientDetailNoticeTimeType.threeDay.descrption(), ClientDetailNoticeTimeType.oneWeek.descrption(), ClientDetailNoticeTimeType.custom.descrption()]) { (str) in
                                            item.remindTime = str
                                            callback(str)
                    }
                }
            }
        }
    }
    
    
}


extension ClientDetailNoticeVC: UITableViewDataSource, UITableViewDelegate {
    //MARK: - table view
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return noticeArr.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if noticeArr[indexPath.row].cellType == .normal { return 60 * KScreenRatio_6 }
        if noticeArr[indexPath.row].cellType == .edit { return 3 * 55 * KScreenRatio_6 }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if noticeArr[indexPath.row].cellType == .normal {
            var cell = tableView.dequeueReusableCell(withIdentifier: "BXBClientDetailNoticeCell") as? BXBClientDetailNoticeCell
            if cell == nil {
                cell = BXBClientDetailNoticeCell.init(style: .default, reuseIdentifier: "BXBClientDetailNoticeCell")
            }
            cell?.data = noticeArr[indexPath.row]
            cell?.delegate = self
            return cell!
        }
        else{//编辑样式
            var cell = tableView.dequeueReusableCell(withIdentifier: "BXBClientDetailNoticeEditCell") as? BXBClientDetailNoticeEditCell
            if cell == nil {
                cell = BXBClientDetailNoticeEditCell.init(style: .default, reuseIdentifier: "BXBClientDetailNoticeEditCell")
            }
            cell?.data = noticeArr[indexPath.row]
            cell?.delegate = self
            return cell!
        }

    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        if let c = cell as? BXBClientDetailNoticeCell {
            if editTranslationState == .push {
                UIView.animate(withDuration: 0.25) {
                    c.transformContentView.transform = CGAffineTransform.init(translationX: 40 * KScreenRatio_6, y: 0)
                }
            }
            else {
                UIView.animate(withDuration: 0.25) {
                    c.transformContentView.transform = CGAffineTransform.init(translationX: 0, y: 0)
                }
            }
        }
        
    }
}

//MARK: - 互动记录
extension ClientDetailRecordVC: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recordArr.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60 * KScreenRatio_6
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "BXBClientDetailRecordCell") as? BXBClientDetailRecordCell
        if cell == nil {
            cell = BXBClientDetailRecordCell.init(style: .default, reuseIdentifier: "BXBClientDetailRecordCell")
        }
        cell?.data = recordArr[indexPath.row]
        return cell!
    }
    
}


//MARK: - 花费记录
extension ClientDetailCostVC {
    
    @objc func addCost(sender: UIButton) {
        editTranslationState = .normal
        
        if state == .normal {//添加花费
            self.state = .add
            let d = ClientDetailMaintainData()
            d.cellType = .edit
            d.spentDate = self.dateFormatterYMD.string(from: Date())
            d.indexPath = IndexPath.init(row: 0, section: 0)
            self.maintainArr.insert(d, at: 0)
            
            tableView.insertRow(at: IndexPath.init(row: 0, section: 0), with: .automatic)
            tableView.scrollToRow(at: IndexPath.init(row: 0, section: 0), at: .top, animated: true)
            tableView.stateNormal()
            return
        }
        
        if state == .add {//取消添加
            
            let hasEdit = maintainArr.enumerated().contains { (offset, element) -> Bool in
                return element.cellType == ClientDetailCellType.edit
            }
            if hasEdit {
                self.state = .normal
                maintainArr.removeFirst()
                tableView.deleteRow(at: IndexPath.init(row: 0, section: 0), with: .none)
                if maintainArr.count == 0 {
                    tableView.stateEmpty(title: "暂时没有花费记录", img: #imageLiteral(resourceName: "client_null_花费记录"), buttonTitle: nil, handle: nil)
                }
            }
            return
        }
        
        if state == .edit {//取消编辑
            state = .normal
            editTranslationState = .pop
            tableView.reloadData()
            return
        }
    }
    
    @objc func editCost(sender: UIButton) {
        editTranslationState = .normal
        
        if state == .add {//确认添加
            
            let group = DispatchGroup()
            
            sender.isUserInteractionEnabled = false
            
            for item in self.maintainArr {
                if item.cellType == .edit {
                    if item.content.count == 0 {
                        self.view.makeToast("未填写具体事项")
                        return
                    }
                    //线程同步并发
                    group.enter()
                    let param = [[//name: String, content: String, spentDate: String, spentMoney: Int, remarks: String
                        "token" : UserDefaults.standard.object(forKey: "token") ?? "",
                        "clientId" : self.clientId,
                        "content" : item.content,
                        "spentDate" : item.spentDate,
                        "spentMoney" : item.spentMoney,
                        "remarks" : item.remarks]]
                    DispatchQueue.global().async(group: group, execute: DispatchWorkItem.init(block: {
                        BXBNetworkTool.isShowSVProgressHUD = false
                        BXBNetworkTool.BXBRequest(router: .addClientMaintain(maintain: param), success: { (resp) in
                            //修改状态
                            item.cellType = .normal
                            group.leave()
                            
                        }, failure: { (error) in
                            group.leave()
                        })
                    }))
                }
                
            }
            group.notify(queue: DispatchQueue.global(), execute: {
                BXBNetworkTool.BXBRequest(router: .clientMaintainList(id: self.clientId), success: { (resp) in
                    
                    sender.isUserInteractionEnabled = true
                    
                    if let ss = resp["spendSum"].int { self.spendSum = ss }
                    if let d = Mapper<ClientDetailMaintainData>().mapArray(JSONObject: resp["data"].arrayObject){
                        self.maintainArr.removeAll()
                        self.maintainArr = d
                        self.tableView.stateNormal()
                        self.tableView.reloadData()
                        self.state = .normal
                    }
                }, failure: { (error) in
                    sender.isUserInteractionEnabled = true
                })
            })
            return
        }
        
        if state == .edit {//确认编辑
            state = .normal
            editTranslationState = .pop
            tableView.reloadData()
            return
        }
        if state == .normal {//开始编辑
            state = .edit
            editTranslationState = .push
            tableView.reloadData()
            return
        }
    }
    
    
}


extension ClientDetailCostVC: ClientDetailMaintainDelegate {
    //MARK: - maintain delegate
    //删除花费
    func didClickNormalMaintainDelete(cell: UITableViewCell) {
        
        if let indexPath = tableView.indexPath(for: cell) {
            
            let alert = UIAlertController.init(title: nil, message: "确定删除该花费记录吗？", preferredStyle: .alert)
            let action = UIAlertAction.init(title: "删除", style: .destructive) { (ac) in
                BXBNetworkTool.BXBRequest(router: .deleteClientMaintain(id: self.maintainArr[indexPath.row].id, clientId: self.clientId), success: { (resp) in
                    
                    if let ss = resp["spendSum"].int { self.spendSum = ss }
                    
                    self.maintainArr.remove(at: indexPath.row)
                    self.tableView.deleteRow(at: indexPath, with: .none)
                    if self.maintainArr.count == 0 {
                        self.tableView.stateEmpty(title: "暂时没有花费记录", img: #imageLiteral(resourceName: "client_null_花费记录"), buttonTitle: nil, handle: nil)
                    }
                    self.tableView.reloadData()
                    
                }) { (error) in
                    
                }
            }
            let cancel = UIAlertAction.init(title: "取消", style: .cancel, handler: nil)
            alert.addAction(action)
            alert.addAction(cancel)
            DispatchQueue.main.async {
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
}


extension ClientDetailCostVC: ClientDetailMaintainEditDelegate {
    //MARK: - maintain edit delegate
    //编辑事项
    func didClickEditMaintainType(cell: UITableViewCell, sender: UITextField) {
        
        if sender.hasText && sender.text!.isIncludeEmoji {
            sender.text = sender.text!.filter({ (c) -> Bool in
                return String(c).isIncludeEmoji == false
            })
            return
        }
        if let indexPath = self.tableView.indexPath(for: cell){
            for item in self.maintainArr {
                guard item.indexPath != nil else { continue }
                if item.indexPath == indexPath {
                    item.content = sender.text ?? ""
                }
            }
        }

    }
    
    //编辑备注
    func editMaintainRemarksTextFieldValueChange(cell: UITableViewCell, sender: UITextField) {
        
        if sender.hasText && sender.text!.isIncludeEmoji {
            sender.text = sender.text!.filter({ (c) -> Bool in
                return String(c).isIncludeEmoji == false
            })
            return
        }
        if sender.hasText && sender.text!.isAllNumber == false {
            view.makeToast("请输入数字")
            sender.text = sender.text!.filter({ (c) -> Bool in
                return String(c).isAllNumber
            })
            return
        }
        
        if sender.hasText {
            if let num = Int(sender.text!) {
                if num < 0 {
                    view.makeToast("不能输入负数")
                    sender.text = String(sender.text!.prefix(sender.text!.count - 1))
                    return
                }
            }
            if let indexPath = self.tableView.indexPath(for: cell) {
                
                for item in self.maintainArr {
                    guard item.indexPath != nil else { continue }
                    if item.indexPath == indexPath {
                        item.spentMoney = Int(sender.text!) ?? 0
                    }
                }
            }
        }
    }
    
    //编辑时间
    func didClickEditMaintainTimeDetail(cell: UITableViewCell, callback: @escaping (String) -> Void) {
        if let indexPath = self.tableView.indexPath(for: cell){
            for item in self.maintainArr {
                guard item.indexPath != nil else { continue }
                if item.indexPath == indexPath {
                    let datePicker = AgendaDetailDatePickerAlert.init(frame: CGRect.init(x: 0, y: 0, width: kScreenWidth, height: kScreenHeight)) { (date) in
                        
                        var d = ""
                        
                        if date.contains(" ") {
                            d = date.components(separatedBy: " ").first!
                        }
                        else {
                            d = date
                        }
                        item.spentDate = d
                        callback(d)
                    }
                    datePicker.datePicker.datePickerMode = .date
                    UIApplication.shared.keyWindow?.addSubview(datePicker)
                }
            }
        }
    }
}

extension ClientDetailCostVC: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return maintainArr.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if maintainArr[indexPath.row].cellType == .normal { return 60 * KScreenRatio_6 }
        else { return 110 * KScreenRatio_6 }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60 * KScreenRatio_6
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if maintainArr[indexPath.row].cellType == .normal {
            var cell = tableView.dequeueReusableCell(withIdentifier: "BXBClientDetailMaintainCell") as? BXBClientDetailMaintainCell
            if cell == nil {
                cell = BXBClientDetailMaintainCell.init(style: .default, reuseIdentifier: "BXBClientDetailMaintainCell")
            }
            cell?.data = maintainArr[indexPath.row]
            cell?.delegate = self
            return cell!
        }
        else{
            var cell = tableView.dequeueReusableCell(withIdentifier: "BXBClientDetailMaintainEditCell") as? BXBClientDetailMaintainEditCell
            if cell == nil {
                cell = BXBClientDetailMaintainEditCell.init(style: .default, reuseIdentifier: "BXBClientDetailMaintainEditCell")
            }
            cell?.delegate = self
            return cell!
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let v = UIView.init(frame: CGRect.init(x: 0, y: 0, width: tableView.width, height: 60 * KScreenRatio_6 - 1))
        v.backgroundColor = UIColor.white
        
        let sep = UIView.init(frame: CGRect.init(x: 0, y: 60 * KScreenRatio_6 - 1, width: tableView.width, height: 0.5))
        sep.backgroundColor = kColor_separatorView
        v.addSubview(sep)
        
        let titleLabel = UILabel()
        titleLabel.font = kFont_text_weight
        titleLabel.textColor = kColor_theme
        titleLabel.text = "共计"
        v.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.width.equalTo(100 * KScreenRatio_6)
            make.height.centerY.equalTo(v)
            make.left.equalTo(v).offset(15 * KScreenRatio_6)
        }
        
        let countLabel = UILabel()
        countLabel.font = kFont_text_weight
        countLabel.textColor = kColor_theme
        countLabel.textAlignment = .right
        countLabel.text = "\(spendSum)元"
        v.addSubview(countLabel)
        countLabel.snp.makeConstraints { (make) in
            make.height.centerY.equalTo(v)
            make.left.equalTo(titleLabel.snp.right).offset(20)
            make.right.equalTo(v).offset(-15 * KScreenRatio_6)
        }
        return v
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        if let c = cell as? BXBClientDetailMaintainCell {
            if editTranslationState == .push {
                UIView.animate(withDuration: 0.25) {
                    c.transformContentView.transform = CGAffineTransform.init(translationX: 40 * KScreenRatio_6, y: 0)
                }
            }
            else {
                UIView.animate(withDuration: 0.25) {
                    c.transformContentView.transform = CGAffineTransform.init(translationX: 0, y: 0)
                }
            }
        }
        
    }
    
}



















