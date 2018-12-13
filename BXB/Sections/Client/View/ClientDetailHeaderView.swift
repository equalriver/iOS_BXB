//
//  ClientDetailHeaderView.swift
//  BXB
//
//  Created by equalriver on 2018/6/21.
//  Copyright © 2018年 tobosoft. All rights reserved.
//

import UIKit

protocol ClientDetailHeaderDelegate: NSObjectProtocol {
    func didClickDetail(data: ClientData)
}

class ClientDetailHeaderView: UIView {
    
    public var data = ClientData(){
        willSet{
            let total = "+标签" + newValue.label.filter({ (c) -> Bool in
                return c != ","
            })
            dataArr = ["+标签"]
            clientName.text = newValue.name
            if newValue.label.count > 0 {
                if newValue.label.contains(",") {
                    let labels = newValue.label.components(separatedBy: ",")
                    dataArr = labels + ["+标签"]
                }
                else{
                    dataArr.insert(newValue.label, at: 0)
                }
                //是否少于两行
                let w = total.getStringWidth(font: kFont_text_3, height: 15 * KScreenRatio_6) + CGFloat(self.dataArr.count) * 20 * KScreenRatio_6
                
                if w > kScreenWidth * 0.65 * 2 {
                    dataArr.removeLast()
                }
                labelCV.reloadData()
            }
            if newValue.policyCount != 0 && newValue.policyAmount != 0 {
                detailTitle.text = "保单\(newValue.policyCount)笔，保费\(newValue.policyAmount)元"
            }
            else {
                detailTitle.text = "未签单"
            }
            
            if newValue.name.isIncludeChinese {
                if newValue.name.isAllChinese { headLabel.text = newValue.name.last?.description }
                else { headLabel.text = newValue.name.first?.description }
            }
            else { headLabel.text = newValue.name.first?.description }
        }
    }
    
    weak public var delegate: ClientDetailHeaderDelegate?
    
    public var targetVC: UIViewController!
    
    var dataArr = ["+标签"]
    
    lazy var headLabel: UILabel = {
        let l = UILabel()
        l.font = UIFont.systemFont(ofSize: 20 * KScreenRatio_6, weight: .semibold)
        l.textColor = UIColor.white
        l.backgroundColor = kColor_theme
        l.textAlignment = .center
        l.layer.cornerRadius = 25 * KScreenRatio_6
        l.layer.masksToBounds = true
        l.layer.drawsAsynchronously = true
        return l
    }()
    lazy var clientName: UILabel = {
        let l = UILabel()
        l.font = UIFont.systemFont(ofSize: 18 * KScreenRatio_6, weight: .semibold)
        l.textColor = kColor_dark
        return l
    }()
    lazy var detailTitle: UILabel = {
        let l = UILabel()
        l.textColor = kColor_subText
        l.font = kFont_text_3
        return l
    }()
    lazy var labelCV: UICollectionView = {
        let l = ClientDetailHeaderCollectionLayout()
        l.sectionInset = UIEdgeInsets.init(top: 10 * KScreenRatio_6, left: 0, bottom: 10 * KScreenRatio_6, right: 15 * KScreenRatio_6)
        l.minimumLineSpacing = 5
        l.minimumInteritemSpacing = 2.5
        l.scrollDirection = .vertical
        l.delegate = self
        let cv = UICollectionView.init(frame: .zero, collectionViewLayout: l)
        cv.backgroundColor = UIColor.white
        cv.isScrollEnabled = false
        cv.dataSource = self
        cv.delegate = self
        cv.register(ClientDetailHeaderCollectionCell.self, forCellWithReuseIdentifier: "ClientDetailHeaderCollectionCell")
        return cv
    }()
    lazy var detailButton: TitleFrontButton = {
        let b = TitleFrontButton()
        b.setImage(#imageLiteral(resourceName: "rightArrow"), for: .normal)
        b.addBlock(for: .touchUpInside, block: { [unowned self](sender) in
            self.delegate?.didClickDetail(data: self.data)
        })
        return b
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(headLabel)
        self.addSubview(clientName)
        self.addSubview(detailTitle)
        self.addSubview(labelCV)
        self.addSubview(detailButton)
        headLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self).offset(15 * KScreenRatio_6)
            make.top.equalTo(self).offset(12 * KScreenRatio_6)
            make.size.equalTo(CGSize.init(width: 50 * KScreenRatio_6, height: 50 * KScreenRatio_6))
        }
        clientName.snp.makeConstraints { (make) in
            make.left.equalTo(headLabel.snp.right).offset(15 * KScreenRatio_6)
            make.top.equalTo(headLabel).offset(7 * KScreenRatio_6)
            make.height.equalTo(20 * KScreenRatio_6)
            make.right.equalTo(self).offset(-60 * KScreenRatio_6)
        }
        detailTitle.snp.makeConstraints { (make) in
            make.left.width.equalTo(clientName)
            make.top.equalTo(clientName.snp.bottom).offset(2)
            make.height.equalTo(18 * KScreenRatio_6)
        }
        labelCV.snp.makeConstraints { (make) in
            make.top.equalTo(headLabel.snp.bottom).offset(16 * KScreenRatio_6)
            make.left.equalTo(headLabel).offset(2)
            make.bottom.equalTo(self).offset(-10 * KScreenRatio_6)
            make.right.equalTo(self).offset(-15 * KScreenRatio_6)
        }
        detailButton.snp.makeConstraints { (make) in
            make.size.equalTo(CGSize.init(width: 40 * KScreenRatio_6, height: 30 * KScreenRatio_6))
            make.centerY.equalTo(headLabel)
            make.right.equalTo(self)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

class ClientDetailHeaderCollectionLayout: UICollectionViewFlowLayout {
    
    weak var delegate: UICollectionViewDelegateFlowLayout?
    
    var itemAttributes = Array<UICollectionViewLayoutAttributes>()
    
    override init() {
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepare() {
        super.prepare()

        if let itemCount = collectionView?.numberOfItems(inSection: 0){
            
            var offsetX = sectionInset.left
            var offsetY = sectionInset.top
            var nextOffsetX = sectionInset.left
            
            itemAttributes.removeAll()
            for i in 0..<itemCount {
                
                guard let item_size = delegate?.collectionView!(collectionView!, layout: self, sizeForItemAt: IndexPath.init(item: i, section: 0)) else { return }
                
                nextOffsetX += minimumInteritemSpacing + item_size.width
                if nextOffsetX > collectionView!.width - sectionInset.right {
                    offsetX = sectionInset.left
                    nextOffsetX = sectionInset.left + minimumInteritemSpacing + item_size.width
                    offsetY += item_size.height + minimumLineSpacing
                }
                else{
                    offsetX = nextOffsetX - (minimumInteritemSpacing + item_size.width)
                }
                let layoutAttributes = UICollectionViewLayoutAttributes.init(forCellWith: IndexPath.init(item: i, section: 0))
                layoutAttributes.frame = CGRect.init(x: offsetX, y: offsetY, width: item_size.width, height: item_size.height)
                itemAttributes.append(layoutAttributes)
//                print("layoutAttributes.frame: \(layoutAttributes.frame)")
            }
            
        }
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return itemAttributes
    }

    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }

    
}


protocol ClientDetailHeaderItemDelegate: NSObjectProtocol {
    func didClickDelete(cell: UICollectionViewCell)
}

class ClientDetailHeaderCollectionCell: UICollectionViewCell {
    
    weak public var delegate: ClientDetailHeaderItemDelegate?
    
    public var title = ""{
        willSet{
            if newValue == "+标签" {
                itemLabel.textColor = kColor_text
                itemLabel.layer.borderColor = kColor_text?.cgColor
            }
            else{
                itemLabel.textColor = kColor_theme
                itemLabel.layer.borderColor = kColor_theme?.cgColor
            }
            itemLabel.text = newValue
        }
    }
    
    lazy var itemLabel: UILabel = {
        let l = UILabel()
        l.backgroundColor = kColor_background
        l.font = UIFont.systemFont(ofSize: 10 * KScreenRatio_6, weight: .semibold)
        l.textColor = kColor_text
        l.textAlignment = .center
        l.layer.cornerRadius = 10 * KScreenRatio_6
        l.layer.masksToBounds = true
        l.isUserInteractionEnabled = true
        let longTap = UILongPressGestureRecognizer.init(actionBlock: { [unowned self](lt) in
            self.deleteBtn.isHidden = false
        })
        l.addGestureRecognizer(longTap)
        return l
    }()
    
    lazy var deleteBtn: UIButton = {
        let b = UIButton()
        b.setImage(#imageLiteral(resourceName: "长按删除"), for: .normal)
        b.addBlock(for: .touchUpInside, block: { [unowned self](sender) in
            self.delegate?.didClickDelete(cell: self)
        })
        b.isHidden = true
        return b
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(itemLabel)
        contentView.addSubview(deleteBtn)
        itemLabel.snp.makeConstraints { (make) in
            make.centerY.left.equalTo(contentView)
            make.size.equalTo(contentView).multipliedBy(0.9)
        }
        deleteBtn.snp.makeConstraints { (make) in
            make.right.equalTo(itemLabel).offset(15 * KScreenRatio_6)
            make.top.equalTo(itemLabel).offset(-15 * KScreenRatio_6)
            make.size.equalTo(CGSize.init(width: 30 * KScreenRatio_6, height: 30 * KScreenRatio_6))
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        deleteBtn.isHidden = true
        
    }
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        
        var v = super.hitTest(point, with: event)
        if v == nil {
            let p = deleteBtn.convert(point, from: contentView)
            if deleteBtn.bounds.contains(p){
                v = deleteBtn
            }
        }
        
        return v
    }
    
    
}
