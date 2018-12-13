
//
//  OtherTools.swift
//  BXB
//
//  Created by 尹平江 on 2018/6/4.
//  Copyright © 2018年 tobosoft. All rights reserved.
//

import Foundation
import UIKit
import ObjectMapper

//MARK: - 检测网络
///检测网络
public func checkNetwork() -> Bool {
    switch YYReachability.init().status {
    case .none:
        SVProgressHUD.showInfo(withStatus: "咦～竟然没有检测到网络")
        return false
    default:
        return true
    }
}

//MARK: - dispatch_once_t
///dispatch_once_t
public extension DispatchQueue {
    
    private static var _onceTracker = [String]()
    
    public class func once(token: String, block:()->Void) {
        objc_sync_enter(self)
        defer { objc_sync_exit(self) }
        
        if _onceTracker.contains(token) {
            return
        }
        
        _onceTracker.append(token)
        block()
    }
}

//MARK: - 崩溃日志
///崩溃日志上传
public func uploadCrashLogFile() {
    
    let path = NSHomeDirectory() + "/Documents/error.txt"
    guard let token = UserDefaults.standard.string(forKey: "token") else { return }
    do {
        let data = try Data.init(contentsOf: URL.init(fileURLWithPath: path))
        BXBNetworkTool.upLoadFileRequest(fileName: token, data: data, filePath: path, router: .uploadLogFile(), success: { (resp) in
            
        }) { (error) in
            print(error.localizedDescription)
        }
        
    } catch {
        print(error.localizedDescription)
    }
    
}


///保存崩溃日志到本地
public func saveCrashLog(exception: NSException) {
    
    let stackArr = exception.callStackSymbols
    
    let reason = exception.reason
    
    let name = exception.name
    
    let info = "exception name: \(name)  \n" + "reason: \(reason ?? "无")  \n" + "stack: \(stackArr)"
    
    do {
        try info.write(toFile: NSHomeDirectory() + "/Documents/error.txt", atomically: true, encoding: String.Encoding.utf8)
    }
    catch {
        print(error.localizedDescription)
    }

}

//MARK: - 计算生日天数差
///计算生日天数差
public func leftDayWithBirthday(birthday: String) -> String {
    
    if birthday.contains("-") == false { return "" }
    let formatter = DateFormatter.init()
    formatter.dateFormat = "MM-dd"
    
    let formatter_y = DateFormatter.init()
    formatter_y.dateFormat = "yyyy-MM-dd"
    
    //转为不带年份的时间
    guard let date_1 = formatter_y.date(from: birthday) else { return "" }
    let monthDay_1 = formatter.string(from: date_1)
    
    let monthDay_2 = formatter.string(from: Date())
    
    //获取当前年份
    let nowDate = formatter_y.string(from: Date())
    guard let nowYear = nowDate.components(separatedBy: "-").first else { return "" }
    //生日 月和日的整数
    let bir_monthDay = monthDay_1.components(separatedBy: "-")
    var bir_monthDay_str = ""
    for i in bir_monthDay {
        bir_monthDay_str += i
    }
    guard let bir_monthDay_int = Int(bir_monthDay_str) else { return "" }
    //
    let now_monthDay = monthDay_2.components(separatedBy: "-")
    var now_monthDay_str = ""
    for i in now_monthDay {
        now_monthDay_str += i
    }
    guard let now_monthDay_int = Int(now_monthDay_str) else { return "" }
    //生日已过
    guard var nowYear_int = Int(nowYear) else { return "" }
    
    if bir_monthDay_int < now_monthDay_int {
        nowYear_int += 1
    }
    let nowYear_birthdayMonthDay = String(nowYear_int) + "-" + monthDay_1
    
    guard let birMonthDay = formatter_y.date(from: nowYear_birthdayMonthDay) else { return "" }
    
    let ca = NSCalendar.init(calendarIdentifier: .gregorian)
    
    if let comps = ca?.components(.day, from: Date(), to: birMonthDay, options: NSCalendar.Options(rawValue: 0)) {
//        print(comps.day ?? "")
        return String(comps.day ?? -1)
    }
    
    return ""
    
}


//MARK: - 获取某个月的天数
///获取某个月的天数
public func getSumOfDaysInMonth(year: String, month: String) -> Int {
    
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM"
    
    let dateStr = year + "-" + month
    guard let date = formatter.date(from: dateStr) else { return 0 }
    
    let ca = Calendar.init(identifier: .gregorian)
    if let range = ca.range(of: Calendar.Component.day, in: Calendar.Component.month, for: date){
        return range.count
    }
    return 0
    
}

//MARK: - 跳转到app权限设置页面
///跳转到app权限设置页面
public func gotoAuthorizationView(vc: UIViewController) {
    
    let alert = UIAlertController.init(title: nil, message: "app需要获取相关应用权限,点击确定跳转设置页面", preferredStyle: .alert)
    let action = UIAlertAction.init(title: "确定", style: .default) { (ac) in
        if let url = URL.init(string: UIApplication.openSettingsURLString){
            if UIApplication.shared.canOpenURL(url){
                UIApplication.shared.openURL(url)
            }
        }
        else {
            SVProgressHUD.showInfo(withStatus: "跳转设置页面失败")
        }
    }
    let cancel = UIAlertAction.init(title: "取消", style: .cancel, handler: nil)
    alert.addAction(action)
    alert.addAction(cancel)
    vc.present(alert, animated: true, completion: nil)
}

//MARK: - debug string
///debug string
public func debugString(debugStr: String) -> String {
    #if DEBUG
    return debugStr
    #else
    return ""
    #endif
}

//MARK: - 归档客户数据
///归档客户数据
public func archiverUserData(datas: Array<Any>?) {
    
    if datas != nil {
        guard let d = datas! as? [ClientData] else { return }
        let arcData = d.map({ (obj) -> Data in
            NSKeyedArchiver.archivedData(withRootObject: obj)
        })
        let ad = NSKeyedArchiver.archivedData(withRootObject: arcData)
        
        do{
            try ad.write(to: URL.init(fileURLWithPath: kClientDataFilePath))
            
        }catch{ print("clientData保存失败: \(error)") }
    }
    else {
        BXBNetworkTool.BXBRequest(router: .clientFilter(remind: "", isWrite: "", matter: ""), success: { (resp) in
            
            DispatchQueue.global().async {
                
                if let data = Mapper<ClientData>().mapArray(JSONObject: resp["data"].arrayObject){
                    
                    let arcData = data.map({ (obj) -> Data in
                        NSKeyedArchiver.archivedData(withRootObject: obj)
                    })
                    let ad = NSKeyedArchiver.archivedData(withRootObject: arcData)
                    
                    do{
                        try ad.write(to: URL.init(fileURLWithPath: kClientDataFilePath))
                        
                    }catch{ print("clientData保存失败: \(error)") }
                    
                }
            }
            
        }) { (error) in
            
        }
    }
    
}

//MARK: - 获取当前显示的controller
///获取当前显示的controller
public func currentViewController() -> UIViewController? {
    
    var result: UIViewController?
    
    var rootVC = UIApplication.shared.keyWindow?.rootViewController
    
    repeat {
        
        guard rootVC != nil else { return result }
        
        if rootVC!.isKind(of: UINavigationController.self) {
            let navi = rootVC as! UINavigationController
            let vc = navi.viewControllers.last
            result = vc
            rootVC = vc?.presentedViewController
            continue
        }
        else if rootVC!.isKind(of: UITabBarController.self) {
            let tab = rootVC as! UITabBarController
            result = tab
            rootVC = tab.viewControllers?[tab.selectedIndex]
            continue
        }
        else if rootVC!.isKind(of: UIViewController.self) {
            result = rootVC
            rootVC = nil
        }
        
    }while rootVC != nil
    
    return result
}

//MARK: - 判断是不是首次登录或者版本更新
///判断是不是首次登录或者版本更新
public func isAPPFirstLauch() -> Bool {
    //获取当前版本号
    guard let infoDic = Bundle.main.infoDictionary else { return false }
    guard let currentVersion: String = infoDic["CFBundleShortVersionString"] as? String else { return false }
    
    let version = UserDefaults.standard.string(forKey: "bxb_app_version") ?? ""
    
    if version == "" || version != currentVersion {
        UserDefaults.standard.set(currentVersion, forKey: "bxb_app_version")
        UserDefaults.standard.synchronize()
        return true
    }
    
    return false
}

/*
func createQRForString(qrString: String?, qrImageName: String) -> UIImage? {
    if let sureQRString = qrString{
        let stringData = sureQRString.data(using: String.Encoding.utf8, allowLossyConversion: false)
        //创建一个二维码的滤镜
        let qrFilter = CIFilter(name: "CIQRCodeGenerator")
        qrFilter?.setValue(stringData, forKey: "inputMessage")//通过kvo方式给一个字符串，生成二维码
        qrFilter?.setValue("H", forKey: "inputCorrectionLevel")//设置二维码的纠错水平，越高纠错水平越高，可以污损的范围越大
        let qrCIImage = qrFilter?.outputImage//拿到二维码图片
        
        // 创建一个颜色滤镜,黑白色
        let colorFilter = CIFilter(name: "CIFalseColor")!
        colorFilter.setDefaults()
        colorFilter.setValue(qrCIImage, forKey: "inputImage")
        colorFilter.setValue(CIColor(red: 0, green: 0, blue: 0), forKey: "inputColor0")
        colorFilter.setValue(CIColor(red: 1, green: 1, blue: 1), forKey: "inputColor1")
        // 返回二维码image
        let codeImage = UIImage(ciImage: (colorFilter.outputImage!.applying(CGAffineTransform(scaleX: 30, y: 30))))
        
        let context = CIContext(options: nil)
        let ciimg = qrCIImage?.applying(CGAffineTransform(scaleX: 30, y: 30))
        let cgimg = context.createCGImage(ciimg!, from: (ciimg?.extent)!)
        
        // 中间一般放logo
        if let iconImage = UIImage(named: qrImageName) {
            let rect = CGRect(x: 0, y: 0, width: codeImage.size.width, height: codeImage.size.height)
            
            UIGraphicsBeginImageContext(rect.size)
            codeImage.draw(in: rect)
            let avatarSize = CGSize(width: rect.size.width*0.25, height: rect.size.height*0.25)
            
            let x = (rect.width - avatarSize.width) * 0.5
            let y = (rect.height - avatarSize.height) * 0.5
            iconImage.draw(in: CGRect(x: x, y: y, width: avatarSize.width, height: avatarSize.height))
            
            let resultImage = UIGraphicsGetImageFromCurrentImageContext()
            
            UIGraphicsEndImageContext()
            return resultImage
        }
        
        //return codeImage
        return UIImage.init(cgImage: cgimg!)
        
    }
    return nil
}
 */
