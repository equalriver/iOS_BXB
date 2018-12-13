//
//  BXBNetworkRefresh.swift
//  BXB
//
//  Created by equalriver on 2018/6/14.
//  Copyright © 2018年 tobosoft. All rights reserved.
//

import Foundation


class BXBNetworkRefresh: NSObject {
    public class func headerRefresh(scrollView: UIScrollView, handle: @escaping () -> Void) {
        
        let headerRef = MJRefreshNormalHeader.init {
            BXBNetworkTool.isShowSVProgressHUD = false
            //check login
            if UserDefaults.standard.string(forKey: "token") != nil && checkNetwork() == true {
                handle()
            }
            else {
                if scrollView.mj_header != nil { scrollView.mj_header.endRefreshing() }
            }
        }
        headerRef?.lastUpdatedTimeLabel.isHidden = true
        headerRef?.tintColor = kColor_subText
        
//        headerRef?.setTitle("下拉刷新", for: .idle)
//        headerRef?.setTitle("释放更新", for: .pulling)
//        headerRef?.setTitle("加载中...", for: .refreshing)
        headerRef?.stateLabel.isHidden = true
        
//        var imgs = Array<UIImage>()
//
//        for v in 1...30 {
//            if let img = UIImage.init(named: "图层\(v)") {
//                imgs.append(img)
//            }
//        }
//        headerRef?.setImages([#imageLiteral(resourceName: "图层1")], duration: 2, for: MJRefreshState.idle)
//        headerRef?.setImages([#imageLiteral(resourceName: "图层15")], duration: 2, for: MJRefreshState.pulling)
//        headerRef?.setImages(imgs, duration: 1, for: MJRefreshState.refreshing)
        
        scrollView.mj_header = headerRef
    }
    
    public class func footerRefresh(scrollView: UIScrollView, handle: @escaping () -> Void) {

        let footerRef = MJRefreshBackNormalFooter.init {
            BXBNetworkTool.isShowSVProgressHUD = false
            //check login
            if UserDefaults.standard.string(forKey: "token") != nil && checkNetwork() == true {
                handle()
            }
            else {
                if scrollView.mj_footer != nil { scrollView.mj_footer.endRefreshing() }
            }
        }
        footerRef?.backgroundColor = kColor_background
        footerRef?.tintColor = kColor_subText
        footerRef?.setTitle("上拉加载更多", for: .idle)
        footerRef?.setTitle("正在加载数据...", for: .refreshing)
        footerRef?.setTitle("没有更多了", for: .noMoreData)
        
        scrollView.mj_footer = footerRef
    }
}
