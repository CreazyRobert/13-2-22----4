//
//  RecordView.m
//  BanBu
//
//  Created by zhengziyan19 on 12-8-20.
//
//

#import "RecordView.h"
#import "AppCommunicationManager.h"
#import "AppDataManager.h"

@implementation RecordView


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor colorWithWhite:0.0 alpha:.4];
       // self.backgroundColor = [UIColor colorWithWhite:1.0 alpha:.9];

        self.exclusiveTouch=YES;
        
        UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _cancelBtn = cancelButton;
        cancelButton.frame = CGRectMake(107, 150, 105, 120);
        [cancelButton setBackgroundImage:[UIImage imageNamed:@"icon_recording.png"] forState:UIControlStateNormal];
        [cancelButton setBackgroundImage:[UIImage imageNamed:@"icon_cancel.png"] forState:UIControlStateHighlighted];
        [self addSubview:cancelButton];
        
        _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 320, 320, 20)];
        _timeLabel.backgroundColor = [UIColor clearColor];
        _timeLabel.shadowColor = [UIColor blackColor];
        _timeLabel.shadowOffset = CGSizeMake(0, -1.0);
        _timeLabel.textAlignment = UITextAlignmentCenter;
        _timeLabel.textColor = [UIColor whiteColor];
        _timeLabel.font = [UIFont boldSystemFontOfSize:15];
        _timeLabel.text = @"0s";
        [self addSubview:_timeLabel];
        
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, self.bounds.size.height-232, 320, 232)];
        imageView.image = [UIImage imageNamed:@"record_volume_1.png"];
//        imageView.backgroundColor = [UIColor redColor];
        [self insertSubview:imageView atIndex:0];
        self.volumeView = imageView;
        [imageView release];
        
        _progressView = [[UIImageView alloc] initWithFrame:CGRectMake(0, self.bounds.size.height-5, 4, 5)];
        _progressView.image = [UIImage imageNamed:@"record_time_status.png"];
        [self addSubview:_progressView];
        
    }
    return self;
}

- (void)cancelRecord
{
    
    _recorder.delegate = nil;
    [_recorder stopRecord];
    [FileManager removeItemAtPath:_recorder.audioSavePath error:nil];
    [_recorder release];
    _recorder = nil;
    
    [UIView animateWithDuration:.5
                     animations:^{
                         self.alpha = 0.0;
                     } completion:^(BOOL finished) {
                         
                         [self removeFromSuperview];
                     }];
    
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    CGPoint point = [[touches anyObject] locationInView:self];
    if(CGRectContainsPoint(_cancelBtn.frame, point) && !_cancelBtn.highlighted)
        _cancelBtn.highlighted = YES;
    if(!CGRectContainsPoint(_cancelBtn.frame, point) && _cancelBtn.highlighted)
        _cancelBtn.highlighted = NO;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    CGPoint point = [[touches anyObject] locationInView:self];
    if(CGRectContainsPoint(_cancelBtn.frame, point))
    {
        _cancelBtn.highlighted = NO;
        [self performSelector:@selector(cancelRecord)];
    }
    else
    {
        [self completeRecord];
    }
}


- (void)touchesMovedInView:(CGPoint)point
{
    if(CGRectContainsPoint(_cancelBtn.frame, point) && !_cancelBtn.highlighted)
        _cancelBtn.highlighted = YES;
    if(!CGRectContainsPoint(_cancelBtn.frame, point) && _cancelBtn.highlighted)
        _cancelBtn.highlighted = NO;    
}


- (void)touchesEndInView:(CGPoint)point
{
    if(CGRectContainsPoint(_cancelBtn.frame, point))
    {
        _cancelBtn.highlighted = NO;
        [self performSelector:@selector(cancelRecord)];
    }
    else
    {
        [self completeRecord];
    }
}

- (void)willMoveToSuperview:(UIView *)newSuperview
{
    if(newSuperview)
    {
        RecordAudio *recorder = [[RecordAudio alloc] init];
        _recorder = recorder;
        recorder.audioSavePath = _audioPath;
        recorder.delegate = self;
        [recorder startRecord];
    }
   
}

- (void)completeRecord
{
    NSData *voiceData = [RecordAudio decodeWavToAMR:_recorder.audioSavePath];
    float runTime = [_recorder getRecordAudioTime];
    //NSLog(@"%i   %.f",voiceData.length,runTime);
    
    [_recorder stopRecord];
    [_recorder release];
    _recorder = nil;
    
    [UIView animateWithDuration:.5
                     animations:^{
                         self.alpha = 0.0;
                     } completion:^(BOOL finished) {
                         
                         [self removeFromSuperview];
                         if([_delegate respondsToSelector:@selector(recordView:recordDidCompleted:recordTime:)])
                             [_delegate recordView:self recordDidCompleted:voiceData recordTime:(int)runTime];
                     }];
    
}


#pragma RecordAudio Delegate Method

- (void)recordAudioDidUpdateAveragePower:(AVAudioRecorder *)recorder
{
    int power = (40+(int)[recorder averagePowerForChannel:0])/6;
    if(power>6)
        power = 6;
//    NSLog(@"power:%i",power);
    self.volumeView.image = [UIImage imageNamed:[NSString stringWithFormat:@"record_volume_%i",power]];
    float time = recorder.currentTime;
    _timeLabel.text = [NSString stringWithFormat:@"%.fs",time];
    if(time > 50)
        _timeLabel.shadowColor = [UIColor redColor];
    _progressView.frame = CGRectMake(0, self.bounds.size.height-5, 320.0/60*time, 5);
    _progressView.image = [_progressView.image stretchableImageWithLeftCapWidth:1.0 topCapHeight:5.0];
    
    if(time > 60)
    {
        [self completeRecord];
    }
}

- (void)recordAudio:(AVAudioRecorder *)recorder didFinishRecord:(BOOL)finish error:(NSError *)error
{
    if(error || !finish)
        [self cancelRecord];
}

- (void)dealloc
{
    self.audioPath = nil;
    self.timeLabel = nil;
    self.progressView = nil;
    self.volumeView = nil;
    [super dealloc];
}

@end
