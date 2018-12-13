//
//  BXBBaseTabVCNavigationBars.swift
//  BXB
//
//  Created by equalriver on 2018/9/25.
//  Copyright © 2018年 tobosoft. All rights reserved.
//

import Foundation

//MARK: - 工作
class BXBWorkTabVCNaviBar: UIView {
    
    public var detailText = "" {
        willSet{
            detailLabel.text = newValue
        }
    }
    
    private lazy var titleLabel: UILabel = {
        let l = UILabel()
        l.font = kFont_tabVC_weight
        l.textColor = kColor_dark
        l.text = "工作"
        return l
    }()
    private lazy var detailLabel: UILabel = {
        let l = UILabel()
        l.font = UIFont.systemFont(ofSize: 18 * KScreenRatio_6, weight: .semibold)
        l.textColor = kColor_text
        return l
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(titleLabel)
        addSubview(detailLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.bottom.equalTo(self).offset(-10)
            make.left.equalTo(self).offset(20 * KScreenRatio_6)
        }
        detailLabel.snp.makeConstraints { (make) in
            make.bottom.equalTo(titleLabel)
            make.left.equalTo(titleLabel.snp.right).offset(15 * KScreenRatio_6)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

//MARK: - 日程
protocol AgendaTabVCNaviBarDelegate: NSObjectProtocol {
    func didClickRightButton()
}

class BXBAgendaTabVCNaviBar: UIView {
    
    weak public var delegate: AgendaTabVCNaviBarDelegate?
    
    public var detailText = "" {
        willSet{
            detailLabel.text = newValue
        }
    }
    
    private lazy var titleLabel: UILabel = {
        let l = UILabel()
        l.font = kFont_tabVC_weight
        l.textColor = kColor_dark
        l.text = "日程"
        return l
    }()
    private lazy var detailLabel: UILabel = {
        let l = UILabel()
        l.font = UIFont.systemFont(ofSize: 18 * KScreenRatio_6, weight: .semibold)
        l.textColor = kColor_text
        return l
    }()
    private lazy var rightButton: UIButton = {
        let b = UIButton()
        b.titleLabel?.font = kFont_naviBtn_weight
        b.setTitle("提醒", for: .normal)
        b.setTitleColor(kColor_theme, for: .normal)
        b.addBlock(for: .touchUpInside, block: { [unowned self](btn) in
            self.delegate?.didClickRightButton()
        })
        return b
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(titleLabel)
        addSubview(detailLabel)
        addSubview(rightButton)
        titleLabel.snp.makeConstraints { (make) in
            make.bottom.equalTo(self).offset(-10)
            make.left.equalTo(self).offset(20 * KScreenRatio_6)
        }
        detailLabel.snp.makeConstraints { (make) in
            make.bottom.equalTo(titleLabel)
            make.left.equalTo(titleLabel.snp.right).offset(15 * KScreenRatio_6)
        }
        rightButton.snp.makeConstraints { (make) in
            make.right.equalToSuperview()
            make.bottom.equalTo(titleLabel).offset(5 * KScreenRatio_6)
            make.size.equalTo(CGSize.init(width: 60 * KScreenRatio_6, height: 35 * KScreenRatio_6))
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

//MARK: - 客户
protocol ClientTabVCNaviBarDelegate: NSObjectProtocol {
    func didClickSearch()
    func didClickRightButton(tag: Int)
}

class BXBClientTabVCNaviBar: UIView {
    
    weak public var delegate: ClientTabVCNaviBarDelegate?
    
    private lazy var searchBtn: UIButton = {
        let b = UIButton()
        b.setImage(UIImage.init(named: "client_搜索_长"), for: .normal)
        b.addBlock(for: .touchUpInside, block: { [unowned self](btn) in
            self.delegate?.didClickSearch()
        })
        return b
    }()
    private lazy var rightButton_1: UIButton = {
        let b = UIButton()
        b.tag = 0
        b.setImage(UIImage.init(named: "client_附近"), for: .normal)
        b.addBlock(for: .touchUpInside, block: { [unowned self](btn) in
            self.delegate?.didClickRightButton(tag: b.tag)
        })
        return b
    }()
    private lazy var rightButton_2: UIButton = {
        let b = UIButton()
        b.tag = 1
        b.setImage(UIImage.init(named: "client_添加客户"), for: .normal)
        b.addBlock(for: .touchUpInside, block: { [unowned self](btn) in
            self.delegate?.didClickRightButton(tag: b.tag)
        })
        return b
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(searchBtn)
        addSubview(rightButton_1)
        addSubview(rightButton_2)
        searchBtn.snp.makeConstraints { (make) in
            make.bottom.equalTo(self).offset(-10)
            make.left.equalTo(self).offset(15 * KScreenRatio_6)
            make.size.equalTo(CGSize.init(width: 265 * KScreenRatio_6, height: 30 * KScreenRatio_6))
        }
        rightButton_2.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(-10 * KScreenRatio_6)
            make.centerY.equalTo(searchBtn)
            make.size.equalTo(CGSize.init(width: 30 * KScreenRatio_6, height: 30 * KScreenRatio_6))
        }
        rightButton_1.snp.makeConstraints { (make) in
            make.right.equalTo(rightButton_2.snp.left).offset(-10 * KScreenRatio_6)
            make.centerY.equalTo(searchBtn)
            make.size.equalTo(CGSize.init(width: 30 * KScreenRatio_6, height: 30 * KScreenRatio_6))
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


//MARK: - 我的
protocol UserTabVCNaviBarDelegate: NSObjectProtocol {
    func didClickRightButton(tag: Int)
}

class BXBUserTabVCNaviBar: UIView {
    
    weak public var delegate: UserTabVCNaviBarDelegate?
    
    lazy var titleLabel: UILabel = {
        let l = UILabel()
        l.font = kFont_tabVC_weight
        l.textColor = kColor_dark
        l.text = "我的"
        return l
    }()
    private lazy var rightButton_1: UIButton = {
        let b = UIButton()
        b.tag = 0
        b.setImage(UIImage.init(named: "me_扫一扫"), for: .normal)
        b.addBlock(for: .touchUpInside, block: { [unowned self](btn) in
            self.delegate?.didClickRightButton(tag: b.tag)
        })
        return b
    }()
    private lazy var rightButton_2: UIButton = {
        let b = UIButton()
        b.tag = 1
        b.setImage(UIImage.init(named: "me_设置"), for: .normal)
        b.addBlock(for: .touchUpInside, block: { [unowned self](btn) in
            self.delegate?.didClickRightButton(tag: b.tag)
        })
        return b
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(titleLabel)
        addSubview(rightButton_1)
        addSubview(rightButton_2)
        titleLabel.snp.makeConstraints { (make) in
            make.bottom.equalTo(self).offset(-10)
            make.left.equalTo(self).offset(20 * KScreenRatio_6)
        }
        rightButton_2.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(-10 * KScreenRatio_6)
            make.centerY.equalTo(titleLabel)
            make.size.equalTo(CGSize.init(width: 30 * KScreenRatio_6, height: 30 * KScreenRatio_6))
        }
        rightButton_1.snp.makeConstraints { (make) in
            make.right.equalTo(rightButton_2.snp.left).offset(-10 * KScreenRatio_6)
            make.centerY.equalTo(titleLabel)
            make.size.equalTo(CGSize.init(width: 30 * KScreenRatio_6, height: 30 * KScreenRatio_6))
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
