//
//  BanBu_ChatToseePic.m
//  BanBu
//
//  Created by apple on 13-1-22.
//
//

#import "BanBu_ChatToseePic.h"
#import "AppCommunicationManager.h"
#import "AppDataManager.h"
#import "BanBu_MyProfileViewController.h"
#import "BanBu_GraffitiController.h"
#import "WXOpen.h"
#import "ShareViewController.h"
@interface BanBu_ChatToseePic (private)

-(void)fenxiang;


@end

@implementation BanBu_ChatToseePic

@synthesize shareArr=_shareArr;

-(void)dealloc{
    
    self.shareArr = nil;
    [_assetLibrary release];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"dismissController" object:nil];
    [super dealloc];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    // 这是 右边的
    UIBarButtonItem *sendButton = [[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"ic_topbar_more.png"] style:UIBarButtonItemStylePlain target:self action:@selector(addFun)] autorelease];
    // Set appearance
    if ([UIBarButtonItem respondsToSelector:@selector(addFun)]) {
        [sendButton setBackgroundImage:nil forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
        [sendButton setBackgroundImage:nil forState:UIControlStateNormal barMetrics:UIBarMetricsLandscapePhone];
        [sendButton setBackgroundImage:nil forState:UIControlStateHighlighted barMetrics:UIBarMetricsDefault];
        [sendButton setBackgroundImage:nil forState:UIControlStateHighlighted barMetrics:UIBarMetricsLandscapePhone];
        [sendButton setTitleTextAttributes:[NSDictionary dictionary] forState:UIControlStateNormal];
        [sendButton setTitleTextAttributes:[NSDictionary dictionary] forState:UIControlStateHighlighted];
    }
    self.navigationItem.rightBarButtonItem = sendButton;
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(dismissController) name:@"dismissController" object:nil];

}

-(void)dismissController{
    [self dismissModalViewControllerAnimated:NO];
    
}

-(void)addFun{
    UIActionSheet *function;
    if(_type){
        NSString *langauage=[MyAppDataManager getPreferredLanguage];
        if([langauage isEqual:@"zh-Hans"]){
            function = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:NSLocalizedString(@"cancelNotice", nil) destructiveButtonTitle:nil otherButtonTitles:NSLocalizedString(@"saveToAlum", nil),NSLocalizedString(@"分享到微信、微博", nil),NSLocalizedString(@"分享到QQ空间人人网", nil),NSLocalizedString(@"tuyaReply", nil), nil];

        }else{
            function = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:NSLocalizedString(@"cancelNotice", nil) destructiveButtonTitle:nil otherButtonTitles:NSLocalizedString(@"saveToAlum", nil),@"Twitter",@"Facebook",NSLocalizedString(@"tuyaReply", nil), nil];

        }

    }else{
        
        NSString *langauage=[MyAppDataManager getPreferredLanguage];
        if([langauage isEqual:@"zh-Hans"]){
            function = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:NSLocalizedString(@"cancelNotice", nil) destructiveButtonTitle:nil otherButtonTitles:NSLocalizedString(@"saveToAlum", nil),NSLocalizedString(@"分享到微信、微博", nil),NSLocalizedString(@"分享到QQ空间人人网", nil),NSLocalizedString(@"tuyaEdit", nil), nil];
            
        }else{
            function = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:NSLocalizedString(@"cancelNotice", nil) destructiveButtonTitle:nil otherButtonTitles:NSLocalizedString(@"saveToAlum", nil),@"Twitter",@"Facebook",NSLocalizedString(@"tuyaEdit", nil), nil];

        }

    }
    function.tag = 1;
    [function showInView:self.view];
    [function release];
    
}

#pragma mark - UIActionSheetDelegate

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    NSLog(@"%d",buttonIndex);
    if(actionSheet.tag == 1){
        if(buttonIndex == 0){
            if(!_assetLibrary){
                _assetLibrary = [[ALAssetsLibrary alloc]init];
            }
            [_assetLibrary saveImage:[self.shareArr objectAtIndex:0] toAlbum:NSLocalizedString(@"fristTitle", nil) completionBlock:^(NSURL *assetURL, NSError *error) {
                
                [TKLoadingView showTkloadingAddedTo:self.navigationController.view title:NSLocalizedString(@"savesucess", nil) activityAnimated:NO duration:2.0];
                
            } failureBlock:^(NSError *error) {
                
                [TKLoadingView showTkloadingAddedTo:self.navigationController.view title:NSLocalizedString(@"savefail", nil) activityAnimated:NO duration:2.0];
            }];
        }
        else if(buttonIndex == 1){
            NSString *langauage=[MyAppDataManager getPreferredLanguage];
            
            if([langauage isEqual:@"zh-Hans"]){
                UIActionSheet *fenxiang=[[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:NSLocalizedString(@"cancelNotice", nil) destructiveButtonTitle:nil otherButtonTitles:@"分享给微信好友",@"分享到微信好友圈",@"分享到新浪微博",@"分享到腾讯微博", nil];
                fenxiang.tag = 2;
                [fenxiang showInView:self.view];
                [fenxiang release];
            }
            else{
    
                if([[UserDefaults valueForKey:@"TUser"] length]){
                    FHSTwitterEngine * aEngine = [[[FHSTwitterEngine alloc]initWithConsumerKey:@"2cZXkfmSC6UrPUkhSPtfwQ" andSecret:@"mdoijXeFbK6dGVs5C61rADMOWSgFdNtPOBsxgnKw"]autorelease];
                    [aEngine loadAccessToken];
                    [TKLoadingView showTkloadingAddedTo:self.view title:NSLocalizedString(@"sendingNotice", nil) activityAnimated:YES];
                    
                    dispatch_async(GCDBackgroundThread, ^{
                        @autoreleasepool {
                            [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
                            NSError *returnCode = [aEngine postTweet:@"Share a good thing" withImageData:UIImageJPEGRepresentation([self.shareArr objectAtIndex:0], 1.0)];
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
                    
                    
                }else{
                    
                    BanBu_MyProfileViewController *profile = [[BanBu_MyProfileViewController alloc]autorelease];
                    profile.tableView.contentOffset = CGPointMake(0, 360);
                    [self.navigationController pushViewController:profile animated:YES];
                }
                
            }
           
        }
        else if(buttonIndex == 2){
//            NSLog(@"%@",[self.shareArr objectAtIndex:1]);
            
            NSString *langauage=[MyAppDataManager getPreferredLanguage];
            if([langauage isEqual:@"zh-Hans"]){
                ShareViewController *share = [[ShareViewController alloc] initWithURLString:[self.shareArr objectAtIndex:1]];
                [self.navigationController pushViewController:share animated:YES];
            }else{
                
                {
                    if([[UserDefaults valueForKey:@"FBUser"] length]){
                        
                        
                        BOOL displayedNativeDialog = [FBNativeDialogs presentShareDialogModallyFrom:self
                                                                                        initialText:nil
                                                                                              image:[self.shareArr objectAtIndex:0]
                                                                                                url:nil
                                                                                            handler:nil];
                        
                        if (!displayedNativeDialog) {
                            
                            [self performPublishAction:^{
                                
                                
                                [FBRequestConnection startForUploadPhoto:[self.shareArr objectAtIndex:0]
                                                       completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
                                                           //                                       [self showAlert:@"Photo Post" result:result error:error];
                                                           [TKLoadingView dismissTkFromView:self.view animated:NO afterShow:0.0];
                                                           [TKLoadingView showTkloadingAddedTo:self.view title:NSLocalizedString(@"shareSuccess", nil) activityAnimated:NO duration:2.0 ];
                                                           
                                                           
                                                       }];
                                
                                
                                
                            }];
                            
                        }
                        
                        
                        
                        
                    }else{
                        BanBu_MyProfileViewController *profile = [[BanBu_MyProfileViewController alloc]autorelease];
                        profile.tableView.contentOffset = CGPointMake(0, 360);
                        [self.navigationController pushViewController:profile animated:YES];
                    }
                }

            }
            
            
        }
        else if(buttonIndex == 3){
            BanBu_GraffitiController *aGraff=[[BanBu_GraffitiController alloc]initwithImage:[self.shareArr objectAtIndex:0] andSourceType:_type];
            [self presentModalViewController:aGraff animated:YES];
            [aGraff release];
        }
 
    }
    else if(actionSheet.tag == 2){
        NSString *langauage=[MyAppDataManager getPreferredLanguage];
   
        if([langauage isEqual:@"zh-Hans"]){
            NSData *aData = [NSData dataWithData:UIImageJPEGRepresentation([self.shareArr objectAtIndex:0], 1.0)];
            NSLog(@"%d",aData.length);
            for(float i= 100;i>0;i -= 10){
                if(aData.length>32000){
                    aData = UIImageJPEGRepresentation([self.shareArr objectAtIndex:0],i/100);
                    NSLog(@"%f--%d",i,aData.length);

                }else{
                    break;
                }
            }
      
            
            NSLog(@"%d",aData.length);
            
            if(buttonIndex == 0){
                MyWXOpen.scene = WXSceneSession;
                if(self.shareArr.count>1){
                    if([[self.shareArr lastObject] hasSuffix:@"gif"]){
                        [MyWXOpen sendGifContentWithImageData:[MyAppDataManager imageDataForImageUrlStr:[self.shareArr lastObject]] andThumbImage:[[[UIImage alloc] initWithData:aData] autorelease]];
                    }else{
                        [MyWXOpen sendImageContentWithImageData:UIImageJPEGRepresentation([self.shareArr objectAtIndex:0], 1.0) andThumbData:aData];
                        
                    }
 
                }
                else{
                    [MyWXOpen sendImageContentWithImageData:UIImageJPEGRepresentation([self.shareArr objectAtIndex:0], 1.0) andThumbData:aData];

                }
            }
            else if(buttonIndex == 1){
                
                [MyWXOpen sendImageContentWithImageData:UIImageJPEGRepresentation([self.shareArr objectAtIndex:0], 1.0) andThumbData:aData];
                
            }
            else if(buttonIndex == 2){
                
                if([[UserDefaults valueForKey:@"sinaUser"] length]){
                    WBEngine *_wbEngine = [[WBEngine alloc] initWithAppKey:kWBSDKDemoAppKey appSecret:kWBSDKDemoAppSecret];
                    [_wbEngine setDelegate:self];
                    [_wbEngine setRootViewController:self];
                    [_wbEngine setRedirectURI:@"http://www.halfeet.com"];
                    [_wbEngine setIsUserExclusive:NO];
                    
                    //NSLog(@"%@",_receiveImage);
                    [_wbEngine sendWeiBoWithText:@"分享个好东西" image: [self.shareArr objectAtIndex:0]];
                    [TKLoadingView showTkloadingAddedTo:self.view title:NSLocalizedString(@"sendingNotice", nil) activityAnimated:YES];
                    
                    
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
                    UIImage *tempImage = [self.shareArr objectAtIndex:0];
                    NSLog(@"%@-----%@",tempImage,[self.shareArr objectAtIndex:0]);
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
                                                             content:@"分享个好东西"
                                                           imageFile:sendImageView.image?imagePath:nil
                                                          resultType:RESULTTYPE_JSON
                                                            delegate:self];
                    [sendImageView release];
                    [TKLoadingView showTkloadingAddedTo:self.view title:NSLocalizedString(@"sendingNotice", nil) activityAnimated:YES];
                    
                    
                    
                }else{
                    
                    BanBu_MyProfileViewController *profile = [[BanBu_MyProfileViewController alloc]autorelease];
                    profile.tableView.contentOffset = CGPointMake(0, 360);
                    [self.navigationController pushViewController:profile animated:YES];
                    
                }
            }

        }
        else{
            if(buttonIndex == 0){
                if([[UserDefaults valueForKey:@"TUser"] length]){
                    FHSTwitterEngine * aEngine = [[[FHSTwitterEngine alloc]initWithConsumerKey:@"2cZXkfmSC6UrPUkhSPtfwQ" andSecret:@"mdoijXeFbK6dGVs5C61rADMOWSgFdNtPOBsxgnKw"]autorelease];
                    [aEngine loadAccessToken];
                    [TKLoadingView showTkloadingAddedTo:self.view title:NSLocalizedString(@"sendingNotice", nil) activityAnimated:YES];
                    
                    dispatch_async(GCDBackgroundThread, ^{
                        @autoreleasepool {
                            [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
                            NSError *returnCode = [aEngine postTweet:@"Share a good thing" withImageData:UIImageJPEGRepresentation([self.shareArr objectAtIndex:0], 1.0)];
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
                    
                    
                }else{
                    
                    BanBu_MyProfileViewController *profile = [[BanBu_MyProfileViewController alloc]autorelease];
                    profile.tableView.contentOffset = CGPointMake(0, 360);
                    [self.navigationController pushViewController:profile animated:YES];
                }
            }
            else if(buttonIndex == 1){
                if([[UserDefaults valueForKey:@"FBUser"] length]){
                    
                    
                    BOOL displayedNativeDialog = [FBNativeDialogs presentShareDialogModallyFrom:self
                                                                                    initialText:nil
                                                                                          image:[self.shareArr objectAtIndex:0]
                                                                                            url:nil
                                                                                        handler:nil];
                    
                    if (!displayedNativeDialog) {
                        
                        [self performPublishAction:^{
                            
                            
                            [FBRequestConnection startForUploadPhoto:[self.shareArr objectAtIndex:0]
                                                   completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
                                                       //                                       [self showAlert:@"Photo Post" result:result error:error];
                                                       [TKLoadingView dismissTkFromView:self.view animated:NO afterShow:0.0];
                                                       [TKLoadingView showTkloadingAddedTo:self.view title:NSLocalizedString(@"shareSuccess", nil) activityAnimated:NO duration:2.0 ];
                                                       
                                                       
                                                   }];
                            
                            
                            
                        }];
                        
                    }
                    
                    
                    
                    
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
 
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
