//
//  BanBu_ReleaseController.m
//  BanBu
//
//  Created by mac on 12-8-11.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//
#include <QuartzCore/QuartzCore.h>
#import "BanBu_ThrowBallController.h"
#import "BanBu_GraffitiController.h"

#import "AppDataManager.h"
#import "AppCommunicationManager.h"
#import "TKLoadingView.h"
#import "BanBu_LocationManager.h"


@interface BanBu_ThrowBallController ()

@end

@implementation BanBu_ThrowBallController
@synthesize btntag=_btntag;



-(void)dealloc{
    [textview1 release];
    [super dealloc];
    
}
//回收键盘
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    if(![textview1.text isEqualToString:@""]){
//        saysDic = [NSDictionary dictionaryWithObjectsAndKeys:@"text",@"type",textView.text,@"content", nil];
        [saysDic setObject:@"text" forKey:@"type"];
        [saysDic setObject:textview1.text forKey:@"content"];
        [saysDic setObject:@"" forKey:@"plong"];
        [saysDic setObject:@"" forKey:@"plat"];
//        haveContent = YES;
        [self clearSelected];
        
    }
    [textview1 resignFirstResponder];
}

//UIToolBar
-(void)pullKeyBorad{
    if(![textview1.text isEqualToString:@""]){
//        saysDic = [NSDictionary dictionaryWithObjectsAndKeys:@"text",@"type",textView.text,@"content", nil];
        [saysDic setObject:@"text" forKey:@"type"];
        [saysDic setObject:textview1.text forKey:@"content"];
        [saysDic setObject:@"" forKey:@"plong"];
        [saysDic setObject:@"" forKey:@"plat"];
//        haveContent = YES;
//        [self clearSelected];

    }

    [textview1 resignFirstResponder];
}
-(void)clearTextView{
    textview1.text=@"";
    haveContent = NO;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
    }
    return self;
}

-(void)popself{
    if(saysDic.count){
        UIAlertView *alert2 = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"noticeNotice", nil) message:NSLocalizedString(@"", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"cancelNotice", nil) otherButtonTitles:NSLocalizedString(@"confirmNotice", nil),nil];
        alert2.tag = 2;
        [alert2 show];
        [alert2 release];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(listeningAction:) name:@"Mynotification" object:nil];
    
	// Do any additional setup after loading the view.
    
    self.title = NSLocalizedString(@"throwBallTitle", nil);
    self.view.backgroundColor=[UIColor colorWithRed:255.0/255 green:250.0/255 blue:240.0/255 alpha:1.0];
    
    UIButton *btn_return=[UIButton buttonWithType:UIButtonTypeCustom];
    
    [btn_return addTarget:self action:@selector(popself) forControlEvents:UIControlEventTouchUpInside];
    
    [btn_return setBackgroundImage:[[UIImage imageNamed:@"app_nav_back_bg1.png"] stretchableImageWithLeftCapWidth:15.0 topCapHeight:15.0] forState:UIControlStateNormal];
    [btn_return setBackgroundImage:[[UIImage imageNamed:@"app_nav_back_bg2.png"] stretchableImageWithLeftCapWidth:15.0 topCapHeight:15.0] forState:UIControlStateHighlighted];
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
    sayLabel.text =NSLocalizedString(@"sayBall", nil);
    sayLabel.font=[UIFont fontWithName:@"CourierNewPS-ItalicMT" size:15];
    sayLabel.alpha = 0.8;
    sayLabel.backgroundColor = [UIColor clearColor];
    sayLabel.textColor = [UIColor redColor];
    [self.view addSubview:sayLabel];
    [sayLabel release];
        
    UIToolbar *aTool=[[UIToolbar alloc]initWithFrame:CGRectMake(0, 10, 320, 35)];
    aTool.barStyle= UIBarStyleBlackTranslucent;
    UIBarButtonItem *clear=[[UIBarButtonItem alloc]initWithTitle:NSLocalizedString(@"emptyToolItem", nil) style:UIBarButtonItemStyleBordered target:self action:@selector(clearTextView)];
    UIBarButtonItem *kon=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *cancel=[[UIBarButtonItem alloc]initWithTitle:NSLocalizedString(@"finishToolItem", nil) style:UIBarButtonItemStyleBordered target:self action:@selector(pullKeyBorad)];
    NSArray *arr=[NSArray arrayWithObjects: clear,kon,cancel, nil];
    aTool.items=arr;
    //编辑的文字
    textview1 = [[UITextView alloc] initWithFrame:CGRectMake(10, 40, 300, 90)];
    textview1.delegate = self;
    textview1.backgroundColor = [UIColor whiteColor];
    textview1.layer.borderColor = [[UIColor grayColor] CGColor];
    textview1.layer.borderWidth = 1.0;
    textview1.layer.cornerRadius = 6.0;
    textview1.textColor = [UIColor darkTextColor];
    textview1.font = [UIFont systemFontOfSize:16];
    textview1.text = @"";
    textview1.keyboardAppearance=UIKeyboardAppearanceAlert;
    [self.view addSubview:textview1];
    textview1.inputAccessoryView =aTool;
    [clear release];
    [kon release];
    [cancel release];
    [aTool release];
    //功能按钮
    for(int i=1;i<6;i++){
        UIButton * button = [UIButton buttonWithType:
							 UIButtonTypeCustom];
		button.frame = CGRectMake(15+(i-1)*63, 140, 33, 50);
		[button addTarget:self action:@selector(funButton:) forControlEvents:UIControlEventTouchUpInside];
		button.tag = i;
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 3, 33, 28)];
        imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"msg_btn%d.png",i]];
        [button addSubview:imageView];
        [imageView release];
        UILabel*label = [[UILabel alloc] initWithFrame:CGRectMake(-15, 28, 60, 20)];
		[label setBackgroundColor:[UIColor clearColor]];
        //        label.textColor = [UIColor grayColor];
		[label setFont:[UIFont systemFontOfSize:12.0]];//改变字体大小
		[label setTextAlignment:UITextAlignmentCenter];//字体中间对齐
        if (i == 1) {
            [label setText:NSLocalizedString(@"funLabel", nil)];
        }
        else if(i == 2) {
            [label setText:NSLocalizedString(@"funLabel1", nil)];
        }
        else if(i == 3) {
            [label setText:NSLocalizedString(@"funLabel2", nil)];
        }
        else if(i == 4) {
            [label setText:NSLocalizedString(@"funLabel3", nil)];
        }
        else{
            [label setText:NSLocalizedString(@"funLabel4", nil)];
        }
        
		[button addSubview:label];
		[label release];
        UIImageView *imageView1 = [[UIImageView alloc] initWithFrame:CGRectMake(10, 38, 24, 19)];
//        imageView1.image = [UIImage imageNamed:@""];
        imageView1.image = nil;

        [button addSubview:imageView1];
        [imageView1 release];
        
        [self.view addSubview:button];
        
    }
    
    /*
    //分享
    UILabel *fenLabel=[[UILabel alloc]initWithFrame:CGRectMake(125, 240, 60, 27)];
    fenLabel.text=@"分享到";
    fenLabel.backgroundColor = [UIColor clearColor];
    fenLabel.font=[UIFont systemFontOfSize:16];
    [self.view addSubview:fenLabel];
    [fenLabel release];
    for(int j=6;j<10;j++){
        UIButton * button = [UIButton buttonWithType:
							 UIButtonTypeCustom];
		button.frame = CGRectMake(185+(j-6)*32, 240, 27, 27);
        [button setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"msg_fbtn%d.png",j-5]] forState:UIControlStateNormal];
//		[button addTarget:self action:@selector(fenButton:) forControlEvents:UIControlEventTouchUpInside];
		button.tag = j;
        [self.view addSubview:button];
    }
     */
    UILabel *noticeLabel = [[UILabel alloc]initWithFrame:CGRectMake(40, 210, 240, 60)];
    noticeLabel.backgroundColor = [UIColor clearColor];
    noticeLabel.text = NSLocalizedString(@"selectOneway", nil);
    noticeLabel.numberOfLines = 0;
    noticeLabel.font = [UIFont systemFontOfSize:15];
    noticeLabel.textColor = [UIColor colorWithRed:190/255.0 green:60/255.0 blue:60/255.0 alpha:1];
    [self.view addSubview:noticeLabel];
    [noticeLabel release];
    //扔出绣球
    UIButton *sendBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    sendBtn.frame=CGRectMake(49, 300, 218, 40);
    [sendBtn setBackgroundImage:[[UIImage imageNamed:@"app_btn_blue.png"] stretchableImageWithLeftCapWidth:10.0 topCapHeight:0.0] forState:UIControlStateNormal];
    [sendBtn setTitle:NSLocalizedString(@"throwNow", nil) forState:UIControlStateNormal];
    [sendBtn addTarget:self action:@selector(sendBrd) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:sendBtn];
    saysDic=[[NSMutableDictionary alloc]init];
    
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

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [textview1 resignFirstResponder];
}
//？？？？？？
-(void)textViewDidBeginEditing:(UITextView *)textView{
    
//    if(haveContent){
//       UIActionSheet* aSheet1 = [[UIActionSheet alloc]initWithTitle:@"是否覆盖掉已编辑好的内容" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"确定" otherButtonTitles: nil];
//        [aSheet1 showInView:self.view];
//    }

}

//按钮功能选择
-(void)btnAction{
    if(_btntag<3){
        UIImagePickerController *picker = [[UIImagePickerController alloc]init];
        picker.delegate = self;
        if(_btntag == 1){
            picker.sourceType = UIImagePickerControllerSourceTypeCamera;
            
        }else if(_btntag ==2){
            picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        }
        [picker setAllowsEditing:YES];
        [self presentModalViewController:picker animated:YES];
        [picker release];
        
    }
    if(_btntag == 3){
        BroadcastRecordView *recordView = [[BroadcastRecordView alloc] initWithFrame:CGRectMake(0, 20, 320, 460)];
        NSString *fileName = @"luyin";
        recordView.audioPath = [AppComManager pathForMedia:fileName];
        recordView.delegate = self; 
        
        [self.navigationController.view addSubview:recordView];
        [recordView release];
    }
    if(_btntag ==4){
        
        BanBu_GraffitiController *aScraw=[[BanBu_GraffitiController alloc]init];
        [self presentModalViewController:aScraw animated:YES];
        [aScraw release];
        
    }
    if(_btntag == 5){
        
        [self sendLocation];
        [self clearSelected];
        UIImageView *tempImageView=[[[self.view viewWithTag:_btntag] subviews]objectAtIndex:2];
        [tempImageView setImage:[UIImage imageNamed:@"msg_btn_selected.png"]];
        
    }
}
-(void)funButton:(UIButton *)sender{
    _btntag=sender.tag;
    if(haveContent){
        aSheet = [[UIActionSheet alloc]initWithTitle:NSLocalizedString(@"editActionSheet", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"cancelNotice", nil) destructiveButtonTitle:NSLocalizedString(@"confirmNotice", nil) otherButtonTitles: nil];
        [aSheet showInView:self.view];
        [aSheet release];
    }else{
        [self btnAction];
    }
    
    
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(buttonIndex == 0){
        if(actionSheet == aSheet){
            [self btnAction];

        }
//        [self clearTextView];
    }
}

-(void)fenButton:(UIButton *)sender{
    
}

//监听涂鸦
-(void)listeningAction:(NSNotification *)value{
    if([value object] == nil){
        UIImageView *tempImageView=[[[self.view viewWithTag:_btntag] subviews]objectAtIndex:2];
//        [tempImageView setImage:[UIImage imageNamed:@""]];
        [tempImageView setImage:nil];
    }else {
        [self clearSelected];
        UIImageView *tempImageView=[[[self.view viewWithTag:4] subviews]objectAtIndex:2];
        [tempImageView setImage:[UIImage imageNamed:@"msg_btn_selected.png"]];
//        saysDic = [NSDictionary dictionaryWithObjectsAndKeys:@"image",@"type",[value object],@"content", nil];
        [saysDic setObject:@"image" forKey:@"type"];
        [saysDic setObject:[value object] forKey:@"content"];
        [saysDic setObject:@"" forKey:@"plong"];
        [saysDic setObject:@"" forKey:@"plat"];
        haveContent = YES;
        
    }
    
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
   
    if(buttonIndex == 1){
        if(alertView.tag == 2){
            [self.navigationController popViewControllerAnimated:YES];

        }else{
            if([[saysDic objectForKey:@"plong"] isEqual:@""]){
                [saysDic removeObjectForKey:@"plong"];
                [saysDic removeObjectForKey:@"plat"];
            }
            NSMutableDictionary *sendDic = [NSMutableDictionary dictionary];
            [sendDic setObject:saysDic forKey:@"says"];
            [sendDic setObject:[NSString stringWithFormat:@"%.f",AppLocationManager.curLocation.longitude*1000000] forKey:@"plong"];
            [sendDic setObject:[NSString stringWithFormat:@"%.f",AppLocationManager.curLocation.latitude*1000000] forKey:@"plat"];
            [AppComManager getBanBuData:BanBu_SendBall_To_Area par:sendDic delegate:self];
            //NSLog(@"%@",sendDic);
        }
        
    
    }else {
//        if(alertView == alertSuccess){
//            [self.navigationController popToRootViewControllerAnimated:YES];
//        }

    }
}
//抛出绣球
-(void)sendBrd{
//    //NSLog(@"%@",saysDic);
    if(![textview1.text isEqual:@""]){
        
        UIAlertView *alert1 = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"noticeNotice", nil) message:NSLocalizedString(@"throwAlert", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"cancelNotice", nil) otherButtonTitles:NSLocalizedString(@"confirmNotice", nil),nil];
        [alert1 show];
        [alert1 release];
        
    }else{
//        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"没有文字信息！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
//        [alert show];
//        [alert release];
        [TKLoadingView showTkloadingAddedTo:self.view title:NSLocalizedString(@"wordNilNotice", nil) activityAnimated:NO duration:1.0];
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
    if([imagePathExtension isEqualToString:@"png"]){
        data = UIImagePNGRepresentation(image);
    }else{
        data = UIImageJPEGRepresentation(image, 1.0);
    }
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
}

//发位置
- (void)sendLocation
{    
//    saysDic = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%.f",AppLocationManager.curLocation.plong*1000000],@"plong",[NSString stringWithFormat:@"%.f",AppLocationManager.curLocation.plat*1000000],@"plat",@"location",@"type",nil];
    [saysDic setObject:@"location" forKey:@"type"];
    [saysDic setObject:[NSString stringWithFormat:@"%.f",AppLocationManager.curLocation.longitude*1000000] forKey:@"plong"];
    [saysDic setObject:[NSString stringWithFormat:@"%.f",AppLocationManager.curLocation.latitude*1000000] forKey:@"plat"];
    haveContent = YES;

 
    //    NSMutableDictionary *sendDic = [NSMutableDictionary dictionary];
    //    [sendDic setValue:[NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%.f",AppLocationManager.curLocation.plong*1000000],@"plong",[NSString stringWithFormat:@"%.f",AppLocationManager.curLocation.plat*1000000],@"plat",@"location",@"type",nil] forKey:@"says"];
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
    
    //NSLog(@"%@",resDic);
    if([[resDic valueForKey:@"ok"]boolValue]){
//        alertSuccess = [[UIAlertView alloc]initWithTitle:@"提示" message:@"绣球抛出成功！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
//        [alertSuccess show];
//        [alertSuccess release];
        [TKLoadingView showTkloadingAddedTo:self.view title:NSLocalizedString(@"throwSuccess", nil) activityAnimated:NO duration:1.0];
        [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(popLastViewC) userInfo:nil repeats:NO];
 
    }
}

-(void)popLastViewC{
    [self.navigationController popToRootViewControllerAnimated:YES];

}

- (void)banbuUploadRequest:(NSDictionary *)resDic didFinishedWithError:(NSError *)error
{
    if(error)
    {
        [TKLoadingView showTkloadingAddedTo:self.view title:NSLocalizedString(@"uploadFailNotice", nil) activityAnimated:NO duration:2.0];
        return;
    }
    //NSLog(@"%@",resDic);
    if([[resDic valueForKey:@"ok"] boolValue]){
       
        if([resDic valueForKey:@"fileurl"]){
            [self clearSelected];
            UIImageView *tempImageView=[[[self.view viewWithTag:_btntag] subviews]objectAtIndex:2];
            [tempImageView setImage:[UIImage imageNamed:@"msg_btn_selected.png"]];
            haveContent  = YES;
        }
        
        if([[resDic valueForKey:@"requestname"] isEqualToString:@"luyin"]){
            
//            saysDic = [NSDictionary dictionaryWithObjectsAndKeys:@"sound",@"type",[resDic objectForKey:@"fileurl"],@"content", nil];
            [saysDic setObject:@"sound" forKey:@"type"];
            [saysDic setObject:[resDic objectForKey:@"fileurl"] forKey:@"content"];
            
        }else{
            //拍照和相片
            [saysDic setObject:@"image" forKey:@"type"];
            [saysDic setObject:[resDic objectForKey:@"fileurl"] forKey:@"content"];
        }
        [saysDic setObject:@"" forKey:@"plong"];
        [saysDic setObject:@"" forKey:@"plat"];
        
    }
    
}



//清除按钮的选中状态
-(void)clearSelected{
    
    for(int i=1;i<6;i++){
        UIImageView *tempImageView = [[[self.view viewWithTag:i]subviews]objectAtIndex:2];
//        [tempImageView setImage:[UIImage imageNamed:@""]];
        [tempImageView setImage:nil];

    }
}








@end
