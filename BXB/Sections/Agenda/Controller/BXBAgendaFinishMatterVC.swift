//
//  BXBAgendaFinishMatterVC.swift
//  BXB
//
//  Created by equalriver on 2018/8/22.
//  Copyright © 2018年 tobosoft. All rights reserved.
//

import UIKit

class BXBAgendaFinishMatterVC: BXBBaseNavigationVC {

    public var data = AgendaData()
    
    public var dataArr: Array<String> = [] {
        didSet{
            tableView.snp.makeConstraints { (make) in
                make.size.equalTo(CGSize.init(width: 345 * KScreenRatio_6, height: CGFloat(dataArr.count) * 55 * KScreenRatio_6))
                make.top.equalTo(subTitleLabel.snp.bottom).offset(40 * KScreenRatio_6)
                make.centerX.equalTo(view)
            }
            tableView.reloadData()
        }
    }
    
    public var selectedItemsSet = Set<String>.init()
    
    lazy var titleLabel: UILabel = {
        let l = UILabel()
        l.font = kFont_btn_weight
        l.textColor = kColor_text
        l.text = "本次活动完成了哪些事项?"
        return l
    }()
    lazy var subTitleLabel: UILabel = {
        let l = UILabel()
        l.font = kFont_text_3
        l.textColor = kColor_theme
        l.text = "(可多选)"
        return l
    }()
    lazy var tableView: UITableView = {
        let tb = UITableView.init(frame: .zero, style: .plain)
        tb.backgroundColor = UIColor.white
        tb.separatorStyle = .none
        tb.dataSource = self
        tb.delegate = self
        tb.isScrollEnabled = false
        tb.allowsMultipleSelection = true
        tb.layer.cornerRadius = kCornerRadius
        tb.layer.masksToBounds = true
        return tb
    }()
    lazy var addNextBtn: UIButton = {
        let b = UIButton()
        b.titleLabel?.font = kFont_text_3
        b.setTitleColor(kColor_text, for: .normal)
        b.setImage(#imageLiteral(resourceName: "bxb_勾选框"), for: .normal)
        b.setImage(#imageLiteral(resourceName: "client_勾"), for: .selected)
        b.setTitle(" 添加后续日程", for: .normal)
        b.addTarget(self, action: #selector(addNextAction(sender:)), for: .touchUpInside)
        return b
    }()
    lazy var confirmBtn: ImageTopButton = {
        let b = ImageTopButton()
        b.titleLabel?.font = kFont_text_3
        b.setTitle("下一步", for: .normal)
        b.setTitleColor(kColor_text, for: .normal)
        b.setImage(#imageLiteral(resourceName: "bxb_btn下一步"), for: .normal)
        b.addTarget(self, action: #selector(confirmAction(sender:)), for: .touchUpInside)
        return b
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initUI()
    }

    func initUI() {
        naviBar.naviBackgroundColor = kColor_background!
        view.backgroundColor = kColor_background
        view.addSubview(titleLabel)
        view.addSubview(subTitleLabel)
        view.addSubview(tableView)
        view.addSubview(addNextBtn)
        view.addSubview(confirmBtn)
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(view).offset(20 * KScreenRatio_6)
            make.top.equalTo(naviBar.snp.bottom).offset(20 * KScreenRatio_6)
            make.right.equalTo(view)
            make.height.equalTo(25 * KScreenRatio_6)
        }
        subTitleLabel.snp.makeConstraints { (make) in
            make.left.width.equalTo(titleLabel)
            make.top.equalTo(titleLabel.snp.bottom).offset(5)
            make.height.equalTo(20 * KScreenRatio_6)
        }
//        tableView.snp.remakeConstraints { (make) in
//            make.size.equalTo(CGSize.init(width: 345 * KScreenRatio_6, height: 280 * KScreenRatio_6))
//            make.top.equalTo(subTitleLabel.snp.bottom).offset(40 * KScreenRatio_6)
//            make.centerX.equalTo(view)
//        }
        addNextBtn.snp.makeConstraints { (make) in
            make.size.equalTo(CGSize.init(width: 150 * KScreenRatio_6, height: 30 * KScreenRatio_6))
            make.centerX.equalTo(view)
            make.bottom.equalTo(view).offset(-130 * KScreenRatio_6 - kIphoneXBottomInsetHeight)
        }
        confirmBtn.snp.makeConstraints { (make) in
            make.size.equalTo(CGSize.init(width: 100 * KScreenRatio_6, height: 100 * KScreenRatio_6))
            make.centerX.equalTo(view)
            make.top.equalTo(addNextBtn.snp.bottom).offset(15 * KScreenRatio_6)
        }
    }
    
    //MARK: - action
    @objc func addNextAction(sender: UIButton) {
        sender.isSelected = !sender.isSelected
    }
    
    @objc func confirmAction(sender: UIButton) {
        
        guard selectedItemsSet.count > 0 else {
            view.makeToast("未选择事项")
            return
        }
        var events = ""
        for item in selectedItemsSet {
            events += "\(item),"
        }
        events.removeLast(1)
        data.matter = events

        presentAction()
        
    }
    
    func presentAction() {
        UserDefaults.standard.set(self.addNextBtn.isSelected, forKey: kAgendaAddNextPlain)
        
        if self.selectedItemsSet.contains("转介名单") && self.selectedItemsSet.contains("签单") == false {
            let vc = BXBAddNewClientVC()
            vc.agendaData = self.data
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else if self.selectedItemsSet.contains("签单") && self.selectedItemsSet.contains("转介名单") == false {
            let vc = BXBAgendaDetailSigningVC()
            vc.data = self.data
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else if self.selectedItemsSet.contains("签单") && self.selectedItemsSet.contains("转介名单"){
            let vc = BXBAgendaDetailSigningVC()
            vc.data = self.data
            vc.isNeedGoAddPage = true
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else{
            let vc = BXBAgendaDetailEditVC()
            vc.titleText = "说点什么吧..."
            vc.data = self.data
            vc.isNeedPopToRootVC = true
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }

}


extension BXBAgendaFinishMatterVC: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArr.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55 * KScreenRatio_6
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = AgendaFinishMatterCell.init(style: .default, reuseIdentifier: nil)
        cell.matterLabel.text = dataArr[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        let item = dataArr[indexPath.row]
        selectedItemsSet.insert(item)
        
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
       
        let item = dataArr[indexPath.row]
        if selectedItemsSet.contains(item) {
            selectedItemsSet.remove(item)
        }
    }
    
}

class AgendaFinishMatterCell: BXBBaseTableViewCell {
    
    lazy var matterLabel: UILabel = {
        let l = UILabel()
        l.font = kFont_text_weight
        l.textColor = kColor_dark
        return l
    }()
    lazy var stateBtn: UIButton = {
        let b = UIButton()
        b.setImage(#imageLiteral(resourceName: "matter_未选中"), for: .normal)
        b.setImage(#imageLiteral(resourceName: "bxb_勾选"), for: .selected)
        return b
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(matterLabel)
        contentView.addSubview(stateBtn)
        matterLabel.snp.makeConstraints { (make) in
            make.height.centerY.right.equalTo(contentView)
            make.left.equalTo(contentView).offset(15 * KScreenRatio_6)
        }
        stateBtn.snp.makeConstraints { (make) in
            make.size.equalTo(CGSize.init(width: 20 * KScreenRatio_6, height: 20 * KScreenRatio_6))
            make.centerY.equalTo(contentView)
            make.right.equalTo(contentView).offset(-15 * KScreenRatio_6)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        stateBtn.isSelected = selected
        matterLabel.textColor = selected == true ? UIColor.white : kColor_dark
        contentView.backgroundColor = selected == true ? kColor_theme : UIColor.white
    }
    
}














