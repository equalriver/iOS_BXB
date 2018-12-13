//
//  NotificationMacro.swift
//  BXB
//
//  Created by equalriver on 2018/6/15.
//  Copyright © 2018年 tobosoft. All rights reserved.
//

import Foundation

extension Notification.Name {
    
    ///登录成功
    public static let kNotiLoginComplete = Notification.Name.init("kNotiLoginComplete")
    
    
    
    
    ///工作页面提醒已跟进
    public static let kNotiWorkDidFinishNotice = Notification.Name.init("kNotiWorkDidFinishNotice")
    
    
    
    
    ///刷新日程列表
    public static let kNotiAgendaShouldRefreshData = Notification.Name.init("kNotiAgendaShouldRefreshData")
    
    ///新建日程完成后跳转
    public static let kNotiAddNewAgendaDismissWay = Notification.Name.init("kNotiAddNewAgendaDismissWay")
    
    ///补录日程后从添加界面dismiss
    public static let kNotiAddOldAgendaNeedDismiss = Notification.Name.init("kNotiAddOldAgendaNeedDismiss")
    
    ///从地图附近选择的用户带参数新建日程
    public static let kNotiAddNewAgendaByOtherController = Notification.Name.init("kNotiAddNewAgendaByOtherController")
    
    ///点击了添加后续带参数新建日程
    public static let kNotiAddNewAgendaBySelectFollow = Notification.Name.init("kNotiAddNewAgendaBySelectFollow")
    
    
    
    
    ///刷新客户列表
    public static let kNotiClientShouldRefreshData = Notification.Name.init("kNotiClientShouldRefreshData")
    
    ///刷新客户详情
    public static let kNotiClientDetailShouldRefreshData = Notification.Name.init("kNotiClientDetailShouldRefreshData")
    
    ///刷新提醒列表
    public static let kNotiRemindShouldRefreshData = Notification.Name.init("kNotiRemindShouldRefreshData")
    
    
    
    
    
    ///刷新团队详情
    public static let kNotiTeamDetailShouldRefreshData = Notification.Name.init("kNotiTeamDetailShouldRefreshData")
    
    
    
    
    
    ///刷新我的页面
    public static let kNotiUserShouldRefreshData = Notification.Name.init("kNotiUserShouldRefreshData")
    
    
    
    

    
}



///上次跟进
public let kLastAgendaFollowKey = "kLastAgendaFollowKey"


///刚刚完成的日程key
public let kLastFinishedAgendaKey = "kLastFinishedAgendaKey"









