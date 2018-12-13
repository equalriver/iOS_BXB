//
//  BXBSpeech.swift
//  BXB
//
//  Created by equalriver on 2018/7/11.
//  Copyright © 2018年 tobosoft. All rights reserved.
//

import Foundation
import Speech


@available(iOS 10.0, *)
class BXBSpeech: UIView {
    
    typealias showCallback = () -> Void
    var showHandle: showCallback!
    
    
    lazy var recognizer: SFSpeechRecognizer? = {
        let cale = Locale.init(identifier: "zh-CN")
        let r = SFSpeechRecognizer.init(locale: cale)
        r?.delegate = self
        return r
    }()
    
    var recognitionTask: SFSpeechRecognitionTask?
    
    var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    
    ///创建录音引擎
    let audioEngine = AVAudioEngine.init()
    
    lazy var speakingIV: UIImageView = {
        let iv = UIImageView.init(image: #imageLiteral(resourceName: "voice_input"))
        iv.isHidden = true
        return iv
    }()
    
    let maskLayer = CAShapeLayer()
    
    lazy var contentView: UIView = {
        let v = UIView.init(frame: CGRect.init(x: 0, y: kScreenHeight, width: kScreenWidth, height: speechContentHeight))
        v.backgroundColor = UIColor.white
        return v
    }()
    lazy var removeBtn: UIButton = {
        let b = UIButton()
        b.setImage(#imageLiteral(resourceName: "agenda_收起"), for: .normal)
        return b
    }()
    lazy var speechIV: UIImageView = {
        let b = UIImageView()
        b.image = #imageLiteral(resourceName: "voice_语音")
        b.isUserInteractionEnabled = true
        return b
    }()
    lazy var titleLabel: UILabel = {
        let l = UILabel()
        l.font = kFont_text
        l.textColor = kColor_text
        l.text = "按住说话"
        l.textAlignment = .center
        return l
    }()
    
    convenience init(frame: CGRect, showHandle: @escaping () -> Void, dismissHandle: @escaping () -> Void) {
        self.init(frame: frame)
        self.showHandle = showHandle
        initUI()
        removeBtn.addBlock(for: .touchUpInside, block: { [unowned self](btn) in
            self.contentView.viewAnimateDismissFromBottom(duration: 0.5, completion: { (isFinish) in
                if isFinish {
                    dismissHandle()
                    self.removeFromSuperview()
                }
            })
        })
        let tap = UITapGestureRecognizer.init { [weak self](ges) in
            dismissHandle()
            self?.removeFromSuperview()
        }
        tap.delegate = self
        addGestureRecognizer(tap)
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let maskPath = UIBezierPath.init(roundedRect: contentView.bounds, byRoundingCorners: [.topLeft, .topRight], cornerRadii: CGSize.init(width: 5, height: 5))
        
        maskLayer.strokeColor = UIColor.white.cgColor
        maskLayer.frame = contentView.bounds
        maskLayer.path = maskPath.cgPath
        contentView.layer.mask = maskLayer
        contentView.viewAnimateComeFromBottom(duration: 0.5) { (isFinish) in
            if self.showHandle != nil { self.showHandle() }
        }
    }
    
    private func initUI() {
        self.backgroundColor = UIColor.clear
        self.tag = speechViewTag
        
        self.addSubview(contentView)
        self.addSubview(speakingIV)
        contentView.addSubview(removeBtn)
        contentView.addSubview(speechIV)
        contentView.addSubview(titleLabel)
        removeBtn.snp.makeConstraints { (make) in
            make.size.equalTo(CGSize.init(width: kScreenWidth / 2, height: 50 * KScreenRatio_6))
            make.centerX.top.equalTo(contentView)
        }
        speakingIV.snp.makeConstraints { (make) in
            make.size.equalTo(CGSize.init(width: 100 * KScreenRatio_6, height: 100 * KScreenRatio_6))
            make.centerX.equalTo(self)
            make.top.equalTo(self).offset(200 * KScreenRatio_6)
        }
        titleLabel.snp.makeConstraints { (make) in
            make.centerX.width.equalTo(contentView)
            make.top.equalTo(removeBtn.snp.bottom).offset(25 * KScreenRatio_6)
        }
        speechIV.snp.makeConstraints { (make) in
            make.centerX.equalTo(contentView)
            make.top.equalTo(titleLabel.snp.bottom).offset(15 * KScreenRatio_6)
            make.size.equalTo(CGSize.init(width: 110 * KScreenRatio_6, height: 110 * KScreenRatio_6))
        }
        
        
    }

    public func showSpeechView(handle: @escaping (_ text: String) -> Void) {
        
        initUI()
        var voiceStr = ""
        
        ///发送语音认证请求
        SFSpeechRecognizer.requestAuthorization { (status) in
            switch status {
            case .authorized:
                let longPress = UILongPressGestureRecognizer.init { [unowned self](sender) in
                    let lp = sender as! UILongPressGestureRecognizer
                    
                    switch lp.state {
                    case .began://长按开始
                        voiceStr = ""
                        self.speakingIV.isHidden = false
                        self.speechIV.image = #imageLiteral(resourceName: "voice_语音")
                        self.titleLabel.text = "松开完成"
                        self.startRecording(handle: { (str) in
                            voiceStr = str
                        })
                        break
                        
                    case .ended://结束
                        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.3, execute: {
                            self.speakingIV.isHidden = true
                            if self.audioEngine.isRunning {
                                self.audioEngine.stop()
                                self.recognitionRequest?.endAudio()
                            }
                            self.speechIV.image = #imageLiteral(resourceName: "voice_语音")
                            self.titleLabel.text = "按住说话"
                            handle(voiceStr)
                        })
                        
                        break
                        
                    default: break
                    }
                }

                DispatchQueue.main.async {
                    self.speechIV.addGestureRecognizer(longPress)
                }
                
            default:
                SVProgressHUD.showInfo(withStatus: "未授权语音识别")
                return
            }
        }
        
    }
    
    
    //
    func startRecording(handle: @escaping (_ text: String) -> Void) {
        
        if recognitionTask != nil {
            recognitionTask?.cancel()
            recognitionTask = nil
        }
        guard recognizer != nil else { return }
        let audioSession = AVAudioSession.sharedInstance()
        
        do {
            try audioSession.setCategory(AVAudioSession.Category(rawValue: convertFromAVAudioSessionCategory(AVAudioSession.Category.record)), mode: AVAudioSession.Mode.default)
            try audioSession.setMode(AVAudioSession.Mode.measurement)
            try audioSession.setActive(true, options: AVAudioSession.SetActiveOptions.notifyOthersOnDeactivation)
            
            self.recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
            let inputNode = self.audioEngine.inputNode
            self.recognitionRequest!.shouldReportPartialResults = true
            //开始识别任务
            self.recognitionTask = self.recognizer!.recognitionTask(with: self.recognitionRequest!, resultHandler: { (result, error) in
                var isFinal = false
                if result != nil {
                    isFinal = result!.isFinal
                    //语音转文本
                    let str = result!.bestTranscription.formattedString
                    handle(str)
                    
                }
                if error != nil || isFinal {
                    self.audioEngine.stop()
                    inputNode.removeTap(onBus: 0)
                    self.recognitionRequest = nil
                    self.recognitionTask = nil
                }
                
            })
            
            let recordingFormat = inputNode.outputFormat(forBus: 0)
            inputNode.removeTap(onBus: 0)
            inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { (buffer, time) in
                self.recognitionRequest?.append(buffer)
            }
            self.audioEngine.prepare()
            try self.audioEngine.start()
            
        } catch {
            print("speech error: \(error)")
            SVProgressHUD.showInfo(withStatus: error.localizedDescription)
        }

    }
    
    
}

@available(iOS 10.0, *)
extension BXBSpeech: UIGestureRecognizerDelegate {
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if let v = touch.view {
            if v.width == kScreenWidth { return true }
        }
        return false
    }
    
}

@available(iOS 10.0, *)
extension BXBSpeech: SFSpeechRecognizerDelegate {
    
    func speechRecognizer(_ speechRecognizer: SFSpeechRecognizer, availabilityDidChange available: Bool) {
        
//        speechIV.isUserInteractionEnabled = available
        
    }
    
}












// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromAVAudioSessionCategory(_ input: AVAudioSession.Category) -> String {
	return input.rawValue
}
