//
//  BanBu_VoiceView.m
//  BanBu
//
//  Created by apple on 13-2-17.
//
//

#import "BanBu_VoiceView.h"
#import "AppCommunicationManager.h"
#import "AppDataManager.h"
@implementation BanBu_VoiceView
@synthesize mediaPath=_mediaPath;
@synthesize showButton=_showButton;
@synthesize progressBar=_progressBar;
@synthesize playingView=_playingView;
@synthesize status=_status;
@synthesize appChatController=_appChatController;
@synthesize isLeft=_isLeft;

@synthesize timeview=_timeview;
@synthesize timeLabel=_timeLabel;
@synthesize isPlay=_isPlay;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.tag=101;
        button.frame = CGRectMake(0, 0, frame.size.width-20, frame.size.height);
        [button addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
        self.showButton = button;
//        self.showButton.backgroundColor = [UIColor greenColor];

        [self addSubview:button];

        _status=3;
        
        UILabel *timed=[[UILabel alloc]initWithFrame:CGRectZero];
        
        timed.backgroundColor=[UIColor clearColor];
        
        timed.font=[UIFont systemFontOfSize:11];
       
        timed.textAlignment=NSTextAlignmentCenter;
        
        timed.textColor=[UIColor darkGrayColor];
        
        [self addSubview:timed];
    
        [timed release];
        
        _timeLabel=timed;
        
        
        UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(toPlay:)];
        
        [self addGestureRecognizer:tap];
        
        [tap release];
        isSlect=NO;
       
        
    }
    return self;
}

-(BOOL)toPlay:(UITapGestureRecognizer *)tap
{
   
   if(self&&tap)
   {
      
       
       isSlect=_isPlay;
       
       !isSlect?[self btnAction:_showButton]:[self stopPlaying:tap];
       
       _isPlay=!_isPlay;
       
        NSLog(@"===+++++__+++__++__++__++%d",_isPlay);
       
       return YES;
   
   }
    return NO;
    
}
- (void)setStatus:(MediaStatus)status
{

    if(_status != status)
    {
        _status = status;
        if(_status != MediaStatusNormal)
            self.showButton.enabled = NO;
        else
        {
            self.showButton.enabled = YES;
        }
    }
    [self layoutSubviews];
}
- (void)setMedia:(NSString *)mediaStr
{
    self.mediaPath = mediaStr;
    if(mediaStr == nil)
    {
        [_showButton setImage:nil forState:UIControlStateNormal];
        return;
    }
    
    [self layoutSubviews];
    // 初始状态下
   }

-(NSString *)mediaPath{
    return _mediaPath;
}


-(void)setTimeview:(NSString *)timeview
{



}





-(void)setTime:(CGFloat)time
{
    
    _timeLabel.text=[NSString stringWithFormat:@"%.2f'",time];
     [self layoutSubviews];
    
}
- (void)btnAction:(UIButton *)button
{
        if(_audioManager)
    {
        [_audioManager release];
        _audioManager = nil;
    }
    _audioManager = [[RecordAudio alloc] init];
    _audioManager.delegate = self;
    // 判断 他 有没有
    
    _audioManager.audioSavePath = [AppComManager pathForMedia:self.mediaPath];
    
    if([_audioManager startPlay])
    {   NSArray *animationImages;
            if(_isLeft)
             {        animationImages = [NSArray arrayWithObjects:@"语音喇叭2.png",@"语音喇叭3.png",@"语音喇叭4.png", nil];
              }else
              {
                  animationImages=[NSArray arrayWithObjects:@"语音喇叭11.png",@"语音喇叭12.png",@"语音喇叭13.png" ,nil];
              
              }
        NSMutableArray *images = [NSMutableArray arrayWithCapacity:3];
        for(NSString *path in animationImages)
        {
            [images addObject:[UIImage imageNamed:path]];
        }
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:button.frame];
        imageView.userInteractionEnabled = YES;
        imageView.animationImages = images;
        imageView.animationDuration = 1.0;
        [self addSubview:imageView];
//        imageView.backgroundColor = [UIColor greenColor];
        self.playingView = imageView;
        [imageView release];
        [imageView startAnimating];
        button.hidden=YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(stopPlaying:)];
        [imageView addGestureRecognizer:tap];
        [tap release];
        
        [MyAppDataManager.valueArr removeAllObjects];
        [MyAppDataManager.valueArr addObject:[NSNumber numberWithInt:self.tag]];
        
    }
    
    
    
    
}
-(void)stopPlaying:(UITapGestureRecognizer *)tap
{
    [_audioManager stopPlay];
    [_audioManager release];
    _audioManager = nil;
    [self.playingView stopAnimating];
    [self.playingView removeFromSuperview];
    if(tap){
        [self.playingView removeGestureRecognizer:tap];
       }else
    {
        [self.playingView removeGestureRecognizer:[[self.playingView gestureRecognizers] lastObject]];
        
        _isPlay=NO;
    }
    //点击之后,如果为对讲机模式则变为聊天模式

    self.playingView = nil;
    _showButton.hidden = NO;
    
    
    
}


-(void)recordAudioDidStopAnimation:(BOOL)flag
{
    if(MyAppDataManager.valueArr.count)
    {
        
        
   [_appChatController stopLastVoiceView:[[MyAppDataManager.valueArr objectAtIndex:0] intValue]];
  
   }
}
- (void)recordAudioDidFinishPlay:(BOOL)finish error:(NSError *)error
{
    [self stopPlaying:nil];
    
    
}

- (void)layoutSubviews
{
   
    
    
    if(!_isPlay)
    {
        [self.playingView setHidden:NO];
    }
    CGFloat timeLen = [_timeLabel.text sizeWithFont:[UIFont systemFontOfSize:11]].width;

    if(_isLeft==NO){
       self.showButton.frame = CGRectMake(self.bounds.size.width-30, 0,20, 20);
        
        self.timeLabel.frame=CGRectMake(8, 0, timeLen, 20);
         [self.showButton setImage:[UIImage imageNamed:@"语音喇叭10.png"] forState:UIControlStateNormal];
        
    }else
    {
        self.showButton.frame=CGRectMake(8, 0, 20, 20);
    
        self.timeLabel.frame=CGRectMake(self.bounds.size.width-40, 0, timeLen, 20);
     
        [self.showButton setImage:[UIImage imageNamed:@"语音喇叭.png"] forState:UIControlStateNormal];
        
    }
}

- (void)dealloc
{
    if(_audioManager)
    {
        [self stopPlaying:nil];
    }
    
    [_playingView release];
    _showButton = nil;
    self.mediaPath = nil;

    [super dealloc];
}








/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
