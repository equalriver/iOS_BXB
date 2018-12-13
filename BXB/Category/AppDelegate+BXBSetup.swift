//
//  AppDelegate+BXBSetup.swift
//  BXB
//
//  Created by 尹平江 on 2018/5/31.
//  Copyright © 2018年 tobosoft. All rights reserved.
//

import Foundation
import Toast_Swift
import IQKeyboardManagerSwift

extension AppDelegate {
    
    public class func bxbSetup() {
        setupAppearance()
        localizeNotification()
        setupAMap()
        setupShareSDK()
        
        //keyboard
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.shouldResignOnTouchOutside = true

    }
    
    class func setupAppearance() {
        
        UILabel.appearance().backgroundColor = .white
        UITextField.appearance().tintColor = kColor_subText
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.font: UIFont.systemFont(ofSize: 11 * KScreenRatio_6),
                                                          NSAttributedString.Key.foregroundColor: kColor_theme!], for: UIControl.State.selected)
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.font: UIFont.systemFont(ofSize: 11 * KScreenRatio_6),
                                                          NSAttributedString.Key.foregroundColor: kColor_subText!], for: UIControl.State.normal)
        
        
        ToastManager.shared.position = .center
        
        //svprogress
//        var imgs = Array<UIImage>()
//        for v in 1...30 {
//            if let img = UIImage.init(named: "图层\(v)") {
//                imgs.append(img)
//            }
//        }
//        if let animatedImg = UIImage.animatedImage(with: imgs, duration: 1){
//            SVProgressHUD.setInfoImage(animatedImg)
//        }
//        SVProgressHUD.setImageViewSize(CGSize.init(width: 44, height: 44))
        SVProgressHUD.setMaximumDismissTimeInterval(3)
        SVProgressHUD.setMinimumDismissTimeInterval(1.5)
        
    }
    
    class func localizeNotification() {
        let setting = UIUserNotificationSettings.init(types: [UIUserNotificationType.alert, UIUserNotificationType.sound, UIUserNotificationType.badge], categories: nil)
        UIApplication.shared.registerUserNotificationSettings(setting)
    }
    
    class func setupAMap() {
        AMapServices.shared().apiKey = kAMapKey
        
    }
    
    class func setupShareSDK() {
        
        ShareSDK.registPlatforms { (SSDKRegister) in
            if SSDKRegister != nil {
                if ShareSDK.isClientInstalled(.typeWechat) {
                   
                    SSDKRegister!.setupWeChat(withAppId: kWeichatAppId, appSecret: KWeichatAppSecret)
                    
                }
            }
        }

    }
    
    /*public class func bxbSetup() {
        /*
         @convention
         1. 修饰 Swift 中的函数类型，调用 C 的函数时候，可以传入修饰过 @convention(c) 的函数类型，匹配 C 函数参数中的函数指针。
         2. 修饰 Swift 中的函数类型，调用 Objective-C 的方法时候，可以传入修饰过 @convention(block) 的函数类型，匹配 Objective-C 方法参数中的 block 参数
         */
        let block: @convention(block) (AnyObject?) -> Void = {
            info in
            let aspectInfo = info as! AspectInfo
            
            let control = aspectInfo.instance()
            //需要判断类
            if (control as? AppDelegate) != nil {
                UIView.appearance().backgroundColor = .white
                UILabel.appearance().backgroundColor = .white
                UIButton.appearance().backgroundColor = .white
                
            }
        }
        //block转AnyObject
        let blobj: AnyObject = unsafeBitCast(block, to: AnyObject.self)
        do {
            let originalSelector = NSSelectorFromString("application")
            
            try AppDelegate.aspect_hook(originalSelector, with: AspectOptions(rawValue: 0), usingBlock: blobj)
            
        } catch  {
            print("error = \(error)")
        }
    }*/
    
}
