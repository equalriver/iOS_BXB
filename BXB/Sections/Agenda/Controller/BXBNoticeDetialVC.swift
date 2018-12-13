//
//  BXBNoticeDetialVC.swift
//  BXB
//
//  Created by equalriver on 2018/8/19.
//  Copyright © 2018年 tobosoft. All rights reserved.
//

import UIKit

class BXBNoticeDetialVC: BXBBaseNavigationVC {
    
    public var data = AgendaRemindData(){
        willSet{
            titleLabel.text = newValue.matter
            tableView.reloadData()
        }
    }
    
    var titles = ["客户", "事项", "时间", "提醒"]
    //提醒
    let noticeDataArr = [ClientDetailNoticeTimeType.today.descrption(),
                         ClientDetailNoticeTimeType.oneDay.descrption(),
                         ClientDetailNoticeTimeType.twoDay.descrption(), ClientDetailNoticeTimeType.threeDay.descrption(), ClientDetailNoticeTimeType.oneWeek.descrption(), ClientDetailNoticeTimeType.custom.descrption()]
    public var noticeSelectedItem = 3
    
    //是否可以编辑
    var isCanEdit = false{
        willSet{
//            confirmBtn.isHidden = !newValue
        }
    }
    
    lazy var titleLabel: UILabel = {
        let l = UILabel()
        l.font = kFont_text_weight
        l.textColor = kColor_text
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
    lazy var moreBarItemBtn: UIButton = {
        let b = UIButton()
//        b.setImage(#imageLiteral(resourceName: "bxb_更多"), for: .normal)
        b.titleLabel?.font = kFont_naviBtn_weight
        b.setTitle("编辑", for: .normal)
        b.setTitleColor(kColor_theme, for: .normal)
        return b
    }()
//    lazy var confirmBtn: UIButton = {
//        let b = UIButton()
//        b.titleLabel?.font = kFont_btn_weight
//        b.setTitle("保 存", for: .normal)
//        b.setTitleColor(UIColor.white, for: .normal)
//        b.backgroundColor = kColor_theme
//        b.layer.cornerRadius = 25 * KScreenRatio_6
//        b.layer.masksToBounds = true
//        b.isHidden = true
//        b.addTarget(self, action: #selector(confirmButtonClick(sender:)), for: .touchUpInside)
//        return b
//    }()
    lazy var dateFormatter: DateFormatter = {
        let d = DateFormatter()
        d.dateFormat = "yyyy-MM-dd HH:mm"
        return d
    }()
    lazy var dateFormatter_std: DateFormatter = {
        let d = DateFormatter()
        d.dateFormat = "yyyy-MM-dd"
        return d
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
        naviBar.naviBackgroundColor = kColor_background!
    }

    func initUI() {
        //        title = "查看日程明细"
        view.backgroundColor = kColor_background
        naviBar.rightBarButtons = [moreBarItemBtn]
        view.addSubview(titleLabel)
        view.addSubview(tableView)
//        view.addSubview(confirmBtn)
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(view).offset(20 * KScreenRatio_6)
            make.size.equalTo(CGSize.init(width: kScreenWidth / 2, height: 20 * KScreenRatio_6))
            make.top.equalTo(naviBar.snp.bottom).offset(15 * KScreenRatio_6)
        }
        tableView.snp.makeConstraints { (make) in
            make.top.equalTo(titleLabel.snp.bottom).offset(30 * KScreenRatio_6)
            make.centerX.equalTo(view)
            make.width.equalTo(345 * KScreenRatio_6)
            make.height.equalTo(240 * KScreenRatio_6)
        }
//        confirmBtn.snp.makeConstraints { (make) in
//            make.size.equalTo(CGSize.init(width: 280 * KScreenRatio_6, height: 50 * KScreenRatio_6))
//            make.centerX.equalTo(view)
//            make.bottom.equalTo(view).offset(-30 * KScreenRatio_6 - kIphoneXBottomInsetHeight)
//        }
    }

    
    

}



















