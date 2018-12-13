//
//  BXBSwipeScrollView.swift
//  BXB
//
//  Created by equalriver on 2018/9/17.
//  Copyright © 2018年 tobosoft. All rights reserved.
//

import UIKit

enum BXBSwipeScrollViewState {
    case center
//    case left
    case right
}

protocol BXBSwipeScrollViewDelegate: NSObjectProtocol {
    func didClickRightButton(index: Int)
}

class BXBSwipeScrollView: UIScrollView {

    weak public var swipeDelegate: BXBSwipeScrollViewDelegate?
    
    public var rightButtons: Array<Any>! {
        willSet{
            rightButtonsView.snp.remakeConstraints { (make) in
                make.top.left.height.equalToSuperview()
                make.width.equalTo(kAngendaEditButtonWidth * CGFloat(newValue.count))
            }
            rightButtonsView.utilityButtons = newValue
            rightButtonsView.layoutIfNeeded()
            layoutIfNeeded()
        }
    }
    
    
    weak private var superCell: UITableViewCell!
    
    weak private var superContentView: UIView!
    
    private lazy var contentCellView: UIView = {
        let v = UIView()
//        v.isUserInteractionEnabled = true
        return v
    }()
    
    private lazy var rightButtonsView: BXBSwipeButtonsView = {
        let b = BXBSwipeButtonsView.init(utilityButtons: nil, parentCell: self, utilityButtonSelector: #selector(rightButtonHandler(sender:)))
        return b ?? BXBSwipeButtonsView()
    }()
    
    private lazy var rightClipView: UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.clipsToBounds = true
        return v
    }()
    
    private var tableViewPanGestureRecognizer: UIPanGestureRecognizer!
//    private var longPressGestureRecognizer: UILongPressGestureRecognizer!
    private lazy var tapGestureRecognizer: UITapGestureRecognizer = {
        let t = UITapGestureRecognizer.init(target: self, action: #selector(scrollViewTapped(sender:)))
        t.cancelsTouchesInView = false
        t.delegate = self
        return t
    }()
    
//    private var rightClipConstraint = NSLayoutConstraint()
    
    private var cellState = BXBSwipeScrollViewState.center
    
    private var layoutUpdating = false
    
    private let BXBSwipeTableViewPanState = "state"
    
    //
    public convenience init(cell: UITableViewCell, contentView: UIView) {
        self.init()
        superCell = cell
        superContentView = contentView
        initializer()
    }
    
    public func isButtonsHidden() -> Bool {
        return cellState == .center
    }
    
    public func hideButtonsAnimated(isAnimated: Bool) {
        
//        if cellState != .center {
            self.setContentOffset(contentOffsetForCellState(state: .center), animated: isAnimated)
//        }
    }
    
    public func showRightButtonsAnimated(isAnimated: Bool) {
        
        if cellState != .right {
            self.setContentOffset(contentOffsetForCellState(state: .right), animated: isAnimated)
        }
    }
    
    public func setNeedScrollViewLayout(super_view: UIView) {
        
//        contentCellView.snp.updateConstraints { (make) in
//            make.size.equalTo(super_view.size)
//        }
        
        self.contentSize = CGSize.init(width: super_view.width + rightButtonsWidth(), height: 0)
        
        if self.isTracking == false && self.isDecelerating == false {
            self.contentOffset = contentOffsetForCellState(state: cellState)
        }
        
        updateCellState()
    }
    
    
    //override
    deinit {
        tableViewPanGestureRecognizer.removeObserver(self, forKeyPath: BXBSwipeTableViewPanState)
    }

}

//MARK: - private func
extension BXBSwipeScrollView {
    
    private func initializer() {
        self.bounces = false
        self.showsHorizontalScrollIndicator = false
        self.delegate = self
        self.scrollsToTop = false
        self.isScrollEnabled = true
        self.addGestureRecognizer(tapGestureRecognizer)
    
        addSubview(contentCellView)
        addSubview(rightClipView)
        rightClipView.addSubview(rightButtonsView)
        
        contentCellView.snp.makeConstraints { (make) in
            make.center.equalTo(self)
            make.width.height.equalTo(self)
        }
        rightClipView.snp.makeConstraints { (make) in
            make.top.height.width.equalToSuperview()
            make.left.equalTo(contentCellView.snp.right)
        }
        rightButtonsView.snp.makeConstraints { (make) in
            make.top.left.height.equalToSuperview()
            make.width.equalTo(120)
        }

        for v in superContentView.subviews {
            if v == self { continue }
            contentCellView.addSubview(v)
        }
        if let agendaConentCell = superContentView as? AgendaConentCell {
            agendaConentCell.remakeConstraints()
        }
        
        guard let tb = superCell.superview as? UITableView else { return }
        
//        rightClipConstraint.priority = .defaultHigh
//        superCell.addConstraint(rightClipConstraint)

        tableViewPanGestureRecognizer = tb.panGestureRecognizer
        
        tapGestureRecognizer.require(toFail: tb.panGestureRecognizer)
        
        tableViewPanGestureRecognizer.addObserver(self, forKeyPath: BXBSwipeTableViewPanState, options: NSKeyValueObservingOptions(rawValue: 0), context: nil)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        guard keyPath != nil else { return }
        guard let obj = object as? UIPanGestureRecognizer else { return }
        guard let tb = superCell.superview as? UITableView else { return }
        
        if keyPath! == BXBSwipeTableViewPanState && obj == tableViewPanGestureRecognizer {
            let locationInTableView = tableViewPanGestureRecognizer.location(in: tb)
            
//            for v in tb.visibleCells {
                let inCurrentCell = superCell.frame.contains(locationInTableView)
//                guard let c = v as? BXBAgendaCell else { return }
                if inCurrentCell == false {
//                    c.contentScroll?.hideButtonsAnimated(isAnimated: true)
                    hideButtonsAnimated(isAnimated: true)
                }
                
//            }
            
        }
    }
    /*
    @objc private func scrollViewPressed(sender: UIGestureRecognizer) {
        /*
        if (gestureRecognizer.state == UIGestureRecognizerStateBegan && !self.isHighlighted && self.shouldHighlight)
        {
            [self setHighlighted:YES animated:NO];
        }
            
        else if (gestureRecognizer.state == UIGestureRecognizerStateEnded)
        {
            // Cell is already highlighted; clearing it temporarily seems to address visual anomaly.
            [self setHighlighted:NO animated:NO];
            [self scrollViewTapped:gestureRecognizer];
        }
            
        else if (gestureRecognizer.state == UIGestureRecognizerStateCancelled)
        {
            [self setHighlighted:NO animated:NO];
        }
        */
    }
    */
    @objc private func scrollViewTapped(sender: UIGestureRecognizer) {
        
        if cellState == .center {
            selectCell()
//            if superCell.isSelected {
//                deselectCell()
//            }
//            else if (self.shouldHighlight) // UITableView refuses selection if highlight is also refused.
//            {
//                selectCell()
//            }
        }
        else {
            hideButtonsAnimated(isAnimated: true)
        }
    }
    
    private func selectCell() {
        
        if cellState == .center {
            guard let tb = superCell.superview as? UITableView else { return }
            
            if var cellIndexPath = tb.indexPath(for: superCell) {
                cellIndexPath = tb.delegate?.tableView?(tb, willSelectRowAt: cellIndexPath) ?? cellIndexPath
                tb.selectRow(at: cellIndexPath, animated: false, scrollPosition: .none)
                tb.delegate?.tableView?(tb, didSelectRowAt: cellIndexPath)
            }
            
        }
    }
    
    private func deselectCell() {
        
        if cellState == .center {
            guard let tb = superCell.superview as? UITableView else { return }
        
            if var cellIndexPath = tb.indexPath(for: superCell) {
                cellIndexPath = tb.delegate?.tableView?(tb, willDeselectRowAt: cellIndexPath) ?? cellIndexPath
                tb.deselectRow(at: cellIndexPath, animated: false)
                tb.delegate?.tableView?(tb, didDeselectRowAt: cellIndexPath)
            }
        }
    }
    
    //MARK: - buttons handling
    @objc private func rightButtonHandler(sender: Any) {
        
        guard let buttonTap = sender as? SWUtilityButtonTapGestureRecognizer else { return }
        let buttonIndex = buttonTap.buttonIndex
        swipeDelegate?.didClickRightButton(index: Int(buttonIndex))
    }
    

    
    
    
    //MARK: - Geometry helpers
    private func rightButtonsWidth() -> CGFloat {
        return rightButtonsView.width + 2
    }
    
    private func contentOffsetForCellState(state: BXBSwipeScrollViewState) -> CGPoint {
        
        var scrollPt = CGPoint.zero
        switch state {
        case .right:
            scrollPt.x = rightButtonsWidth()
            break
            
        default:
            scrollPt.x = 0
            break
        }
        return scrollPt
        
    }
    
    private func updateCellState() {
        
        if layoutUpdating == false {
            for v in [BXBSwipeScrollViewState.center, BXBSwipeScrollViewState.right] {
                if self.contentOffset.equalTo(contentOffsetForCellState(state: v)) {
                    cellState = v
                    break
                }
            }
        }
        // Update the clipping on the utility button views according to the current position.
//        var f = superCell.convert(superCell.contentView.frame, to: superCell)
//        f.size.width = superCell.width
//        rightClipConstraint.constant = min(0, f.maxX - superCell.frame.maxX)
        /*
        if superCell.isEditing {
            self.contentOffset = CGPoint.zero
            cellState = .center
        }
        */
//        rightClipView.isHidden = rightClipConstraint.constant == 0
        
        // Enable or disable the gesture recognizers according to the current mode.
        if self.isDragging == false && self.isDecelerating == false {
            self.tapGestureRecognizer.isEnabled = true
//            self.longPressGestureRecognizer.isEnabled = cellState == .center
        }
        else {
            self.tapGestureRecognizer.isEnabled = false
//            self.longPressGestureRecognizer.isEnabled = false
        }
//        self.tapGestureRecognizer.isEnabled = cellState == .center
        self.isScrollEnabled = !superCell.isEditing
    }
    
}

//MARK: - UIScrollViewDelegate
extension BXBSwipeScrollView: UIScrollViewDelegate {
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        
        if velocity.x >= 0.5 {
            if rightButtons == nil {
                cellState = .center
            }
            else {
                cellState = .right
            }
        }
        else if velocity.x <= -0.5 {
            if cellState == .right {
                cellState = .center
            }
//            else {
//                cellState = .left
//            }
        }
        else {
//            let leftThreshold = contentOffsetForCellState(state: .left).x
            let rightThreshold = contentOffsetForCellState(state: .right).x - rightButtonsWidth() / 2
            
            if targetContentOffset.pointee.x > rightThreshold {
                cellState = .right
            }
//            else if targetContentOffset.pointee.x < leftThreshold {
//                cellState = .left
//            }
            else {
                cellState = .center
            }
        }
        
        if cellState != .center {
            guard let tb = superCell.superview as? UITableView else { return }
            
            for v in tb.visibleCells {
                guard let c = v as? BXBAgendaCell else { return }
                if c != superCell {
                    c.contentScroll?.hideButtonsAnimated(isAnimated: true)
                }
            }
        }
        
        targetContentOffset.pointee = contentOffsetForCellState(state: cellState)
        
    }
    /*
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if rightButtonsWidth() > 0 {
            /*
            if (self.delegate && [self.delegate respondsToSelector:@selector(swipeableTableViewCell:canSwipeToState:)])
            {
                BOOL shouldScroll = [self.delegate swipeableTableViewCell:self canSwipeToState:kCellStateRight];
                if (!shouldScroll)
                {
                    scrollView.contentOffset = CGPointMake([self leftUtilityButtonsWidth], 0);
                }
            }
            */
//            else {
//                scrollView.setContentOffset(CGPoint.zero, animated: true)
//                self.tapGestureRecognizer.isEnabled = true
//            }
        }
        else {
            scrollView.setContentOffset(CGPoint.zero, animated: true)
            self.tapGestureRecognizer.isEnabled = true
        }
        
        updateCellState()
    }*/
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        updateCellState()
    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        updateCellState()
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if decelerate == false {
            self.tapGestureRecognizer.isEnabled = true
        }
    }
    
}

//MARK: - UIGestureRecognizerDelegate
extension BXBSwipeScrollView: UIGestureRecognizerDelegate {
    
    override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if gestureRecognizer == self.panGestureRecognizer {//y方向手势不滑动
            let translation = (gestureRecognizer as! UIPanGestureRecognizer).translation(in: gestureRecognizer.view)
            return abs(translation.y) <= abs(translation.x)
        }
        return true
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        if gestureRecognizer.isKind(of: UIPanGestureRecognizer.self) {
            let yVelocity = (gestureRecognizer as! UIPanGestureRecognizer).translation(in: gestureRecognizer.view).y
            return abs(yVelocity) <= 0.25
        }
        return true
    }
}
