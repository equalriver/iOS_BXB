//
//  AgendaData.swift
//  BXB
//
//  Created by equalriver on 2018/6/13.
//  Copyright © 2018年 tobosoft. All rights reserved.
//

import Foundation
import ObjectMapper


class AgendaData: BXBBaseModel {
    
    lazy var formatter: DateFormatter = {
        let f = DateFormatter()
        f.dateFormat = "yyyy-MM-dd HH:mm"
        return f
    }()

    
    
    //工作页面相关
    var isWorkData = false
    var noticeId = 0
    
    ///是否是提醒跟进
    var isNoticeFollow = false
    
    var isOldAgenda = false
    
    
    ///所属团队Id
    var teamId = 0
    ///地址
    var address = ""
    ///心得
    var heart = ""
    ///备注
    var remarks = ""
    ///提醒时间
    var remindTime = ""
    ///状态，1为已完成/0为未完成
    var status = 0
    ///拜访时间
    var visitDate = ""
    ///事项ID
//    var visitTypeKey = ""
    ///事项名称
    var visitTypeName = ""
    ///复选事项名称
    var matter = ""
    ///拜访时间的时分秒
    var visitTime = ""
    ///客户名称
    var name = ""
    ///日程ID
    var id = 0
    ///yyyy-MM-dd
    var time = ""
    ///签单金额
    var amount = 0
    ///签单数
    var policyNum = ""
    
    var lat = ""
    
    var lng = ""
    
    //备注地址
    var detailAddress = ""
    
    ///提醒时间
    var remindDate = ""
    
    override func mapping(map: Map) {
        address <- map["address"]
        heart <- map["heart"]
        remarks <- map["remarks"]
        remindTime <- map["remindTime"]
        status <- map["status"]
        visitDate <- map["visitDate"]
//        visitTypeKey <- map["visitTepyKey"]
        visitTypeName <- map["visitTepyName"]
        matter <- map["matter"]
        visitTime <- map["visitTime"]
        name <- map["name"]
        id <- map["id"]
        time <- map["time"]
        amount <- map["amount"]
        policyNum <- map["policyNum"]
        lat <- map["latitude"]
        lng <- map["longitude"]
        detailAddress <- map["unitAddress"]
        remindDate <- map["remindDate"]
    }
}



class AgendaRemindData: BXBBaseModel {
    
    ///提醒的ID
    var id = 0
    
    ///事项ID
    var matterId = 0
    
    ///事项
    var matter = ""
    
    ///自定义事项名称
    var remindName = ""
    
    ///提醒时间，汉字
    var remindTime = ""
    
    ///提醒时间
    var remindDate = ""
    
    ///客户名称
    var name = ""
    
    ///事件发生时间与当前时间相距天数
    var difTime = 0
    
    ///是否已经设置提醒
    var remind = 0
    
    ///事件发生时间(read)
    var times = ""
    
    ///事件发生时间（set）
    var time = ""
    
    override func mapping(map: Map) {
        id <- map["id"]
        matterId <- map["matterId"]
        matter <- map["matter"]
        remindName <- map["remindName"]
        remindTime <- map["remindTime"]
        remindDate <- map["remindDate"]
        name <- map["name"]
        difTime <- map["difTime"]
        remind <- map["remind"]
        times <- map["times"]
        time <- map["time"]
    }
}











