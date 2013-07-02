//
//  RecordAudio.h
//  JuuJuu
//
//  Created by xiaoguang huang on 11-12-19.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <CoreAudio/CoreAudioTypes.h>


@protocol RecordAudioDelegate;


@interface RecordAudio : NSObject <AVAudioRecorderDelegate,AVAudioPlayerDelegate>
{
	AVAudioRecorder *_recorder;
	NSError         * _error;
    AVAudioPlayer   *_avPlayer;
    NSTimer         *_levelTimer;
}

@property (nonatomic, assign) id<RecordAudioDelegate> delegate;
@property (nonatomic, retain) NSString *audioSavePath;



- (void) stopRecord;
- (BOOL) startRecord;
- (BOOL) startPlay;
- (void) stopPlay;

-(CGFloat)playDuration:(NSData *)data;
- (NSTimeInterval) getRecordAudioTime;
+ (NSData *)decodeWavToAMR:(NSString *)wavFilePath;
+ (NSData *)decodeAMRToWav:(NSString *)amrFilePath;





@end

@protocol RecordAudioDelegate <NSObject>
@optional

- (void)recordAudio:(AVAudioRecorder *)recorder didFinishRecord:(BOOL)finish error:(NSError *)error;
- (void)recordAudioDidFinishPlay:(BOOL)finish error:(NSError *)error;
- (void)recordAudioDidUpdateAveragePower:(AVAudioRecorder *)recorder;

-(void)recordAudioDidStopAnimation:(BOOL)flag;


@end