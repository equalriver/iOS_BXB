//
//  BXBWorkLogVC.swift
//  BXB
//
//  Created by equalriver on 2018/8/8.
//  Copyright © 2018年 tobosoft. All rights reserved.
//

import UIKit

class BXBWorkLogVC: BXBBaseNavigationVC {
    
    var meDataArr = Array<WorkLogListData>()
    
    var year = ""
    var month = ""
    var day = ""
    
    var meDate = ""
    var teamDate = ""
    
    var isOnlyMonth = false
    
    var meCommitArr = Array<WorkLogData>()
    var teamCommitArr = Array<WorkLogData>()
    var meUploadArr = Array<[String : Any]>()
    
    var isMeTableView = true {
        willSet{
            isOnlyMonth = !newValue
            meTableView.isHidden = !newValue
            teamTableView.isHidden = newValue
            confirmBtn.setTitle(newValue == true ? "提交" : "一键批阅", for: .normal)
            dateButton.setTitle(newValue == true ? " 更改时间" : " 更改月份", for: .normal)
            meButton.setTitleColor(newValue == true ? kColor_theme : kColor_text, for: .normal)
            teamTapLabel.textColor = newValue == false ? kColor_theme : kColor_text
            dateLabel.text = newValue == true ? meDate : teamDate
            
            if newValue == true {
                if meCommitArr.count == 0 { self.loadMeData(date: year + "-" + self.month + "-" + self.day) }
            }
            else {
                if teamCommitArr.count == 0 {}
            }
        }
    }
    
    lazy var formatter: DateFormatter = {
        let f = DateFormatter()
        f.dateFormat = "yyyy-MM-dd"
        return f
    }()

    
    lazy var meTableView: UITableView = {
        let tb = UITableView.init(frame: .zero, style: .plain)
        tb.separatorStyle = .none
        tb.dataSource = self
        tb.delegate = self
        return tb
    }()
    lazy var teamTableView: UITableView = {
        let tb = UITableView.init(frame: .zero, style: .plain)
        tb.separatorStyle = .none
        tb.dataSource = self
        tb.delegate = self
        tb.isHidden = true
        return tb
    }()
    lazy var meButton: UIButton = {
        let b = UIButton()
        b.titleLabel?.font = kFont_text_2_weight
        b.setTitle("我", for: .normal)
        b.setTitleColor(kColor_theme, for: .normal)
        b.addBlock(for: .touchUpInside, block: { [unowned self](btn) in
            self.isMeTableView = true
        })
        return b
    }()
    lazy var sepView_1: UIView = {
        let v = UIView()
        v.backgroundColor = kColor_background
        return v
    }()
    lazy var sepView_2: UIView = {
        let v = UIView()
        v.backgroundColor = kColor_background
        return v
    }()
    lazy var teamTapLabel: UILabel = {
        let l = UILabel()
        l.font = kFont_text_2_weight
        l.textColor = kColor_text
        l.text = "我的团队"
        l.textAlignment = .right
        l.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer.init(actionBlock: { [unowned self](ges) in
            self.isMeTableView = false
        })
        l.addGestureRecognizer(tap)
        return l
    }()
    lazy var teamBadgeLabel: UILabel = {
        let l = UILabel()
        l.font = UIFont.systemFont(ofSize: 11 * KScreenRatio_6)
        l.textColor = UIColor.white
        l.textAlignment = .center
        l.backgroundColor = kColor_theme
        l.layer.masksToBounds = true
        l.layer.cornerRadius = 7
        l.isHidden = true
        return l
    }()
    lazy var dateLabel: UILabel = {
        let l = UILabel()
        l.font = UIFont.systemFont(ofSize: 13 * KScreenRatio_6)
        l.textColor = kColor_subText
        l.backgroundColor = kColor_background
        let d = formatter.string(from: Date()).components(separatedBy: "-")
        if d.count == 3 {
            if let m = Int(d[1]), let day = Int(d[2]) {
                l.text = "    \(m)月\(day)日"
            }
        }
        return l
    }()
    lazy var dateButton: UIButton = {
        let b = UIButton()
        b.titleLabel?.font = UIFont.systemFont(ofSize: 13 * KScreenRatio_6)
        b.setTitle(" 更改时间", for: .normal)
        b.setTitleColor(kColor_subText, for: .normal)
        b.setImage(#imageLiteral(resourceName: "workLog_更改时间&月份"), for: .normal)
        b.backgroundColor = kColor_background
        b.addTarget(self, action: #selector(datePick), for: .touchUpInside)
        return b
    }()
    lazy var confirmBtn: UIButton = {
        let b = UIButton()
        b.titleLabel?.font = kFont_text
        b.setTitle("提交", for: .normal)
        b.setTitleColor(UIColor.white, for: .normal)
        b.backgroundColor = kColor_theme
        b.layer.cornerRadius = 3
        b.layer.masksToBounds = true
        b.addTarget(self, action: #selector(confirmAction(sender:)), for: .touchUpInside)
        return b
    }()
    
    
    //MARK: -
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "工作日志"
        initUI()
        loadMeData(date: formatter.string(from: Date()))
        let dateArr = formatter.string(from: Date()).components(separatedBy: "-")
        guard dateArr.count == 3 else { return }
        year = dateArr[0]
        month = dateArr[1]
        day = dateArr[2]
    }
    
    
    func initUI() {
        view.backgroundColor = UIColor.white
        view.addSubview(meTableView)
        view.addSubview(teamTableView)
        view.addSubview(meButton)
        view.addSubview(sepView_1)
        view.addSubview(sepView_2)
        view.addSubview(teamTapLabel)
        view.addSubview(teamBadgeLabel)
        view.addSubview(dateLabel)
        view.addSubview(dateButton)
        view.addSubview(confirmBtn)
        meButton.snp.makeConstraints { (make) in
            make.width.equalTo(kScreenWidth / 2 - 1)
            make.left.equalTo(view)
            make.top.equalTo(naviBar.snp.bottom)
            make.height.equalTo(40 * KScreenRatio_6)
        }
        sepView_1.snp.makeConstraints { (make) in
            make.size.equalTo(CGSize.init(width: 1, height: 20 * KScreenRatio_6))
            make.centerY.equalTo(meButton)
            make.left.equalTo(meButton.snp.right)
        }
        teamTapLabel.snp.makeConstraints { (make) in
            make.size.equalTo(CGSize.init(width: 120 * KScreenRatio_6, height: 40 * KScreenRatio_6))
            make.left.equalTo(sepView_1.snp.right)
            make.centerY.equalTo(meButton)
        }
        teamBadgeLabel.snp.makeConstraints { (make) in
            make.left.equalTo(teamTapLabel.snp.right).offset(2)
            make.size.equalTo(CGSize.init(width: 14, height: 14))
            make.centerY.equalTo(teamTapLabel)
        }
        sepView_2.snp.makeConstraints { (make) in
            make.size.equalTo(CGSize.init(width: kScreenWidth, height: 1))
            make.top.equalTo(meButton.snp.bottom)
            make.left.equalTo(view)
        }
        dateLabel.snp.makeConstraints { (make) in
            make.height.equalTo(40 * KScreenRatio_6)
            make.right.equalTo(dateButton.snp.left)
            make.top.equalTo(sepView_2.snp.bottom)
            make.left.equalTo(view)
        }
        dateButton.snp.makeConstraints { (make) in
            make.size.equalTo(CGSize.init(width: 100 * KScreenRatio_6, height: 40 * KScreenRatio_6))
            make.top.equalTo(sepView_2.snp.bottom)
            make.right.equalTo(view)
        }
        meTableView.snp.makeConstraints { (make) in
            make.top.equalTo(dateLabel.snp.bottom)
            make.width.centerX.equalTo(view)
            make.bottom.equalTo(view).offset(-65 * KScreenRatio_6)
        }
        teamTableView.snp.makeConstraints { (make) in
            make.top.equalTo(dateLabel.snp.bottom)
            make.width.centerX.equalTo(view)
            make.bottom.equalTo(view).offset(-65 * KScreenRatio_6)
        }
        confirmBtn.snp.makeConstraints { (make) in
            make.size.equalTo(CGSize.init(width: 355 * KScreenRatio_6, height: 45 * KScreenRatio_6))
            make.centerX.equalTo(view)
            make.bottom.equalTo(view).offset(-10 * KScreenRatio_6 - kIphoneXBottomInsetHeight)
        }
    }

    

}





















