//
//  AmrRecorder.m
//  aaaa
//
//  Created by Andrew on 2017/7/17.
//  Copyright © 2017年 Andrew. All rights reserved.
//

#import "DPAudioRecorder.h"
#import "DPAudioPlayer.h"
#import <AVFoundation/AVFoundation.h>
#import <UIKit/UIKit.h>
#import "JX_GCDTimerManager.h"
#import "amr_wav_converter.h"

#define MAX_RECORDER_TIME 60
#define MIN_RECORDER_TIME 1

#define TimerName @"audioTimer_999"

@interface DPAudioRecorder () <AVAudioRecorderDelegate>
{
    BOOL isRecording;
    dispatch_source_t timer;
    NSUInteger __block audioTimeLength; //录音时长
}

@property (nonatomic, strong) AVAudioRecorder *audioRecorder;

@end

@implementation DPAudioRecorder

static DPAudioRecorder *recorderManager = nil;
+ (DPAudioRecorder *)sharedInstance
{
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken,^{
        recorderManager = [[DPAudioRecorder alloc] init];
    });
    
    return recorderManager;
}

- (instancetype)init
{
    if (self = [super init]) {
        //创建缓存录音文件到Tmp
        NSString *wavRecordFilePath = [NSTemporaryDirectory()stringByAppendingPathComponent:@"WAVtemporaryRadio.wav"];
        NSString *amrRecordFilePath = [NSTemporaryDirectory() stringByAppendingPathComponent:@"AMRtemporaryRadio.amr"];

        if (![[NSFileManager defaultManager]fileExistsAtPath:wavRecordFilePath]) {
            [[NSData data] writeToFile:wavRecordFilePath atomically:YES];
        }
        if (![[NSFileManager defaultManager]fileExistsAtPath:amrRecordFilePath]) {
            [[NSData data] writeToFile:amrRecordFilePath atomically:YES];
        }
    }
    return self;
}

- (void)startRecording
{
    if (isRecording) return;
    
    [[DPAudioPlayer sharedInstance]stopPlaying];
    //开始录音
    [[AVAudioSession sharedInstance] setCategory: AVAudioSessionCategoryPlayAndRecord error:nil];
    [[AVAudioSession sharedInstance] setActive:YES error:nil];

    [self.audioRecorder prepareToRecord];
    
    [self.audioRecorder record];
    
    if ([self.audioRecorder isRecording]) {
        isRecording = YES;
        [self activeTimer];
        if (self.audioStartRecording) {
            self.audioStartRecording(YES);
        }
    } else {
        if (self.audioStartRecording) {
            self.audioStartRecording(NO);
        }
    }
    
    
    [self createPickSpeakPowerTimer];
}

- (void)stopRecording;
{
    if (!isRecording) return;
    
    [self shutDownTimer];
    [self.audioRecorder stop];
    self.audioRecorder = nil;
}

- (void)activeTimer
{
    //录音时长
    audioTimeLength = 0;
    
    [[JX_GCDTimerManager sharedInstance]scheduledDispatchTimerWithName:TimerName timeInterval:1 queue:nil repeats:YES actionOption:AbandonPreviousAction action:^{
        audioTimeLength ++;
        if (audioTimeLength >= 60) { //大于等于60秒停止
            [self stopRecording];
        }
    }];
}

- (void)shutDownTimer
{
    [[JX_GCDTimerManager sharedInstance] cancelAllTimer];//定时器停止
}

- (AVAudioRecorder *)audioRecorder
{
    if (!_audioRecorder) {
        
        //暂存录音文件路径
        NSString *wavRecordFilePath = [NSTemporaryDirectory()stringByAppendingPathComponent:@"WAVtemporaryRadio.wav"];
        
        NSDictionary *recordSetting = @{ AVSampleRateKey        : @8000.0,                      // 采样率
                                         AVFormatIDKey          : @(kAudioFormatLinearPCM),     // 音频格式
                                         AVLinearPCMBitDepthKey : @16,                          // 采样位数 默认 16
                                         AVNumberOfChannelsKey  : @1                            // 通道的数目
                                         };
        
        _audioRecorder = [[AVAudioRecorder alloc] initWithURL:[NSURL URLWithString:wavRecordFilePath] settings:recordSetting error:nil];
        _audioRecorder.delegate = self;
        _audioRecorder.meteringEnabled = YES;
    }
    return _audioRecorder;
}

#pragma mark - AVAudioRecorder

- (void)audioRecorderDidFinishRecording:(AVAudioRecorder *)recorder successfully:(BOOL)flag
{
    //暂存录音文件路径
    NSString *wavRecordFilePath = [NSTemporaryDirectory() stringByAppendingPathComponent:@"WAVtemporaryRadio.wav"];
    NSString *amrRecordFilePath = [NSTemporaryDirectory() stringByAppendingPathComponent:@"AMRtemporaryRadio.amr"];
    
    //重点:把wav录音文件转换成amr文件,用于网络传输.amr文件大小是wav文件的十分之一左右
    wave_file_to_amr_file([wavRecordFilePath cStringUsingEncoding:NSUTF8StringEncoding],[amrRecordFilePath cStringUsingEncoding:NSUTF8StringEncoding], 1, 16);
    
    //返回amr音频文件Data,用于传输或存储
    NSData *cacheAudioData = [NSData dataWithContentsOfFile:amrRecordFilePath];
    
    //大于最小录音时长时,发送数据
    if (audioTimeLength > MIN_RECORDER_TIME) {
        if (self.audioRecorderFinishRecording) {
            self.audioRecorderFinishRecording(cacheAudioData, audioTimeLength);
        }
    } else {
        if (self.audioRecordingFail) {
            self.audioRecordingFail([NSString stringWithFormat:@"录音时长不能小于%ds", MIN_RECORDER_TIME]);
        }
    }
    
    isRecording = NO;
    
    //取消定时器
    if (timer) {
        dispatch_source_cancel(timer);
        timer = NULL;
    }
    
}

//音频值测量
- (void)createPickSpeakPowerTimer
{
    timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_main_queue());
    dispatch_source_set_timer(timer, DISPATCH_TIME_NOW, 0.01 * NSEC_PER_SEC, 1ull * NSEC_PER_SEC);
    
    __weak __typeof(self) weakSelf = self;
    
    dispatch_source_set_event_handler(timer, ^{
        __strong __typeof(weakSelf) _self = weakSelf;
        
        [_self->_audioRecorder updateMeters];
        double lowPassResults = pow(10, (0.05 * [_self->_audioRecorder peakPowerForChannel:0]));
        if (_self.audioSpeakPower) {
            _self.audioSpeakPower(lowPassResults);
        }
    });
    
    dispatch_resume(timer);
}

- (void)dealloc
{
    if (isRecording) [self.audioRecorder stop];
     [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
