//
//  StringTools.swift
//  BXB
//
//  Created by equalriver on 2018/6/11.
//  Copyright © 2018年 tobosoft. All rights reserved.
//

import Foundation

extension String {
    
    ///获取string高度
    public func getStringHeight(font: UIFont, width: CGFloat) -> CGFloat {
        let statusLabelText: NSString = self as NSString
        let size = CGSize.init(width: width, height: 900)
        let dic = NSDictionary(object: font, forKey: NSAttributedString.Key.font as NSCopying)
        let strSize = statusLabelText.boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: dic as? [NSAttributedString.Key : AnyObject], context: nil).size
        return strSize.height
    }

    ///获取string宽度
    public func getStringWidth(font: UIFont, height: CGFloat) -> CGFloat {
        let statusLabelText: NSString = self as NSString
        let size = CGSize.init(width: 900, height: height)
        let dic = NSDictionary(object: font, forKey: NSAttributedString.Key.font as NSCopying)
        let strSize = statusLabelText.boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: dic as? [NSAttributedString.Key : AnyObject], context: nil).size
        return strSize.width
    }
    
    ///获取string  size
    public func getStringSize(font: UIFont, height: CGFloat) -> CGSize {
        let statusLabelText: NSString = self as NSString
        let size = CGSize.init(width: 900, height: height)
        let dic = NSDictionary(object: font, forKey: NSAttributedString.Key.font as NSCopying)
        let strSize = statusLabelText.boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: dic as? [NSAttributedString.Key : AnyObject], context: nil).size
        return strSize
    }

    ///汉字转拼音(耗性能，谨慎使用)
    func transformToPinYin() -> String {
        let mutableString = NSMutableString(string: self)
        //先转换为带声调的拼音
        CFStringTransform(mutableString, nil, kCFStringTransformToLatin, false)
        //再转换为不带声调的拼音
        CFStringTransform(mutableString, nil, kCFStringTransformStripDiacritics, false)
        //返回小写拼音
        let string = String(mutableString).lowercased()
        return string.replacingOccurrences(of: " ", with: "")
    }
    
    ///json转字典
    func getDictionaryFromJSONString() -> Dictionary<String, Any> {
        
        let jsonData: Data = self.data(using: .utf8)!
        
        let dict = try? JSONSerialization.jsonObject(with: jsonData, options: .mutableContainers)
        if dict != nil {
            return dict as! Dictionary
        }
        return Dictionary()
        
    }

    ///MD5
    var MD5: String! {
        let str = self.cString(using: String.Encoding.utf8)
        let strLen = CC_LONG(self.lengthOfBytes(using: String.Encoding.utf8))
        let digestLen = Int(CC_MD5_DIGEST_LENGTH)
        let result = UnsafeMutablePointer<CUnsignedChar>.allocate(capacity: digestLen)
        
        CC_MD5(str!, strLen, result)
        
        let hash = NSMutableString()
        for i in 0..<digestLen {
            hash.appendFormat("%02x", result[i])
        }
        
        result.deallocate()
        
        return hash as String
    }
    
    
    ///url to utf-8
    var URL_UTF8_string: String! {
        return self.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) ?? ""
    }
    
}

extension String {
    
    /// 判断字符串中是否有中文
    var isIncludeChinese: Bool {
        for ch in self.unicodeScalars {
            if (0x4e00 < ch.value  && ch.value < 0x9fff) { return true } // 中文字符范围：0x4e00 ~ 0x9fff
        }
        return false
    }
    
    ///是否全中文
    var isAllChinese: Bool {
        let pattern = "(^[\\u4e00-\\u9fa5]+$)"
        let pred = NSPredicate.init(format: "SELF MATCHES %@", pattern)
        return pred.evaluate(with: self)
    }
    
    ///判断字符串中是否为全数字
    var isAllNumber: Bool {
        let pattern = "[0-9]*"
        let pred = NSPredicate.init(format: "SELF MATCHES %@", pattern)
        return pred.evaluate(with: self)
    }
    
    ///判断字符中是否包含表情
    var isIncludeEmoji: Bool {
        
        for scalar in unicodeScalars {
            switch scalar.value {
            case 0x1F600...0x1F64F, // Emoticons
            0x1F300...0x1F5FF, // Misc Symbols and Pictographs
            0x1F680...0x1F6FF, // Transport and Map
            0x2600...0x26FF,   // Misc symbols
            0x2700...0x27BF,   // Dingbats
            0xFE00...0xFE0F,   // Variation Selectors
            0x1F900...0x1F9FF:  // Supplemental Symbols and Pictographs
                return true
            default:
                continue
            }
        }
        return false
    }
    
    ///匹配手机号
    var isPhoneNumber: Bool {
        let pattern = "^1+[0-9]+\\d{9}"
        let pred = NSPredicate.init(format: "SELF MATCHES %@", pattern)
        return pred.evaluate(with: self)
    }

    ///匹配用户密码6-18位数字和字母组合
    var isPassword: Bool {
        let pattern = "^(?![0-9]+$)(?![a-zA-Z]+$)[a-zA-Z0-9]{6,18}"
        let pred = NSPredicate.init(format: "SELF MATCHES %@", pattern)
        return pred.evaluate(with: self)
    }
    
    ///匹配用户姓名,20位的中文或英文
    var isUserName: Bool {
        let pattern = "^[a-zA-Z\\u4E00-\\u9FA5]{1,20}"
        let pred = NSPredicate.init(format: "SELF MATCHES %@", pattern)
        return pred.evaluate(with: self)
    }
    
    ///匹配用户身份证号15或18位
    var isUserIdCard: Bool {
        let pattern = "(^[0-9]{15}$)|([0-9]{17}([0-9]|X)$)"
        let pred = NSPredicate.init(format: "SELF MATCHES %@", pattern)
        return pred.evaluate(with: self)
    }
    
    ///匹配URL
    var isURLString: Bool {
        let pattern = "^[0-9A-Za-z]{1,50}"
        let pred = NSPredicate.init(format: "SELF MATCHES %@", pattern)
        return pred.evaluate(with: self)
    }


}

