//
//  AVCaptureSessionManager.swift
//  ZZYQRCodeSwift
//
//  Created by 张泽宇 on 2017/5/23.
//  Copyright © 2017年 zzy. All rights reserved.
//

import UIKit
import AVFoundation
import Photos

typealias SuccessBlock = (String?) -> Void
typealias GrantBlock = () -> ()
typealias DeniedBlock = () -> ()

class AVCaptureSessionManager: AVCaptureSession, AVCaptureMetadataOutputObjectsDelegate {
    
    /// 音效名称
    var soundName:String?
    /// 是否播放音效
    var isPlaySound = false
    
    private var block: SuccessBlock?
    
    private lazy var device: AVCaptureDevice? = {
        return AVCaptureDevice.devices(for: AVMediaType.video).first
    }()
    
    private lazy var preViewLayer: AVCaptureVideoPreviewLayer = {
        return AVCaptureVideoPreviewLayer(session: self)
    }()
    
    
   /// 创建sessionManager
   ///
   /// - Parameters:
   ///   - captureType: 需要扫描的类型
   ///   - scanRect: 扫描区域这里的Rect(x,y,w,h)分别的取值范围都是0-1 如果需要全屏传入React.null
   ///   - success: 成功回调
   convenience init(captureType: AVCaptureType,
                    scanRect: CGRect,
                    success: @escaping SuccessBlock) {
        self.init()
        block = success
    
        guard device != nil else {
            print("相机输入设备device读取错误")
            return
        }
        var input: AVCaptureDeviceInput?
        do {
            input = try AVCaptureDeviceInput(device: device!)
        } catch let error as NSError {
            print("AVCaputreDeviceError \(error)")
        }
        
        let output = AVCaptureMetadataOutput()
        output.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
        
        if !scanRect.equalTo(CGRect.null) {
            output.rectOfInterest = scanRect
        }
        guard input != nil else {
            print("相机输入设备input读取错误")
            return
        }

        sessionPreset = AVCaptureSession.Preset.high
        if canAddInput(input!) {
            addInput(input!)
        }
        
        if canAddOutput(output) {
            addOutput(output)
        }
        output.metadataObjectTypes = captureType.supportTypes()
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(stop),
                                               name: UIApplication.didEnterBackgroundNotification,
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(start),
                                               name: UIApplication.willEnterForegroundNotification,
                                               object: nil)
    
    }
    
    
    /// 创建sessionManager
    ///
    /// - Parameters:
    ///   - captureType: 需要扫描的类型
    ///   - scanRect: 扫描区域这里的Rect(x,y,w,h)分别的取值范围都是0-1 如果需要全屏传入React.null
    ///   - success: 成功回调
    /// - Returns: manager
    class func createSessionManager(captureType: AVCaptureType,
                                    scanRect: CGRect,
                                    success: @escaping SuccessBlock) ->AVCaptureSessionManager {
        let result = AVCaptureSessionManager(captureType: captureType, scanRect: scanRect, success: success);
        return result
    }
    

    /// 监测相机权限
    ///
    /// - Parameters:
    ///   - grant: 同意回调
    ///   - denied: 拒绝回调
    class func checkAuthorizationStatusForCamera(grant:@escaping GrantBlock, denied:DeniedBlock) {
        
        if AVCaptureDevice.devices(for: AVMediaType.video).first != nil {
            let status = AVCaptureDevice.authorizationStatus(for: AVMediaType.video)
            switch status {
            case .notDetermined:
                AVCaptureDevice.requestAccess(for: AVMediaType.video, completionHandler: { (granted) in
                    if granted {
                        DispatchQueue.main.async(execute: {
                            grant()
                        })
                    }
                })
            case .authorized:
                grant()
            case .denied:
                denied()
            default:
                break
            }
        }
    }
    
    /// 监测相册权限
    ///
    /// - Parameters:
    ///   - grant: 同意回调
    ///   - denied: 拒绝回调
    class func checkAuthorizationStatusForPhotoLibrary(grant:@escaping GrantBlock, denied:DeniedBlock) {
        let status = PHPhotoLibrary.authorizationStatus()
        switch status {
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization({ (status) in
                if status == PHAuthorizationStatus.authorized {
                    DispatchQueue.main.async(execute: {
                        grant()
                    })
                }
            })
            
        case .authorized:
            grant()
        case .denied:
            denied()
        default:
            break
        }
    }
    
    /// 扫描相册中的二维码
    ///
    /// - Parameters:
    ///   - image: 图片
    ///   - success: 成功回调
    func scanPhoto(image: UIImage, success: SuccessBlock) {
        let detector = CIDetector(ofType: CIDetectorTypeQRCode,
                                  context: nil,
                                  options: [CIDetectorAccuracy : CIDetectorAccuracyHigh])
        if detector != nil {
            let features = detector!.features(in: CIImage(cgImage: image.cgImage!))
            for temp in features {
                let result = (temp as! CIQRCodeFeature).messageString
                success(result)
                return
            }
            success(nil)
        }else {
            success(nil)
        }
        
    }
    
    /// 显示扫描
    ///
    /// - Parameter view: 需要在哪个View中显示
    func showPreViewLayerIn(view :UIView) {
        preViewLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        preViewLayer.frame = view.bounds
        view.layer.insertSublayer(preViewLayer, at: 0)
        start()
    }
    
    
    /// 开关闪光灯
    ///
    /// - Parameter state: 闪光灯状态
    func turnTorch(state:Bool) {
        guard device != nil else {
            print("相机输入设备device读取错误")
            return
        }
        if (device!.hasTorch) {
            do {
                try device!.lockForConfiguration()
            } catch let error as NSError {
                print("TorchError  \(error)")
            }
            if (state) {
                device!.torchMode = AVCaptureDevice.TorchMode.on
            } else {
                device!.torchMode = AVCaptureDevice.TorchMode.off
            }
            device!.unlockForConfiguration()
        }
    }
    
    
    /// 播放音效
    func playSound() {
        if isPlaySound {
            var result = "ZZYQRCode.bundle/sound.caf"
            if let temp = soundName, temp != ""{
                result = temp
            }
            
            if let urlstr = Bundle.main.path(forResource: result, ofType: nil) {
                let fileURL = NSURL(fileURLWithPath: urlstr)
                var soundID:SystemSoundID = 0;
                AudioServicesCreateSystemSoundID(fileURL, &soundID)
                AudioServicesPlaySystemSound(soundID)
            }
        }
    }
    
    /// 开启扫描
    @objc func start() {
        startRunning()
    }
    
    /// 停止扫描
    @objc func stop() {
        stopRunning()
    }
    
    func captureOutput(_ captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [Any]!, from connection: AVCaptureConnection!) {
        if (metadataObjects.count > 0) {
            // 停止扫描
            stop()
            playSound()
            // 获取信息
            let result = metadataObjects.last as! AVMetadataMachineReadableCodeObject
            block!(result.stringValue)
        }
    }
}

enum AVCaptureType {
    case AVCaptureTypeQRCode
    case AVCaptureTypeBarCode
    case AVCaptureTypeBoth
    func supportTypes() -> [AVMetadataObject.ObjectType] {
        switch self {
        case .AVCaptureTypeQRCode:
            return [.qr]
        case .AVCaptureTypeBarCode:
            return [.dataMatrix,
                    .itf14,
                    .interleaved2of5,
                    .aztec,
                    .pdf417,
                    .code128,
                    .code93,
                    .ean8,
                    .ean13,
                    .code39Mod43,
                    .code39,
                    .upce]
        case .AVCaptureTypeBoth:
            return [.qr,
                    .dataMatrix,
                    .itf14,
                    .interleaved2of5,
                    .aztec,
                    .pdf417,
                    .code128,
                    .code93,
                    .ean8,
                    .ean13,
                    .code39Mod43,
                    .code39,
                    .upce]
        }
    }
}
