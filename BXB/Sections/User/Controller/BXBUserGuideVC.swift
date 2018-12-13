//
//  BXBUserGuideVC.swift
//  BXB
//
//  Created by equalriver on 2018/10/31.
//  Copyright © 2018年 tobosoft. All rights reserved.
//

import UIKit

class BXBUserGuideVC: BXBBaseNavigationVC {

    lazy var tableView: UITableView = {
        let tb = UITableView.init(frame: .zero, style: .grouped)
        tb.backgroundColor = UIColor.white
        tb.separatorStyle = .none
        tb.dataSource = self
        tb.delegate = self
        return tb
    }()
    
    private var titles = ["客户管理", "生日提醒", "花费记录", "附近的客户", "跟进状态", "日程安排", "智能提醒", "销售线索", "纪念日备忘", "个人统计", "团队管理"]
    private var imgs = [UIImage.init(named: "meGuide_客户管理"), UIImage.init(named: "meGuide_生日提醒"), UIImage.init(named: "meGuide_花费记录"), UIImage.init(named: "meGuide_附近的客户"), UIImage.init(named: "meGuide_跟进状态"), UIImage.init(named: "meGuide_日程安排"), UIImage.init(named: "meGuide_智能提醒"), UIImage.init(named: "meGuide_销售线索"), UIImage.init(named: "meGuide_纪念日备忘"), UIImage.init(named: "meGuide_个人统计"), UIImage.init(named: "meGuide_团队管理")]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "新手教程"
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.top.equalTo(naviBar.snp.bottom)
            make.width.bottom.centerX.equalToSuperview()
        }
    }
    
}


extension BXBUserGuideVC: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titles.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55 * KScreenRatio_6
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 || indexPath.row == 5 || indexPath.row == 6 || indexPath.row == 9 || indexPath.row == 10 {
            let cell = BXBUserGuideCell.init(style: .default, reuseIdentifier: nil)
            cell.iconIV.image = imgs[indexPath.row]
            cell.titleLabel.text = titles[indexPath.row]
            return cell
        }
        else {
            let cell = BXBUserGuideSubCell.init(style: .default, reuseIdentifier: nil)
            cell.iconIV.image = imgs[indexPath.row]
            cell.titleLabel.text = titles[indexPath.row]
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = BXBUserGuideDetailVC()
        
        navigationController?.pushViewController(vc, animated: true)
    }
    
}
