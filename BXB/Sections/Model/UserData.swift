//
//  UserData.swift
//  BXB
//
//  Created by equalriver on 2018/7/3.
//  Copyright © 2018年 tobosoft. All rights reserved.
//

import Foundation
import ObjectMapper


class UserData: BXBBaseModel {
    
    var name = ""
    
    var lastLoginTime = 0
    
    var introduce = ""
    
    var birthdayStatus = 0
    
    var userName = ""
    
    var birthday = ""
    
    var remarks = ""
    ///签名
    var signature = ""
    
    var status = 0
    
    var id = 0
    
    var password = ""
    
    var token = ""
    
    var sex = ""
    
    var phone = ""
    
    var marriageStatus = ""
    
    ///创建的团队的ID
    var createTeamId = 0
    
    ///创建的团队名
    var createTeamName = ""
    
    ///创建的团队总人数
    var createTeamCount = 0
    
    ///加入的团队总人数
    var addTeamCount = 0
    
    ///加入的团队群主名称
    var addName = ""
    
    ///加入的团队的ID
    var addTeamId = 0
    
    ///加入的团队名
    var addTeamName = ""
    
    var addLogo = ""
    
    var createLogo = ""
    
    
    override func mapping(map: Map) {
        name <- map["name"]
        lastLoginTime <- map["lastLoginTime"]
        introduce <- map["introduce"]
        birthdayStatus <- map["birthdayStatus"]
        userName <- map["userName"]
        birthday <- map["birthday"]
        remarks <- map["remarks"]
        signature <- map["signature"]
        status <- map["status"]
        id <- map["id"]
        password <- map["password"]
        token <- map["token"]
        sex <- map["sex"]
        phone <- map["phone"]
        marriageStatus <- map["marriageStatus"]
        createTeamId <- map["createTeamId"]
        createTeamName <- map["createTeamName"]
        createTeamCount <- map["createTeamCount"]
        addTeamCount <- map["addTeamCount"]
        addName <- map["addName"]
        addTeamId <- map["addTeamId"]
        addTeamName <- map["addTeamName"]
        addLogo <- map["addLogo"]
        createLogo <- map["createLogo"]
    }
}


class UserAimsData: BXBBaseModel {
    ///个人活动量目标
    var activityCount = 0
    
    ///个人保费目标
    var targetAmount = 0
    
    ///团队保费目标
    var targetAmountTeam = 0
    
    
    override func mapping(map: Map) {
        activityCount <- map["activityCount"]
        targetAmount <- map["targetAmount"]
        targetAmountTeam <- map["targetAmountTeam"]
    }
}














