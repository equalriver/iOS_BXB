//
//  BXBAddNewAgendaView.swift
//  BXB
//
//  Created by equalriver on 2018/8/19.
//  Copyright © 2018年 tobosoft. All rights reserved.
//

import UIKit
import pop

protocol AddNewAgendaDelegate: NSObjectProtocol {
    func didSelectedAddNewAgendaType(type: String, data: Any?)
}

class BXBAddNewAgendaView: UIView {
    
    weak public var delegate: AddNewAgendaDelegate?
    
    public var data: Any?
    
    var cells = Array<AddNewAgendaCollectionCell>()
    
    let dataArr = ["接洽", "面谈", "建议书", "增员", "签单", "保单服务", "客户服务"]
    
    let maskLayer = CAShapeLayer()
    
    lazy var contentView: UIView = {
        let v = UIView.init(frame: CGRect.init(x: 0, y: kScreenHeight, width: kScreenWidth, height: 260 * KScreenRatio_6))
//        let tap = UITapGestureRecognizer()
//        v.addGestureRecognizer(tap)
        v.backgroundColor = UIColor.white
        return v
    }()
    lazy var contentCV: UICollectionView = {
        let l = UICollectionViewFlowLayout()
        l.itemSize = CGSize.init(width: kScreenWidth / 4 - 10 * KScreenRatio_6, height: kScreenWidth / 4 - 10 * KScreenRatio_6)
        l.scrollDirection = .vertical
        l.sectionInset = UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: 0)
        l.minimumLineSpacing = 10 * KScreenRatio_6
        l.minimumInteritemSpacing = 0
        let c = UICollectionView.init(frame: .zero, collectionViewLayout: l)
        c.dataSource = self
        c.delegate = self
        c.backgroundColor = UIColor.white
        c.isScrollEnabled = false
        c.register(AddNewAgendaCollectionCell.self, forCellWithReuseIdentifier: "AddNewAgendaCollectionCell")
        return c
    }()
    lazy var removeBtn: UIButton = {
        let b = UIButton()
        b.setImage(#imageLiteral(resourceName: "agenda_收起"), for: .normal)
        b.addBlock(for: .touchUpInside, block: { [unowned self](btn) in
            self.contentView.viewAnimateDismissFromBottom(duration: 0.5, completion: { (isFinish) in
                if isFinish { self.removeFromSuperview() }
            })
        })
        return b
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.init(white: 0.3, alpha: 0.3)
        let tap = UITapGestureRecognizer.init { [weak self](ges) in
            self?.removeFromSuperview()
        }
        tap.delegate = self
        addGestureRecognizer(tap)
        
        addSubview(contentView)
        contentView.addSubview(contentCV)
        contentView.addSubview(removeBtn)
        removeBtn.snp.makeConstraints { (make) in
            make.size.equalTo(CGSize.init(width: kScreenWidth / 2, height: 50 * KScreenRatio_6))
            make.centerX.top.equalTo(contentView)
        }
        contentCV.snp.makeConstraints { (make) in
            make.top.equalTo(removeBtn.snp.bottom)
            make.width.centerX.bottom.equalTo(contentView)
        }

        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.2) {
            self.springAnimation()
        }
        contentView.viewAnimateComeFromBottom(duration: 0.4) { (isFinish) in
            
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let maskPath = UIBezierPath.init(roundedRect: contentView.bounds, byRoundingCorners: [.topLeft, .topRight], cornerRadii: CGSize.init(width: 12, height: 12))
        
        maskLayer.strokeColor = UIColor.white.cgColor
        maskLayer.frame = contentView.bounds
        maskLayer.path = maskPath.cgPath
        contentView.layer.mask = maskLayer
        
    }
    
    func springAnimation() {
        
        var duration: Double = 0
        
        for v in cells {
            var fromFrame = v.frame
            let toFrame = v.frame
            fromFrame.origin.y += fromFrame.size.height / 3
            v.frame = fromFrame
            
            let spring = POPSpringAnimation.init(propertyNamed: kPOPViewFrame)
            spring?.toValue = NSValue.init(cgRect: toFrame)
            spring?.beginTime = CACurrentMediaTime() + duration
            spring?.springBounciness = 12
            
            v.pop_add(spring, forKey: kPOPViewFrame)
            duration += 0.04
        }
    }
    
}

extension BXBAddNewAgendaView: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AddNewAgendaCollectionCell", for: indexPath) as! AddNewAgendaCollectionCell
        cell.iconIV.image = [#imageLiteral(resourceName: "agenda_接洽"), #imageLiteral(resourceName: "agenda_面谈"), #imageLiteral(resourceName: "agenda_建议书"), #imageLiteral(resourceName: "agenda_增员"), #imageLiteral(resourceName: "agenda_签单"), #imageLiteral(resourceName: "agenda_保单服务"), #imageLiteral(resourceName: "agenda_客户服务")][indexPath.row]
        cell.titleLabel.text = dataArr[indexPath.row]
        cells.insert(cell, at: indexPath.row)

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.didSelectedAddNewAgendaType(type: dataArr[indexPath.row], data: data)
        self.removeFromSuperview()
    }
}

extension BXBAddNewAgendaView: UIGestureRecognizerDelegate {
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if let v = touch.view {
            if v.width == kScreenWidth { return true }
        }
        return false
    }
  
}


class AddNewAgendaCollectionCell: UICollectionViewCell {
    
    lazy var iconIV: UIImageView = {
        let v = UIImageView()
        return v
    }()
    lazy var titleLabel: UILabel = {
        let l = UILabel()
        l.font = kFont_text_3
        l.textColor = kColor_text
        l.textAlignment = .center
        return l
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(iconIV)
        contentView.addSubview(titleLabel)
        iconIV.snp.makeConstraints { (make) in
            make.top.equalTo(contentView).offset(10 * KScreenRatio_6)
            make.centerX.equalTo(contentView)
        }
        titleLabel.snp.makeConstraints { (make) in
            make.width.centerX.equalTo(contentView)
            make.top.equalTo(iconIV.snp.bottom).offset(10 * KScreenRatio_6)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}










