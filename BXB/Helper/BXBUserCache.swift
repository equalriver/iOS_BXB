//
//  BXBUserCache.swift
//  BXB
//
//  Created by 尹平江 on 2018/6/1.
//  Copyright © 2018年 tobosoft. All rights reserved.
//

import UIKit


class BXBUserCache: NSObject {

    public class func cacheCostString() -> String {
        
        let totalCost = YYWebImageManager.shared().cache?.diskCache.totalCost()
        
        let path = BXBUserCache.URLForDocumentDirectory()?.path ?? ""
        
        let pathSize = FileManager.default.sizeOfFolderAtPath(path: path)
        
        if let total = totalCost {
            
            let totalSize = UInt64(total) + pathSize
            
            let costInMB = totalSize / UInt64(1024.0) / UInt64(1024.0)
            
            if costInMB <= 50 {return String.init(format: "%.1f MB", costInMB)}
            
            return "大于 50 MB"
        }
        return ""
    }
    
    public class func clearCacheWithCompletion(completion: (() -> Void)?) {
        
        SVProgressHUD.showProgress(-1, status: "正在清理...")
        
        let cache = YYWebImageManager.shared().cache?.diskCache
        
        do {
            try FileManager.default.removeItem(at: BXBUserCache.URLForDocumentDirectory() ?? URL.init(fileURLWithPath: "com.tobosoft.bxb.document"))
        } catch {
            print("clear cache error: \(error)")
        }
        
        cache?.removeAllObjects {
            
            if completion != nil {
                completion!()
                SVProgressHUD.showInfo(withStatus: "清理完毕")
            }
            else{
                SVProgressHUD.showInfo(withStatus: "清理失败")
            }
            
        }
    }

    private class func URLForDocumentDirectory() -> URL? {
        
        let url = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first
        
        return url?.appendingPathComponent("com.tobosoft.bxb.document", isDirectory: true)
    }
    
}
