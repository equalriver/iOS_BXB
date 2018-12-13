//
//  BXBUserTeamActivityVC.swift
//  BXB
//
//  Created by equalriver on 2018/8/31.
//  Copyright © 2018年 tobosoft. All rights reserved.
//

import UIKit

class BXBUserTeamActivityVC: BXBBaseNavigationVC {
    
    
    public var userId = 0
    
    public var teamName = "" {
        willSet{
            title = newValue
        }
    }
    
    let titlesArr = ["接洽", "面谈", "建议书", "增员", "签单", "客户服务", "保单服务"]
    
    var currentDate = Date()
    
    var totalData = TeamActivityTotalData()
    
    var listArr = Array<TeamActivityMemberData>()
    
    lazy var blankView: UIView = {
        let v = UIView()
        v.backgroundColor = kColor_background
        v.layer.borderColor = kColor_separatorView?.cgColor
        v.layer.borderWidth = 0.5
        return v
    }()
    lazy var contentScroll: UIScrollView = {
        let s = UIScrollView()
        s.backgroundColor = UIColor.white
        s.showsVerticalScrollIndicator = false
        s.delegate = self
        s.bounces = false
        s.contentSize = CGSize.init(width: 630, height: kScreenHeight - kNavigationBarAndStatusHeight - kIphoneXBottomInsetHeight - 45 * KScreenRatio_6)
        
        return s
    }()
    lazy var namesTableView: UITableView = {
        let tb = UITableView.init(frame: .zero, style: .plain)
        tb.backgroundColor = kColor_background
        tb.showsVerticalScrollIndicator = false
        tb.dataSource = self
        tb.delegate = self
        tb.bounces = false
        tb.separatorStyle = .none

        return tb
    }()
    lazy var titlesView: UIView = {
        let v = UIView()
        v.backgroundColor = kColor_background
        
        for i in 0..<7 {
            let l = UILabel.init(frame: CGRect.init(x: CGFloat(i) * 90, y: 0, width: 90, height: 45 * KScreenRatio_6))
            l.backgroundColor = kColor_background
            l.font = kFont_text
            l.textColor = kColor_text
            l.textAlignment = .center
            l.text = titlesArr[i]
            if i != 0 {//垂直分割线
                let sep = UIView.init(frame: CGRect.init(x: -0.5, y: 0, width: 0.5, height: 45 * KScreenRatio_6))
                sep.backgroundColor = kColor_separatorView
                l.addSubview(sep)
            }

            v.addSubview(l)
        }
        //上下分割线
        let s1 = UIView.init(frame: CGRect.init(x: -0.5, y: 0, width: 630, height: 0.5))
        s1.backgroundColor = kColor_separatorView
        v.addSubview(s1)
        let s2 = UIView.init(frame: CGRect.init(x: 0, y: 45 * KScreenRatio_6 - 0.5, width: 630, height: 0.5))
        s2.backgroundColor = kColor_separatorView
        v.addSubview(s2)
        
        return v
    }()
    lazy var detailCollectionView: UICollectionView = {
        let l = UICollectionViewFlowLayout()
//        l.itemSize = CGSize.init(width: 90, height: 45 * KScreenRatio_6)
        l.sectionInset = UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: 0)
        l.minimumLineSpacing = 0
        l.minimumInteritemSpacing = 0
        l.scrollDirection = .vertical
        let cv = UICollectionView.init(frame: .zero, collectionViewLayout: l)
        cv.backgroundColor = UIColor.white
        cv.dataSource = self
        cv.delegate = self
        cv.bounces = false
        cv.register(UserTeamActivityDetailCell.self, forCellWithReuseIdentifier: "UserTeamActivityDetailCell")
        return cv
    }()
    lazy var leftButton: UIButton = {
        let b = UIButton()
        b.backgroundColor = kColor_background
        b.setImage(#imageLiteral(resourceName: "team_左箭头"), for: .normal)
        b.addTarget(self, action: #selector(leftDayAction), for: .touchUpInside)
        return b
    }()
    lazy var rightButton: UIButton = {
        let b = UIButton()
        b.backgroundColor = kColor_background
        b.setImage(#imageLiteral(resourceName: "team_右箭头"), for: .normal)
        b.addTarget(self, action: #selector(rightDayAction), for: .touchUpInside)
        return b
    }()
    lazy var dayLabel: UILabel = {
        let l = UILabel()
        l.backgroundColor = kColor_background
        l.font = kFont_text
        l.textColor = kColor_text
        l.textAlignment = .center
        l.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(dayDatePick))
        l.addGestureRecognizer(tap)
        return l
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
    lazy var sepView_3: UIView = {
        let v = UIView()
        v.backgroundColor = kColor_separatorView
        return v
    }()
    lazy var sepView_4: UIView = {
        let v = UIView()
        v.backgroundColor = kColor_separatorView
        return v
    }()
    lazy var dateFormatter: DateFormatter = {
        let f = DateFormatter()
        f.dateFormat = "yyyy-MM-dd"
        return f
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
        loadData(date: dateFormatter.string(from: Date()))
        dayLabel.text = dateFormatter.string(from: Date())
        
        makeUserGuideForTeamActivity()
    }

    func initUI() {
        view.backgroundColor = kColor_background
        view.addSubview(blankView)
        view.addSubview(contentScroll)
        view.addSubview(namesTableView)
        contentScroll.addSubview(titlesView)
        contentScroll.addSubview(detailCollectionView)
        view.addSubview(leftButton)
        view.addSubview(rightButton)
        view.addSubview(dayLabel)
        view.addSubview(sepView_1)
        view.addSubview(sepView_2)
        view.addSubview(sepView_3)
        view.addSubview(sepView_4)
        
        blankView.snp.makeConstraints { (make) in
            make.size.equalTo(CGSize.init(width: 95, height: 45 * KScreenRatio_6))
            make.left.equalTo(view)
            make.top.equalTo(naviBar.snp.bottom)
        }
        leftButton.snp.makeConstraints { (make) in
            make.size.equalTo(CGSize.init(width: 70 * KScreenRatio_6, height: 45 * KScreenRatio_6 + kIphoneXBottomInsetHeight))
            make.left.bottom.equalTo(view)
        }
        sepView_1.snp.makeConstraints { (make) in
            make.width.left.equalTo(view)
            make.height.equalTo(0.5)
            make.bottom.equalTo(leftButton.snp.top)
        }
        sepView_2.snp.makeConstraints { (make) in
            make.width.equalTo(0.5)
            make.left.equalTo(leftButton.snp.right)
            make.centerY.height.equalTo(leftButton)
        }
        rightButton.snp.makeConstraints { (make) in
            make.right.equalTo(view)
            make.size.centerY.equalTo(leftButton)
        }
        sepView_3.snp.makeConstraints { (make) in
            make.width.centerY.height.equalTo(sepView_2)
            make.right.equalTo(rightButton.snp.left)
        }
        dayLabel.snp.makeConstraints { (make) in
            make.left.equalTo(leftButton.snp.right).offset(0.5)
            make.height.centerY.equalTo(leftButton)
            make.right.equalTo(rightButton.snp.left).offset(-0.5)
        }
        namesTableView.snp.makeConstraints { (make) in
            make.width.equalTo(95)
            make.top.equalTo(blankView.snp.bottom)
            make.left.equalTo(view)
            make.bottom.equalTo(sepView_1.snp.top)
        }
        contentScroll.snp.makeConstraints { (make) in
            make.top.equalTo(naviBar.snp.bottom)
            make.left.equalTo(namesTableView.snp.right)
            make.right.equalTo(view)
            make.bottom.equalTo(namesTableView)
        }
        titlesView.snp.makeConstraints { (make) in
            make.height.equalTo(45 * KScreenRatio_6)
            make.left.equalTo(contentScroll)
            make.top.equalTo(contentScroll)
            make.width.equalTo(630)
        }
        detailCollectionView.snp.makeConstraints { (make) in
            make.left.equalTo(contentScroll)
            make.top.equalTo(titlesView.snp.bottom)
            make.height.equalTo(namesTableView)
            make.width.equalTo(630)
        }
        sepView_4.snp.makeConstraints { (make) in
            make.width.equalTo(0.5)
            make.top.right.height.equalTo(namesTableView)
        }
    }
    
}















