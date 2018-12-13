//
//  BXBAgendaCell.swift
//  BXB
//
//  Created by equalriver on 2018/6/7.
//  Copyright © 2018年 tobosoft. All rights reserved.
//

import UIKit

enum AgendaCellHeightType: CGFloat {
    case singleRow = 55
    case twoRow = 80
    case threeRow = 105
}

protocol AgendaCellDelegate: NSObjectProtocol {
    func didClickEditButtons(cell: BXBAgendaCell, index: Int)
}

extension BXBAgendaCell: BXBSwipeScrollViewDelegate {
    
    func didClickRightButton(index: Int) {
        delegate?.didClickEditButtons(cell: self, index: index)
    }
}

class BXBAgendaCell: UITableViewCell {
    
    weak public var delegate: AgendaCellDelegate?
    
    public var data: AgendaData! {
        willSet{
            contentCell.nameLabel.text = newValue.name
            contentCell.detailLabel.text = newValue.visitTypeName
            contentCell.addressLabel.text = newValue.address
            contentCell.remarkLabel.text = newValue.remarks
            timeLabel.text = newValue.visitTime
            
            var type = AgendaCellHeightType.singleRow
            if newValue.address.count > 0 || newValue.remarks.count > 0 { type = .twoRow }
            if newValue.address.count > 0 && newValue.remarks.count > 0 { type = .threeRow }
            
            contentCell.snp.updateConstraints { (make) in
                make.height.equalTo(type.rawValue * KScreenRatio_6)
            }

            contentCell.remarkLabel.isHidden = newValue.remarks.count == 0
            contentCell.addressLabel.isHidden = newValue.address.count == 0
            
            if newValue.status == 1 {//已完成
                stateIV.image = #imageLiteral(resourceName: "agenda_完成")
                contentCell.image = #imageLiteral(resourceName: "agenda_白色底")
                contentCell.finishStateIV.isHidden = false
                contentCell.detailLabel.textColor = kColor_agenda_finish_1
                contentCell.nameLabel.textColor = kColor_agenda_finish_1
                contentCell.addressLabel.textColor = kColor_agenda_finish_2
                contentCell.remarkLabel.textColor = kColor_agenda_finish_3
            }
            else {
                stateIV.image = #imageLiteral(resourceName: "agenda_进行中")
                contentCell.image = #imageLiteral(resourceName: "agenda_白色底")
                contentCell.finishStateIV.isHidden = true
                contentCell.detailLabel.textColor = kColor_dark
                contentCell.nameLabel.textColor = kColor_dark
                contentCell.addressLabel.textColor = kColor_text
                contentCell.remarkLabel.textColor = kColor_theme
            }
            
            if contentScroll != nil {
                contentScroll!.isHidden = false
                contentScroll!.hideButtonsAnimated(isAnimated: true)
                contentScroll!.isUserInteractionEnabled = true
            }
            else {
                contentScroll = BXBSwipeScrollView.init(cell: self, contentView: contentCell)
                contentScroll!.swipeDelegate = self
                contentCell.addSubview(contentScroll!)
                contentScroll!.snp.makeConstraints { (make) in
                    make.top.left.bottom.right.equalToSuperview()
                }
            }
            
            let btns = NSMutableArray.init(capacity: 2)
            if newValue.status == 0 {
                btns.sw_addUtilityButton(with: UIColor.init(red: 199/255.0, green: 199/255.0, blue: 203/255.0, alpha: 1.0), title: "完成")
            }
            btns.sw_addUtilityButton(with: UIColor.init(red: 234/255.0, green: 78/255.0, blue: 61/255.0, alpha: 1.0), title: "删除")
            contentScroll!.rightButtons = btns as? Array<Any>
            
            contentScroll!.contentSize = CGSize.init(width: 340 * KScreenRatio_6 + kAngendaEditButtonWidth * CGFloat(btns.count), height: 0)
            
            contentScroll!.rightButtons = btns as? Array<Any>
        }
    }
    
    public var remindData: AgendaRemindData! {
        willSet{
            contentCell.snp.updateConstraints { (make) in
                make.height.equalTo(AgendaCellHeightType.singleRow.rawValue * KScreenRatio_6)
            }
            contentCell.detailLabel.textColor = kColor_dark
            contentCell.nameLabel.textColor = kColor_dark
            contentCell.image = #imageLiteral(resourceName: "agenda_白色底")
            contentCell.addressLabel.isHidden = true
            contentCell.remarkLabel.isHidden = true
            stateIV.image = #imageLiteral(resourceName: "agenda_提醒类日程")
            contentCell.nameLabel.text = newValue.name
            contentCell.detailLabel.text = newValue.remindName 
            timeLabel.text = newValue.matter
            
            if contentScroll != nil {
                contentScroll!.isHidden = false
                contentScroll!.isUserInteractionEnabled = true
                contentScroll!.hideButtonsAnimated(isAnimated: true)
            }
            else {
                contentScroll = BXBSwipeScrollView.init(cell: self, contentView: contentCell)
                contentScroll!.swipeDelegate = self
                contentCell.addSubview(contentScroll!)
                contentScroll!.snp.makeConstraints { (make) in
                    make.top.left.bottom.right.equalToSuperview()
                }
            }
            let btns = NSMutableArray.init(capacity: 1)
      
            btns.sw_addUtilityButton(with: UIColor.init(red: 234/255.0, green: 78/255.0, blue: 61/255.0, alpha: 1.0), title: "删除")
            contentScroll!.rightButtons = btns as? Array<Any>
            
            contentScroll!.contentSize = CGSize.init(width: 340 * KScreenRatio_6 + kAngendaEditButtonWidth * CGFloat(btns.count), height: 0)
            
            contentScroll!.rightButtons = btns as? Array<Any>
            
        }
    }
    
    lazy var contentCell: AgendaConentCell = {
        let c = AgendaConentCell.init(frame: .zero)
        c.isUserInteractionEnabled = true
        return c
    }()
    
    var contentScroll: BXBSwipeScrollView?
    
    lazy var stateIV: UIImageView = {
        let v = UIImageView()
        return v
    }()
    lazy var sepView: UIView = {
        let v = UIView()
        v.backgroundColor = kColor_separatorView
        return v
    }()
    lazy var timeLabel: UILabel = {
        let l = UILabel()
        l.font = kFont_text
        l.textColor = kColor_text
        return l
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.backgroundColor = kColor_background
        contentView.addSubview(contentCell)
        contentView.addSubview(stateIV)
        contentView.addSubview(sepView)
        contentView.addSubview(timeLabel)
        contentCell.snp.makeConstraints { (make) in
            make.width.equalTo(330 * KScreenRatio_6)
            make.right.equalTo(contentView).offset(-15 * KScreenRatio_6)
            make.top.equalTo(contentView).offset(30 * KScreenRatio_6)
            make.height.equalTo(AgendaCellHeightType.singleRow.rawValue * KScreenRatio_6)
        }
        stateIV.snp.makeConstraints { (make) in
            make.size.equalTo(CGSize.init(width: 16 * KScreenRatio_6, height: 16 * KScreenRatio_6))
            make.top.equalTo(contentView)
            make.left.equalTo(contentView).offset(7 * KScreenRatio_6)
        }
        sepView.snp.makeConstraints { (make) in
            make.width.equalTo(1)
            make.top.equalTo(stateIV.snp.bottom)
            make.bottom.equalTo(contentView)
            make.centerX.equalTo(stateIV)
        }
        timeLabel.snp.makeConstraints { (make) in
            make.left.equalTo(stateIV.snp.right).offset(15 * KScreenRatio_6)
            make.centerY.equalTo(stateIV)
            make.width.equalTo(200 * KScreenRatio_6)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        contentCell.nameLabel.text = nil
        contentCell.addressLabel.text = nil
        contentCell.detailLabel.text = nil
        contentCell.remarkLabel.text = nil
        contentCell.finishStateIV.isHidden = true
//        contentCell.leftUtilityButtons = nil
        stateIV.image = nil
        timeLabel.text = nil
        sepView.isHidden = false
        contentScroll?.hideButtonsAnimated(isAnimated: false)
        contentScroll?.isUserInteractionEnabled = true
        contentScroll?.isHidden = true
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if data != nil {
            if data.address.count == 0 && data.remarks.count > 0 {
                contentCell.remarkLabel.snp.updateConstraints { (make) in
                    make.top.equalTo(contentCell.addressLabel.snp.bottom).offset(-3 * KScreenRatio_6)
                }
            }
            else {
                contentCell.remarkLabel.snp.updateConstraints { (make) in
                    make.top.equalTo(contentCell.addressLabel.snp.bottom).offset(8 * KScreenRatio_6)
                }
            }
        }
        
    }
    
    //获取行高
    class func getRowHeight(data: AgendaData, indexPath: IndexPath) -> CGFloat {
        
        var type = AgendaCellHeightType.singleRow
        if data.address.count > 0 || data.remarks.count > 0 { type = .twoRow }
        if data.address.count > 0 && data.remarks.count > 0 { type = .threeRow }
        
        return agendaRowCommonHeight + type.rawValue * KScreenRatio_6
        
    }
    
}

class AgendaConentCell: UIImageView {
    
    lazy var nameLabel: UILabel = {
        let l = UILabel()
        l.font = kFont_text_weight
        l.textColor = kColor_dark
        l.textAlignment = .right
        return l
    }()
    lazy var detailLabel: UILabel = {
        let l = UILabel()
        l.textColor = kColor_dark
        l.font = kFont_text_weight
        return l
    }()
    lazy var addressLabel: UILabel = {
        let l = UILabel()
        l.textColor = kColor_text
        l.font = kFont_text_3
        return l
    }()
    lazy var remarkLabel: UILabel = {
        let l = UILabel()
        l.textColor = kColor_theme
        l.font = kFont_text_3
        return l
    }()
    lazy var finishStateIV: UIImageView = {
        let v = UIImageView.init(image: UIImage.init(named: "agenda_已完成_印章"))
        v.isHidden = true
        return v
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(nameLabel)
        addSubview(addressLabel)
        addSubview(detailLabel)
        addSubview(remarkLabel)
        addSubview(finishStateIV)
        makeConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    
    func makeConstraints() {
        nameLabel.snp.makeConstraints { (make) in
            make.size.equalTo(CGSize.init(width: 325 * 0.3 * KScreenRatio_6, height: 20 * KScreenRatio_6))
            make.right.equalToSuperview().offset(-20 * KScreenRatio_6)
            make.top.equalToSuperview().offset(18 * KScreenRatio_6)
        }
        detailLabel.snp.makeConstraints { (make) in
            make.left.top.equalToSuperview().offset(18 * KScreenRatio_6)
            make.width.equalTo(180 * KScreenRatio_6)
            make.height.equalTo(nameLabel)
        }
        addressLabel.snp.makeConstraints { (make) in
            make.top.equalTo(detailLabel.snp.bottom).offset(8 * KScreenRatio_6)
            make.left.equalTo(detailLabel)
            make.right.equalTo(nameLabel)
        }
        remarkLabel.snp.makeConstraints { (make) in
            make.top.equalTo(addressLabel.snp.bottom).offset(8 * KScreenRatio_6)
            make.left.width.equalTo(addressLabel)
        }
        finishStateIV.snp.makeConstraints { (make) in
            make.size.equalTo(CGSize.init(width: 50 * KScreenRatio_6, height: 40 * KScreenRatio_6))
            make.center.equalToSuperview()
        }
    }
    
    func remakeConstraints() {
        nameLabel.snp.remakeConstraints { (make) in
            make.size.equalTo(CGSize.init(width: 325 * 0.3 * KScreenRatio_6, height: 20 * KScreenRatio_6))
            make.right.equalToSuperview().offset(-20 * KScreenRatio_6)
            make.top.equalToSuperview().offset(18 * KScreenRatio_6)
        }
        detailLabel.snp.remakeConstraints { (make) in
            make.left.top.equalToSuperview().offset(18 * KScreenRatio_6)
            make.width.equalTo(180 * KScreenRatio_6)
            make.height.equalTo(nameLabel)
        }
        addressLabel.snp.remakeConstraints { (make) in
            make.top.equalTo(detailLabel.snp.bottom).offset(8 * KScreenRatio_6)
            make.left.equalTo(detailLabel)
            make.right.equalTo(nameLabel)
        }
        remarkLabel.snp.remakeConstraints { (make) in
            make.top.equalTo(addressLabel.snp.bottom).offset(8 * KScreenRatio_6)
            make.left.width.equalTo(addressLabel)
        }
        finishStateIV.snp.remakeConstraints { (make) in
            make.size.equalTo(CGSize.init(width: 50 * KScreenRatio_6, height: 40 * KScreenRatio_6))
            make.center.equalToSuperview()
        }
    }
    
    

}
