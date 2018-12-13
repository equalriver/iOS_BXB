//
//  AnalyzeData.swift
//  BXB
//
//  Created by equalriver on 2018/7/13.
//  Copyright © 2018年 tobosoft. All rights reserved.
//

import Foundation
import ObjectMapper

class AnalyzeData: BXBBaseModel {
    
    ///保费目标
    var PolicyPerson = AnalyzePolicyPerson()
    
    ///活动量目标
    var VisitPerson = AnalyzeVisitPerson()
    
    ///活动量详细
    var VisitTypeList = Array<AnalyzeVisitTypeList>()
    
    ///互动详细
    var ClientType = Array<AnalyzeClientType>()
    
    var listPer = Array<AnalyzeChangeData>()
    
    ///签单总览
    var policyList = Array<AnalyzePolicyList>()
    
    
    ///工作简报
    var workList = BXBWorkData()
    
    ///互动收益
    var num = 0
    
    ///转化率
    var percent = ""
    
    
    override func mapping(map: Map) {
        VisitPerson <- map["VisitPerson"]
        PolicyPerson <- map["PolicyPerson"]
        VisitTypeList <- map["VisitTypeList"]
        ClientType <- map["ClientType"]
        num <- map["num"]
        percent <- map["percent"]
        listPer <- map["listPer"]
        workList <- map["WorkList"]
        policyList <- map["policyList"]
    }
}


class AnalyzePolicyPerson: BXBBaseModel {
    
    ///实际完成金额
    var completedAmount = 0
    
    ///目标金额
    var targetAmount = 0
    
    ///签单数
    var policyNum = 0
    
    
    override func mapping(map: Map) {
        completedAmount <- map["completedAmount"]
        targetAmount <- map["targetAmount"]
        policyNum <- map["policyNum"]
    }
}


class AnalyzeVisitPerson: BXBBaseModel {
    
    ///活动目标
    var activityCount = 0
    
    ///实际活动量
    var finishVisit = 0
    
    
    override func mapping(map: Map) {
//        activityCount <- map["activityCount"]
//        finishVisit <- map["finishVisit"]
        finishVisit <- map["activityCount"]
        activityCount <- map["finishVisit"]
    }
}


class AnalyzeVisitTypeList: BXBBaseModel {
    
    ///活动量名称
    var visitTepyName = ""
    
    ///活动次数
    var visitCount = 0
    
    class func initData(name: String) -> AnalyzeVisitTypeList {
        let obj = AnalyzeVisitTypeList()
        obj.visitTepyName = name
        obj.visitCount = 0
        return obj
    }
    
    override func mapping(map: Map) {
        visitTepyName <- map["visitTepyName"]
        visitCount <- map["visitCount"]
    }
}


class AnalyzeClientType: BXBBaseModel {
    
    ///客户名称
    var name = ""
    
    ///客户拜访次数
    var clientCount = 0
    
    
    override func mapping(map: Map) {
        name <- map["name"]
        clientCount <- map["clientCount"]
    }
}


class AnalyzeChangeData: BXBBaseModel {
    
    ///活动名称
    var visitTepyName = ""
    
    ///次数
    var visitCount = 0
    
    class func initData(name: String, count: Int) -> AnalyzeChangeData {
        let obj = AnalyzeChangeData()
        obj.visitTepyName = name
        obj.visitCount = count
        return obj
    }
    
    override func mapping(map: Map) {
        visitTepyName <- map["visitTepyName"]
        visitCount <- map["visitCount"]
    }
}


class AnalyzePolicyList: BXBBaseModel {
    ///客户名称
    var name = ""
    
    ///签单日期
    var policyDate = ""
    
    ///签单数
    var policyNum = 0
    
    ///签单金额
    var amount = 0
    
    
    override func mapping(map: Map) {
        name <- map["name"]
        policyDate <- map["policyDate"]
        policyNum <- map["policyNum"]
        amount <- map["amount"]
    }
}


