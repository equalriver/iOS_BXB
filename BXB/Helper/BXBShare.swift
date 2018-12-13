//
//  BXBShare.swift
//  BXB
//
//  Created by equalriver on 2018/7/4.
//  Copyright © 2018年 tobosoft. All rights reserved.
//

import Foundation


struct BXBShare {
    
    public static func shareWithDefaultUI(title: String, text: String, images: UIImage, url: URL?, view: UIView) {
        
        if /*ShareSDK.isClientInstalled(.typeQQ) == false &&*/ ShareSDK.isClientInstalled(.typeWechat) == false {
            SVProgressHUD.showInfo(withStatus: "尚未安装微信")
            return
        }
        
        // 1.创建分享参数
        let shareParames = NSMutableDictionary()
        shareParames.ssdkSetupShareParams(byText: title, images: images, url: url, title: title, type: SSDKContentType.image)

        //2.进行分享
        ShareSDK.showShareActionSheet(nil, customItems: nil, shareParams: shareParames, sheetConfiguration: nil) { (state, platformType, info, entity, error, isSuccess) in
            
            if platformType != .typeWechat || platformType != .subTypeWechatFav || platformType != .subTypeWechatSession || platformType != .subTypeWechatTimeline {
                view.makeToast("目前暂时只能分享到微信")
            }
            switch state{
                
            case SSDKResponseState.success: print("分享成功")
            case SSDKResponseState.fail:    print("授权失败,错误描述:\(error.debugDescription)")
            case SSDKResponseState.cancel:  print("操作取消")
                
            default:
                break
            }
            
        }

    }
    
}
