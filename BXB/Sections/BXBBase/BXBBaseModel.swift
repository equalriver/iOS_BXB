
//
//  BXBBaseModel.swift
//  BXB
//
//  Created by 尹平江 on 2018/6/5.
//  Copyright © 2018年 tobosoft. All rights reserved.
//

import Foundation
import ObjectMapper

class BXBBaseModel: NSObject, Mappable {
    
    
    public required init?(map: Map) {
        
    }
    
    override init() {
        super.init()
    }
    
    public func mapping(map: Map) {
        
    }
}

