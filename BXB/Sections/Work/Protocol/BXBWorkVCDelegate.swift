//
//  BXBWorkVCDelegate.swift
//  BXB
//
//  Created by equalriver on 2018/9/26.
//  Copyright © 2018年 tobosoft. All rights reserved.
//

import Foundation
import ObjectMapper

//MARK: - action
extension BXBWorkViewController {
    
    //新建日程
    func addNewAgenda() {
        loginValidate(currentVC: self) { (isLogin) in
            guard isLogin else { return }
            if let t = UIApplication.shared.keyWindow?.rootViewController {
                guard t.isKind(of: BXBTabBarController.self) else { return }
                let tab = t as! BXBTabBarController
                tab.selectedIndex = 1
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
                    NotificationCenter.default.post(name: .kNotiAddNewAgendaByOtherController, object: nil)
                }
            }
        }
        
    }
    
    //日程展开
    @objc func showAgendaMore(sender: UIButton) {
        
        sender.isSelected = !sender.isSelected
        
//        guard self.agendaArr.count > 2 else { return }
        
        self.isShowAgendaMore = sender.isSelected
    }
    
    //提醒展开
    @objc func showNoticeMore(sender: UIButton) {
        
        sender.isSelected = !sender.isSelected
        
//        guard self.noticeArr.count > 2 else { return }

        self.isShowNoticeMore = sender.isSelected
    }
    
    //MARK: - noti
    //刷新日程
    @objc func notiAgendaShouldRefreshData(sender: Notification) {
        
        BXBNetworkTool.isShowSVProgressHUD = false
        
        if sender.userInfo != nil {
            
            if let loginOut: Bool = sender.userInfo!["loginOut"] as? Bool {
                if loginOut == true {
                    agendaArr.removeAll()
                    noticeArr.removeAll()
                    isShowAgendaMore = false
                    isShowNoticeMore = false
                    reportView.data = BXBWorkData()
                    day_report = BXBWorkData()
                    month_report = BXBWorkData()
                    isShowNoticeMore = false
                    isShowAgendaMore = false
                    return
                }
            }
        }
        loadData()
    }
    
    //刷新提醒
    @objc func notiRemindShouldRefreshData() {
        dayNotice()
    }
    
    //提醒跟进
    @objc func notiWorkDidFinishNotice(sender: Notification) {
        if let info = sender.userInfo {
            guard let id = info["workNoticeId"] as? Int else { return }
            BXBNetworkTool.BXBRequest(router: .editClientRemind(id: id, args: ["isFollow": "1"]), success: { (resp) in
                
                NotificationCenter.default.post(name: .kNotiRemindShouldRefreshData, object: nil)
                
            }) { (error) in
                
            }
        }
    }
    
    //MARK: - network
    
    func setRefresh() {
        BXBNetworkRefresh.headerRefresh(scrollView: contentSV) {[weak self] in
            self?.loadData()
            self?.dayNotice()
            self?.dayReport()
            self?.monthReport()
        }
    }
    
    ///获取某天日程
    func loadData() {
        BXBNetworkTool.isShowSVProgressHUD = false
        BXBNetworkTool.BXBRequest(router: Router.searchAgendaByDay(time: dateFormatterYMD.string(from: Date())), success: { (resp) in
            
            self.contentSV.mj_header.endRefreshing()
            
            if let data = Mapper<AgendaData>().mapArray(JSONObject: resp["data"].arrayObject){
                self.agendaArr.removeAll()
                self.agendaAllCount = data.count
                self.agendaArr = data.filter({ (obj) -> Bool in
                    return obj.status == 0
                })
            }
            let state = self.isShowAgendaMore
            self.isShowAgendaMore = state
            
        }) { (error) in
            self.contentSV.mj_header.endRefreshing()
        }
        
    }
    
    //当天提醒
    func dayNotice() {
        BXBNetworkTool.isShowSVProgressHUD = false
        BXBNetworkTool.BXBRequest(router: .todayNotice(), success: { (resp) in
        
            self.contentSV.mj_header.endRefreshing()
            
            if let data = Mapper<NoticeDetailData>().mapArray(JSONObject: resp["data"].arrayObject){
                self.noticeArr.removeAll()
                self.noticeArr = data.filter({ (obj) -> Bool in
                    return obj.isFollow != "1"
                })
                let state = self.isShowNoticeMore
                self.isShowNoticeMore = state
            }
            
        }) { (error) in
            self.contentSV.mj_header.endRefreshing()
        }
    }
    
    //日工作简报
    func dayReport() {
        BXBNetworkTool.isShowSVProgressHUD = false
        BXBNetworkTool.BXBRequest(router: .dayReport(), success: { (resp) in
            
            self.contentSV.mj_header.endRefreshing()
            
            if let data = Mapper<BXBWorkData>().map(JSONObject: resp["data"].object){
                self.day_report = data
                self.reportView.data = self.isDayReport ? self.day_report : self.month_report
            }
            
        }) { (error) in
            self.contentSV.mj_header.endRefreshing()
        }
    }
    
    //月工作简报
    func monthReport() {
        BXBNetworkTool.isShowSVProgressHUD = false
        BXBNetworkTool.BXBRequest(router: .monthReport(), success: { (resp) in
            
            self.contentSV.mj_header.endRefreshing()
            
            if let data = Mapper<BXBWorkData>().map(JSONObject: resp["data"].object){
                self.month_report = data
                self.reportView.data = self.isDayReport ? self.day_report : self.month_report
            }
            
        }) { (error) in
            self.contentSV.mj_header.endRefreshing()
        }
    }
    
}

//MARK: - 待办添加日程
extension BXBWorkViewController: BXBWorkAgendaDelegate {
    //点击✅
    func didClickFinish(sender: UIButton, cell: UITableViewCell) {
        guard let indexPath = agendaTableView.indexPath(for: cell) else { return }
        sender.isSelected = true
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.25) {
            let vc = BXBAgendaFinishMatterVC()
            let data = self.agendaArr[indexPath.row]
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
                self.navigationController?.pushViewController(vc, animated: true)
                return
            }
            else{//保单服务  客户服务
                let vc = BXBAgendaDetailEditVC.init()
                vc.titleText = "说点什么吧..."
                vc.data = data
                vc.isNeedPopToRootVC = true
                self.navigationController?.pushViewController(vc, animated: true)
                return
            }
            
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    //添加日程
    func didClickAddNewAgenda() {
        addNewAgenda()
    }
}

//MARK: - 提醒跟进
extension BXBWorkViewController: BXBWorkNoticeDelegate {
    
    func didClickFollow(cell: BXBWorkNoticeCell) {
        
        guard let indexPath = noticeTableView.indexPath(for: cell) else { return }
        
        if isNoticeFollow == true { return }
        
        isNoticeFollow = true
        
        let rect = cell.convert(cell.followBtn.frame, to: view)
        let p = CGPoint.init(x: rect.origin.x + rect.size.width / 2, y: rect.origin.y + rect.size.height / 2 - 15 * KScreenRatio_6)
        
        BXBNetworkTool.isShowSVProgressHUD = false
        
        BXBNetworkTool.BXBRequest(router: .editClientRemind(id: noticeArr[indexPath.row].id, args: ["isFollow": "1"]), success: { (resp) in
            
            DispatchQueue.global().async {
                NotificationCenter.default.post(name: .kNotiRemindShouldRefreshData, object: nil)
                BXBNetworkTool.isShowSVProgressHUD = false
                self.createFollowAgenda(data: self.noticeArr[indexPath.row], animatePoint: p)
            }
            
        }) { (error) in
            
        }
        
        
//        if let indexPath = noticeTableView.indexPath(for: cell) {
//
//            if let t = UIApplication.shared.keyWindow?.rootViewController {
//
//                guard t.isKind(of: BXBTabBarController.self) else { return }
//
//                let tab = t as! BXBTabBarController
//                tab.selectedIndex = 1
//                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
//                    let data = self.noticeArr[indexPath.row]
//                    data.isWorkData = true
//                    NotificationCenter.default.post(name: NSNotification.Name.init(kNotiAddNewAgendaByOtherController), object: nil, userInfo: ["WorkData": data])
//                }
//            }
//        }
    }
    
    //创建跟进日程
    func createFollowAgenda(data: NoticeDetailData, animatePoint: CGPoint) {
        
        let currentCa = NSCalendar.current
        
        let com = currentCa.dateComponents([.minute], from: Date())
        
        let ca = NSCalendar.init(calendarIdentifier: .gregorian)
        var comps = DateComponents.init()
        
        guard com.minute != nil else { return }
        comps.setValue(60 - com.minute!, for: .minute)
        
        guard let date = ca?.date(byAdding: comps, to: Date(), options: NSCalendar.Options(rawValue: 0)) else { return }
        
        //提醒时间
        let fireDate = BXBLocalizeNotification.getDateWithRemindName(name: "日程开始时", date: date)
        
        BXBNetworkTool.BXBRequest(router: .addNewAgenda(args: ["name": data.name,
                                                               "visitDate": self.dateFormatter.string(from: date),
                                                               "visitTepyName": "客户服务",
                                                               "remindTime": "日程开始时",
                                                               "remindDate": self.dateFormatter.string(from: date),
                                                               ]), success: { (resp) in
             
                                                                
            let id = resp["id"].intValue
                                                                
            BXBLocalizeNotification.sendLocalizeNotification(id: id, alertTitle: "日程提醒: 你有一条日程需要处理", alertBody: "\(self.dateFormatter.string(from: date))  \(data.matter)  \(data.name)", image: nil, fireDate: fireDate)
            NotificationCenter.default.post(name: .kNotiClientShouldRefreshData, object: nil)
            NotificationCenter.default.post(name: .kNotiAgendaShouldRefreshData, object: nil, userInfo: ["selectedDate": date])
            
            //刷新日程
            BXBNetworkTool.isShowSVProgressHUD = false
            BXBNetworkTool.BXBRequest(router: Router.searchAgendaByDay(time: self.dateFormatterYMD.string(from: Date())), success: { (resp) in
                
                self.contentSV.mj_header.endRefreshing()
                
                if let data = Mapper<AgendaData>().mapArray(JSONObject: resp["data"].arrayObject){
                    self.agendaArr.removeAll()
                    self.agendaAllCount = data.count
                    self.agendaArr = data.filter({ (obj) -> Bool in
                        return obj.status == 0
                    })
                }
                
                self.followAnimation(startPoint: animatePoint)
                self.isNoticeFollow = false
                
            }) { (error) in
                self.isNoticeFollow = false
                self.contentSV.mj_header.endRefreshing()
            }
                                                                
        }) { (error) in
            
        }
    }
    
    //跟进动画
    func followAnimation(startPoint: CGPoint) {
        let rect = contentSV.convert(agendaTableView.frame, to: view)
        let endPoint = CGPoint.init(x: rect.origin.x + rect.size.width / 2, y: rect.origin.y + rect.size.height - 30 * KScreenRatio_6)
        let curvePoint = CGPoint.init(x: startPoint.x + 60 * KScreenRatio_6, y: startPoint.y - 80 * KScreenRatio_6)
        
        bezierPath.move(to: startPoint)
        
        bezierPath.addCurve(to: endPoint, controlPoint1: startPoint, controlPoint2: curvePoint)
        view.layer.addSublayer(followAnimationLayer)
        
        let an = CAKeyframeAnimation.init(keyPath: "position")
        an.path = bezierPath.cgPath
        
        let alphaAn = CABasicAnimation.init(keyPath: "alpha")
        alphaAn.duration = 0.5
        alphaAn.fromValue = NSNumber.init(value: 1.0)
        alphaAn.toValue = NSNumber.init(value: 0.1)
        alphaAn.timingFunction = CAMediaTimingFunction.init(name: CAMediaTimingFunctionName.easeOut)
        
        let groups = CAAnimationGroup.init()
        groups.animations = [an, alphaAn]
        groups.duration = 0.8
        groups.isRemovedOnCompletion = false
        groups.fillMode = .forwards
        
        followAnimationLayer.add(groups, forKey: nil)
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
            self.agendaTableView.reloadData()
        }
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.8) {
            self.bezierPath.removeAllPoints()
            self.followAnimationLayer.removeFromSuperlayer()
        }
    }
}

//MARK: - table view
extension BXBWorkViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == agendaTableView {
            if agendaArr.count == 0 {
                return 1
            }
            else {
                if isShowAgendaMore { return agendaArr.count + 1 }
                else { return 2 }
            }
        }
        else {
            if noticeArr.count == 0 {
                return 1
            }
            else {
                if isShowNoticeMore == false && noticeArr.count > 2 { return 2 }
                else { return noticeArr.count }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == agendaTableView {
            if agendaArr.count == 0 {
                return 50 * 2 * KScreenRatio_6
            }
            return 50 * KScreenRatio_6
        }
        else {
            if noticeArr.count == 0 {
                return 50 * 2 * KScreenRatio_6
            }
            return 50 * KScreenRatio_6
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60 * KScreenRatio_6
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == agendaTableView {
            var cell = tableView.dequeueReusableCell(withIdentifier: "BXBWorkAgendaCell") as? BXBWorkAgendaCell
            if cell == nil {
                cell = BXBWorkAgendaCell.init(style: .default, reuseIdentifier: "BXBWorkAgendaCell")
            }
            cell?.delegate = self
            cell?.finishBtn.isSelected = false
            
            if agendaArr.count == 0 {
                cell?.isNoData = true
            }
            else {
                if indexPath.row == agendaArr.count {//最后一行显示添加
                    cell?.isAddAgenda = true
                    return cell!
                }
                cell?.data = agendaArr[indexPath.row]
                
            }
            return cell!
        }
        else {
            var cell = tableView.dequeueReusableCell(withIdentifier: "BXBWorkNoticeCell") as? BXBWorkNoticeCell
            if cell == nil {
                cell = BXBWorkNoticeCell.init(style: .default, reuseIdentifier: "BXBWorkNoticeCell")
            }
            cell?.delegate = self
            if noticeArr.count == 0 { cell?.isNoData = true }
            else { cell?.data = noticeArr[indexPath.row] }
            
            return cell!
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let v = UIView.init(frame: CGRect.init(x: 0, y: 0, width: 345 * KScreenRatio_6, height: 60 * KScreenRatio_6))
        v.backgroundColor = UIColor.white
        
        let l = UILabel()
        l.font = kFont_text_2
        l.textColor = kColor_text
//        l.text = tableView == noticeTableView ? "今日提醒" : nil
        
        if tableView == agendaTableView {
            let c1 = "(\(agendaArr.count))"
//            let c2 = "\(agendaAllCount)"
            let att = NSMutableAttributedString.init(string: "今日待办 " + c1)
            att.addAttributes([.font: kFont_text_2, .foregroundColor: kColor_text!], range: NSMakeRange(0, 5))
//            att.addAttributes([.font: kFont_text_3, .foregroundColor: kColor_subText!], range: NSMakeRange(4, 1))
            att.addAttributes([.font: kFont_text_2, .foregroundColor: kColor_theme!], range: NSMakeRange(5, c1.count))
//            att.addAttributes([.font: kFont_text_3, .foregroundColor: kColor_subText!], range: NSMakeRange(5 + c1.count, c2.count + 2))
            l.attributedText = att
        }
        else {
            let c1 = "(\(noticeArr.count))"
   
            let att = NSMutableAttributedString.init(string: "今日提醒 " + c1)
            att.addAttributes([.font: kFont_text_2, .foregroundColor: kColor_text!], range: NSMakeRange(0, 5))
            att.addAttributes([.font: kFont_text_2, .foregroundColor: kColor_theme!], range: NSMakeRange(5, c1.count))
            
            l.attributedText = att
        }
 
        v.addSubview(l)

        if tableView == agendaTableView {
            v.addSubview(agendaMoreBtn)
            agendaMoreBtn.snp.makeConstraints { (make) in
                make.size.equalTo(CGSize.init(width: 60 * KScreenRatio_6, height: 30 * KScreenRatio_6))
                make.centerY.equalTo(l)
                make.right.equalToSuperview()
            }
        }
        else {
            v.addSubview(noticeMoreBtn)
            noticeMoreBtn.snp.makeConstraints { (make) in
                make.size.equalTo(CGSize.init(width: 60 * KScreenRatio_6, height: 30 * KScreenRatio_6))
                make.centerY.equalTo(l)
                make.right.equalToSuperview()
            }
        }
        
        let sepView = UIView()
        sepView.backgroundColor = kColor_separatorView
        v.addSubview(sepView)
        
        l.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(20 * KScreenRatio_6)
            make.top.equalToSuperview().offset(15 * KScreenRatio_6)
        }
        sepView.snp.makeConstraints { (make) in
            make.width.centerX.equalToSuperview()
            make.height.equalTo(0.5)
            make.top.equalTo(l.snp.bottom).offset(15 * KScreenRatio_6)
        }
        
        
        return v
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == agendaTableView {
            //日程详情
            if agendaArr.count == 0 { return }
            if agendaArr.count == 1 {
                if indexPath.row == 1 { return }
            }
            let vc = BXBAgendaDetailVC()
            vc.agendaId = agendaArr[indexPath.row].id
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}

//MARK: - top buttons collection view
extension BXBWorkViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BXBWorkTopButtonsCell", for: indexPath) as! BXBWorkTopButtonsCell
        cell.iconIV.image = [UIImage.init(named: "work_日程安排"), UIImage.init(named: "work_客户管理"), UIImage.init(named: "work_团队管理"), UIImage.init(named: "work_智能提醒")][indexPath.item]
        cell.titleLabel.text = ["日程安排", "客户管理", "团队管理", "智能提醒"][indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        loginValidate(currentVC: self) { (isLogin) in
            if isLogin {
                //日程，客户，我的
                if indexPath.item != 3 {
                    
                    if indexPath.item == 0 {//日程
                        if UserDefaults.standard.string(forKey: "bxb_didLoadAgendaIntro") == nil {
                            
                            let vc = BXBWorkIntroVC.init(type: .agenda) {
                                if let t = UIApplication.shared.keyWindow?.rootViewController {
                                    guard t.isKind(of: BXBTabBarController.self) else { return }
                                    let tab = t as! BXBTabBarController
                                    tab.selectedIndex = indexPath.item + 1
                                }
                                UserDefaults.standard.setValue("bxb_didLoadAgendaIntro", forKey: "bxb_didLoadAgendaIntro")
                            }
                            navigationController?.pushViewController(vc, animated: true)
                            return
                        }
                    }
                    if indexPath.item == 1 {//客户
                        if UserDefaults.standard.string(forKey: "bxb_didLoadClientIntro") == nil {
                            
                            let vc = BXBWorkIntroVC.init(type: .client) {
                                if let t = UIApplication.shared.keyWindow?.rootViewController {
                                    guard t.isKind(of: BXBTabBarController.self) else { return }
                                    let tab = t as! BXBTabBarController
                                    tab.selectedIndex = indexPath.item + 1
                                }
                                UserDefaults.standard.setValue("bxb_didLoadClientIntro", forKey: "bxb_didLoadClientIntro")
                            }
                            navigationController?.pushViewController(vc, animated: true)
                            return
                        }
                    }
                    if indexPath.item == 2 {//我的
                        if UserDefaults.standard.string(forKey: "bxb_didLoadTeamIntro") == nil {
                            
                            let vc = BXBWorkIntroVC.init(type: .team) {
                                if let t = UIApplication.shared.keyWindow?.rootViewController {
                                    guard t.isKind(of: BXBTabBarController.self) else { return }
                                    let tab = t as! BXBTabBarController
                                    tab.selectedIndex = indexPath.item + 1
                                }
                                UserDefaults.standard.setValue("bxb_didLoadTeamIntro", forKey: "bxb_didLoadTeamIntro")
                            }
                            navigationController?.pushViewController(vc, animated: true)
                            return
                        }
                    }
                    
                    if let t = UIApplication.shared.keyWindow?.rootViewController {
                        guard t.isKind(of: BXBTabBarController.self) else { return }
                        let tab = t as! BXBTabBarController
                        tab.selectedIndex = indexPath.item + 1
                    }
                }
                //提醒
                if indexPath.item == 3 {
                    if UserDefaults.standard.string(forKey: "bxb_didLoadNoticeIntro") == nil {
                        
                        let vc = BXBWorkIntroVC.init(type: .notice) {[unowned self] in
                            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5, execute: {
                                
                                let vc = BXBMessageVC()
                                self.navigationController?.pushViewController(vc, animated: true)
                                return
                                
                            })
                            UserDefaults.standard.setValue("bxb_didLoadNoticeIntro", forKey: "bxb_didLoadNoticeIntro")
                            return
                        }
                        navigationController?.pushViewController(vc, animated: true)
                        return
                    }
                    
                    let vc = BXBMessageVC()
                    navigationController?.pushViewController(vc, animated: true)
                    
                }
            }
        }
        
    }
}

//MARK: - 工作简报
extension BXBWorkViewController: BXBWorkReportDelegate {
    //日月切换
    func didClickRightButton(sender: UIButton) {
        loginValidate(currentVC: self) { (isLogin) in
            guard isLogin else { return }
            sender.isSelected = !sender.isSelected
            isDayReport = !sender.isSelected
            reportView.data = sender.isSelected ? month_report : day_report
        }
        
    }
}


