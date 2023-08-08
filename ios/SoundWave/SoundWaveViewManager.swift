//
//  SoundWaveViewManager.swift
//
//

import Foundation
import AVKit

extension Notification.Name {
  static let audioPlayerManagerMeteringLevelDidUpdateNotification = Notification.Name("AudioPlayerManagerMeteringLevelDidUpdateNotification")
  static let audioPlayerManagerBufferDidUpdateNotification = Notification.Name("audioPlayerManagerBufferDidUpdateNotification")
  static let audioPlayerManagerMeteringLevelDidFinishNotification = Notification.Name("AudioPlayerManagerMeteringLevelDidFinishNotification")
}
let audioPercentageUserInfoKey = "percentage"
let bufferUserInfoKey = "buffer"

@objc(SoundWaveView)
class RCTSoundWaveView: RCTViewManager {
  var audioVisualizationView: WaveformLiveView!
  var audioVisualizationTimeInterval: TimeInterval = 0.05
  var audioManager: AudioManager = AudioManager.sharedInstance
  
  override func view() -> WaveformLiveView? {
    audioVisualizationView = WaveformLiveView(frame: CGRect(x: 0.0, y: 0.0, width: 700.0, height: 100.0))
    audioVisualizationView.backgroundColor = .white
    NotificationCenter.default.addObserver(self, selector: #selector(didBuffersUpdate),
                                           name: .audioPlayerManagerBufferDidUpdateNotification, object: nil)
    NotificationCenter.default.addObserver(self, selector: #selector(didReceiveMeteringLevelUpdate),
                                           name: .audioPlayerManagerMeteringLevelDidUpdateNotification, object: nil)
    NotificationCenter.default.addObserver(self, selector: #selector(didReceiveMeteringLevelUpdate),
                                           name: .audioRecorderManagerMeteringLevelDidUpdateNotification, object: nil)

    // notifications audio finished
    NotificationCenter.default.addObserver(self, selector: #selector(didFinishRecordOrPlayAudio),
                                           name: .audioPlayerManagerMeteringLevelDidFinishNotification, object: nil)
    NotificationCenter.default.addObserver(self, selector: #selector(didFinishRecordOrPlayAudio),
                                           name: .audioRecorderManagerMeteringLevelDidFinishNotification, object: nil)
    return audioVisualizationView
  }
  
  override static func requiresMainQueueSetup() -> Bool {
    return true
  }
  
  @objc(askAudioRecordingPermission:)
  func askAudioRecordingPermission(callback: @escaping RCTResponseSenderBlock) -> Void {
    self.audioManager.askPermission { (permission, error) in
      let resultsDict = ["success": permission, "message": "Ask Audio Recording Permission", "permission": permission] as [String : Any];
      callback([NSNull() ,resultsDict])
    }
  }
  
  @objc(setUrl:)
  func setUrl(_ url: NSString) -> Void {
    print("url... \(url)")
    let samplecount = self.audioVisualizationView.samples.count
    
    DispatchQueue.main.async {
//      guard url != "" else {
//        self.audioVisualizationView.meteringLevels = []
//        return
//      }
      // This works
      self.audioVisualizationView.reset()
      
      
//      waveformImageView.waveformAudioURL = URL(fileURLWithPath: strif as String)
//      DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+3) {
//        self.audioVisualizationView.playOnly(from: URL(fileURLWithPath: strif as String))
//      }
    }
    let strif = url.replacingOccurrences(of: "file://", with: "")
    let waveformAnalyzer = WaveformAnalyzer(audioAssetURL: URL(fileURLWithPath: strif as String))
    waveformAnalyzer?.samples(count: 200) { samples in
        print("so many samples: \(samples)")
      DispatchQueue.main.async {
        
        for sample in samples ?? [] {
          // Here we add the same sample 3 times to speed up the animation.
          // Usually you'd just add the sample once.
          self.audioVisualizationView.add(samples: [sample, sample])
        }
        
//        self.audioVisualizationView.add(samples: samples ?? [])
      }
    }
  }
  
  @objc(start:)
  func start(callback: @escaping RCTResponseSenderBlock) -> Void {
    print("start(_ node: NSNumber")
    if !self.audioManager.isRecording() {
      self.audioManager.startRecording { (url, error) in
        if let urldata = url {
          DispatchQueue.main.async {
            if let onStarted = self.audioVisualizationView.onStarted {
              onStarted(["message": "Audio Started", "fileUrl": self.audioManager.audioFile?.url.absoluteString ?? ""])
            }
          }
        } else {
          if let onError = self.audioVisualizationView.onError {
            onError(["message": "Audio Already Started"])
          }
        }
      }
    } else {
      if let onError = self.audioVisualizationView.onError {
        onError(["message": "Audio Already Started"])
      }
    }
//    DispatchQueue.main.async {
//      self.audioVisualizationView.configuration = self.audioVisualizationView.configuration.with(
//        style: .striped(.init(color: UIColor(hexString: self.audioVisualizationView.progressColor), width: CGFloat(self.audioVisualizationView.waveWidth), spacing: CGFloat(self.audioVisualizationView.gap)))
//      )
//    }
//    self.audioVisualizationView.audioVisualizationMode = .write

    
  }
  
  // MARK: - Notifications Handling
  @objc private func didBuffersUpdate(_ notification: Notification) {
    let buffer = notification.userInfo![bufferUserInfoKey] as! AVAudioPCMBuffer
    DispatchQueue.main.async {
      if let onBuffer = self.audioVisualizationView.onBuffer {
        onBuffer(["message": "onBuffer", "buffer": buffer])
      }
    }
  }
  
  @objc private func didReceiveMeteringLevelUpdate(_ notification: Notification) {
      let percentage = notification.userInfo![audioPercentageUserInfoKey] as! Float
      DispatchQueue.main.async {
        print("current power: \(percentage) dB")
        let linear = 1 - pow(5, percentage / 20)
        if percentage < -99 {
          if let onSilentDetected = self.audioVisualizationView.onSilentDetected {
            onSilentDetected(["message": "onSilentDetected"])
          }
        }
      // Here we add the same sample 3 times to speed up the animation.
      // Usually you'd just add the sample once.
      self.audioVisualizationView.add(samples: [linear, linear, linear, linear, linear, linear, linear])
//      self.audioVisualizationView.add(meteringLevel: percentage)
      }
//      self.audioMeteringLevelUpdate?(percentage)
  }

  @objc private func didFinishRecordOrPlayAudio(_ notification: Notification) {
//    self.audioVisualizationView.meteringLevels = self.audioVisualizationView.scaleSoundDataToFitScreen()
//    self.audioVisualizationView.audioVisualizationMode = .read
//    if let onAudioStoped = self.onFinished {
//      onAudioStoped(["message": "onAudioStoped", "imageData": "image", "fileUrl": self.audioManager.audioFile?.url.absoluteString ?? ""])
//    }
//      self.audioDidFinish?()
  }
  
  @objc(stop:)
  func stop(callback: RCTResponseSenderBlock) -> Void {
    print("stop(_ node: NSNumber")
//    let resultsDict = ["success" : true, "message": "Audio Stoped", "fileUrl": self.audioManager.audioFile?.url.absoluteString ?? ""] as [String : Any];
//    callback([NSNull() ,resultsDict])
    DispatchQueue.main.async {
      
      if let onFinished = self.audioVisualizationView.onFinished {
        onFinished(["message": "onAudioStoped", "fileUrl": self.audioManager.audioFile?.url.absoluteString ?? ""])
      }
      self.audioManager.stopRecording()
    }
  }
  
  @objc(pause:)
  func pause(callback: RCTResponseSenderBlock) -> Void {
    print("pause(_ node: NSNumber")
    DispatchQueue.main.async {
      self.audioManager.pauseRecording()
      if let onStarted = self.audioVisualizationView.onPause {
        onStarted(["message": "Audio Pause"])
      }
    }
//    let resultsDict = ["success" : true, "message": "Audio Pause"] as [String : Any];
//    callback([NSNull() ,resultsDict])
//    DispatchQueue.main.async {
//      self.audioVisualizationView.pause()
//    }
  }
  
  @objc(reset:)
  func reset(callback: RCTResponseSenderBlock) -> Void {
    DispatchQueue.main.async {
      self.audioVisualizationView.reset()
      if let onFinished = self.audioVisualizationView.onError {
        onFinished(["isReset": true, "message": "reset Clicked", "fileUrl": self.audioManager.audioFile?.url.absoluteString ?? ""])
      }
      self.audioManager.stopRecording()
    }
  }
  
  @objc(setLevels:)
  func setLevels(_ meteringLevels: NSArray) -> Void {
    print("setLevels... \(meteringLevels)")
    DispatchQueue.main.async {
      // This works
      let x = meteringLevels.map { ($0 as AnyObject).floatValue! }
      self.audioVisualizationView.add(samples: x)
    }
  }
  
}

// MARK: - UIColor
extension UIColor {
    
    convenience init(hexString: String) {
        let hex = hexString.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt64()
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(a) / 255)
    }
    
}// End of Extension
