//
//  BXBWorkViewController.swift
//  BXB
//
//  Created by equalriver on 2018/9/26.
//  Copyright © 2018年 tobosoft. All rights reserved.
//

import UIKit

class BXBWorkViewController: BXBBaseViewController {

    var agendaArr = Array<AgendaData>()
    
    var noticeArr = Array<NoticeDetailData>()
    
    //日工作简报
    var day_report = BXBWorkData()
    
    //月工作简报
    var month_report = BXBWorkData()
    
    var isDayReport = true
    
    //所有日程数
    var agendaAllCount = 0
    
    ///正在进行提醒跟进
    var isNoticeFollow = false
    
    
    var isShowAgendaMore = false {
        didSet{
            agendaTableView.reloadData()
            let h = agendaArr.count + 1 > 2 && isShowAgendaMore ? CGFloat(agendaArr.count - 1) * 50 * KScreenRatio_6 + 160 * KScreenRatio_6 : 160 * KScreenRatio_6
            
            self.agendaTableView.snp.updateConstraints { (make) in
                make.size.equalTo(CGSize.init(width: 345 * KScreenRatio_6, height: h))
            }
            let h1 = (160 + 4 * 15) * KScreenRatio_6 + h + noticeTableView.height
            contentSV.contentSize = CGSize.init(width: 0, height: h1)
        }
    }
    
    var isShowNoticeMore = false {
        didSet{
            noticeTableView.reloadData()
            let h = noticeArr.count > 2 && isShowNoticeMore ? CGFloat(noticeArr.count - 2) * 50 * KScreenRatio_6 + 160 * KScreenRatio_6 : 160 * KScreenRatio_6
            noticeTableView.snp.updateConstraints { (make) in
                make.size.equalTo(CGSize.init(width: 345 * KScreenRatio_6, height: h))
            }
            let h1 = (160 + 4 * 15) * KScreenRatio_6 + h + agendaTableView.height
            contentSV.contentSize = CGSize.init(width: 0, height: h1)
        }
    }
    
    
    lazy var naviBar: BXBWorkTabVCNaviBar = {
        let v = BXBWorkTabVCNaviBar.init(frame: CGRect.init(x: 0, y: 0, width: kScreenWidth, height: kNavigationBarAndStatusHeight))
        v.backgroundColor = UIColor.white
        return v
    }()
    lazy var topButtonsCV: UICollectionView = {
        let l = UICollectionViewFlowLayout()
        l.itemSize = CGSize.init(width: (335 / 4) * KScreenRatio_6, height: 70 * KScreenRatio_6)
        l.sectionInset = .init(top: 10 * KScreenRatio_6, left: 0, bottom: 10 * KScreenRatio_6, right: 0)
        let cv = UICollectionView.init(frame: .zero, collectionViewLayout: l)
        cv.backgroundColor = UIColor.white
        cv.isScrollEnabled = false
        cv.delegate = self
        cv.dataSource = self
        cv.register(BXBWorkTopButtonsCell.self, forCellWithReuseIdentifier: "BXBWorkTopButtonsCell")
        return cv
    }()
    lazy var contentSV: UIScrollView = {
        let s = UIScrollView.init()
        s.backgroundColor = kColor_background
        s.showsHorizontalScrollIndicator = false
        s.contentSize = CGSize.init(width: 0, height: (160 * 3 + 15 * 4) * KScreenRatio_6)
        return s
    }()
    lazy var agendaTableView: UITableView = {
        let tb = UITableView.init(frame: .zero, style: UITableView.Style.grouped)
        tb.backgroundColor = UIColor.white
        tb.showsVerticalScrollIndicator = false
        tb.isScrollEnabled = false
        tb.separatorStyle = .none
        tb.dataSource = self
        tb.delegate = self
        tb.setLayerShadow(kColor_text, offset: CGSize.zero, radius: 5)
        tb.layer.cornerRadius = kCornerRadius
        tb.layer.masksToBounds = true
        return tb
    }()
    lazy var noticeTableView: UITableView = {
        let tb = UITableView.init(frame: .zero, style: UITableView.Style.grouped)
        tb.backgroundColor = UIColor.white
        tb.showsVerticalScrollIndicator = false
        tb.isScrollEnabled = false
        tb.separatorStyle = .none
        tb.dataSource = self
        tb.delegate = self
        tb.setLayerShadow(kColor_text, offset: CGSize.zero, radius: 5)
        tb.layer.cornerRadius = kCornerRadius
        tb.layer.masksToBounds = true
        return tb
    }()
    lazy var reportView: BXBWorkReportView = {
        let v = BXBWorkReportView.init(frame: CGRect.zero)
        v.backgroundColor = UIColor.white
        v.setLayerShadow(kColor_text, offset: CGSize.zero, radius: 5)
        v.layer.cornerRadius = kCornerRadius
        v.layer.masksToBounds = true
        v.delegate = self
        return v
    }()
    lazy var agendaMoreBtn: UIButton = {
        let b = UIButton()
        b.titleLabel?.font = kFont_text_2
        b.setTitle("展开", for: .normal)
        b.setTitle("收起", for: .selected)
        b.setTitleColor(kColor_text, for: .normal)
        b.addTarget(self, action: #selector(showAgendaMore(sender:)), for: .touchUpInside)
        return b
    }()
    lazy var noticeMoreBtn: UIButton = {
        let b = UIButton()
        b.titleLabel?.font = kFont_text_2
        b.setTitle("展开", for: .normal)
        b.setTitle("收起", for: .selected)
        b.setTitleColor(kColor_text, for: .normal)
        b.addTarget(self, action: #selector(showNoticeMore(sender:)), for: .touchUpInside)
        return b
    }()
    lazy var dateFormatterYMD: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
    lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        return formatter
    }()
    lazy var bezierPath: UIBezierPath = {
        let b = UIBezierPath.init()
        return b
    }()
    lazy var followAnimationLayer: CALayer = {
        let l = CALayer.init()
        l.frame = CGRect.init(x: 0, y: 0, width: 30 * KScreenRatio_6, height: 30 * KScreenRatio_6)
        l.contents = UIImage.init(named: "work_智能提醒")?.cgImage
        return l
    }()
    
    //
    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
        setRefresh()
        getDate()
        loadData()
        dayNotice()
        //日程
        NotificationCenter.default.addObserver(self, selector: #selector(notiAgendaShouldRefreshData), name: .kNotiAgendaShouldRefreshData, object: nil)
        //提醒
        NotificationCenter.default.addObserver(self, selector: #selector(notiRemindShouldRefreshData), name: .kNotiRemindShouldRefreshData, object: nil)
        //提醒已跟进
        NotificationCenter.default.addObserver(self, selector: #selector(notiWorkDidFinishNotice(sender:)), name: .kNotiWorkDidFinishNotice, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        dayReport()
        monthReport()
        let sa = isShowAgendaMore
        isShowAgendaMore = sa
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if contentSV.contentSize.height < (160 * 3 + 15 * 4) * KScreenRatio_6 {
            contentSV.contentSize = CGSize.init(width: 0, height: (160 * 3 + 15 * 4) * KScreenRatio_6)
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    //MARK: -
    func initUI() {
        view.backgroundColor = kColor_background
        view.addSubview(naviBar)
        view.addSubview(topButtonsCV)
        view.addSubview(contentSV)
        contentSV.addSubview(agendaTableView)
        contentSV.addSubview(noticeTableView)
        contentSV.addSubview(reportView)
        topButtonsCV.snp.makeConstraints { (make) in
            make.size.equalTo(CGSize.init(width: kScreenWidth, height: 90 * KScreenRatio_6))
            make.top.equalTo(naviBar.snp.bottom)
            make.centerX.equalToSuperview()
        }
        contentSV.snp.makeConstraints { (make) in
            make.top.equalTo(topButtonsCV.snp.bottom).offset(15 * KScreenRatio_6)
            make.width.bottom.centerX.equalToSuperview()
        }
        agendaTableView.snp.makeConstraints { (make) in
            make.size.equalTo(CGSize.init(width: 345 * KScreenRatio_6, height: 160 * KScreenRatio_6))
            make.centerX.equalToSuperview()
            make.top.equalToSuperview()
        }
        noticeTableView.snp.makeConstraints { (make) in
            make.size.equalTo(CGSize.init(width: 345 * KScreenRatio_6, height: 160 * KScreenRatio_6))
            make.centerX.equalToSuperview()
            make.top.equalTo(agendaTableView.snp.bottom).offset(15 * KScreenRatio_6)
        }
        reportView.snp.makeConstraints { (make) in
            make.size.equalTo(CGSize.init(width: 345 * KScreenRatio_6, height: 160 * KScreenRatio_6))
            make.centerX.equalToSuperview()
            make.top.equalTo(noticeTableView.snp.bottom).offset(15 * KScreenRatio_6)
        }
    }
    
    func getDate() {
        let ca = Calendar.init(identifier: Calendar.Identifier.gregorian)
        let comps = ca.dateComponents([Calendar.Component.weekday, Calendar.Component.day, Calendar.Component.month], from: Date())
        
        guard comps.weekday != nil && comps.month != nil && comps.day != nil else { return }
        var weekday = ""
        switch comps.weekday! {
        case 1:
            weekday = "日"
            
        case 2:
            weekday = "一"
            
        case 3:
            weekday = "二"
            
        case 4:
            weekday = "三"
            
        case 5:
            weekday = "四"
            
        case 6:
            weekday = "五"
            
        default:
            weekday = "六"
        }
        
        naviBar.detailText = "周" + weekday + " \(comps.month!)月\(comps.day!)日"
    }


}
