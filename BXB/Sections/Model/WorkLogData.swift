//
//  WorkLogData.swift
//  BXB
//
//  Created by equalriver on 2018/8/8.
//  Copyright © 2018年 tobosoft. All rights reserved.
//

import Foundation
import ObjectMapper

class WorkLogListData: BXBBaseModel {
    
    var list = Array<WorkLogData>()
    
    var visitTepyName = ""
    
    
    override func mapping(map: Map) {
        list <- map["list"]
        visitTepyName <- map["visitTepyName"]
    }
}

class WorkLogData: BXBBaseModel {
    
    ///日程ID
    var id = 0
    
    ///客户ID
    var clientId = 0
    
    ///客户姓名
    var name = ""
    
    ///拜访时间
    var visitDate = ""
    
    ///拜访选择的类型
    var visitTepyName = ""
    
    ///完成的事项
    var matter = ""
    
    ///心得
    var heart = ""
    
    ///状态（1为完成，0为未完成）
    var status = 0
    
    ///签单数量
    var policyNum = 0
    
    ///签单金额
    var amount = 0
    
    ///备注
    var remarks = ""
    
    ///是否提交（1为已提交，0为没有提交）
    var isSubmit = 0
    
    
    
    override func mapping(map: Map) {
        id <- map["id"]
        clientId <- map["clientId"]
        name <- map["name"]
        visitDate <- map["visitDate"]
        visitTepyName <- map["visitTepyName"]
        matter <- map["matter"]
        heart <- map["heart"]
        status <- map["status"]
        policyNum <- map["policyNum"]
        amount <- map["amount"]
        remarks <- map["remarks"]
        isSubmit <- map["isSubmit"]
    }
}




