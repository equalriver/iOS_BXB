//
//  NoticeData.swift
//  BXB
//
//  Created by equalriver on 2018/7/7.
//  Copyright © 2018年 tobosoft. All rights reserved.
//

import Foundation
import ObjectMapper

class NoticeData: BXBBaseModel {
    
    var remindDate = ""
    var list = Array<NoticeDetailData>()
    
    override func mapping(map: Map) {
        remindDate <- map["remindDate"]
        list <- map["list"]
  
    }
}


class NoticeDetailData: BXBBaseModel {
    
    var isWorkData = false
    
    var name = ""
    
    var matterId = ""
    
    var matter = ""
    
    var remindId = ""
    
    var remindName = ""
    
    var remindDate = ""
    
    ///距离提醒剩余时间
    var difTime = ""
    
    var remindTime = ""
    
    var times = ""
    
    var id = 0
    /// "已失效"
    var remind = ""
    
    var remarks = ""
    
    var status = ""
    ///是否跟进
    var isFollow = "0"
    
    var clientId = 0

    
    
    override func mapping(map: Map) {
        name <- map["name"]
        matterId <- map["matterId"]
        matter <- map["matter"]
        remindId <- map["remindId"]
        remindName <- map["remindName"]
        remindDate <- map["remindDate"]
        difTime <- map["difTime"]
        remindTime <- map["remindTime"]
        times <- map["times"]
        id <- map["id"]
        remind <- map["remind"]
        remarks <- map["remarks"]
        status <- map["status"]
        isFollow <- map["isFollow"]
        clientId <- map["clientId"]
    }
}








