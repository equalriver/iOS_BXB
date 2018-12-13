//
//  BXBLocalizeNotification.swift
//  BXB
//
//  Created by equalriver on 2018/7/5.
//  Copyright © 2018年 tobosoft. All rights reserved.
//

import Foundation


struct BXBLocalizeNotification {
    
    ///设置本地通知
    public static func sendLocalizeNotification(id: Int, alertTitle: String?, alertBody: String, image: String?, fireDate: Date?) {
        
        if fireDate == nil { return }
        
        let notis = UIApplication.shared.scheduledLocalNotifications
        
        if notis != nil && notis!.count > 0 {//修改已有的通知
            
            for v in notis! {
                if v.userInfo != nil {
                    
                    if let i = v.userInfo![kBXBNotiId] {
                        let notiId = i as! Int
                        if notiId == id {
                            v.alertTitle = alertTitle
                            v.alertBody = alertBody
                            v.fireDate = fireDate
                            v.alertLaunchImage = image
                            return
                        }
                    }
                }
            }
        }
        //新建通知
            
        let localNotification = UILocalNotification.init()
        
        localNotification.userInfo = [kBXBNotiId: id]
        
        //显示内容
        localNotification.alertTitle = alertTitle
        localNotification.alertBody = alertBody
        localNotification.alertLaunchImage = image
        //发送时间
        localNotification.fireDate = fireDate
        localNotification.applicationIconBadgeNumber += 1
        localNotification.soundName = UILocalNotificationDefaultSoundName
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        print("设置通知: ")
        print(formatter.string(from: fireDate!))
        //发送通知
        UIApplication.shared.scheduleLocalNotification(localNotification)
        
        
        
    }
    
    ///移除本地通知
    public static func removeLocalizeNotification(id: Int) {
        
        guard let notis = UIApplication.shared.scheduledLocalNotifications else { return }
        for v in notis {
            if v.userInfo != nil {
                guard let i = v.userInfo![kBXBNotiId] else { return }
                let notiId = i as! Int
                if notiId == id {
                    UIApplication.shared.cancelLocalNotification(v)
                }
            }
        }
        
    }
    
    ///验证通知有效性
    public static func checkNoticeDateValidate(name: String, date: Date) -> Bool {
        
        guard let d = BXBLocalizeNotification.getDateWithRemindName(name: name, date: date) else { return false }
        if d.compare(Date()) == ComparisonResult.orderedDescending || d.compare(Date()) == ComparisonResult.orderedSame { return true }
        
        return false
    }
    
    ///转换提醒时间string -> date
    public static func getDateWithRemindName(name: String, date: Date) -> Date? {
        
        if name == "无" { return nil }
        
        var comps = DateComponents()
        
        if name == "日程开始时" || name == "当天" {
            return date
        }
        else if name.contains("分钟前") {
            let arr = name.components(separatedBy: "分")
            if let mStr = arr.first {
                
                if let m = Int(mStr){ comps.setValue(-m, for: .minute) }
            }
        }
        else if name == "1小时前" {
            comps.setValue(-1, for: .hour)
        }
        else if name == "2小时前" {
            
            comps.setValue(-2, for: .hour)
        }
        else if name.contains("天提醒") {
            guard let s1 = name.components(separatedBy: "天").first else { return Date() }
            if s1.contains("提前") {
                guard let day = s1.components(separatedBy: "前").last else { return Date() }
                if let d = Int(day){ comps.setValue(-d, for: .day) }
            }
        }
        
        let ca = NSCalendar.init(calendarIdentifier: .gregorian)
        
        if let com_date = ca?.date(byAdding: comps, to: date, options: NSCalendar.Options(rawValue: 0)) {
            return com_date
        }
        
        return Date()
        
    }
    
    
}
