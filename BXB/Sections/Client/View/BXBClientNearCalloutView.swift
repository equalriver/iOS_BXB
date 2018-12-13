//
//  BXBClientNearCalloutView.swift
//  BXB
//
//  Created by equalriver on 2018/7/17.
//  Copyright © 2018年 tobosoft. All rights reserved.
//

import Foundation


protocol ClientNearCalloutViewDelegate: NSObjectProtocol {
    func didTapCalloutView(annotationView: MAAnnotationView)
}

class BXBClientNearCalloutView: MAAnnotationView {
    
    weak public var delegate: ClientNearCalloutViewDelegate?
    
    lazy var callout: ClientNearCallout = {
        let v = ClientNearCallout.init(frame: CGRect.init(x: 0, y: 0, width: 28 * KScreenRatio_6, height: 34 * KScreenRatio_6))
        v.center = CGPoint.init(x: self.width / 2 + calloutOffset.x, y: -self.height / 2 + calloutOffset.y)
        v.iconIV.addGestureRecognizer(calloutTap)
        return v
    }()
    
    lazy var calloutTap: UITapGestureRecognizer = {
        let t = UITapGestureRecognizer.init(actionBlock: { (tap) in
            self.delegate?.didTapCalloutView(annotationView: self)
        })
        
        return t
    }()
    
    
    override init!(annotation: MAAnnotation!, reuseIdentifier: String!) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        addSubview(callout)
        isUserInteractionEnabled = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//    override func prepareForReuse() {
//        super.prepareForReuse()
//        callout.iconIV.image = nil
//    }
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        var v = super.hitTest(point, with: event)
        if v == nil {
            let p = callout.iconIV.convert(point, from: self)
            if callout.iconIV.bounds.contains(p){
                v = callout.iconIV
            }
        }
        return v
    }
    
}

class ClientNearCallout: UIView {
    
 
    lazy var iconIV: UIImageView = {
        let iv = UIImageView.init(image: #imageLiteral(resourceName: "map_定位"))
        return iv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.clear
        isUserInteractionEnabled = true
        addSubview(iconIV)
        iconIV.snp.makeConstraints { (make) in
            make.size.centerX.centerY.equalTo(self)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    /*
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
    */
    
    
}
