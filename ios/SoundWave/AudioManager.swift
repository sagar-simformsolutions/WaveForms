//
//  AudioManager.swift
//  AwesomeProject
//
//  Created by Viraj Patel on 28/07/21.
//

import Foundation
import UIKit
import AVFoundation
import Accelerate

extension Notification.Name {
    static let audioRecorderManagerMeteringLevelDidUpdateNotification = Notification.Name("AudioRecorderManagerMeteringLevelDidUpdateNotification")
  static let audioRecorderManagerMeteringLevelDidUpdateNotification2 = Notification.Name("AudioRecorderManagerMeteringLevelDidUpdateNotification2")
    static let audioRecorderManagerMeteringLevelDidFinishNotification = Notification.Name("AudioRecorderManagerMeteringLevelDidFinishNotification")
    static let audioRecorderManagerMeteringLevelDidFailNotification = Notification.Name("AudioRecorderManagerMeteringLevelDidFailNotification")
}

@objc(AudioManager)
class AudioManager: RCTEventEmitter {
  var settings: [String:Any]  {
    let format = self.audioEngine.inputNode.outputFormat(forBus: 0)
    let sampleRate = format.sampleRate
    return [AVFormatIDKey: kAudioFormatLinearPCM, AVLinearPCMBitDepthKey: 16, AVLinearPCMIsFloatKey: true, AVSampleRateKey: sampleRate, AVNumberOfChannelsKey: 1] as [String : Any]
  }
  @objc var onAudioStarted: RCTDirectEventBlock? = nil
  @objc var onAudioBuffers: RCTDirectEventBlock? = nil
  @objc var onAudioStoped: RCTDirectEventBlock? = nil
  @objc var onAudioPaused: RCTDirectEventBlock? = nil
  @objc var onBuffer: RCTDirectEventBlock? = nil
  
  var audioEngine = AVAudioEngine()
  private var renderTs: Double = 0
  private var averagePowerForChannel0: Float = 0
  private var averagePowerForChannel1: Float = 0
  let LEVEL_LOWPASS_TRIG:Float32 = 0.30
  private var recordingTs: Double = 0
  private var silenceTs: Double = 0
  var audioFile: AVAudioFile?
//  weak var delegate: RecorderViewControllerDelegate?
  public static let sharedInstance = AudioManager()
  var audioVisualizationView: AudioVisualizationView!
  var currentRecordPath: URL?
  
  // we need to override this method and
  // return an array of event names that we can listen to
  override func supportedEvents() -> [String]! {
    return ["onStartRecording", "onRunningWaveforms"]
  }
  
  func askPermission(with completion: @escaping (Bool?, Error?) -> Void) {
    let permission = AVAudioSession.sharedInstance().recordPermission
    switch permission {
    case .undetermined:
      AVAudioSession.sharedInstance().requestRecordPermission({ (result) in
        DispatchQueue.main.async {
          if result {
            completion(result, nil)
          }
        }
      })
      break
    case .granted:
      completion(true, nil)
      break
    case .denied:
      completion(false, nil)
      break
    }
  }
  
  // MARK:- Recording
  func startRecording(with completion: @escaping (URL?, Error?) -> Void) {
    if isRecording() {
      completion(nil, nil)
    }
    audioEngine = AVAudioEngine()
//    if let d = self.delegate {
//      d.didStartRecording()
//    }
    
    self.recordingTs = NSDate().timeIntervalSince1970
    self.silenceTs = 0
    
    do {
      let session = AVAudioSession.sharedInstance()
      try session.setCategory(.playAndRecord,
                              mode: AVAudioSession.Mode.default,
                              options: [.mixWithOthers, .allowBluetooth, .allowBluetoothA2DP, .defaultToSpeaker])
      try session.setActive(true, options: .notifyOthersOnDeactivation)
    } catch let error as NSError {
      print(error.localizedDescription)
      return
    }
    
    let inputNode = self.audioEngine.inputNode
    //        guard let format = self.format() else {
    //            return
    //        }
    let recordingFormat: AVAudioFormat = inputNode.outputFormat(forBus: 0)
    inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) {[weak self] (buffer, time) in
      guard let strongSelf = self else {
        return
      }
      buffer.frameLength = 2048
      guard let channelData = buffer.floatChannelData else {
        return
      }
      
      let channelDataValue = channelData.pointee
      // 4
      let channelDataValueArray = stride(
        from: 0,
        to: Int(buffer.frameLength),
        by: buffer.stride)
        .map { channelDataValue[$0] }
      
      // 5
      let rms = sqrt(channelDataValueArray.map {
        return $0 * $0
      }
                      .reduce(0, +) / Float(buffer.frameLength))
      
      // 6
      
      let avgPower = 20 * log10(rms)
      let percentage: Float = pow(10, (0.05 * avgPower))
      NotificationCenter.default.post(name: .audioRecorderManagerMeteringLevelDidUpdateNotification2, object: self, userInfo: [audioPercentageUserInfoKey: percentage])
      
//      let avgPower = 20 * log10(rms)
//      let percentage: Float = pow(10, (0.05 * avgPower))
//      print(percentage)
//      let linear = 1 - pow(10, Float(avgPower) / 20)
//      print(percentage)
//      NotificationCenter.default.post(name: .audioRecorderManagerMeteringLevelDidUpdateNotification2, object: self, userInfo: [audioPercentageUserInfoKey: linear])
      NotificationCenter.default.post(name: .audioPlayerManagerBufferDidUpdateNotification, object: self, userInfo: [bufferUserInfoKey: buffer])
      
      strongSelf.audioMetering(buffer: buffer)
    }
    
//    inputNode.installTap(onBus: 0, bufferSize: 1024, format: nil) { [weak self] (buffer, time) in
//      guard let `self` = self else {
//        return
//      }
//
//      guard let channelData = buffer.floatChannelData else {
//        return
//      }
//
//      let channelDataValue = channelData.pointee
//      // 4
//      let channelDataValueArray = stride(
//        from: 0,
//        to: Int(buffer.frameLength),
//        by: buffer.stride)
//        .map { channelDataValue[$0] }
//
//      // 5
//      let rms = sqrt(channelDataValueArray.map {
//        return $0 * $0
//      }
//      .reduce(0, +) / Float(buffer.frameLength))
//
//      // 6
//      let avgPower = 20 * log10(rms)
//      let percentage: Float = pow(10, (0.05 * avgPower))
//      print(percentage)
//      let linear = 1 - pow(10, Float(avgPower) / 20)
//      print(percentage)
//      NotificationCenter.default.post(name: .audioRecorderManagerMeteringLevelDidUpdateNotification, object: self, userInfo: [audioPercentageUserInfoKey: linear])
//
//      let write = true
//      if write {
//        if self.audioFile == nil {
//          self.audioFile = self.createAudioRecordFile()
//        }
//        if let f = self.audioFile {
//          do {
//            try f.write(from: buffer)
//          } catch let error as NSError {
//            print(error.localizedDescription)
//          }
//        }
//      }
//    }
    do {
      self.audioEngine.prepare()
      try self.audioEngine.start()
    } catch let error as NSError {
      print(error.localizedDescription)
      return
    }
    if let onAudioStarted = self.onAudioStarted {
      onAudioStarted(["message": "Image Saved", "imageData": "image"])
    }
    let notificationName = AVAudioSession.interruptionNotification
    NotificationCenter.default.addObserver(self, selector: #selector(handleRecording), name: notificationName, object: nil)
    completion(currentRecordPath, nil)
  }
  
  private func audioMetering(buffer:AVAudioPCMBuffer) {
    buffer.frameLength = 2048
    let inNumberFrames:UInt = UInt(buffer.frameLength)
    if buffer.format.channelCount > 0 {
      let samples = (buffer.floatChannelData![0])
      var avgValue:Float32 = 0
      vDSP_meamgv(samples,1 , &avgValue, inNumberFrames)
      var v:Float = -100
      if avgValue != 0 {
        v = 20.0 * log10f(avgValue)
      }
      self.averagePowerForChannel0 = (self.LEVEL_LOWPASS_TRIG*v) + ((1-self.LEVEL_LOWPASS_TRIG)*self.averagePowerForChannel0)
      self.averagePowerForChannel1 = self.averagePowerForChannel0
    }
    
    if buffer.format.channelCount > 1 {
      let samples = buffer.floatChannelData![1]
      var avgValue:Float32 = 0
      vDSP_meamgv(samples, 1, &avgValue, inNumberFrames)
      var v:Float = -100
      if avgValue != 0 {
        v = 20.0 * log10f(avgValue)
      }
      self.averagePowerForChannel1 = (self.LEVEL_LOWPASS_TRIG*v) + ((1-self.LEVEL_LOWPASS_TRIG)*self.averagePowerForChannel1)
    }
    NotificationCenter.default.post(name: .audioRecorderManagerMeteringLevelDidUpdateNotification, object: self, userInfo: [audioPercentageUserInfoKey: self.averagePowerForChannel1])
    
    let write = true
    if write {
      if self.audioFile == nil {
        self.audioFile = self.createAudioRecordFile()
      }
      if let f = self.audioFile {
        do {
          try f.write(from: buffer)
        } catch let error as NSError {
          print(error.localizedDescription)
        }
      }
    }
  }
  //MARK:- Actions
  @objc func handleRecording() {
      if !isRecording() {
          self.checkPermissionAndRecord()
      } else {
          self.stopRecording()
      }
  }
  
  // MARK:- Paths and files
  private func createAudioRecordPath() -> URL? {
      let format = DateFormatter()
      format.dateFormat="yyyy-MM-dd-HH-mm-ss-SSS"
      let currentFileName = "recording-\(format.string(from: Date()))" + ".wav"
      let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
      let url = documentsDirectory.appendingPathComponent(currentFileName)
      return url
  }
  
  private func createAudioRecordFile() -> AVAudioFile? {
      guard let path = self.createAudioRecordPath() else {
          return nil
      }
      self.currentRecordPath = path
      do {
          let file = try AVAudioFile(forWriting: path, settings: self.settings, commonFormat: .pcmFormatFloat32, interleaved: true)
          return file
      } catch let error as NSError {
          print(error.localizedDescription)
          return nil
      }
  }
  
  func pauseRecording() {
    self.audioEngine.pause()
    do {
      try AVAudioSession.sharedInstance().setActive(false)
    } catch  let error as NSError {
      print(error.localizedDescription)
      return
    }
  }
  
  func stopRecording() {
    if let onAudioStoped = self.onAudioStoped {
      onAudioStoped(["message": "Audio Started", "videoUrl": audioFile?.url ?? ""])
    }
    self.audioFile = nil
    self.audioEngine.inputNode.removeTap(onBus: 0)
    self.audioEngine.stop()
    do {
      try AVAudioSession.sharedInstance().setActive(false)
    } catch  let error as NSError {
      print(error.localizedDescription)
      return
    }
//    if let d = self.delegate {
//      d.didFinishRecording()
//    }
    NotificationCenter.default.removeObserver(self)
    NotificationCenter.default.post(name: .audioRecorderManagerMeteringLevelDidFinishNotification, object: self)
  }
  
  private func checkPermissionAndRecord() {
    let permission = AVAudioSession.sharedInstance().recordPermission
    switch permission {
    case .undetermined:
      AVAudioSession.sharedInstance().requestRecordPermission({ (result) in
        DispatchQueue.main.async {
          if result {
            self.startRecording { (url, error) in
              
            }
          }
        }
      })
      break
    case .granted:
      self.startRecording { (url, error) in
        
      }
      break
    case .denied:
      break
    }
  }
  
  func isRecording() -> Bool {
    if self.audioEngine.isRunning {
      return true
    }
    return false
  }
  
  private func format() -> AVAudioFormat? {
    let format = AVAudioFormat(settings: self.settings)
    return format
  }
  
}
