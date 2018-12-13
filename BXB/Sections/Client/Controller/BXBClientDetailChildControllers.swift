//
//  BXBClientDetailChildControllers.swift
//  BXB
//
//  Created by equalriver on 2018/8/28.
//  Copyright © 2018年 tobosoft. All rights reserved.
//

import Foundation
import Toast_Swift

//MARK: - 提醒事项
class ClientDetailNoticeVC: BXBBaseViewController {
    
    public var noticeArr = Array<ClientDetailNoticeData>() {
        willSet{
            if newValue.count == 0 {
                state = .normal
                editTranslationState = .normal
                tableView.reloadData()
            }
        }
    }
    
    public var clientId = 0
    
    var state = ClientDetailState.normal {
        willSet{
            if newValue == .normal {
                self.addButton.setTitle("添加提醒", for: .normal)
                self.editButton.setTitle("编辑", for: .normal)
            }
            else {
                self.addButton.setTitle("取消", for: .normal)
                self.editButton.setTitle("确认", for: .normal)
            }
        }
    }
    
    var editTranslationState = ClientDetailEditTranslationState.normal
    
    
    lazy var sepView: UIView = {
        let v = UIView()
        v.backgroundColor = kColor_separatorView
        return v
    }()
    lazy var tableView: UITableView = {
        let tb = UITableView.init(frame: .zero, style: .plain)
        tb.backgroundColor = UIColor.white
        tb.separatorStyle = .none
        tb.delegate = self
        tb.dataSource = self
        return tb
    }()
    lazy var bottomContentView: UIView = {
        let v = UIView()
        v.backgroundColor = UIColor.white
        return v
    }()
    lazy var addButton: UIButton = {
        let b = UIButton()
        b.titleLabel?.font = kFont_text_weight
        b.setTitle("添加提醒", for: .normal)
        b.setTitleColor(kColor_theme, for: .normal)
        b.addTarget(self, action: #selector(addNotice(sender:)), for: .touchUpInside)
        return b
    }()
    lazy var sepView_1: UIView = {
        let v = UIView()
        v.backgroundColor = kColor_separatorView
        return v
    }()
    lazy var sepView_2: UIView = {
        let v = UIView()
        v.backgroundColor = kColor_separatorView
        return v
    }()
    lazy var editButton: UIButton = {
        let b = UIButton()
        b.titleLabel?.font = kFont_text_weight
        b.setTitle("编辑", for: .normal)
        b.setTitleColor(kColor_theme, for: .normal)
        b.addTarget(self, action: #selector(editNotice(sender:)), for: .touchUpInside)
        return b
    }()
    lazy var dateFormatterYMD: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        initUI()
        if noticeArr.count == 0 {
            self.tableView.stateEmpty(title: "暂时没有提醒事项", img: #imageLiteral(resourceName: "client_null_提醒事项"), buttonTitle: nil, handle: nil)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        ToastManager.shared.position = .top
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let maskPath = UIBezierPath.init(roundedRect: bottomContentView.bounds, byRoundingCorners: [.bottomLeft, .bottomRight], cornerRadii: CGSize.init(width: 10, height: 10))
        let maskLayer = CAShapeLayer()
        
        maskLayer.strokeColor = UIColor.white.cgColor
        maskLayer.frame = bottomContentView.bounds
        maskLayer.path = maskPath.cgPath
        bottomContentView.layer.mask = maskLayer
    }
    
    //
    func initUI() {
        view.addSubview(sepView)
        view.addSubview(tableView)
        view.addSubview(bottomContentView)
        bottomContentView.addSubview(addButton)
        bottomContentView.addSubview(sepView_1)
        bottomContentView.addSubview(sepView_2)
        bottomContentView.addSubview(editButton)
        sepView.snp.makeConstraints { (make) in
            make.top.width.centerX.equalTo(view)
            make.height.equalTo(0.5)
        }
        tableView.snp.makeConstraints { (make) in
            make.width.centerX.equalTo(view)
            make.top.equalTo(sepView.snp.bottom)
            make.bottom.equalTo(view).offset(-60 * KScreenRatio_6)
        }
        bottomContentView.snp.makeConstraints { (make) in
            make.size.equalTo(CGSize.init(width: 345 * KScreenRatio_6, height: 60 * KScreenRatio_6))
            make.bottom.centerX.equalTo(view)
        }
        sepView_1.snp.makeConstraints { (make) in
            make.top.width.centerX.equalTo(bottomContentView)
            make.height.equalTo(0.5)
        }
        addButton.snp.makeConstraints { (make) in
            make.size.equalTo(CGSize.init(width: 170 * KScreenRatio_6, height: 60 * KScreenRatio_6 - 1))
            make.top.equalTo(sepView_1.snp.bottom)
            make.left.equalTo(bottomContentView)
        }
        sepView_2.snp.makeConstraints { (make) in
            make.size.equalTo(CGSize.init(width: 1, height: 30 * KScreenRatio_6))
            make.center.equalTo(bottomContentView)
        }
        editButton.snp.makeConstraints { (make) in
            make.size.centerY.equalTo(addButton)
            make.right.equalTo(bottomContentView)
        }
    }
    
}

//MARK: - 互动记录
class ClientDetailRecordVC: BXBBaseViewController {
    
    public var recordArr = Array<ClientDetailRecordData>()
    
    lazy var sepView: UIView = {
        let v = UIView()
        v.backgroundColor = kColor_separatorView
        return v
    }()
    lazy var tableView: UITableView = {
        let tb = UITableView.init(frame: .zero, style: .plain)
        tb.backgroundColor = UIColor.white
        tb.separatorStyle = .none
        tb.delegate = self
        tb.dataSource = self
        return tb
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        view.addSubview(sepView)
        view.addSubview(tableView)
        sepView.snp.makeConstraints { (make) in
            make.top.width.centerX.equalTo(view)
            make.height.equalTo(0.5)
        }
        tableView.snp.makeConstraints { (make) in
            make.width.centerX.bottom.equalTo(view)
            make.top.equalTo(sepView.snp.bottom)
        }
        if recordArr.count == 0 {
            tableView.stateEmpty(title: "暂时没有互动记录", img: #imageLiteral(resourceName: "client_null_互动记录"), buttonTitle: nil, handle: nil)
        }
    }
    
}

//MARK: - 花费记录
class ClientDetailCostVC: BXBBaseViewController {
    
    public var maintainArr = Array<ClientDetailMaintainData>() {
        willSet{
            if newValue.count == 0 {
                state = .normal
                editTranslationState = .normal
                tableView.reloadData()
            }
        }
    }
    
    public var clientId = 0
    public var clientName = ""
    ///维护总费用
    public var spendSum = 0
    
    var state = ClientDetailState.normal {
        willSet{
            if newValue == .normal {
                self.addButton.setTitle("添加花费", for: .normal)
                self.editButton.setTitle("编辑", for: .normal)
            }
            else {
                self.addButton.setTitle("取消", for: .normal)
                self.editButton.setTitle("确认", for: .normal)
            }
        }
    }
    
    var editTranslationState = ClientDetailEditTranslationState.normal
    
    
    lazy var sepView: UIView = {
        let v = UIView()
        v.backgroundColor = kColor_separatorView
        return v
    }()
    lazy var tableView: UITableView = {
        let tb = UITableView.init(frame: .zero, style: .grouped)
        tb.backgroundColor = UIColor.white
        tb.separatorStyle = .none
        tb.delegate = self
        tb.dataSource = self
        return tb
    }()
    lazy var bottomContentView: UIView = {
        let v = UIView()
        v.backgroundColor = UIColor.white
        return v
    }()
    lazy var addButton: UIButton = {
        let b = UIButton()
        b.titleLabel?.font = kFont_text_weight
        b.setTitle("添加花费", for: .normal)
        b.setTitleColor(kColor_theme, for: .normal)
        b.addTarget(self, action: #selector(addCost(sender:)), for: .touchUpInside)
        return b
    }()
    lazy var sepView_1: UIView = {
        let v = UIView()
        v.backgroundColor = kColor_separatorView
        return v
    }()
    lazy var sepView_2: UIView = {
        let v = UIView()
        v.backgroundColor = kColor_separatorView
        return v
    }()
    lazy var editButton: UIButton = {
        let b = UIButton()
        b.titleLabel?.font = kFont_text_weight
        b.setTitle("编辑", for: .normal)
        b.setTitleColor(kColor_theme, for: .normal)
        b.addTarget(self, action: #selector(editCost(sender:)), for: .touchUpInside)
        return b
    }()
    lazy var dateFormatterYMD: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        initUI()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        ToastManager.shared.position = .top
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if maintainArr.count == 0 {
            tableView.stateEmpty(title: "暂时没有花费记录", img: #imageLiteral(resourceName: "client_null_花费记录"), buttonTitle: nil, handle: nil)
        }
        let maskPath = UIBezierPath.init(roundedRect: bottomContentView.bounds, byRoundingCorners: [.bottomLeft, .bottomRight], cornerRadii: CGSize.init(width: 10, height: 10))
        let maskLayer = CAShapeLayer()
        
        maskLayer.strokeColor = UIColor.white.cgColor
        maskLayer.frame = bottomContentView.bounds
        maskLayer.path = maskPath.cgPath
        bottomContentView.layer.mask = maskLayer
        
    }
    
    //
    func initUI() {
        view.addSubview(sepView)
        view.addSubview(tableView)
        view.addSubview(bottomContentView)
        bottomContentView.addSubview(addButton)
        bottomContentView.addSubview(sepView_1)
        bottomContentView.addSubview(sepView_2)
        bottomContentView.addSubview(editButton)
        sepView.snp.makeConstraints { (make) in
            make.top.width.centerX.equalTo(view)
            make.height.equalTo(0.5)
        }
        tableView.snp.makeConstraints { (make) in
            make.width.centerX.equalTo(view)
            make.top.equalTo(sepView.snp.bottom)
            make.bottom.equalTo(view).offset(-60 * KScreenRatio_6)
        }
        bottomContentView.snp.makeConstraints { (make) in
            make.size.equalTo(CGSize.init(width: 345 * KScreenRatio_6, height: 60 * KScreenRatio_6))
            make.bottom.centerX.equalTo(view)
        }
        sepView_1.snp.makeConstraints { (make) in
            make.top.width.centerX.equalTo(bottomContentView)
            make.height.equalTo(0.5)
        }
        addButton.snp.makeConstraints { (make) in
            make.size.equalTo(CGSize.init(width: 170 * KScreenRatio_6, height: 60 * KScreenRatio_6 - 1))
            make.top.equalTo(sepView_1.snp.bottom)
            make.left.equalTo(bottomContentView)
        }
        sepView_2.snp.makeConstraints { (make) in
            make.size.equalTo(CGSize.init(width: 1, height: 30 * KScreenRatio_6))
            make.center.equalTo(bottomContentView)
        }
        editButton.snp.makeConstraints { (make) in
            make.size.centerY.equalTo(addButton)
            make.right.equalTo(bottomContentView)
        }
    }
    
}
