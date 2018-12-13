//
//  BXBIntroView.swift
//  BXB
//
//  Created by equalriver on 2018/8/21.
//  Copyright © 2018年 tobosoft. All rights reserved.
//

import UIKit

class BXBIntroView: UIView {

    lazy var imgs_1: [UIImage] = {
        let name = ["intro_日程规划", "intro_客户管理", "intro_提醒消息", "intro_团队管理"]
        var imgs = Array<UIImage>()
        for v in name {
            guard let img = UIImage.init(named: isIphoneXLatter ? v + "_x" : v) else { break }
            imgs.append(img)
        }
        return imgs
    }()
    lazy var imgs_2: [UIImage] = {
        let name = ["intro_日程_弹起", "intro_客户_弹起", "intro_提醒_弹起", "intro_团队_弹起"]
        var imgs = Array<UIImage>()
        for v in name {
            guard let img = UIImage.init(named: v) else { break }
            imgs.append(img)
        }
        return imgs
    }()

    
    var displayCells = Set<IndexPath>()
    
    var cellTransforms = Dictionary<IndexPath, CATransform3D>()
    
    
    lazy var contentCV_1: UICollectionView = {
        let l = UICollectionViewFlowLayout()
        l.itemSize = CGSize.init(width: kScreenWidth, height: kScreenHeight)
        l.sectionInset = UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: 0)
        l.minimumLineSpacing = 0
        l.minimumInteritemSpacing = 0
        l.scrollDirection = .horizontal
        let cv = UICollectionView.init(frame: .zero, collectionViewLayout: l)
        cv.dataSource = self
        cv.delegate = self
        cv.backgroundColor = UIColor.clear
        cv.register(BXBIntroViewCollectionCell.self, forCellWithReuseIdentifier: "BXBIntroViewCollectionCell")
        cv.isPagingEnabled = true
        cv.showsHorizontalScrollIndicator = false
        cv.bounces = false
        return cv
    }()
    lazy var pageControl: UIPageControl = {
        let p = UIPageControl.init()
        p.numberOfPages = 4
        p.currentPage = 0
        p.backgroundColor = UIColor.clear
        p.currentPageIndicatorTintColor = UIColor.white
        p.pageIndicatorTintColor = UIColor.init(hexString: "#b9dbfd")
        return p
    }()
    lazy var breakBtn: UIButton = {
        let b = UIButton()
        b.setImage(#imageLiteral(resourceName: "intro_跳过"), for: .normal)
        b.addTarget(self, action: #selector(breakAction), for: .touchUpInside)
        return b
    }()

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(contentCV_1)
        addSubview(pageControl)
        addSubview(breakBtn)
        
        contentCV_1.snp.makeConstraints { (make) in
            make.size.centerX.centerY.equalToSuperview()
        }
        pageControl.snp.makeConstraints { (make) in
            make.size.equalTo(CGSize.init(width: 80 * KScreenRatio_6, height: 20 * KScreenRatio_6))
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-30 * KScreenRatio_6 - kIphoneXBottomInsetHeight)
        }
        breakBtn.snp.makeConstraints { (make) in
            make.size.equalTo(CGSize.init(width: 90 * KScreenRatio_6, height: 50 * KScreenRatio_6))
            make.right.equalToSuperview()
            make.top.equalToSuperview().offset(kNavigationBarAndStatusHeight - 40 * KScreenRatio_6)
        }
        

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if SVProgressHUD.isVisible() { SVProgressHUD.dismiss() }
    }
    
    //MARK: - action
    
    @objc func breakAction() {

        UIView.animate(withDuration: 1.0, animations: {
            self.alpha = 0
            self.transform = CGAffineTransform.init(scaleX: 3, y: 3)
        }) { (isFinish) in
            if isFinish { self.removeFromSuperview() }
        }
    }
    
    func scaleAnimation(view: UIView) {
        let an = CAKeyframeAnimation.init(keyPath: "transform")
        an.duration = 0.7
        an.fillMode = CAMediaTimingFillMode.forwards
        an.isRemovedOnCompletion = false
        an.timingFunction = CAMediaTimingFunction.init(name: CAMediaTimingFunctionName.easeInEaseOut)
        var values = Array<Any>()
        values.append(NSValue.init(caTransform3D: CATransform3DMakeScale(1.3, 1.3, 1)))
        values.append(NSValue.init(caTransform3D: CATransform3DMakeScale(1.6, 1.6, 1)))
        values.append(NSValue.init(caTransform3D: CATransform3DMakeScale(1.3, 1.3, 1)))
        an.values = values
        
        view.layer.add(an, forKey: nil)
    }
    
}

extension BXBIntroView: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imgs_1.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BXBIntroViewCollectionCell", for: indexPath) as! BXBIntroViewCollectionCell
        
        cell.imgIV.image = imgs_1[indexPath.item]
        cell.scaleImgIV.image = imgs_2[indexPath.item]
        cell.indexPath = indexPath
        for (k, v) in cellTransforms {
            if k == indexPath {
                cell.scaleImgIV.layer.transform = v
            }
        }
        return cell

    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
      
        if let c = cell as? BXBIntroViewCollectionCell {
            
            if displayCells.contains(indexPath) == false {
                
                cellTransforms[indexPath] = CATransform3DMakeScale(1.3, 1.3, 1)

                self.scaleAnimation(view: c.scaleImgIV)

                displayCells.insert(indexPath)
            }
            
        }
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        
        if scrollView.contentOffset.x / scrollView.width == 3.0 && scrollView.panGestureRecognizer.translation(in: self).x < 0 {
            
            DispatchQueue.once(token: "BXBIntroViewDismiss") {
                self.breakAction()
            }
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let page: Int = Int(scrollView.contentOffset.x / scrollView.width + 0.5)
        pageControl.currentPage = page
        
    }
    
}


class BXBIntroViewCollectionCell: UICollectionViewCell {
    
    public var indexPath: IndexPath?
    
    lazy var imgIV: UIImageView = {
        let iv = UIImageView()
        return iv
    }()
    lazy var scaleImgIV: UIImageView = {
        let iv = UIImageView()
        return iv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = UIColor.white
        contentView.addSubview(imgIV)
        imgIV.addSubview(scaleImgIV)
        imgIV.snp.makeConstraints { (make) in
            make.size.centerX.centerY.equalToSuperview()
        }
        scaleImgIV.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            if isIphoneXLatter {
                make.top.equalToSuperview().offset(140 * KScreenRatio_6 + kNavigationBarAndStatusHeight)
            }
            else {
                make.top.equalToSuperview().offset(120 * KScreenRatio_6 + kNavigationBarAndStatusHeight)
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if let index = indexPath {
            switch index.item {
            case 0:
                scaleImgIV.snp.updateConstraints { (make) in
                    make.top.equalToSuperview().offset(140 * KScreenRatio_6 + kNavigationBarAndStatusHeight)
                }
                break
                
            case 1:
                scaleImgIV.snp.updateConstraints { (make) in
                    make.top.equalToSuperview().offset(105 * KScreenRatio_6 + kNavigationBarAndStatusHeight)
                }
                break
                
            case 2:
                scaleImgIV.snp.updateConstraints { (make) in
                    make.top.equalToSuperview().offset(80 * KScreenRatio_6 + kNavigationBarAndStatusHeight)
                }
                break
                
            case 3:
                scaleImgIV.snp.updateConstraints { (make) in
                    make.top.equalToSuperview().offset(185 * KScreenRatio_6 + kNavigationBarAndStatusHeight)
                }
                break
                
            default: break
            }
        }
    }

    
}












