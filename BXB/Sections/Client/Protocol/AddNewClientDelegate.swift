
//
//  AddNewClientDelegate.swift
//  BXB
//
//  Created by equalriver on 2018/6/20.
//  Copyright © 2018年 tobosoft. All rights reserved.
//

import Foundation

extension BXBAddNewClientVC: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isAddMoreInfo ? 9 : 2
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 7 || indexPath.row == 8 {
            return 110 * KScreenRatio_6
        }
        return 55 * KScreenRatio_6
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if !isAddMoreInfo {
            phoneCell.isNeedSeparatorView = false
            return indexPath.row == 0 ? nameCell : phoneCell
        }
        else{
            phoneCell.isNeedSeparatorView = true
            
            if indexPath.row < 2 {
                return indexPath.row == 0 ? nameCell : phoneCell
            }
            let cell = BXBAddNewClientMoreCell.init(style: .default, reuseIdentifier: nil)
            
            switch indexPath.row {
            case 2:
                cell.title = "性别"
                cell.detail = data.name
                
            case 3:
                cell.title = "生日"
                cell.detail = data.birthday
                
            case 4:
                cell.title = "婚姻状态"
                cell.detail = data.marriageStatus
                
            case 5:
                cell.title = "年收入"
                if data.income == 10 { cell.detail = "10万元以下" }
                else if data.income == 50 { cell.detail = "50万元以上" }
                else { cell.detail =  data.income == 0 ? "未设置" : "\(data.income)万元" }
                
            case 6:
                cell.title = "学历"
                cell.detail = data.educationName
                
            case 7:
                let c = BXBAddNewClientAddressCell.init(style: .default, reuseIdentifier: nil)
                c.title = "家庭地址"
                c.detail = data.residentialAddress
                c.delegate = self
                return c
                
            case 8:
                let c = BXBAddNewClientAddressCell.init(style: .default, reuseIdentifier: nil)
                c.title = "工作地址"
                c.detail = data.workingAddress
                c.delegate = self
                c.isNeedSeparatorView = false
                return c
                
            default:
                break
            }
            
            return cell
        }
  
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
                
            }
            datePicker.datePicker.datePickerMode = .date
            datePicker.dateFormatter.dateFormat = "yyyy-MM-dd"
            self.view.addSubview(datePicker)
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
        }
        
        let vc = AddNewClientEditInfoVC.init { [unowned self](str) in
            
            if let cell = tableView.cellForRow(at: indexPath){
                let c = cell as! BXBAddNewClientMoreCell
                c.detail = str
                if indexPath.row == 5 { c.detail = str + "万元" }
            }
            
            switch indexPath.row {
                
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
        
        if indexPath.row == 2 { vc.titleInfo = "性别" }
        else if indexPath.row == 4 { vc.titleInfo = "婚姻状态" }
//        else if indexPath.row == 5 { vc.titleInfo = "年收入" }
        else if indexPath.row == 6 { vc.titleInfo = "学历" }
        else { return }
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        scrollView.endEditing(true)
    }
    
}


//MARK: - 备注地址
extension BXBAddNewClientVC: AddNewClientAddressDelegate {
    
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
        let t = String(sender.text!.prefix(kRemarkAddressTextLimitCount))
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
extension BXBAddNewClientVC: SelectedLocationDelegate {
    
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















