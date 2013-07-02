//
//  BanBu_DigiViewController.m
//  BanBu
//
//  Created by Jc Zhang on 13-3-7.
//
//

#import "BanBu_DigiViewController.h"
#import "AppCommunicationManager.h"
#import "TKLoadingView.h"
#import "AppDataManager.h"
#import "BanBu_ProfileViewController.h"
#import "BanBu_MyProfileViewController.h"
#import "BanBu_ChatToseePic.h"
#import "WXOpen.h"
#import "ShareViewController.h"
#import "BanBu_BroadcastTVC.h"
@interface BanBu_DigiViewController ()

@end

@implementation BanBu_DigiViewController

-(NSString*)getPreferredLanguage
{
    NSUserDefaults* defs = [NSUserDefaults standardUserDefaults];
    NSArray* languages = [defs objectForKey:@"AppleLanguages"];
    NSString* preferredLang = [languages objectAtIndex:0];
    return preferredLang;
}

-(void)dealloc{
    [_soundTime release];
    [_sendSoundData release];
    [replyList release];
    self.showPhotos = nil;
    self.chatView = nil;
    self.broadTableView = nil;
    self.inputTextView = nil;
    self.broadcast = nil;
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"seeProfile" object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"playVoice" object:nil];
    [super dealloc];
    
}

- (id)initWithBroadcast:(NSDictionary *)broadcastDic{
    self = [super init];
    if (self) {
        
        _broadcast = [[NSMutableDictionary alloc] initWithDictionary:broadcastDic];
        _showPhotos=[[NSMutableArray alloc]initWithCapacity:10];

        NSLog(@"%@",_broadcast);
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.title = [MyAppDataManager IsMinGanWord:[MyAppDataManager theRevisedName:[_broadcast valueForKey:@"pname"] andUID:[_broadcast valueForKey:@"userid"]]];

    if([MyAppDataManager.useruid isEqualToString:[_broadcast valueForKey:@"userid"]]){
        UIButton *moreButton = [UIButton buttonWithType:UIButtonTypeCustom];
        moreButton.frame = CGRectMake(0, 0, 50, 30);
        moreButton.titleLabel.font = [UIFont systemFontOfSize:14];
        [moreButton setBackgroundImage:[[UIImage imageNamed:@"app_nav_btn_bg1.png"] stretchableImageWithLeftCapWidth:15.0 topCapHeight:15.0] forState:UIControlStateNormal];
        [moreButton setImage:[UIImage imageNamed:@"delete_brocast.png"] forState:UIControlStateNormal];
        //    [moreButton setTitle:NSLocalizedString(@"moreTitle", nil) forState:UIControlStateNormal];
        [moreButton addTarget:self action:@selector(moreAction) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *rightItem = [[[UIBarButtonItem alloc] initWithCustomView:moreButton] autorelease];
        self.navigationItem.rightBarButtonItem = rightItem;
    }
 
    UITableView *aTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, 320, __MainScreen_Height-88) style:UITableViewStylePlain];
    aTableView.delegate = self;
    aTableView.dataSource = self;
    aTableView.backgroundColor = [UIColor colorWithRed:255.0/255 green:250.0/255 blue:240.0/255 alpha:1.0];
    aTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.broadTableView = aTableView;
    [self.view addSubview:aTableView];
    [aTableView release];
    
    
    
    UIImageView *bkView = [[UIImageView alloc] initWithFrame:CGRectMake(0, -400, 320, 400)];
    bkView.image = [UIImage imageNamed:@"bgdark_profile.png"];
    [self.broadTableView addSubview:bkView];
    [bkView release];
    //TableViewHeader
    UIImageView *headerView = [[UIImageView alloc]initWithFrame:CGRectZero];
    {
        NSDictionary *conDic = [_broadcast valueForKey:@"mcontent"];
        //头像
        UIButton *_iconButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _iconButton.frame = CGRectMake(10, 10, 35, 35);
        
        //        _iconButton.layer.borderColor = [[UIColor blackColor]CGColor];
        //        _iconButton.layer.borderWidth = 1.0;
        _iconButton.layer.cornerRadius = 3.0;
        _iconButton.layer.masksToBounds = YES;
        [_iconButton setImageWithURL:[NSURL URLWithString:[_broadcast valueForKey:@"uface"]] placeholderImage:[UIImage imageNamed:@"icon_default.png"] andType:1];
        [_iconButton addTarget:self action:@selector(seeProfile) forControlEvents:UIControlEventTouchUpInside];
        //        [_iconButton setImage:[UIImage imageNamed:@"msg_fbtn1.png"] forState:UIControlStateNormal];
        [headerView addSubview:_iconButton];
        
        //名字
        UILabel *_nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(55, 10, 160, 17)];
        _nameLabel.backgroundColor = [UIColor clearColor];
        _nameLabel.text = [_broadcast objectForKey:@"pname"];
        _nameLabel.font = [UIFont boldSystemFontOfSize:13];
        _nameLabel.textColor = [UIColor blackColor];
        [headerView addSubview:_nameLabel];
        [_nameLabel release];
        //距离与到达时间
        UILabel *_distanceAndTimeLabel = [[UILabel alloc]initWithFrame:CGRectMake(55, 27, 160, 17)];
        _distanceAndTimeLabel.backgroundColor = [UIColor clearColor];
        _distanceAndTimeLabel.text =  [NSString stringWithFormat:@"%@/%@",[_broadcast objectForKey:@"admeter"],[_broadcast objectForKey:@"adtime"]];
        _distanceAndTimeLabel.font = [UIFont boldSystemFontOfSize:13];
        _distanceAndTimeLabel.textColor = [UIColor lightGrayColor];
        [headerView addSubview:_distanceAndTimeLabel];
        [_distanceAndTimeLabel release];
        
        //最新发布时间
        UILabel *_lastTimeLabel = [[UILabel alloc]initWithFrame:CGRectMake(235, 10, 75, 17)];
        _lastTimeLabel.backgroundColor = [UIColor clearColor];
        _lastTimeLabel.text = [_broadcast valueForKey:@"mtime"];
        _lastTimeLabel.textAlignment = UITextAlignmentRight;
        _lastTimeLabel.font = [UIFont boldSystemFontOfSize:13];
        _lastTimeLabel.textColor = [UIColor lightGrayColor];
        [headerView addSubview:_lastTimeLabel];
        [_lastTimeLabel release];
        
        
        //标签view
        UIView *_tagsView = [[UIView alloc]initWithFrame:CGRectZero];
        _tagsView.backgroundColor = [UIColor clearColor];
        [headerView addSubview:_tagsView];
        [_tagsView release];
        //文字（可选）
        _sayTextLabel = [[UILabel alloc]initWithFrame:CGRectMake(55, 44, 235, 0)];
//        _sayTextLabel.text = [MyAppDataManager IsInternationalLanguage:[MyAppDataManager IsMinGanWord:[conDic objectForKey:@"saytext"]]];
        _sayTextLabel.textColor = [UIColor blackColor];
        _sayTextLabel.font = [UIFont systemFontOfSize:13];
        _sayTextLabel.backgroundColor = [UIColor clearColor];
        CGFloat textLabelHeight = 0;
        if(![_sayTextLabel.text isEqualToString:@""]){
            NSString *saytext = [conDic objectForKey:@"saytext"];
            if([saytext rangeOfString:@"-->"].location != NSNotFound && [saytext rangeOfString:@"<--"].location != NSNotFound){
                
                //            NSLog(@"%@------%d%d",[saytext substringWithRange:NSMakeRange(start, end-start)],start,end);
                NSInteger start=[saytext rangeOfString:@"<--"].location+3;
                NSInteger end = [saytext rangeOfString:@"-->"].location;
                _sayTextLabel.text = [saytext substringToIndex:start-3];
                textLabelHeight = [_sayTextLabel.text sizeWithFont:[UIFont systemFontOfSize:13] constrainedToSize:CGSizeMake(235, 100) lineBreakMode:NSLineBreakByTruncatingMiddle].height;
                
                _sayTextLabel.frame = CGRectMake(55, 55, 235, textLabelHeight);
                
                textLabelHeight += 5;
                
                NSString *tagString = [saytext substringWithRange:NSMakeRange(start, end-start)];
                NSLog(@"%@",tagString);
                NSArray *tagArray = [tagString componentsSeparatedByString:@" "];
                NSLog(@"%@",tagArray);
                CGFloat height= 0,width = 0;
                for(int i= 0;i<tagArray.count;i++){
                    NSString *buttonTitle = [NSString stringWithFormat:@"#%@",[tagArray objectAtIndex:i]];
                    UIButton *aButton = [UIButton buttonWithType:UIButtonTypeCustom];
                    aButton.backgroundColor = [UIColor clearColor];
                    [aButton setTitle:buttonTitle forState:UIControlStateNormal];
                    aButton.titleLabel.font = [UIFont systemFontOfSize:13];
                    [aButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
                    CGFloat buttonLength = [buttonTitle sizeWithFont:[UIFont systemFontOfSize:13]].width;
                    if(width > 235-buttonLength){
                        width = 0;
                        height += 15;
                    }
                    aButton.frame = CGRectMake(width, height, buttonLength, 17);
                    width += buttonLength+5;
                    [aButton addTarget:self action:@selector(goSearchBroad:) forControlEvents:UIControlEventTouchUpInside];
                    [_tagsView addSubview:aButton];
                    
                }
                _tagsView.frame = CGRectMake(55, 55+textLabelHeight, 235, height+17);
                _tagsView.backgroundColor = [UIColor clearColor];
                textLabelHeight += height + 17;
                
                
            }
            else{
                _sayTextLabel.text = [conDic objectForKey:@"saytext"];
                textLabelHeight = [_sayTextLabel.text sizeWithFont:[UIFont systemFontOfSize:13] constrainedToSize:CGSizeMake(235, 100) lineBreakMode:NSLineBreakByTruncatingMiddle].height;
                _sayTextLabel.frame = CGRectMake(55, 55, 235, textLabelHeight);
 
            }
        }
 
        _sayTextLabel.numberOfLines = 0;
        [headerView addSubview:_sayTextLabel];
        [_sayTextLabel release];

      
        
        //主图片
        if(textLabelHeight>0){
            textLabelHeight += 10;
        }
        CGFloat headImageViewHeight = 0;

//        if(self.sendImageData){
//           _headImageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 55+textLabelHeight, 300, 300)];
//            headImageViewHeight = 300+10;
//        }else{
            _headImageView = [[UIImageView alloc]initWithFrame:CGRectZero];
        
//        }
        
//        _headImageView.image = [UIImage imageWithData:self.sendImageData];
//        _headImageView.image = [UIImage imageNamed:@"photo_default.png"];
        _headImageView.userInteractionEnabled = YES;
        [headerView addSubview:_headImageView];
        [_headImageView release];
        
        //单击手势
        UITapGestureRecognizer *aTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(seeOriginalImage)];
        [_headImageView addGestureRecognizer:aTap];
        [aTap release];
        
        //播放按钮(可选)
        UIButton *_playButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _playButton.hidden = YES;
        [_playButton setImage:[UIImage imageNamed:@"播放语音_未按下.png"] forState:UIControlStateNormal];
//        [_playButton addTarget:self action:@selector(play:) forControlEvents:UIControlEventTouchUpInside];
        [headerView addSubview:_playButton];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(playAction:)];
        [_playButton addGestureRecognizer:tap];
        [tap release];
        
        NSArray *animationImages = [NSArray arrayWithObjects:@"feed_comment_player_pause_anim1.png",@"feed_comment_player_pause_anim2.png",@"feed_comment_player_pause_anim3.png", nil];
        NSMutableArray *images = [NSMutableArray arrayWithCapacity:6];
        for(NSString *path in animationImages){
            
            [images addObject:[UIImage imageNamed:path]];
        }
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(18+5, 7, 10, 12)];
        imageView.image = [UIImage imageNamed:@"audio_s_play.png"];
        imageView.userInteractionEnabled = YES;
        imageView.animationImages = images;
        imageView.animationDuration = 1.0;
        [_playButton addSubview:imageView];
        self.playingView = imageView;
        [imageView release];
        
        UILabel *aLabel = [[UILabel alloc]initWithFrame:CGRectMake(105-10-40, 3, 40, 20)];
        aLabel.backgroundColor = [UIColor clearColor];
        aLabel.textColor = [UIColor whiteColor];
        aLabel.font = [UIFont systemFontOfSize:14];
        aLabel.textAlignment= UITextAlignmentRight;

        [_playButton addSubview:aLabel];
        [aLabel release];
        
        //解base64的“mcontent”的内容

        for(NSDictionary *aDic in [conDic valueForKey:@"attach"]){
            if([[aDic valueForKey:@"type"] isEqualToString:@"sound"]){

                if(![[aDic valueForKey:@"content"] isEqualToString:@""]){
                    _playButton.hidden = NO;
                    _playButton.frame = CGRectMake( 160-105/2,_headImageView.frame.origin.y+ _headImageView.frame.size.height-13, 105, 26);
                    [_playButton setTitle:[NSString stringWithFormat:@"0,%@",[aDic valueForKey:@"content"]] forState:UIControlStateNormal];
                    
                    //语音的时间
                    if([aDic valueForKey:@"length"]){
                        aLabel.text = [NSString stringWithFormat:@"%@\"",[aDic valueForKey:@"length"]];
                        
                    }
                    
                    //有录音高度加button的一半
                    headImageViewHeight = 300+23;

                }
                


            }
            else if([[aDic valueForKey:@"type"] isEqualToString:@"image"]){
                //                NSLog(@"%@----------%@",[aDic valueForKey:@"content"],[[SDWebImageManager sharedManager] imageWithURL:[NSURL URLWithString:[conDic valueForKey:@"content"]]]);
                _headImageView.frame = CGRectMake(10, 55+textLabelHeight, 300, 300) ;
                headImageViewHeight = 300+10;
                headImageString = [NSString stringWithString:[aDic valueForKey:@"content"]];
                [_headImageView setImageWithURL:[NSURL URLWithString:[NSString stringWithString:[aDic valueForKey:@"content"]]]];

            }
        }

        //附加功能
        for(int i=0;i<4;i++){
            UIButton *aButton = [UIButton buttonWithType:UIButtonTypeCustom];
            aButton.tag = i+1;
            if(i<3){
                aButton.frame = CGRectMake(15+22.5+i*(71), 55+textLabelHeight+headImageViewHeight, 32, 32);
                NSLog(@"%f",aButton.frame.origin.y);
                UILabel *aLabel = [[UILabel alloc]initWithFrame:CGRectMake(15+22.5+i*(71)+32+6, aButton.frame.origin.y+16, 32, 16)];
                aLabel.backgroundColor = [UIColor clearColor];
                aLabel.tag = aButton.tag*10;
                if(i==0){
                    NSLog(@"%@",[_broadcast valueForKey:@"comments"]);
                    if([[_broadcast valueForKey:@"comments"]integerValue]>0){
                        aLabel.text = [NSString stringWithFormat:@"%@+",[_broadcast valueForKey:@"comments"]];

                    }
 //                    NSLog(@"%@",aLabel.text);
                }else if(i==1){
                    if([[_broadcast valueForKey:@"vote"]integerValue]>0){

                        aLabel.text = [NSString stringWithFormat:@"%@+",[_broadcast valueForKey:@"vote"]];
                    }
                  }else if(i==2){
                    if([[_broadcast valueForKey:@"share"]integerValue]>0){
                        aLabel.text = [NSString stringWithFormat:@"%@+",[_broadcast valueForKey:@"share"]];


                        
                    }
                 }
                aLabel.font = [UIFont systemFontOfSize:12];
                aLabel.textColor = [UIColor redColor];
                [headerView addSubview:aLabel];
                [aLabel release];

            }else{
                aButton.frame = CGRectMake(15+22.5+3*(71), 55+textLabelHeight+headImageViewHeight, 32, 32);

            }
            [aButton setImage:[UIImage imageNamed:[NSString stringWithFormat:@"addfun%d.png",i+1]] forState:UIControlStateNormal];
            [aButton setImage:[UIImage imageNamed:[NSString stringWithFormat:@"addfun%d_select.png",i+1]] forState:UIControlStateHighlighted];
            [aButton addTarget:self action:@selector(addfun:) forControlEvents:UIControlEventTouchUpInside];
            [headerView addSubview:aButton];

            
        }
        
        //计算headerView的高度
        CGRect arect = headerView.frame;
        arect.size.height = 55+textLabelHeight+headImageViewHeight+32 + 15;
        headerView.frame = arect;
        
    }
    headerView.userInteractionEnabled = YES;
    headerView.image = [[UIImage imageNamed:@"listbg.png"] stretchableImageWithLeftCapWidth:2.0 topCapHeight:4.0];
    self.broadTableView.tableHeaderView = headerView;
    [headerView release];

    
    //toolbar
    {
        UIImageView *aView = [[UIImageView alloc]initWithFrame:CGRectMake(-1, __MainScreen_Height-88, 321, 44)];
//        aView.backgroundColor = [UIColor lightGrayColor];
        aView.userInteractionEnabled = YES;
        aView.image = [[UIImage imageNamed:@"comment_publisher_bg.9.png"]stretchableImageWithLeftCapWidth:15.0 topCapHeight:15.0];
        self.chatView = aView;
        [self.view addSubview:self.chatView];
        [aView release];
        
        _textAndSoundBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _textAndSoundBtn.frame = CGRectMake(10, 7, 30, 30);
        [_textAndSoundBtn setImage:[UIImage imageNamed:@"文字输入模式_未按下.png"] forState:UIControlStateNormal];
        [_textAndSoundBtn setImage:[UIImage imageNamed:@"文字输入模式_按下去.png"] forState:UIControlStateHighlighted];

        [_textAndSoundBtn addTarget:self action:@selector(changeBtn:) forControlEvents:UIControlEventTouchUpInside];
        [self.chatView addSubview:_textAndSoundBtn];
        
        UITextView *aTextView = [[UITextView alloc]initWithFrame:CGRectMake(50, 7, 200, 30)];
        aTextView.layer.borderColor = [UIColor grayColor].CGColor;
        aTextView.layer.borderWidth = 1.0;
        aTextView.layer.cornerRadius = 15;
        aTextView.textAlignment = UITextAlignmentLeft;
        aTextView.font = [UIFont systemFontOfSize:15];
        aTextView.hidden = YES;
        aTextView.delegate = self;
        self.inputTextView = aTextView;
        [aTextView release];
        [self.chatView addSubview:self.inputTextView];
        
        //录音按钮
        UIButton *voiceButton = [UIButton buttonWithType:UIButtonTypeCustom];
        voiceButton.frame = CGRectMake(50, 7, 200+58, 30);
        voiceButton.layer.cornerRadius = 15;
        [voiceButton setImage:[UIImage imageNamed:@"长条语音按钮.png"]  forState:UIControlStateNormal];
         [voiceButton addTarget:self action:@selector(voiceTap) forControlEvents:UIControlEventTouchUpInside];
        
        UILabel *tipLabel = [[UILabel alloc]initWithFrame:CGRectMake(60, 3, 180, 24)];
        tipLabel.text = NSLocalizedString(@"longVoice", nil);
        tipLabel.font = [UIFont systemFontOfSize:15];
        tipLabel.backgroundColor = [UIColor clearColor];
        [voiceButton addSubview:tipLabel];
        [tipLabel release];
        
        self.tabvoiceButton = voiceButton;
        [self.chatView addSubview:voiceButton];
        
        UILongPressGestureRecognizer *aLongPress = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(voiceAction:)];
        [voiceButton addGestureRecognizer:aLongPress];
        [aLongPress release];
        
        //发送按钮
        sendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        sendBtn.hidden = YES;
        sendBtn.frame = CGRectMake(310-48, 7, 48, 29);
        [sendBtn setImage:[UIImage imageNamed:@"广播_发送.png"] forState:UIControlStateNormal];
        [sendBtn setImage:[UIImage imageNamed:@"广播_发送_按下.png"] forState:UIControlStateHighlighted];

        [sendBtn addTarget:self action:@selector(sendTextReply) forControlEvents:UIControlEventTouchUpInside];
        [self.chatView addSubview:sendBtn];
        
        //监听键盘高度
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardShowNotify:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardShowNotify:) name:UIKeyboardWillHideNotification object:nil];
    }
    //监听查看个人资料按钮和语音播放按钮
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(seeProfile:) name:@"seeProfile" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(playVoiceButton:) name:@"playVoice" object:nil];
    
    replyList = [[NSArray alloc]initWithArray:[_broadcast valueForKey:@"replylist"]];
}


//点击标签

-(void)goSearchBroad:(UIButton *)sender{
    
    [[NSNotificationCenter defaultCenter]postNotificationName:@"xiangqingAction" object:sender];
    [self.navigationController popViewControllerAnimated:YES];
    
}

-(void)viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:animated];
    if(!_isRefreshContent){
        
        NSMutableDictionary *pars = [NSMutableDictionary dictionaryWithCapacity:1];
        [pars setValue:[_broadcast valueForKey:@"actid"] forKey:@"actid"];
        [AppComManager getBanBuData:BanBu_Get_Broadcast par:pars delegate:self];
        _isRefreshContent = YES;
    }
  
    
//    NSDictionary *conDic =  [AppComManager getAMsgFrom64String:[_broadcast valueForKey:@"mcontent"]];
//
//    for(NSDictionary *aDic in [conDic valueForKey:@"attach"]){
//        if([[aDic valueForKey:@"type"] isEqualToString:@"image"]){
//            if(![[aDic valueForKey:@"content"] isEqualToString:@""]){
//                NSLog(@"%@",[aDic valueForKey:@"content"]);
//                [_headImageView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[aDic valueForKey:@"content"]]] placeholderImage:[UIImage imageNamed:@"photo_default.png"]];
//                break;
//
//            }
//        }
//    }
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [AppComManager cancalHandlesForObject:self];

}

//更多功能

-(void)moreAction{
    
    UIActionSheet *deleteSheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:NSLocalizedString(@"cancelNotice", nil) destructiveButtonTitle:NSLocalizedString(@"deleteButton", nil) otherButtonTitles: nil];
    deleteSheet.tag = 1;
    [deleteSheet showInView:self.view];
    
}


//点击看原图

-(void)seeOriginalImage{
    MWPhoto *photo=[MWPhoto photoWithImage:_headImageView.image];
    
    [_showPhotos removeAllObjects];
    
    [_showPhotos addObject:photo];
    BanBu_ChatToseePic *broadSeePic = [[BanBu_ChatToseePic alloc]initWithDelegate:self];
//    broadSeePic.displayActionButton = YES;
    broadSeePic.type = DrawTypeBroadcast;
    broadSeePic.shareArr = [NSMutableArray arrayWithObjects:_headImageView.image,headImageString, nil];
    UINavigationController *aNc = [[UINavigationController alloc]initWithRootViewController:broadSeePic];
    [self presentModalViewController:aNc animated:YES];
    [broadSeePic release];
    [aNc release];
                                   
}

#pragma mark - MWPhotoManager

- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser {
    return 1;
}

- (MWPhoto *)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index {
    if (index < _showPhotos.count)
        return [_showPhotos objectAtIndex:index];
    return nil;
    
}

//回复录音

-(void)voiceTap{
    
    [TKLoadingView showTkloadingAddedTo:self.view title:NSLocalizedString(@"timeshortNoticte", nil) activityAnimated:NO duration:1.0];
    
}

-(void)voiceAction:(UILongPressGestureRecognizer *)sender{
    

    UIButton *button = (UIButton *)sender.view;
        if(button.selected)
        {
            CGPoint point = [sender locationInView:_recordView];
            if(sender.state == UIGestureRecognizerStateEnded)
            {
                button.selected = NO;
                [_recordView touchesEndInView:point];
                _recordView = nil;
            }else{
                
                [_recordView touchesMovedInView:point];
                
            }
            
            return;
        }
        button.selected = YES;
        _recordView = [[RecordView alloc]initWithFrame:CGRectMake(0, 0, 320, __MainScreen_Height+20)];
        NSString *fileName = @"huifu.amr";
        _recordView.audioPath = [AppComManager pathForMedia:fileName];
        NSLog(@"%@", [AppComManager pathForMedia:fileName]);
        _recordView.delegate = self;
        [self.navigationController.view addSubview:_recordView];
        [_recordView release];

    
}

#pragma mark - RecordView Delegate

-(void)recordView:(RecordView *)recordView recordDidCompleted:(NSData *)audioData recordTime:(int)duration{
    
    if([audioData length]<100){
        
        [TKLoadingView showTkloadingAddedTo:self.view title:NSLocalizedString(@"timeshortNoticte", nil) activityAnimated:NO duration:1.0];
        return;
    }
    _sendSoundData = [[NSData alloc]initWithData:audioData];
    _soundTime = [[NSString alloc]initWithFormat:@"%d",duration];
    if(_sendSoundData.length){
        
        
        NSMutableDictionary *sendDic = [NSMutableDictionary dictionaryWithCapacity:1];
        [sendDic setValue:@"amr" forKey:@"extname"];
        [AppComManager uploadBanBuBroadcastMedia:_sendSoundData mediaName:@"huifu" par:sendDic delegate:self];
        [TKLoadingView showTkloadingAddedTo:self.navigationController.view title:NSLocalizedString(@"chuliNotice", nil) activityAnimated:YES];
        self.navigationController.view.userInteractionEnabled = NO;
    
    }
    
    
//    NSLog(@"%d",duration);
    
}

//看主贴个人资料、播放语音

-(void)seeProfile{
    
    BanBu_PeopleProfileController *peopleFfofile = [[BanBu_PeopleProfileController alloc] initWithProfile:_broadcast displayType:DisplayTypePeopleProfile];
    peopleFfofile.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:peopleFfofile animated:YES];
    [peopleFfofile release];
}

//看回复个人资料、播放语音

-(void)seeProfile:(NSNotification *)notifi{
    //    NSLog(@"%@",sender.titleLabel.text);
    UIButton *sender = (UIButton *)[notifi object];

    NSDictionary *aDic = [NSDictionary dictionaryWithDictionary:[replyList objectAtIndex:[sender.titleLabel.text intValue]]];
//    NSLog(@"%@",aDic);
    BanBu_PeopleProfileController *peopleFfofile = [[BanBu_PeopleProfileController alloc] initWithProfile:aDic displayType:DisplayTypePeopleProfile];
    peopleFfofile.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:peopleFfofile animated:YES];
    [peopleFfofile release];
}

-(void)playAction:(UITapGestureRecognizer *)tap{
    
    [[NSNotificationCenter defaultCenter]postNotificationName:@"playVoice" object:(UIButton *)tap.view];

}

-(void)play:(UIButton *)sender{
    
    [[NSNotificationCenter defaultCenter]postNotificationName:@"playVoice" object:sender];
    
}


//附加功能按钮

-(void)addfun:(UIButton*)sender{
    
    if(sender.tag == 1){
        [self.inputTextView becomeFirstResponder];
        [_textAndSoundBtn setImage:[UIImage imageNamed:@"语音输入模式_未按下.png"] forState:UIControlStateNormal];
        [_textAndSoundBtn setImage:[UIImage imageNamed:@"语音输入模式_按下去.png"] forState:UIControlStateHighlighted];
        self.inputTextView.hidden = NO;
        self.tabvoiceButton.hidden = YES;
        sendBtn.hidden = NO;
        self.tabvoiceButton.frame = CGRectMake(50, 7, 200, 30);
        _textAndSoundBtn.selected = YES;
        //评论
    }else if(sender.tag == 2){
        //赞
        
        if(!labelSelect){
            NSMutableDictionary *pars = [NSMutableDictionary dictionaryWithCapacity:1];
            [pars setValue:[_broadcast valueForKey:@"actid"] forKey:@"actid"];
            [pars setValue:@"l" forKey:@"type"];
            [AppComManager getBanBuData:BanBu_Vote_Broadcast par:pars delegate:self];
            labelSelect = 2*10;
        }else{
            [TKLoadingView showTkloadingAddedTo:self.navigationController.view title:NSLocalizedString(@"zan_failed", nil) activityAnimated:NO duration:2.0];

        }
      

    }else if(sender.tag == 3){
        //分享
        UIActionSheet *actionSheet;
        NSString *langauage=[self getPreferredLanguage];
        if([langauage isEqual:@"zh-Hans"]){
            actionSheet = [[[UIActionSheet alloc] initWithTitle:nil delegate:self
                                                                   cancelButtonTitle:NSLocalizedString(@"cancelNotice", nil) destructiveButtonTitle:nil
                                                                   otherButtonTitles:NSLocalizedString(@"分享到微信、微博", nil),NSLocalizedString(@"分享到QQ空间、人人网", nil),  nil] autorelease];;
        }else{
                actionSheet = [[[UIActionSheet alloc] initWithTitle:nil delegate:self
                                                    cancelButtonTitle:NSLocalizedString(@"cancelNotice", nil) destructiveButtonTitle:nil
                                                    otherButtonTitles: @"Twitter",@"Facebook",  nil] autorelease];
        }
        [actionSheet showInView:self.view];
        
    }else if(sender.tag == 4){
        //举报
      
        
        NSMutableArray *reportArr = [NSMutableArray array];
        if([UserDefaults valueForKey:@"reportList"]){
            [reportArr addObjectsFromArray:[UserDefaults valueForKey:@"reportList"]];
            BOOL isHave = NO;
            for(NSString *tem in reportArr){
                if([[_broadcast valueForKey:@"actid"] isEqualToString:tem]){
                    isHave = YES;
                    break;
                }
            }
            if(!isHave){
                NSMutableDictionary *pars = [NSMutableDictionary dictionaryWithCapacity:1];
                [pars setValue:[_broadcast valueForKey:@"actid"] forKey:@"actid"];
                [AppComManager getBanBuData:BanBu_Report_Broadcat par:pars delegate:self];
                self.navigationController.view.userInteractionEnabled = NO;
                [reportArr addObject:[_broadcast valueForKey:@"actid"]];
                [UserDefaults setValue:reportArr forKey:@"reportList"];
            }else{
                [TKLoadingView showTkloadingAddedTo:self.navigationController.view title:NSLocalizedString(@"reportNotice", nil) activityAnimated:NO duration:2.0];

            }
      
        }
        else{
            NSMutableDictionary *pars = [NSMutableDictionary dictionaryWithCapacity:1];
            [pars setValue:[_broadcast valueForKey:@"actid"] forKey:@"actid"];
            [AppComManager getBanBuData:BanBu_Report_Broadcat par:pars delegate:self];
            self.navigationController.view.userInteractionEnabled = NO;
            
            
            
            [reportArr addObject:[_broadcast valueForKey:@"actid"]];
            [UserDefaults setValue:reportArr forKey:@"reportList"];
        }
     
    }
}

//回复文字与语音的切换

-(void)changeBtn:(UIButton *)sender{
    if(_textAndSoundBtn.selected){
        [_textAndSoundBtn setImage:[UIImage imageNamed:@"文字输入模式_未按下.png"] forState:UIControlStateNormal];
        [_textAndSoundBtn setImage:[UIImage imageNamed:@"文字输入模式_按下去.png"] forState:UIControlStateHighlighted];
        self.inputTextView.hidden = YES;
        self.tabvoiceButton.hidden = NO;
        sendBtn.hidden = YES;
        self.tabvoiceButton.frame = CGRectMake(50, 7, 200+58, 30);
        
        [self.inputTextView resignFirstResponder];
        
    }else{
        [_textAndSoundBtn setImage:[UIImage imageNamed:@"语音输入模式_未按下.png"] forState:UIControlStateNormal];
        [_textAndSoundBtn setImage:[UIImage imageNamed:@"语音输入模式_按下去.png"] forState:UIControlStateHighlighted];
        self.inputTextView.hidden = NO;
        self.tabvoiceButton.hidden = YES;
        sendBtn.hidden = NO;
        self.tabvoiceButton.frame = CGRectMake(50, 7, 200, 30);
        [self.inputTextView becomeFirstResponder];
    }
    NSLog(@"%d",sender.selected);
    _textAndSoundBtn.selected = !sender.selected;

}

//监听键盘的收起展开

-(void)keyboardReset{
    [self.inputTextView resignFirstResponder];
    [_textAndSoundBtn setImage:[UIImage imageNamed:@"文字输入模式_未按下.png"] forState:UIControlStateNormal];
    [_textAndSoundBtn setImage:[UIImage imageNamed:@"文字输入模式_按下去.png"] forState:UIControlStateHighlighted];
    self.inputTextView.hidden = YES;
 
  self.tabvoiceButton.hidden = NO;
    sendBtn.hidden = YES;
    self.tabvoiceButton.frame = CGRectMake(50, 7, 200+58, 30);
    _textAndSoundBtn.selected = NO;
}

-(void)keyboardShowNotify:(NSNotification *)notification{
    
    CGFloat keyboardHeight = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey]CGRectValue].size.height;
//    NSLog(@"%f,%@",keyboardHeight,notification.name);

    CGRect frame = self.chatView.frame;
    frame.origin.y = __MainScreen_Height-88-keyboardHeight;
    CGFloat subHeight = fabsf(frame.origin.y-self.chatView.frame.origin.y);
//    NSLog(@"%f",subHeight);
    if(subHeight == 36){
        CGRect frame = self.chatView.frame;
        frame.origin.y = __MainScreen_Height-88-keyboardHeight;
        self.chatView.frame = frame;
        return;
    }
    if([notification.name isEqualToString:UIKeyboardWillHideNotification]){
        keyboardHeight = 0;
    }
    [UIView animateWithDuration:0.25 animations:^{
        
        CGRect frame = self.chatView.frame;
        frame.origin.y = __MainScreen_Height-88-keyboardHeight;
        self.chatView.frame = frame;
        frame = self.broadTableView.frame;
        frame.origin.y = -keyboardHeight;

        self.broadTableView.frame = frame;
        
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//发送文字回复

-(void)sendTextReply{
    
    if(![[self.inputTextView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]isEqualToString:@""]){
        [self keyboardReset];
        NSMutableDictionary *abrd = [NSMutableDictionary dictionaryWithCapacity:2];
        [abrd setValue:[MyAppDataManager IsMinGanWord:self.inputTextView.text] forKey:@"saytext"];
        //    [abrd setValue:[NSArray array] forKey:@"attach"];
        NSMutableDictionary *pars = [NSMutableDictionary dictionaryWithCapacity:1];
        [pars setValue:[_broadcast valueForKey:@"actid"] forKey:@"replyid"];
        [pars setValue:abrd forKey:@"says"];
        [AppComManager getBanBuData:BanBu_Reply_Broadcast par:pars delegate:self];
        self.navigationController.view.userInteractionEnabled = NO;
        [TKLoadingView showTkloadingAddedTo:self.navigationController.view title:NSLocalizedString(@"sendingNotice", nil) activityAnimated:YES];
    }
    
    self.inputTextView.text = @"";

}

#pragma mark - UIActionSheetDelegate

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    NSLog(@"%d",buttonIndex);
    if(actionSheet.tag == 1){
        if(buttonIndex == 0){
            [[NSNotificationCenter defaultCenter]postNotificationName:@"delete_Broadcast" object:[_broadcast valueForKey:@"actid"]];
            
            [self.navigationController popViewControllerAnimated:YES];
        }
        
    }
    else if(actionSheet.tag ==10010){
        
        
        if(buttonIndex == 0){
            MyWXOpen.scene = WXSceneSession;
            NSData *adat = UIImageJPEGRepresentation(_headImageView.image, 1.0);

            if(_headImageView.image){
                 for(float i=1;i>0;i=i*0.90){
                     adat = UIImageJPEGRepresentation(_headImageView.image, i);

//                    NSLog(@"%f-----%d",i,adat.length);
                    if(adat.length<25000){
                        break;
                    }
                }
                //微信小图限制在35K内。
                [MyWXOpen sendImageContentWithImageData:UIImageJPEGRepresentation(_headImageView.image, 1.0) andThumbData:adat];
 
            }else{
                [MyWXOpen sendTextContent:_sayTextLabel.text];
            }
            
            
        }
        else if(buttonIndex == 1){
            MyWXOpen.scene = WXSceneTimeline;
            NSData *adat = UIImageJPEGRepresentation(_headImageView.image, 1.0);

            if(_headImageView.image){
                for(float i=1;i>0;i=i*0.90){
                    adat = UIImageJPEGRepresentation(_headImageView.image, i);
                    
                    //                    NSLog(@"%f-----%d",i,adat.length);
                    if(adat.length<25000){
                        break;
                    }
                }
                //微信小图限制在35K内。
                [MyWXOpen sendImageContentWithImageData:UIImageJPEGRepresentation(_headImageView.image, 1.0) andThumbData:adat];

            }else{
                [MyWXOpen sendTextContent:_sayTextLabel.text];

            }
            
        }
        else if(buttonIndex == 2){
            
            if([[UserDefaults valueForKey:@"sinaUser"] length]){
                WBEngine *_wbEngine = [[WBEngine alloc] initWithAppKey:kWBSDKDemoAppKey appSecret:kWBSDKDemoAppSecret];
                [_wbEngine setDelegate:self];
                [_wbEngine setRootViewController:self];
                [_wbEngine setRedirectURI:@"http://www.halfeet.com"];
                [_wbEngine setIsUserExclusive:NO];
                
                //NSLog(@"%@",_receiveImage);
                [_wbEngine sendWeiBoWithText:[_sayTextLabel.text isEqualToString:@""]?@"分享个好东西":_sayTextLabel.text image: _headImageView.image];
                [TKLoadingView showTkloadingAddedTo:self.view title:NSLocalizedString(@"sendingNotice", nil) activityAnimated:YES];
                
                NSMutableDictionary *pars = [NSMutableDictionary dictionaryWithCapacity:1];
                [pars setValue:[_broadcast valueForKey:@"actid"] forKey:@"actid"];
                [pars setValue:@"s" forKey:@"type"];
                [AppComManager getBanBuData:BanBu_Vote_Broadcast par:pars delegate:self];
                labelSelect = 3*10;
                
            }else{
                BanBu_MyProfileViewController *profile = [[BanBu_MyProfileViewController alloc]autorelease];
                profile.tableView.contentOffset = CGPointMake(0, 360);
                [self.navigationController pushViewController:profile animated:YES];
            }
        }
        else if(buttonIndex == 3){
            if([[UserDefaults valueForKey:@"QUser"] length]){
                
                QWeiboAsyncApi *api = [[[QWeiboAsyncApi alloc] init] autorelease];
                NSString *tokenKey = [user valueForKey:AppTokenKey];
                NSString *tokenSecret = [user valueForKey:AppTokenSecret];
                
                NSString *imagePath = [NSTemporaryDirectory() stringByAppendingFormat:@"releaseImage"];
                UIImage *tempImage = _headImageView.image;
                UIImageView *sendImageView = [[UIImageView alloc]initWithImage:tempImage] ;
                if(sendImageView.image)
                {
                    NSData *imageData;
                    //            if(!imageData)
                    imageData = UIImageJPEGRepresentation(sendImageView.image, 0.7);
                    [imageData writeToFile:imagePath atomically:YES];
                    //                    //NSLog(@"%@",imageData);
                }
                self.connection	= [api publishMsgWithConsumerKey:AppKey
                                                  consumerSecret:AppSecret
                                                  accessTokenKey:tokenKey
                                               accessTokenSecret:tokenSecret
                                                         content:[_sayTextLabel.text isEqualToString:@""]?@"分享个好东西":_sayTextLabel.text
                                                       imageFile:sendImageView.image?imagePath:nil
                                                      resultType:RESULTTYPE_JSON
                                                        delegate:self];
                [sendImageView release];
                [TKLoadingView showTkloadingAddedTo:self.view title:NSLocalizedString(@"sendingNotice", nil) activityAnimated:YES];
                
                NSMutableDictionary *pars = [NSMutableDictionary dictionaryWithCapacity:1];
                [pars setValue:[_broadcast valueForKey:@"actid"] forKey:@"actid"];
                [pars setValue:@"s" forKey:@"type"];
                [AppComManager getBanBuData:BanBu_Vote_Broadcast par:pars delegate:self];
                labelSelect = 3*10;
                
            }else{
                
                BanBu_MyProfileViewController *profile = [[BanBu_MyProfileViewController alloc]autorelease];
                profile.tableView.contentOffset = CGPointMake(0, 360);
                [self.navigationController pushViewController:profile animated:YES];
                
            }
        }
        
    }
    else{
        NSString *langauage=[MyAppDataManager getPreferredLanguage];
        if([langauage isEqual:@"zh-Hans"]){
            
            
            
            if(buttonIndex == 1){
                NSLog(@"%@",headImageString);
                ShareViewController *share = [[ShareViewController alloc] initWithURLString:headImageString];
                share.sayContent = _sayTextLabel.text;
                 [self.navigationController pushViewController:share animated:YES];
            }else if(buttonIndex == 0){
                UIActionSheet *shareSheet=[[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:NSLocalizedString(@"cancelNotice", nil) destructiveButtonTitle:nil otherButtonTitles:@"分享给微信好友",@"分享到微信好友圈",@"分享到新浪微博",@"分享到腾讯微博", nil];
                shareSheet.tag = 10010;
                [shareSheet showInView:self.view];
                [shareSheet release];
            }

            
        }
        else{
            
            if(buttonIndex == 1){
                if([[UserDefaults valueForKey:@"FBUser"] length]){
                    
                    
                    BOOL displayedNativeDialog = [FBNativeDialogs presentShareDialogModallyFrom:self
                                                                                    initialText:nil
                                                                                          image: _headImageView.image
                                                                                            url:nil
                                                                                        handler:nil];
                    
                    if (!displayedNativeDialog) {
                        
                        [self performPublishAction:^{
                            
                            
                            [FBRequestConnection startForUploadPhoto:_headImageView.image
                                                   completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
                                                       //                                       [self showAlert:@"Photo Post" result:result error:error];
                                                       [TKLoadingView dismissTkFromView:self.view animated:NO afterShow:0.0];
                                                       [TKLoadingView showTkloadingAddedTo:self.view title:NSLocalizedString(@"shareSuccess", nil) activityAnimated:NO duration:2.0 ];
                                                       
                                                       
                                                   }];
                            
                            
                            
                        }];
                        
                    }
                    
                    
                    
                    NSMutableDictionary *pars = [NSMutableDictionary dictionaryWithCapacity:1];
                    [pars setValue:[_broadcast valueForKey:@"actid"] forKey:@"actid"];
                    [pars setValue:@"s" forKey:@"type"];
                    [AppComManager getBanBuData:BanBu_Vote_Broadcast par:pars delegate:self];
                    labelSelect = 3*10;
                }else{
                    BanBu_MyProfileViewController *profile = [[BanBu_MyProfileViewController alloc]autorelease];
                    profile.tableView.contentOffset = CGPointMake(0, 360);
                    [self.navigationController pushViewController:profile animated:YES];
                }
            }else if(buttonIndex == 0){
                if([[UserDefaults valueForKey:@"TUser"] length]){
                    FHSTwitterEngine * aEngine = [[[FHSTwitterEngine alloc]initWithConsumerKey:@"2cZXkfmSC6UrPUkhSPtfwQ" andSecret:@"mdoijXeFbK6dGVs5C61rADMOWSgFdNtPOBsxgnKw"]autorelease];
                    [aEngine loadAccessToken];
                    [TKLoadingView showTkloadingAddedTo:self.view title:NSLocalizedString(@"sendingNotice", nil) activityAnimated:YES];
                    
                    dispatch_async(GCDBackgroundThread, ^{
                        @autoreleasepool {
                            [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
                            NSError *returnCode = [aEngine postTweet:@"Share a good thing" withImageData:UIImageJPEGRepresentation( _headImageView.image, 1.0)];
                            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                            
                            NSString *title = nil;
                            //                                NSString *message = nil;
                            
                            if (returnCode) {
                                //                                    title = [NSString stringWithFormat:@"Error %d",returnCode.code];
                                //                                    message = returnCode.domain;
                                title = NSLocalizedString(@"errcode_fail", nil);
                            } else {
                                //                                    title = @"Tweet Posted";
                                //                                    message = tweetField.text;
                                title = NSLocalizedString(@"shareSuccess", nil);
                            }
                            
                            dispatch_sync(GCDMainThread, ^{
                                [TKLoadingView dismissTkFromView:self.view animated:NO afterShow:0.0];
                                [TKLoadingView showTkloadingAddedTo:self.view title:title activityAnimated:NO duration:2.0];
                            });
                        }
                    });
                    NSMutableDictionary *pars = [NSMutableDictionary dictionaryWithCapacity:1];
                    [pars setValue:[_broadcast valueForKey:@"actid"] forKey:@"actid"];
                    [pars setValue:@"s" forKey:@"type"];
                    [AppComManager getBanBuData:BanBu_Vote_Broadcast par:pars delegate:self];
                    labelSelect = 3*10;
                    
                }else{
                    
                    
                    BanBu_MyProfileViewController *profile = [[BanBu_MyProfileViewController alloc]autorelease];
                    profile.tableView.contentOffset = CGPointMake(0, 360);
                    [self.navigationController pushViewController:profile animated:YES];
                }
            }
        }
    }
    
}


- (void) performPublishAction:(void (^)(void)) action {
    // we defer request for permission to post to the moment of post, then we check for the permission
    if ([FBSession.activeSession.permissions indexOfObject:@"publish_actions"] == NSNotFound) {
        // if we don't already have the permission, then we request it now
        [FBSession.activeSession reauthorizeWithPublishPermissions:[NSArray arrayWithObject:@"publish_actions"]
                                                   defaultAudience:FBSessionDefaultAudienceFriends
                                                 completionHandler:^(FBSession *session, NSError *error) {
                                                     if (!error) {
                                                         [TKLoadingView showTkloadingAddedTo:self.view title:NSLocalizedString(@"sendingNotice", nil) activityAnimated:YES];
                                                         
                                                         action();
                                                     }
                                                     //For this example, ignore errors (such as if user cancels).
                                                 }];
    } else {
        [TKLoadingView showTkloadingAddedTo:self.view title:NSLocalizedString(@"sendingNotice", nil) activityAnimated:YES];
        
        action();
    }
    
}
- (void)showAlert:(NSString *)message
           result:(id)result
            error:(NSError *)error {
    
    NSString *alertMsg;
    NSString *alertTitle;
    if (error) {
        alertMsg = error.localizedDescription;
        alertTitle = @"Error";
    } else {
        NSDictionary *resultDict = (NSDictionary *)result;
        alertMsg = [NSString stringWithFormat:@"Successfully posted '%@'.\nPost ID: %@",
                    message, [resultDict valueForKey:@"id"]];
        alertTitle = @"Success";
    }
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:alertTitle
                                                        message:alertMsg
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
    [alertView show];
}
#pragma mark - 分享结果

- (void)engine:(WBEngine *)engine requestDidFailWithError:(NSError *)error{
    NSLog(@"%@",error);
    
    TKLoadingView *indictor = nil;
	for(indictor in self.view.subviews)
		if([indictor isKindOfClass:[TKLoadingView class]])
		{
			[indictor setActivityAnimating:NO withShowMsg:NSLocalizedString(@"errcode_fail", nil)];
			[indictor dismissAfterDelay:1.0 animated:YES];
		}
}
- (void)engine:(WBEngine *)engine requestDidSucceedWithResult:(id)result{
    NSLog(@"asdfasdf");
    TKLoadingView *indictor = nil;
	for(indictor in self.view.subviews)
		if([indictor isKindOfClass:[TKLoadingView class]])
		{
			[indictor setActivityAnimating:NO withShowMsg:NSLocalizedString(@"shareSuccess", nil)];
			[indictor dismissAfterDelay:1.0 animated:YES];
		}
}

- (void) connectionDidFinishLoading:(NSURLConnection *)connection {
	
    
    TKLoadingView *indictor = nil;
	for(indictor in self.view.subviews)
		if([indictor isKindOfClass:[TKLoadingView class]])
		{
			[indictor setActivityAnimating:NO withShowMsg:NSLocalizedString(@"shareSuccess", nil)];
			[indictor dismissAfterDelay:1.0 animated:YES];
		}
    
}
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
	
    TKLoadingView *indictor = nil;
	for(indictor in self.view.subviews)
		if([indictor isKindOfClass:[TKLoadingView class]])
		{
			[indictor setActivityAnimating:NO withShowMsg:NSLocalizedString(@"errcode_fail", nil)];
			[indictor dismissAfterDelay:1.0 animated:YES];
		}
}


- (void)storeAccessToken:(NSString *)accessToken {
    [[NSUserDefaults standardUserDefaults]setObject:accessToken forKey:@"SavedAccessHTTPBody"];
}

- (NSString *)loadAccessToken {
    return [[NSUserDefaults standardUserDefaults]objectForKey:@"SavedAccessHTTPBody"];
}

#pragma mark - TextView Delegate

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    NSLog(@"%@",text);
    if([text isEqualToString:@"\n"]){
        return NO;
    }
    return YES;
    
}

#pragma mark - ScrollView Delegate

//-(void)scrollToBottom_tableView
//{
//    NSArray *sections = [[self.broadTableView fetchedResultsController] sections];
//    if([sections count]<=0) return;
//    id <NSFetchedResultsSectionInfo> sectionInfo = [sections objectAtIndex:0];
//    //NSLog(@"numher:%d",sectionInfo.numberOfObjects);
//    if (sectionInfo.numberOfObjects<=0) {
//        return;
//    }
//    NSIndexPath * ndxPath= [NSIndexPath indexPathForRow:sectionInfo.numberOfObjects-1 inSection:0];
//    [mTableView scrollToRowAtIndexPath:indxPath atScrollPosition:UITableViewScrollPositionBottom  animated:NO];
//    
//}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    if([self.inputTextView isFirstResponder]){
        
        [self keyboardReset];

    }
}

#pragma mark - TalbeView DataSource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return replyList.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 55;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellIdentifier = @"BroadcastCell";
    BanBu_DetailCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(cell == nil){
        cell = [[[BanBu_DetailCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier]autorelease];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }

    NSDictionary *replyDic = [NSDictionary dictionaryWithDictionary:[replyList objectAtIndex:indexPath.row]];
    NSLog(@"%@",replyDic);
    NSDictionary *conDic = [AppComManager getAMsgFrom64String:[replyDic valueForKey:@"mcontent"]];

    [cell setAvatar:[replyDic valueForKey:@"uface"]];
    [cell.iconButton setTitle:[NSString stringWithFormat:@"%d",indexPath.row] forState:UIControlStateNormal];

    cell.nameLabel.text = [replyDic objectForKey:@"pname"];
    cell.nameLabel.frame = CGRectMake(55, 10, 180, cell.nameLabel.frame.size.height);
    cell.lastTimeLabel.text = [replyDic valueForKey:@"mtime"];
    cell.lastTimeLabel.frame = CGRectMake(235, 10, 75, 17);
    
    cell.sayTextLabel.text = [conDic objectForKey:@"saytext"];
    cell.playButton.frame = CGRectZero;
    cell.timeLabel.frame = CGRectZero;
    [cell.playButton setTitle:@"" forState:UIControlStateNormal];

    
    
    for(NSDictionary *aDic in [conDic valueForKey:@"attach"]){
        if([[aDic valueForKey:@"type"] isEqualToString:@"sound"]){
        
            if(![[aDic valueForKey:@"content"]isEqualToString:@""]){
                cell.playButton.hidden = NO;
                CGFloat nameWidth = [cell.nameLabel.text sizeWithFont:cell.nameLabel.font constrainedToSize:CGSizeMake(100, 17) lineBreakMode:UILineBreakModeTailTruncation].width;
                //        NSLog(@"%f",nameWidth);
                cell.nameLabel.frame = CGRectMake(55, 19, nameWidth, cell.nameLabel.frame.size.height);
                cell.lastTimeLabel.frame = CGRectMake(235, 19, 75, 17);
                
                [cell.playButton setTitle:[NSString stringWithFormat:@"1,%@",[[[conDic valueForKey:@"attach"] objectAtIndex:0] valueForKey:@"content"]] forState:UIControlStateNormal];
                [cell.playButton setImage:[UIImage imageNamed:@"广播详情-复选框-播放.png"] forState:UIControlStateNormal];
                
                cell.playButton.frame = CGRectMake(cell.nameLabel.frame.origin.x+nameWidth+10, 15, 60, 25);
                if([aDic valueForKey:@"length"]){

                    cell.timeLabel.text = [NSString stringWithFormat:@"%@\"",[aDic valueForKey:@"length"]];
                }
                
                cell.timeLabel.frame = CGRectMake(cell.playButton.frame.origin.x+60-10-25, cell.playButton.frame.origin.y+2, 25, 20);
            }
//            cell.sayTextLabel.frame = CGRectZero;
            
        }
    }
   
    
    
    return cell;
}
 
#pragma mark - TableView Delegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if([self.inputTextView isFirstResponder]){
        [self.inputTextView resignFirstResponder];
        [self keyboardReset];
    }
}



// 语音的播放及动画
-(void)animation:(UIButton *)animationBtn
{
    
    if(animationBackgroundView){
        [animationBackgroundView removeFromSuperview];
    }
    
    animationBackgroundView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 60, 25)];
    animationBackgroundView.userInteractionEnabled = YES;
    [animationBackgroundView setImage:[UIImage imageNamed:@"广播详情-复选框-播放_空.png"]];
    
    
    NSArray *animationImages = [NSArray arrayWithObjects:@"feed_comment_player_pause_anim1.png",@"feed_comment_player_pause_anim2.png",@"feed_comment_player_pause_anim3.png", nil];
    NSMutableArray *images = [NSMutableArray arrayWithCapacity:3];
    for(NSString *path in animationImages)
    {
        [images addObject:[UIImage imageNamed:path]];
    }
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    imageView.userInteractionEnabled = YES;
    imageView.animationImages = images;
    imageView.animationDuration = 1.0;
    imageView.animationImages = images;
    imageView.animationDuration = 1.0;
    imageView.frame = CGRectMake(13, 6.5, 10, 12);
    
    
    imageView.userInteractionEnabled = YES;
    
    imageView.backgroundColor = [UIColor clearColor];
    [animationBackgroundView addSubview:imageView];
    [imageView startAnimating];
    [imageView release];
    
    [animationBtn addSubview:animationBackgroundView];
    
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(stopPlay:)];
    [animationBackgroundView addGestureRecognizer:tap];
    [tap release];
    
    
}

-(void)stopPlay:(UITapGestureRecognizer *)tap{
    [_player stop];
    [tap.view removeFromSuperview];
    
    
}

-(void)playVoiceButton:(NSNotification *)notifi{
    
    UIButton *sender = (UIButton *)[notifi object];
    NSLog(@"%@",sender.titleLabel.text);

    _voiceButton = sender;
    NSArray *voiceArr = [_voiceButton.titleLabel.text componentsSeparatedByString:@","];
    if(![FileManager fileExistsAtPath:[AppComManager pathForMedia:[voiceArr lastObject]]]){
        
        [AppComManager getBanBuMedia:[voiceArr lastObject] delegate:self];
        [TKLoadingView showTkloadingAddedTo:self.navigationController.view title:NSLocalizedString(@"loadingNotice", nil) activityAnimated:YES];
    }else{
    
        if([[voiceArr objectAtIndex:0]boolValue]){

            
            if(_player){
                [self.playingView stopAnimating];

                [_player release],_player = nil;
            }
            NSData *aData = [NSData dataWithContentsOfFile:[AppComManager pathForMedia:[voiceArr lastObject]]];
            NSLog(@"%@",[AppComManager pathForMedia:[voiceArr lastObject]]);
            _player = [[AVAudioPlayer alloc]initWithData:aData error:nil];
            _player.delegate = self;
            _player.volume = 1.0;
            [_player prepareToPlay];
            
            [_player play];
            [_playHUD startAnimating];
            //        sender.hidden = YES;
            if([_player isPlaying]){
                [self animation:sender];
            }
        }else{
            
            if([self.playingView isAnimating]){
                
                
                [self.playingView stopAnimating];
                if(_player){
                    
                    [_player release],_player = nil;
                }
                return;
            }
            
            NSData *aData = [NSData dataWithContentsOfFile:[AppComManager pathForMedia:[voiceArr lastObject]]];
            
            _player = [[AVAudioPlayer alloc]initWithData:aData error:nil];
            _player.delegate = self;
            _player.volume = 1.0;
            [_player prepareToPlay];
            
            [_player play];
            [_playHUD startAnimating];
            //        sender.hidden = YES;
            if([_player isPlaying]){
                //            [self animation:sender];
                [self.playingView startAnimating];
            }
        }
    
    }
    
}


//上传

#pragma mark - BanBuUploadRequsetDelegate

- (void)banbuUploadRequest:(NSDictionary *)resDic didFinishedWithError:(NSError *)error{
    NSLog(@"%@",resDic);
    
    self.navigationController.view.userInteractionEnabled = YES;
    [TKLoadingView dismissTkFromView:self.view animated:NO afterShow:0.0];
    if(error){
        [TKLoadingView showTkloadingAddedTo:self.view title:NSLocalizedString(@"uploadFailNotice", nil) activityAnimated:NO duration:2.0];
    }
    if([[resDic valueForKey:@"ok"] boolValue]){
        if([[resDic valueForKey:@"requestname"] isEqualToString:@"huifu"]){
            [FileManager removeItemAtPath:[AppComManager pathForMedia:@"huifu.amr"] error:nil];

            NSMutableDictionary *abrd = [NSMutableDictionary dictionaryWithCapacity:2];
            [abrd setValue:@"" forKey:@"saytext"];
            [abrd setValue:[NSArray arrayWithObject:[NSDictionary dictionaryWithObjectsAndKeys:@"sound",@"type",[resDic valueForKey:@"fileurl"],@"content",_soundTime,@"length", nil]] forKey:@"attach"];
            NSMutableDictionary *pars = [NSMutableDictionary dictionaryWithCapacity:1];
            [pars setValue:[_broadcast valueForKey:@"actid"] forKey:@"replyid"];
            [pars setValue:abrd forKey:@"says"];
            NSLog(@"%@",pars);
            [AppComManager getBanBuData:BanBu_Reply_Broadcast par:pars delegate:self];
            self.navigationController.view.userInteractionEnabled = NO;
            [TKLoadingView showTkloadingAddedTo:self.navigationController.view title:NSLocalizedString(@"sendingNotice", nil) activityAnimated:YES];
        }
    }
}


//下载语音

#pragma mark - BanBuDownloadRequest

- (void)banbuDownloadRequest:(NSDictionary *)resDic didFinishedWithError:(NSError *)error{
    //    NSLog(@"%@",resDic);
    
    NSArray *voiceArr = [_voiceButton.titleLabel.text componentsSeparatedByString:@","];
    
    
    [TKLoadingView dismissTkFromView:self.navigationController.view animated:NO afterShow:0.0];
    if([[resDic valueForKey:@"ok"]boolValue]){
        
        if([[voiceArr objectAtIndex:0]boolValue]){
            
            
            if(_player){
                [self.playingView stopAnimating];

                [_player release],_player = nil;
            }
            NSData *aData = [NSData dataWithContentsOfFile:[AppComManager pathForMedia:[voiceArr lastObject]]];
            
            _player = [[AVAudioPlayer alloc]initWithData:aData error:nil];
            _player.delegate = self;
            _player.volume = 1.0;
            [_player prepareToPlay];
            
            [_player play];
            [_playHUD startAnimating];
            //        sender.hidden = YES;
            if([_player isPlaying]){
                [self animation:_voiceButton];
            }
        }
        else{
            
            if([self.playingView isAnimating]){
                
                
                [self.playingView stopAnimating];
                if(_player){
                    
                    [_player release],_player = nil;
                }
                return;
            }
            
            NSData *aData = [NSData dataWithContentsOfFile:[AppComManager pathForMedia:[voiceArr lastObject]]];
            
            _player = [[AVAudioPlayer alloc]initWithData:aData error:nil];
            _player.delegate = self;
            _player.volume = 1.0;
            [_player prepareToPlay];
            
            [_player play];
            [_playHUD startAnimating];
            //        sender.hidden = YES;
            if([_player isPlaying]){
                //            [self animation:sender];
                [self.playingView startAnimating];
            }
        }
    }else{
//        [TKLoadingView showTkloadingAddedTo:self.view title:@"下载失败" activityAnimated:NO duration:1.0];
    }
}

//播放完毕

-(void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag{
    
    [_player stop];
    if(animationBackgroundView){
        [animationBackgroundView removeFromSuperview];
    }
    if([self.playingView isAnimating]){
        [self.playingView stopAnimating];
    }
//    [[_voiceButton.subviews lastObject]removeFromSuperview];
}


#pragma mark - BanBu_Request

-(void)banbuRequestDidFinished:(NSDictionary *)resDic error:(NSError *)error{
    NSLog(@"%@",resDic);

    self.navigationController.view.userInteractionEnabled = YES;
    [TKLoadingView dismissTkFromView:self.navigationController.view animated:YES afterShow:0.0];
    if(error){
        if([error.domain isEqualToString:BanBuDataformatError]){
            [TKLoadingView showTkloadingAddedTo:self.view title:NSLocalizedString(@"data_error", nil) activityAnimated:NO duration:2.0];
        }else{
            [TKLoadingView showTkloadingAddedTo:self.view title:NSLocalizedString(@"network_error", nil) activityAnimated:NO duration:2.0];
        }
        return;
        
    }
    
    if([AppComManager respondsDic:resDic isFunctionData:BanBu_Vote_Broadcast]){
        if([[resDic valueForKey:@"ok"]boolValue]){
            
            UILabel *aLabel = (UILabel *)[self.view viewWithTag:labelSelect];
            if(labelSelect == 20){
                aLabel.text = [NSString stringWithFormat:@"%d+",[[_broadcast valueForKey:@"vote"]intValue]+1];
                [TKLoadingView showTkloadingAddedTo:self.navigationController.view title:NSLocalizedString(@"zan_success", nil) activityAnimated:NO duration:2.0];


            }else{
                
                aLabel.text = [NSString stringWithFormat:@"%d+",[[_broadcast valueForKey:@"share"]intValue]+1];

            }
        }else{
            [TKLoadingView showTkloadingAddedTo:self.navigationController.view title:NSLocalizedString(@"zan_success", nil) activityAnimated:NO duration:2.0];
        }
    }
    else if([AppComManager respondsDic:resDic isFunctionData:BanBu_Report_Broadcat]){
        NSLog(@"%@",resDic);
        if([[resDic valueForKey:@"ok"]boolValue]){
            
            
            [MyAppDataManager.nearDos removeObjectAtIndex:self.selectSection];
            //将更新的广播列表更新到上个页面
            for(BanBu_BroadcastTVC  * broad in self.navigationController.viewControllers)
            {
                if([broad isKindOfClass:[BanBu_BroadcastTVC class]])
                {
                    [broad.tableView reloadData];
                    break;
                }
            }

            
            [TKLoadingView showTkloadingAddedTo:self.navigationController.view title:NSLocalizedString(@"reportNotice", nil) activityAnimated:NO duration:1.0];

        }
    }
    else if([AppComManager respondsDic:resDic isFunctionData:BanBu_Reply_Broadcast]){
        if([[resDic valueForKey:@"ok"]boolValue]){

            
//            [TKLoadingView showTkloadingAddedTo:self.navigationController.view title:NSLocalizedString(@"sendingNotice", nil) activityAnimated:YES];
            
            NSMutableDictionary *pars = [NSMutableDictionary dictionaryWithCapacity:1];
            [pars setValue:[_broadcast valueForKey:@"actid"] forKey:@"actid"];
            [AppComManager getBanBuData:BanBu_Get_Broadcast par:pars delegate:self];
            self.navigationController.view.userInteractionEnabled = NO;
            _isReplyed = YES;
        }
    }
    else if([AppComManager respondsDic:resDic isFunctionData:BanBu_Get_Broadcast]){
        
        if([[resDic valueForKey:@"ok"]boolValue]){
            [replyList release];
            
//            NSArray *tempArr = [NSArray arrayWithArray:[resDic valueForKey:@"replylist"]];
//            NSArray *sortedArray = [tempArr sortedArrayUsingComparator: ^(id obj1, id obj2) {
//                //                NSLog(@"%@",[obj1 objectForKey:@"actid"]);
//                return [[obj1 objectForKey:@"actid"] compare:[obj2 objectForKey:@"actid"] options:NSCaseInsensitiveSearch];
//                
//            }];
            
            replyList = [[NSArray alloc]initWithArray:[resDic valueForKey:@"replylist"]];
            [self.broadTableView reloadData];
            
            UILabel *aLabel = (UILabel *)[self.view viewWithTag:10];
            if(replyList.count>0){
                aLabel.text = [NSString stringWithFormat:@"%d+",replyList.count];

            }
 //            [self.bgtableview scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:最后一行的indexPath.row的值] atScrollPosition:UITableViewScrollPositionBottom animated:NO]
            if(_isReplyed && replyList.count>0){
                [self.broadTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[replyList count]-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
                _isReplyed = NO;
            }
            
            NSMutableArray *replaceArr = [NSMutableArray arrayWithCapacity:0];
            for(int i=replyList.count-1;i>=0;i--){
                [replaceArr addObject:[replyList objectAtIndex:i]];
                if(replaceArr.count>=3){
                    break;
                }
            }
//                NSLog(@"%@",replaceArr);
            NSMutableDictionary *replaceDic = [MyAppDataManager.nearDos objectAtIndex:self.selectSection];
            [replaceDic setValue:replaceArr forKey:@"replylist"];
            [replaceDic setValue:[NSString stringWithFormat:@"%d",replyList.count] forKey:@"comments"];
            [MyAppDataManager.nearDos replaceObjectAtIndex:self.selectSection withObject:replaceDic];
            
            //将新的评论更新到上个页面
            for(BanBu_BroadcastTVC  * broad in self.navigationController.viewControllers)
            {
                if([broad isKindOfClass:[BanBu_BroadcastTVC class]])
                {
//                    [broad.tableView reloadSections:[NSIndexSet indexSetWithIndex:self.selectSection] withRowAnimation:UITableViewRowAnimationNone];
                    [broad.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:self.selectSection inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
                    break;
                }
            }
      
        }
        
    }
   
}
















@end
