//
//  BXBClientListVC.swift
//  BXB
//
//  Created by equalriver on 2018/8/6.
//  Copyright © 2018年 tobosoft. All rights reserved.
//

import UIKit

class BXBClientListVC: BXBBaseViewController {

    var clientData = Array<ClientData>()
    
    var clientNameData = Array<String>()
    
    var dataArr = Array<ClientData>()
    
    var sectionIndexArr = NSMutableArray.init(capacity: 10)
    
    var clientNamesArr = Array<Array<String>>()
    
    var dataAllArr = Array<ClientData>()
    
    var style: ClientItemStyle!
    
    var cellStyle = ClientListType.normal
    
    var page = 1
    
    var remind = ""
    
    var isWrite = ""
    
    var matter = ""
    
    
    lazy var tableView: UITableView = {
        let t = UITableView.init(frame: .zero, style: .plain)
        t.backgroundColor = kColor_background
        t.dataSource = self
        t.delegate = self
        t.separatorStyle = .none
        t.sectionIndexColor = kColor_subText
        return t
    }()
    
    lazy var filterView: BXBClientFilterButtons = {
        let v = BXBClientFilterButtons.init(frame: .zero)
        v.backgroundColor = UIColor.white
        v.delegate = self
        return v
    }()
    
    lazy var footerView: UILabel = {
        let l = UILabel.init(frame: CGRect.init(x: 0, y: 0, width: kScreenWidth, height: 50 * KScreenRatio_6))
        l.font = kFont_text_2_weight
        l.textColor = kColor_text
        l.textAlignment = .center
        return l
    }()
    //navi button
    lazy var nearButton: UIButton = {
        let b = UIButton()
        b.setTitle("附近", for: .normal)
        b.setTitleColor(kColor_text, for: .normal)
        b.titleLabel?.font = UIFont.systemFont(ofSize: 19 * KScreenRatio_6)
        return b
    }()
    lazy var naviBar: BXBClientTabVCNaviBar = {
        let v = BXBClientTabVCNaviBar.init(frame: CGRect.init(x: 0, y: 0, width: kScreenWidth, height: kNavigationBarAndStatusHeight))
        v.backgroundColor = UIColor.white
        v.delegate = self
        return v
    }()
    lazy var search: PYSearchViewController = {
        let vc = PYSearchViewController.init(hotSearches: nil, searchBarPlaceholder: "搜索")
        vc!.delegate = self
        vc!.dataSource = self
        vc?.showSearchHistory = false
        vc?.searchBar.setImage(UIImage.init(named: "bxb_搜索"), for: UISearchBar.Icon.search, state: UIControl.State.normal)
        vc?.searchTextField.attributedPlaceholder = NSAttributedString.init(string: "搜索", attributes: [.font: kFont_text_2_weight, .foregroundColor: kColor_subText!])
        vc?.searchBarCornerRadius = kCornerRadius
        return vc!
    }()
    lazy var searchVC: BXBSearchNavi = {
        let navi = BXBSearchNavi.init(rootViewController: search)
        return navi
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(shouldRefreshData(sender:)), name: .kNotiClientShouldRefreshData, object: nil)

        initUI()
        
        setRefresh()
        
        makeUserGuideForClient()
        
        loadData(remind: "", isWrite: "", matter: "")
        
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let token = UserDefaults.standard.value(forKey: "token")
        if token == nil {
            self.tableView.stateEmpty(title: "暂时没有添加客户", img: #imageLiteral(resourceName: "client_空白页"), buttonTitle: "新建客户", handle: {[weak self] in
                self?.addNewClient()
            })
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if filterView.filterView.superview != nil {
            filterView.filterView.resetState()
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func initUI() {
        view.addSubview(naviBar)
        view.addSubview(tableView)
        view.addSubview(filterView)
        filterView.snp.makeConstraints { (make) in
            make.width.centerX.equalTo(view)
            make.height.equalTo(44 * KScreenRatio_6)
            make.top.equalTo(naviBar.snp.bottom)
        }
        tableView.snp.makeConstraints { (make) in
            make.centerX.width.bottom.equalTo(view)
            make.top.equalTo(filterView.snp.bottom)
        }
        
    }

}

















