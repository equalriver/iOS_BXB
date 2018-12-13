//
//  BXBAgendaVC.swift
//  BXB
//
//  Created by 尹平江 on 2018/6/5.
//  Copyright © 2018年 tobosoft. All rights reserved.
//

import UIKit
import EventKit
import Alamofire
import SwiftyJSON
import ObjectMapper

enum BXBAgendaVCTableActionStyle {
    case none
    case delete
    
}

class BXBAgendaVC: BXBBaseViewController {
    
    var dataArr = Array<AgendaData>(){
        willSet{
//            agendaStatusDic.removeAll()
            for item in newValue {
                agendaStatusDic[item.time] = item.name
            }
        }
    }
    var remindArr = Array<AgendaRemindData>()
    
    var displayTime: TimeInterval = 0.5
    
    var displayCells = Set<IndexPath>()
    
    
    ///日程行高
    var rowHeightDic = Dictionary<IndexPath, CGFloat>()
    
    ///notice cell height
    let noticeCellHeight = 60 * KScreenRatio_6 + AgendaCellHeightType.singleRow.rawValue * KScreenRatio_6
    
    ///事项状态
    var agendaStatusDic = [String : String]()
    
    ///当前选中日期
    var currentDate = Date() {
        willSet{
            getDate(date: newValue)
            loadData(date: newValue)
        }
    }
    
    ///是否点击回到今天
    var isDidClickBackToToday = false
    
    ///刚刚完成的日程id
    var lastFinishedAgendaId = 0
    
    ///table view aciton
    var tableViewAction = BXBAgendaVCTableActionStyle.none
    
    ///EKEventStore
    static let store = EKEventStore.init()
    
    ///农历
    let chineseCalendar = NSCalendar.init(calendarIdentifier: .chinese)
    
    let lunarChars = ["初一","初二","初三","初四","初五","初六","初七","初八","初九","初十","十一","十二","十三","十四","十五","十六","十七","十八","十九","二十","廿一","廿二","廿三","廿四","廿五","廿六","廿七","廿八","廿九","三十"]
    
    var events: NSArray = []
    
    lazy var calendar: FSCalendar = {
        let c = FSCalendar.init(frame: CGRect.init(x: 0, y: CGFloat(kNavigationBarAndStatusHeight), width: kScreenWidth, height: 300))//固定初始化300
        c.dataSource = self
        c.delegate = self
        c.scope = .week
        c.headerHeight = 0
        c.fs_height = c.fs_width
        c.backgroundColor = UIColor.white
        
        //week
        c.weekdayHeight = 20 * KScreenRatio_6
        c.appearance.weekdayTextColor = kColor_dark
        c.appearance.titleWeekendColor = kColor_dark
        c.appearance.weekdayFont = UIFont.systemFont(ofSize: 11 * KScreenRatio_6)
        c.appearance.caseOptions = .weekdayUsesSingleUpperCase
        //圆点
        c.appearance.eventDefaultColor = kColor_highBackground
        c.appearance.eventSelectionColor = kColor_theme
        c.appearance.eventOffset = CGPoint.init(x: 0, y: 3)
        
        c.appearance.selectionColor = kColor_theme
        c.appearance.todayColor = UIColor.white
        c.appearance.titleTodayColor = kColor_theme
        c.appearance.subtitleTodayColor = kColor_theme
        
        c.appearance.titleDefaultColor = kColor_dark
        c.appearance.titleSelectionColor = .white
        c.appearance.titleFont = kFont_tabVC
        
        c.appearance.subtitleDefaultColor = kColor_subText
        c.appearance.subtitleSelectionColor = .white
        c.appearance.subtitleFont = UIFont.systemFont(ofSize: 11 * KScreenRatio_6)
        return c
    }()
    lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM月yyyy年"
        return formatter
    }()
    lazy var dateFormatterDay: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM月dd日"
        return formatter
    }()
    lazy var dateFormatterYMD: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
    lazy var naviBar: BXBAgendaTabVCNaviBar = {
        let v = BXBAgendaTabVCNaviBar.init(frame: CGRect.init(x: 0, y: 0, width: kScreenWidth, height: kNavigationBarAndStatusHeight))
        v.backgroundColor = UIColor.white
        v.delegate = self
        return v
    }()
    //add button
    lazy var addNewAgendaBtn: UIButton = {
        let b = UIButton()
        b.setImage(#imageLiteral(resourceName: "agenda_添加日程"), for: .normal)
        b.addTarget(self, action: #selector(addNewAgenda), for: .touchUpInside)
        let pan = UIPanGestureRecognizer.init(target: self, action: #selector(moveAddButton(sender:)))
        b.addGestureRecognizer(pan)
        return b
    }()
    //today
    lazy var goTodayBtn: UIButton = {
        let b = UIButton()
        b.setImage(#imageLiteral(resourceName: "agenda_今"), for: .normal)
        b.isHidden = true
        b.addTarget(self, action: #selector(goToday), for: .touchUpInside)
        return b
    }()
    //table view
    lazy var tableView: UITableView = {
        let tb = UITableView.init(frame: CGRect.null, style: .plain)
        tb.backgroundColor = kColor_background
        tb.dataSource = self
        tb.delegate = self
        tb.separatorStyle = .none
        tb.showsHorizontalScrollIndicator = false
        tb.register(BXBAgendaCell.self, forCellReuseIdentifier: "BXBAgendaCell")
        return tb
    }()
    //pan gesture
    lazy var scopeGesture: UIPanGestureRecognizer = {
        [unowned self] in
        let panGesture = UIPanGestureRecognizer(target: self.calendar, action: #selector(self.calendar.handleScopeGesture(_:)))
        panGesture.delegate = self
        panGesture.minimumNumberOfTouches = 1
        panGesture.maximumNumberOfTouches = 2
        return panGesture
        }()

    
    //MARK: - life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initUI()
        setRefresh()
        NotificationCenter.default.addObserver(self, selector: #selector(shouldRefreshDataNoti(sender:)), name: .kNotiAgendaShouldRefreshData, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(addNewAgendaDismissWay(sender:)), name: .kNotiAddNewAgendaDismissWay, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(addNewAgendaByOtherVC(sender:)), name: .kNotiAddNewAgendaByOtherController, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(addNewAgendaBySelectFollow(sender:)), name: .kNotiAddNewAgendaBySelectFollow, object: nil)

        
        view.addGestureRecognizer(self.scopeGesture)
        tableView.panGestureRecognizer.require(toFail: self.scopeGesture)
        
        //FIXME: 询问日历权限
        let eventStatus = EKEventStore.authorizationStatus(for: .event)
        switch eventStatus {
        case .authorized:
            makeEvents()
            
        case .notDetermined:
            makeEvents()
        default:
            break
        }
        
        currentDate = Date()
        
        loadData(date: Date())
        refreshCalendar()
        
        makeUserGuideForAgenda()
        
        /*
        #if DEBUG
        
        let fpsView = BXBFPSLabel.init(frame: CGRect.init(x: kScreenWidth * 0.65, y: 30, width: 50, height: 20))
        view.addSubview(fpsView)
        
        #endif
        */
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let token = UserDefaults.standard.value(forKey: "token")
        if token == nil {
            self.tableView.stateEmpty(title: "暂时没有待处理的日程", img: #imageLiteral(resourceName: "agenda_空白页"), buttonTitle: "新建日程", handle: {[weak self] in
                self?.addNewAgenda()
            })
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    //MARK: - ui
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        for v in calendar.subviews {
            if v.frame.height == 1 {
                v.isHidden = true
            }
        }
    }
    
    func getDate(date: Date) {
        let ca = Calendar.init(identifier: Calendar.Identifier.gregorian)
        let comps = ca.dateComponents([Calendar.Component.weekday, Calendar.Component.day, Calendar.Component.month], from: date)
        
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
    
    private func initUI() {
        
        calendar.select(Date())
        view.addSubview(naviBar)
        view.addSubview(calendar)
        view.addSubview(tableView)
        view.addSubview(addNewAgendaBtn)
        view.addSubview(goTodayBtn)
        
        view.backgroundColor = kColor_background
        
        tableView.snp.makeConstraints { (make) in
            make.top.equalTo(calendar.snp.bottom).offset(25 * KScreenRatio_6)
            make.width.centerX.equalTo(view)
//            make.width.equalTo(350 * KScreenRatio_6)
            make.bottom.equalTo(view).offset(-2)
        }
        addNewAgendaBtn.snp.makeConstraints { (make) in
            make.size.equalTo(CGSize.init(width: 80 * KScreenRatio_6, height: 80 * KScreenRatio_6))
            make.right.equalTo(view).offset(-10 * KScreenRatio_6)
            make.bottom.equalTo(tableView).offset(-40 * KScreenRatio_6)
        }
        goTodayBtn.snp.makeConstraints { (make) in
            make.size.equalTo(CGSize.init(width: 60 * KScreenRatio_6, height: 60 * KScreenRatio_6))
            make.centerX.equalTo(addNewAgendaBtn)
            make.bottom.equalTo(addNewAgendaBtn.snp.top)
        }
        
        tableView.reloadSection(0, with: .none)
    }
    
    //MARK: - action
    ///农历生成
    func makeEvents() {
        
        let minimumDate = dateFormatterYMD.date(from: "2017-01-01")
        
        var comps = DateComponents.init()
        comps.setValue(2, for: .year)
        guard let maximumDate = NSCalendar.init(calendarIdentifier: .gregorian)?.date(byAdding: comps, to: Date(), options: NSCalendar.Options(rawValue: 0)) else { return }
        let type = BXBAgendaVC.store.calendars(for: EKEntityType.event)
        
        BXBAgendaVC.store.requestAccess(to: .event) { [unowned self] (isGranted, error) in
            if isGranted == true {
                let fetchCalendarEvents = BXBAgendaVC.store.predicateForEvents(withStart: minimumDate!, end: maximumDate, calendars: type)
                let eventList = BXBAgendaVC.store.events(matching: fetchCalendarEvents) as NSArray
                let currentEvents = eventList.filtered(using: NSPredicate.init(block: { (event, bindingsDic) -> Bool in
                    guard let event = event else { return false }
                    let e = event as! EKEvent
                    return e.calendar.isSubscribed
                }))
                self.events = currentEvents as NSArray
            }
        }
        
    }
    
    ///某个日期的所有事件
    func eventsForDate(date: Date) -> Array<EKEvent> {
        
        let pre = NSPredicate.init(block: { (evaluatedObject, bindingsDic) -> Bool in
            let evaluated = evaluatedObject as! EKEvent
            let compare = evaluated.occurrenceDate.compare(date)
            
            return compare.rawValue == 0
        })
        
        let filteredEvents = events.filtered(using: pre) as! Array<EKEvent>
        
        return filteredEvents
    }

    
    //MARK: - network
    ///获取某天日程
    func loadData(date: Date) {
        
        goTodayBtn.isHidden = NSCalendar.current.isDateInToday(date)
        
        BXBNetworkTool.BXBRequest(router: Router.searchAgendaByDay(time: dateFormatterYMD.string(from: date)), success: { (resp) in
            
            self.tableView.mj_header.endRefreshing()
            self.rowHeightDic.removeAll()
            self.remindArr.removeAll()
            self.dataArr.removeAll()
            
            if let reminds = Mapper<AgendaRemindData>().mapArray(JSONObject: resp["clentRemindList"].arrayObject){
                
                self.remindArr = reminds
            }
            
            if let data = Mapper<AgendaData>().mapArray(JSONObject: resp["data"].arrayObject){
                
                self.dataArr = data
            }
            if self.dataArr.count == 0 && self.remindArr.count == 0 {
                
                self.tableView.stateEmpty(title: "暂时没有待处理的日程", img: #imageLiteral(resourceName: "agenda_空白页"), buttonTitle: "新建日程", handle: {[weak self] in
                    self?.addNewAgenda()
                })
            }
            else { self.tableView.stateNormal() }
            
            self.calendar.reloadData()
            self.tableView.reloadData()
            
            if self.lastFinishedAgendaId == 0 {
                if self.tableViewAction == .none {
                    
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.2, execute: {
                        self.tableView.scrollToTop()
                    })
                }
                
            }
            else {//滚动到刚刚完成的cell
                for (i, v) in self.dataArr.enumerated() {
                    if v.id == self.lastFinishedAgendaId {
                        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.2, execute: {
                            self.agendaFinishAnimation(indexPath: IndexPath.init(row: i, section: 1))
                        })
                    }
                }
            }
            
        }) { (error) in
            self.tableView.mj_header.endRefreshing()
        }
        
    }
    
    ///删除日程
    func deleteAgenda(index: Int, success: @escaping () -> Void) {
        guard dataArr.count > index else {
            return
        }
        BXBNetworkTool.isShowSVProgressHUD = false
        BXBNetworkTool.BXBRequest(router: .deleteAgenda(id: dataArr[index].id), success: { (resp) in
            
            BXBLocalizeNotification.removeLocalizeNotification(id: self.dataArr[index].id)
            NotificationCenter.default.post(name: .kNotiAgendaShouldRefreshData, object: nil, userInfo: nil)
            success()
            
        }) { (error) in
            
        }
    }
    
    //refresh
    func setRefresh() {
        
        BXBNetworkRefresh.headerRefresh(scrollView: tableView) {[weak self] in
            self?.tableViewAction = .none
            self?.loadData(date: self?.calendar.selectedDate ?? Date())
        }
    }

}



