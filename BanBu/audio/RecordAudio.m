//
//  RecordAudio.m
//  JuuJuu
//
//  Created by xiaoguang huang on 11-12-19.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "RecordAudio.h"
#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>
#import "amrFileCodec.h"
#import "AppDataManager.h"

@implementation RecordAudio

- (void)dealloc
{
    [_audioSavePath release];
   if(_recorder.recording)
    {
        _recorder.delegate = nil;
        [_recorder stop];
        [_recorder release];
        _recorder = nil;
    }
    if(_avPlayer.playing)
    {
        _avPlayer.delegate = nil;
        [_avPlayer stop];
        [_avPlayer release];
        _avPlayer = nil;
    }
   
    [super dealloc];
}

-(id)init {
   
    self = [super init];
    if (self) {

        AVAudioSession * audioSession = [AVAudioSession sharedInstance];
        [audioSession setCategory:AVAudioSessionCategoryPlayAndRecord error: &_error];
        UInt32 audioRouteOverride = kAudioSessionOverrideAudioRoute_Speaker;
        AudioSessionSetProperty (kAudioSessionProperty_OverrideAudioRoute,
								 sizeof (audioRouteOverride),
								 &audioRouteOverride);
        [audioSession setActive:YES error: &_error];
    }
    return self;
}

-(BOOL) startRecord
{
    
    NSDictionary *recordSetting = [NSDictionary dictionaryWithObjectsAndKeys:
                                   [NSNumber numberWithInt:kAudioFormatLinearPCM], AVFormatIDKey,
                                   //[NSNumber numberWithFloat:44100.0], AVSampleRateKey,
                                   [NSNumber numberWithFloat:8000.00], AVSampleRateKey,
                                   [NSNumber numberWithInt:1], AVNumberOfChannelsKey,
                                   //  [NSData dataWithBytes:&channelLayout length:sizeof(AudioChannelLayout)], AVChannelLayoutKey,
                                   [NSNumber numberWithInt:16], AVLinearPCMBitDepthKey,
                                   [NSNumber numberWithBool:NO], AVLinearPCMIsNonInterleaved,
                                   [NSNumber numberWithBool:NO],AVLinearPCMIsFloatKey,
                                   [NSNumber numberWithBool:NO], AVLinearPCMIsBigEndianKey,
                                   [NSNumber numberWithInt:AVAudioQualityMedium], AVEncoderAudioQualityKey,
                                   nil];
    
    
    if(!_audioSavePath)
    {
        //NSLog(@"save path is nil");
        return NO;
    }
    
    
    _recorder = [[ AVAudioRecorder alloc] initWithURL:[NSURL fileURLWithPath:_audioSavePath] settings:recordSetting error:&_error];
    _recorder.meteringEnabled = YES;
    _levelTimer = [NSTimer scheduledTimerWithTimeInterval: 0.1 target: self
                                                 selector: @selector(levelTimerCallback:) userInfo: nil repeats: YES];
    [[NSRunLoop mainRunLoop] addTimer:_levelTimer forMode:NSDefaultRunLoopMode];
    [_recorder setDelegate:self];
    [_recorder prepareToRecord];
    return [_recorder record];
}

- (void)levelTimerCallback:(NSTimer *)timer {
    
    [_recorder updateMeters];
    //NSLog(@"Average input: %f Peak input: %f",
     //     [_recorder averagePowerForChannel:0], [_recorder peakPowerForChannel:0]);
    if([_delegate respondsToSelector:@selector(recordAudioDidUpdateAveragePower:)])
        [_delegate recordAudioDidUpdateAveragePower:_recorder];
}

- (void) stopRecord {
   
    if(_recorder.recording)
    {
        [_recorder setDelegate:nil];
        [_recorder stop];
        [_recorder release];
        _recorder =nil;
        [_levelTimer invalidate];
        _levelTimer = nil;
    }
   
}


- (NSTimeInterval) getRecordAudioTime
{
    return _recorder.currentTime;
}

- (BOOL)startPlay
{
    if(MyAppDataManager.playert&&[MyAppDataManager.playert play])
    {
        [MyAppDataManager.playert stop];
        
        [MyAppDataManager.playert setDelegate:nil];
        
        [MyAppDataManager.playert release];
        
        [_delegate recordAudioDidStopAnimation:YES];
       
        
        
    }
    NSData *audioData = [NSData dataWithContentsOfFile:_audioSavePath];
    
    _avPlayer = [[AVAudioPlayer alloc] initWithData:audioData error:&_error];
    
    MyAppDataManager.playert=[_avPlayer retain];
    
    _avPlayer.delegate = self;
	[_avPlayer prepareToPlay];
    [_avPlayer setVolume:1.0];
    
     
    return [_avPlayer play];
}

-(CGFloat)playDuration:(NSData *)data
{
    if(data)
    {
    
   _avPlayer = [[AVAudioPlayer alloc] initWithData:data error:&_error] ;

    return _avPlayer.duration;
    }
    return .0;
}

- (void)stopPlay
{
    [MyAppDataManager.valueArr removeAllObjects];
    
    if (_avPlayer.playing)
    {
        [_avPlayer setDelegate:nil];
        [_avPlayer stop];
        [_avPlayer release];
        _avPlayer = nil;
    }
}


#pragma methods

//record
- (void)audioRecorderDidFinishRecording:(AVAudioRecorder *)recorder successfully:(BOOL)flag
{
    if([_delegate respondsToSelector:@selector(recordAudio:didFinishRecord:error:)])
        [_delegate recordAudio:_recorder didFinishRecord:flag error:nil];
}

- (void)audioRecorderEncodeErrorDidOccur:(AVAudioRecorder *)recorder error:(NSError *)error
{
    [_recorder release];
    _recorder =nil;
    [_levelTimer invalidate];
    _levelTimer = nil;
    
    if([_delegate respondsToSelector:@selector(recordAudio:didFinishRecord:error:)])
        [_delegate recordAudio:nil didFinishRecord:NO error:error];

}

//play

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    if([_delegate respondsToSelector:@selector(recordAudioDidFinishPlay:error:)])
        [_delegate recordAudioDidFinishPlay:flag error:nil];
}

- (void)audioPlayerDecodeErrorDidOccur:(AVAudioPlayer *)player error:(NSError *)error
{

    [_avPlayer release];
    _avPlayer = nil;
    
    if([_delegate respondsToSelector:@selector(recordAudioDidFinishPlay:error:)])
        [_delegate recordAudioDidFinishPlay:NO error:error];
    
}



+ (NSData *)decodeAMRToWav:(NSString *)amrFilePath
{
    if (!amrFilePath)
        return nil;

    NSData *amrData = [NSData dataWithContentsOfFile:amrFilePath];
    return DecodeAMRToWAVE(amrData);
}

+ (NSData *)decodeWavToAMR:(NSString *)wavFilePath;
{
    if (!wavFilePath)
        return nil;
    
    NSData *wavData = [NSData dataWithContentsOfFile:wavFilePath];
    return EncodeWAVEToAMR(wavData, 1, 16);
}


@end
