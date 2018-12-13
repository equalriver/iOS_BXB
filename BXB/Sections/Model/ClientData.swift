//
//  ClientData.swift
//  BXB
//
//  Created by equalriver on 2018/6/19.
//  Copyright © 2018年 tobosoft. All rights reserved.
//

import Foundation
import ObjectMapper

class ClientData: BXBBaseModel, NSCoding {

    var clientItemStyle = ""

    var phone = ""
    
    ///客户名称
    var name = ""
    ///居住地址
    var residentialAddress = ""
    ///工作地址
    var workingAddress = ""
    
    var birthday = ""
    
    var sex = ""
    ///收入
    var income = 0
    ///婚姻状态
    var marriageStatus = ""
    ///学历名称
    var educationName = ""
    ///学历Key
    var educationKey = ""
    ///介绍人ID
    var introducerId = 0
    ///星级
    var grade = 0
    ///标签
    var label = ""
    ///状态,1为已签单，0为未签单
    var status = 0
    ///备注
    var remarks = ""
        
    var id = 0
    
    ///距离提醒剩余时间
    var time = 0
    
    var times = ""
    
    ///提醒设置
    var remind = ""
    
    var remindTime = ""
    
    var remindName = ""
    
    ///提醒的时间
    var remindDate = ""
    
    ///互动次数
    var visitCount = 0
    
    ///上次互动时间
    var visitTime = 0
    
    ///保单
    var policyCount = 0
    
    ///保费
    var policyAmount = 0
    ///已签单/未签单
    var isWrite = ""
    
    ///家庭地址纬度
    var latitude = ""
    
    ///家庭地址经度
    var longitude = ""
    
    ///提醒类型
    var matter = ""
    
    ///工作地址纬度
    var workLatitude = ""
    
    ///工作地址经度
    var workLongitude = ""
    
    ///家庭地址备注
    var unitAddress = ""
    
    ///工作地址备注
    var workUnitAddress = ""
    
    override init() {
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init()
        phone = aDecoder.decodeObject(forKey: "phone") as? String ?? ""
        name = aDecoder.decodeObject(forKey: "name") as? String ?? ""
        residentialAddress = aDecoder.decodeObject(forKey: "residentialAddress") as? String ?? ""
        workingAddress = aDecoder.decodeObject(forKey: "workingAddress") as? String ?? ""
        birthday = aDecoder.decodeObject(forKey: "birthday") as? String ?? ""
        sex = aDecoder.decodeObject(forKey: "sex") as? String ?? ""
        income = aDecoder.decodeInteger(forKey: "income")
        marriageStatus = aDecoder.decodeObject(forKey: "marriageStatus") as? String ?? ""
        educationName = aDecoder.decodeObject(forKey: "educationName") as? String ?? ""
        educationKey = aDecoder.decodeObject(forKey: "educationKey") as? String ?? ""
        introducerId = aDecoder.decodeInteger(forKey: "introducerId")
        grade = aDecoder.decodeInteger(forKey: "grade")
        label = aDecoder.decodeObject(forKey: "label") as? String ?? ""
        status = aDecoder.decodeInteger(forKey: "status")
        remarks = aDecoder.decodeObject(forKey: "remarks") as? String ?? ""
        id = aDecoder.decodeInteger(forKey: "id")
        time = aDecoder.decodeInteger(forKey: "time")
        times = aDecoder.decodeObject(forKey: "times") as? String ?? ""
        remind = aDecoder.decodeObject(forKey: "remind") as? String ?? ""
        remindTime = aDecoder.decodeObject(forKey: "remindTime") as? String ?? ""
        remindName = aDecoder.decodeObject(forKey: "remindName") as? String ?? ""
        remindDate = aDecoder.decodeObject(forKey: "remindDate") as? String ?? ""
        visitCount = aDecoder.decodeInteger(forKey: "visitCount")
        visitTime = aDecoder.decodeInteger(forKey: "visitTime")
        policyCount = aDecoder.decodeInteger(forKey: "policyCount")
        policyAmount = aDecoder.decodeInteger(forKey: "policyAmount") 
        latitude = aDecoder.decodeObject(forKey: "latitude") as? String ?? ""
        longitude = aDecoder.decodeObject(forKey: "longitude") as? String ?? ""
        matter = aDecoder.decodeObject(forKey: "matter") as? String ?? ""
        workLatitude = aDecoder.decodeObject(forKey: "workLatitude") as? String ?? ""
        workLongitude = aDecoder.decodeObject(forKey: "workLongitude") as? String ?? ""
        unitAddress = aDecoder.decodeObject(forKey: "unitAddress") as? String ?? ""
        workUnitAddress = aDecoder.decodeObject(forKey: "workUnitAddress") as? String ?? ""
    }
    
    public required init?(map: Map) {
        super.init(map: map)
//        fatalError("init(map:) has not been implemented")
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(phone, forKey: "phone")
        aCoder.encode(name, forKey: "name")
        aCoder.encode(residentialAddress, forKey: "residentialAddress")
        aCoder.encode(workingAddress, forKey: "workingAddress")
        aCoder.encode(birthday, forKey: "birthday")
        aCoder.encode(sex, forKey: "sex")
        aCoder.encode(income, forKey: "income")
        aCoder.encode(marriageStatus, forKey: "marriageStatus")
        aCoder.encode(educationName, forKey: "educationName")
        aCoder.encode(educationKey, forKey: "educationKey")
        aCoder.encode(introducerId, forKey: "introducerId")
        aCoder.encode(grade, forKey: "grade")
        aCoder.encode(label, forKey: "label")
        aCoder.encode(status, forKey: "status")
        aCoder.encode(remarks, forKey: "remarks")
        aCoder.encode(id, forKey: "id")
        aCoder.encode(time, forKey: "time")
        aCoder.encode(times, forKey: "times")
        aCoder.encode(remind, forKey: "remind")
        aCoder.encode(remindTime, forKey: "remindTime")
        aCoder.encode(remindName, forKey: "remindName")
        aCoder.encode(remindDate, forKey: "remindDate")
        aCoder.encode(visitCount, forKey: "visitCount")
        aCoder.encode(visitTime, forKey: "visitTime")
        aCoder.encode(policyCount, forKey: "policyCount")
        aCoder.encode(policyAmount, forKey: "policyAmount")
        aCoder.encode(latitude, forKey: "latitude")
        aCoder.encode(longitude, forKey: "longitude")
        aCoder.encode(matter, forKey: "matter")
        aCoder.encode(workLatitude, forKey: "workLatitude")
        aCoder.encode(workLongitude, forKey: "workLongitude")
        aCoder.encode(unitAddress, forKey: "unitAddress")
        aCoder.encode(workUnitAddress, forKey: "workUnitAddress")
    }
    
    override func mapping(map: Map) {
        phone <- map["phone"]
        name <- map["name"]
        residentialAddress <- map["residentialAddress"]
        workingAddress <- map["workingAddress"]
        birthday <- map["birthday"]
        sex <- map["sex"]
        income <- map["income"]
        marriageStatus <- map["marriageStatus"]
        educationName <- map["educationName"]
        educationKey <- map["educationKey"]
        introducerId <- map["introducerId"]
        grade <- map["grade"]
        label <- map["label"]
        status <- map["status"]
        remarks <- map["remarks"]
        id <- map["id"]
        time <- map["time"]
        times <- map["times"]
        remind <- map["remind"]
        remindTime <- map["remindTime"]
        remindName <- map["remindName"]
        remindDate <- map["remindDate"]
        visitCount <- map["visitCount"]
        visitTime <- map["visitTime"]
        policyCount <- map["policyCount"]
        policyAmount <- map["policyAmount"]
        isWrite <- map["isWrite"]
        latitude <- map["latitude"]
        longitude <- map["longitude"]
        matter <- map["matter"]
        workLatitude <- map["workLatitude"]
        workLongitude <- map["workLongitude"]
        unitAddress <- map["unitAddress"]
        workUnitAddress <- map["workUnitAddress"]
    }
}

class ClientDetailNoticeData: BXBBaseModel {

    ///自定义详情cell状态
    var cellType = ClientDetailCellType.normal
    var indexPath: IndexPath!
    
    var name = ""
    var matterId = ""
    var matter = ""
    var remindId = ""
    var remindName = ""
    ///距离提醒剩余时间
    var time = ""
    var remindTime = ""
    var times = ""
    var id = 0
    
    override func mapping(map: Map) {
        name <- map["name"]
        matterId <- map["matterId"]
        matter <- map["matter"]
        remindId <- map["remindId"]
        remindName <- map["remindName"]
        time <- map["time"]
        remindTime <- map["remindTime"]
        times <- map["times"]
        id <- map["id"]
    }
}

class ClientDetailRecordData: BXBBaseModel {
    
    var indexPath: IndexPath!
    ///
    var visitTepyName = ""
    
    ///
    var visitStatus = 0
    
    ///
    var visitDate = ""
    
    override func mapping(map: Map) {
        visitTepyName <- map["visitTepyName"]
        visitStatus <- map["visitStatus"]
        visitDate <- map["visitDate"]
    }
}

class ClientDetailMaintainData: BXBBaseModel {

    ///自定义详情cell状态
    var cellType = ClientDetailCellType.normal
    var indexPath: IndexPath!
    
    
    var name = ""
    var content = ""
    var spentDate = ""
    var spentMoney = 0
    var remarks = ""
    var id = 0
    
    override func mapping(map: Map) {
        name <- map["name"]
        content <- map["content"]
        spentDate <- map["spentDate"]
        spentMoney <- map["spentMoney"]
        remarks <- map["remarks"]
        id <- map["id"]
    }
}


class ClientNearData: BXBBaseModel {
    
    var id = 0
    
    var name = ""
    
    ///客户住址
    var residentialAddress = ""
    
    ///客户与用户的距离
    var label = ""
    
    ///客户地址纬度
    var latitude = ""
    
    ///客户地址经度
    var longitude = ""
    
    var phone = ""
    
    ///状态,1为已签单，0为未签单
    var isWrite = 0
    
    ///互动次数
    var visitCount = 0
    
    ///上次互动时间
    var visitTime = 0
    
    ///地址备注
    var unitAddress = ""
    

    override func mapping(map: Map) {
        id <- map["id"]
        name <- map["name"]
        residentialAddress <- map["residentialAddress"]
        label <- map["label"]
        latitude <- map["latitude"]
        longitude <- map["longitude"]
        phone <- map["phone"]
        unitAddress <- map["unitAddress"]
        visitCount <- map["visitCount"]
        visitTime <- map["visitTime"]
        isWrite <- map["isWrite"]
    }
}


class ClientContactData: BXBBaseModel {
    
    var phone = ""
    
    var name = ""
    
    var status = 0
    
    
    override func mapping(map: Map) {
        
        
    }
}


class ClientAllAgendaIdData: BXBBaseModel {
    
    var id = 0
    
    override func mapping(map: Map) {
        id <- map["id"]
    }
}















