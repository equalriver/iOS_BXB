//
//  BXBClientFilterView.swift
//  BXB
//
//  Created by equalriver on 2018/8/1.
//  Copyright © 2018年 tobosoft. All rights reserved.
//

import UIKit

protocol ClientFilterViewDelegate: NSObjectProtocol {
    func didSelectedFilterItem(name: String, index: Int)
    func didRemoveView()
}

enum ClientFilterTableViewTag: Int {
    case first = 0
    case second = 1
    case third = 2
}

class BXBClientFilterView: UIView {
    
    weak public var delegate: ClientFilterViewDelegate?
    
    public var selectedIndexPath = IndexPath.init(row: 0, section: 0)
    
    public var index = -1 {
        willSet{
            
            switch newValue {
            case 0:
                firstStateTb.isHidden = false
                self.secondStateTb.isHidden = true
                self.thirdStateTb.isHidden = true
                self.secondStateTb.height = 0
                self.thirdStateTb.height = 0
                
                if self.index == newValue && isSameIndex {
                    
                    isSameIndex = false
                    delegate?.didSelectedFilterItem(name: "", index: 0)
                    thirdStateTb.height = 0
                    secondStateTb.height = 0
                    delegate?.didRemoveView()
                    
                    UIView.animate(withDuration: 0.3, animations: {
                        
                        self.firstStateTb.height = 0
                        
                    }) { (isFinish) in
                        self.removeFromSuperview()
                    }
                    
                }
                else {
                    isSameIndex = true
                    UIView.animate(withDuration: 0.5) {
                        self.firstStateTb.height = CGFloat(self.firstItems.count) * 40 * KScreenRatio_6
                    }
                    
                }
        
                break
                
            case 1:
                secondStateTb.isHidden = false
                self.firstStateTb.isHidden = true
                self.thirdStateTb.isHidden = true
                self.firstStateTb.height = 0
                self.thirdStateTb.height = 0
                
                if self.index == newValue && isSameIndex {
                    
                    isSameIndex = false
                    delegate?.didSelectedFilterItem(name: "", index: 0)
                    thirdStateTb.height = 0
                    firstStateTb.height = 0
                    delegate?.didRemoveView()
                    
                    UIView.animate(withDuration: 0.3, animations: {
                        
                        self.secondStateTb.height = 0
                        
                    }) { (isFinish) in
                        self.removeFromSuperview()
                    }
                    
                }
                else {
                    isSameIndex = true
                    UIView.animate(withDuration: 0.5) {
                        self.secondStateTb.height = CGFloat(self.secondItems.count) * 40 * KScreenRatio_6
                    }
                    
                }
                break
                
            default:
                thirdStateTb.isHidden = false
                self.secondStateTb.isHidden = true
                self.firstStateTb.isHidden = true
                self.secondStateTb.height = 0
                self.firstStateTb.height = 0
                
                if self.index == newValue && isSameIndex {
                    
                    isSameIndex = false
                    delegate?.didSelectedFilterItem(name: "", index: 0)
                    firstStateTb.height = 0
                    secondStateTb.height = 0
                    delegate?.didRemoveView()
                    
                    UIView.animate(withDuration: 0.3, animations: {
                        
                        self.thirdStateTb.height = 0
                        
                    }) { (isFinish) in
                        self.removeFromSuperview()
                    }
                    
                }
                else {
                    isSameIndex = true
                    UIView.animate(withDuration: 0.5) {
                        self.thirdStateTb.height = CGFloat(self.thirdItems.count) * 40 * KScreenRatio_6
                    }
                    
                }
                break
            }
        }
        
        didSet{
            firstStateTb.reloadData()
            secondStateTb.reloadData()
            thirdStateTb.reloadData()
        }
    }
    
    var isSameIndex = false
    
    var firstItems = ["所有客户", "已签单", "未签单", "已设置提醒", "未设置提醒"]
    var secondItems = ["所有状态", "开启面谈", "建议书"]
    var thirdItems = ["所有提醒", "生日", "纪念日", "保单", "其他"]

    lazy var firstStateTb: UITableView = {
        let tb = UITableView.init(frame: CGRect.init(x: 0, y: 0, width: kScreenWidth, height: 0), style: .plain)
        tb.separatorStyle = .none
        tb.isScrollEnabled = false
        tb.dataSource = self
        tb.delegate = self
        tb.backgroundColor = UIColor.white
        tb.tag = ClientFilterTableViewTag.first.rawValue
        return tb
    }()
    lazy var secondStateTb: UITableView = {
        let tb = UITableView.init(frame: CGRect.init(x: 0, y: 0, width: kScreenWidth, height: 0), style: .plain)
        tb.separatorStyle = .none
        tb.isScrollEnabled = false
        tb.dataSource = self
        tb.delegate = self
        tb.backgroundColor = UIColor.white
        tb.tag = ClientFilterTableViewTag.second.rawValue
        return tb
    }()
    lazy var thirdStateTb: UITableView = {
        let tb = UITableView.init(frame: CGRect.init(x: 0, y: 0, width: kScreenWidth, height: 0), style: .plain)
        tb.separatorStyle = .none
        tb.isScrollEnabled = false
        tb.dataSource = self
        tb.delegate = self
        tb.backgroundColor = UIColor.white
        tb.tag = ClientFilterTableViewTag.third.rawValue
        return tb
    }()
    lazy var tapView: UIView = {
        let v = UIView()
        v.backgroundColor = UIColor.clear
        return v
    }()
    
    convenience init(frame: CGRect, indexPath: IndexPath) {
        self.init(frame: frame)
        self.index = indexPath.section
        self.selectedIndexPath = indexPath
        
        backgroundColor = UIColor.init(white: 0.3, alpha: 0.3)
        addSubview(firstStateTb)
        addSubview(secondStateTb)
        addSubview(thirdStateTb)
        addSubview(tapView)
 
        tapView.snp.makeConstraints { (make) in
            make.bottom.width.centerX.equalTo(self)
            make.height.equalTo(height - 220 * KScreenRatio_6)
        }
        let tap = UITapGestureRecognizer.init { [unowned self](tap) in
            self.isSameIndex = false
            self.resetState()
        }
        
        tapView.addGestureRecognizer(tap)
        
    }
    
    func resetState() {
        self.delegate?.didSelectedFilterItem(name: "", index: 0)
        thirdStateTb.height = 0
        secondStateTb.height = 0
        firstStateTb.height = 0
        delegate?.didRemoveView()
        self.removeFromSuperview()
    }
}



extension BXBClientFilterView: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView.tag == ClientFilterTableViewTag.first.rawValue { return firstItems.count }
        if tableView.tag == ClientFilterTableViewTag.second.rawValue { return secondItems.count }
        if tableView.tag == ClientFilterTableViewTag.third.rawValue { return thirdItems.count }
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40 * KScreenRatio_6
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = BXBClientFilterViewCell.init(style: .default, reuseIdentifier: nil)
        switch tableView.tag {
        case ClientFilterTableViewTag.first.rawValue:
            cell.titleLabel.text = firstItems[indexPath.row]
            break
            
        case ClientFilterTableViewTag.second.rawValue:
            cell.titleLabel.text = secondItems[indexPath.row]
            break
            
        default:
            cell.titleLabel.text = thirdItems[indexPath.row]
            break
        }
        if self.selectedIndexPath.section == tableView.tag {
            cell.isSelectedState = self.selectedIndexPath.row == indexPath.row
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch self.index {
        case 0:
            delegate?.didSelectedFilterItem(name: firstItems[indexPath.row], index: indexPath.row)
            
        case 1:
            delegate?.didSelectedFilterItem(name: secondItems[indexPath.row], index: indexPath.row)
            
        default:
            delegate?.didSelectedFilterItem(name: thirdItems[indexPath.row], index: indexPath.row)
        }
        isSameIndex = false
        thirdStateTb.height = 0
        secondStateTb.height = 0
        firstStateTb.height = 0
        self.removeFromSuperview()
    }
    
}


class BXBClientFilterViewCell: BXBBaseTableViewCell {
    
    public var isSelectedState = false {
        willSet{
            titleLabel.textColor = newValue == true ? kColor_theme : kColor_text
            selectedIV.isHidden = !newValue
        }
    }
    
    lazy var titleLabel: UILabel = {
        let l = UILabel()
        l.font = kFont_text_2
        l.textColor = kColor_text
        return l
    }()
    lazy var selectedIV: UIImageView = {
        let iv = UIImageView.init(image: #imageLiteral(resourceName: "bxb_选中_筛选栏"))
        iv.isHidden = true
        return iv
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(titleLabel)
        contentView.addSubview(selectedIV)
        titleLabel.snp.makeConstraints { (make) in
            make.centerY.height.equalTo(contentView)
            make.left.equalTo(contentView).offset(15 * KScreenRatio_6)
        }
        selectedIV.snp.makeConstraints { (make) in
            make.centerY.equalTo(contentView)
            make.right.equalTo(contentView).offset(-15 * KScreenRatio_6)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
}

















