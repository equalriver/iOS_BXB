//
//  TeamData.swift
//  BXB
//
//  Created by equalriver on 2018/7/5.
//  Copyright © 2018年 tobosoft. All rights reserved.
//

import UIKit
import ObjectMapper

class TeamData: BXBBaseModel {
    
    ///团队id
    var id = 0
    
    var remarks = ""
    
    var teamName = ""
    
    ///用户id
    var ownerId = 0
    
    var targetAmount = ""
    
    var completedAmount = ""
    
    var status = 0
    
    var label = ""
    
    var logo = ""
    
    var teamCount = 0
    
    var name = ""

    var userId = 0
    
    
    override func mapping(map: Map) {
        id <- map["id"]
        remarks <- map["remarks"]
        teamName <- map["teamName"]
        ownerId <- map["ownerId"]
        targetAmount <- map["targetAmount"]
        completedAmount <- map["completedAmount"]
        status <- map["status"]
        label <- map["label"]
        logo <- map["logo"]
        teamCount <- map["teamCount"]
        name <- map["name"]
        userId <- map["userId"]
    }
    
}


class TeamPersonData: BXBBaseModel {
    ///团队id
    var id = 0
    
    var status = 0
    
    var name = ""
    ///用户id
    var ownerId = 0
    
    
    override func mapping(map: Map) {
        id <- map["id"]
        status <- map["status"]
        name <- map["name"]
        ownerId <- map["ownerId"]
    }
    
}

class TeamActivityTotalData: BXBBaseModel {
    
    ///接洽总数
    var jieqieTotal = 0
    
    ///面谈总数
    var miantanTotal = 0
    
    ///建议书总数
    var jianyishuTotal = 0
    
    ///增员总数
    var zengyuanTotal = 0
    
    ///保单服务总数
    var baodanTotal = 0
    
    ///客户服务总数
    var kehuTotal = 0
    
    ///签单总数
    var qiandanTotal = 0
    
    ///接洽平均数
    var jieqieAvg = 0.0
    
    ///面谈平均数
    var miantanAvg = 0.0
    
    ///建议书平均数
    var jianyishuAvg = 0.0
    
    ///增员平均数
    var zengyuanAvg = 0.0
    
    ///保单服务平均数
    var baodanAvg = 0.0
    
    ///客户服务平均数
    var kehuAvg = 0.0
    
    ///签单平均数
    var qiandanAvg = 0.0
    
    
    override func mapping(map: Map) {
        jieqieTotal <- map["jieqieTotal"]
        miantanTotal <- map["miantanTotal"]
        jianyishuTotal <- map["jianyishuTotal"]
        zengyuanTotal <- map["zengyuanTotal"]
        baodanTotal <- map["baodanTotal"]
        kehuTotal <- map["kehuTotal"]
        qiandanTotal <- map["qiandanTotal"]
        jieqieAvg <- map["jieqieAvg"]
        miantanAvg <- map["miantanAvg"]
        jianyishuAvg <- map["jianyishuAvg"]
        zengyuanAvg <- map["zengyuanAvg"]
        baodanAvg <- map["baodanAvg"]
        kehuAvg <- map["kehuAvg"]
        qiandanAvg <- map["qiandanAvg"]
    }
    
}


class TeamActivityMemberData: BXBBaseModel {
    
    ///用户ID
    var id = 0
    
    ///用户名
    var name = ""
    
    ///接洽个数
    var jieqie = 0
    
    ///面谈个数
    var miantan = 0
    
    ///建议书个数
    var jianyishu = 0
    
    ///增员个数
    var zengyuan = 0
    
    ///保单服务个数
    var baodan = 0
    
    ///客户服务个数
    var kehu = 0
    
    ///签单个数
    var qiandan = 0
    
    
    override func mapping(map: Map) {
        id <- map["id"]
        name <- map["name"]
        jieqie <- map["jieqie"]
        miantan <- map["miantan"]
        jianyishu <- map["jianyishu"]
        zengyuan <- map["zengyuan"]
        baodan <- map["baodan"]
        kehu <- map["kehu"]
        qiandan <- map["qiandan"]
    }
    
}















