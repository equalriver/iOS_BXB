//
//  BXBWorkLogPickerView.swift
//  BXB
//
//  Created by equalriver on 2018/8/8.
//  Copyright © 2018年 tobosoft. All rights reserved.
//

import UIKit

class BXBWorkLogPickerView: UIView {

    
    var months = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12"]
    
    var days = Array<Array<String>>()
    
    typealias callback = (_ month: String, _ day: String) -> Void
    
    var handle: callback
    var isOnlyMonth = false
    
    var month = "1"
    var day = "1"
    
    lazy var formatter: DateFormatter = {
        let f = DateFormatter()
        f.dateFormat = "yyyy-MM"
        return f
    }()
    
    lazy var contentView: UIView = {
        let v = UIView.init(frame: CGRect.init(x: 0, y: kScreenHeight, width: kScreenWidth, height: 250 * KScreenRatio_6))
        v.backgroundColor = UIColor.white
        let tap = UITapGestureRecognizer.init(actionBlock: { (ac) in
            
        })
        v.addGestureRecognizer(tap)
        return v
    }()
    
    lazy var datePick: UIPickerView = {
        let p = UIPickerView.init()
        p.backgroundColor = UIColor.white
        p.dataSource = self
        p.delegate = self
        return p
    }()
    
    lazy var monthLabel: UILabel = {
        let l = UILabel()
        l.font = UIFont.systemFont(ofSize: 18 * KScreenRatio_6)
        l.textColor = kColor_text
        l.text = "月"
        return l
    }()
    
    lazy var dayLabel: UILabel = {
        let l = UILabel()
        l.font = UIFont.systemFont(ofSize: 18 * KScreenRatio_6)
        l.textColor = kColor_text
        l.text = "日"
        return l
    }()

    lazy var cancelBtn: UIButton = {
        let b = UIButton()
        b.setTitle("取消", for: .normal)
        b.setTitleColor(kColor_theme, for: .normal)
        b.addTarget(self, action: #selector(cancelAction(sender:)), for: .touchUpInside)
        return b
    }()
    
    lazy var confirmBtn: UIButton = {
        let b = UIButton()
        b.setTitle("确定", for: .normal)
        b.setTitleColor(kColor_theme, for: .normal)
        b.addTarget(self, action: #selector(confirmAction(sender:)), for: .touchUpInside)
        return b
    }()
    
    init(frame: CGRect, isOnlyMonth: Bool, handle: @escaping callback)  {
        
        self.handle = handle
        super.init(frame: frame)
        self.backgroundColor = UIColor.init(white: 0.3, alpha: 0.5)
        days = getDaysWithMonth()
        self.isOnlyMonth = isOnlyMonth
        
        addSubview(contentView)
        contentView.addSubview(datePick)
        datePick.addSubview(monthLabel)
        datePick.addSubview(dayLabel)
        contentView.addSubview(cancelBtn)
        contentView.addSubview(confirmBtn)
        cancelBtn.snp.makeConstraints { (make) in
            make.size.equalTo(CGSize.init(width: 60 * KScreenRatio_6, height: 30 * KScreenRatio_6))
            make.top.left.equalTo(contentView)
        }
        confirmBtn.snp.makeConstraints { (make) in
            make.size.equalTo(CGSize.init(width: 60 * KScreenRatio_6, height: 30 * KScreenRatio_6))
            make.right.top.equalTo(contentView)
        }
        datePick.snp.makeConstraints { (make) in
            make.size.equalTo(CGSize.init(width: kScreenWidth * 0.4, height: contentView.height / 2))
            make.center.equalTo(contentView)
        }
        if isOnlyMonth {
            monthLabel.snp.makeConstraints { (make) in
                make.centerY.equalTo(datePick)
                make.left.equalTo(datePick).offset(kScreenWidth * 0.4 * 0.7)
            }
        }
        else {
            monthLabel.snp.makeConstraints { (make) in
                make.centerY.equalTo(datePick)
                make.left.equalTo(datePick).offset(kScreenWidth * 0.4 * 0.5 * 0.7)
            }
            dayLabel.snp.makeConstraints { (make) in
                make.centerY.equalTo(datePick)
                make.left.equalTo(datePick).offset(kScreenWidth * 0.4 * 0.85)
            }
        }
        
        let tap = UITapGestureRecognizer.init { (ac) in
            self.removeFromSuperview()
        }
        self.addGestureRecognizer(tap)
        
        contentView.viewAnimateComeFromBottom(duration: 0.3) { (isFinished) in
            
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //action
    @objc func cancelAction(sender: UIButton){
        contentView.viewAnimateDismissFromBottom(duration: 0.3) { (isFinished) in
            if isFinished { self.removeFromSuperview() }
        }
    }
    
    @objc func confirmAction(sender: UIButton){
        handle(month, day)
        contentView.viewAnimateDismissFromBottom(duration: 0.3) { (isFinished) in
            if isFinished { self.removeFromSuperview() }
        }
    }
    
    func getDaysWithMonth() -> Array<Array<String>> {
        
        var arr = Array<Array<String>>()
        
        DispatchQueue.global().sync {
            
            let y = self.formatter.string(from: Date()).components(separatedBy: "-")
            guard y.first != nil else { return }
            for v in self.months {
                let m = getSumOfDaysInMonth(year: y.first!, month: v)
                var days = Array<String>()
                
                for i in 1...m {
                    days.append("\(i)")
                }
                arr.append(days)
            }
        }
        return arr
    }
    
    
}



extension BXBWorkLogPickerView: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return isOnlyMonth ? 1 : 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if isOnlyMonth {
            return months.count
        }
        guard let m: Int = months.index(of: month) else { return 0 }
        return component == 0 ? months.count : days[m].count
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        
        let l = UILabel()
        l.font = UIFont.systemFont(ofSize: 20 * KScreenRatio_6)
        l.textColor = kColor_text
        l.textAlignment = .center
        
        var m: Int = 0
        
        if component == 0 {
            m = months.index(of: months[row])!
        }
        if isOnlyMonth {
            l.text = months[row]
        }
        else {
            l.text = component == 0 ? months[row] : days[m][row]
        }
        
        return l
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if isOnlyMonth {
            month = months[row]
        }
        else {
            if component == 0 {
                month = months[row]
                pickerView.reloadComponent(1)
            }
            else {
                guard let m: Int = months.index(of: month) else { return }
                day = days[m][row]
            }
        }
        
    }
    
}








