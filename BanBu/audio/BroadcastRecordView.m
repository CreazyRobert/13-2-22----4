
//
//  BroadcastRecordView.m
//  BanBu
//
//  Created by mac on 12-8-29.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "BroadcastRecordView.h"
#import "AppCommunicationManager.h"
#import "AppDataManager.h"

@implementation BroadcastRecordView
@synthesize timeLabel =_timeLabel;
@synthesize progressView =_progressView;
@synthesize delegate =_delegate;
@synthesize volumeView =_volumeView;
@synthesize audioPath =_audioPath;

-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        self.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.4];
        
        toggle = YES;
        UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _cancelBtn = cancelBtn;
        cancelBtn.frame = CGRectMake(107, 150, 105, 120);
        [cancelBtn setBackgroundImage:[UIImage imageNamed:@"icon_recording1.png"] forState:UIControlStateNormal];
        [cancelBtn addTarget:self action:@selector(startAndStop) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:cancelBtn];
        
        _timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 320, 320, 20)];
        _timeLabel.backgroundColor = [UIColor clearColor];
        _timeLabel.shadowColor = [UIColor blackColor];
        _timeLabel.shadowOffset = CGSizeMake(0, -1);
        _timeLabel.textAlignment = UITextAlignmentCenter;
        _timeLabel.textColor = [UIColor whiteColor];
        _timeLabel.font = [UIFont boldSystemFontOfSize:15];
        _timeLabel.text = @"0s";
        [self addSubview:_timeLabel];
        
        UIImageView *imageView =[[UIImageView alloc]initWithFrame:CGRectMake(0, __MainScreen_Height-232, 320, __MainScreen_Height)];
        imageView.image = [UIImage imageNamed:@"record_volume_1.png"];
        [self insertSubview:imageView atIndex:0];
        self.volumeView = imageView;
        [imageView release];
        
        _progressView = [[UIImageView alloc]initWithFrame:CGRectMake(0, self.bounds.size.height-5, 4, 5)];
        _progressView.image = [UIImage imageNamed:@"record_time_status.png"];
        [self addSubview:_progressView];
        
    }
    return self;
}

-(void)cancelRecord{
    _recorder.delegate = nil;
    [_recorder stopRecord];
    [FileManager removeItemAtPath:_recorder.audioSavePath error:nil];
    [_recorder release];
    _recorder = nil;
    
    [UIView animateWithDuration:0.5 animations:^{
        self.alpha = 0.0;
    } completion:^(BOOL finished){
        [self removeFromSuperview];
    }];
    
     
}

//开始、结束录音
-(void)startAndStop{
    if(toggle){
        toggle = NO;
        [_cancelBtn setBackgroundImage:[UIImage imageNamed:@"icon_cancel1.png"] forState:UIControlStateNormal];
        RecordAudio *recorder = [[RecordAudio alloc]init];
        _recorder = recorder;
        recorder.audioSavePath =_audioPath;
        recorder.delegate = self;
        [recorder startRecord];
    }else{
        toggle = YES;
        [self completeRecord];
    }
        
}

//录音完成
-(void)completeRecord{
    //将录音转成通用的AMR格式
    NSData *voiceData = [RecordAudio decodeWavToAMR:_recorder.audioSavePath];
    float runtime = [_recorder getRecordAudioTime];
    [_recorder stopRecord];
    [_recorder release];
    _recorder = nil;
    [UIView animateWithDuration:0.5 animations:^{self.alpha = 0.0;} completion:^(BOOL finished){
            [self removeFromSuperview];
            //调用上传音频文件方法
            if([_delegate respondsToSelector:@selector(recordView:recordDidCompleted:recordTime:)]){
                [_delegate recordView:self recordDidCompleted:voiceData recordTime:runtime];
            }
    }];
}

#pragma mark - RecordAudio Delegate Methods

-(void)recordAudioDidUpdateAveragePower:(AVAudioRecorder *)recorder{
    int power = (40+(int)[recorder averagePowerForChannel:0])/6;
    if(power>6){
        power = 6;
    }
    _volumeView.image = [UIImage imageNamed:[NSString stringWithFormat:@"record_volume_%i",power]];
    float time = recorder.currentTime;
    //NSLog(@"%f",time);
    _timeLabel.text = [NSString stringWithFormat:@"%.fs",time];
    if(time > 50){
        _timeLabel.shadowColor = [UIColor redColor];
    }
    _progressView.frame = CGRectMake(0, self.bounds.size.height-5, 320.0/60*time, 5);
    _progressView.image = [_progressView.image stretchableImageWithLeftCapWidth:1.0 topCapHeight:5.0];
    if(time >60){
        [self completeRecord];
    }

}

-(void)recordAudio:(AVAudioRecorder *)recorder didFinishRecord:(BOOL)finish error:(NSError *)error{
    if(error || !finish){
        [self cancelRecord];
    }
}

-(void)dealloc{
    self.audioPath =nil;
    self.timeLabel =nil;
    self.progressView =nil;
    self.volumeView =nil;
    [super dealloc];
}
















@end
