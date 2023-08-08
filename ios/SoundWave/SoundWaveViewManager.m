//
//  SoundWaveViewManager.m
//  AwesomeProject
//
//  Created by Viraj Patel on 28/07/21.
//

#import <Foundation/Foundation.h>
#import <React/RCTBridgeModule.h>
#import <React/RCTViewManager.h>
#import <React/RCTUIManager.h>

@interface RCT_EXTERN_MODULE(SoundWaveView, RCTViewManager)

RCT_EXPORT_VIEW_PROPERTY(waveWidth, int)
RCT_EXPORT_VIEW_PROPERTY(gap, int)
RCT_EXPORT_VIEW_PROPERTY(radius, int)
RCT_EXPORT_VIEW_PROPERTY(progressColor, NSString)
RCT_EXPORT_VIEW_PROPERTY(bgClor, NSString)
RCT_EXPORT_VIEW_PROPERTY(isDrawSilencePadding, BOOL)
RCT_EXPORT_VIEW_PROPERTY(minHeight, double)

RCT_EXTERN_METHOD(start:(RCTResponseSenderBlock)callback)
RCT_EXTERN_METHOD(stop:(RCTResponseSenderBlock)callback)
RCT_EXTERN_METHOD(pause:(RCTResponseSenderBlock)callback)
RCT_EXTERN_METHOD(reset:(RCTResponseSenderBlock)callback)
RCT_EXTERN_METHOD(askAudioRecordingPermission:(RCTResponseSenderBlock)callback)
RCT_EXTERN_METHOD(setLevels:(NSArray)meteringLevels)
RCT_EXTERN_METHOD(setUrl:(NSString)url)

RCT_EXPORT_VIEW_PROPERTY(onProgress, RCTDirectEventBlock)
RCT_EXPORT_VIEW_PROPERTY(onStarted, RCTDirectEventBlock)
RCT_EXPORT_VIEW_PROPERTY(onFinished, RCTDirectEventBlock)
RCT_EXPORT_VIEW_PROPERTY(onPause, RCTDirectEventBlock)
RCT_EXPORT_VIEW_PROPERTY(onSilentDetected, RCTDirectEventBlock)
RCT_EXPORT_VIEW_PROPERTY(onBuffer, RCTDirectEventBlock)
RCT_EXPORT_VIEW_PROPERTY(onError, RCTDirectEventBlock)

@end

@interface RCT_EXTERN_MODULE(AudioPlayerWaveformView, RCTViewManager)

RCT_EXPORT_VIEW_PROPERTY(waveWidth, int)
RCT_EXPORT_VIEW_PROPERTY(gap, int)
RCT_EXPORT_VIEW_PROPERTY(radius, int)
RCT_EXPORT_VIEW_PROPERTY(progressColor, NSString)
RCT_EXPORT_VIEW_PROPERTY(bgClor, NSString)
RCT_EXPORT_VIEW_PROPERTY(isDrawSilencePadding, BOOL)
RCT_EXPORT_VIEW_PROPERTY(minHeight, double)

RCT_EXTERN_METHOD(start:(RCTResponseSenderBlock)callback)
RCT_EXTERN_METHOD(stop:(RCTResponseSenderBlock)callback)
RCT_EXTERN_METHOD(pause:(RCTResponseSenderBlock)callback)
RCT_EXTERN_METHOD(reset:(RCTResponseSenderBlock)callback)
RCT_EXTERN_METHOD(setUrl:(NSString)url)
RCT_EXTERN_METHOD(play:(RCTResponseSenderBlock)callback)

RCT_EXPORT_VIEW_PROPERTY(onProgress, RCTDirectEventBlock)
RCT_EXPORT_VIEW_PROPERTY(onStarted, RCTDirectEventBlock)
RCT_EXPORT_VIEW_PROPERTY(onFinished, RCTDirectEventBlock)
RCT_EXPORT_VIEW_PROPERTY(onPause, RCTDirectEventBlock)
RCT_EXPORT_VIEW_PROPERTY(onSilentDetected, RCTDirectEventBlock)
RCT_EXPORT_VIEW_PROPERTY(onBuffer, RCTDirectEventBlock)
RCT_EXPORT_VIEW_PROPERTY(onError, RCTDirectEventBlock)

@end

