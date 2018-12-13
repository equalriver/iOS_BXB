//
//  UserTeamActivityDelegate.swift
//  BXB
//
//  Created by equalriver on 2018/9/3.
//  Copyright © 2018年 tobosoft. All rights reserved.
//

import Foundation
import ObjectMapper

extension BXBUserTeamActivityVC {
    
    //MARK: - network
    func loadData(date: String) {
        BXBNetworkTool.BXBRequest(router: .searchTeamActivityWithYM(time: date, userId: userId), success: { (resp) in
            
            if let total = Mapper<TeamActivityTotalData>().map(JSONObject: resp["acTotal"].object) {
                self.totalData = total
            }
            if let list = Mapper<TeamActivityMemberData>().mapArray(JSONObject: resp["data"].arrayObject){
                if list.count > 0 {
                    if let date = self.dateFormatter.date(from: date){
                        self.dayLabel.text = self.dateFormatter.string(from: date)
                        self.listArr.removeAll()
                        self.listArr = list
                    }
                }
            }
            self.namesTableView.reloadData()
            self.detailCollectionView.reloadData()
            
        }) { (error) in
            
        }
    }
    
    @objc func leftDayAction() {
        
        var comps = DateComponents()
        //前一天
        comps.setValue(-1, for: .day)
        let ca = NSCalendar.init(calendarIdentifier: .gregorian)
        
        guard let com_date = ca?.date(byAdding: comps, to: currentDate, options: NSCalendar.Options(rawValue: 0)) else {
            view.makeToast("没有更多了")
            return
        }
        dayLabel.text = dateFormatter.string(from: com_date)
        currentDate = com_date
        loadData(date: dateFormatter.string(from: com_date))
    }
    
    @objc func rightDayAction() {
        
        var comps = DateComponents()
        //后一天
        comps.setValue(1, for: .day)
        let ca = NSCalendar.init(calendarIdentifier: .gregorian)
        
        guard let com_date = ca?.date(byAdding: comps, to: currentDate, options: NSCalendar.Options(rawValue: 0)) else {
            view.makeToast("没有更多了")
            return
        }
        dayLabel.text = dateFormatter.string(from: com_date)
        currentDate = com_date
        loadData(date: dateFormatter.string(from: com_date))
    }
    
    @objc func dayDatePick() {
        
        guard let v = UIApplication.shared.keyWindow else { return }
        
        let datePicker = AgendaDetailDatePickerAlert.init(frame: CGRect.init(x: 0, y: 0, width: kScreenWidth, height: kScreenHeight)) { [unowned self](date) in
            
            let ymd = date.contains(":") == true ? date.components(separatedBy: " ").first! : date
            
            if let d = self.dateFormatter.date(from: ymd) {
                self.dayLabel.text = ymd
                self.currentDate = d
                self.loadData(date: ymd)
            }
            
        }
        datePicker.datePicker.datePickerMode = .date
        v.addSubview(datePicker)
    }
}

extension BXBUserTeamActivityVC: UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listArr.count + 2
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 || indexPath.row == 1 {
            return 30 * KScreenRatio_6
        }
        return 45 * KScreenRatio_6
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "UserTeamActivityNameCell") as? UserTeamActivityNameCell
        if cell == nil {
            cell = UserTeamActivityNameCell.init(style: .default, reuseIdentifier: "UserTeamActivityNameCell")
        }
        switch indexPath.row {
        case 0:
            cell?.nameLabel.text = "总数"
            cell?.nameLabel.textColor = kColor_subText
            cell?.isNeedSeparatorView = false
            break
            
        case 1:
            cell?.nameLabel.text = "平均"
            break
            
        default:
            cell?.nameLabel.text = listArr[indexPath.row - 2].name
            break
        }
        cell?.nameLabel.textColor = indexPath.row == 1 ? kColor_theme : kColor_dark
        
        return cell!
    }

    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == contentScroll {
            scrollView.setContentOffset(CGPoint.init(x: scrollView.contentOffset.x, y: 0), animated: false)
        }
        else {
            if scrollView == namesTableView { detailCollectionView.contentOffset = CGPoint.init(x: 0, y: scrollView.contentOffset.y) }
            else { namesTableView.contentOffset = CGPoint.init(x: 0, y: scrollView.contentOffset.y) }
        }
    }
}


extension BXBUserTeamActivityVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return listArr.count + 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return titlesArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "UserTeamActivityDetailCell", for: indexPath) as! UserTeamActivityDetailCell
        if indexPath.section == 0 {//总数
            
            cell.isFirstCell = true
            cell.detailLabel.textColor = kColor_subText
            
            switch indexPath.item {
            case 0:
                cell.detailLabel.text = "\(totalData.jieqieTotal)"
                break
                
            case 1:
                cell.detailLabel.text = "\(totalData.miantanTotal)"
                break
                
            case 2:
                cell.detailLabel.text = "\(totalData.jianyishuTotal)"
                break
                
            case 3:
                cell.detailLabel.text = "\(totalData.zengyuanTotal)"
                break
                
            case 4:
                cell.detailLabel.text = "\(totalData.qiandanTotal)"
                break
                
            case 5:
                cell.detailLabel.text = "\(totalData.kehuTotal)"
                break
                
            case 6:
                cell.detailLabel.text = "\(totalData.baodanTotal)"
                break

            default: break
            }
        }
        else if indexPath.section == 1 {//平均数
            
            cell.detailLabel.textColor = kColor_theme
            
            switch indexPath.item {
            case 0:
                cell.detailLabel.text = "\(totalData.jieqieAvg)"
                break
                
            case 1:
                cell.detailLabel.text = "\(totalData.miantanAvg)"
                break
                
            case 2:
                cell.detailLabel.text = "\(totalData.jianyishuAvg)"
                break
                
            case 3:
                cell.detailLabel.text = "\(totalData.zengyuanAvg)"
                break
                
            case 4:
                cell.detailLabel.text = "\(totalData.qiandanAvg)"
                break
                
            case 5:
                cell.detailLabel.text = "\(totalData.kehuAvg)"
                break
                
            case 6:
                cell.detailLabel.text = "\(totalData.baodanAvg)"
                break
                
            default: break
            }
        }
        else {
            cell.detailLabel.textColor = kColor_dark
            
            switch indexPath.item {
            case 0:
                cell.detailLabel.text = "\(listArr[indexPath.section - 2].jieqie)"
                break
                
            case 1:
                cell.detailLabel.text = "\(listArr[indexPath.section - 2].miantan)"
                break
                
            case 2:
                cell.detailLabel.text = "\(listArr[indexPath.section - 2].jianyishu)"
                break
                
            case 3:
                cell.detailLabel.text = "\(listArr[indexPath.section - 2].zengyuan)"
                break
                
            case 4:
                cell.detailLabel.text = "\(listArr[indexPath.section - 2].qiandan)"
                break
                
            case 5:
                cell.detailLabel.text = "\(listArr[indexPath.section - 2].kehu)"
                break
                
            case 6:
                cell.detailLabel.text = "\(listArr[indexPath.section - 2].baodan)"
                break
                
            default: break
            }
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.section == 0 || indexPath.section == 1 {
            return CGSize.init(width: 90, height: 30 * KScreenRatio_6)
        }
        return CGSize.init(width: 90, height: 45 * KScreenRatio_6)
    }
    
    
}







