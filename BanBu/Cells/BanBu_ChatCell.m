//
//  BanBu_ChatCell.m
//  BanBu
//
//  Created by 来国 郑 on 12-7-24.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "BanBu_ChatCell.h"
#import <QuartzCore/QuartzCore.h>


#define AvatarWidth 40.0
// 2-15
// 39-49

#define AvatarRect(height)  CGRectMake(_atLeft?15.0:(320-AvatarWidth-15.0),(_showTime?29:4), AvatarWidth, AvatarWidth)

// 因为image 的frame 的大小
#define BKViewRect(width,height)  CGRectMake(_atLeft?59.0:(320-width-74.0),(_showTime?TimeLabelHeight:0)+(_showFrom?2:2), width+15, height-(_showTime?TimeLabelHeight:0)-(_showFrom?FromLabelHeight:0)+10)

#define MediaViewRect  CGRectMake(_bkView.frame.origin.x+(_atLeft?(12.0+7.5):(8.0+7)), _bkView.frame.origin.y+7.0+3+(_atLeft?.0:0), _bkView.frame.size.width-30-5, _bkView.frame.size.height-30)

#define VoiceViewRect CGRectMake(_bkView.frame.origin.x+(_atLeft?12.0:8.0), _bkView.frame.origin.y+(_atLeft?12.0:12.0), _bkView.frame.size.width-(_atLeft?17.0:20.0), _bkView.frame.size.height-18-(_atLeft?12.0:12.0))

#define SmileLabelRect  CGRectMake(_bkView.frame.origin.x+(_atLeft?2.0:0.0), _bkView.frame.origin.y+2.0, _bkView.frame.size.width, _bkView.frame.size.height-10)
//为了解决UILabel的问题，瞎加的
#define SmileLabelRect1  CGRectMake(_bkView.frame.origin.x+2+(_atLeft?6.0:0.0)+12, _bkView.frame.origin.y+(_atLeft?2:1), _bkView.frame.size.width-35, _bkView.frame.size.height-10)


// 第二个加+3.0 改为-3.0

#define StatusViewRect  CGRectMake(_atLeft?(_bkView.frame.origin.x+_bkView.frame.size.width-3.0):(_bkView.frame.origin.x-_statusView.image.size.width-3.0), _bkView.frame.origin.y+8.0, _statusView.image.size.width, _statusView.image.size.height)

@interface BanBu_ChatCell()

-(void)setType1:(ChatCellType)type;

@property(nonatomic,retain)UILabel *statusLabel;
@end
@implementation BanBu_ChatCell

@synthesize avatar = _avatar;
@synthesize atLeft = _atLeft;
@synthesize smileLabel = _smileLabel;
@synthesize mediaView = _mediaView;
@synthesize statusView = _statusView;
@synthesize type = _type;
@synthesize status = _status;
@synthesize bkViewWidth = _bkViewWidth;
@synthesize delegate=_delegate;
@synthesize emiImage=_emiImage;
@synthesize statusLabel=_statusLabel;
@synthesize statuss=_statuss;
@synthesize fromLabel=_fromLabel;
@synthesize from=_from;
@synthesize demeterLabel=_demeterLabel;
@synthesize mapButton=_mapButton;
@synthesize voiceView=_voiceView;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.backgroundColor = [UIColor redColor];
        
        _atLeft = YES;
        
        _status = ChatStatusNone;
        
        _type = ChatCellTypeText;
        
        _bkView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _bkView.backgroundColor = [UIColor clearColor];

        _bkView.image =  [UIImage imageNamed:@"chat_voice_bubble-lef.png"];
//        _bkView.image =  [UIImage imageNamed:@"chat_voice_bubble-right.png"];
        [self addSubview:_bkView];
       
        [_bkView release];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
        [self addSubview:label];
        self.smileLabel = label;
        self.smileLabel.numberOfLines = 0;
        self.smileLabel.backgroundColor = [UIColor clearColor];
        self.smileLabel.tag = 101;
//        self.smileLabel.alpha = 0.5;
//        self.smileLabel.backgroundColor = [UIColor redColor];
        [label release];
        //2-18
        UIImageView *avatar = [[UIImageView alloc] initWithFrame:CGRectMake(18, self.bounds.size.height-35, 30, 30)];
        self.avatar = avatar;
        avatar.image = [UIImage imageNamed:@"icon_default.png"];
            [self addSubview:avatar];
        [avatar release];
        
        UIImageView *statusView = [[UIImageView alloc] initWithFrame:CGRectZero];
        self.statusView = statusView;
        [self insertSubview:statusView atIndex:0];
        [statusView release];
        
        _statusLabel=[[UILabel alloc]initWithFrame:CGRectZero];
        
        [_statusView insertSubview:_statusLabel atIndex:0];
        
        [_statusLabel release];
        
        BanBu_MediaView *mediaView = [[BanBu_MediaView alloc] initWithFrame:_bkView.frame];
        [self addSubview:mediaView];
        self.mediaView = mediaView;
        [mediaView release];
        
        BanBu_VoiceView *voiceView=[[BanBu_VoiceView alloc]initWithFrame:_bkView.frame];
        
        [self addSubview:voiceView];
//        voiceView.backgroundColor = [UIColor yellowColor];
        self.voiceView=voiceView;
        self.voiceView.tag = 102;
        [voiceView release];
        
        _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(90, 7.0, 100, 18)];
        //_timeLabel.backgroundColor = [UIColor colorWithWhite:.1 alpha:.2];
        _timeLabel.backgroundColor=[UIColor clearColor];
        
        _timeLabel.layer.cornerRadius = 4.0;
        _timeLabel.textAlignment = UITextAlignmentCenter;
        _timeLabel.textColor = [UIColor darkGrayColor];
        _timeLabel.font = [UIFont systemFontOfSize:14];
        _timeLabel.hidden = YES;
        [self addSubview:_timeLabel];
        
        [_timeLabel release];
        // 距离的远近
        
        _demeterLabel=[[UILabel alloc]initWithFrame:CGRectMake(190, 7, 100, 18)];
        _demeterLabel.backgroundColor=[UIColor clearColor];
        
        _demeterLabel.layer.cornerRadius=4.0;
        _demeterLabel.textAlignment=NSTextAlignmentLeft;
        
        _demeterLabel.textColor=[UIColor darkGrayColor];
        
        _demeterLabel.font=[UIFont systemFontOfSize:14];
        
        _demeterLabel.hidden=YES;
        
        [self addSubview:_demeterLabel];
        
        [_demeterLabel release];
        
        
        
        // 来自哪里
        
        _fromLabel=[[UILabel alloc]initWithFrame:CGRectZero];
        
        _fromLabel.backgroundColor=[UIColor grayColor];
        
        _fromLabel.alpha=.5;
        
        _fromLabel.textColor = [UIColor whiteColor];
        
        
        _fromLabel.layer.cornerRadius=4.0;
        
        _fromLabel.textAlignment=NSTextAlignmentLeft;
        
        _fromLabel.font=[UIFont systemFontOfSize:14];
        
        _fromLabel.userInteractionEnabled=YES;
        
        _fromLabel.hidden=YES;
        
        [self addSubview:_fromLabel];
        
        _showFrom=NO;
        _status = 6;
        _type = 5;
        
       // 点击的手势 那么可以进入破冰语
        
        UITapGestureRecognizer *tapGester=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(iceBreak)];
        
        tapGester.numberOfTapsRequired=1;
        
        [_fromLabel addGestureRecognizer:tapGester];
        
        [tapGester release];
        
        
        SCGIFImageView *image=[[SCGIFImageView alloc]initWithFrame:CGRectZero];
        
        _emiImage=image;
        
        [self addSubview:_emiImage];
        
        [_emiImage release];
        
        [_smileLabel addObserver:self forKeyPath:@"frame" options:NSKeyValueObservingOptionNew context:_smileLabel];

        [_mediaView addObserver:self forKeyPath:@"frame" options:NSKeyValueObservingOptionNew context:_mediaView];
        
        [_voiceView addObserver:self forKeyPath:@"frame" options:NSKeyValueObservingOptionNew context:_voiceView];
        
        // 声音
        
        
        // 长按手势 改变 颜色
        
        UILongPressGestureRecognizer *longRecognizer=[[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(changePic:)];
        
        [self addGestureRecognizer:longRecognizer];
        
        [longRecognizer release];
        

        
        UIButton *tempBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        tempBtn.frame = CGRectZero;
        [tempBtn addTarget:self action:@selector(MakeMap:) forControlEvents:UIControlEventTouchUpInside];
        
        _mapButton=tempBtn;
        tempBtn.tag=10101;
     
        [self addSubview:tempBtn];

       
 
    }
    return self;
}




- (void)setShowTime:(BOOL)showTime
{
    
    if(_showTime == showTime)
        return;
    _showTime = showTime;

    _timeLabel.hidden = !_showTime;

    _demeterLabel.hidden=!_showTime;
    
    if(!_showTime)
    {
        _timeLabel.text = nil;
        
        _demeterLabel.text=nil;
        
    }
     
}



- (void)setType:(ChatCellType)type
{
    if(_type == type)
        return;
    
    if(self.mapView)
    {
        self.mapView.delegate = nil;
        [self.mapView removeFromSuperview];
        self.mapView = nil;
    }

    if(type == ChatCellTypeText)
    {
        _smileLabel.hidden = NO;
        [_mediaView setMedia:nil];
        _mediaView.hidden = YES;
        _emiImage.hidden=YES;
        _mapButton.hidden=YES;
        [_voiceView setMedia:nil];
        
        _voiceView.hidden=YES;
        
    }
    else if(type == ChatCellTypeLocation)
    {
        _smileLabel.hidden = YES;
        _smileLabel.text = nil;
        [_mediaView setMedia:nil];
        _mediaView.hidden = YES;
        _bkViewWidth = 160.0;
        // 加一个长按的手势
        _emiImage.hidden=YES;
        
        _mapButton.hidden=NO;
        
        [_voiceView setMedia:nil];
        
        _voiceView.hidden=YES;
        
    }
    else if(type == ChatCellTypeImage)
    {
        _smileLabel.hidden = YES;
        _smileLabel.text = nil;
        _mediaView.hidden = NO;
        _bkViewWidth = 80.0;
        
        [_emiImage setHidden:YES];
        
        [_mediaView setType:MediaViewTypeImage];

         _mapButton.hidden=YES;
        
        [_voiceView setMedia:nil];
        
        _voiceView.hidden=YES;
        
    }
    else if(type == ChatCellTypeVoice)
    {   _emiImage.hidden=YES;
        _smileLabel.hidden = YES;
        _smileLabel.text = nil;
        _mediaView.hidden = YES;
        _bkViewWidth = 80.0;
       // [_mediaView setType:MediaViewTypeVoice];

        [_mediaView setMedia:nil];
        
        _voiceView.hidden=NO;
        
         _mapButton.hidden=YES;
    }else if (type==ChatCellTypeEmi)
    {
        _smileLabel.hidden = YES;
        _smileLabel.text = nil;
        _mediaView.hidden = NO;
        _bkViewWidth = 90;
      
        [_mediaView setMedia:nil];
        
        [_mediaView setHidden:YES];
    
        [_emiImage setHidden:NO];
         _mapButton.hidden=YES;
        
        _voiceView.hidden=YES;
    }
    
    _type = type;
    [self layoutSubviews];

}


-(void)setVoiceViewLong:(CGFloat)time
{
    
    [_voiceView setTime:time];
    
    
  if(time<=5)
  {
      _emiImage.hidden=YES;
      _smileLabel.hidden = YES;
      _smileLabel.text = nil;
      _mediaView.hidden = YES;
      _bkViewWidth = 80.0;
      // [_mediaView setType:MediaViewTypeVoice];
      
      [_mediaView setMedia:nil];
      
      _voiceView.hidden=NO;
      
      _mapButton.hidden=YES;
  
  }else if (time>5&&time<15)
  {
      _emiImage.hidden=YES;
      _smileLabel.hidden = YES;
      _smileLabel.text = nil;
      _mediaView.hidden = YES;
      _bkViewWidth = 130.0;
      // [_mediaView setType:MediaViewTypeVoice];
      
      [_mediaView setMedia:nil];
      
      _voiceView.hidden=NO;
      
      _mapButton.hidden=YES;

  
  }else
  {
  
      _emiImage.hidden=YES;
      _smileLabel.hidden = YES;
      _smileLabel.text = nil;
      _mediaView.hidden = YES;
      _bkViewWidth = 160.0;
      // [_mediaView setType:MediaViewTypeVoice];
      
      [_mediaView setMedia:nil];
      
      _voiceView.hidden=NO;
      
      _mapButton.hidden=YES;

  }

    
    [self layoutSubviews];
    
}
-(void)setType1:(ChatCellType)type
{
   
    if(type == ChatCellTypeText)
    {
        _smileLabel.hidden = NO;
        [_mediaView setMedia:nil];
        _mediaView.hidden = YES;
        _emiImage.hidden=YES;
        _mapButton.hidden=YES;
        
    }
    else if(type == ChatCellTypeLocation)
    {
        _smileLabel.hidden = YES;
        _smileLabel.text = nil;
        [_mediaView setMedia:nil];
        _mediaView.hidden = YES;
        _bkViewWidth = 160.0;
        // 加一个长按的手势
        _emiImage.hidden=YES;
        
        _mapButton.hidden=NO;
    }
    else if(type == ChatCellTypeImage)
    {
        _smileLabel.hidden = YES;
        _smileLabel.text = nil;
        _mediaView.hidden = NO;
        _bkViewWidth = 80.0;
        
        [_emiImage setHidden:YES];
        
        [_mediaView setType:MediaViewTypeImage];
        
        _mapButton.hidden=YES;

        
    }
    else if(type == ChatCellTypeVoice)
    {   _emiImage.hidden=YES;
        _smileLabel.hidden = YES;
        _smileLabel.text = nil;
        _mediaView.hidden = NO;
        _bkViewWidth = 80.0;
        [_mediaView setType:MediaViewTypeVoice];
        
        _mapButton.hidden=YES;
    }else if (type==ChatCellTypeEmi)
    {
        _smileLabel.hidden = YES;
        _smileLabel.text = nil;
        _mediaView.hidden = NO;
        _bkViewWidth = 90;
        
        [_mediaView setMedia:nil];
        
        [_mediaView setHidden:YES];
        
        [_emiImage setHidden:NO];
        _mapButton.hidden=YES;
    }
    
    _type = type;
    [self layoutSubviews];
    
}

- (void)setAtLeft:(BOOL)atLeft
{
    if(_atLeft == atLeft)
        return;
    _atLeft = atLeft;
    if(_atLeft){
//        _bkView.backgroundColor = [UIColor redColor];
        _bkView.image = [UIImage imageNamed:@"chat_voice_bubble-lef.png"]  ;
    }
    else
    {
        _bkView.image =  [UIImage imageNamed:@"chat_voice_bubble-right.png"] ;
//        _bkView.backgroundColor = [UIColor greenColor];

        
    }
}

-(void)changePic:(UILongPressGestureRecognizer *)sender
{
    
    
    // 先判断 创建 menu
   /*
    if(_atLeft)
    {
        if(sender.state==UIGestureRecognizerStateBegan){
            
            _bkView.image = [UIImage imageNamed:@"chat_select-lef.png"];
            
            [self setType1:_type];
            
            
        }else if (sender.state==UIGestureRecognizerStateEnded)
        {
            
            
            _bkView.image = [UIImage imageNamed:@"chat_voice_bubble-lef.png"];
            [self setType1:_type];
        }
        
    }else
    {
        
        if(sender.state==UIGestureRecognizerStateBegan){
            
            _bkView.image = [UIImage imageNamed:@"chatto_select_right.png"];
            
            
            [self setType1:_type];
            
            
        }else if (sender.state==UIGestureRecognizerStateEnded)
        {
            
            _bkView.image = [UIImage imageNamed:@"chat_voice_bubble-right.png"];
            
            [self setType1:_type];
            
        }
        
        
    }
    */
    
    if(sender.state==UIGestureRecognizerStateBegan)
    {
    if([_delegate respondsToSelector:@selector(menuShow:tableCell:)]&&_delegate)
    {
     
        [_delegate menuShow:_bkView tableCell:self];
        
    }
    
    }
    
    
}


//-()

#define DefaultFont [UIFont systemFontOfSize:17]
#define Marge 10
#define MaxWidth 200
#define DefaultHeight [@"f" sizeWithFont:DefaultFont].height
- (void)setAvatarImage:(NSString *)imageStr
{
    [_avatar setImageWithURL:[NSURL URLWithString:imageStr] placeholderImage:[UIImage imageNamed:@"icon_default.png"] andType:1];
}
- (void)setSmileLabelText:(NSString *)text
{
//    NSLog(@"text:%@",text);
    
    self.smileLabel.text = text;
    CGSize size = [self.smileLabel.text sizeWithFont:DefaultFont constrainedToSize:CGSizeMake(MaxWidth-20, 1000)lineBreakMode:UILineBreakModeWordWrap];
    CGRect newFrame = self.smileLabel.frame;
    newFrame.size.height = size.height + ((size.height>20 )?20:0);
    newFrame.size.width = (size.height>DefaultHeight)?MaxWidth:(size.width + 20);
    self.smileLabel.frame = newFrame;
 

    
    _bkViewWidth = self.smileLabel.frame.size.width;
    if(self.smileLabel.frame.size.width>160)
    {
        _bkViewWidth = 160;
    }
}

-(void)setEmi:(NSString *)text
{
    
    NSString *path=[[NSBundle mainBundle]pathForResource:text ofType:@"gif"];
   
     
    _emiImage.gifFile=path;
    

    CGRect rect=CGRectMake(89, 12, 90, 90);
    
    _emiImage.frame=rect;
    
    _emiImage.backgroundColor=[UIColor clearColor];
    
    [self addSubview:self.emiImage];
    
    
    [self bringSubviewToFront:self.emiImage];
    
  
    _bkViewWidth = _emiImage.frame.size.width;
    if(_emiImage.frame.size.width>160)
    {
        _bkViewWidth = 160;
    }

}
- (void)setMediaVoice:(NSString *)voicePath duration:(NSString *)duration
{
    [_mediaView setMedia:duration];
}

- (void)setLocationLat:(CLLocationDegrees)lat andLong:(CLLocationDegrees)lon
{
    if(!self.mapView)
    {
       self.mapView = [[[MKMapView alloc] initWithFrame:CGRectMake(89, 12, 160, 12)] autorelease];
        
       
        _mapView.frame = CGRectMake(89, 12, 160, 64);
        
        _mapView.userInteractionEnabled = YES;
        
    }
    _mapView.delegate = self;
    _mapView.showsUserLocation = YES;

    _mapView.region = MKCoordinateRegionMake(CLLocationCoordinate2DMake(lat, lon), MKCoordinateSpanMake(0.005, 0.005));

    
    [self addSubview:self.mapView];
//    [self bringSubviewToFront:_mapView];
    
    _mapButton.frame =CGRectMake(79, 12, 163, 64);
    
    [self bringSubviewToFront:_mapButton];
}

// 重写cell 的setediting
- (void)setStatus:(ChatStatus)status
{
    
   if (_status == status)
       return;

    if(status == ChatStatusNone)
    {
        _statusView.image = nil;
        
       _statusLabel.text=@"";
        
        return;
    }
    /**************************************************************/
    _statuss=status;
    
    NSArray *statusImages = [[[NSArray alloc] initWithObjects:@"icon_msgfail1.png",@"icon_msgsent1.png",@"icon_msgpend1.png",@"icon_msgread1.png",nil] autorelease];
    
    NSArray *statusWords=[[NSArray alloc]initWithObjects:NSLocalizedString(@"newsState4", nil),NSLocalizedString(@"newsState", nil),NSLocalizedString(@"newsState3", nil),NSLocalizedString(@"newsState1", nil), nil];

//    _statusView.backgroundColor = [UIColor redColor];
    _statusView.image = [[UIImage imageNamed:[statusImages objectAtIndex:status]]stretchableImageWithLeftCapWidth:5 topCapHeight:5];

    // 长度
    CGFloat f=[[statusWords objectAtIndex:status] sizeWithFont:[UIFont systemFontOfSize:11]].width;
    

    _statusView.frame=CGRectMake(StatusViewRect.origin.x-(f-23), StatusViewRect.origin.y, f, StatusViewRect.size.height);
          
   // UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(StatusViewRect), CGRectGetHeight(StatusViewRect))];
    
    _statusLabel.frame=CGRectMake(0, 0,_statusView.frame.size.width, _statusView.frame.size.height);
    
    _statusLabel.textColor=[UIColor whiteColor];
    
    _statusLabel.text=[statusWords objectAtIndex:status];
       
    [_statusLabel setTextAlignment:NSTextAlignmentCenter];
    
    _statusLabel.font=[UIFont systemFontOfSize:11];
    
    _statusLabel.numberOfLines=0;
    
    _statusLabel.backgroundColor=[UIColor clearColor];
    
    [statusWords release];
    
   
    
    
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    float height = self.contentView.frame.size.height;
    

    self.avatar.frame = AvatarRect(height);

    _bkView.frame = BKViewRect(_bkViewWidth, height-2*CellMarge);
    
    _bkView.image = [_bkView.image stretchableImageWithLeftCapWidth:20.0 topCapHeight:30.0];
    
    if(_type == ChatCellTypeImage)
    {
        _mediaView.frame = MediaViewRect;
        
            
    }
    if(_type==ChatCellTypeVoice)
    {
          _voiceView.frame = VoiceViewRect;
    
    }
    if(_type == ChatCellTypeText)
    {
        
        _smileLabel.frame = SmileLabelRect1;
    
    }
    if(_type == ChatCellTypeLocation)
    {

        _mapView.frame = CGRectMake(MediaViewRect.origin.x+1, MediaViewRect.origin.y, MediaViewRect.size.width-2, MediaViewRect.size.height);
    
    }if(_type==ChatCellTypeEmi)
    {
        
      //  MediaViewRect
        _bkView.frame = BKViewRect(_bkViewWidth, height-5);
        
        _emiImage.frame=CGRectMake(MediaViewRect.origin.x, MediaViewRect.origin.y, CGRectGetWidth(MediaViewRect), CGRectGetHeight(MediaViewRect));
        _emiImage.userInteractionEnabled=NO;
        
    }
    
    CGFloat f=[_statusLabel.text sizeWithFont:[UIFont systemFontOfSize:11]].width;
    _statusView.frame=CGRectMake(StatusViewRect.origin.x-(f-23), StatusViewRect.origin.y, f+3, StatusViewRect.size.height);
}

-(void)setShowFrom:(BOOL)showFrom
{
    
#warning 注释掉以下几句是为了解决“来自破冰语”、“来自涂鸦”错乱的问题。
//    if(_showFrom==showFrom)
//    {
//        return;
//    }

    _showFrom=showFrom;
    
    _fromLabel.hidden=!_showFrom;
    if(!_showFrom)
    {
        
        _fromLabel.text=nil;
        
    }

        if([_from isEqual:@"pb"])
        {
          
           _fromLabel.frame=CGRectMake(50, 0, 140, 18);
        
            _fromLabel.text= NSLocalizedString(@"comefromIceBreak", nil);
           
            
        }
        else if([_from isEqual:@"ty"])
        {
            _fromLabel.frame=CGRectMake(50, 0, 140, 18);
 
            //        _fromLabel.text= NSLocalizedString(@"comefromIceBreak", nil);
            _fromLabel.text = NSLocalizedString(@"comefromtuya", nil);
            
        }
//        else if ([_from isEqual:@"pb"])
//        {
//        
//            _fromLabel.frame=CGRectMake(20, MediaViewRect.size.height+2*CellMarge, 40, 18);
//            
//             
//            _fromLabel.text= NSLocalizedString(@"comefromIceBreak", nil);
//            
//            
//        }else if([_from isEqual:@"pb"])
//        {
//            _fromLabel.frame=CGRectMake(20, MediaViewRect.size.height+2*CellMarge, 120, 18);
//            
//            
//            _fromLabel.text= NSLocalizedString(@"comefromIceBreak", nil);
//        
//        }
    
         if (_type==ChatCellTypeLocation)
        {
            _fromLabel.frame=CGRectMake(20, MediaViewRect.size.height+2*CellMarge, 40,18);
        
        }
    
      CGRect rect=_fromLabel.frame;
    
      if(_showTime)
      {
          rect.origin.y=rect.origin.y+TimeLabelHeight;
      
          _fromLabel.frame=rect;
      }
  

}



-(void)iceBreak
{

   if(!(_delegate&&[_delegate respondsToSelector:@selector(pushTheNextViewController:)]))
   {
       return;
   }
    
    [_delegate pushTheNextViewController:_from];
    
    
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    //(320-AvatarWidth-15.0),height-CellMarge-30
    CGFloat fromlabellen = [_fromLabel.text sizeWithFont:[UIFont systemFontOfSize:14]].width+10;

  if([keyPath isEqualToString:@"frame"]&&context==_smileLabel)
  {
      _fromLabel.textAlignment=NSTextAlignmentCenter;

      if(!_atLeft){
        if(!_showTime)
         _fromLabel.frame=CGRectMake( SmileLabelRect.origin.x+5, SmileLabelRect.size.height+2*CellMarge+6-7, fromlabellen, 18);
         else
         {
             _fromLabel.frame=CGRectMake(SmileLabelRect.origin.x+5, SmileLabelRect.size.height+2*CellMarge+TimeLabelHeight+6-7, fromlabellen, 18);
            
         }
      }
      else{
          if(!_showTime)
              _fromLabel.frame=CGRectMake(70, SmileLabelRect.size.height+2*CellMarge+6+7-9-3, 80, 18);
          else
          {
              _fromLabel.frame=CGRectMake(70, SmileLabelRect.size.height+2*CellMarge+TimeLabelHeight+6+4-9-3, 80, 18);
          }

      }
      
  }
  else if([keyPath isEqualToString:@"frame"]&&context==_mediaView)
  {
      if(!_atLeft)
      {

          _fromLabel.textAlignment=NSTextAlignmentCenter;
          if(!_showTime)
          {
              _fromLabel.frame=CGRectMake(172, MediaViewRect.size.height+2*CellMarge+6+12, fromlabellen, 18);
              
              
          }
          else
          {
              _fromLabel.frame=CGRectMake(172, MediaViewRect.size.height+2*CellMarge+6+TimeLabelHeight+14, fromlabellen, 18);;
              
          }
      }
      else
      {
          _fromLabel.textAlignment=NSTextAlignmentCenter;
          
          if(!_showTime)
              _fromLabel.frame=CGRectMake(70, MediaViewRect.size.height+2*CellMarge+6+12+3, fromlabellen, 18);
          else
          {
              _fromLabel.frame=CGRectMake(70, MediaViewRect.size.height+2*CellMarge+6+TimeLabelHeight+15, fromlabellen, 18);;
              
          }

      
      }
    
  }
  else if([keyPath isEqualToString:@"frame"]&&context==_voiceView)
  {
  
      
      if(!_atLeft)
      {
          _fromLabel.textAlignment=NSTextAlignmentCenter;
          if(!_showTime)
          {
//              NSLog(@"= = = = = = = = = = = = =%s","eee");
              
              _fromLabel.frame=CGRectMake(VoiceViewRect.origin.x-2, VoiceViewRect.size.height+2*CellMarge+6+14, fromlabellen, 18);
              
              
          }
          else
          {
    
              _fromLabel.frame=CGRectMake(VoiceViewRect.origin.x-2, VoiceViewRect.size.height+2*CellMarge+6+TimeLabelHeight+14, fromlabellen, 18);;
              
          }
      }else
      {
          _fromLabel.textAlignment=NSTextAlignmentCenter;
          
          if(!_showTime)
              _fromLabel.frame=CGRectMake(70, VoiceViewRect.size.height+2*CellMarge+6+16, fromlabellen, 18);
          else
          {
             
              _fromLabel.frame=CGRectMake(70, VoiceViewRect.size.height+2*CellMarge+6+TimeLabelHeight+16, fromlabellen, 18);
              
          }
          
          
      }
    
  }
    
}



- (void)willMoveToSuperview:(UIView *)newSuperview
{
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation
{
    MKPinAnnotationView *pinView = nil;
    static NSString *defaultPinID = @"com.invasivecode.pin";
    pinView = (MKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:defaultPinID];
    if ( pinView == nil )
        pinView = [[[MKPinAnnotationView alloc]
                    initWithAnnotation:annotation reuseIdentifier:defaultPinID] autorelease];
    pinView.pinColor = MKPinAnnotationColorRed;
    pinView.canShowCallout = YES;
    pinView.animatesDrop = NO;
    return pinView;
}

-(void)MakeMap:(UIButton *)tap
{     
    if([self.delegate respondsToSelector:@selector(MakeBigMap)])
   {
       [_delegate MakeBigMap];
   
   }
}

- (void)dealloc
{
    [_avatar release];
    [_smileLabel release];
    [_mediaView release];
    [_statusView release];
    [_mapView release];
    
    [_voiceView release];
    
    [_smileLabel removeObserver:self forKeyPath:@"frame" context:_smileLabel];
    
    [_mediaView removeObserver:self forKeyPath:@"frame" context:_mediaView];
    
    [_voiceView removeObserver:self forKeyPath:@"frame" context:_voiceView];
        
    [super dealloc];
}

@end
