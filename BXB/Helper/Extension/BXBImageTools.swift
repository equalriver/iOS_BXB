//
//  ImageTools.swift
//  BXB
//
//  Created by equalriver on 2018/7/7.
//  Copyright © 2018年 tobosoft. All rights reserved.
//

import Foundation


extension UIImage {
    
    ///异步绘制圆角
    public func asyncDrawCornerRadius(roundedRect: CGRect, cornerRadius: CGFloat, fillColor: UIColor, callback: @escaping (_ img: UIImage) -> Void) {
        
        DispatchQueue.global().async {
            // 1.利用绘图，建立上下文 - 内存中开辟一个地址，跟屏幕无关!
            /**
             参数：
             1> size: 绘图的尺寸
             2> 不透明：false / true
             3> scale：屏幕分辨率，生成的图片默认使用 1.0 的分辨率，图像质量不好;可以指定 0 ，会选择当前设备的屏幕分辨率
             */
            UIGraphicsBeginImageContextWithOptions(roundedRect.size, false, 0)
            
            // 2.设置被裁切的部分的填充颜色
            fillColor.setFill()
            UIRectFill(roundedRect)
            
            
            // 3.利用 贝塞尔路径 实现 裁切 效果
            // 1>实例化一个圆形的路径
            let path = UIBezierPath.init(roundedRect: roundedRect, cornerRadius: cornerRadius)
            // 2>进行路径裁切 - 后续的绘图，都会出现在圆形路径内部，外部的全部干掉
            path.addClip()
            
            // 4.绘图 drawInRect 就是在指定区域内拉伸屏幕
            self.draw(in: roundedRect)
            /*
             // 5.绘制内切的圆形
             let ovalPath = UIBezierPath.init(ovalIn: rect)
             ovalPath.lineWidth = 2
             lineColor.setStroke()
             ovalPath.stroke()
             //        UIColor.darkGray.setStroke()
             //        path.lineWidth = 2
             //        path.stroke()
             */
            // 6.取得结果
            let result = UIGraphicsGetImageFromCurrentImageContext()
            
            // 7.关闭上下文
            UIGraphicsEndImageContext()
            
            if result != nil {
                DispatchQueue.main.async {
                    callback(result!)
                }
            }
        }
    }
    
    ///绘制图片圆角
    func drawCorner(rect: CGRect, cornerRadius: CGFloat) -> UIImage {
       
        let bezierPath = UIBezierPath.init(roundedRect: rect, cornerRadius: cornerRadius)
        UIGraphicsBeginImageContextWithOptions(rect.size, false, UIScreen.main.scale)
        if let context = UIGraphicsGetCurrentContext() {
            context.addPath(bezierPath.cgPath)
            context.clip()
            self.draw(in: rect)
            context.drawPath(using: CGPathDrawingMode.fillStroke)
            if let img = UIGraphicsGetImageFromCurrentImageContext(){
                UIGraphicsEndImageContext()
                return img
            }
        }
        return UIImage()
        
    }
    
    
    ///裁剪图片
    func clipImage(newRect: CGRect) -> UIImage? {
        //将UIImage转换成CGImage
        let sourceImg = self.cgImage
        
        //按照给定的矩形区域进行剪裁
        guard let newCgImg = sourceImg?.cropping(to: newRect) else { return nil }
        
        //将CGImageRef转换成UIImage
        let newImg = UIImage.init(cgImage: newCgImg)
        
        return newImg
    }
    
    ///自适应裁剪
    func clipImageToRect(newSize: CGSize) -> UIImage? {
        
        //被切图片宽比例比高比例小 或者相等，以图片宽进行放大
        if self.size.width * newSize.height <= self.size.height * newSize.width {
            //以被剪裁图片的宽度为基准，得到剪切范围的大小
            let w = self.size.width
            let h = self.size.width * newSize.height / newSize.width
            // 调用剪切方法
            // 这里是以中心位置剪切，也可以通过改变rect的x、y值调整剪切位置
            return self.clipImage(newRect: CGRect.init(x: 0, y: (self.size.height - h) / 2, width: w, height: h))
        }
        else {//被切图片宽比例比高比例大，以图片高进行剪裁
            // 以被剪切图片的高度为基准，得到剪切范围的大小
            let w = self.size.height * newSize.width / newSize.height
            let h = self.size.height
            // 调用剪切方法
            // 这里是以中心位置剪切，也可以通过改变rect的x、y值调整剪切位置
            return self.clipImage(newRect: CGRect.init(x: (self.size.width - w) / 2, y: 0, width: w, height: h))
        }
        
    }
    
    ///压缩图片
    /**
     *  压缩上传图片到指定字节
     *
     *  image     压缩的图片
     *  maxLength 压缩后最大字节大小
     *
     *  return 压缩后图片的二进制
     */
    func compressImage(maxLength: Int) -> Data? {
        
        var compress:CGFloat = 0.9

        var data = self.jpegData(compressionQuality: compress)
        
        guard data != nil else { return nil }
        while (data?.count)! > maxLength && compress > 0.01 {
            compress -= 0.02
            data = self.jpegData(compressionQuality: compress)
        }
        
        return data
    }
    
    /**
     *  通过指定图片最长边，获得等比例的图片size
     *
     *  image       原始图片
     *  imageLength 图片允许的最长宽度（高度）
     *
     *  return 获得等比例的size
     */
    func  scaleImage(imageLength: CGFloat) -> CGSize {
        
        var newWidth:CGFloat = 0.0
        var newHeight:CGFloat = 0.0
        let width = self.size.width
        let height = self.size.height
        
        if (width > imageLength || height > imageLength){
            
            if (width > height) {
                
                newWidth = imageLength;
                newHeight = newWidth * height / width;
                
            }else if(height > width){
                
                newHeight = imageLength;
                newWidth = newHeight * width / height;
                
            }else{
                
                newWidth = imageLength;
                newHeight = imageLength;
            }
            
        }
        return CGSize(width: newWidth, height: newHeight)
    }

    /**
     *  获得指定size的图片
     *
     *  image   原始图片
     *  newSize 指定的size
     *
     *  return 调整后的图片
     */
    func resizeImage(newSize: CGSize) -> UIImage? {
        UIGraphicsBeginImageContext(newSize)
        self.draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    }

    
}
