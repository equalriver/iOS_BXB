//
//  AppDelegate.swift
//  BXB
//
//  Created by 尹平江 on 2018/5/31.
//  Copyright © 2018年 tobosoft. All rights reserved.
//

import UIKit
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        window = UIWindow.init(frame: UIScreen.main.bounds)
        window?.rootViewController = BXBTabBarController()
        window?.makeKeyAndVisible()
        
//        if let launchView = LaunchIntroductionView.shared(withImages: ["launch_日程规划", "launch_客户管理", "launch_提醒", "launch_团队"], buttonImage: "", buttonFrame: .zero){
//            launchView.nomalColor = kColor_background
//        }
        
        //引导页
        if isAPPFirstLauch() == true {
            BXBNetworkTool.isShowSVProgressHUD = false
            let intro = BXBIntroView.init(frame: CGRect.init(x: 0, y: 0, width: kScreenWidth, height: kScreenHeight))
            window?.addSubview(intro)
        }
       
        //保存crash日志到本地
        NSSetUncaughtExceptionHandler { (exc) in
            saveCrashLog(exception: exc)
        }
        uploadCrashLogFile()
        
        
        if launchOptions != nil {//通过推送点击启动
            if let info = launchOptions![.remoteNotification] as? [AnyHashable : Any] {
                handleAPNs(info: info)
            }
        }
        
        
        AppDelegate.bxbSetup()
        WXApi.registerApp(kWeichatAppId)
        setupJPush(info: launchOptions)
        return true
    }

    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        //清除角标
        UIApplication.shared.applicationIconBadgeNumber = 0
        
        gotoJoinTeam(url: url)
        
        WXApi.handleOpen(url, delegate: self)
        
        return true
    }
    
    //跳转加入团队页面
    func gotoJoinTeam(url: URL) {
        
        guard window != nil, window!.rootViewController != nil else { return }
        guard (window?.rootViewController?.children.count)! > 0 else { return }
        
        if url.absoluteString.contains(localShareURL) && url.absoluteString.contains("teamId") {
            if let teamId = url.absoluteString.components(separatedBy: "teamId=").last{
                let navi = window?.rootViewController?.children.first
                if navi!.isKind(of: BXBNavigationController.self){
                    let vc = BXBUserJoinTeamVC()
                    vc.teamId = Int(teamId)!
                    let naviVC = navi as! BXBNavigationController
                    naviVC.pushViewController(vc, animated: true)
                }
            }
        }
    }
    
    //通用链接跳转
    /*
    func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([Any]?) -> Void) -> Bool {
        
        if userActivity.activityType == NSUserActivityTypeBrowsingWeb  {
            
            if let url = userActivity.webpageURL {
                
                
            }
            
        }
        return true
    }
    */
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
        
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
//        UserDefaults.standard.set(nil, forKey: "token")
        print("app terminate")
    }


}

