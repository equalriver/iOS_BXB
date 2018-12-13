
//
//  AgendaFSCalendarDelegate.swift
//  BXB
//
//  Created by 尹平江 on 2018/6/5.
//  Copyright © 2018年 tobosoft. All rights reserved.
//

import Foundation
import EventKit
import ObjectMapper

//MARK: - action
extension BXBAgendaVC {
    
    //action
    @objc func titleButtonAction(sender: UIButton) {
        
        sender.isSelected = !sender.isSelected
        
        if self.calendar.scope == .month {
            self.calendar.setScope(.week, animated: true)
        } else {
            self.calendar.setScope(.month, animated: true)
        }
    }
    
    //移动日程按钮
    @objc func moveAddButton(sender: UIPanGestureRecognizer) {
        guard sender.view != nil else { return }
        let p = sender.location(in: view)
        if p.x < 10 + 40 || p.x > kScreenWidth - 10 - 40 || p.y < tableView.origin.y + 10 || p.y > tableView.origin.y + tableView.height - 40 {
            return
        }
        sender.view?.center = sender.location(in: view)
    }
    
    //添加日程
    @objc func addNewAgenda() {
        
        loginValidate(currentVC: self) { [weak self](isLogin) in
            if isLogin {
                let v = BXBAddNewAgendaView.init(frame: CGRect.init(x: 0, y: 0, width: kScreenWidth, height: kScreenHeight))
                v.delegate = self
                UIApplication.shared.keyWindow?.addSubview(v)
            }
        }
        
    }
    
    //回到今天
    @objc func goToday() {
        isDidClickBackToToday = true
        currentDate = Date()
        calendar.select(Date(), scrollToDate: true)
    }
    
    //刷新日历
    func refreshCalendar() {
        BXBNetworkTool.BXBRequest(router: .nearAgendaWithToday(), success: { (resp) in
            if let data = Mapper<AgendaData>().mapArray(JSONObject: resp["data"].arrayObject){
                self.agendaStatusDic.removeAll()
                for item in data {
                    self.agendaStatusDic[item.time] = item.name
                }
                self.calendar.reloadData()
            }
            
        }) { (error) in
            
        }
    }
    
    //印章动画
    func agendaFinishAnimation(indexPath: IndexPath) {
        
        if self.lastFinishedAgendaId != 0 {
            
            self.lastFinishedAgendaId = 0
            
            guard indexPath.row < dataArr.count else { return }
            self.tableView.scrollToRow(at: indexPath, at: .top, animated: false)
            
            guard let cell = tableView.cellForRow(at: indexPath) as? BXBAgendaCell else { return }
            
            print(indexPath)
            
            cell.contentCell.finishStateIV.alpha = 0
            cell.contentCell.finishStateIV.transform = CGAffineTransform.identity
            cell.contentCell.finishStateIV.transform = CGAffineTransform.init(scaleX: 3, y: 3)
            cell.contentCell.finishStateIV.isHidden = false
            
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1, execute: {
                
                UIView.animate(withDuration: 0.5, animations: {
                    
                    cell.contentCell.finishStateIV.transform = CGAffineTransform.identity
                    cell.contentCell.finishStateIV.alpha = 1
                    
                }, completion: { (isFinish) in
                    if isFinish {
                        
                    }
                })
            })
            
        }
    }
    
    //MARK: - noti
    //刷新列表
    @objc func shouldRefreshDataNoti(sender: Notification) {
        
        BXBNetworkTool.isShowSVProgressHUD = false
        
        if sender.userInfo != nil {
            if let agendaId = sender.userInfo![kLastFinishedAgendaKey] as? Int {
                lastFinishedAgendaId = agendaId
            }
            if let loginOut: Bool = sender.userInfo!["loginOut"] as? Bool {
                if loginOut == true {
                    dataArr.removeAll()
                    remindArr.removeAll()
                    displayCells.removeAll()
                    rowHeightDic.removeAll()
                    agendaStatusDic.removeAll()
                    calendar.reloadData()
                    tableView.reloadData()
                    return
                }
            }
            if let d = sender.userInfo!["selectedDate"] {
                if let date = d as? Date {
                    calendar.select(date, scrollToDate: true)
                    currentDate = date
                    loadData(date: date)
                }
            }
        }
        else {
            currentDate = calendar.selectedDate ?? Date()
            calendar.select(calendar.selectedDate ?? Date(), scrollToDate: true)
            loadData(date: calendar.selectedDate ?? Date())
        }
       
        refreshCalendar()
    }
    
    @objc func addNewAgendaDismissWay(sender: Notification) {
        
        if let info = sender.userInfo {
            if let isPopRoot = info["isPopRoot"] {
                let isPop = isPopRoot as! Bool
                if isPop {
                    navigationController?.popToRootViewController(animated: false)
                }
                else{
                    let vc = BXBAgendaDetailEditVC.init()
                    guard info["data"] != nil else { return }
                    guard info["title"] != nil else { return }
                    vc.data = info["data"]! as! AgendaData
                    vc.titleText = info["title"]! as! String
                    navigationController?.pushViewController(vc, animated: true)
                }
            }
        }
    }
    
    //通过其他VC跳转新建日程
    @objc func addNewAgendaByOtherVC(sender: Notification) {
        
        if sender.userInfo == nil {
            let v = BXBAddNewAgendaView.init(frame: CGRect.init(x: 0, y: 0, width: kScreenWidth, height: kScreenHeight))
            v.delegate = self
            UIApplication.shared.keyWindow?.addSubview(v)
            return
        }
        //从附近客户新建
        if let data = sender.userInfo!["ClientNearData"] {
            let v = BXBAddNewAgendaView.init(frame: CGRect.init(x: 0, y: 0, width: kScreenWidth, height: kScreenHeight))
            v.delegate = self
            v.data = data
            UIApplication.shared.keyWindow?.addSubview(v)
            return
        }
        //从工作页面新建
        if let data = sender.userInfo!["WorkData"] {
            let v = BXBAddNewAgendaView.init(frame: CGRect.init(x: 0, y: 0, width: kScreenWidth, height: kScreenHeight))
            v.delegate = self
            v.data = data
            UIApplication.shared.keyWindow?.addSubview(v)
            return
        }
        
    }
    
    //点击了添加后续带参数新建日程
    @objc func addNewAgendaBySelectFollow(sender: Notification) {
        
        guard sender.userInfo != nil else { return }
        let data = sender.userInfo!["agendaData"] ?? sender.userInfo!["NoticeDetailData"]
        let v = BXBAddNewAgendaView.init(frame: CGRect.init(x: 0, y: 0, width: kScreenWidth, height: kScreenHeight))
        v.delegate = self
        v.data = data
        UIApplication.shared.keyWindow?.addSubview(v)
        
    }
    
}


//MARK: - AddNewAgendaDelegate
extension BXBAgendaVC: AddNewAgendaDelegate {
    
    func didSelectedAddNewAgendaType(type: String, data: Any?) {
        let vc = BXBAddNewAgendaStep_1_VC()
        vc.type = type
        vc.selectDate = currentDate
        if data != nil {
            if data is AgendaData { vc.agendaData = data! as! AgendaData }
            if data is NoticeDetailData { vc.noticeData = data! as! NoticeDetailData }
            if data is ClientNearData { vc.clientNearData = data! as! ClientNearData }
        }
        navigationController?.pushViewController(vc, animated: true)
    }
}

//MARK: - table view
extension BXBAgendaVC: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? remindArr.count : dataArr.count
//        return section == 0 ? 1 : 6
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.section == 1 {
            if let h = rowHeightDic[indexPath] {
                return h
            }
           
            rowHeightDic[indexPath] = BXBAgendaCell.getRowHeight(data: dataArr[indexPath.row], indexPath: indexPath)
            
            return rowHeightDic[indexPath] ?? 0
        }
        return noticeCellHeight
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 0 ? 25 * KScreenRatio_6 : 0
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "BXBAgendaCell", for: indexPath) as! BXBAgendaCell
        //隐藏最后的分割线
        if dataArr.count == 0 {
            if indexPath.row == remindArr.count - 1 { cell.sepView.isHidden = true }
        }
        else {
            if indexPath.section == 1 && indexPath.row == dataArr.count - 1 {
                cell.sepView.isHidden = true
            }
        }
        
        if indexPath.section == 0 {
            cell.remindData = remindArr[indexPath.row]
        }
        else {
            
            cell.data = dataArr[indexPath.row]
            if self.dataArr[indexPath.row].id == self.lastFinishedAgendaId {
                cell.contentCell.finishStateIV.isHidden = true
            }
        }
        
        cell.delegate = self
        cell.selectionStyle = .none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {

        guard let c = cell as? BXBAgendaCell else { return }
        guard indexPath.row < dataArr.count else { return }
        
        if displayCells.contains(indexPath) == false {
            
            c.contentScroll?.panGestureRecognizer.require(toFail: self.scopeGesture)
            
            if indexPath.section == 0 { displayTime += Double(indexPath.row) * 0.1 }
            if indexPath.section == 1 { displayTime += Double(remindArr.count + indexPath.row) * 0.1 }
            
            cell.transform = CGAffineTransform.init(translationX: kScreenWidth, y: 0)
            
            UIView.animate(withDuration: displayTime > 1 ? 1 : displayTime, animations: {

                cell.transform = CGAffineTransform.init(translationX: 0, y: 0)
                
            }) { (isFinish) in
                if isFinish {
                    self.displayCells.insert(indexPath)
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            let vc = BXBNoticeDetialVC()
            vc.data = remindArr[indexPath.row]
            navigationController?.pushViewController(vc, animated: true)
        }
        else {
            let vc = BXBAgendaDetailVC()
            vc.agendaId = dataArr[indexPath.row].id
            navigationController?.pushViewController(vc, animated: true)
        }
        
    }
    

}

//MARK: - 编辑cell
extension BXBAgendaVC: AgendaCellDelegate {
    
    func didClickEditButtons(cell: BXBAgendaCell, index: Int) {
        
        if let indexPath = tableView.indexPath(for: cell) {
            if indexPath.section == 0 {//删除提醒
                let alert = UIAlertController.init(title: nil, message: "确定删除本条提醒吗？", preferredStyle: .actionSheet)
                
                let action = UIAlertAction.init(title: "删除", style: .destructive) { (ac) in
                    BXBNetworkTool.BXBRequest(router: .deleteClientNotice(id: self.remindArr[indexPath.row].id), success: { (resp) in
                        
                        self.tableViewAction = .delete
                        
                        NotificationCenter.default.post(name: .kNotiAgendaShouldRefreshData, object: nil, userInfo: nil)
                        NotificationCenter.default.post(name: .kNotiRemindShouldRefreshData, object: nil, userInfo: nil)
                        
                        if self.displayCells.contains(indexPath) { self.displayCells.remove(indexPath) }
                        
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
            else {
                if index == 0 && dataArr[indexPath.row].status == 0 {//完成日程
                    let vc = BXBAgendaDetailVC()
                    vc.agendaId = dataArr[indexPath.row].id
                    navigationController?.pushViewController(vc, animated: true)
                }
                else {//删除日程
                    let alert = UIAlertController.init(title: nil, message: "确定删除本条日程吗？", preferredStyle: .actionSheet)
                    
                    let action = UIAlertAction.init(title: "删除", style: .destructive) { (ac) in
                        
                        guard self.dataArr.count > indexPath.row else { return }
                        
                        BXBNetworkTool.isShowSVProgressHUD = false
                        BXBNetworkTool.BXBRequest(router: .deleteAgenda(id: self.dataArr[indexPath.row].id), success: { (resp) in
                            
                            self.tableViewAction = .delete
                            
                            BXBLocalizeNotification.removeLocalizeNotification(id: self.dataArr[indexPath.row].id)
                            
                            NotificationCenter.default.post(name: .kNotiAgendaShouldRefreshData, object: nil, userInfo: nil)
                            
                            if self.displayCells.contains(indexPath) { self.displayCells.remove(indexPath) }
                            
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
    }
}

/*

extension BXBAgendaVC: SWTableViewCellDelegate {
    func swipeableTableViewCell(_ cell: SWTableViewCell!, didTriggerLeftUtilityButtonWith index: Int) {
        //点击完成
        if let indexPath = tableView.indexPath(for: cell) {
            let vc = BXBAgendaDetailConfirmVC()
            vc.data = dataArr[indexPath.section]
            if dataArr[indexPath.section].visitTypeName == "增员" {
                vc.dataArr = ["增员面谈", "事业说明会", "面试", "入职培训"]
            }
            else if dataArr[indexPath.section].visitTypeName == "接洽" || dataArr[indexPath.section].visitTypeName == "面谈" || dataArr[indexPath.section].visitTypeName == "建议书" {
                vc.dataArr = ["开启面谈", "转介名单", "建议书", "签单", "客户服务"]
            }
            else if dataArr[indexPath.section].visitTypeName == "签单" {
                let vc = BXBAgendaDetailSigningVC()
                vc.data = self.dataArr[indexPath.section]
                navigationController?.pushViewController(vc, animated: true)
                return
            }
            else if dataArr[indexPath.section].visitTypeName == "客户服务" {
                vc.dataArr = ["运动", "羽毛球", "吃饭", "美容", "健身", "娱乐", "旅游"]
            }
            else{
                let vc = BXBAgendaDetailEditVC.init { (str) in
                    
                }
                vc.titleText = "说点什么吧..."
                vc.data = dataArr[indexPath.section]
                navigationController?.pushViewController(vc, animated: true)
                return
            }
            
            navigationController?.pushViewController(vc, animated: true)
        }
        
    }
    
    func swipeableTableViewCell(_ cell: SWTableViewCell!, didTriggerRightUtilityButtonWith index: Int) {
        
        switch index {
            
        case 0: //修改
            if let indexPath = tableView.indexPath(for: cell) {
                let vc = BXBAgendaDetailVC()
                vc.data = dataArr[indexPath.section]
                navigationController?.pushViewController(vc, animated: true)
            }
            
        case 1: //删除
            if let indexPath = tableView.indexPath(for: cell) {
                deleteAgenda(index: indexPath.section) {
                    self.dataArr.remove(at: indexPath.section)
                    self.tableView.deleteSection(UInt(indexPath.section), with: .right)
                }
            }
        default:
            break
        }
        
    }
}
*/


//MARK: - UIGestureRecognizerDelegate
extension BXBAgendaVC: UIGestureRecognizerDelegate {
    
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        
        let p = gestureRecognizer.location(in: tableView)
        if p.y > 0 { return false }
        
        let shouldBegin = tableView.contentOffset.y <= -tableView.contentInset.top
        
        if shouldBegin {
            let velocity = scopeGesture.velocity(in: view)
            
            switch calendar.scope {
            case .month:
                return velocity.y < 0
                
            case .week:
                return velocity.y > 0
            }
        }
        
     return shouldBegin
     }
    
}

//MARK: - 日历  delegate
extension BXBAgendaVC: FSCalendarDataSource, FSCalendarDelegate {
    
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        for (key, value) in agendaStatusDic {
            if key == dateFormatterYMD.string(from: date) && value.count > 0 {
                return 1
            }
        }
        return 0
    }
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, eventColorFor date: Date) -> UIColor? {
        //        let dateString = self.dateFormatter2.string(from: date)
        //        if self.datesWithEvent.contains(dateString) {
        //            return UIColor.purple
        //        }
        return UIColor.purple
    }
    
    func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
        calendar.height = bounds.size.height
        view.layoutIfNeeded()
    }
    
    func calendar(_ calendar: FSCalendar, subtitleFor date: Date) -> String? {
        if let event = eventsForDate(date: date).first {
            return event.title  // 春分、秋分、儿童节、植树节、国庆节、圣诞节...
        }

        guard let day = chineseCalendar?.component(.day, from: date) else {return ""}
        if day >= 1 {
            return lunarChars[day - 1] // 初一、初二、初三...
        }
        return ""
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        
//        let selectedDates = calendar.selectedDates.map({self.dateFormatter.string(from: $0)})
        
        if monthPosition == .next || monthPosition == .previous {
            calendar.setCurrentPage(date, animated: false)
        }
        
        guard calendar.selectedDate != nil else { return }
        currentDate = calendar.selectedDate!
       
    }
    
    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
        
        if isDidClickBackToToday == false {
            calendar.select(calendar.currentPage, scrollToDate: true)
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.3) {
                self.currentDate = calendar.currentPage
            }
        }
        else {
            isDidClickBackToToday = false
        }
//        print(calendar.currentPage)
        guard calendar.selectedDate != nil else { return }
        
        goTodayBtn.isHidden = NSCalendar.current.isDateInToday(calendar.selectedDate!)
        
//        tableView.reloadSection(0, with: .none)
    }
    
}

//MARK: - 导航
extension BXBAgendaVC: AgendaTabVCNaviBarDelegate {
    //提醒
    func didClickRightButton() {
        let vc = BXBMessageVC()
        navigationController?.pushViewController(vc, animated: true)
    }
}
