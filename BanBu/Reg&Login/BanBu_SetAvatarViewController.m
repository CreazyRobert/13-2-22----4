//
//  BanBu_SetAvatarViewController.m
//  BanBu
//
//  Created by jie zheng on 12-7-7.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "BanBu_SetAvatarViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "BanBu_AppDelegate.h"
#import "TKLoadingView.h"
#import "AppCommunicationManager.h"
#import "AppDataManager.h"
#import "UIImageView+WebCache.h"
#import "BanBu_LocationManager.h"
#import "BanBu_MyProfileViewController.h"
@interface BanBu_SetAvatarViewController ()
@end
int selectIndex = -1;
@implementation BanBu_SetAvatarViewController
@synthesize imagePathExtension = _imagePathExtension;

- (id)initWith
{
    self = [super init];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _useDefaultImage = NO;
    self.view.backgroundColor = [UIColor colorWithRed:255.0/255 green:250.0/255 blue:240.0/255 alpha:1.0];
    self.title =NSLocalizedString(@"avatarTitle", nil);
    
    CGFloat btnLen = [NSLocalizedString(@"finishButton", nil) sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(100, 30)].width;
    
     UIButton *nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
    nextButton.frame=CGRectMake(0, 0, btnLen+20, 30);
    [nextButton addTarget:self action:@selector(complete:) forControlEvents:UIControlEventTouchUpInside];
    [nextButton setBackgroundImage:[[UIImage imageNamed:@"app_nav_btn_bg1.png"] stretchableImageWithLeftCapWidth:15.0 topCapHeight:15.0] forState:UIControlStateNormal];
    [nextButton setBackgroundImage:[[UIImage imageNamed:@"app_nav_btn_bg2.png"] stretchableImageWithLeftCapWidth:15.0 topCapHeight:15.0] forState:UIControlStateHighlighted];
    [nextButton setTitleEdgeInsets:UIEdgeInsetsMake(3, 2, 2, 2)];
    [nextButton setTitle:NSLocalizedString(@"finishButton", nil) forState:UIControlStateNormal];
    nextButton.titleLabel.font = [UIFont systemFontOfSize:14];
    UIBarButtonItem *next = [[[UIBarButtonItem alloc] initWithCustomView:nextButton] autorelease];
    self.navigationItem.rightBarButtonItem = next;
    
    UIView *bkView = [[UIView alloc] initWithFrame:CGRectMake(20, 20, 130, 130)];
    bkView.backgroundColor = [UIColor whiteColor];
    bkView.layer.borderColor = [[UIColor grayColor] CGColor];
    bkView.layer.borderWidth = 1.0;
    bkView.layer.cornerRadius = 6.0f;
    [self.view addSubview:bkView];
    [bkView release];
    
    UIImageView *imageview = [[UIImageView alloc] initWithFrame:CGRectMake(10.0, 10.0, 110, 110)];
    _avatorView = imageview;
    imageview.image = [UIImage imageNamed:@"icon_default.png"];
    [bkView addSubview:imageview];
    [imageview release];
    
    UIButton *btnXiangCe = [UIButton buttonWithType:UIButtonTypeCustom];
    btnXiangCe.frame = CGRectMake(165, 20, 130, 65);
    [btnXiangCe setBackgroundImage:[UIImage imageNamed:@"button_reggallery.png"] forState:UIControlStateNormal];
    [btnXiangCe setTitleEdgeInsets:UIEdgeInsetsMake(35, 0, 10, 0)];
    [btnXiangCe setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    btnXiangCe.titleLabel.font = [UIFont systemFontOfSize:13];
    [btnXiangCe setTitle:NSLocalizedString(@"btnXiangCe", nil) forState:UIControlStateNormal];
    [btnXiangCe addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    btnXiangCe.tag = 1;
    [self.view addSubview:btnXiangCe];
    
    UIButton *btnCamera = [UIButton buttonWithType:UIButtonTypeCustom];
    btnCamera.frame = CGRectMake(165, 85, 130, 65);
    [btnCamera setBackgroundImage:[UIImage imageNamed:@"button_regtake.png"] forState:UIControlStateNormal];
    [btnCamera setTitleEdgeInsets:UIEdgeInsetsMake(35, 0, 10, 0)];
    [btnCamera setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    btnCamera.titleLabel.font = [UIFont systemFontOfSize:13];
    [btnCamera setTitle:NSLocalizedString(@"btnCamera", nil) forState:UIControlStateNormal];
    [btnCamera addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    btnCamera.tag = 2;
    [self.view addSubview:btnCamera];
    
//    self.navigationItem.hidesBackButton = YES;
    avatarScroll = [[UIScrollView alloc] initWithFrame:CGRectMake(10, __MainScreen_Height-50-200, 300,190)];
    avatarScroll.showsHorizontalScrollIndicator = NO;
    avatarScroll.showsVerticalScrollIndicator = NO;
//    avatarScroll 
//    avatarScroll.scrollEnabled = NO;
//    [avatarScroll setBackgroundColor:[UIColor redColor]];
    [self.view addSubview:avatarScroll];
//    avatarScroll.layer.cornerRadius = 8.0;
//    avatarScroll.layer.borderWidth = 0.8;
//    avatarScroll.layer.borderColor = [[UIColor blackColor] CGColor];
    [AppComManager getBanBuData:BanBu_Get_System_Facelist par:nil delegate:self];
    
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    [AppComManager cancalHandlesForObject:self];
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.navigationItem.hidesBackButton = YES;

}

- (void)btnAction:(UIButton *)button
{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    if(button.tag == 1)
    {
        if ([UIImagePickerController isSourceTypeAvailable:
             UIImagePickerControllerSourceTypePhotoLibrary]) {
            picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        }
    }
    else 
    {        
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;        
    }
    [picker setAllowsEditing:YES];
    [self presentModalViewController:picker animated:YES];
    [picker release];

    
}

#pragma mark  -
- (void)imagePickerController:(UIImagePickerController *)picker 
        didFinishPickingImage:(UIImage *)image
                  editingInfo:(NSDictionary *)editingInfo {
    
    
    if(picker.sourceType == UIImagePickerControllerSourceTypeCamera)
        self.imagePathExtension = @"jpg";
    else
    {
        self.imagePathExtension = [[[editingInfo valueForKey:UIImagePickerControllerReferenceURL] pathExtension] lowercaseString];
        if([self.imagePathExtension isEqualToString:@"gif"])
            self.imagePathExtension = @"jpg";
    }
    
    //NSLog(@"geshi:%@",_imagePathExtension);
    
    _picked = YES;
    _avatorView.image = image;
    [picker dismissModalViewControllerAnimated:YES];    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [picker dismissModalViewControllerAnimated:YES];
}

/*//提交用户个人照片BASE64版 以post形式提交，文件先经base64编码
 网址　http://www.halfeet.com/_user_login/_base64_user_face.php?phone=y&loginid=xxxxxxx&photofile=xxxxxxx
 参数　{"fc":"base64_user_face","loginid":"20120707221438-28D8AD6E-569E-677F-2385-6DBCD987FF31","phone":"y","photofile":"eyJmYyI6InNldF91c2VyX2xvY2F0aW9uIiwibG9naW5pZCI6IjIw"}
 返回　{"fc":"base64_user_face","ok":"y"}
 
 loginid值为登录ID
 phone值为y表示来自手机客户端
 photofile值为经过base64编码后的文件
 ok值为y表示设置成功，值为n表示设置失败
 *头像为高宽相等的正方形，限10k-200K，超200K则保持高宽比例缩小到200K以内*/

//- (void)complete:(UIButton *)button
//{
//    if(!_picked)
//    {
////        [TKLoadingView showTkloadingAddedTo:self.view title:@"请选择头像" activityAnimated:NO duration:1.5];
//        [TKLoadingView showTkloadingAddedTo:self.view point:CGPointMake(0, 180) title:NSLocalizedString(@"selectAvater", nil) activityAnimated:NO duration:1.0];
//
//        return;
//    }
//    
//    NSData *data = nil;
////    if([self.imagePathExtension isEqualToString:@"png"])
////        data = UIImagePNGRepresentation(_avatorView.image);
////    else
//        data = UIImageJPEGRepresentation(_avatorView.image, 0.5);
//    NSLog(@"注册时头像的大小%d",data.length);
//    NSMutableDictionary *uploadDic = [NSMutableDictionary dictionary];
//    [uploadDic setValue:@"y" forKey:@"phone"];
//    [uploadDic setValue:@"jpg" forKey:@"picformat"];
//    self.navigationController.view.userInteractionEnabled = NO;
//    [TKLoadingView showTkloadingAddedTo:self.view title:NSLocalizedString(@"sendAvater", nil) activityAnimated:YES];
//    [AppComManager uploadRegAvatarImage:data Par:uploadDic delegate:self];
//    
//}
-(void)complete:(UIButton *)button
{
    if(_picked)
    {
        //        [TKLoadingView showTkloadingAddedTo:self.view title:@"请选择头像" activityAnimated:NO duration:1.5];
        NSData *data = nil;
        //    if([self.imagePathExtension isEqualToString:@"png"])
        //        data = UIImagePNGRepresentation(_avatorView.image);
        //    else
        data = UIImageJPEGRepresentation(_avatorView.image, 0.5);
        NSLog(@"注册时头像的大小%d",data.length);
        NSMutableDictionary *uploadDic = [NSMutableDictionary dictionary];
        [uploadDic setValue:@"y" forKey:@"phone"];
        [uploadDic setValue:@"jpg" forKey:@"picformat"];
        self.navigationController.view.userInteractionEnabled = NO;
        [TKLoadingView showTkloadingAddedTo:self.view title:NSLocalizedString(@"sendAvater", nil) activityAnimated:YES];
        [AppComManager uploadRegAvatarImage:data Par:uploadDic delegate:self];

    }
    else if(_useDefaultImage)
    {
        [MyAppDataManager.regDic setValue:[NSString stringWithFormat:@"%.f",AppLocationManager.curLocation.latitude*1000000] forKey:Latitude];
        [MyAppDataManager.regDic setValue:[NSString stringWithFormat:@"%.f",AppLocationManager.curLocation.longitude*1000000] forKey:Longitude];
        
//        NSLog(@"%@",[self getFaceName:[[_facelist objectAtIndex:selectIndex] valueForKey:@"system_facefile"]]);
//        NSLog(@"%@",[self getFaceName:[[_facelist objectAtIndex:selectIndex] valueForKey:@"system_facefull"]]);
        [MyAppDataManager.regDic setValue:[self getFacePath:[[_facelist objectAtIndex:selectIndex] valueForKey:@"system_facefile"]] forKey:@"facepath"];
        [MyAppDataManager.regDic setValue:[self getFaceName:[[_facelist objectAtIndex:selectIndex] valueForKey:@"system_facefile"]] forKey:@"facefile"];
        [MyAppDataManager.regDic setValue:[self getFaceName:[[_facelist objectAtIndex:selectIndex] valueForKey:@"system_facefull"]] forKey:@"facefull"];
        UIAlertView * alert= [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"waitauditNotice", nil) message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:NSLocalizedString(@"confirmNotice", nil),nil];
        alert.tag = 2;
        [alert show];
        [alert release];
    }
    else
    {
        
        [TKLoadingView showTkloadingAddedTo:self.view point:CGPointMake(0, 180) title:NSLocalizedString(@"selectAvater", nil) activityAnimated:NO duration:1.0];
        
        return;
    }

    
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    NSLog(@"%d",buttonIndex);
    if(buttonIndex == 1){
        if(alertView.tag == 1){
            [self performSelector:@selector(complete:)];

        }
    }else{
        if(alertView.tag == 2){
            
            [AppComManager getBanBuData:BanBu_Set_Register_User par:MyAppDataManager.regDic delegate:self];
            self.navigationController.view.userInteractionEnabled =NO;
            [TKLoadingView showTkloadingAddedTo:self.view title:NSLocalizedString(@"registering", nil) activityAnimated:YES];
        }
    }
}

- (void)banbuRequestDidFinished:(NSDictionary *)resDic error:(NSError *)error
{
    self.navigationController.view.userInteractionEnabled = YES;
    [TKLoadingView dismissTkFromView:self.view animated:YES afterShow:0.0];
    if(error)
    {
        if([AppComManager respondsDic:resDic isFunctionData:BanBu_Set_User_Avatar]){
            
            UIAlertView * alert= [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"uploadFailNotice", nil) message:nil delegate:self cancelButtonTitle:NSLocalizedString(@"cancelNotice", nil) otherButtonTitles:NSLocalizedString(@"reUpload", nil), nil];
            alert.tag = 1;
            [alert show];
            [alert release];
            return;
        }
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
    
//    NSLog(@"res:%@",resDic);
    if([AppComManager respondsDic:resDic isFunctionData:BanBu_Set_User_Avatar]){
        if([[resDic valueForKey:@"ok"] boolValue])
        {

            [MyAppDataManager.regDic setValue:[NSString stringWithFormat:@"%.f",AppLocationManager.curLocation.latitude*1000000] forKey:Latitude];
            [MyAppDataManager.regDic setValue:[NSString stringWithFormat:@"%.f",AppLocationManager.curLocation.longitude*1000000] forKey:Longitude];
            [MyAppDataManager.regDic setValue:[self getFacePath:[resDic valueForKey:@"smallpic"]] forKey:@"facepath"];
            [MyAppDataManager.regDic setValue:[self getFaceName:[resDic valueForKey:@"smallpic"]] forKey:@"facefile"];
            [MyAppDataManager.regDic setValue:[self getFaceName:[resDic valueForKey:@"largepic"]] forKey:@"facefull"];

            
            UIAlertView * alert= [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"waitauditNotice", nil) message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:NSLocalizedString(@"confirmNotice", nil),nil];
            alert.tag = 2;
            [alert show];
            [alert release];
          

//            //NSLog(@"%@",[self getFacePath:[resDic valueForKey:@"smallpic"]]);
            
        }else{
            [TKLoadingView showTkloadingAddedTo:self.view title:[MyAppDataManager IsInternationalLanguage:[resDic valueForKey:@"error"]] activityAnimated:NO duration:2.0];
        }
    }
    if([AppComManager respondsDic:resDic isFunctionData:BanBu_Set_Register_User]){
        if([[resDic valueForKey:@"ok"] boolValue]){
            
            NSMutableDictionary *loginDic = [NSMutableDictionary dictionary];
            [loginDic setValue:[MyAppDataManager.regDic valueForKey:@"email"] forKey:@"email"];
            [loginDic setValue:[MyAppDataManager.regDic valueForKey:@"pass"] forKey:@"pass"];
            [loginDic setValue:[NSString stringWithFormat:@"%.f",AppLocationManager.curLocation.latitude*1000000] forKey:@"plat"];
            [loginDic setValue:[NSString stringWithFormat:@"%.f",AppLocationManager.curLocation.longitude*1000000] forKey:@"plong"];
            [loginDic setValue:[MyAppDataManager.regDic valueForKey:@"regby"] forKey:@"regby"];
            
            BanBu_AppDelegate *delegate = (BanBu_AppDelegate *)[UIApplication sharedApplication].delegate;
            //    NSLog(@"%@",delegate.pushid);
            [loginDic setValue:delegate.pushid forKey:@"pushid"];
            
            
            
            
            
            NSString *isJailbroken = nil;
            if([[UIDevice currentDevice] isJailbroken]){
                isJailbroken = @"YES";
            }else{
                isJailbroken = @"NO";
            }
            [loginDic setValue:[NSString stringWithFormat:@"%@::%@::%@::%@::%@",[[UIDevice currentDevice] systemName],[[UIDevice currentDevice] systemVersion],[MyAppDataManager getPreferredLanguage],[[UIDevice currentDevice] platformString],isJailbroken] forKey:@"sysparam"];
            
            //根据语言，登陆时的提示；
            NSString *langauage=[[MyAppDataManager getPreferredLanguage]substringToIndex:2];
            //    NSLog(@"%@",langauage);
            
            if([langauage isEqual:@"zh"]){
                [loginDic setValue:@"cn" forKey:@"lang"];
                
            }else if([langauage isEqual:@"ja"]){
                [loginDic setValue:@"jp" forKey:@"lang"];
            }else{
                [loginDic setValue:@"en" forKey:@"lang"];
            }
            
            [AppComManager getBanBuData:BanBu_Check_Login par:loginDic delegate:self];
            self.navigationController.view.userInteractionEnabled = NO;
            [TKLoadingView showTkloadingAddedTo:self.view title:NSLocalizedString(@"getMessage", nil) activityAnimated:YES];
//            NSLog(@"%@",loginDic);
        }else{
            [TKLoadingView showTkloadingAddedTo:self.view title:[MyAppDataManager IsInternationalLanguage:[resDic valueForKey:@"error"]] activityAnimated:NO duration:2.0];
        }
    }

    else if([AppComManager respondsDic:resDic isFunctionData:BanBu_Check_Login]){
        

        if([[resDic valueForKey:@"ok"]boolValue]){

            MyAppDataManager.loginid = [resDic valueForKey:@"loginid"];
            MyAppDataManager.useruid = [resDic valueForKey:@"userid"];
            MyAppDataManager.userAvatar =[resDic valueForKey:@"uface"];
            [UserDefaults setValue:resDic forKey:MyAppDataManager.useruid];
             //是否多余
//            [UserDefaults setValue:[BanBu_MyProfileViewController buildMyProfile:resDic] forKey:MyProfile];
//             [UserDefaults synchronize];
            if(![[UserDefaults valueForKey:MyAppDataManager.useruid] valueForKey:@"settings"]){
                NSMutableDictionary *settingsDic = [NSMutableDictionary dictionaryWithCapacity:2];
                [settingsDic setValue:[NSArray arrayWithObjects:[NSNumber numberWithBool:YES],[NSNumber numberWithBool:YES], nil] forKey:@"boolKey"];
                [settingsDic setValue:@"msg_1" forKey:@"MusicSwith"];
                NSMutableDictionary *addDic = [NSMutableDictionary dictionaryWithDictionary:resDic];
                [addDic setValue:settingsDic forKey:@"settings"];
                [UserDefaults setValue:addDic forKey:MyAppDataManager.useruid];
            }
            else{
                NSMutableDictionary *settingsDic = [NSMutableDictionary dictionaryWithDictionary:[[UserDefaults valueForKey:MyAppDataManager.useruid] valueForKey:@"settings"]];
                NSMutableDictionary *addDic = [NSMutableDictionary dictionaryWithDictionary:resDic];
                [addDic setValue:settingsDic forKey:@"settings"];
                [UserDefaults setValue:addDic forKey:MyAppDataManager.useruid];
                
            }
            [UserDefaults setValue:MyAppDataManager.useruid forKey:@"myID"];
            [UserDefaults synchronize];

            
            
            NSLog(@"%@", MyAppDataManager.regDic);
            if([[MyAppDataManager.regDic valueForKey:@"regby"]isEqualToString:@"b"]){
                NSMutableDictionary *pars = [NSMutableDictionary dictionaryWithCapacity:2];
                if([[MyAppDataManager.regDic valueForKey:@"bindtype"]integerValue] == 2){
                    [pars setValue:@"twitter" forKey:@"bindto"];
                    [pars setValue:[NSString stringWithFormat:@"%@,%@,%@",[UserDefaults valueForKey:@"TAccessToken"],[UserDefaults valueForKey:@"TAccessTokenSecret"],[UserDefaults valueForKey:@"TUser"]] forKey:@"bindstring"];
                }else if([[MyAppDataManager.regDic valueForKey:@"bindtype"]integerValue] == 1){
                    [pars setValue:@"facebook" forKey:@"bindto"];
                    //            [pars setValue:[NSString stringWithFormat:@"%@,%@",nil,@""] forKey:@"bindstring"];
                    [pars setValue:[NSString stringWithFormat:@"%@,%@",[UserDefaults valueForKey:@"FBAccessToken"],[UserDefaults valueForKey:@"FBUser"]] forKey:@"bindstring"];
                }
                
                
                [AppComManager getBanBuData:BanBu_Set_User_accountbind par:pars delegate:self];
                self.navigationController.view.userInteractionEnabled = NO;
            }else{
                [UserDefaults setValue:@"" forKey:@"QUser"];
                [UserDefaults setValue:@"" forKey:@"sinaUser"];
                BanBu_AppDelegate *delegate = (BanBu_AppDelegate *)[UIApplication sharedApplication].delegate;
                delegate.logined = YES;
                [delegate setViewController:YES];
            }
            
            
        }

    }
    else if([AppComManager respondsDic:resDic isFunctionData:BanBu_Set_User_accountbind]){
        NSMutableDictionary *uidDic = [NSMutableDictionary dictionaryWithDictionary:[UserDefaults valueForKey:MyAppDataManager.useruid]];
        [uidDic setValue:[resDic valueForKey:@"bindlist"] forKey:@"bindlist"];
        [UserDefaults setValue:uidDic forKey:MyAppDataManager.useruid];
        [UserDefaults synchronize];
        
        
        
#warning 未完成的注册分享
        //分享修改后的资料
        
    
        if([[UserDefaults valueForKey:@"TUser"] length]){
            FHSTwitterEngine * aEngine = [[[FHSTwitterEngine alloc]initWithConsumerKey:@"2cZXkfmSC6UrPUkhSPtfwQ" andSecret:@"mdoijXeFbK6dGVs5C61rADMOWSgFdNtPOBsxgnKw"]autorelease];
            [aEngine loadAccessToken];
            dispatch_async(GCDBackgroundThread, ^{
                @autoreleasepool {
                    
                    //发送的内容
                    [aEngine postTweet:NSLocalizedString(@"reginShare", nil)];
                    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                    dispatch_sync(GCDMainThread, ^{
                        
                    });
                }
            });
            
        }
        if([[UserDefaults valueForKey:@"FBUser"] length]){
            
            BOOL displayedNativeDialog = [FBNativeDialogs presentShareDialogModallyFrom:self
                                                                            initialText:nil
                                                                                  image:nil
                                                                                    url:nil
                                                                                handler:nil];
            if (!displayedNativeDialog) {
                
                [self performPublishAction:^{
                    // otherwise fall back on a request for permissions and a direct post
                    
                    [FBRequestConnection startForPostStatusUpdate:NSLocalizedString(@"reginShare", nil)
                                                completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
                                                    
                                                }];
                    
                }];
            }
        }

    
        BanBu_AppDelegate *delegate = (BanBu_AppDelegate *)[UIApplication sharedApplication].delegate;
        delegate.logined = YES;
        [delegate setViewController:YES];
        
    }
    else if([AppComManager respondsDic:resDic isFunctionData:BanBu_Get_System_Facelist])
    {
        NSLog(@"%@",resDic);
        _facelist = [[resDic valueForKey:@"facelist"] retain];
        avatarScroll.contentSize = CGSizeMake((_facelist.count/2+(_facelist.count%2))*90+10, 190);
        for(int i=0;i<_facelist.count;i++)
        {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.frame = CGRectMake((i%(_facelist.count/2+(_facelist.count%2)))*90+10,(i+1)>(_facelist.count/2+(_facelist.count%2))?100:10,80, 80);
            button.tag = 1223+i;
//            button.layer.cornerRadius = 8.0;
            button.layer.borderWidth = 0.8;
            button.layer.borderColor = [[UIColor blackColor] CGColor];
            [button setImageWithURL:[NSURL URLWithString:[[_facelist objectAtIndex:i] valueForKey:@"system_facefile"]]];
            NSLog(@"%@",[[_facelist objectAtIndex:i] valueForKey:@"system_facefile"]);
            [button addTarget:self action:@selector(changeAvatar:) forControlEvents:UIControlEventTouchUpInside];            [avatarScroll addSubview:button];
        }
    }
}
-(void)changeAvatar:(UIButton *)sender
{
    [_avatorView setImageWithURL:[NSURL URLWithString:[[_facelist objectAtIndex:sender.tag-1223] valueForKey:@"system_facefile"]]];
    _useDefaultImage = YES;
    selectIndex = sender.tag-1223;
}
- (NSString *)getFacePath:(NSString *)parStr{
    NSInteger start = 7;
    NSInteger end = [parStr rangeOfString:@"/photo" options:NSBackwardsSearch].location;
    return [parStr substringWithRange:NSMakeRange(start, end-start)];
}

- (NSString *)getFaceName:(NSString *)parStr{
    NSInteger start = [parStr rangeOfString:@"face/" options:NSBackwardsSearch].location+5;
    NSInteger end = parStr.length;
//    //NSLog(@"%@",[parStr substringWithRange:NSMakeRange(start, end-start)]);
    return [parStr substringWithRange:NSMakeRange(start, end-start)];
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    self.imagePathExtension = nil;
}

- (void)dealloc
{
    [_imagePathExtension release];
    [super dealloc];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}



//facebook分享


- (void) performPublishAction:(void (^)(void)) action {
    // we defer request for permission to post to the moment of post, then we check for the permission
    if ([FBSession.activeSession.permissions indexOfObject:@"publish_actions"] == NSNotFound) {
        // if we don't already have the permission, then we request it now
        [[FBSession activeSession] reauthorizeWithPublishPermissions:@[@"publish_actions"] defaultAudience:FBSessionDefaultAudienceFriends completionHandler:^(FBSession *session, NSError *error) {
            if (!error) {
                action();
            }
        }];
    } else {
        action();
    }
}

@end
