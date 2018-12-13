//
//  ClientDetailHeaderDelegate.swift
//  BXB
//
//  Created by equalriver on 2018/6/21.
//  Copyright © 2018年 tobosoft. All rights reserved.
//

import Foundation

extension ClientDetailHeaderView: ClientDetailHeaderItemDelegate {
    
    //删除标签
    func didClickDelete(cell: UICollectionViewCell) {
        if let indexPath = labelCV.indexPath(for: cell) {
            
            var total = ""
            if indexPath.item < dataArr.count {
                dataArr.remove(at: indexPath.item)
                self.labelCV.deleteItems(at: [indexPath])
            }
            for item in dataArr {
                if item == "+标签" { continue }
                total += item + ","
            }
            if let last = total.last {
                if last == "," { total.removeLast() }
            }
            
            BXBNetworkTool.BXBRequest(router: .editClient(id: data.id, params: ["label": total]), success: { (resp) in
                //是否少于两行
                let w = total.getStringWidth(font: kFont_text_3, height: 15 * KScreenRatio_6) + CGFloat(self.dataArr.count) * 20 * KScreenRatio_6
                
                if w <= kScreenWidth * 0.65 * 2 {
                    if self.dataArr.contains("+标签") == false { self.dataArr.append("+标签") }
                }
                else {
                    if self.dataArr.contains("+标签") == true { self.dataArr.removeLast() }
                }
                self.labelCV.reloadData()
                
            }) { (error) in
                
            }
        }
    }
}

extension ClientDetailHeaderView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ClientDetailHeaderCollectionCell", for: indexPath) as! ClientDetailHeaderCollectionCell
        cell.title = dataArr[indexPath.item]
        if dataArr[indexPath.item] == "+标签" {
            cell.itemLabel.backgroundColor = kColor_theme
            cell.itemLabel.textColor = UIColor.white
        }
        else {
            cell.itemLabel.backgroundColor = kColor_background
            cell.itemLabel.textColor = kColor_subText
        }
        cell.delegate = self
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath){
            let c = cell as! ClientDetailHeaderCollectionCell
            if c.title == "+标签" {
                
                for v in collectionView.visibleCells {
                    if let cc = v as? ClientDetailHeaderCollectionCell {
                        cc.deleteBtn.isHidden = true
                    }
                }
                
                let alert = UIAlertController.init(title: nil, message: "请输入标签", preferredStyle: .alert)
                let ac = UIAlertAction.init(title: "确定", style: .default) { (action) in
                    
                    if let tf = alert.textFields?.first {
                        
                        guard tf.hasText == true else { return }
                        
                        tf.text = String(tf.text!.prefix(8))
                        
                        var totalItem = ""
                        
                        //去重
                        for item in self.dataArr {
                            if item == "+标签" { continue }
                            if item == tf.text! {
                                self.superview?.makeToast("重复标签")
                                totalItem = ""
                                return
                            }
                            totalItem += item + ","
                        }
                        
                        //是否超出两行
                        var totalStr = ""
                        
                        for obj in self.dataArr { totalStr += obj }
                        
                        let w = totalStr.getStringWidth(font: kFont_text_3, height: 15 * KScreenRatio_6) + CGFloat(self.dataArr.count) * 20 * KScreenRatio_6
                        
                        if w > kScreenWidth * 0.7 * 2 {
                            self.superview?.makeToast("超出标签数量限制")
                            return
                        }
                        if w > kScreenWidth * 0.65 * 2 {
                            self.dataArr.removeLast()
                            collectionView.reloadData()
                        }
                        
                        
                        //添加标签
                        BXBNetworkTool.BXBRequest(router: .editClient(id: self.data.id, params: ["label": totalItem + tf.text!]), success: { (resp) in
                            
                            self.dataArr.insert(tf.text!, at: 0)
                            collectionView.insertItems(at: [IndexPath.init(row: 0, section: 0)])
                            
                            collectionView.reloadData()
                            
                        }, failure: { (error) in
                            
                        })
                            
                    }
                }
                let cancel = UIAlertAction.init(title: "取消", style: .cancel, handler: nil)
                alert.addTextField { (tf) in
                    tf.font = kFont_text_2
                    tf.textColor = kColor_text
                    tf.clearButtonMode = .whileEditing
                    tf.attributedPlaceholder = NSAttributedString.init(string: "最多输入\(kClientLabelTextLimitCount)个字", attributes: [NSAttributedString.Key.font: kFont_text_2, NSAttributedString.Key.foregroundColor: kColor_subText!])
                    tf.addBlock(for: .editingChanged, block: { (t) in
                        
                        guard tf.hasText == true else { return }
                        
                        if tf.text! == "+标签" { return }
                        
                        guard UIApplication.shared.keyWindow != nil else { return }
                        
                        guard tf.markedTextRange == nil else { return }
                        if tf.text!.count > kClientLabelTextLimitCount {
                            UIApplication.shared.keyWindow!.makeToast("最多输入\(kClientLabelTextLimitCount)个字")
                            tf.text = String(tf.text!.prefix(kClientLabelTextLimitCount))
                        }
                        
                    })
                }
                alert.addAction(ac)
                alert.addAction(cancel)
                DispatchQueue.main.async {
                    self.targetVC.present(alert, animated: true, completion: nil)
                }
            }
        }
        
    }
    
    //layout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let s = dataArr[indexPath.item].getStringSize(font: .systemFont(ofSize: 15 * KScreenRatio_6), height: 22 * KScreenRatio_6)
        
        return CGSize.init(width: s.width + 15 * KScreenRatio_6, height: 22 * KScreenRatio_6)
    }
    
}
