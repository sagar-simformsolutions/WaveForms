import Foundation
import UIKit

/// Renders a live waveform everytime its `(0...1)`-normalized samples are changed.
public class WaveformLiveView: UIView {

  @objc var waveWidth: Int = 1 {
    didSet {
      self.configuration = self.configuration.with(
        style: .striped(.init(color: UIColor(hexString: self.progressColor), width: CGFloat(waveWidth), spacing: CGFloat(gap)))
      )
    }
  }
  @objc var gap: Int = 3 {
    didSet {
      self.configuration = self.configuration.with(
        style: .striped(.init(color: UIColor(hexString: self.progressColor), width: CGFloat(waveWidth), spacing: CGFloat(gap)))
      )
    }
  }
  @objc var radius: Int = 3 {
    didSet {
      
    }
  }
  
  @objc var progressColor: String = "white" {
    didSet {
      self.configuration = self.configuration.with(
        style: .striped(.init(color: UIColor(hexString: self.progressColor), width: CGFloat(waveWidth), spacing: CGFloat(gap)))
      )
    }
  }
  
  @objc var bgClor: String = "white" {
    didSet {
      self.backgroundColor = UIColor(hexString: bgClor)
    }
  }
  
  
  @objc var onStarted: RCTDirectEventBlock? = nil {
    didSet {
     // self.onAudioStarted = onStarted
    }
  }
  @objc var onProgress: RCTDirectEventBlock? = nil  {
    didSet {
     // onAudioBuffers = onProgress
    }
  }
  @objc var onFinished: RCTDirectEventBlock? = nil  {
    didSet {
     // onAudioStoped = onFinished
    }
  }
  @objc var onPause: RCTDirectEventBlock? = nil  {
    didSet {
     // onAudioStoped = onFinished
    }
  }
  @objc var onSilentDetected: RCTDirectEventBlock? = nil  {
    didSet {
     // onAudioStoped = onFinished
    }
  }
  @objc var onBuffer: RCTDirectEventBlock? = nil  {
    didSet {
     // onAudioStoped = onFinished
    }
  }
  @objc var onError: RCTDirectEventBlock? = nil  {
    didSet {
     // onAudioStoped = onFinished
    }
  }
  
  @objc var minHeight: Double = 0.95 {
    didSet {
      self.configuration = self.configuration.with(
        verticalScalingFactor: minHeight
      )
    }
  }
  
  @objc var isDrawSilencePadding: Bool = false {
      didSet {
        shouldDrawSilencePadding = isDrawSilencePadding
      }
  }
    /// Default configuration with dampening enabled.
    public static let defaultConfiguration = Waveform.Configuration(dampening: .init(percentage: 0.025, sides: .both))

    /// If set to `true`, a zero line, indicating silence, is being drawn while the received
    /// samples are not filling up the entire view's width yet.
    public var shouldDrawSilencePadding: Bool = false {
        didSet {
            sampleLayer.shouldDrawSilencePadding = shouldDrawSilencePadding
        }
    }

    public var configuration: Waveform.Configuration {
        didSet {
            sampleLayer.configuration = configuration
        }
    }

    /// Returns the currently used samples.
    public var samples: [Float] {
        sampleLayer.samples
    }

    private var sampleLayer: WaveformLiveLayer! {
        return layer as? WaveformLiveLayer
    }

    override public class var layerClass: AnyClass {
        return WaveformLiveLayer.self
    }

    public init(configuration: Waveform.Configuration = defaultConfiguration) {
        self.configuration = configuration
        super.init(frame: .zero)
        self.contentMode = .redraw
    }

    public override init(frame: CGRect) {
        self.configuration = Self.defaultConfiguration
        super.init(frame: frame)
        contentMode = .redraw
    }

    required init?(coder: NSCoder) {
        self.configuration = Self.defaultConfiguration
        super.init(coder: coder)
        contentMode = .redraw
    }

    /// The sample to be added. Re-draws the waveform with the pre-existing samples and the new one.
    /// Value must be within `(0...1)` to make sense (0 being loweset and 1 being maximum amplitude).
    public func add(sample: Float) {
        sampleLayer.add([sample])
    }

    /// The samples to be added. Re-draws the waveform with the pre-existing samples and the new ones.
    /// Values must be within `(0...1)` to make sense (0 being loweset and 1 being maximum amplitude).
    public func add(samples: [Float]) {
        sampleLayer.add(samples)
    }

    /// Clears the samples, emptying the waveform view.
    public func reset() {
        sampleLayer.reset()
    }
}

class WaveformLiveLayer: CALayer {
    @NSManaged var samples: [Float]

    private var lastNewSampleCount: Int = 0

    var configuration = WaveformLiveView.defaultConfiguration {
        didSet { contentsScale = configuration.scale }
    }

    var shouldDrawSilencePadding: Bool = false {
        didSet {
            waveformDrawer.shouldDrawSilencePadding = shouldDrawSilencePadding
            setNeedsDisplay()
        }
    }

    private let waveformDrawer = WaveformImageDrawer()

    override class func needsDisplay(forKey key: String) -> Bool {
        if key == #keyPath(samples) {
            return true
        }
        return super.needsDisplay(forKey: key)
    }

    override func draw(in context: CGContext) {
        super.draw(in: context)

        UIGraphicsPushContext(context)
        waveformDrawer.draw(waveform: samples, newSampleCount: lastNewSampleCount, on: context, with: configuration.with(size: bounds.size))
        UIGraphicsPopContext()
    }

    func add(_ newSamples: [Float]) {
        lastNewSampleCount = newSamples.count
        samples += newSamples
    }

    func reset() {
        lastNewSampleCount = 0
        samples = []
    }
}
