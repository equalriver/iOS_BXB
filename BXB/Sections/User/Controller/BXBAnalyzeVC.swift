//
//  BXBAnalyzeVC.swift
//  BXB
//
//  Created by equalriver on 2018/7/1.
//  Copyright © 2018年 tobosoft. All rights reserved.
//

import UIKit
import ObjectMapper

class BXBAnalyzeVC: BXBBaseNavigationVC {
    
    var sectionTitles = ["本月目标", "工作简报", "业务活动量详细", "签单用户总览", "转化率分析"]
    
    var data = AnalyzeData()
    
    var personData = AnalyzeData()
    
    var teamData = AnalyzeData()
    
    var isPersonData = true
    
    var currentMonth = 1
    

    lazy var dateFormatter: DateFormatter = {
        let d = DateFormatter()
        d.dateFormat = "yyyy-MM-dd"
        return d
    }()
    
    lazy var titleView: UISegmentedControl = {
        let v = UISegmentedControl.init(items: ["个人", "团队"])
        v.backgroundColor = UIColor.white
        v.selectedSegmentIndex = 0
        v.tintColor = kColor_theme
        v.setTitleTextAttributes([.font: kFont_navi_weight], for: UIControl.State.normal)
        v.setTitleTextAttributes([.font: kFont_navi_weight], for: UIControl.State.selected)
        v.addTarget(self, action: #selector(titleSelected(sender:)), for: .valueChanged)
        return v
    }()
    
    lazy var tableView: UITableView = {
        let tb = UITableView.init(frame: .zero, style: .grouped)
        tb.backgroundColor = UIColor.white
        tb.separatorStyle = .none
        tb.dataSource = self
        tb.delegate = self
        return tb
    }()
    
    lazy var currentTargetCell: AnalyzeCurrentTargetCell = {
        let c = AnalyzeCurrentTargetCell.init(style: .default, reuseIdentifier: nil)
        return c
    }()
    lazy var workReportCell: AnalyzeWorkReportCell = {
        let v = AnalyzeWorkReportCell.init(style: .default, reuseIdentifier: nil)
        v.backgroundColor = UIColor.white
        return v
    }()
    lazy var activityCell: AnalyzeActivityCell = {
        let c = AnalyzeActivityCell.init(style: .default, reuseIdentifier: nil)
        return c
    }()
    lazy var changeCell: AnalyzeChangeCell = {
        let c = AnalyzeChangeCell.init(style: .default, reuseIdentifier: nil)
        return c
    }()
    
    lazy var rightMonthButton: TitleFrontButton = {
        let b = TitleFrontButton()
        b.titleLabel?.font = kFont_naviBtn_weight
        b.setTitleColor(kColor_text, for: .normal)
        b.setImage(#imageLiteral(resourceName: "client_下箭头_灰"), for: .normal)
        return b
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
        loadPersonData(date: dateFormatter.string(from: Date()))
    }

   
    func initUI() {
        naviBar.titleView.isUserInteractionEnabled = true
        naviBar.titleView.addSubview(titleView)
        titleView.snp.makeConstraints { (make) in
            make.size.equalTo(CGSize.init(width: 140 * KScreenRatio_6, height: 30 * KScreenRatio_6))
            make.center.equalTo(naviBar.titleView)
        }
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.width.bottom.centerX.equalTo(view)
            make.top.equalTo(naviBar.snp.bottom)
        }
        
        let dates = dateFormatter.string(from: Date()).components(separatedBy: "-")
        if dates.count >= 1 {
            let month = dates[1]
            rightMonthButton.setTitle("\(Int(month)!)月", for: .normal)
            currentMonth = Int(month)!
            naviBar.rightBarButtons = [rightMonthButton]
        }
        
    }
    
    
    //MARK: - action
    override func rightButtonsAction(sender: UIButton) {
        let vc = BXBAnalyzePopoverVC()
        vc.delegate = self
        vc.preferredContentSize = CGSize.init(width: 100 * KScreenRatio_6, height: 240 * KScreenRatio_6)
        vc.modalPresentationStyle = .popover
        vc.currentMonth = currentMonth
        if let pop = vc.popoverPresentationController {
            pop.delegate = self
            pop.backgroundColor = UIColor.white
            pop.permittedArrowDirections = .up
            pop.sourceView = sender
            pop.sourceRect = sender.bounds
            sender.setImage(#imageLiteral(resourceName: "me_上三角形"), for: .normal)
            present(vc, animated: true, completion: nil)
        }
        
    }
    
    @objc func titleSelected(sender: UISegmentedControl) {
        isPersonData = sender.selectedSegmentIndex == 0
        var m = ""
        m = currentMonth < 10 ? "0" + "\(currentMonth)" : "\(currentMonth)"
        let dates = dateFormatter.string(from: Date()).components(separatedBy: "-")
        if dates.count == 3 {
            let date = dates[0] + "-" + m + "-" + dates[2]
            if isPersonData { loadPersonData(date: date) }
            else { loadTeamData(date: date) }
        }
    
    }
    
    //MARK: - network
    func loadPersonData(date: String) {
        BXBNetworkTool.BXBRequest(router: .countPersonal(visitDate: date), success: { (resp) in
            
            if let d = Mapper<AnalyzeData>().map(JSONObject: resp.object){
                self.personData = d
                if self.isPersonData {
                    self.data = d
                    self.data.listPer.sort(by: { (obj_1, obj_2) -> Bool in
                        return obj_1.visitCount > obj_2.visitCount
                    })
                    if let maxCount = self.data.listPer.first?.visitCount {
                        self.changeCell.setData(datas: self.data.listPer, total: CGFloat(maxCount))
                    }
                    
                    self.tableView.reloadData()
                }
            }
            
        }) { (error) in
            
        }
    }
    
    func loadTeamData(date: String) {
        BXBNetworkTool.BXBRequest(router: .countTeam(visitDate: date), success: { (resp) in
            
            if let d = Mapper<AnalyzeData>().map(JSONObject: resp.object){
                self.teamData = d
                if self.isPersonData == false {
                    self.data = d
                    self.data.listPer.sort(by: { (obj_1, obj_2) -> Bool in
                        return obj_1.visitCount > obj_2.visitCount
                    })
                    if let maxCount = self.data.listPer.first?.visitCount {
                        self.changeCell.setData(datas: self.data.listPer, total: CGFloat(maxCount))
                    }
                    self.tableView.reloadData()
                }
            }
            
        }) { (error) in
            
        }
    }
   
}
