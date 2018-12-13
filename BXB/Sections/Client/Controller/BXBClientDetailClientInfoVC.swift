//
//  BXBClientDetailClientInfoVC.swift
//  BXB
//
//  Created by equalriver on 2018/8/29.
//  Copyright © 2018年 tobosoft. All rights reserved.
//

import UIKit
import ObjectMapper

class BXBClientDetailClientInfoVC: BXBBaseNavigationVC {

    public var data = ClientData()
    
    var infoArr = ["姓名", "手机", "性别", "生日", "婚姻状态", "年收入", "学历", "家庭住址", "工作地址"]
    
    let incomes = ["10", "20", "30", "40", "50"]
    
    ///点击的地址cell
    var selectedAddressIndexPath: IndexPath!
    
    lazy var tableView: UITableView = {
        let tb = UITableView.init(frame: .zero, style: .plain)
        tb.backgroundColor = UIColor.white
        tb.separatorStyle = .none
        tb.dataSource = self
        tb.delegate = self
        tb.layer.cornerRadius = kCornerRadius
        tb.layer.masksToBounds = true
        return tb
    }()
    lazy var dateFormatterYMD: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "基本信息"
        view.backgroundColor = kColor_background
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.centerX.equalTo(view)
            make.width.equalTo(345 * KScreenRatio_6)
            make.top.equalTo(naviBar.snp.bottom).offset(15 * KScreenRatio_6 + kIphoneXBottomInsetHeight)
            make.height.equalTo(580 * KScreenRatio_containX)
        }
    }
    
    override func leftButtonsAction(sender: UIButton) {
        //退出时保存
        sender.isUserInteractionEnabled = false
        BXBNetworkTool.isShowSVProgressHUD = false
        
        BXBNetworkTool.BXBRequest(router: .editClient(id: self.data.id, params: ["name": data.name, "phone": data.phone, "sex": data.sex, "birthday": data.birthday, "marriageStatus": data.marriageStatus, "income": data.income, "educationName": data.educationName, "residentialAddress": data.residentialAddress, "workingAddress": data.workingAddress, "latitude": data.latitude, "longitude": data.longitude, "workLatitude": data.workLatitude, "workLongitude": data.workLongitude, "unitAddress": data.unitAddress, "workUnitAddress": data.workUnitAddress]), success: { (resp) in
            
            sender.isUserInteractionEnabled = true
            
            super.leftButtonsAction(sender: sender)
            NotificationCenter.default.post(name: .kNotiClientDetailShouldRefreshData, object: nil)
            NotificationCenter.default.post(name: .kNotiClientShouldRefreshData, object: nil)
            
        }, failure: { (error) in
            sender.isUserInteractionEnabled = true
        })
        
    }
    
    ///是否追加生日提醒
    func addBirthdayNotice(date: String) {
        
        let alert = UIAlertController.init(title: nil, message: "是否添加生日提醒?", preferredStyle: .alert)
        let action = UIAlertAction.init(title: "是", style: .default) { (ac) in
            
            guard let d = self.dateFormatterYMD.date(from: date) else { return }
       
            guard let remindDate = BXBLocalizeNotification.getDateWithRemindName(name: ClientDetailNoticeTimeType.oneWeek.descrption(), date: d) else { return }
            
            let param = [[
                "token" : UserDefaults.standard.object(forKey: "token") ?? "",
                "clientId" : self.data.id,
                "matterId" : ClientItemStyle.birthday.descriptionForID(),
                "matter" : ClientItemStyle.birthday.description(),
                "remindId" : "",
                "remindName" : "本人",
                "time" : date,
                "remindDate" : self.dateFormatterYMD.string(from: remindDate),
                "remindTime" : ClientDetailNoticeTimeType.oneWeek.descrption()]]

            BXBNetworkTool.BXBRequest(router: .addClientNotice(client: param), success: { (resp) in
                
                
            }, failure: { (error) in
                
            })

        }
        let cancel = UIAlertAction.init(title: "否", style: .cancel, handler: nil)
        alert.addAction(action)
        alert.addAction(cancel)
        DispatchQueue.main.async {
            self.present(alert, animated: true, completion: nil)
        }
        
    }
    
}

//MARK: - 备注地址
extension BXBClientDetailClientInfoVC: AddNewClientAddressDelegate {
    func didEditRemarkAddress(sender: UITextField, cell: BXBAddNewClientAddressCell) {
        
        guard sender.hasText else {
            if let indexPath = tableView.indexPath(for: cell) {
                if indexPath.row == 7 {//家庭地址
                    data.unitAddress = ""
                }
                if indexPath.row == 8 {//工作地址
                    data.workUnitAddress = ""
                }
            }
            return
        }
        
        guard sender.markedTextRange == nil else { return }
        let t = String(sender.text!.prefix(kRemarkAddressTextLimitCount)).filter { (c) -> Bool in
            return String(c).isIncludeEmoji == false
        }
        sender.text = t
        
        if let indexPath = tableView.indexPath(for: cell) {
            if indexPath.row == 7 {//家庭地址
                data.unitAddress = t
            }
            if indexPath.row == 8 {//工作地址
                data.workUnitAddress = t
            }
        }
    }
    
    

}

//MARK: - SelectedLocationDelegate
extension BXBClientDetailClientInfoVC: SelectedLocationDelegate {
    
    func didSelectedAddress(poi: AMapPOI) {
        
        guard selectedAddressIndexPath != nil else { return }
        
        if selectedAddressIndexPath.row == 7 {//家庭住址
            data.residentialAddress = poi.name
            data.latitude = "\(poi.location.latitude)"
            data.longitude = "\(poi.location.longitude)"
        }
        if selectedAddressIndexPath.row == 8 {//工作地址
            data.workingAddress = poi.name
            data.workLatitude = "\(poi.location.latitude)"
            data.workLongitude = "\(poi.location.longitude)"
        }
        if let cell = tableView.cellForRow(at: selectedAddressIndexPath){
            let c = cell as! BXBAddNewClientAddressCell
            c.detail = poi.name
            
        }
    }
    
}

extension BXBClientDetailClientInfoVC: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return infoArr.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 7 || indexPath.row == 8 { return 110 * KScreenRatio_6 }
        return 55 * KScreenRatio_6
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = BXBAddNewClientMoreCell.init(style: .default, reuseIdentifier: nil)
        cell.title = infoArr[indexPath.row]
        
        switch indexPath.row {
        case 0://姓名
            cell.detail = data.name
            
        case 1://手机
            cell.detail = data.phone
            
        case 2://性别
            cell.detail = data.sex
            
        case 3://生日
            cell.detail = data.birthday
            
        case 4://婚姻状态
            cell.detail = data.marriageStatus
            
        case 5://年收入
            if data.income == 10 { cell.detail = "10万元以下" }
            else if data.income == 50 { cell.detail = "50万元以上" }
            else { cell.detail =  data.income == 0 ? "未设置" : "\(data.income)万元" }
            
        case 6://学历
            cell.detail = data.educationName
            
        case 7:
            let c = BXBAddNewClientAddressCell.init(style: .default, reuseIdentifier: nil)
            c.title = "家庭地址"
            c.detail = data.residentialAddress
            c.addressTF.text = data.unitAddress
            c.delegate = self
            return c
            
        case 8:
            let c = BXBAddNewClientAddressCell.init(style: .default, reuseIdentifier: nil)
            c.title = "工作地址"
            c.detail = data.workingAddress
            c.addressTF.text = data.workUnitAddress
            c.delegate = self
            return c
            
        default:
            break
        }
        
        return cell
        
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        scrollView.endEditing(true)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //生日
        if indexPath.row == 3 {
            let datePicker = AgendaDetailDatePickerAlert.init(frame: CGRect.init(x: 0, y: 0, width: kScreenWidth, height: kScreenHeight)) { [unowned self](date) in
                if let cell = tableView.cellForRow(at: indexPath){
                    let c = cell as! BXBAddNewClientMoreCell
                    c.detail = date
                }
                self.data.birthday = date
                self.addBirthdayNotice(date: date)
            }
            datePicker.datePicker.datePickerMode = .date
            datePicker.dateFormatter.dateFormat = "yyyy-MM-dd"
            UIApplication.shared.keyWindow?.addSubview(datePicker)
            return
        }
        //年收入
        if indexPath.row == 5 {
            
            let alert = UIAlertController.init(title: nil, message: nil, preferredStyle: .actionSheet)
            
            for v in incomes {
                var income = v
                if v == "10" { income = "10万元以下" }
                else if v == "50" { income = "50万元以上" }
                else { income = v + "万元" }
                
                let action = UIAlertAction.init(title: income, style: .default) { (ac) in
                    self.data.income = Int(v) ?? 0
                    if let cell = tableView.cellForRow(at: indexPath){
                        let c = cell as! BXBAddNewClientMoreCell
                        c.detail = income
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
        //家庭住址 / 工作地址
        if indexPath.row == 7 || indexPath.row == 8 {
            
            guard checkNetwork() == true else { return }
            
            switch CLLocationManager.authorizationStatus() {
            case .authorizedAlways, .authorizedWhenInUse, .notDetermined:
                
                selectedAddressIndexPath = indexPath
                
                let vc = BXBSelectedLocationVC()
                if indexPath.row == 7 {
                    if Double(data.latitude) != nil && Double(data.longitude) != nil {
                        let poi = AMapPOI()
                        poi.name = data.residentialAddress
                        poi.location = AMapGeoPoint.location(withLatitude: CGFloat(Double(data.latitude)!), longitude: CGFloat(Double(data.longitude)!))
                        vc.currentLocation = poi
                    }
                }
                else {
                    if Double(data.workLatitude) != nil && Double(data.workLongitude) != nil {
                        let poi = AMapPOI()
                        poi.name = data.workingAddress
                        poi.location = AMapGeoPoint.location(withLatitude: CGFloat(Double(data.workLatitude)!), longitude: CGFloat(Double(data.workLongitude)!))
                        vc.currentLocation = poi
                    }
                }
                vc.delegate = self
                navigationController?.pushViewController(vc, animated: true)
                
            default:
                gotoAuthorizationView(vc: self)
            }
            return
        }
        
        let vc = AddNewClientEditInfoVC.init { [unowned self](str) in
            
            if let cell = tableView.cellForRow(at: indexPath){
                let c = cell as! BXBAddNewClientMoreCell
                c.detail = str
            }
            
            switch indexPath.row {
            case 0://姓名
                self.data.name = str
                
            case 1://手机
                self.data.phone = str
                
            case 2: //性别
                self.data.sex = str
                
            case 4: //婚姻状态
                self.data.marriageStatus = str
                
//            case 5: //年收入
//                self.data.income = Int(str) ?? 0
                
            case 6: //学历
                self.data.educationName = str
                
            default: return
                
            }
            
        }
        if indexPath.row == 0 { vc.titleInfo = "姓名" }
        else if indexPath.row == 1 { vc.titleInfo = "手机" }
        else if indexPath.row == 2 { vc.titleInfo = "性别" }
        else if indexPath.row == 4 { vc.titleInfo = "婚姻状态" }
//        else if indexPath.row == 5 { vc.titleInfo = "年收入" }
        else if indexPath.row == 6 { vc.titleInfo = "学历" }
        else { return }
        vc.clientData = data
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
}


















