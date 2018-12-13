//
//  AnalyzeCellDelegate.swift
//  BXB
//
//  Created by equalriver on 2018/7/2.
//  Copyright © 2018年 tobosoft. All rights reserved.
//

import Foundation

extension AnalyzeWorkReportCell: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BXBWorkReportCVCell", for: indexPath) as! BXBWorkReportCVCell
        cell.iconIV.image = [UIImage.init(named: "work_新增客户"), UIImage.init(named: "work_增员"), UIImage.init(named: "work_活动量"), UIImage.init(named: "work_成交单数")][indexPath.item]
        cell.titleLabel.text = ["新增客户", "增员", "活动量", "成交单数"][indexPath.item]
        cell.countLabel.text = ["\(data.addClientTotal)", "\(data.zengYuanTotal)", "\(data.finishVisit)", "\(data.policyNum)"][indexPath.item]
        return cell
    }
}


extension AnalyzeActivityCell: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return datas.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AnalyzeActivityCVCell", for: indexPath) as! AnalyzeActivityCVCell
        cell.matterLabel.text = datas[indexPath.item].visitTepyName
        cell.numLabel.text = "(\(datas[indexPath.item].visitCount))"
        return cell
    }
}
