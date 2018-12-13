
//
//  ToolMacro.swift
//  BXB
//
//  Created by 尹平江 on 2018/6/1.
//  Copyright © 2018年 tobosoft. All rights reserved.
//

import Foundation

public let kNavigationBarAndStatusHeight: CGFloat = UIScreen.main.bounds.size.height >= 812 ? 88 : 64

public let isIphoneXLatter = UIScreen.main.bounds.size.height >= 812 ? true : false

public let kIphoneXBottomInsetHeight: CGFloat = UIScreen.main.bounds.size.height >= 812 ? 20 : 0

public let kScreenWidth = UIScreen.main.bounds.size.width

public let kScreenHeight = UIScreen.main.bounds.size.height

public let KScreenRatio_6 = UIScreen.main.bounds.size.width/375.0

public let KScreenRatio_containX = UIScreen.main.bounds.size.height >= 812 ? 1.1 : UIScreen.main.bounds.size.width/375.0

public let kTabBarHeight: CGFloat = UIScreen.main.bounds.height >= 812 ? 83 : 49


///备注字数
public let kRemarkTextLimitCount_1 = 36

///备注字数
public let kRemarkTextLimitCount_2 = 40

///姓名字数
public let kNameTextLimitCount = 8

///备注地址字数
public let kRemarkAddressTextLimitCount = 20

///提醒主题字数
public let kNoticeThemeTextLimitCount = 8

///签单件数字数
public let kSignCountTextLimitCount = 3

///总保费字数
public let kBaofeiTextLimitCount = 9

///客户标签字数
public let kClientLabelTextLimitCount = 8

///花费事项字数
public let kCostMatterTextLimitCount = 12

///花费金额字数
public let kCostMoneyLimitCount = 6

///团队名称字数
public let kTeamNameTextLimitCount = 10


///agenda edit button width
public let kAngendaEditButtonWidth = 82 * KScreenRatio_6

///agenda row height
public let agendaRowCommonHeight = 60 * KScreenRatio_6

public let navigationBarButtonHeight = 30 * KScreenRatio_6

public let navigationBarButtonWidth = 30 * KScreenRatio_6

public let speechContentHeight = 260 * KScreenRatio_6

public let webFitStr = String(format: "<meta name='viewport' content='width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=0'><meta name='apple-mobile-web-app-capable' content='yes'><meta name='apple-mobile-web-app-status-bar-style' content='black'><meta name='format-detection' content='telephone=no'><style type='text/css'>img{width:%fpx;margin:0 auto;display:block;}</style><style type='text/css'>video{width:%fpx;margin:0 auto;display:block}</style><style type='text/css'>*{padding:0;margin:0;}</style><style type='text/css'>p{padding:8;margin:0;}</style>", kScreenWidth - 20 * KScreenRatio_6, kScreenWidth - 20 * KScreenRatio_6, kScreenWidth - 20 * KScreenRatio_6)



