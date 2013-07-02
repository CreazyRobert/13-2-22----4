//
//  BanBu_PictureAndVoice.m
//  BanBu
//
//  Created by Jc Zhang on 13-3-11.
//
//

#import "BanBu_PictureAndVoice.h"
#import "AppCommunicationManager.h"
#import "AppDataManager.h"
#import "TKLoadingView.h"
#import "BanBu_TextAndTags.h"
@interface BanBu_PictureAndVoice ()

@end

@implementation BanBu_PictureAndVoice

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.title = NSLocalizedString(@"pictureAndVoiceTitle", nil);
    self.view.backgroundColor = [UIColor colorWithRed:255.0/255 green:250.0/255 blue:240.0/255 alpha:1.0];
    
    UIButton *nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
    nextButton.frame=CGRectMake(0, 0, 60, 30);
    [nextButton addTarget:self action:@selector(nextStep) forControlEvents:UIControlEventTouchUpInside];
    [nextButton setBackgroundImage:[[UIImage imageNamed:@"app_nav_btn_bg1.png"] stretchableImageWithLeftCapWidth:15.0 topCapHeight:15.0] forState:UIControlStateNormal];
    [nextButton setBackgroundImage:[[UIImage imageNamed:@"app_nav_btn_bg2.png"] stretchableImageWithLeftCapWidth:15.0 topCapHeight:15.0] forState:UIControlStateHighlighted];
    [nextButton setTitleEdgeInsets:UIEdgeInsetsMake(3, 2, 2, 2)];
    [nextButton setTitle:NSLocalizedString(@"nextButton", nil) forState:UIControlStateNormal];
    nextButton.titleLabel.font = [UIFont systemFontOfSize:14];
    UIBarButtonItem *next = [[[UIBarButtonItem alloc] initWithCustomView:nextButton] autorelease];
    self.navigationItem.rightBarButtonItem = next;
    
    UIView *picView = [[UIView alloc]initWithFrame:CGRectMake( 10, 10, 300, 300)];
    self.contentView = picView;
    self.contentView.backgroundColor = [UIColor grayColor];
    [picView release];
    [self.view addSubview:self.contentView];
    
    disPlayImageView = [[UIImageView alloc]initWithFrame:self.contentView.frame];
    disPlayImageView.userInteractionEnabled = NO;
    disPlayImageView.image = [UIImage imageNamed:@"photo_default.png"];
    
    //外部阴影
    disPlayImageView.layer.masksToBounds = NO;
    disPlayImageView.layer.shadowOffset = CGSizeMake(0, 2);
    disPlayImageView.layer.shadowOpacity = 0.6;
    disPlayImageView.layer.shadowPath = [UIBezierPath bezierPathWithRect:disPlayImageView.bounds].CGPath;
    
    [self.view addSubview:disPlayImageView];
    [disPlayImageView release];
    
//    ASMediaThumbnailsViewController *aThum = [[ASMediaThumbnailsViewController alloc]initWithNibName:nil bundle:nil];
//    aThum.view.backgroundColor = [UIColor redColor];
//    aThum.imageViews = [NSArray arrayWithObject:disPlayImageView];
//    [self.navigationController addChildViewController:aThum];
//    [self.contentView addSubview:aThum.view];
//    aThum.view.frame = self.contentView.bounds;
//    self.view.clipsToBounds = NO;
//    [aThum release];
  
    
    //功能按钮
    for(int i=1; i<3; i++){
        UIButton * aButton = [UIButton buttonWithType:UIButtonTypeCustom];
        aButton.tag = i;
        
        aButton.frame = CGRectMake(i*32+64*(i-1), 330, 64, 64);
        if(i == 2){
            aButton.frame = CGRectMake((i+1)*32+64*2, 330, 64, 64);

        }
        [aButton setImage:[UIImage imageNamed:[NSString stringWithFormat:@"fun%d.png",i]] forState:UIControlStateNormal];
        [aButton setImage:[UIImage imageNamed:[NSString stringWithFormat:@"fun%d_select.png",i]] forState:UIControlStateHighlighted];
        [aButton addTarget:self action:@selector(imagePickerAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:aButton];
         
    }
   
    //录音按钮
    UIButton *voiceButton = [UIButton buttonWithType:UIButtonTypeCustom];
    voiceButton.tag = 3;
    voiceButton.alpha = 0;
    voiceButton.frame = CGRectMake(32*2+64*1, 330, 64, 64);
    [voiceButton setImage:[UIImage imageNamed:@"fun3.png"] forState:UIControlStateNormal];
    [voiceButton setImage:[UIImage imageNamed:@"fun3_select.png"] forState:UIControlStateSelected];
    [voiceButton setImage:[UIImage imageNamed:@"fun3_select.png"] forState:UIControlStateHighlighted];
    [voiceButton addTarget:self action:@selector(voiceTap) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:voiceButton];
    
    UILongPressGestureRecognizer *aLongPress = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(voiceAction:)];
    [voiceButton addGestureRecognizer:aLongPress];
    [aLongPress release];
    
    //播放按钮
    
    _playButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _playButton.frame = CGRectMake( 160-105/2, 297, 105, 26);
    [_playButton setImage:[UIImage imageNamed:@"播放语音_未按下.png"] forState:UIControlStateNormal];
    [_playButton addTarget:self action:@selector(playAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_playButton];
    _playButton.hidden = YES;
    
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(playAction)];
//    [_playButton addGestureRecognizer:tap];
//    [tap release];
 
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
    aLabel.tag = 10;
    aLabel.backgroundColor = [UIColor clearColor];
    aLabel.textColor = [UIColor whiteColor];
    aLabel.font = [UIFont systemFontOfSize:14];
    aLabel.textAlignment= UITextAlignmentRight;
    aLabel.text = _soundDuration;
    [_playButton addSubview:aLabel];
    [aLabel release];
        
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)nextStep{

    if(disPlayImageView.userInteractionEnabled){
        BanBu_TextAndTags *aText = [[BanBu_TextAndTags alloc]initWithSendImage:UIImageJPEGRepresentation(disPlayImageView.image, 0.7) andSoundData:_sendSoundData andSoundDuration:_soundDuration];
        [self.navigationController pushViewController:aText animated:YES];
        [aText release];
    }else{
        
        [TKLoadingView showTkloadingAddedTo:self.view title:NSLocalizedString(@"addAPhoto", nil) activityAnimated:NO duration:1.0];
    }

}

//录制语音

-(void)voiceTap{
    
    if(disPlayImageView.userInteractionEnabled){
        [TKLoadingView showTkloadingAddedTo:self.view title:NSLocalizedString(@"timeshortNoticte", nil) activityAnimated:NO duration:1.0];

    }else{
        [TKLoadingView showTkloadingAddedTo:self.view title:NSLocalizedString(@"addAPhoto", nil) activityAnimated:NO duration:1.0];

    }

}

-(void)voiceAction:(UILongPressGestureRecognizer *)sender{
    
    if(disPlayImageView.userInteractionEnabled){
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
        NSString *fileName = @"yuyin.amr";
        _recordView.audioPath = [AppComManager pathForMedia:fileName];
        NSLog(@"%@", [AppComManager pathForMedia:fileName]);
        _recordView.delegate = self;
        [self.navigationController.view addSubview:_recordView];
        [_recordView release];
    }
    else{
        [TKLoadingView showTkloadingAddedTo:self.view title:NSLocalizedString(@"addAPhoto", nil) activityAnimated:NO duration:1.0];
    }
}

#pragma mark - RecordView Delegate

-(void)recordView:(RecordView *)recordView recordDidCompleted:(NSData *)audioData recordTime:(int)duration{
    
    if([audioData length]<100){
        
        [TKLoadingView showTkloadingAddedTo:self.view title:NSLocalizedString(@"timeshortNoticte", nil) activityAnimated:NO duration:1.0];
        return;
    }
    _sendSoundData = [[NSData alloc]initWithData:audioData];
    _playButton.hidden = NO;
    NSLog(@"%d秒",duration);
    _soundDuration = [[NSString alloc]initWithFormat:@"%d",duration];;
    ((UILabel *)[self.view viewWithTag:10]).text = [NSString stringWithFormat:@"%@\"",_soundDuration];
}

//播放语音

-(void)playAction{
    
    if(_player){
 
        [self.playingView stopAnimating];
        self.player = nil;
        return;
    }
    NSData *aData = [NSData dataWithContentsOfFile:[AppComManager pathForMedia:@"yuyin.amr"]];
    _player = [[AVAudioPlayer alloc]initWithData:aData error:nil];
    _player.delegate = self;
    _player.volume = 1.0;
    [_player prepareToPlay];
    [_player play];

    if([_player isPlaying]){
        [self.playingView startAnimating];
    }
 
}

-(void)stopPlaying{
    
    [_player stop];
    self.player = nil;
    [self.playingView stopAnimating];

}

#pragma mark - AVAudioDelegate
 

-(void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag{
    [self stopPlaying];

}

//照相、相册
- (void) setup: (UIView *) aView
{
    //获取相机界面的view
    NSLog(@"%d",aView.subviews.count);
    
    //相机原有控件全部透明
    NSArray *svarray = [aView subviews];
    for (int i = 0; i < svarray.count; i++)  [[svarray objectAtIndex:i] setAlpha:0.0f];
    
    //加入自己的UI界面
    
    //    self.navbar = [[[UINavigationBar alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 44.0f)] autorelease];
    //    UINavigationItem *navItem = [[[UINavigationItem alloc] init] autorelease];
    //    navItem.rightBarButtonItem = BARBUTTON(@"Shoot", @selector(shoot:));
    //    navItem.leftBarButtonItem = BARBUTTON(@"Cancel", @selector(dismiss:));
    //
    //    [(UINavigationBar *)self.navbar pushNavigationItem:navItem animated:NO];
    //    [plcameraview addSubview:self.navbar];
}

-(void)imagePickerAction:(UIButton *)sender{
    UIImagePickerController *picker = [[UIImagePickerController alloc]init];
    picker.delegate = self;
    if(sender.tag == 1){
        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
            picker.sourceType = UIImagePickerControllerSourceTypeCamera;

        }
        
        //        UIView *aOverView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 480)];
        //        aOverView.backgroundColor = [UIColor greenColor];
        //        picker.cameraOverlayView = aOverView;
        //        [aOverView release];
        
    }else{
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    [picker setAllowsEditing:YES];
    [self presentModalViewController:picker animated:YES];
    [picker release];
}

#pragma mark - ImagePickerControllerDelegate

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    
//    NSLog(@"%@",info);
    
    disPlayImageView.image = [info valueForKey:UIImagePickerControllerEditedImage];
    disPlayImageView.userInteractionEnabled = YES;
    [picker dismissModalViewControllerAnimated:YES];
    
    [UIView animateWithDuration:1 animations:^{
        UIButton *aButton = (UIButton *)[self.view viewWithTag:3];
        aButton.alpha = 1;
        UIButton *aButton1 = (UIButton *)[self.view viewWithTag:1];
        UIButton *aButton2 = (UIButton *)[self.view viewWithTag:2];
        aButton1.alpha = 0.6;
        aButton2.alpha = 0.6;
        

    }];
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    
    [picker dismissModalViewControllerAnimated:YES];
    
}

-(void)dealloc{
 
    [_soundDuration release];
    [_sendSoundData release];
    self.playingView = nil;
    [super dealloc];
    
}

@end
