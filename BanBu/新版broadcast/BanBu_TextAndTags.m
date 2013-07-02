//
//  BanBu_TextAndTags.m
//  BanBu
//
//  Created by Jc Zhang on 13-3-12.
//
//

#import "BanBu_TextAndTags.h"
#import "AppCommunicationManager.h"
#import "AppDataManager.h"
#import "TKLoadingView.h"
#import "RecordAudio.h"
#import "BanBu_MyProfileViewController.h"
@interface BanBu_TextAndTags ()

@end

@implementation BanBu_TextAndTags
- (void)storeAccessToken:(NSString *)accessToken {
    [[NSUserDefaults standardUserDefaults]setObject:accessToken forKey:@"SavedAccessHTTPBody"];
}

- (NSString *)loadAccessToken {
    return [[NSUserDefaults standardUserDefaults]objectForKey:@"SavedAccessHTTPBody"];
}
-(void)dealloc{
    
    [_soundTime release];
    [_imageString release];
    [_imageData release];
    [_soundData release];
    self.functionView = nil;
    [super dealloc];
    
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(id)initWithSendImage:(NSData *)aImageData andSoundData:(NSData *)aSoundData andSoundDuration:(NSString *)duration{

    self = [super init];
    if(self){
        
        _imageData = [[NSData alloc]initWithData:aImageData];
        if(aSoundData){
            _soundData = [[NSData alloc]initWithData:aSoundData];
            _soundTime = [[NSString alloc]initWithString:duration];
        }
    }
    return self;
}



- (void)textViewDidChange:(UITextView *)textView{
    
    
    if(textView.text.length !=0){
        if(textView.text.length == 1){
            if([textView.text isEqualToString:@" "] || [textView.text isEqualToString:@"\n"]){
                aTextView.text = [textView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                return;
            }
        }
      
        backTextField.placeholder = @"";
    }else{
        backTextField.placeholder = @"此刻写点什么吧...";
    }
}

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([text isEqualToString:@"\n"]) {
        return NO;
    }
    return YES;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.title = NSLocalizedString(@"textAndTagsTitle", nil);
    self.view.backgroundColor = [UIColor colorWithRed:255.0/255 green:250.0/255 blue:240.0/255 alpha:1.0];

    
    UIButton *completeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [completeButton addTarget:self action:@selector(sendBroadcast) forControlEvents:UIControlEventTouchUpInside];
    [completeButton setBackgroundImage:[[UIImage imageNamed:@"app_nav_btn_bg1.png"] stretchableImageWithLeftCapWidth:15.0 topCapHeight:15.0] forState:UIControlStateNormal];
    [completeButton setBackgroundImage:[[UIImage imageNamed:@"app_nav_btn_bg2.png"] stretchableImageWithLeftCapWidth:15.0 topCapHeight:15.0] forState:UIControlStateHighlighted];
    CGFloat btnLen = [NSLocalizedString(@"finishButton", nil) sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(100, 30)].width;
    
    completeButton.frame=CGRectMake(0, 0, btnLen+20, 30);
    [completeButton setTitleEdgeInsets:UIEdgeInsetsMake(3, 2, 2, 2)];
    [completeButton setTitle:NSLocalizedString(@"finishButton", nil) forState:UIControlStateNormal];
    completeButton.titleLabel.font = [UIFont systemFontOfSize:14];
    UIBarButtonItem *complete = [[[UIBarButtonItem alloc] initWithCustomView:completeButton] autorelease];
    self.navigationItem.rightBarButtonItem = complete;
//    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//    self.tableView.backgroundView = nil;
//    self.tableView.backgroundColor = [UIColor colorWithRed:255.0/255 green:250.0/255 blue:240.0/255 alpha:1.0];
//    self.tableView.scrollEnabled = NO;
    backTextField = [[UITextField alloc]initWithFrame:CGRectMake( 10, 13, 310, 18)];
    backTextField.placeholder = NSLocalizedString(@"textDescription", nil);
    backTextField.backgroundColor = [UIColor clearColor];
    backTextField.userInteractionEnabled = NO;
    backTextField.font = [UIFont boldSystemFontOfSize:14];
    [self.view addSubview:backTextField];
    [backTextField release];
    aTextView = [[UITextView alloc]initWithFrame:CGRectMake( 0, 5, 320, 36+18)];
    aTextView.backgroundColor = [UIColor clearColor];
    aTextView.delegate = self;
    aTextView.font = [UIFont boldSystemFontOfSize:14];
    [aTextView becomeFirstResponder];
    [self.view addSubview:aTextView];
    [aTextView release];
    
    UIView *aView = [[UIView alloc]initWithFrame:CGRectMake(0, __MainScreen_Height-44-216-90, 320, 90)];
    aView.backgroundColor = [UIColor clearColor];
    self.functionView = aView;
    [self.view addSubview:aView];
    [aView release];
    
    //分享栏
    UIView *shareView = [[UIView alloc]initWithFrame:CGRectMake(0, 90-44, 320, 44)];
    shareView.backgroundColor = [UIColor colorWithRed:210.0/256 green:210.0/256 blue:210.0/256 alpha:1.0];
    [self.functionView addSubview:shareView];
    [shareView release];
    UILabel *shareLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 7, 60, 30)];
    shareLabel.text = NSLocalizedString(@"share_broadcast", nil);
    shareLabel.font = [UIFont systemFontOfSize:14];
    shareLabel.backgroundColor = [UIColor clearColor];
    [shareView addSubview:shareLabel];
    [shareLabel release];
    NSString *langauage=[MyAppDataManager getPreferredLanguage];
    for(int i=0;i<2;i++){
        UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        button.tag = i;
        button.frame = CGRectMake(70+i*42, 6, 32, 32);
        if([langauage isEqual:@"zh-Hans"]){
            if(i){
                [button setImage:[UIImage imageNamed:@"tencent_bw.png"] forState:UIControlStateNormal];
                [button setImage:[UIImage imageNamed:@"tencent_down.png"] forState:UIControlStateHighlighted];
            }else{
                [button setImage:[UIImage imageNamed:@"sina_bw.png"] forState:UIControlStateNormal];
                [button setImage:[UIImage imageNamed:@"sina_down.png"] forState:UIControlStateHighlighted];

            }
        }else{
            if(i){
                [button setImage:[UIImage imageNamed:@"facebook_bw.png"] forState:UIControlStateNormal];
                [button setImage:[UIImage imageNamed:@"facebook_down.png"] forState:UIControlStateHighlighted];
            }else{
                [button setImage:[UIImage imageNamed:@"twitter_bw.png"] forState:UIControlStateNormal];
                [button setImage:[UIImage imageNamed:@"twitter_down.png"] forState:UIControlStateHighlighted];
                
            }
            
        }
        [button addTarget:self action:@selector(shareAction:) forControlEvents:UIControlEventTouchUpInside];
        [shareView addSubview:button];
        
    }
    
    
    //根据是否绑定了，来控制分享按钮的显示
    if([langauage isEqual:@"zh-Hans"]){
 
        if([[UserDefaults valueForKey:@"QUser"] length]){
            UIButton *tempButton = (UIButton *)[[[self.functionView.subviews objectAtIndex:0] subviews] objectAtIndex:2];
            [self performSelector:@selector(shareAction:) withObject:tempButton];
        } 
        if([[UserDefaults valueForKey:@"sinaUser"] length]){
            UIButton *tempButton = (UIButton *)[[[self.functionView.subviews objectAtIndex:0] subviews] objectAtIndex:1];
            [self performSelector:@selector(shareAction:) withObject:tempButton];
        }
     }else{
        
         if([[UserDefaults valueForKey:@"FBUser"]length]){
             UIButton *tempButton = (UIButton *)[[[self.functionView.subviews objectAtIndex:0] subviews] objectAtIndex:2];
             [self performSelector:@selector(shareAction:) withObject:tempButton];
         }
    
         if([[UserDefaults valueForKey:@"TUser"] length]){
             UIButton *tempButton = (UIButton *)[[[self.functionView.subviews objectAtIndex:0] subviews] objectAtIndex:1];
             [self performSelector:@selector(shareAction:) withObject:tempButton];
         }
 
     }

    
    
    
//    UIButton *textButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//    textButton.frame = CGRectMake(320-120-10, 7, 120, 30);
//    textButton.backgroundColor = [UIColor grayColor];
////    [textButton setTitle:@"我在半步网分享了一张美图，欢迎来看。。。" forState:UIControlStateNormal];
//    textButton.titleLabel.font = [UIFont systemFontOfSize:12];
//    [shareView addSubview:textButton];
//    UILabel *aLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 90, 30)];
//    aLabel.text = @"我在半步网分享了一张美图，欢迎来看。。。";
//    aLabel.backgroundColor = [UIColor clearColor];
//    aLabel.font = [UIFont systemFontOfSize:12];
//    [textButton addSubview:aLabel];
//    [aLabel release];
    
    //标签栏之上
    UILabel *aline = [[UILabel alloc]initWithFrame:CGRectMake(0, -5, 320, 1)];
    aline.backgroundColor = [UIColor colorWithRed:200.0/256 green:200.0/256 blue:200.0/256 alpha:1.0];
    [self.functionView addSubview:aline];
    [aline release];
    
    //标签栏
    UIView *tagView = [[UIView alloc]initWithFrame:CGRectMake(0, 1, 320, 36)];
    tagView.backgroundColor = [UIColor clearColor];
    [self.functionView addSubview:tagView];
    [tagView release];
    UILabel *tagLabel = [[UILabel alloc]initWithFrame:CGRectMake( 10, 5, 55, 30)];
    tagLabel.text = [NSString stringWithFormat:@"%@:",NSLocalizedString(@"tagTextfield",nil)];
    tagLabel.font = [UIFont systemFontOfSize:14];
    tagLabel.backgroundColor = [UIColor clearColor];
    [tagView addSubview:tagLabel];
    [tagLabel release];
    tagTextField = [[UITextField alloc]initWithFrame:CGRectMake(65, 5, 160+85, 30)];
    tagTextField.placeholder = NSLocalizedString(@"tagTextPlaceholder", nil);
    tagTextField.backgroundColor = [UIColor whiteColor];
    tagTextField.textColor = [UIColor blackColor];
    [tagTextField setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    tagTextField.font = [UIFont systemFontOfSize:13];
    
    tagTextField.layer.borderColor = [[UIColor blackColor] CGColor];
    tagTextField.layer.borderWidth = 1.0;
    [tagView addSubview:tagTextField];
    [tagTextField release];
    
    UILabel *paddingView = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 5, 30)];
    paddingView.backgroundColor = [UIColor clearColor];
    tagTextField.leftView = paddingView;
    tagTextField.leftViewMode = UITextFieldViewModeAlways;
    [paddingView release];

    
    //监听键盘高度
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardShowNotify:) name:UIKeyboardWillShowNotification object:nil];

    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//上传图片

-(void)sendPicture{
    
    NSMutableDictionary *sendDic = [NSMutableDictionary dictionaryWithCapacity:1];
    [sendDic setValue:@"jpg" forKey:@"extname"];
    [AppComManager uploadBanBuBroadcastMedia:_imageData mediaName:@"tupian" par:sendDic delegate:self];
    [TKLoadingView showTkloadingAddedTo:self.view title:NSLocalizedString(@"chuliNotice", nil) activityAnimated:YES];
    self.navigationController.view.userInteractionEnabled = NO;
//    [aTextView becomeFirstResponder];

}

//上传语音

-(void)sendSound{
    
    NSMutableDictionary *sendDic = [NSMutableDictionary dictionaryWithCapacity:1];
    [sendDic setValue:@"amr" forKey:@"extname"];
    [AppComManager uploadBanBuBroadcastMedia:_soundData mediaName:@"yuyin" par:sendDic delegate:self];
    [TKLoadingView showTkloadingAddedTo:self.view title:NSLocalizedString(@"chuliNotice", nil) activityAnimated:YES];
    self.navigationController.view.userInteractionEnabled = NO;
//    [aTextView becomeFirstResponder];

}

//将返回的图片、语音字符串进行包装，和文字一起发送出去。
//标签是包在“saytext”里的


- (void) performPublishAction:(void (^)(void)) action {
    // we defer request for permission to post to the moment of post, then we check for the permission
    if ([FBSession.activeSession.permissions indexOfObject:@"publish_actions"] == NSNotFound) {
        // if we don't already have the permission, then we request it now
        [FBSession.activeSession reauthorizeWithPublishPermissions:[NSArray arrayWithObject:@"publish_actions"]
                                                   defaultAudience:FBSessionDefaultAudienceFriends
                                                 completionHandler:^(FBSession *session, NSError *error) {
                                                     if (!error) {
//                                                         [TKLoadingView showTkloadingAddedTo:self.view title:NSLocalizedString(@"sendingNotice", nil) activityAnimated:YES];
                                                         
                                                         action();
                                                     }
                                                     //For this example, ignore errors (such as if user cancels).
                                                 }];
    } else {
//        [TKLoadingView showTkloadingAddedTo:self.view title:NSLocalizedString(@"sendingNotice", nil) activityAnimated:YES];
        
        action();
    }
    
}
 
-(void)sendMessage{
    
    NSString *langauage=[MyAppDataManager getPreferredLanguage];
     UIButton *tempButton1 = (UIButton *)[[[self.functionView.subviews objectAtIndex:0] subviews] objectAtIndex:1];
     UIButton *tempButton2 = (UIButton *)[[[self.functionView.subviews objectAtIndex:0] subviews] objectAtIndex:2];
    if([langauage isEqual:@"zh-Hans"]){
        if(tempButton1.selected){
            WBEngine *_wbEngine = [[WBEngine alloc] initWithAppKey:kWBSDKDemoAppKey appSecret:kWBSDKDemoAppSecret];
            [_wbEngine setDelegate:self];
            [_wbEngine setRootViewController:self];
            [_wbEngine setRedirectURI:@"http://www.halfeet.com"];
            [_wbEngine setIsUserExclusive:NO];
            
            //NSLog(@"%@",_receiveImage);
            [_wbEngine sendWeiBoWithText:@"" image:[[[UIImage alloc]initWithData:_imageData] autorelease]];
        }
        if(tempButton2.selected){
            QWeiboAsyncApi *api = [[[QWeiboAsyncApi alloc] init] autorelease];
            NSString *tokenKey = [user valueForKey:AppTokenKey];
            NSString *tokenSecret = [user valueForKey:AppTokenSecret];
            
            NSString *imagePath = [NSTemporaryDirectory() stringByAppendingFormat:@"releaseImage"];
            UIImage *tempImage = [[[UIImage alloc]initWithData:_imageData] autorelease];
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
                                                     content:@""
                                                   imageFile:sendImageView.image?imagePath:nil
                                                  resultType:RESULTTYPE_JSON
                                                    delegate:self];
            [sendImageView release];
            
        }
    }
    else{
        if(tempButton1.selected){

            FHSTwitterEngine * aEngine = [[[FHSTwitterEngine alloc]initWithConsumerKey:@"2cZXkfmSC6UrPUkhSPtfwQ" andSecret:@"mdoijXeFbK6dGVs5C61rADMOWSgFdNtPOBsxgnKw"]autorelease];
                [aEngine loadAccessToken];
//                [TKLoadingView showTkloadingAddedTo:self.view title:NSLocalizedString(@"sendingNotice", nil) activityAnimated:YES];
           
                dispatch_async(GCDBackgroundThread, ^{
                    @autoreleasepool {
                        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
                        NSError *returnCode = [aEngine postTweet:@"Share a good thing" withImageData:_imageData];
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
                            //                                    UIAlertView *av = [[UIAlertView alloc]initWithTitle:title message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                            //                                    [av show];
//                            [TKLoadingView dismissTkFromView:self.view animated:NO afterShow:0.0];
//                            [TKLoadingView showTkloadingAddedTo:self.view title:title activityAnimated:NO duration:2.0];
                        });
                    }
                });
                
            }
          
 
        if(tempButton2.selected) {
                
            
            BOOL displayedNativeDialog = [FBNativeDialogs presentShareDialogModallyFrom:self
                                                                            initialText:nil
                                                                                  image:[UIImage imageWithData:_imageData]
                                                                                    url:nil
                                                                                handler:nil];
            if (!displayedNativeDialog) {
                [self performPublishAction:^{
                    
                    [FBRequestConnection startForUploadPhoto:[UIImage imageWithData:_imageData]
                                           completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
                                               //                                       [self showAlert:@"Photo Post" result:result error:error];
//                                               [TKLoadingView dismissTkFromView:self.view animated:NO afterShow:0.0];
//                                               [TKLoadingView showTkloadingAddedTo:self.view title:NSLocalizedString(@"shareSuccess", nil) activityAnimated:NO duration:2.0 ];
                                               
                                               
                                           }];
                    
                    
                    
                }];
            }
            
            
        }
 
    }

    NSMutableDictionary *aBroadcastDic = [NSMutableDictionary dictionaryWithCapacity:2];
    NSMutableArray *attachArray = [NSMutableArray arrayWithObject:[NSDictionary dictionaryWithObjectsAndKeys:@"image",@"type",_imageString,@"content", nil]];
    if(_soundString){
        
        [attachArray addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"sound",@"type",_soundString,@"content",_soundTime,@"length", nil]];
    }
    
    
    if([tagTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length){
        NSArray *charArr = [NSArray arrayWithObjects:@".",@"。",@",",@"，",@"?",@"？",@"/",@"、",@"'",@"’",@"\"",@"“",@";",@"；",@"[",@"]",@"!",@"！",@":",@"：",@"(",@")",@"（",@"）",@"$",@"￥",@"&",@"-",@"／", nil];
        for(NSString *tempStr in charArr){
            tagTextField.text = [tagTextField.text stringByReplacingOccurrencesOfString:tempStr withString:@" "];
            
        }
        //        NSLog(@"%@",tagTextField.text);
        NSMutableArray *tagArr = [NSMutableArray arrayWithArray:[tagTextField.text componentsSeparatedByString:@" "]];
        [tagArr removeObject:@""];
        NSLog(@"%@",tagArr);
        
        if(tagArr.count){
            //标签去重
            for(int i=0;i<tagArr.count;i++){
                
                for(int j=i+1;j<tagArr.count;j++){
                    
                    if([[tagArr objectAtIndex:i] isEqualToString:[tagArr objectAtIndex:j]]){
                        
                        [tagArr removeObjectAtIndex:j];
                        
                    }
                }
                
            }
            //        NSLog(@"%@",tagArr);
            
            NSMutableString *joinStr = [NSMutableString stringWithString:[tagArr objectAtIndex:0]];
            for(int i=1;i<tagArr.count;i++){
                [joinStr appendFormat:@" %@",[tagArr objectAtIndex:i]];
            }
            //        NSLog(@"%@",joinStr);
            
            [aBroadcastDic setValue:[MyAppDataManager IsMinGanWord:[NSString stringWithFormat:@"%@<--%@-->",aTextView.text,joinStr]] forKey:@"saytext"];
            
            
        }

        
    }
    else{
        
        [aBroadcastDic setValue:aTextView.text forKey:@"saytext"];

    }
    [aBroadcastDic setValue:attachArray forKey:@"attach"];
    NSDictionary *sendDic = [NSDictionary dictionaryWithObject:aBroadcastDic forKey:@"says"];
    NSLog(@"%@",sendDic);
    [AppComManager getBanBuData:BanBu_Send_Broadcast par:sendDic delegate:self];
    
    [TKLoadingView showTkloadingAddedTo:self.view title:NSLocalizedString(@"sendingNotice", nil) activityAnimated:YES];
    self.navigationController.view.userInteractionEnabled = NO;
//    [aTextView becomeFirstResponder];

}

-(void)sendBroadcast{
    //先上传图片，再传语音，最后发送广播
    if([aTextView isFirstResponder]){
        [aTextView resignFirstResponder];

    }

    if(_soundData || aTextView.text.length){
    
        if(!_imageString){
            [self sendPicture];
            return;
        }
        if(!_soundString && _soundData){
            [self sendSound];
            return;
        }
        //    [self sendMessage];
    }else{
        
        if(!aTextView.text.length){
            
            [TKLoadingView showTkloadingAddedTo:self.view title:NSLocalizedString(@"voiceOrTextNotice", nil) activityAnimated:NO duration:1.0];
        }
        
    }
}

-(void)shareAction:(UIButton *)sender{
 
    NSString *langauage=[MyAppDataManager getPreferredLanguage];
    
    UIAlertView *shareAlert = [[[UIAlertView alloc]initWithTitle:NSLocalizedString(@"weiboUnBing", nil) message:NSLocalizedString(@"bindNow", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"cancelNotice", nil) otherButtonTitles:NSLocalizedString(@"confirmNotice", nil), nil] autorelease];
    
    if([langauage isEqual:@"zh-Hans"]){
        
        if(sender.tag){
            if([[UserDefaults valueForKey:@"QUser"] length]){
                UIButton *tempButton = (UIButton *)[[[self.functionView.subviews objectAtIndex:0] subviews] objectAtIndex:2];
                tempButton.selected = !sender.selected;
                [sender setImage:[UIImage imageNamed:@"tencent.png"] forState:UIControlStateSelected];
            }else{
//                shareAlert.title = @"你还没有绑定腾讯微博";
                [shareAlert show];
            }
        }else{
//            NSLog(@"%d",[[self.functionView.subviews objectAtIndex:0] subviews].count);
            if([[UserDefaults valueForKey:@"sinaUser"] length]){
                UIButton *tempButton = (UIButton *)[[[self.functionView.subviews objectAtIndex:0] subviews] objectAtIndex:1];
                tempButton.selected = !sender.selected;

                [sender setImage:[UIImage imageNamed:@"sina.png"] forState:UIControlStateSelected];

            }else{
//                shareAlert.title = @"你还没有绑定新浪微博";
                [shareAlert show];
            }
        }
    }else{
        
        if(sender.tag){
            if([[UserDefaults valueForKey:@"FBUser"] length]){
                UIButton *tempButton = (UIButton *)[[[self.functionView.subviews objectAtIndex:0] subviews] objectAtIndex:2];
                tempButton.selected = !sender.selected;
                [sender setImage:[UIImage imageNamed:@"facebook.png"] forState:UIControlStateSelected];

            }else{
//                shareAlert.title = @"你还没有绑定FaceBook";
                [shareAlert show];
            }
        }else{
            if([[UserDefaults valueForKey:@"TUser"] length]){
                UIButton *tempButton = (UIButton *)[[[self.functionView.subviews objectAtIndex:0] subviews] objectAtIndex:1];
                tempButton.selected = !sender.selected;
                [sender setImage:[UIImage imageNamed:@"twitter.png"] forState:UIControlStateSelected];

            }else{
//                shareAlert.title = @"你还没有绑定Twitter";
                [shareAlert show];
            }
        }
    }
   
}


-(void)keyboardShowNotify:(NSNotification *)notification{
    
    CGFloat keyboardHeight = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey]CGRectValue].size.height;
//    NSLog(@"%f,%@",keyboardHeight,notification.name);
        CGRect frame = self.functionView.frame;
        frame.origin.y = __MainScreen_Height-44-90-keyboardHeight;
        self.functionView.frame = frame;
    
}

#pragma mark - AlertViewDelegate

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if(buttonIndex == 1){
        
        BanBu_MyProfileViewController *profile = [[BanBu_MyProfileViewController alloc]autorelease];
        profile.tableView.contentOffset = CGPointMake(0, 360);
        [self.navigationController pushViewController:profile animated:YES];
    }
}

#pragma mark - BanBuUploadRequsetDelegate

- (void)banbuUploadRequest:(NSDictionary *)resDic didFinishedWithError:(NSError *)error{
    NSLog(@"%@",resDic);

    self.navigationController.view.userInteractionEnabled = YES;
    [TKLoadingView dismissTkFromView:self.view animated:NO afterShow:0.0];
    if(error){
        [TKLoadingView showTkloadingAddedTo:self.view title:NSLocalizedString(@"uploadFailNotice", nil) activityAnimated:NO duration:2.0];
    }
    if([[resDic valueForKey:@"ok"] boolValue]){
        if([[resDic valueForKey:@"requestname"] isEqualToString:@"tupian"]){
            if(_imageString){
                [_imageString release];
            }
            _imageString = [[NSString alloc]initWithString:[resDic valueForKey:@"fileurl"]];
            if(_soundData){
                [self sendSound];
            }else{
                [self sendMessage];
            }
        }else{
            if(_soundString){
                [_soundString release];
            }
            _soundString = [[NSString alloc]initWithString:[resDic valueForKey:@"fileurl"]];
            [FileManager removeItemAtPath:[AppComManager pathForMedia:@"yuyin.amr"] error:nil];
            [self sendMessage];
            
        }
        

    }
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
    if([AppComManager respondsDic:resDic isFunctionData:BanBu_Send_Broadcast]){
        NSLog(@"%@",resDic);
        if([resDic valueForKey:@"ok"]){
            
            [TKLoadingView showTkloadingAddedTo:self.view title:NSLocalizedString(@"releaseSuccess", nil) activityAnimated:NO duration:1.0];
            [self performSelector:@selector(backLast) withObject:self afterDelay:1.0];
            
        }
    }
   
}

-(void)backLast{
    
    [self.navigationController popToRootViewControllerAnimated:YES];
}





@end
