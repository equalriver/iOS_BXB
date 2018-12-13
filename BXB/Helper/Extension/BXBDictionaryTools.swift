//
//  DictionaryTools.swift
//  BXB
//
//  Created by equalriver on 2018/6/27.
//  Copyright © 2018年 tobosoft. All rights reserved.
//

import Foundation


extension Dictionary {
    ///字典转json
    func getJSONStringFromDictionary() -> String {
        if (!JSONSerialization.isValidJSONObject(self)) {
            print("无法解析出JSONString")
            return ""
        }
        let data : NSData! = try! JSONSerialization.data(withJSONObject: self, options: []) as NSData?
        let JSONString = NSString(data:data as Data,encoding: String.Encoding.utf8.rawValue)
        return JSONString! as String
        
    }
}
