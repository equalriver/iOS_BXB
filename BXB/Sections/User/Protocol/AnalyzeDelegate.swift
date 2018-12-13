//
//  AnalyzeDelegate.swift
//  BXB
//
//  Created by equalriver on 2018/7/1.
//  Copyright © 2018年 tobosoft. All rights reserved.
//

import Foundation


extension BXBAnalyzeVC: UIPopoverPresentationControllerDelegate {
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
    
    func popoverPresentationControllerDidDismissPopover(_ popoverPresentationController: UIPopoverPresentationController) {
        rightMonthButton.setImage(#imageLiteral(resourceName: "client_下箭头_灰"), for: .normal)
    }
}

//MARK: - popover delegate
extension BXBAnalyzeVC: AnalyzePopoverDelegate {
    
    func didSelectedPopoverItem(month: String) {
        rightMonthButton.setImage(#imageLiteral(resourceName: "client_下箭头_灰"), for: .normal)
        rightMonthButton.setTitle("\(Int(month)!)月", for: .normal)
        currentMonth = Int(month)!
        let dates = dateFormatter.string(from: Date()).components(separatedBy: "-")
        if dates.count == 3 {
            let m = dates[0] + "-" + month + "-" + dates[2]
            rightMonthButton.setTitle("\(Int(month)!)月", for: .normal)
            if isPersonData { loadPersonData(date: m) }
            else { loadTeamData(date: m) }
        }
    }
}

//MARK: - table view
extension BXBAnalyzeVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionTitles.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 3 { return data.policyList.count == 0 ? 1 : data.policyList.count }
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0://本月目标
            return 230 * KScreenRatio_6
            
        case 1://工作简报
            return 120 * KScreenRatio_6
            
        case 2://业务活动量详细
            return 320 * KScreenRatio_6
            
        case 3://签单用户总览
            return data.policyList.count == 0 ? 120 * KScreenRatio_6 : 60 * KScreenRatio_6
            
        case 4://转化率分析
            return 4 * 40 * KScreenRatio_6 + 50 * KScreenRatio_6
            
        default:
            return 0
        }

    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44 * KScreenRatio_6
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 20 * KScreenRatio_6
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0://本月目标
            currentTargetCell.data = data
            return currentTargetCell
            
        case 1://工作简报
            workReportCell.data = data.workList
            return workReportCell
            
        case 2://业务活动量详细
            activityCell.dataArr = data.VisitTypeList
            return activityCell
            
        case 3://签单用户总览
            if data.policyList.count == 0 {
                let c = UITableViewCell.init()
                let l = UILabel()
                l.font = kFont_text_2
                l.textColor = kColor_text
                l.text = "暂无签单客户"
                l.textAlignment = .center
                c.addSubview(l)
                l.snp.makeConstraints { (make) in
                    make.size.centerX.centerY.equalToSuperview()
                }
                
                return c
            }
            var cell = tableView.dequeueReusableCell(withIdentifier: "AnalyzeUserSignCell") as? AnalyzeUserSignCell
            if cell == nil {
                cell = AnalyzeUserSignCell.init(style: .default, reuseIdentifier: "AnalyzeUserSignCell")
            }
            cell?.data = data.policyList[indexPath.row]
            if data.policyList.count - 1 == indexPath.row { cell?.isNeedSeparatorView = false }
            return cell!
            
        case 4://转化率分析
            return changeCell
            
        default:
            return UITableViewCell()
        }

    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let v = UIView.init(frame: CGRect.init(x: 0, y: 0, width: kScreenWidth, height: 44 * KScreenRatio_6))
        v.backgroundColor = UIColor.white
        
//        let icon = UIImageView()
//        icon.image = [#imageLiteral(resourceName: "me_本月目标"), #imageLiteral(resourceName: "me_业务活动量详细"), #imageLiteral(resourceName: "me_客户互动详细"), #imageLiteral(resourceName: "me_转化率分析")][section]
//        v.addSubview(icon)
//        icon.snp.makeConstraints { (make) in
//            make.centerY.equalTo(v)
//            make.left.equalTo(v).offset(15 * KScreenRatio_6)
//        }
        
        let titleLabel = UILabel()
        titleLabel.font = kFont_text_2
        titleLabel.textColor = kColor_text
        titleLabel.text = sectionTitles[section]
        v.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(v)
            make.left.equalTo(v).offset(20 * KScreenRatio_6)
        }
        
        let sep = UIView.init(frame: CGRect.init(x: 0, y: 44 * KScreenRatio_6 - 0.5, width: kScreenWidth, height: 0.5))
        sep.backgroundColor = kColor_background
        v.addSubview(sep)
        
        return v
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let v = UIView.init(frame: CGRect.init(x: 0, y: 0, width: kScreenWidth, height: 20 * KScreenRatio_6))
        v.backgroundColor = kColor_background
        return v
        
    }
    
}
