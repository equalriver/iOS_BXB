//
//  BXBMapCalloutView.swift
//  BXB
//
//  Created by equalriver on 2018/7/16.
//  Copyright © 2018年 tobosoft. All rights reserved.
//

import UIKit

protocol MapCalloutViewDelegate: NSObjectProtocol {
    func didTapCalloutView(annotationView: MAAnnotationView)
}

class BXBMapCalloutView: MAAnnotationView {
    
    weak public var delegate: MapCalloutViewDelegate?
    
    lazy var callout: MapCallout = {
        let v = MapCallout.init(frame: CGRect.init(x: 0, y: 0, width: 150 * KScreenRatio_6, height: 60 * KScreenRatio_6))
        v.center = CGPoint.init(x: self.width / 2 + calloutOffset.x, y: -self.height / 2 + calloutOffset.y)
        v.titleLabel.addGestureRecognizer(calloutTap)
        return v
    }()
    
    lazy var calloutTap: UITapGestureRecognizer = {
        let t = UITapGestureRecognizer.init(actionBlock: { (tap) in
            self.delegate?.didTapCalloutView(annotationView: self)
        })

        return t
    }()
    
//    override func setSelected(_ selected: Bool, animated: Bool) {
//        if selected {
//
//        }
//        else{ callout.removeFromSuperview() }
//
//        super.setSelected(selected, animated: animated)
//    }
    
    override init!(annotation: MAAnnotation!, reuseIdentifier: String!) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
//        callout.titleLabel.text = annotation.title
        addSubview(callout)
        isUserInteractionEnabled = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        callout.titleLabel.text = nil
    }

    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        var v = super.hitTest(point, with: event)
        if v == nil {
            let p = callout.titleLabel.convert(point, from: self)
            if callout.titleLabel.bounds.contains(p){
                v = callout.titleLabel
            }
        }
        return v
    }
    
}

class MapCallout: UIView {

    lazy var titleLabel: UILabel = {
        let l = UILabel()
        l.font = kFont_text_2
        l.textColor = kColor_text
        l.numberOfLines = 2
        l.textAlignment = .center
        l.isUserInteractionEnabled = true
        return l
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.clear
        isUserInteractionEnabled = true
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.left.top.equalTo(self).offset(10 * KScreenRatio_6)
            make.right.equalTo(self).offset(-10 * KScreenRatio_6)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        if let context = UIGraphicsGetCurrentContext(){
            context.setLineWidth(2)
            context.setFillColor(kColor_background!.cgColor)
            getDrawPath(context: context)
            context.fillPath()
        }
        layer.shadowColor = kColor_text?.cgColor
        layer.shadowOpacity = 1
        layer.shadowOffset = CGSize.init(width: 0, height: 0)

    }
    
    
    func getDrawPath(context: CGContext) {
        let kArrorHeight: CGFloat = 10
        let rrect = self.bounds
        let radius: CGFloat = 6.0
        let minx = rrect.minX
        let midx = rrect.midX
        let maxx = rrect.maxX
        let miny = rrect.minY
        let maxy = rrect.maxY - kArrorHeight
        
        context.move(to: CGPoint.init(x: midx + kArrorHeight, y: maxy))
        context.addLine(to: CGPoint.init(x: midx, y: maxy + kArrorHeight))
        context.addLine(to: CGPoint.init(x: midx - kArrorHeight, y: maxy))
        
        context.addArc(tangent1End: CGPoint.init(x: minx, y: maxy), tangent2End: CGPoint.init(x: minx, y: miny), radius: radius)
        context.addArc(tangent1End: CGPoint.init(x: minx, y: minx), tangent2End: CGPoint.init(x: maxx, y: miny), radius: radius)
        context.addArc(tangent1End: CGPoint.init(x: maxx, y: miny), tangent2End: CGPoint.init(x: maxx, y: maxx), radius: radius)
        context.addArc(tangent1End: CGPoint.init(x: maxx, y: maxy), tangent2End: CGPoint.init(x: midx, y: maxy), radius: radius)
        context.closePath()
    }

    

}
