//
//  WorkLogDelegate.swift
//  BXB
//
//  Created by equalriver on 2018/8/8.
//  Copyright © 2018年 tobosoft. All rights reserved.
//

import Foundation
import ObjectMapper

//MARK: - action
extension BXBWorkLogVC {
    
    func loadMeData(date: String) {
        BXBNetworkTool.BXBRequest(router: .meWorkLog(date: date), success: { (resp) in
            
            if let d = Mapper<WorkLogListData>().mapArray(JSONObject: resp["data"].arrayObject){
                
                let dateStrArr = date.components(separatedBy: "-")
                if dateStrArr.count == 3 {
                    if let m = Int(dateStrArr[1]), let day = Int(dateStrArr[2]) {
                        self.dateLabel.text = "    \(m)月\(day)日"
                        self.meDate = "    \(m)月\(day)日"
                    }
                }
                
                self.meDataArr.removeAll()
                self.meDataArr = d
                d.count == 0 ? self.meTableView.stateEmpty(title: "无消息", img: nil, buttonTitle: nil, handle: nil) : self.meTableView.stateNormal()
                self.meTableView.reloadData()
            }
            
        }) { (error) in
            
        }
    }
    
    func loadTeamData(date: String) {
        
    }
    
    @objc func datePick(){
        
        let d = BXBWorkLogPickerView.init(frame: CGRect.init(x: 0, y: 0, width: kScreenWidth, height: kScreenHeight), isOnlyMonth: isOnlyMonth, handle: { [unowned self](m, d) in
           
            self.month = m.count == 2 ? m : "0" + m
            self.day = d.count == 2 ? d : "0" + d
            
            if self.isMeTableView {
                self.loadMeData(date: self.year + "-" + self.month + "-" + self.day)
            }
            else {
                
            }
        })
        UIApplication.shared.keyWindow?.addSubview(d)
        
    }
    
    @objc func confirmAction(sender: UIButton){
        guard let token = UserDefaults.standard.string(forKey: "token") else { return }
        if isMeTableView {
            if meCommitArr.count > 0 {
                for v in meCommitArr {
                    var dic = Dictionary<String, Any>()
                    dic["id"] = v.id
                    dic["name"] = v.name
                    dic["token"] = token
                    dic["isSubmit"] = 1
                    meUploadArr.append(dic)
                }
                sender.isUserInteractionEnabled = false
                BXBNetworkTool.BXBRequest(router: .commitMeWorkLog(args: meUploadArr), success: { (resp) in
                    sender.isUserInteractionEnabled = true
                    self.meCommitArr.removeAll()
                    self.meUploadArr.removeAll()
                    SVProgressHUD.showInfo(withStatus: "提交成功")
                    
                }) { (error) in
                    sender.isUserInteractionEnabled = true
                }
            }
        }
        else {
            
        }
    }
    
}


//MARK: -
extension BXBWorkLogVC: WorkLogMeCellDelegate {
    
    func didFinishRemark(data: WorkLogData, heart: String) {
        BXBNetworkTool.BXBRequest(router: .editAgenda(name: data.name, id: data.id, params: ["heart": heart]), success: { (resp) in
            
            if self.meCommitArr.contains(data) == false {
                self.meCommitArr.append(data)
            }
            
        }) { (error) in
            
        }
    }
}


//MARK: - table view delegate
extension BXBWorkLogVC: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return tableView == meTableView ? meDataArr.count : 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableView == meTableView ? meDataArr[section].list.count : 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView == meTableView ? 140 * KScreenRatio_6 : 210 * KScreenRatio_6
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return tableView == meTableView ? 40 * KScreenRatio_6 : 0
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return tableView == meTableView ? 10 * KScreenRatio_6 : 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == meTableView {
            var cell = tableView.dequeueReusableCell(withIdentifier: "BXBWorkLogMeCell") as? BXBWorkLogMeCell
            if cell == nil { cell = BXBWorkLogMeCell.init(style: .default, reuseIdentifier: "BXBWorkLogMeCell") }
            cell?.data = meDataArr[indexPath.section].list[indexPath.row]
            cell?.delegate = self
            return cell!
        }
        else {
            var cell = tableView.dequeueReusableCell(withIdentifier: "BXBWorkLogTeamCell") as? BXBWorkLogTeamCell
            if cell == nil { cell = BXBWorkLogTeamCell.init(style: .default, reuseIdentifier: "BXBWorkLogTeamCell") }
            
            
            return cell!
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let l = UILabel.init(frame: CGRect.init(x: 0, y: 0, width: KScreenRatio_6, height: 40 * KScreenRatio_6))
        l.font = kFont_text_weight
        l.textColor = kColor_theme
        l.textAlignment = .center
        l.backgroundColor = UIColor.white
        l.text = meDataArr[section].visitTepyName
        
        return tableView == meTableView ? l : nil
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let v = UIView.init(frame: CGRect.init(x: 0, y: 0, width: KScreenRatio_6, height: 10 * KScreenRatio_6))
        v.backgroundColor = kColor_background
        
        return tableView == meTableView ? v : nil
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        view.endEditing(true)
    }
    
    
}








