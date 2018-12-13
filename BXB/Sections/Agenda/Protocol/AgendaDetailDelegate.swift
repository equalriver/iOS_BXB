//
//  AgendaDetailDelegate.swift
//  BXB
//
//  Created by equalriver on 2018/7/30.
//  Copyright © 2018年 tobosoft. All rights reserved.
//

import Foundation
import ObjectMapper


extension BXBAgendaDetailVC {
    
    //MARK: - action
    
    //network
    func loadData(id: Int) {
        
        BXBNetworkTool.BXBRequest(router: .detailAgenda(id: agendaId), success: { (resp) in
            
            if let data = Mapper<AgendaData>().map(JSONObject: resp["data"].object) {
                self.data = data
            }
            
        }) { (error) in
            
        }
    }
    
    ///删除日程
    override func rightButtonsAction(sender: UIButton) {
        super.rightButtonsAction(sender: sender)
        
        if sender.tag == 1 {//更多
            
            /*
            let vc = BXBAgendaDetailPopoverVC()
            vc.dataArr = ["编辑", "删除"]
            vc.delegate = self
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
        if sender.tag == 2 {//保存
            if sender.titleLabel?.text == "编辑" {
                sender.setTitle("保存", for: .normal)
                isCanEdit = true
                tableView.reloadData()
                return
            }
            
            guard let date = dateFormatter.date(from: data.visitDate) else { return }
            //提醒时间
            let fireDate = BXBLocalizeNotification.getDateWithRemindName(name: data.remindTime, date: date)
            let remindDate = fireDate == nil ? "" : dateFormatter.string(from: fireDate!)
            
            sender.isUserInteractionEnabled = false
            
            BXBNetworkTool.BXBRequest(router: .editAgenda(name: self.data.name, id: self.data.id, params: ["remindDate": remindDate, "visitDate": data.visitDate, "address": data.address, "unitAddress": data.detailAddress, "latitude": data.lat, "longitude": data.lng, "remindTime": data.remindTime, "remarks": self.data.remarks, "heart": data.heart]), success: { (resp) in
                
                sender.setTitle("编辑", for: .normal)
                sender.isUserInteractionEnabled = true
                
                if self.oldDate != self.data.visitDate || self.oldNotice != self.data.remindTime { self.isEditNotice = true }
                
                self.isCanEdit = false
                self.tableView.snp.updateConstraints { (make) in
                    if self.data.status == 1 {
                        make.height.equalTo((self.data.remarks + self.data.heart).getStringHeight(font: kFont_text, width: 315 * KScreenRatio_6) + 360 * KScreenRatio_6)
                    }
                    else { make.height.equalTo(self.data.remarks.getStringHeight(font: kFont_text, width: 315 * KScreenRatio_6) + 320 * KScreenRatio_6) }
                }
                self.tableView.reloadData()
                
                NotificationCenter.default.post(name: .kNotiAgendaShouldRefreshData, object: nil)
                
            }, failure: { (error) in
                sender.setTitle("编辑", for: .normal)
                sender.isUserInteractionEnabled = true
            })
            
        }
        
    }
    
    
    @objc func confirmButtonClick(sender: UIButton) {
        
        if isCanEdit == false {//完成日程
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
            else{//保单服务  客户服务
                let vc = BXBAgendaDetailEditVC.init()
                vc.titleText = "说点什么吧..."
                vc.data = data
                vc.isNeedPopToRootVC = true
                navigationController?.pushViewController(vc, animated: true)
                return
            }
            
            navigationController?.pushViewController(vc, animated: true)
        }
        
    }
    
    //notice alert
    func noticeAction() {
        let alert = UIAlertController.init(title: nil, message: nil, preferredStyle: .actionSheet)
        
        for (index, item) in noticeDataArr.enumerated() {
            
            if noticeSelectedItem == index {
                let action = UIAlertAction.init(title: item, style: .destructive) { (ac) in
                    
                    self.data.remindTime = self.noticeDataArr[index]
                    self.tableView.reloadRow(3, inSection: 0, with: .automatic)
                    
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
        let alert = UIAlertController.init(title: "请输入自定义分钟数", message: nil, preferredStyle: .alert)
        let action = UIAlertAction.init(title: "确定", style: .default) { (ac) in
            if let tf = alert.textFields?.first {
                if tf.text != nil {
                    self.data.remindTime = "\(tf.text!)分钟前"
                    self.tableView.reloadRow(3, inSection: 0, with: .automatic)
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
}

//MARK: - popover delegate
extension BXBAgendaDetailVC: UIPopoverPresentationControllerDelegate {
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
}

extension BXBAgendaDetailVC: AgendaDetailPopoverDelegate {
    
    func didSelectedPopoverItem(index: Int) {
        if index == 0 {//编辑
            isCanEdit = true
//            naviBar.rightBarButtons = [saveBtn]
            tableView.reloadData()
        }
        else {//删除
            let alert = UIAlertController.init(title: "确定删除日程吗?", message: nil, preferredStyle: .alert)
            
            let confirm = UIAlertAction.init(title: "删除", style: .destructive, handler: { (ac) in
                BXBNetworkTool.isShowSVProgressHUD = false
                BXBNetworkTool.BXBRequest(router: .deleteAgenda(id: self.data.id), success: { (resp) in
                 
                    BXBLocalizeNotification.removeLocalizeNotification(id: self.data.id)
                 
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1, execute: {
                        NotificationCenter.default.post(name: .kNotiAgendaShouldRefreshData, object: nil, userInfo: nil)
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

//MARK: - table view delegate
extension BXBAgendaDetailVC: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return normalAngedaTitles.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let editHeight:CGFloat = isCanEdit ? 20 : 0
        
        if indexPath.row == 2 {//拜访地址
            return 80 * KScreenRatio_6
        }
        if indexPath.row == 4 {//备注
            
            return data.remarks.getStringHeight(font: kFont_text, width: 315 * KScreenRatio_6) + 45 * KScreenRatio_6 + editHeight
        }
        if indexPath.row == 5 {//心得
            
            return data.heart.getStringHeight(font: kFont_text, width: 315 * KScreenRatio_6) + 45 * KScreenRatio_6 + editHeight
        }
        return 60 * KScreenRatio_6
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = BXBAgendaDetailCell.init(style: .default, reuseIdentifier: nil)
        cell.delegate = self
        cell.titleLabel.text = normalAngedaTitles[indexPath.row]
        
        if indexPath.row == normalAngedaTitles.count - 1 { cell.isNeedSeparatorView = false }
        
        cell.rightArrowView.isHidden = !isCanEdit
        
        if isCanEdit && (indexPath.row == 1 || indexPath.row == 3) {
            
            cell.rightArrowView.isHidden = data.status == 1
            
        }
        
        switch indexPath.row {
        case 0://name
            cell.rightArrowView.isHidden = true
            cell.detailTV.text = data.name
            cell.detailTV.textColor = kColor_dark
            
        case 1://time
            cell.detailTV.textColor = kColor_dark
            cell.detailTV.text = data.visitDate
            
        case 2://address
            let c = BXBAgendaDetailAddressCell.init(style: .default, reuseIdentifier: nil)
            c.delegate = self
            c.titleLabel.text = normalAngedaTitles[indexPath.row]
            c.rightBtn.setImage(isCanEdit ? #imageLiteral(resourceName: "agenda_定位") : #imageLiteral(resourceName: "agenda_导航"), for: .normal)
            c.detailTF.text = data.address.count > 0 ? data.address : nil
            c.subDetailTF.text = data.detailAddress.count > 0 ? data.detailAddress : nil
            c.subDetailTF.isUserInteractionEnabled = isCanEdit
            return c
            
        case 3://notice
            cell.detailTV.text = data.remindTime.count > 0 ? data.remindTime : "未设置"
            cell.detailTV.textColor = data.remindTime.count > 0 ? kColor_dark : kColor_text
            
        case 4://remark
            cell.detailTV.isUserInteractionEnabled = isCanEdit
            cell.detailTV.text = data.remarks.count > 0 ? data.remarks : "未填写"
            cell.detailTV.textColor = data.remarks.count > 0 ? kColor_dark : kColor_text
            cell.voiceInputBtn.isHidden = !isCanEdit
            
        case 5://heart
            cell.detailTV.isUserInteractionEnabled = isCanEdit
            cell.detailTV.text = data.heart.count > 0 ? data.heart : "未填写"
            cell.detailTV.textColor = data.heart.count > 0 ? kColor_dark : kColor_text
            cell.voiceInputBtn.isHidden = !isCanEdit
            
        default:
            break
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if isCanEdit == false { return }
        
        switch indexPath.row {
        case 1: //date picker
            if data.status == 1 { return }
            let datePicker = AgendaDetailDatePickerAlert.init(frame: CGRect.init(x: 0, y: 0, width: kScreenWidth, height: kScreenHeight)) { [unowned self](date) in
                
                self.data.visitDate = date
                self.tableView.reloadRow(1, inSection: 0, with: .automatic)
                
            }
            view.addSubview(datePicker)
            
        case 2: //address
            if let cell = tableView.cellForRow(at: indexPath){
                let c = cell as! BXBAgendaDetailAddressCell
                c.subDetailTF.becomeFirstResponder()
            }
            
        case 3: //notice
            if data.status == 1 { return }
            noticeAction()
            
        case 4: //remarks
            if let cell = tableView.cellForRow(at: indexPath){
                let c = cell as! BXBAgendaDetailCell
                c.detailTV.becomeFirstResponder()
            }
            
        case 5: //heart
            if let cell = tableView.cellForRow(at: indexPath){
                let c = cell as! BXBAgendaDetailCell
                c.detailTV.becomeFirstResponder()
            }
            
        default:
            break
        }
    }
}


//MARK: - 地址 cell delegate
extension BXBAgendaDetailVC: AgendaDetailAddressDelegate {
    
    //MARK: - 选择地址  导航
    func didClickAddressRightButton(cell: UITableViewCell) {
        
        guard checkNetwork() == true else { return }
        
        if isCanEdit {//选择地址
            switch CLLocationManager.authorizationStatus() {
            case .authorizedAlways, .authorizedWhenInUse, .notDetermined:
                let vc = BXBSelectedLocationVC()
                if Double(data.lat) != nil && Double(data.lng) != nil {
                    
                    let poi = AMapPOI()
                    poi.name = data.address
                    poi.location = AMapGeoPoint.location(withLatitude: CGFloat(Double(data.lat)!), longitude: CGFloat(Double(data.lng)!))
                    vc.currentLocation = poi
                }
                vc.delegate = self
                navigationController?.pushViewController(vc, animated: true)
                
            default:
                gotoAuthorizationView(vc: self)
            }
        }
        else {//导航
            guard Double(data.lat) != nil && Double(data.lng) != nil else {
                view.makeToast("无效的位置信息")
                return
            }
            
            var maps = ["苹果地图" : ""]
            if UIApplication.shared.canOpenURL(URL.init(string: "baidumap://")!) {
                maps["百度地图"] = "baidumap://map/direction?origin={{我的位置}}&destination=latlng:\(data.lat),\(data.lng)|name=目的地&mode=driving&coord_type=gcj02"
            }
            if UIApplication.shared.canOpenURL(URL.init(string: "iosamap://")!) {
                maps["高德地图"] = "iosamap://navi?sourceApplication= &backScheme= &lat=\(data.lat)&lon=\(data.lng)&dev=0&style=2"
            }
            if UIApplication.shared.canOpenURL(URL.init(string: "comgooglemaps://")!) {
                maps["谷歌地图"] = "comgooglemaps://?saddr=&daddr=\(data.lat),\(data.lng)&directionsmode=walking"
            }
            if UIApplication.shared.canOpenURL(URL.init(string: "qqmap://")!) {
                maps["腾讯地图"] = "qqmap://map/routeplan?from=我的位置&type=drive&tocoord=\(data.lat),\(data.lng)&to=终点&coord_type=1&policy=0"
            }
            let alert = UIAlertController.init(title: nil, message: nil, preferredStyle: .actionSheet)
            for (k, v) in maps {
                let action = UIAlertAction.init(title: k, style: .default) { (ac) in
                    if k == "苹果地图" { self.localMap() }
                    else {
                        if let url = URL.init(string: v.URL_UTF8_string) {
                            UIApplication.shared.openURL(url)
                        }
                    }
                }
                alert.addAction(action)
            }
            let cancel = UIAlertAction.init(title: "取消", style: .cancel, handler: nil)
            alert.addAction(cancel)
            DispatchQueue.main.async {
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    //备注地址
    func addressSubDetailTextChange(sender: UITextField, cell: UITableViewCell) {
        
        data.detailAddress = sender.text ?? ""
        guard sender.hasText == true else { return }
        
        guard sender.markedTextRange == nil else { return }
        if sender.text!.count > 20 {
            view.makeToast("最多输入20个字")
            sender.text = String(sender.text!.prefix(20))
            data.detailAddress = sender.text!
        }
    }
 
}

//MARK: - 编辑状态 delegate
extension BXBAgendaDetailVC: AgendaDetailCellDelegate {
    
    func isEditingText(isEditing: Bool, cell: UITableViewCell) {
        countLabel.isHidden = !isEditing
    }
    
    func detailTextChange(sender: UITextView, cell: UITableViewCell) {

        
        if sender.hasText {
            if sender.text!.isIncludeEmoji {
                sender.text = sender.text!.filter({ (c) -> Bool in
                    return String(c).isIncludeEmoji == false
                })
                return
            }
            
            guard sender.markedTextRange == nil else { return }
            let current = "\(sender.text.count)"
            let total = "/\(kRemarkTextLimitCount_1)"
            let att = NSMutableAttributedString.init(string: current + total)
            att.addAttributes([NSAttributedString.Key.font: kFont_text, NSAttributedString.Key.foregroundColor: kColor_theme!], range: NSMakeRange(0, current.count))
            att.addAttributes([NSAttributedString.Key.font: kFont_text, NSAttributedString.Key.foregroundColor: kColor_subText!], range: NSMakeRange(current.count, total.count))
            countLabel.attributedText = att
          
            if let indexPath = tableView.indexPath(for: cell) {
                //备注
                if indexPath.row == 4 { data.remarks = sender.text ?? "" }
                //心得
                if indexPath.row == 5 { data.heart = sender.text ?? "" }
                cell.setNeedsLayout()
                cell.layoutIfNeeded()
            }
        }
        else {
            if let indexPath = tableView.indexPath(for: cell) {
                //备注
                if indexPath.row == 4 { data.remarks = sender.text ?? "" }
                //心得
                if indexPath.row == 5 { data.heart = sender.text ?? "" }
                cell.setNeedsLayout()
                cell.layoutIfNeeded()
            }
        }
        if sender.text.count > kRemarkTextLimitCount_1 {
            view.makeToast("超出字数限制")
            sender.text = String(sender.text.prefix(kRemarkTextLimitCount_1))
            if let indexPath = tableView.indexPath(for: cell) {
                //备注
                if indexPath.row == 4 { data.remarks = sender.text ?? "" }
                //心得
                if indexPath.row == 5 { data.heart = sender.text ?? "" }
            }
            return
        }
        
    }
    
    
    func didClickVoiceInput(cell: BXBAgendaDetailCell) {
        
        if isCanEdit == false { return }
        
        if let indexPath = tableView.indexPath(for: cell) {
            
            view.endEditing(true)
            
            if cell.detailTV.text == "未设置" { cell.detailTV.text = nil }
            
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.25) {
                let rect = self.tableView.convert(cell.frame, to: self.view)
                
                if #available(iOS 10.0, *) {
                 
                    let speech = BXBSpeech.init(frame: CGRect.init(x: 0, y: 0, width: kScreenWidth, height: kScreenHeight), showHandle: {
                        
                        self.view.transform = CGAffineTransform.init(translationX: 0, y: (kScreenHeight - rect.origin.y - rect.height) - speechContentHeight - 30)
                        
                    }, dismissHandle: {
                        UIView.animate(withDuration: 0.15) {
                            self.view.transform = CGAffineTransform.init(translationX: 0, y: 0)
                        }
                    })
                    UIApplication.shared.keyWindow?.addSubview(speech)
                    
                    speech.showSpeechView { (str) in
                        
                        guard cell.detailTV.markedTextRange == nil else { return }
                        
                        if (cell.detailTV.text + str).count > kRemarkTextLimitCount_1 {
                            self.view.makeToast("超出字数限制")
                            return
                        }
                        
                        //备注
                        if indexPath.row == 4 {
                            self.data.remarks = (cell.detailTV.text ?? "") + str
                        }
                        //心得
                        if indexPath.row == 5 {
                            self.data.heart = (cell.detailTV.text ?? "") + str
                        }
                        cell.detailTV.text = (cell.detailTV.text ?? "") + str
                        cell.setNeedsLayout()
                        cell.layoutIfNeeded()
                        print("语音输入: \(str)")
                    }
                } else {
                    SVProgressHUD.showInfo(withStatus: "语音输入需要iOS 10以上的系统")
                }
            }
        }
    }
    
    func localMap() {
        guard data.lat.count > 0 && data.lng.count > 0 else { return }
        let coor = CLLocationCoordinate2D.init(latitude: Double(data.lat)!, longitude: Double(data.lng)!)
        let current = MKMapItem.forCurrentLocation()
        let toLocation = MKMapItem.init(placemark: MKPlacemark.init(coordinate: coor, addressDictionary: nil))
        
        MKMapItem.openMaps(with: [current, toLocation], launchOptions: [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving, MKLaunchOptionsShowsTrafficKey: true])
    }
}

//MARK: - SelectedLocationDelegate
extension BXBAgendaDetailVC: SelectedLocationDelegate {
    
    func didSelectedAddress(poi: AMapPOI) {
        
        data.lat = "\(poi.location.latitude)"
        data.lng = "\(poi.location.longitude)"
        self.data.address = poi.name
        if let cell = tableView.cellForRow(at: IndexPath.init(row: 2, section: 0)) {
            let c = cell as! BXBAgendaDetailAddressCell
            c.detailTF.text = poi.name
        }
        
    }
    
}
