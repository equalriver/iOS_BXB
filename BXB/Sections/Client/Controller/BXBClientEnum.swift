//
//  BXBClientEnum.swift
//  BXB
//
//  Created by equalriver on 2018/8/21.
//  Copyright © 2018年 tobosoft. All rights reserved.
//

import Foundation



enum ClientDetailEditTranslationState {
    case normal
    case push
    case pop
}

enum ClientDetailState {
    case normal
    case add
    case edit
}

enum ClientDetailCellType {
    case normal
    case edit
}

enum ClientDetailNoticeTimeType {//"当天","提前1天提醒","提前2天提醒","提前3天提醒","提前7天提醒", "自定义"
    case none
    case today
    case oneDay
    case twoDay
    case threeDay
    case oneWeek
    case custom
    
    func descrption() -> String {
        switch self {
        case .today:
            return "当天"
            
        case .oneDay:
            return "提前1天提醒"
            
        case .twoDay:
            return "提前2天提醒"
            
        case .threeDay:
            return "提前3天提醒"
            
        case .oneWeek:
            return "提前7天提醒"
            
        case .custom:
            return "自定义"
        default:
            return ""
        }
    }
}

enum ClientListType {
    case normal
    case notice
}

enum ClientItemStyle {
    case all
    case birthday
    case memorial
    case baodan
    case other
    
    static func initWithDescription(des: String) -> ClientItemStyle {
        switch des {
        case "保单":
            return .baodan
        case "生日":
            return .birthday
        case "纪念日":
            return .memorial
        case "其他":
            return .other
        default:
            return .all
        }
    }
    
    func description() -> String {
        switch self {
        case .baodan:
            return "保单"
        case .birthday:
            return "生日"
        case .memorial:
            return "纪念日"
        case .other:
            return "其他"
        default:
            return ""
        }
    }
    
    func descriptionForID() -> String {
        switch self {
        case .baodan:
            return "3"
        case .birthday:
            return "1"
        case .memorial:
            return "2"
        case .other:
            return "4"
        default:
            return "0"
        }
    }
    
}
