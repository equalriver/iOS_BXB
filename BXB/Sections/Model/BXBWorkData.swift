//
//  BXBWorkData.swift
//  BXB
//
//  Created by equalriver on 2018/9/27.
//  Copyright © 2018年 tobosoft. All rights reserved.
//

import Foundation
import ObjectMapper

class BXBWorkData: BXBBaseModel {

    ///活动量
    var finishVisit = 0
    
    ///成交件数
    var policyNum = 0
    
    ///增员
    var zengYuanTotal = 0
    
    ///新增客户
    var addClientTotal = 0
    
    
    override func mapping(map: Map) {
        finishVisit <- map["finishVisit"]
        policyNum <- map["policyNum"]
        zengYuanTotal <- map["zengYuanTotal"]
        addClientTotal <- map["addClientTotal"]
    }
}
