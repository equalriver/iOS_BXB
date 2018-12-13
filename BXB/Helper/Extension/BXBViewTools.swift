//
//  ViewTools.swift
//  BXB
//
//  Created by equalriver on 2018/6/11.
//  Copyright © 2018年 tobosoft. All rights reserved.
//

import Foundation

extension UITextField {

    open override func didMoveToSuperview() {
        super.didMoveToSuperview()
//        delegate = self
        self.addBlock(for: .editingChanged) { [weak self](tf) in
            guard self != nil && self!.hasText else { return }
            guard self!.markedTextRange == nil else { return }
            if self!.text!.isIncludeEmoji {
                self?.text = self?.text?.filter({ (c) -> Bool in
                    return String(c).isIncludeEmoji == false
                })
            }
            if self!.text!.contains(" ") || self!.text!.contains("\n") {
                self?.text = self?.text?.filter({ (c) -> Bool in
                    return c != " " && c != "\n"
                })
            }
        }
    }

//    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
//
//        if string.isIncludeEmoji { return false }
//        if string == " " { return false }
//        return true
//    }
    
    
}

extension UIView {
    
    ///从底部弹出
    public func viewAnimateComeFromBottom(duration: TimeInterval, completion: @escaping (_ isFinished: Bool) -> Void ) {
        UIView.animate(withDuration: duration, animations: {
            
            var center = self.center
            center.y -= self.height
            self.center = center
            
        }) { (isFinished) in
            completion(isFinished)
        }
    }
    
    ///从底部消失
    public func viewAnimateDismissFromBottom(duration: TimeInterval, completion: @escaping (_ isFinished: Bool) -> Void ) {
        UIView.animate(withDuration: duration, animations: {
            
            var center = self.center
            center.y += self.height
            self.center = center
            
        }) { (isFinished) in
            completion(isFinished)
        }
    }
    
}
