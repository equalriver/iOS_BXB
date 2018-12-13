//
//  BXBNoticeDetailDelegate.swift
//  BXB
//
//  Created by equalriver on 2018/8/24.
//  Copyright © 2018年 tobosoft. All rights reserved.
//

import Foundation
import ObjectMapper

//MARK: - action
extension BXBNoticeDetialVC {
    
    override func rightButtonsAction(sender: UIButton) {
        super.rightButtonsAction(sender: sender)
        if sender.titleLabel?.text == "编辑" {
            isCanEdit = true
            tableView.reloadData()
            sender.setTitle("保存", for: .normal)
            return
        }
        //提醒时间
        let date = dateFormatter.date(from: data.time) ?? dateFormatter_std.date(from: data.times)
        guard date != nil else {
            view.makeToast("请选择时间")
            return
        }
        
        guard data.remindName.count > 0 else {
            view.makeToast("事项不能为空")
            return
        }
        
        let fireDate = BXBLocalizeNotification.getDateWithRemindName(name: data.remindTime, date: date!)
        let remindDate = fireDate == nil ? "" : dateFormatter.string(from: fireDate!)
        
        sender.isUserInteractionEnabled = false
        
        BXBNetworkTool.BXBRequest(router: .editClientRemind(id: data.id, args: ["remindName": data.remindName, "remindDate": remindDate, "remindTime": data.remindTime, "time": data.time.count > 0 ? data.time : data.times]), success: { (resp) in
            
            sender.setTitle("编辑", for: .normal)
            sender.isUserInteractionEnabled = true
            self.isCanEdit = false
            
            if let d = Mapper<AgendaRemindData>().map(JSONObject: resp["data"].object) {
                d.id = self.data.id
                self.data = d
            }
            NotificationCenter.default.post(name: .kNotiAgendaShouldRefreshData, object: nil)
            
            
        }) { (error) in
            sender.setTitle("编辑", for: .normal)
            sender.isUserInteractionEnabled = true
            self.isCanEdit = false
        }
        /*
        let vc = BXBAgendaDetailPopoverVC()
        vc.delegate = self
        vc.dataArr = ["编辑", "删除"]
        vc.preferredContentSize = CGSize.init(width: 120 * KScreenRatio_6, height: 100 * KScreenRatio_6)
        vc.modalPresentationStyle = .popover
        if let pop = vc.popoverPresentationController {
            pop.delegate = self
            pop.backgroundColor = UIColor.white
            pop.permittedArrowDirections = .up
            pop.sourceView = sender
            pop.sourceRect = sender.bounds
            
            present(vc, animated: true, completion: nil)
        }
        */
    }
    
    /*
    //保存修改
    @objc func confirmButtonClick(sender: UIButton) {
        //提醒时间
        let date = dateFormatter.date(from: data.time) ?? dateFormatter_std.date(from: data.times)
        guard date != nil else {
            view.makeToast("请选择时间")
            return
        }
        let fireDate = BXBLocalizeNotification.getDateWithRemindName(name: data.remindTime, date: date!)
        let remindDate = fireDate == nil ? "" : dateFormatter.string(from: fireDate!)

        sender.setTitle("保存", for: .normal)
        sender.isUserInteractionEnabled = false
        
        BXBNetworkTool.BXBRequest(router: .editClientRemind(id: data.id, args: ["remindName": data.remindName, "remindDate": remindDate, "remindTime": data.remindTime, "time": data.time.count > 0 ? data.time : data.times]), success: { (resp) in

            sender.setTitle("编辑", for: .normal)
            sender.isUserInteractionEnabled = true
            
            if let d = Mapper<AgendaRemindData>().map(JSONObject: resp["data"].object) {
                self.data = d
            }
            NotificationCenter.default.post(name: NSNotification.Name.init(kNotiAgendaShouldRefreshData), object: nil)
            
            self.isCanEdit = false
            
        }) { (error) in
            sender.setTitle("编辑", for: .normal)
            sender.isUserInteractionEnabled = true
        }
    }
   */
    
    //notice alert
    func noticeAction() {
        let alert = UIAlertController.init(title: nil, message: nil, preferredStyle: .actionSheet)
        
        for (index, item) in noticeDataArr.enumerated() {
            
            if index == noticeDataArr.endIndex - 1 {
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
                    self.tableView.reloadRow(3, inSection: 0, with: .automatic)
                    
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
        let alert = UIAlertController.init(title: "请输入自定义天数", message: nil, preferredStyle: .alert)
        let action = UIAlertAction.init(title: "确定", style: .default) { (ac) in
            if let tf = alert.textFields?.first {
                if tf.hasText {
                    guard Int(tf.text!) != nil else { return }
                    self.data.remindTime = Int(tf.text!) == 0 ? "当天" : "提前\(tf.text!)天提醒" 
                    self.tableView.reloadRow(3, inSection: 0, with: .automatic)
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

//MARK: - popover delegate
extension BXBNoticeDetialVC: UIPopoverPresentationControllerDelegate {
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
}

extension BXBNoticeDetialVC: AgendaDetailPopoverDelegate {
    
    func didSelectedPopoverItem(index: Int) {
        if index == 0 {//编辑
            isCanEdit = true
            tableView.reloadData()
        }
        else {//删除
            let alert = UIAlertController.init(title: "确定删除提醒吗?", message: nil, preferredStyle: .alert)
            
            let confirm = UIAlertAction.init(title: "确定", style: .default, handler: { (ac) in
                
                BXBNetworkTool.BXBRequest(router: .deleteClientNotice(id: self.data.id), success: { (resp) in

                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1, execute: {
                        NotificationCenter.default.post(name: .kNotiAgendaShouldRefreshData, object: nil, userInfo: nil)
                        NotificationCenter.default.post(name: .kNotiRemindShouldRefreshData, object: nil, userInfo: nil)
  
                        self.navigationController?.popViewController(animated: true)
                    })
                    
                }) { (error) in
                    
                }
            })
            
            let cancel = UIAlertAction.init(title: "取消", style: .cancel, handler: nil)
            alert.addAction(confirm)
            alert.addAction(cancel)
            DispatchQueue.main.async {
                self.present(alert, animated: true, completion: nil)
            }
            
        }
    }
}

//MARK: - 编辑状态 delegate
extension BXBNoticeDetialVC: NoticeDetailCellDelegate {
    
    func detailTextChange(sender: UITextField, cell : UITableViewCell) {
  
        if let indexPath = tableView.indexPath(for: cell) {
            if indexPath.row == 1 {//type
                guard sender.markedTextRange == nil else { return }
                sender.text = String(sender.text?.prefix(kNameTextLimitCount) ?? "")
                data.remindName = sender.text ?? data.remindName
            }
        }
    }
}

//MARK: - table view delegate
extension BXBNoticeDetialVC: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titles.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60 * KScreenRatio_6
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = BXBNoticeDetailCell.init(style: .default, reuseIdentifier: nil)
        cell.delegate = self
        cell.titleLabel.text = titles[indexPath.row]
        if isCanEdit && indexPath.row != 0 {
            cell.rightArrowView.isHidden = false
        }
        else { cell.rightArrowView.isHidden = true }
        
        switch indexPath.row {
        case 0://name
            cell.detailTF.text = data.name
            
        case 1://type
            cell.detailTF.isUserInteractionEnabled = false
            cell.detailTF.text = data.remindName
            
        case 2://time
            cell.detailTF.text = data.times

        case 3://notice
            cell.detailTF.text = data.remindTime.count > 0 ? data.remindTime : "未设置"
            
        default:
            break
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if isCanEdit == false { return }
        
        switch indexPath.row {
        case 1: //type
            if let cell = tableView.cellForRow(at: indexPath){
                let c = cell as! BXBNoticeDetailCell
                c.detailTF.isUserInteractionEnabled = true
                c.detailTF.becomeFirstResponder()
            }
            
        case 2: //date picker
            let datePicker = AgendaDetailDatePickerAlert.init(frame: CGRect.init(x: 0, y: 0, width: kScreenWidth, height: kScreenHeight)) { [unowned self](date) in
                
                self.data.time = date
                if let cell = tableView.cellForRow(at: indexPath) {
                    if let c = cell as? BXBNoticeDetailCell {
                        c.detailTF.text = date
                        if date.contains(":") {
                            guard let d = date.components(separatedBy: " ").first else { return }
                            c.detailTF.text = d
                        }
                    }
                }
                
            }
            datePicker.datePicker.datePickerMode = .date
            view.addSubview(datePicker)
            
        case 3: //notice
            noticeAction()
            
        default:
            break
        }
    }
}









