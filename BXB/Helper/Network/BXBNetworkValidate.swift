//
//  BXBNewworkValidate.swift
//  BXB
//
//  Created by equalriver on 2018/6/11.
//  Copyright © 2018年 tobosoft. All rights reserved.
//

import Alamofire
import SwiftyJSON

//验证
extension DataRequest {
    var acceptableStatusCodes: [Int] { return Array(200..<300) }
    
    func validateInternal(data: Data?) -> ValidationResult {
        
        guard let data = data, data.count > 0 else { return .success }
        
        do {
            _ = try JSON(data: data)
            return .success
//            if json["responseNum"].stringValue == "000000" {
//                return .success
//            }
//            else {
//                return .failure(BXBError.networkError(message: json["responseMsg"].stringValue))
//            }
            
        }catch{ return .failure(BXBError.networkError(message: "咦～竟然失败了")) }
        
    }
    
    @discardableResult
    public func validateInternal() -> Self {
        return validate { [unowned self] _, response, data in
            return self.validateInternal(data: data)
        }
    }
    
    @discardableResult
    public func validate() -> Self {
        return validate(statusCode: self.acceptableStatusCodes).validateInternal()
    }
    
}

//error
enum BXBError: Error {
    case networkError(message: String?)
}

extension BXBError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .networkError(let message):
            return message ?? "网络出错了，请稍后再试"
        }
    }
}
