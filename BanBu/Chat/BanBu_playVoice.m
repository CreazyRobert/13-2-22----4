//
//  BanBu_playVoice.m
//  BanBu
//
//  Created by Jc Zhang on 12-12-13.
//
//

#import "BanBu_playVoice.h"
#import "AppCommunicationManager.h"
#import "AppDataManager.h"
#import "TKLoadingView.h"
#import "BanBu_LampText.h"
#import "WXOpen.h"
@interface BanBu_playVoice ()

@end

@implementation BanBu_playVoice

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)dealloc{
    [_player release];
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor blackColor];
    NSInteger lampInteger = [self.naviTitle rangeOfString:@"_"].location+1;
    NSString *lampStr = [self.naviTitle substringWithRange:NSMakeRange(lampInteger, self.naviTitle.length-lampInteger)];
    
    [BanBu_LampText showNavTitle:self title:lampStr width:180];

    UIBarButtonItem *backButton = [[[UIBarButtonItem alloc]initWithTitle:NSLocalizedString(@"returnButton", nil) style:UIBarButtonItemStylePlain target:self action:@selector(backAction)]autorelease];
    self.navigationItem.leftBarButtonItem = backButton;
    
    UIBarButtonItem *doneButton = [[[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"sendReply", nil) style:UIBarButtonItemStylePlain target:self action:@selector(sendAction)] autorelease];
    self.navigationItem.rightBarButtonItem = doneButton;
    playButton = [UIButton buttonWithType:UIButtonTypeCustom];
    playButton.frame = CGRectMake(0, 0, 128, 128);
    playButton.center = self.view.center;
    [playButton setImage:[UIImage imageNamed:@"palyBtn.png"] forState:UIControlStateNormal];
    [playButton addTarget:self action:@selector(playAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:playButton];
    
//    //动画
//    gifImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 128, 128)];
//    gifImageView.image = [UIImage imageNamed:@"11.png"];
//    gifImageView.center = self.view.center;
////    NSArray *gifArray = [NSArray arrayWithObjects:[UIImage imageNamed:@"2.png"],[UIImage imageNamed:@"3.png"],[UIImage imageNamed:@"4.png"],[UIImage imageNamed:@"5.png"],[UIImage imageNamed:@"6.png"],[UIImage imageNamed:@"7.png"],nil];
//    NSArray *gifArray = [NSArray arrayWithObjects:[UIImage imageNamed:@"11.png"],[UIImage imageNamed:@"22.png"],[UIImage imageNamed:@"33.png"],[UIImage imageNamed:@"44.png"],nil];
//
//    gifImageView.animationImages = gifArray; //动画图片数组
//    gifImageView.animationDuration = 1; //执行一次完整动画所需的时长
//    gifImageView.animationRepeatCount = 0;  //动画重复次数
//    [self.view addSubview:gifImageView];
//    [gifImageView release];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)backAction{
    [_player stop];

    [self dismissModalViewControllerAnimated:YES];
}

-(void)sendAction{
    [_player stop];
//    [self dismissModalViewControllerAnimated:NO];
//    UIActionSheet *conSheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:NSLocalizedString(@"cancelNotice", nil) destructiveButtonTitle:nil otherButtonTitles:NSLocalizedString(@"ice_actionSheetButtionTitle", nil),NSLocalizedString(@"ice_actionSheetButtionTitle1", nil),NSLocalizedString(@"ice_actionSheetButtionTitle2", nil),nil];
    UIActionSheet *conSheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:NSLocalizedString(@"cancelNotice", nil) destructiveButtonTitle:nil otherButtonTitles:NSLocalizedString(@"ice_actionSheetButtionTitle", nil),nil];

    [conSheet showInView:self.view];
    [conSheet release];
    
}

-(void)playAction:(UIButton *)sender{
    
    if(![FileManager fileExistsAtPath:[AppComManager pathForMedia:self.voiceURL]]){
        [AppComManager getBanBuMedia:self.voiceURL delegate:self];
    }
    else{
        if(!_player){
            NSData *aData = [NSData dataWithContentsOfFile:[AppComManager pathForMedia:self.voiceURL]];
            _player = [[AVAudioPlayer alloc]initWithData:aData error:nil];
            _player.delegate = self;
            _player.volume = 1.0;
            [_player prepareToPlay];
//            [_player play];
        }
        if(!playButton.selected){
            [_player play];
        }else{
            [_player stop];
        }

    }
    [self performSelector:@selector(changeStatu)];

}

-(void)changeStatu{
    
    playButton.selected = !playButton.selected;
    [playButton setImage:playButton.selected?[UIImage imageNamed:@"paseBtn.png"]:[UIImage imageNamed:@"palyBtn.png"] forState:UIControlStateNormal];

    if(playButton.selected){
//        [UIView beginAnimations:nil context:nil];
//        [UIView setAnimationDuration:1];
//        [gifImageView startAnimating];
//        [UIView commitAnimations];


    }else{
//        [gifImageView stopAnimating];

    }
    
}

-(void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag{
    playButton.selected = !playButton.selected;
    [playButton setImage:playButton.selected?[UIImage imageNamed:@"paseBtn.png"]:[UIImage imageNamed:@"palyBtn.png"] forState:UIControlStateNormal];

//    [gifImageView stopAnimating];

}

#pragma mark - UIActionSheetDelegate

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if(buttonIndex !=3){

        if(buttonIndex == 0){
                    
            if(_push)
            {
                NSData *data=[NSData dataWithContentsOfFile:[AppComManager pathForMedia:_voiceURL]];
                
                if(data ){
                    RecordAudio *record=[[RecordAudio alloc]init];
                    
                    
                    MyAppDataManager.time =[record playDuration:data];
                    
                }
                _push.voiceString =self.voiceURL;
                
                [_push popself1];
                
            }
            
        }
//        else if(buttonIndex == 1){
//            MyWXOpen.scene = WXSceneSession;
//            [MyWXOpen sendMusicContentWithTitle:self.naviTitle andThumbImage:[UIImage imageNamed:@"pan_voice.png"] andMusicURL:self.voiceURL];
////            [self dismissModalViewControllerAnimated:NO];
//            
//        }else if(buttonIndex == 2){
//            MyWXOpen.scene = WXSceneTimeline;
//            [MyWXOpen sendMusicContentWithTitle:self.naviTitle andThumbImage:[UIImage imageNamed:@"pan_voice.png"] andMusicURL:self.voiceURL];
////            [self dismissModalViewControllerAnimated:NO];
//            
//        }
        [self dismissModalViewControllerAnimated:NO];

    }
    
}






@end
