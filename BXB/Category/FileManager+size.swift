//
//  FileManager+size.swift
//  BXB
//
//  Created by 尹平江 on 2018/6/1.
//  Copyright © 2018年 tobosoft. All rights reserved.
//

import Foundation

extension FileManager {
    
    public func sizeOfFolderAtPath(path: String) -> UInt64 {
        
        let pathStr = path as NSString
        
        var size: UInt64 = 0
        
        do {
            let files: NSArray = try self.subpathsOfDirectory(atPath: path as String) as NSArray
            
            let enumerator = files.objectEnumerator()
            
            if let fn = enumerator.nextObject() as? String {
                
                do {
                    let dic = try self.attributesOfItem(atPath: pathStr.appendingPathComponent(fn)) as NSDictionary
                    size += dic.fileSize()
                    
                }catch{print("FileManager get dic error = \(error)")}
                
            }
            
        } catch {print("FileManager get size error = \(error)")}
        
        return size
    }
    
}
