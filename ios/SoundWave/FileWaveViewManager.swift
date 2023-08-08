//
//  FileWaveViewManager.swift
//  AwesomeProject
//
//  Created by Viraj Patel on 31/12/21.
//

import Foundation
import AVKit
import AVFoundation

@objc(AudioPlayerWaveformView)
class RCTFileWaveView: RCTViewManager {
  
  private var chronometer: Chronometer?

  var audioPlayer: AVAudioPlayer?
  var audioVisualizationView: AudioVisualizationView!
  var audioVisualizationTimeInterval: TimeInterval = 0.2
  var audioManager: AudioManager = AudioManager.sharedInstance
  var fileUrl: URL?

  override func view() -> AudioVisualizationView? {
    audioVisualizationView = AudioVisualizationView(frame: CGRect(x: 0.0, y: 0.0, width: 700.0, height: 100))
    audioVisualizationView.backgroundColor = .white
    NotificationCenter.default.addObserver(self, selector: #selector(didReceiveMeteringLevelUpdate),
                                           name: .audioPlayerManagerMeteringLevelDidUpdateNotification, object: nil)
    NotificationCenter.default.addObserver(self, selector: #selector(didReceiveMeteringLevelUpdate),
                                           name: .audioRecorderManagerMeteringLevelDidUpdateNotification2, object: nil)
    return audioVisualizationView
  }
  
  override static func requiresMainQueueSetup() -> Bool {
    return true
  }
  
  @objc(play:)
  func play(callback: @escaping RCTResponseSenderBlock) -> Void {
    print("play(_ node: NSNumber")
    guard let fileUrl = fileUrl else {
      return
    }
    DispatchQueue.main.async {
      let audioAsset = AVURLAsset.init(url: fileUrl, options: nil)
      let duration = audioAsset.duration
      let durationInSeconds = CMTimeGetSeconds(duration)
      self.audioVisualizationView.play(for: TimeInterval(durationInSeconds))
    }
    do {
            audioPlayer = try AVAudioPlayer(contentsOf: fileUrl)
            audioPlayer?.prepareToPlay()
            audioPlayer?.play()
            
        } catch {
            print("Error playing audio: \(error.localizedDescription)")
        }
  }
  
  @objc(start:)
  func start(callback: @escaping RCTResponseSenderBlock) -> Void {
    print("start(_ node: NSNumber")
    
    let resultsDict = ["success" : true, "message": "Audio Started", "isPlay": "self.audioManager.isRecording()"] as [String : Any];
    DispatchQueue.main.async {
      self.audioVisualizationView.audioVisualizationMode = .write
    }
    
//    self.audioManager.startRecording { (url, error) in
//      let resultsDict = ["success" : true, "message": "Audio Started", "isPlay": self.audioManager.isRecording(), "url": url?.absoluteString] as [String : Any];
//      callback([NSNull() ,resultsDict])
//      self.chronometer = Chronometer()
//      self.chronometer?.start()
//    }
  }
  
  // MARK: - Notifications Handling

  @objc private func didReceiveMeteringLevelUpdate(_ notification: Notification) {
      let percentage = notification.userInfo![audioPercentageUserInfoKey] as! Float
    DispatchQueue.main.async {
      if self.audioVisualizationView.audioVisualizationMode == .read {
        self.audioVisualizationView.audioVisualizationMode = .write
      }
      self.audioVisualizationView.add(meteringLevel: percentage)
    }
      
//      self.audioMeteringLevelUpdate?(percentage)
  }
  
  @objc(stop:)
  func stop(callback: RCTResponseSenderBlock) -> Void {
    print("stop(_ node: NSNumber")
    DispatchQueue.main.async {
      self.audioVisualizationView.stop()
    }
    let resultsDict = ["success" : true] as [String : Any];
    callback([NSNull() ,resultsDict])
  }
  
  @objc(pause:)
  func pause(callback: RCTResponseSenderBlock) -> Void {
    print("pause(_ node: NSNumber")
    DispatchQueue.main.async {
      self.audioVisualizationView.pause()
    }
    let resultsDict = ["success" : true] as [String : Any];
    callback([NSNull() ,resultsDict])
//    DispatchQueue.main.async {
//      self.audioVisualizationView.pause()
//    }
//    let resultsDict = ["success" : true, "message": "Audio Pause"] as [String : Any];
//    callback([NSNull() ,resultsDict])
  }
  
  @objc(reset:)
  func reset(callback: RCTResponseSenderBlock) -> Void {
    DispatchQueue.main.async {
      self.audioVisualizationView.reset()
    }
  }
  
  @objc(setUrl:)
  func setUrl(_ url: NSString) -> Void {
    print("url... \(url)")
    if url != "" {
      DispatchQueue.main.async {
        self.audioVisualizationView.audioVisualizationMode = .read
  //      guard url != "" else {
  //        self.audioVisualizationView.meteringLevels = []
  //        return
  //      }
        // This works
        
        let strif = url.replacingOccurrences(of: "file://", with: "")
        self.fileUrl = URL(fileURLWithPath: strif as String)
        self.audioVisualizationView.audioContextLoad(from: URL(fileURLWithPath: strif as String))
      }
    }
  }
  
  @objc(setLevels:)
  func setLevels(_ meteringLevels: NSArray) -> Void {
    print("setLevels... \(meteringLevels)")
    DispatchQueue.main.async {
      // This works
      let x = meteringLevels.map { ($0 as AnyObject).floatValue! }
      self.audioVisualizationView.meteringLevels = x
    }
  }
  
}
