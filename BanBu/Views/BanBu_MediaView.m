//
//  BanBu_MediaView.m
//  BanBu
//
//  Created by 来国 郑 on 12-7-25.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "BanBu_MediaView.h"
#import "AppDataManager.h"
#import "AppCommunicationManager.h"
#import "SCGIFViewController.h"
#import "BanBu_ToseeGifViewController.h"
@interface BanBu_MediaView (fuck)

//-(void)radioAutoBroad;

@end

@implementation BanBu_MediaView

@synthesize showButton = _showButton;
@synthesize progressBar = _progressBar;
@synthesize status = _status;
@synthesize type = _type;
@synthesize showPhotos=_showPhotos;
@synthesize broadType=_broadType;
@synthesize delegate=_delegate;
@synthesize gifView=_gifView;
-(void)sendMessageTochat{
    
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.tag=101;
        button.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
        [button addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
        self.showButton = button;
        [self addSubview:button];
        
        DDProgressView *progress = [[DDProgressView alloc] initWithFrame:CGRectMake(10, self.bounds.size.height-20, self.bounds.size.width-20, 10)];
        [self addSubview:progress];
        self.progressBar = progress;
        progress.hidden = YES;
        [self addSubview:progress];
        [progress release];
        
        _type = 2;
        _status = 3;
        _broadType=0;
        _showPhotos=[[NSMutableArray alloc]initWithCapacity:10];
        
        self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"file-loading.png"]];
        
             
        //
        UITapGestureRecognizer *taptoseeGif=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(Gif)];
        
        taptoseeGif.numberOfTapsRequired=1;
        
        _gifView.userInteractionEnabled=YES;
        [_gifView addGestureRecognizer:taptoseeGif];
        
        [taptoseeGif release];

        
    }
    return self;
}

// void this is 这是点击看gif 的大图

-(void)Gif
{

    BanBu_ToseeGifViewController *aSC = [[BanBu_ToseeGifViewController alloc]init];

    aSC.gifString = _mediaPath;
    UINavigationController *nc = [[UINavigationController alloc]initWithRootViewController:aSC];
    nc.navigationBar.barStyle = UIBarStyleBlackTranslucent;
    [_appChatController presentModalViewController:nc animated:YES];
    [aSC release];
    [nc release];
 

}
- (void)setType:(MediaViewType)type
{
    if(_type == type)
        return;
    _type = type;
   
}
-(void)radioAutoBroad:(MediaBroadType)type
{
    // 判断他是不是队列的第一个 若不是 等待第一个播放完
    
    if(_broadType==type)
        return;
    _broadType=type;
    
     if(![MyAppDataManager.valueArr indexOfObject:_mediaPath]==0)
         return;
    
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
    {
        [self animation];
    }
}

-(void)continueToBroad
{
    if(_audioManager)
    {
        [_audioManager release];
        _audioManager = nil;
    }
    _audioManager = [[RecordAudio alloc] init];
    
    _audioManager.delegate = self;
    // 判断 他 有没有
    
    _audioManager.audioSavePath = [AppComManager pathForMedia:[MyAppDataManager.valueArr objectAtIndex:0]];
    
    if([_audioManager startPlay])
    {
        [self animation];
    }

    
}

-(void)animation
{
    
    UIButton *btn=(UIButton *)[self viewWithTag:101];
    
    NSArray *animationImages = [NSArray arrayWithObjects:@"voice_low.png",@"voice_midium.png",@"voice_max.png", nil];
    NSMutableArray *images = [NSMutableArray arrayWithCapacity:3];
    for(NSString *path in animationImages)
    {
        [images addObject:[UIImage imageNamed:path]];
    }
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:btn.frame];
    imageView.userInteractionEnabled = YES;
    imageView.animationImages = images;
    imageView.animationDuration = 1.0;
    [self addSubview:imageView];
    self.playingView = imageView;
    [imageView release];
    [imageView startAnimating];
    btn.hidden=YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(stopPlaying:)];
    [imageView addGestureRecognizer:tap];
    [tap release];


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
            self.progressBar.progress = 0.0;
        }
    }
    [self layoutSubviews];
}


- (void)layoutSubviews
{
    self.progressBar.frame = CGRectMake(10, self.bounds.size.height-20, self.bounds.size.width-20, 10);
    if(_type == MediaViewTypeImage)
    {    if(![[_mediaPath pathExtension]isEqualToString:@"gif"])
    {
        self.showButton.frame = self.bounds;
        self.gifView.frame=CGRectZero;
    }else
    {
        self.gifView.frame=self.bounds;
        self.showButton.frame=CGRectZero;
        
    }
        if(_status == MediaStatusNormal)
        {
            self.progressBar.hidden = YES;
        }
        else
        {
            self.progressBar.hidden = NO;
        }
    }
    else if(_type == MediaViewTypeVoice)
    {
        self.showButton.frame = CGRectMake(20, 15,self.bounds.size.width-40, self.bounds.size.width-40);
        
        self.gifView.frame=CGRectZero;
        
        if(_status == MediaStatusNormal)
        {
            self.progressBar.hidden = YES;
        }
        else
        {
            self.progressBar.hidden = NO;
        }
    }
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

    if(_type == MediaViewTypeImage)
    {
         // 如果是jpg 的就是这种方式
        
        if([[mediaStr pathExtension]isEqual:@"jpg"]||[[mediaStr pathExtension] isEqual:@"png"])
        {
        
        UIImage *image = [MyAppDataManager imageForImageUrlStr:mediaStr];
       
        [_showButton setImage:image forState:UIControlStateNormal];
        
        }else
        {
            SCGIFImageView *g=(SCGIFImageView*)[self viewWithTag:1000];
            
            if(g)
            {
                [g removeFromSuperview];
            }
            
            SCGIFImageView *gif=[[SCGIFImageView alloc]initWithFrame:self.bounds];
            
            gif.tag=1000;
            
            self.gifView=gif;
            
            [self addSubview:gif];
            
            [gif release];
            gif.gifFile=[AppComManager pathForMedia:mediaStr];
            
            self.gifView.hidden=NO;
            self.gifView.userInteractionEnabled=YES;
        
            UITapGestureRecognizer *taptoseeGif=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(Gif)];
            
            [gif addGestureRecognizer:taptoseeGif];
            
            [taptoseeGif release];

        
        }
       
    
    }
    else
    {
        [self.showButton setImage:[UIImage imageNamed:@"voice_play.png"] forState:UIControlStateNormal];
    }
    
}

- (void)btnAction:(UIButton *)button
{
    if(_type==MediaViewTypeImage)
    {
       // MWPhoto *photo=[MWPhoto photoWithURL:[NSURL URLWithString:_mediaPath]];
        MWPhoto *photo=[MWPhoto photoWithImage:[MyAppDataManager imageForImageUrlStr:_mediaPath]];
    
        [_showPhotos removeAllObjects];
        
        [_showPhotos addObject:photo];
        
        // 新建一个数组 存放image
        
        BanBu_ChatToseePic *browser = [[BanBu_ChatToseePic alloc] initWithDelegate:self];
//        browser.displayActionButton = YES;
        browser.type = DrawTypeChat;
        NSMutableArray *arr=[[[NSMutableArray alloc]initWithCapacity:1]autorelease];

        [arr addObject:[MyAppDataManager imageForImageUrlStr:_mediaPath]];
        [arr addObject:_mediaPath];
        browser.shareArr=arr;
        
        
        
        [browser setInitialPageIndex:0];
        UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:browser];
        [self.appChatController presentModalViewController:nc animated:YES];
        
        [nc release];
        
        [browser release];

        return;
    
    }
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
    {
        [self animation];
    }
    
    
    
    
}

- (void)stopPlaying:(UITapGestureRecognizer *)tap
{
    [_audioManager stopPlay];
    [_audioManager release];
    _audioManager = nil;
    [self.playingView stopAnimating];
    [self.playingView removeFromSuperview];
    if(tap)
        [self.playingView removeGestureRecognizer:tap];
    else
    {
        [self.playingView removeGestureRecognizer:[[self.playingView gestureRecognizers] lastObject]];
    }
    //点击之后,如果为对讲机模式则变为聊天模式
    
    if(_broadType== MediaBroadRadio&&tap)
    {
        _broadType=MediaBroadStand;
        
        [MyAppDataManager.valueArr removeAllObjects];
    
        // 将smalllist 的对讲机模式 变为聊天模式
        
       // _appChatController.listType=ListAudioTalk;
        
        
    }
    
    
    
    
    
    self.playingView = nil;
    _showButton.hidden = NO;
    
}


- (void)recordAudioDidFinishPlay:(BOOL)finish error:(NSError *)error
{
    [self stopPlaying:nil];
    
    
    
    if(_broadType==MediaBroadRadio&&[MyAppDataManager.valueArr count] )
    {
       
        
        int index=[MyAppDataManager.valueArr indexOfObject:_mediaPath];
    
        [MyAppDataManager.valueArr removeObject:_mediaPath];
        
        [MyAppDataManager.keyArr removeObjectAtIndex:index];

        if([_delegate respondsToSelector:@selector(RunLoopMusic:Url:)]&&[MyAppDataManager.keyArr count])
        {
     
         [_delegate RunLoopMusic:MyAppDataManager.valueArr Url:MyAppDataManager.keyArr];
     
        }else
        {
         
         _broadType=MediaBroadStand;
     
       }
    // 存放的url he row 让他们自动播放
    }
    
}


- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser {
    return 1;
}

- (MWPhoto *)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index {
    if (index < _showPhotos.count)
        return [_showPhotos objectAtIndex:index];
    return nil;

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
    [_progressBar release];
    
    [_showPhotos release];
    
    
    
    
    [super dealloc];
}

@end
