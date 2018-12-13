//
//  BXBAgendaDetailVC.swift
//  BXB
//
//  Created by equalriver on 2018/6/10.
//  Copyright © 2018年 tobosoft. All rights reserved.
//

import UIKit

class BXBAgendaDetailVC: BXBBaseNavigationVC {
    
    public var noticeSelectedItem = 3
    
    public var agendaId = 0
    
    var data = AgendaData(){
        willSet{
            confirmBtn.isHidden = newValue.status == 1
            if newValue.visitTypeName == "客户服务" {
                signingLabel.isHidden = false
            }
            else {
                signingLabel.isHidden = newValue.status == 0
            }
            
            if noticeDataArr.contains(newValue.remindTime) {
                noticeSelectedItem = noticeDataArr.index(of: newValue.remindTime)!
            }
            titleLabel.text = newValue.visitTypeName
            
            var matters = [newValue.matter]
            var matter_str = ""
            let signingStr = newValue.policyNum.count == 0 ? "" : " 签单（\(newValue.policyNum)件 \(newValue.amount)元）"
            
            if newValue.matter.contains(",") {
                matters = newValue.matter.components(separatedBy: ",")
                for v in matters {
                    if v == "签单" { continue }
                    matter_str += v + " "
                }
                signingLabel.text = matter_str + signingStr
            }
            else {
                matter_str = newValue.matter == "签单" ? "" : newValue.matter + " "
                signingLabel.text = matter_str + signingStr
            }
            signingLabel.snp.updateConstraints { (make) in
                make.height.equalTo(signingLabel.text!.getStringHeight(font: kFont_text, width: signingLabel.width))
            }

            
            confirmBtn.isHidden = newValue.status == 1
            if newValue.status == 1 {
                normalAngedaTitles = ["拜访对象", "开始时间", "拜访地址", "提醒", "备注", "心得"]
            }
            tableView.snp.updateConstraints { (make) in
                if newValue.status == 1 {
                    make.height.equalTo((newValue.remarks + newValue.heart).getStringHeight(font: kFont_text, width: 315 * KScreenRatio_6) + 360 * KScreenRatio_6)
                }
                else { make.height.equalTo(newValue.remarks.getStringHeight(font: kFont_text, width: 315 * KScreenRatio_6) + 320 * KScreenRatio_6) }
            }
            tableView.reloadData()
        }
    }

    
    var normalAngedaTitles = ["拜访对象", "开始时间", "拜访地址", "提醒", "备注"]
    
    //是否可以编辑
    var isCanEdit = false {
        willSet{
            confirmBtn.isHidden = newValue || data.status == 1
            tableView.isScrollEnabled = newValue
            tableView.reloadData()
            if newValue == false {
                tableView.scrollToTop()
            }

        }
    }
    
    var oldDate = ""
    var oldNotice = ""
    
    //是否修改过提醒
    var isEditNotice = false {
        willSet{
            if newValue {
                //提醒时间
                guard data.status == 0 else { return }
                guard dateFormatter.date(from: data.visitDate) != nil else { return }
                let fireDate = BXBLocalizeNotification.getDateWithRemindName(name: data.remindTime, date: dateFormatter.date(from: data.visitDate)!)
                BXBLocalizeNotification.sendLocalizeNotification(id: data.id, alertTitle: "日程提醒: 你有一条日程需要处理", alertBody: "\(self.data.visitDate)  \(self.data.visitTypeName)  \(self.data.name)", image: nil, fireDate: fireDate)
            }
        }
    }
    
    //提醒
    public var noticeDataArr = ["无", "日程开始时", "30分钟前", "1小时前", "2小时前", "自定义"]
    
    
    lazy var titleLabel: UILabel = {
        let l = UILabel()
        l.font = kFont_text_weight
        l.textColor = kColor_text
        return l
    }()
    lazy var signingLabel: UILabel = {
        let l = UILabel()
        l.font = kFont_text_3
        l.numberOfLines = 2
        l.textColor = kColor_theme
        return l
    }()
    lazy var tableView: UITableView = {
        let tb = UITableView.init(frame: CGRect.zero, style: .plain)
        tb.backgroundColor = UIColor.white
        tb.layer.cornerRadius = kCornerRadius
        tb.layer.masksToBounds = true
        tb.dataSource = self
        tb.delegate = self
        tb.separatorStyle = .none
        tb.isScrollEnabled = false
        return tb
    }()
    lazy var countLabel: UILabel = {
        let l = UILabel()
        l.isHidden = true
        l.textAlignment = .right
        return l
    }()
//    lazy var moreBarItemBtn: UIButton = {
//        let b = UIButton()
//        b.setImage(#imageLiteral(resourceName: "popover_shanchu"), for: .normal)
//        b.tag = 1
//        return b
//    }()
    lazy var saveBtn: UIButton = {
        let b = UIButton()
        b.titleLabel?.font = kFont_naviBtn_weight
        b.setTitle("编辑", for: .normal)
        b.setTitleColor(kColor_theme, for: .normal)
        b.tag = 2
        return b
    }()
    lazy var confirmBtn: ImageTopButton = {
        let b = ImageTopButton()
        b.titleLabel?.font = kFont_text_3
        b.setTitle("完成", for: .normal)
        b.setTitleColor(kColor_text, for: .normal)
        b.setImage(#imageLiteral(resourceName: "bxb_btn完成"), for: .normal)
        b.addTarget(self, action: #selector(confirmButtonClick(sender:)), for: .touchUpInside)
        b.isHidden = true
        return b
    }()
    lazy var dateFormatter: DateFormatter = {
        let d = DateFormatter()
        d.dateFormat = "yyyy-MM-dd HH:mm"
        return d
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
        oldDate = data.visitDate
        oldNotice = data.remindTime
        loadData(id: agendaId)
        naviBar.naviBackgroundColor = kColor_background!
    }
    
    func initUI() {
        view.backgroundColor = kColor_background
        naviBar.rightBarButtons = [saveBtn]
        view.addSubview(titleLabel)
        view.addSubview(signingLabel)
        view.addSubview(tableView)
        view.addSubview(confirmBtn)
        view.addSubview(countLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(view).offset(20 * KScreenRatio_6)
            make.size.equalTo(CGSize.init(width: kScreenWidth / 2, height: 20 * KScreenRatio_6))
            make.top.equalTo(naviBar.snp.bottom).offset(15 * KScreenRatio_6)
        }
        signingLabel.snp.makeConstraints { (make) in
            make.left.equalTo(titleLabel)
            make.top.equalTo(titleLabel.snp.bottom).offset(10 * KScreenRatio_6)
            make.right.equalTo(view).offset(-15 * KScreenRatio_6)
            make.height.equalTo(17 * KScreenRatio_6)
        }
        tableView.snp.makeConstraints { (make) in
            make.top.equalTo(signingLabel).offset(50 * KScreenRatio_6)
            make.centerX.equalTo(view)
            make.width.equalTo(345 * KScreenRatio_6)
            if data.heart.count > 0 && data.status == 1 {
                make.height.equalTo(420 * KScreenRatio_6)
            }
            else { make.height.equalTo(340 * KScreenRatio_6) }
        }
        confirmBtn.snp.makeConstraints { (make) in
            make.size.equalTo(CGSize.init(width: 100 * KScreenRatio_6, height: 100 * KScreenRatio_6))
            make.centerX.equalTo(view)
            make.bottom.equalTo(view).offset(-15 * KScreenRatio_6 - kIphoneXBottomInsetHeight)
        }
        countLabel.snp.makeConstraints { (make) in
            make.right.equalTo(tableView).offset(-10 * KScreenRatio_6)
             make.bottom.equalTo(tableView)
            make.size.equalTo(CGSize.init(width: 60 * KScreenRatio_6, height: 20 * KScreenRatio_6))
        }
    }
    
    
}




