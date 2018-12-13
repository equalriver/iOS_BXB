//
//  AppDelegate+BXBRemoteNoti.swift
//  BXB
//
//  Created by equalriver on 2018/10/23.
//  Copyright © 2018年 tobosoft. All rights reserved.
//

import Foundation
import UserNotifications
import AdSupport


extension AppDelegate: JPUSHRegisterDelegate {
    
    func setupJPush(info: [UIApplication.LaunchOptionsKey: Any]?) {
        
        //初始化 APNs
        let entity = JPUSHRegisterEntity.init()
        entity.types = Int(JPAuthorizationOptions.alert.rawValue) | Int(JPAuthorizationOptions.badge.rawValue) | Int(JPAuthorizationOptions.sound.rawValue)
        JPUSHService.register(forRemoteNotificationConfig: entity, delegate: self)
        
        
        //初始化 JPush
        /*
         channel
         指明应用程序包的下载渠道，为方便分渠道统计，具体值由你自行定义，如：App Store。
         apsForProduction
         1.3.1 版本新增，用于标识当前应用所使用的 APNs 证书环境。
         0（默认值）表示采用的是开发证书，1 表示采用生产证书发布应用。
         注：此字段的值要与 Build Settings的Code Signing 配置的证书环境一致。
        */
        var apsForProduction = false
        
        #if DEBUG
        apsForProduction = false
        #else
        apsForProduction = true
        #endif
        
        //获取 IDFA
        let advertisingId = ASIdentifierManager.shared().advertisingIdentifier.uuidString
        
        JPUSHService.setup(withOption: info, appKey: kJPushKey, channel: "App Store", apsForProduction: apsForProduction, advertisingIdentifier: advertisingId)
        
        
        //获取JPush服务器推送
        NotificationCenter.default.addObserver(self, selector: #selector(networkDidReceiveMessage(noti:)), name: NSNotification.Name.jpfNetworkDidReceiveMessage, object: nil)
        
    }
    
    func handleAPNs(info: [AnyHashable : Any]) {
        //取得 APNs 标准信息内容
        if let aps = info["aps"] as? [AnyHashable : Any] {
            //推送显示的内容
            if let content = aps["alert"] as? String {
                if content.contains("") { NotificationCenter.default.post(name: .kNotiUserShouldRefreshData, object: nil) }
            }
            
            
        }
    }
    
    //处理JPush服务器推送
    @objc func networkDidReceiveMessage(noti: Notification) {
        
        guard let info = noti.userInfo else { return }
        print(info)
        
    }
    
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        //注册 APNs 成功并上报 DeviceToken
        JPUSHService.registerDeviceToken(deviceToken)
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]) {
        handleAPNs(info: userInfo)
        JPUSHService.handleRemoteNotification(userInfo)
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        handleAPNs(info: userInfo)
        JPUSHService.handleRemoteNotification(userInfo)
        completionHandler(UIBackgroundFetchResult.newData)
    }
    
    @available(iOS 10.0, *)
    func jpushNotificationCenter(_ center: UNUserNotificationCenter!, willPresent notification: UNNotification!, withCompletionHandler completionHandler: ((Int) -> Void)!) {
        let info = notification.request.content.userInfo
        if let trigger = notification.request.trigger {
            if trigger.isKind(of: UNPushNotificationTrigger.self) {
                JPUSHService.handleRemoteNotification(info)
                handleAPNs(info: info)
            }
        }
        completionHandler(Int(UNNotificationPresentationOptions.alert.rawValue))
    }
    
    @available(iOS 10.0, *)
    func jpushNotificationCenter(_ center: UNUserNotificationCenter!, didReceive response: UNNotificationResponse!, withCompletionHandler completionHandler: (() -> Void)!) {
        let info = response.notification.request.content.userInfo
        if let trigger = response.notification.request.trigger {
            if trigger.isKind(of: UNPushNotificationTrigger.self) {
                JPUSHService.handleRemoteNotification(info)
                handleAPNs(info: info)
            }
        }
        completionHandler()
    }
    
    @available(iOS 10.0, *)
    func jpushNotificationCenter(_ center: UNUserNotificationCenter!, openSettingsFor notification: UNNotification?) {
        
    }
    
    
    
    
}
