//
//  BXBNetworkTool.swift
//  BXB
//
//  Created by equalriver on 2018/6/12.
//  Copyright © 2018年 tobosoft. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import CoreTelephony

typealias responseCallback = (_ response : JSON) -> Void
typealias errorCallback = (_ error : Error) -> Void

class BXBNetworkTool: SessionManager {
    
    public static var isShowSVProgressHUD = false
    
    public static let shared: SessionManager = {
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = 15
        config.timeoutIntervalForResource = 15
//        config.httpAdditionalHeaders = ["content-Type": "application/json"]
        
        let manager = Alamofire.SessionManager(configuration: config)
        return manager
        
    }()
    
    
    public class func BXBRequest(router: Router, success: @escaping responseCallback, failure: @escaping errorCallback) {
        
        DispatchQueue.global().async {
            //check login
            if UserDefaults.standard.string(forKey: "token") == nil {
                switch router {
                case .register, .getAuthCode, .addClientNotice, .addClientMaintain, .commitMeWorkLog:
                    break
                    
                default:
                    return
                }
            }
            
            //检查网络状态
            if UserDefaults.standard.string(forKey: "isFirstLogin") != nil {
                
                DispatchQueue.once(token: "bxb_checkNetwork", block: {
                    checkNetwork { (isOpen) in
                        if isOpen == false { isShowSVProgressHUD = false }
                    }
                })
                
            }
            
//            if isShowSVProgressHUD {
//                DispatchQueue.main.async {
//                    SVProgressHUD.show()
//                }
//            }
            
            BXBNetworkTool.shared.request(router).validate().responseJSON { (resp) in
                
                //第一次登录不提示网络权限
                DispatchQueue.once(token: "isFirstLogin", block: {
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 30, execute: {
                        UserDefaults.standard.set("isFirstLogin", forKey: "isFirstLogin")
                    })
                })
                
                switch resp.result{
                    
                case .success(let value):
                    
                    let json = JSON(value)
                    
                    DispatchQueue.main.async {
                        
                        if isShowSVProgressHUD { SVProgressHUD.dismiss() }
                        
                        if json["responseNum"].stringValue == "000000" {
                            success(json)
                        }
                        else {
                            failure(BXBError.networkError(message: json["responseMsg"].stringValue))
                            SVProgressHUD.showInfo(withStatus: json["responseMsg"].stringValue)
                            print(json["responseMsg"].stringValue)
                        }
                        
                        isShowSVProgressHUD = true
                    }
                    
                case .failure(let error):
                    
                    DispatchQueue.main.async {
                        
                        if isShowSVProgressHUD { SVProgressHUD.dismiss() }
                        
                        if error.localizedDescription == "似乎已断开与互联网的连接。" {
                            
                            switch router {
                            case .monthReport(), .dayReport(), .userDetail():
                                break
                                
                            default:
                                DispatchQueue.main.async {
                                    SVProgressHUD.showInfo(withStatus: "咦～竟然没有检测到网络")
                                }
                            }
                            
                        }
//                        else  if error.localizedDescription.contains("5") || error.localizedDescription.contains("4") {
//                            SVProgressHUD.showInfo(withStatus: "咦～竟然失败了")
//                        }
                        else {
                            SVProgressHUD.showInfo(withStatus: "咦～竟然失败了")
                        }
                        
                        /*
                         BXBNetworkTool.BXBRequest(router: .loginOut(), success: { (resp) in
                         
                         UserDefaults.standard.set(nil, forKey: "token")
                         UserDefaults.standard.synchronize()
                         do{
                         try FileManager.default.removeItem(atPath: kClientDataFilePath)
                         }catch{ print("remove local client data fail: \(error)") }
                         
                         NotificationCenter.default.post(name: NSNotification.Name.init(kNotiAgendaShouldRefreshData), object: nil, userInfo: ["loginOut": true])
                         NotificationCenter.default.post(name: NSNotification.Name.init(kNotiClientShouldRefreshData), object: nil, userInfo: ["loginOut": true])
                         NotificationCenter.default.post(name: NSNotification.Name.init(kNotiRemindShouldRefreshData), object: nil, userInfo: ["loginOut": true])
                         NotificationCenter.default.post(name: NSNotification.Name.init(kNotiUserShouldRefreshData), object: nil, userInfo: ["loginOut": true])
                         self.navigationController?.popViewController(animated: true)
                         
                         }, failure: { (error) in
                         
                         })
                         */
                        print(error.localizedDescription)
                        failure(error)
                        isShowSVProgressHUD = true
                    }
   
                }
            }
        }
        
        
    }
    
    //上传图片
    public class func upLoadImageRequest(images: [UIImage], imageName: String, params: [String : String], router: Router, success : @escaping responseCallback, failure : @escaping errorCallback) {

        BXBNetworkTool.shared.upload(multipartFormData: { (multipartFormData) in
            for (index, img) in images.enumerated() {
                if let imgData = img.compressImage(maxLength: 2048 * 1024){
                    let formatter = DateFormatter()
                    formatter.dateFormat = "yyyyMMddHHmmss"
                    let str = formatter.string(from: Date())
                    let fileName = str + "logo" + "\(index)" + ".jpg"
                    // 以文件流格式上传
                    // 批量上传与单张上传，后台语言为java或.net等
                    multipartFormData.append(imgData, withName: imageName, fileName: fileName, mimeType: "image/jpeg")
                    guard let d = fileName.data(using: String.Encoding.utf8) else { break }
                    multipartFormData.append(d, withName: "logoName")
                    //                    // 单张上传，后台语言为PHP
                    //                    multipartFormData.append(imageData!, withName: "fileupload", fileName: fileName, mimeType: "image/jpeg")
                    //                    // 批量上传，后台语言为PHP。 注意：此处服务器需要知道，前台传入的是一个图片数组
                    //                    multipartFormData.append(imageData!, withName: "fileupload[\(index)]", fileName: fileName, mimeType: "image/jpeg")
                }
            }
            for (key ,value) in params {
                guard let d = value.data(using: String.Encoding.utf8) else { break }
                multipartFormData.append(d, withName: key)
            }
            
        }, with: router
           ) { (encodingResult) in
            switch encodingResult {
            case .success(let request,  _,  _):
                request.responseJSON(completionHandler: { (resp) in
                    if resp.result.isSuccess {
                        guard resp.value != nil else { return }
                        let json = JSON(resp.value!)
                        success(json)
                    }
                    else {
                        failure(resp.result.error ?? BXBError.networkError(message: nil))
                    }
                })
                
            case .failure(let error):
                print(error.localizedDescription)
                failure(error)
                
            }
        }
        
    }
    
    
    //上传文件
    public class func upLoadFileRequest(fileName: String, data: Data, filePath: String, router: Router, success : @escaping responseCallback, failure : @escaping errorCallback) {
        
        BXBNetworkTool.shared.upload(multipartFormData: { (multipartFormData) in
            
            multipartFormData.append(data, withName: "file", fileName: fileName, mimeType: "txt")
            
            
        }, with: router
        ) { (encodingResult) in
            switch encodingResult {
            case .success(_,  _,  _):
                //删除文件
                do {
                    try FileManager.default.removeItem(atPath: filePath)
                }
                catch { print(error.localizedDescription) }
                
                
            case .failure(let error):
                print(error.localizedDescription)
                failure(error)
                
            }
        }
        
    }
    
    
    ///检查wifi或wwan是否打开
    private class func checkNetwork(handle: @escaping (_ isOpen: Bool) -> Void) {
    
        let reach = YYReachability.init()
        
        let cellularData = CTCellularData.init()
        cellularData.cellularDataRestrictionDidUpdateNotifier = { (state) in
            
            switch state {
            case .notRestricted://蜂窝移动网和WLAN
                handle(true)
                break
                
            case .restrictedStateUnknown://未知
                handle(true)
                break
                
            case .restricted://关闭 或 WLAN
                
                if reach.status == .wiFi {
                    handle(true)
                    break
                }
                DispatchQueue.once(token: "bj_checkNetwork", block: {
                    let alert = UIAlertController.init(title: nil, message: "无法访问网络，未打开无线数据访问权限，是否现在打开?", preferredStyle: .alert)
                    let action = UIAlertAction.init(title: "是", style: .default, handler: { (ac) in
                        
                        DispatchQueue.main.async {
                            if let url = URL.init(string: UIApplication.openSettingsURLString) {
                                if UIApplication.shared.canOpenURL(url) {
                                    UIApplication.shared.openURL(url)
                                }
                            }
                        }
                        
                    })
                    let cancel = UIAlertAction.init(title: "否", style: .cancel, handler: nil)
                    alert.addAction(action)
                    alert.addAction(cancel)
                    DispatchQueue.main.async {
                        if let vc = currentViewController() {
                            vc.present(alert, animated: true, completion: nil)
                        }
                    }
                })
                
                handle(false)
                break
            }
            
        }
    
    }
    

}















