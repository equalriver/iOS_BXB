//
//  BXBQRScanVC.swift
//  BXB
//
//  Created by equalriver on 2018/7/3.
//  Copyright © 2018年 tobosoft. All rights reserved.
//

import UIKit
import AVFoundation

class BXBQRScanVC: BXBBaseNavigationVC {

   
    public var teamId = 0
    
    let scanRect = CGRect.init(x: (kScreenWidth - 220 * KScreenRatio_6) / 2, y: 220 * KScreenRatio_6, width: 220 * KScreenRatio_6, height: 220 * KScreenRatio_6)
    
    lazy var pickerBg: UIImageView = {
        let iv = UIImageView.init(frame: scanRect)
        iv.image = #imageLiteral(resourceName: "pick_bg")
        return iv
    }()
    
    lazy var rightCameraBtn: UIButton = {
        let b = UIButton()
        b.titleLabel?.font = kFont_naviBtn_weight
        b.setTitle("相册", for: .normal)
        b.setTitleColor(kColor_theme, for: .normal)
        return b
    }()
    
    lazy var cropLayer: CAShapeLayer = {
        let c = CAShapeLayer()
        let path = CGMutablePath.init()
        path.addRect(scanRect)
        path.addRect(CGRect.init(x: 0, y: kNavigationBarAndStatusHeight, width: kScreenWidth, height: kScreenHeight - kNavigationBarAndStatusHeight))
        
        c.fillRule = CAShapeLayerFillRule.evenOdd
        c.path = path
        c.fillColor = UIColor.black.cgColor
        c.opacity = 0.65
        return c
    }()
    
    lazy var titleLabel: UILabel = {
        let l = UILabel()
        l.text = "对准二维码到框内即可扫描"
        l.font = kFont_text_2
        l.textColor = UIColor.white
        l.textAlignment = .center
        return l
    }()
    
    lazy var session: AVCaptureSession = {
        let s = AVCaptureSession()
        s.sessionPreset = .high
        return s
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "扫一扫"
        initUI()
        setupCamera()
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        session.startRunning()
    }
    
    func initUI() {
        cropLayer.setNeedsDisplay()
        view.layer.addSublayer(cropLayer)
        view.addSubview(titleLabel)
        view.addSubview(pickerBg)
        titleLabel.snp.makeConstraints { (make) in
            make.width.centerX.equalTo(view)
            make.top.equalTo(view).offset(445 * KScreenRatio_6)
        }
        naviBar.rightBarButtons = [rightCameraBtn]
    }

    func setupCamera() {
        guard let device = AVCaptureDevice.default(for: .video) else {
            self.view.makeToast("无相机或相机无法使用")
            navigationController?.popViewController(animated: true)
            return
        }
        do {
            let input = try AVCaptureDeviceInput.init(device: device)
            let output = AVCaptureMetadataOutput.init()
            output.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            
            if session.canAddInput(input) { session.addInput(input) }
            if session.canAddOutput(output) { session.addOutput(output) }
            //条码类型
            output.metadataObjectTypes = [.qr]
            
            let preview = AVCaptureVideoPreviewLayer.init(session: session)
            preview.videoGravity = .resizeAspectFill
            preview.frame = view.layer.bounds
            view.layer.insertSublayer(preview, at: 0)
            
            session.startRunning()
            
        } catch {
            print("相机error:\(error.localizedDescription)")
        }
    }
    
    //MARK: - action
    override func rightButtonsAction(sender: UIButton) {
        super.rightButtonsAction(sender: sender)
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.sourceType = .savedPhotosAlbum
        picker.delegate = self
        navigationController?.present(picker, animated: true, completion: nil)
    }

    func openurl(url: String) {
        guard URL.init(string: url) != nil else {
            self.view.makeToast("无效的二维码")
            navigationController?.popViewController(animated: true)
            return
        }
        if UIApplication.shared.canOpenURL(URL.init(string: url)!) == false {
            self.view.makeToast("无效的二维码")
            navigationController?.popViewController(animated: true)
            return
        }
        else{
            session.stopRunning()
            UIApplication.shared.openURL(URL.init(string: url)!)
            navigationController?.popViewController(animated: true)
        }
        
    }
    
    func validateTeamQRImageAndGetTeamId(qrString: String) -> Int {
        if qrString.contains(localShareURL) && qrString.contains("teamId") {
            let arr = qrString.components(separatedBy: "teamId=")
            if let tid = arr.last {
                return Int(tid) ?? 0
            }
            return 0
        }
        self.view.makeToast("不是团队二维码")
        return 0
    }
    
}


extension BXBQRScanVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
// Local variable inserted by Swift 4.2 migrator.
let info = convertFromUIImagePickerControllerInfoKeyDictionary(info)

        if let resultImage = info["UIImagePickerControllerOriginalImage"] {
            let img = resultImage as! UIImage
            navigationController?.dismiss(animated: true, completion: {
                let context = CIContext.init(options: nil)
                let detector = CIDetector.init(ofType: CIDetectorTypeQRCode, context: context, options: [CIDetectorAccuracy: CIDetectorAccuracyHigh])
                guard img.cgImage != nil else { return }
                let ciimg = CIImage.init(cgImage: img.cgImage!)
                let features = detector?.features(in: ciimg)
                guard let feature = features?.first else { return }
                let f = feature as! CIQRCodeFeature
                
//                self.openurl(url: f.messageString ?? "")
                let tid = self.validateTeamQRImageAndGetTeamId(qrString: f.messageString ?? "")
                if tid != 0 {
                    if self.teamId == tid {
                        self.view.makeToast("不能加入自己的团队")
                        return
                    }
                    let vc = BXBUserJoinTeamVC()
                    vc.teamId = tid
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            })
        }
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        navigationController?.dismiss(animated: true, completion: {
            self.navigationController?.popViewController(animated: true)
        })
    }
    
}


extension BXBQRScanVC: AVCaptureMetadataOutputObjectsDelegate {
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        if metadataObjects.count > 0 {
            guard let obj = metadataObjects.first else {
                print("无扫描信息")
                return
            }
            let metadata = obj as! AVMetadataMachineReadableCodeObject
            guard let res = metadata.stringValue else {
                print("无扫描信息")
                return
            }
            
            let tid = self.validateTeamQRImageAndGetTeamId(qrString: res)
            if tid != 0 {
                if teamId == tid {
                    view.makeToast("不能加入自己的团队")
                    return
                }
                session.stopRunning()
                //播放音效
                AudioServicesPlaySystemSound(SystemSoundID.init(1007))
                let vc = BXBUserJoinTeamVC()
                vc.teamId = tid
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
}


// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKeyDictionary(_ input: [UIImagePickerController.InfoKey: Any]) -> [String: Any] {
	return Dictionary(uniqueKeysWithValues: input.map {key, value in (key.rawValue, value)})
}
