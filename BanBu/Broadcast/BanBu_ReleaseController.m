//
//  BanBu_ReleaseController.m
//  BanBu
//
//  Created by mac on 12-8-11.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//
#import "BanBu_ReleaseController.h"
#import "BanBu_GraffitiController.h"
//#import "BanBu_BroadcastController.h"
#import "AppDataManager.h"
#import "AppCommunicationManager.h"
#import "TKLoadingView.h"
#import "BanBu_LocationManager.h"
#import "BanBu_MyProfileViewController.h"
#import "SSCheckBoxView.h"
#import "BanBu_UserAgreement.h"
//#define kWBSDKDemoAppKey @"2129725138"
//#define kWBSDKDemoAppSecret @"17fa3fa07a4c3bcb01d212cb024136ca"

@interface BanBu_ReleaseController ()

@end

@implementation BanBu_ReleaseController
@synthesize btntag=_btntag;
@synthesize wbEngine = _wbEngine;
@synthesize responseData = _responseData;
@synthesize connection = _connection;
@synthesize receiveImage = _receiveImage;

//回收键盘
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{

    [textView resignFirstResponder];
}

-(void)pullKeyBorad{
    [textView resignFirstResponder];
}
//清空textview
-(void)clearTextView{
    textView.text=@"";
}

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
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(listeningAction:) name:@"Mynotification" object:nil];

	// Do any additional setup after loading the view.

    self.title = NSLocalizedString(@"releaseTitle", nil);
    self.view.backgroundColor=[UIColor colorWithRed:255.0/255 green:250.0/255 blue:240.0/255 alpha:1.0];
    
    UIButton *btn_return=[UIButton buttonWithType:UIButtonTypeCustom];
    
    [btn_return addTarget:self action:@selector(popself) forControlEvents:UIControlEventTouchUpInside];
    
    [btn_return setBackgroundImage:[[UIImage imageNamed:@"app_nav_back_bg1.png"] stretchableImageWithLeftCapWidth:15.0 topCapHeight:15.0] forState:UIControlStateNormal];
//    [btn_return setBackgroundImage:[[UIImage imageNamed:@"app_nav_back_bg2.png"] stretchableImageWithLeftCapWidth:15.0 topCapHeight:15.0] forState:UIControlStateHighlighted];
    btn_return.frame=CGRectMake(0, 0, 48, 30);
    [btn_return setTitleEdgeInsets:UIEdgeInsetsMake(3, 9, 2, 2)];
    [btn_return setTitle:NSLocalizedString(@"returnButton", nil) forState:UIControlStateNormal];
    btn_return.titleLabel.font = [UIFont systemFontOfSize:14];
    UIBarButtonItem *bar_itemreturn=[[[UIBarButtonItem alloc] initWithCustomView:btn_return] autorelease];
    self.navigationItem.leftBarButtonItem = bar_itemreturn;
    
//    UIImageView *sayImageView=[[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 225, 20)];
//    sayImageView.image=[UIImage imageNamed:@"msg_sayabout.png"];
//    [self.view addSubview:sayImageView];
//    [sayImageView release];
    UILabel *sayLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, 300, 30)];
    sayLabel.text =NSLocalizedString(@"sayRelease", nil);
    sayLabel.alpha = 0.8;
    sayLabel.font=[UIFont fontWithName:@"CourierNewPS-ItalicMT" size:15];
    sayLabel.backgroundColor = [UIColor clearColor];
    sayLabel.textColor = [UIColor redColor];
    [self.view addSubview:sayLabel];
    [sayLabel release];
    
    UIToolbar *aTool=[[UIToolbar alloc]initWithFrame:CGRectMake(0, 10, 320, 35)];
    aTool.barStyle= UIBarStyleBlackTranslucent;
    UIBarButtonItem *clear=[[UIBarButtonItem alloc]initWithTitle:NSLocalizedString(@"emptyToolItem", nil) style:UIBarButtonItemStyleBordered target:self action:@selector(clearTextView)];
    UIBarButtonItem *kon=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *cancel=[[UIBarButtonItem alloc]initWithTitle:NSLocalizedString(@"finishToolItem", nil) style:UIBarButtonItemStyleDone target:self action:@selector(pullKeyBorad)];
    NSArray *arr=[NSArray arrayWithObjects: clear,kon,cancel, nil];
    aTool.items=arr;
    //编辑的文字
    textView = [[UITextView alloc] initWithFrame:CGRectMake(10, 40, 300, 90)];
    textView.delegate = self;
    textView.backgroundColor = [UIColor whiteColor];
    textView.layer.borderColor = [[UIColor grayColor] CGColor];
    textView.layer.borderWidth = 1.0;
    textView.layer.cornerRadius = 6.0;
    textView.textColor = [UIColor darkTextColor];
    textView.font = [UIFont systemFontOfSize:16];
    textView.text = @"";
    textView.keyboardAppearance=UIKeyboardAppearanceAlert;
    [self.view addSubview:textView];
    textView.inputAccessoryView =aTool;
    [clear release];
    [kon release];
    [cancel release];
    [aTool release];
    //功能按钮
    for(int i=1;i<6;i++){
        if(i == 3 || i ==5){
            
        }else{
            UIView *aView = [[UIView alloc]init];
            aView.frame = CGRectMake(15+(i-1)*63, 140, 33, 50);
            aView.tag = i*10;
            [self.view addSubview:aView];
            [aView release];
            
            UIButton *aButton  = [UIButton buttonWithType:UIButtonTypeCustom];
            aButton.frame =  CGRectMake(0, 3, 33, 28);
            [aButton setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"msg_btn%d.png",i]] forState:UIControlStateNormal];
            aButton.tag = i;
            [aButton addTarget:self action:@selector(funButton:) forControlEvents:UIControlEventTouchUpInside];
            [aView addSubview:aButton];
            
            UILabel*label = [[UILabel alloc] initWithFrame:CGRectMake(-15, 28, 60, 20)];
            [label setBackgroundColor:[UIColor clearColor]];
            //        label.textColor = [UIColor grayColor];
            [label setFont:[UIFont systemFontOfSize:12.0]];//改变字体大小
            [label setTextAlignment:UITextAlignmentCenter];//字体中间对齐
            if (i == 1) {
                [label setText:NSLocalizedString(@"funLabel", nil)];
                aView.frame = CGRectMake(60, 140, 33, 50);

            }
            else if(i == 2) {
                [label setText:NSLocalizedString(@"funLabel1", nil)];
                aView.frame = CGRectMake(150, 140, 33, 50);

            }
            else if(i == 3) {
                [label setText:NSLocalizedString(@"funLabel2", nil)];
            }
            else if(i == 4) {
                [label setText:NSLocalizedString(@"funLabel3", nil)];
                aView.frame = CGRectMake(230, 140, 33, 50);

            }
            else{
                [label setText:NSLocalizedString(@"funLabel4", nil)];
            }
            
            [aView addSubview:label];
            [label release];
            
            //        UIImageView *imageView1 = [[UIImageView alloc] initWithFrame:CGRectMake(10, 38, 24, 19)];
            //        imageView1.image = nil;
            //        imageView1.image = [UIImage imageNamed:@"msg_btn_selected.png"];
            //
            //        imageView1.backgroundColor = [UIColor redColor];
            //        [aView addSubview:imageView1];
            //        [imageView1 release];
            UIImageView *rightImageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 38, 24, 19)];
            //        rightImageView.backgroundColor = [UIColor redColor];
            [aView addSubview:rightImageView];
            [rightImageView release];
        }
        

    }
    
//    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(record:)];
//    [[self.view viewWithTag:3] addGestureRecognizer:longPress];
//    [longPress release];
    SSCheckBoxViewStyle style = 3;
    SSCheckBoxView * cbv = [[SSCheckBoxView alloc] initWithFrame:CGRectMake(20, 192, 30, 30)
                                                           style:style
                                                         checked:NO];
    cbv.tag = 101;
    [cbv setStateChangedTarget:self selector:@selector(checkBoxViewChangedState:)];
    [self.view addSubview:cbv];
    [cbv release];
    
    //    UITextView *aTextView = [[UITextView alloc]initWithFrame:CGRectMake(70, 200, 180, 20)];
    //    aTextView.text = @"我已阅读并同意半步用户协议";
    //    aTextView.dataDetectorTypes = UIDataDetectorTypeLink;
    //    [self.view addSubview:aTextView];
    //    [aTextView release];
    NSString *aStr = NSLocalizedString(@"aStr", nil);
    CGFloat backX = [aStr sizeWithFont:[UIFont systemFontOfSize:15] constrainedToSize:CGSizeMake(180, 20)].width;
    
    UILabel *aLabel = [[UILabel alloc]initWithFrame:CGRectMake(50, 200, backX, 20)];
    aLabel.backgroundColor = [UIColor clearColor];
    aLabel.text = aStr;
    aLabel.font = [UIFont systemFontOfSize:15];
    [self.view addSubview:aLabel];
    [aLabel release];
    
    
    NSString *bStr = NSLocalizedString(@"bStr", nil);
    CGFloat backX1 = [bStr sizeWithFont:[UIFont systemFontOfSize:15] constrainedToSize:CGSizeMake(200, 20)].width;
    
    UIButton *aButton = [UIButton buttonWithType:UIButtonTypeCustom];
    aButton.frame = CGRectMake(150, 221, backX1, 20);
    aButton.backgroundColor = [UIColor clearColor];
    [aButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [aButton setTitle:bStr forState:UIControlStateNormal];
    aButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [aButton addTarget:self action:@selector(goToUser) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:aButton];
    
    UILabel *aNoticeLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 240, 280, 80)];
    aNoticeLabel.backgroundColor = [UIColor clearColor];
    aNoticeLabel.text = NSLocalizedString(@"seqingNotice", nil);
    aNoticeLabel.textColor = [UIColor darkGrayColor];
    aNoticeLabel.font = [UIFont systemFontOfSize:14];
    aNoticeLabel.numberOfLines = 0;
    [self.view addSubview:aNoticeLabel];
    [aNoticeLabel release];
    

    
    //分享
    UILabel *fenLabel=[[UILabel alloc]initWithFrame:CGRectMake(115, 320, 70, 27)];
    fenLabel.text=NSLocalizedString(@"fenLabel", nil);
    fenLabel.backgroundColor = [UIColor clearColor];
    fenLabel.font=[UIFont systemFontOfSize:16];
    [self.view addSubview:fenLabel];
    [fenLabel release];
    for(int j=6;j<8;j++){
        UIButton * button = [UIButton buttonWithType:
							 UIButtonTypeCustom];
		button.frame = CGRectMake(185+(j-6)*32, 320, 27, 27);
        [button setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"msg_fbtn%d.png",j-5]] forState:UIControlStateNormal];
		[button addTarget:self action:@selector(fenButton:) forControlEvents:UIControlEventTouchUpInside];
		button.tag = j;
        [self.view addSubview:button];
    }
    //提交广播
    UIButton *sendBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    sendBtn.frame=CGRectMake(49, 360, 218, 40);
    [sendBtn setBackgroundImage:[[UIImage imageNamed:@"app_btn_blue.png"] stretchableImageWithLeftCapWidth:10.0 topCapHeight:0.0] forState:UIControlStateNormal];
    [sendBtn setTitle:NSLocalizedString(@"sendNow", nil) forState:UIControlStateNormal];
    [sendBtn addTarget:self action:@selector(sendBrd) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:sendBtn];
    attachArr=[[NSMutableArray alloc]init];



}


-(void)goToUser{
    BanBu_UserAgreement *agreement = [[BanBu_UserAgreement alloc]init];
    [self.navigationController pushViewController:agreement animated:YES];
    [agreement release];
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void)dealloc{
    [_zhaoxiangDic release];
    [_tuyaDic release];
    [_xiangceDic release];
    [attachArr release];
    [alertSucess release];
    [_receiveImage release];
    [textView release];
    [_wbEngine release];
//    [veryImprotImageView release];
//    [veryImprotImageView1 release];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"Mynotification" object:nil];
    [super dealloc];

}

//放弃编辑好的内容
-(void)popself{
    if(attachArr.count || ![textView.text isEqualToString:@""]){
        UIAlertView *alert2 = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"noticeNotice", nil) message:NSLocalizedString(@"editAlert", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"cancelNotice", nil) otherButtonTitles:NSLocalizedString(@"confirmNotice", nil),nil];
        alert2.tag = 2;
        [alert2 show];
        [alert2 release];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}



-(void)funButton:(UIButton *)sender{
    _btntag=sender.tag*10;
    if(sender.tag<3){
        UIImagePickerController *picker = [[UIImagePickerController alloc]init];
        picker.delegate = self;
        if(sender.tag == 1){
            picker.sourceType = UIImagePickerControllerSourceTypeCamera;
            
        }else if(sender.tag ==2){
            picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        }
        [picker setAllowsEditing:YES];
        [self presentModalViewController:picker animated:YES];
        [picker release];
        
    }
    if(sender.tag == 3){
//        BroadcastRecordView *recordView = [[BroadcastRecordView alloc] initWithFrame:CGRectMake(0, 20, 320, __MainScreen_Height)];
//        NSString *fileName = @"luyin";
//        recordView.audioPath = [AppComManager pathForMedia:fileName];
//        recordView.delegate = self; 
//    
//        [self.navigationController.view addSubview:recordView];
//        [recordView release];
    }
    if(sender.tag ==4){
        
        BanBu_GraffitiController *aScraw=[[BanBu_GraffitiController alloc]init];
        [self presentModalViewController:aScraw animated:YES];
        [aScraw release];
        
    }
    
    if(sender.tag == 5){
//        if(!haveSendLocation){
//            
//            
//            [self sendLocation];
//            NSLog(@"%d",_btntag);
//            UIImageView *tempImageView=(UIImageView *)[[[self.view viewWithTag:_btntag] subviews]objectAtIndex:2];
//            tempImageView.image = [UIImage imageNamed:@"msg_btn_selected.png"];
//            NSLog(@"%@",tempImageView);
//
//        }else{
////            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"您的位置已载入数据！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
////            [alert show];
////            [alert release];
//            [TKLoadingView showTkloadingAddedTo:self.view title:NSLocalizedString(@"locationNotice", nil) activityAnimated:NO duration:1.0];
//        }
        

    }
  
}

-(void)fenButton:(UIButton *)sender{
    if(sender.tag ==6){
//        _wbEngine = [[WBEngine alloc]initWithAppKey:kWBSDKDemoAppKey appSecret:kWBSDKDemoAppKey];
//        _wbEngine.delegate = self;
//        [_wbEngine setRootViewController:self];
//        [_wbEngine setRedirectURI:@"http://www.halfeet.com"];
//        [_wbEngine setIsUserExclusive:NO];
//        if([UserDefaults valueForKey:@"sinaUser"]){
//            //NSLog(@"sina,bangding");
//            [_wbEngine sendWeiBoWithText:textView.text image:[UIImage imageNamed:@"msg_btn2.png"]];
//
//        }else{
//            [_wbEngine logOut];
//            [_wbEngine logIn];
//        }
//        //NSLog(@"%@",[UserDefaults valueForKey:@"sinaUser"]);
        if(![[UserDefaults valueForKey:@"sinaUser"] length]){
            BanBu_MyProfileViewController *profile = [[BanBu_MyProfileViewController alloc]init];
            profile.tableView.contentOffset = CGPointMake(0, 360);
            [self.navigationController pushViewController:profile animated:YES];
        }else{
            [TKLoadingView showTkloadingAddedTo:self.view title:NSLocalizedString(@"sinaBing", nil) activityAnimated:NO duration:1.0];

        }
        
    }else{
//        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"prefs:root=LOCATION_SERVICES"]];
        if( ![[UserDefaults valueForKey:@"QUser"] length]){
            BanBu_MyProfileViewController *profile = [[BanBu_MyProfileViewController alloc]init];
            profile.tableView.contentOffset = CGPointMake(0, 360);
            [self.navigationController pushViewController:profile animated:YES];
            [profile release];
        }else{
            [TKLoadingView showTkloadingAddedTo:self.view title:NSLocalizedString(@"tXBing", nil) activityAnimated:NO duration:1.0];
        }
        
    }
}

//监听
-(void)listeningAction:(NSNotification *)value{
    if([value object] == nil){
        haveAttach = NO;
        UIImageView *tempImageView=[[[self.view viewWithTag:_btntag] subviews]objectAtIndex:2];
        [tempImageView setImage:nil];
    }else {
        haveAttach =YES;
        UIImageView *tempImageView=[[[self.view viewWithTag:_btntag] subviews]objectAtIndex:2];
        [tempImageView setImage:[UIImage imageNamed:@"msg_btn_selected.png"]];
        _tuyaDic = [[NSDictionary alloc]initWithObjectsAndKeys:@"image",@"type",[value object],@"content", nil];
        veryImprotImageView = [[UIImageView alloc]initWithImage:[[value userInfo] objectForKey:@"tuyaImage"]];
        _receiveImage = veryImprotImageView.image;
        [self.view addSubview:veryImprotImageView1];
        veryImprotImageView1.hidden = YES;
//        //NSLog(@"%@",[[value userInfo] objectForKey:@"tuyaImage"]);
//        //NSLog(@"%@",_receiveImage);
    }

}

//发送广播
-(void)sendBrd{
    if(!isAgree){
        
        [TKLoadingView showTkloadingAddedTo:self.view title:NSLocalizedString(@"isAgreeNotice", nil) activityAnimated:NO duration:2.0];
        return;
    }
    if(!_tuyaDic && !_zhaoxiangDic && !_xiangceDic){
       
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"noticeNotice", nil) message:NSLocalizedString(@"oneImage", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"confirmNotice", nil) otherButtonTitles:NSLocalizedString(@"btnXiangCe", nil),NSLocalizedString(@"btnCamera", nil),NSLocalizedString(@"funLabel3", nil),nil];
        alert.tag = 3;
        [alert show];
        [alert release];
        return;
        
    }
    
    if(![textView.text isEqualToString:@""]){
//        UIAlertView *alert1 = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"noticeNotice", nil) message:NSLocalizedString(@"isSendBro", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"cancelNotice", nil) otherButtonTitles:NSLocalizedString(@"confirmNotice", nil),nil];
//        alert1.tag = 1;
//        [alert1 show];
//        [alert1 release];

         [self buildShareNoticeView];

        
    }else{
        [TKLoadingView showTkloadingAddedTo:self.view title:NSLocalizedString(@"contentNil", nil) activityAnimated:NO duration:1.0];
    }
    
    
    
}

-(void)buildShareNoticeView{
    UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, __MainScreen_Height+20)];
    backView.backgroundColor =  [UIColor colorWithWhite:0.1 alpha:0.6];
    backView.tag = 1001;
    [self.navigationController.view addSubview:backView];
    [backView release];
    
    UIImageView *backImageView = [[UIImageView alloc]initWithFrame:CGRectMake(15, 100, 290, 270)];
    backImageView.userInteractionEnabled = YES;
    backImageView.layer.cornerRadius = 5.0;
    backImageView.backgroundColor = [UIColor colorWithRed:255.0/255 green:250.0/255 blue:240.0/255 alpha:1.0];
    [backView addSubview:backImageView];
    [backImageView release];
    UILabel *aLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 10, 200, 30)];
    aLabel.text = NSLocalizedString(@"noticeNotice", nil);
    aLabel.font = [UIFont systemFontOfSize:18];
    aLabel.backgroundColor = [UIColor clearColor];
    [backImageView addSubview:aLabel];
    [aLabel release];
    
    UILabel *lineLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 45, 290, 1)];
    lineLabel.backgroundColor = [UIColor colorWithRed:224.0/255 green:224.0/255 blue:224.0/255 alpha:0.5];
    [backImageView addSubview:lineLabel];
    [lineLabel release];
    
    
    SSCheckBoxView *cbv = nil;
    sinaIsOK =  YES;
    TXIsOK = YES;
    CGRect frame = CGRectMake(15, 60, 260, 90);
    for (int i = 0; i < 2; ++i) {
        SSCheckBoxViewStyle style = 3;
        BOOL checked = YES;
        cbv = [[SSCheckBoxView alloc] initWithFrame:frame
                                              style:style
                                            checked:checked];
        if(i){
            [cbv setText:NSLocalizedString(@"shareToTX", nil)];
        }else{
            [cbv setText:NSLocalizedString(@"shareToSina", nil)];
        }
        //            cbv.backgroundColor = [UIColor redColor];
        cbv.tag = i+1;
        [backImageView addSubview:cbv];
        [cbv release];
        frame.origin.y += 36;
        [cbv setStateChangedTarget:self selector:@selector(checkBoxViewChangedState:)];
        
    }

    
    
    
    
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    leftBtn.frame = CGRectMake(15, 150, 260, 40);
    [leftBtn addTarget:self action:@selector(finishAction) forControlEvents:UIControlEventTouchUpInside];
    [leftBtn setTitle:NSLocalizedString(@"confirmNotice", nil) forState:UIControlStateNormal];
    [leftBtn setBackgroundImage:[[UIImage imageNamed:@"leftBtn.png"] stretchableImageWithLeftCapWidth:15.0 topCapHeight:15.0] forState:UIControlStateNormal];
    [leftBtn setBackgroundImage:[[UIImage imageNamed:@"leftBtn_selected.png"] stretchableImageWithLeftCapWidth:15.0 topCapHeight:15.0] forState:UIControlStateHighlighted];
    [backImageView addSubview:leftBtn];
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    rightBtn.frame = CGRectMake(15, 210, 260, 40);
    [rightBtn addTarget:self action:@selector(dismissSelf) forControlEvents:UIControlEventTouchUpInside];
    [rightBtn setTitle:NSLocalizedString(@"cancelNotice", nil) forState:UIControlStateNormal];
    [rightBtn setBackgroundImage:[[UIImage imageNamed:@"leftBtn.png"] stretchableImageWithLeftCapWidth:15.0 topCapHeight:15.0] forState:UIControlStateNormal];
    [rightBtn setBackgroundImage:[[UIImage imageNamed:@"leftBtn_selected.png"] stretchableImageWithLeftCapWidth:15.0 topCapHeight:15.0] forState:UIControlStateHighlighted];
    [backImageView addSubview:rightBtn];
    ;

}

-(void)finishAction{
    [self dismissSelf];
    isAlert = NO;
    BOOL com1 = ![[UserDefaults valueForKey:@"sinaUser"] isEqualToString:@""] && sinaIsOK;//新浪
    BOOL com2 = ![[UserDefaults valueForKey:@"QUser"] isEqualToString:@""] && TXIsOK;//腾讯
    //            //NSLog(@"%@,%@",[UserDefaults valueForKey:@"sinaUser"],[UserDefaults valueForKey:@"sinaUser"]);
    if(sinaIsOK){
        if(!com1){
            [TKLoadingView showTkloadingAddedTo:self.view title:NSLocalizedString(@"UnsinaBing", nil) activityAnimated:NO duration:1.0];
            return;
        }
        
    }
    if(TXIsOK){
        if(!com2){
            [TKLoadingView showTkloadingAddedTo:self.view title:NSLocalizedString(@"UnTXBing", nil) activityAnimated:NO duration:1.0];
            return;
        }
        
    }
    //            if ((sinaIsOK && !com1) || (TXIsOK && !com2)){
    //                    [TKLoadingView showTkloadingAddedTo:self.view title:@"新浪或腾讯微博未绑定！" activityAnimated:NO duration:1.0];
    //                return;
    //            }
    
    
    if(sinaIsOK){
        _wbEngine = [[WBEngine alloc] initWithAppKey:kWBSDKDemoAppKey appSecret:kWBSDKDemoAppSecret];
        [_wbEngine setDelegate:self];
        [_wbEngine setRootViewController:self];
        [_wbEngine setRedirectURI:@"http://www.halfeet.com"];
        [_wbEngine setIsUserExclusive:NO];
        
        //NSLog(@"%@",_receiveImage);
        [_wbEngine sendWeiBoWithText:textView.text image:_receiveImage];
    }
    if(TXIsOK){
        QWeiboAsyncApi *api = [[[QWeiboAsyncApi alloc] init] autorelease];
        NSString *tokenKey = [user valueForKey:AppTokenKey];
        NSString *tokenSecret = [user valueForKey:AppTokenSecret];
        
        NSString *imagePath = [NSTemporaryDirectory() stringByAppendingFormat:@"releaseImage"];
        UIImageView *sendImageView = [[UIImageView alloc]initWithImage:_receiveImage] ;
        if(sendImageView.image)
        {
            NSData *imageData;
//            if(!imageData)
                imageData = UIImageJPEGRepresentation(sendImageView.image, 0.7);
            [imageData writeToFile:imagePath atomically:YES];
            //                    //NSLog(@"%@",imageData);
        }
        //                NSString *imagePath = nil;
        //                for(NSString *tempStr in attachArr){
        ////                    //NSLog(@"%@",tempStr);
        //                    if([[tempStr valueForKey:@"type"] isEqualToString:@"image"]){
        //                        imagePath = [NSString stringWithFormat:@"%@",[tempStr valueForKey:@"content"]];
        //                    }
        //                }
        //                self.connection	= [api publishMsgWithConsumerKey:AppKey
        //                                                  consumerSecret:AppSecret
        //                                                  accessTokenKey:tokenKey
        //                                               accessTokenSecret:tokenSecret
        //                                                         content:textView.text
        //                                                       imageFile:imagePath
        //                                                      resultType:RESULTTYPE_JSON
        //                                                        delegate:self];
        self.connection	= [api publishMsgWithConsumerKey:AppKey
                                          consumerSecret:AppSecret
                                          accessTokenKey:tokenKey
                                       accessTokenSecret:tokenSecret
                                                 content:textView.text
                                               imageFile:sendImageView.image?imagePath:nil
                                              resultType:RESULTTYPE_JSON
                                                delegate:self];
        [sendImageView release];
        
    }
    
   
    if(_zhaoxiangDic){
        [attachArr addObject:_zhaoxiangDic];

    }
    if(_xiangceDic){
        [attachArr addObject:_xiangceDic];

    }
    if(_tuyaDic){
        [attachArr addObject:_tuyaDic];
        
    }
    NSMutableDictionary *abrd = [NSMutableDictionary dictionaryWithCapacity:2];
    [abrd setValue:textView.text forKey:@"saytext"];
    [abrd setValue:attachArr forKey:@"attach"];
    NSDictionary *sendDic =[NSDictionary dictionaryWithObjectsAndKeys:abrd,@"says", nil];
    [AppComManager getBanBuData:BanBu_Send_Broadcast par:sendDic delegate:self];
    [TKLoadingView showTkloadingAddedTo:self.view title:NSLocalizedString(@"chuliNotice", nil) activityAnimated:YES];
    self.navigationController.view.userInteractionEnabled = NO;
    NSLog(@"%@",sendDic);
    //            }else{
    //                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"noticeNotice", nil) message:NSLocalizedString(@"oneImage", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"confirmNotice", nil) otherButtonTitles:nil];
    //                [alert show];
    //                [alert release];
    //            }
    
}

-(void)dismissSelf{
    [[self.navigationController.view viewWithTag:1001] removeFromSuperview];
}

#pragma mark - WBEngineDelegate

-(void)engine:(WBEngine *)engine requestDidSucceedWithResult:(id)result{
    //NSLog(@"success");
}

-(void)engine:(WBEngine *)engine requestDidFailWithError:(NSError *)error{
    
}

#pragma mark UIAlertViewDelegate

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    
    if(alertView.tag!=3)
        
    {
        if(buttonIndex == 1){
            if(alertView.tag == 2){
                [self.navigationController popViewControllerAnimated:YES];

            }else{
                isAlert = NO;
                BOOL com1 = ![[UserDefaults valueForKey:@"sinaUser"] isEqualToString:@""] && sinaIsOK;//新浪
                BOOL com2 = ![[UserDefaults valueForKey:@"QUser"] isEqualToString:@""] && TXIsOK;//腾讯
    //            //NSLog(@"%@,%@",[UserDefaults valueForKey:@"sinaUser"],[UserDefaults valueForKey:@"sinaUser"]);
                if(sinaIsOK){
                    if(!com1){
                        [TKLoadingView showTkloadingAddedTo:self.view title:NSLocalizedString(@"UnsinaBing", nil) activityAnimated:NO duration:1.0];
                        return;
                    }

                }
                if(TXIsOK){
                    if(!com2){
                        [TKLoadingView showTkloadingAddedTo:self.view title:NSLocalizedString(@"UnTXBing", nil) activityAnimated:NO duration:1.0];
                        return;
                    }

                }
    //            if ((sinaIsOK && !com1) || (TXIsOK && !com2)){
    //                    [TKLoadingView showTkloadingAddedTo:self.view title:@"新浪或腾讯微博未绑定！" activityAnimated:NO duration:1.0];
    //                return;
    //            }
              

                if(sinaIsOK){
                    _wbEngine = [[WBEngine alloc] initWithAppKey:kWBSDKDemoAppKey appSecret:kWBSDKDemoAppSecret];
                    [_wbEngine setDelegate:self];
                    [_wbEngine setRootViewController:self];
                    [_wbEngine setRedirectURI:@"http://www.halfeet.com"];
                    [_wbEngine setIsUserExclusive:NO];
                    
                    //NSLog(@"%@",_receiveImage);
                    [_wbEngine sendWeiBoWithText:textView.text image:_receiveImage];
                }
                if(TXIsOK){
                    QWeiboAsyncApi *api = [[[QWeiboAsyncApi alloc] init] autorelease];
                    NSString *tokenKey = [user valueForKey:AppTokenKey];
                    NSString *tokenSecret = [user valueForKey:AppTokenSecret];

                    NSString *imagePath = [NSTemporaryDirectory() stringByAppendingFormat:@"releaseImage"];
                    UIImageView *sendImageView = [[UIImageView alloc]initWithImage:_receiveImage] ;
                    if(sendImageView.image)
                    {
                        NSData *imageData ;
                        //        if(imageData == nil)
                        //        {
                        imageData = UIImageJPEGRepresentation(sendImageView.image, 0.7);
                        //        imageData = UIImagePNGRepresentation(image);
                        //            imagePathExtension = @"jpg";
                        //        }
                        [imageData writeToFile:imagePath atomically:YES];
    //                    //NSLog(@"%@",imageData);
                    }
    //                NSString *imagePath = nil;
    //                for(NSString *tempStr in attachArr){
    ////                    //NSLog(@"%@",tempStr);
    //                    if([[tempStr valueForKey:@"type"] isEqualToString:@"image"]){
    //                        imagePath = [NSString stringWithFormat:@"%@",[tempStr valueForKey:@"content"]];
    //                    }
    //                }
    //                self.connection	= [api publishMsgWithConsumerKey:AppKey
    //                                                  consumerSecret:AppSecret
    //                                                  accessTokenKey:tokenKey
    //                                               accessTokenSecret:tokenSecret
    //                                                         content:textView.text
    //                                                       imageFile:imagePath
    //                                                      resultType:RESULTTYPE_JSON
    //                                                        delegate:self];
                    self.connection	= [api publishMsgWithConsumerKey:AppKey
                                                      consumerSecret:AppSecret
                                                      accessTokenKey:tokenKey
                                                   accessTokenSecret:tokenSecret
                                                             content:textView.text
                                                           imageFile:sendImageView.image?imagePath:nil
                                                          resultType:RESULTTYPE_JSON
                                                            delegate:self];
                    [sendImageView release];
                    
                }
                
    //            if(_tuyaDic || _zhaoxiangDic || _xiangceDic){
    //                if(_tuyaDic){
    //                    [attachArr addObject:_tuyaDic];
    //
    //                }
    //                if(_zhaoxiangDic){
    //                    [attachArr addObject:_zhaoxiangDic];
    //
    //                }
    //                if(_xiangceDic){
    //                    [attachArr addObject:_xiangceDic];
    //
    //                }
                
                    NSMutableDictionary *abrd = [NSMutableDictionary dictionaryWithCapacity:2];
                    [abrd setValue:textView.text forKey:@"saytext"];
                    [abrd setValue:attachArr forKey:@"attach"];
                    NSDictionary *sendDic =[NSDictionary dictionaryWithObjectsAndKeys:abrd,@"says", nil];
                    [AppComManager getBanBuData:BanBu_Send_Broadcast par:sendDic delegate:self];
                    [TKLoadingView showTkloadingAddedTo:self.view title:NSLocalizedString(@"chuliNotice", nil) activityAnimated:YES];
                    self.navigationController.view.userInteractionEnabled = NO;
                    NSLog(@"%@",sendDic);
    //            }else{
    //                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"noticeNotice", nil) message:NSLocalizedString(@"oneImage", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"confirmNotice", nil) otherButtonTitles:nil];
    //                [alert show];
    //                [alert release];
    //            }

            }
           
        }
        else{
            if(alertView.tag == 1){
                isAlert = NO;
            }
            if(alertView == alertSucess){
                
    //            [MyAppDataManager.nearDos removeAllObjects];
                [self.navigationController popToRootViewControllerAnimated:YES];
     
            }
        
        }
    }
    else{
       if(buttonIndex==0)
       {
       
           NSLog(@"this is o");
       
       }else if (buttonIndex==1)
       {
       
           NSLog(@"this is 1");
           
       }else if( buttonIndex==2)
       {
           NSLog(@"this is 2");
       
       
       }else
       {
        
           NSLog(@"this is 3");
       
       }
        
        
    }
    
}
#pragma mark - UIActionSheetDelegate

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if(buttonIndex == 0){
        
    }else if(buttonIndex == 1){
        
    }else if(buttonIndex == 2){
        
    }else if(buttonIndex == 3){
        
    }
    
}
/*
-(void)willPresentAlertView:(UIAlertView *)alertView
{
    
    if(!isAlert){
        isAlert = YES;
        CGRect frame=alertView.frame;
        
        if(alertView.tag == 1)
        {
            
            frame.origin.y=frame.origin.y-60;
            
            frame.size.height=frame.size.height+70;
            
            frame.size.width=frame.size.width+10;
            
            alertView.frame=frame;
            
            for(UIView *view in alertView.subviews)
            {
                if(![view isKindOfClass:[UILabel class]])
                {
                    
                    if(view.tag==1)
                    {
                        CGRect btnFrame=CGRectMake(40, frame.size.height-55, 105, 40);
                        
                        view.frame=btnFrame;
                        
                    }else if(view.tag==2)
                    {
                        
                        CGRect btnFrame2 =CGRectMake(152, frame.size.height-55, 105, 40);
                        view.frame = btnFrame2;
                        
                        
                    }
                    
                    
                }
                
            }
            SSCheckBoxView *cbv = nil;
            sinaIsOK =  YES;
            TXIsOK = YES;
            CGRect frame = CGRectMake(70, 72, 200, 30);
            for (int i = 0; i < 2; ++i) {
                SSCheckBoxViewStyle style = 3;
                BOOL checked = YES;
                cbv = [[SSCheckBoxView alloc] initWithFrame:frame
                                                      style:style
                                                    checked:checked];
                if(i){
                    [cbv setText:NSLocalizedString(@"shareToSina", nil)];
                }else{
                    [cbv setText:NSLocalizedString(@"shareToTX", nil)];
                }
                //            cbv.backgroundColor = [UIColor redColor];
                cbv.tag = i+1;
                [alertView addSubview:cbv];
                [cbv release];
                frame.origin.y += 36;
                [cbv setStateChangedTarget:self selector:@selector(checkBoxViewChangedState:)];
                
            }
        }
    }
    

    
}
*/
-(void)checkBoxViewChangedState:(SSCheckBoxView *)cbv{
    if(cbv.tag == 1){
        sinaIsOK = cbv.checked;
        //NSLog(@"checkBoxViewChangedState: %d", cbv.checked);

    }else if(cbv.tag == 2){
      
        TXIsOK = cbv.checked;
        //NSLog(@"checkBoxViewChangedState: %d", cbv.checked);

    }
    if(cbv.tag == 101){
        
        isAgree =  cbv.checked;

    }
    
}


#pragma recordView delegate method

- (void)recordView:(BroadcastRecordView *)recordView recordDidCompleted:(NSData *)audioData recordTime:(int)duration
{
    [self sendSound:audioData];
}

-(void)sendSound:(NSData *)voiceData{
    NSMutableDictionary *sendDic = [NSMutableDictionary dictionaryWithCapacity:1];
    [sendDic setValue:@"amr" forKey:@"extname"];
    [AppComManager uploadBanBuMedia:voiceData mediaName:@"luyin" par:sendDic delegate:self];
    [TKLoadingView showTkloadingAddedTo:self.view title:NSLocalizedString(@"chuliNotice", nil) activityAnimated:YES];
    self.navigationController.view.userInteractionEnabled = NO;
}

#pragma mark - ImagePickerController

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo{
    NSString *imagePathExtension = nil;
    NSString *filename = nil;
    if(picker.sourceType == UIImagePickerControllerSourceTypeCamera){
        imagePathExtension = @"jpg";
        filename = @"paizhao";
    }else{
        imagePathExtension = [[[editingInfo valueForKey:UIImagePickerControllerReferenceURL]pathExtension]lowercaseString];
        if([imagePathExtension isEqualToString:@"gif"]){
            imagePathExtension = @"jpg";
        }
        filename = @"xiangce";

    }
    NSData *data = nil;
//    if([imagePathExtension isEqualToString:@"png"]){
//        data = UIImagePNGRepresentation(image);
//    }else{
        data = UIImageJPEGRepresentation(image, 0.7);
//    }
    veryImprotImageView1 = [[UIImageView alloc]initWithImage:image] ;
    _receiveImage = veryImprotImageView1.image;
    [self.view addSubview:veryImprotImageView1];
    veryImprotImageView1.hidden = YES;
    //上传图片
    [self sendMedia:data pathExtension:imagePathExtension andMediaName:filename];
    [picker dismissModalViewControllerAnimated:YES];
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissModalViewControllerAnimated:YES];
}

//发图片
-(void)sendMedia:(NSData *)mediaData pathExtension:(NSString *)pathExtension andMediaName:(NSString *)name{
    NSMutableDictionary *senDic = [NSMutableDictionary dictionaryWithCapacity:1];
    [senDic setValue: pathExtension forKey:@"extname"];
    [AppComManager uploadBanBuMedia:mediaData mediaName:name par:senDic delegate:self];
    [TKLoadingView showTkloadingAddedTo:self.view title:NSLocalizedString(@"chuliNotice", nil) activityAnimated:YES];
    self.navigationController.view.userInteractionEnabled = NO;
}

//发位置
- (void)sendLocation
{    
    haveSendLocation = YES;
    [attachArr addObject:[NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%.f",AppLocationManager.curLocation.longitude*1000000],@"longitude",[NSString stringWithFormat:@"%.f",AppLocationManager.curLocation.latitude*1000000],@"latitude",@"location",@"type",nil]];
    //NSLog(@"%@",attachArr);
//    NSMutableDictionary *sendDic = [NSMutableDictionary dictionary];
//    [sendDic setValue:[NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%.f",AppLocationManager.curLocation.longitude*1000000],@"longitude",[NSString stringWithFormat:@"%.f",AppLocationManager.curLocation.latitude*1000000],@"latitude",@"location",@"type",nil] forKey:@"says"];
//    [AppComManager getBanBuData:BanBu_SendMessage_To_Server par:sendDic delegate:self];
    
    
}
#pragma mark - BanBuRequestDelegate

- (void)banbuRequestDidFinished:(NSDictionary *)resDic error:(NSError *)error{
    self.navigationController.view.userInteractionEnabled = YES;
    [TKLoadingView dismissTkFromView:self.view animated:YES afterShow:0.0];
    if(error)
    {
        if([error.domain isEqualToString:BanBuDataformatError])
        {
            [TKLoadingView showTkloadingAddedTo:self.view title:NSLocalizedString(@"data_error", nil) activityAnimated:NO duration:2.0];
        }
        else
        {
            [TKLoadingView showTkloadingAddedTo:self.view title:NSLocalizedString(@"network_error", nil) activityAnimated:NO duration:2.0];
        }
        
        return;
    }
    
//    //NSLog(@"%@",resDic);
    if([[resDic valueForKey:@"ok"]boolValue]){
//        alertSucess = [[UIAlertView alloc]initWithTitle:@"提示" message:@"广播发布成功！" delegate:self cancelButtonTitle:nil otherButtonTitles: @"确定",nil];
//        alertSucess = [[UIAlertView alloc]initWithTitle:@"提示" message:@"广播发布成功！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
//
//        [alertSucess show];
        [TKLoadingView showTkloadingAddedTo:self.view title:NSLocalizedString(@"releaseSuccess", nil) activityAnimated:NO duration:1.0];
        [self performSelector:@selector(backLast) withObject:nil afterDelay:1.0];
    }
}

-(void)backLast{
//    [self.navigationController popViewControllerAnimated:YES];
}
- (void)banbuUploadRequest:(NSDictionary *)resDic didFinishedWithError:(NSError *)error
{
    self.navigationController.view.userInteractionEnabled = YES;
    [TKLoadingView dismissTkFromView:self.view animated:YES afterShow:0.0];

    if(error)
    {
        [TKLoadingView showTkloadingAddedTo:self.view title:NSLocalizedString(@"uploadFailNotice", nil) activityAnimated:NO duration:2.0];
        return;
    }
//    //NSLog(@"%@",resDic);
    if([[resDic valueForKey:@"ok"] boolValue]){
        if([resDic valueForKey:@"fileurl"]){
            UIImageView *tempImageView=[[[self.view viewWithTag:_btntag] subviews]objectAtIndex:2];
            [tempImageView setImage:[UIImage imageNamed:@"msg_btn_selected.png"]];
        }
        if([[resDic valueForKey:@"requestname"] isEqualToString:@"paizhao"]){
            _zhaoxiangDic = [[NSDictionary alloc]initWithObjectsAndKeys:@"image",@"type",[resDic objectForKey:@"fileurl"],@"content", nil];
            
//            [attachArr addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"image",@"type",[resDic objectForKey:@"fileurl"],@"content", nil]];
//            //NSLog(@"%@",attachArr);
        }
        if([[resDic valueForKey:@"requestname"] isEqualToString:@"xiangce"]){
            NSLog(@"%@",[resDic objectForKey:@"fileurl"]);
            _xiangceDic = [[NSDictionary alloc]initWithObjectsAndKeys:@"image",@"type",[resDic objectForKey:@"fileurl"],@"content", nil];
            
//            [attachArr addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"image",@"type",[resDic objectForKey:@"fileurl"],@"content", nil]];
        }

        if([[resDic valueForKey:@"requestname"] isEqualToString:@"luyin"]){
            
            [attachArr addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"sound",@"type",[resDic objectForKey:@"fileurl"],@"content", nil]];

        }
        
        
    }
    
}












@end
