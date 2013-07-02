
//
//  BanBu_LoginViewController.m
//  BanBu
//
//  Created by jie zheng on 12-7-5.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "BanBu_LoginViewController.h"
#import "BanBu_ForgetPWController.h"
#import "TKLoadingView.h"
#import "AppCommunicationManager.h"
#import "BanBu_LocationManager.h"
#import "BanBu_AppDelegate.h"
#import "AppDataManager.h"
#import "BanBu_MyProfileViewController.h"
#import "BanBu_RegViewController.h"
#import "QVerifyWebViewController.h"
#import "WBEngine.h"
#import "UIDevice+Helper.h"

@interface BanBu_LoginViewController ()

@end

@implementation BanBu_LoginViewController

- (id)init
{
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:SCSessionStateChangedNotification object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"Twitter" object:nil];

    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.title = NSLocalizedString(@"loginTitle", nil);
    self.tableView.backgroundView = nil;
    self.tableView.backgroundColor = [UIColor colorWithRed:255.0/255 green:250.0/255 blue:240.0/255 alpha:1.0];
    UIButton *completeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [completeButton addTarget:self action:@selector(login:) forControlEvents:UIControlEventTouchUpInside];
    [completeButton setBackgroundImage:[[UIImage imageNamed:@"app_nav_btn_bg1.png"] stretchableImageWithLeftCapWidth:15.0 topCapHeight:15.0] forState:UIControlStateNormal];
    [completeButton setBackgroundImage:[[UIImage imageNamed:@"app_nav_btn_bg2.png"] stretchableImageWithLeftCapWidth:15.0 topCapHeight:15.0] forState:UIControlStateHighlighted];
    CGFloat btnLen = [NSLocalizedString(@"logButton", nil) sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(100, 30)].width;

    completeButton.frame=CGRectMake(0, 0, btnLen+20, 30);
    [completeButton setTitleEdgeInsets:UIEdgeInsetsMake(3, 2, 2, 2)];
    [completeButton setTitle:NSLocalizedString(@"logButton", nil) forState:UIControlStateNormal];
    completeButton.titleLabel.font = [UIFont systemFontOfSize:14];
    UIBarButtonItem *complete = [[[UIBarButtonItem alloc] initWithCustomView:completeButton] autorelease];
    self.navigationItem.rightBarButtonItem = complete;
    
    
    
    
   
    
    
    NSString *langauage=[MyAppDataManager getPreferredLanguage];
    if(![langauage isEqual:@"zh-Hans"]){
//        self.tableView.tableFooterView.hidden = NO;
        [self showThirdLogin];

        _rows = 0;
    }else{
//        self.tableView.tableFooterView.hidden = YES;

        _rows = 2;
    }
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(sessionStateChanged:) name:SCSessionStateChangedNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(checkTwitterGO:) name:@"Twitter" object:nil];

    //twitter
    FHSTwitterEngine * aEngine = [[FHSTwitterEngine alloc]initWithConsumerKey:@"2cZXkfmSC6UrPUkhSPtfwQ" andSecret:@"mdoijXeFbK6dGVs5C61rADMOWSgFdNtPOBsxgnKw"];
    self.twitterEngine = aEngine;


}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    [self.twitterEngine loadAccessToken];
    _twitterLoginID = self.twitterEngine.loggedInID;
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [AppComManager cancalHandlesForObject:self];
    [TKLoadingView dismissTkFromView:self.navigationController.view animated:NO afterShow:0.0];
    
}

-(void)showLoginField{
//    self.tableView.tableFooterView.hidden = YES;
    
    
    UIView *aView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 40)];
    aView.backgroundColor = [UIColor clearColor];
    self.tableView.tableFooterView = aView;
    
    UIButton *halfeetLoginButton = [UIButton buttonWithType:UIButtonTypeCustom];
    halfeetLoginButton.backgroundColor = [UIColor clearColor];
    halfeetLoginButton.frame = CGRectMake(15+290-145, 10, 145, 30);
    [halfeetLoginButton setTitle:@"FaceBook/Twitter" forState:UIControlStateNormal];
    [halfeetLoginButton addTarget:self action:@selector(showThirdLogin) forControlEvents:UIControlEventTouchUpInside];
    [halfeetLoginButton  setTitleColor:[UIColor colorWithRed:50.0/255 green:79.0/255 blue:133.0/255 alpha:1.0] forState:UIControlStateNormal];
    [aView addSubview:halfeetLoginButton];
    
    
    _rows = 2;
    [self.tableView reloadData];

}

-(void)showThirdLogin{
    UIView *aView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 160)];
    aView.backgroundColor = [UIColor clearColor];
    self.tableView.tableFooterView = aView;
    
    UIButton *aButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    aButton.frame = CGRectMake(15, 0, 290, 40);
    [aButton setBackgroundImage:[UIImage imageNamed:@"facebookloginicon.png"] forState:UIControlStateNormal];
    [aButton setTitle:@"Sign in with FaceBook" forState:UIControlStateNormal];
    [aButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [aButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    
    [aButton addTarget:self action:@selector(goToFB) forControlEvents:UIControlEventTouchUpInside];
    [aView addSubview:aButton];
    
    UIButton *bButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    bButton.frame = CGRectMake(15, 60, 290, 40);
    [bButton setBackgroundImage:[UIImage imageNamed:@"twitterloginicon.png"] forState:UIControlStateNormal];
    [bButton setTitle:@"Sign in with Twitter" forState:UIControlStateNormal];
    [bButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [bButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [bButton addTarget:self action:@selector(goToTwitter) forControlEvents:UIControlEventTouchUpInside];
    [aView addSubview:bButton];
    
    UIButton *halfeetLoginButton = [UIButton buttonWithType:UIButtonTypeCustom];
    halfeetLoginButton.backgroundColor = [UIColor clearColor];
     halfeetLoginButton.titleLabel.font = [UIFont systemFontOfSize:18];
    
    NSString *langauage=[[MyAppDataManager getPreferredLanguage]substringToIndex:2];
    if([langauage isEqual:@"ja"]){

        [halfeetLoginButton setTitle:@"アカウントを持っている" forState:UIControlStateNormal];

    }else if([langauage isEqual:@"en"]){
        
        [halfeetLoginButton setTitle:@"I have a account" forState:UIControlStateNormal];

    }
    CGFloat len = [halfeetLoginButton.titleLabel.text sizeWithFont:[UIFont systemFontOfSize:18]].width;
    halfeetLoginButton.frame = CGRectMake(15+290-len, 100+20, len, 30);

    
    
    [halfeetLoginButton addTarget:self action:@selector(showLoginField) forControlEvents:UIControlEventTouchUpInside];
    [halfeetLoginButton  setTitleColor:[UIColor colorWithRed:50.0/255 green:79.0/255 blue:133.0/255 alpha:1.0] forState:UIControlStateNormal];
    
    
    [aView addSubview:halfeetLoginButton];
    
    
    
    
    _rows = 0;
    [self.tableView reloadData];
}

-(void)populateUserDetails:(FBSession *)session{

    if([FBSession activeSession].isOpen){
        [TKLoadingView showTkloadingAddedTo:self.navigationController.view title:NSLocalizedString(@"loadingNotice", nil) activityAnimated:YES];
//        self.navigationController.view.userInteractionEnabled = NO;
        [[FBRequest requestForMe] startWithCompletionHandler:^(FBRequestConnection *connectin, NSDictionary<FBGraphUser> *myuser, NSError *error){
            NSLog(@"%@",[error description]);

            if(!error){

                NSLog(@"%@%@,%@,%@,%@",myuser.id,myuser.first_name,[myuser objectForKey:@"email"],myuser.birthday,[myuser objectForKey:@"gender"]);
                [UserDefaults setValue:[session accessToken] forKey:@"FBUser"];
                [MyAppDataManager.regDic setValue:myuser.first_name forKey:@"pname"];
                [MyAppDataManager.regDic setValue:[myuser objectForKey:@"email"] forKey:@"email"];
                [MyAppDataManager.regDic setValue:[[myuser objectForKey:@"gender"] substringToIndex:1] forKey:@"gender"];
                NSArray *birthArr = [myuser.birthday componentsSeparatedByString:@"/"];
                NSString *birthStr = [NSString stringWithFormat:@"%@-%@-%@",[birthArr objectAtIndex:2],[birthArr objectAtIndex:1],[birthArr objectAtIndex:0]];
                NSLog(@"%@",birthStr);
                [MyAppDataManager.regDic setValue:birthStr forKey:@"borndate"];
                [MyAppDataManager.regDic setValue:@"b" forKey:@"regby"];
                
                NSMutableDictionary *loginDic = [NSMutableDictionary dictionary];
                [loginDic setValue:[myuser objectForKey:@"email"] forKey:@"email"];
                [loginDic setValue:[NSString stringWithFormat:@"%.f",AppLocationManager.curLocation.latitude*1000000] forKey:@"plat"];
                [loginDic setValue:[NSString stringWithFormat:@"%.f",AppLocationManager.curLocation.longitude*1000000] forKey:@"plong"];
                
//                BanBu_AppDelegate *delegate = (BanBu_AppDelegate *)[UIApplication sharedApplication].delegate;
//                //    NSLog(@"%@",delegate.pushid);
//                [loginDic setValue:delegate.pushid forKey:@"pushid"];
                [loginDic setValue:[UserDefaults valueForKey:@"pushid"] forKey:@"pushid"];
                
                
                
                
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
                
                //判读是什么绑定的
                _bindType = 1;
                
                [AppComManager getBanBuData:BanBu_Check_Login_Bind par:loginDic delegate:self];
                [TKLoadingView showTkloadingAddedTo:self.navigationController.view title:NSLocalizedString(@"chuliNotice", nil) activityAnimated:YES];

               
//                [TKLoadingView dismissTkFromView:self.view animated:NO afterShow:0.0];
//                self.navigationController.view.userInteractionEnabled = YES;

//                [[FBSession activeSession]closeAndClearTokenInformation];

             
            }
            else{
                [TKLoadingView dismissTkFromView:self.navigationController.view animated:NO afterShow:0.0];
                self.navigationController.view.userInteractionEnabled = YES;
            }
        }];

    }
}

- (void)sessionStateChanged:(NSNotification*)notification {
    // A more complex app might check the state to see what the appropriate course of
    // action is, but our needs are simple, so just make sure our idea of the session is
    // up to date and repopulate the user's name and picture (which will fail if the session
    // has become invalid).
    [self performSelector:@selector(populateUserDetails:) withObject:(FBSession *)[notification object]];
//    FBSession *aS = [notification object];
    
}

-(void)goToFB{
    
    [MyAppDelegate openSessionWithAllowLoginUI:YES];
    
}

-(void)checkTwitterGO:(NSNotification *)noti{
    
    [MyAppDataManager.regDic setValue:[UserDefaults valueForKey:@"TUser"] forKey:@"pname"];
    [MyAppDataManager.regDic setValue:[NSString stringWithFormat:@"%@@twitter.com",[noti object]] forKey:@"email"];
    
    [MyAppDataManager.regDic setValue:@"b" forKey:@"regby"];
    
    NSMutableDictionary *loginDic = [NSMutableDictionary dictionary];
    [loginDic setValue:[MyAppDataManager.regDic objectForKey:@"email"] forKey:@"email"];
    [loginDic setValue:[NSString stringWithFormat:@"%.f",AppLocationManager.curLocation.latitude*1000000] forKey:@"plat"];
    [loginDic setValue:[NSString stringWithFormat:@"%.f",AppLocationManager.curLocation.longitude*1000000] forKey:@"plong"];
    //获取手机信息
    
    NSString * stringPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString * documentFile = [stringPath stringByAppendingPathComponent:@"one"];
    if (![[NSFileManager defaultManager] fileExistsAtPath:documentFile]){
        NSString *isJailbroken = nil;
        if([[UIDevice currentDevice] isJailbroken]){
            isJailbroken = @"YES";
        }else{
            isJailbroken = @"NO";
        }
        [loginDic setValue:[NSString stringWithFormat:@"%@::%@::%@::%@::%@",[[UIDevice currentDevice] systemName],[[UIDevice currentDevice] systemVersion],[MyAppDataManager getPreferredLanguage],[[UIDevice currentDevice] platformString],isJailbroken] forKey:@"sysparam"];
    }
    
//    BanBu_AppDelegate *delegate = (BanBu_AppDelegate *)[UIApplication sharedApplication].delegate;
// //   NSLog(@"%@",delegate.pushid);
//    [loginDic setValue:delegate.pushid forKey:@"pushid"];
    [loginDic setValue:[UserDefaults valueForKey:@"pushid"] forKey:@"pushid"];

    
    
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
    
    //判读是什么绑定的
    _bindType = 2;
    [AppComManager getBanBuData:BanBu_Check_Login_Bind par:loginDic delegate:self];
    [TKLoadingView showTkloadingAddedTo:self.navigationController.view title:NSLocalizedString(@"chuliNotice", nil) activityAnimated:YES];
 
}

-(void)goToTwitter{
    
    [self presentModalViewController:[self.twitterEngine OAuthLoginWindow] animated:YES];
   
}

/*//用户登录校验
 网址　http://www.halfeet.com/_user_login/_check_user_login.php?jsonfrom=
 参数　{"fc":"check_user_login","email":"abcd123456@gmail.com","pass":"123456","plong":"118113314","plat":"40019923"}
 返回　{"fc":"check_user_login","logok":"y","loginid":"20120707212149-3E4227CB-2D3E-A6D5-A656-BA755B231D71","serveron":"127.0.0.1"}
 
 email值为用户邮箱，pass值为用户密码
 long值为经度, lat值为纬度
 logok值为y表示登录成功，值为n表示登录失败
 loginid值为登录ID，供后期调用时向服务器端提交此值
 serveron值为分配的服务器，部分接口功能需发送请求到该返回值指定的服务器*/

- (void)login:(UIButton *)button
{
    if(!_userName.text.length)
    {
        [TKLoadingView showTkloadingAddedTo:self.view title:NSLocalizedString(@"userNameNil", nil) activityAnimated:NO duration:2.0];
        return;
    }
    if(_userpw.text.length<6)
    {
        [TKLoadingView showTkloadingAddedTo:self.view title:NSLocalizedString(@"passWordError", nil) activityAnimated:NO duration:2.0];
        return;
    }
    
    NSMutableDictionary *loginDic = [NSMutableDictionary dictionary];
    [loginDic setValue:_userName.text forKey:@"email"];
    [loginDic setValue:_userpw.text forKey:@"pass"];
    [loginDic setValue:[NSString stringWithFormat:@"%.f",AppLocationManager.curLocation.latitude*1000000] forKey:@"plat"];
    [loginDic setValue:[NSString stringWithFormat:@"%.f",AppLocationManager.curLocation.longitude*1000000] forKey:@"plong"];
//    BanBu_AppDelegate *delegate = (BanBu_AppDelegate *)[UIApplication sharedApplication].delegate;
//    NSLog(@"%@",[UserDefaults valueForKey:@"pushid"]);
    [loginDic setValue:[UserDefaults valueForKey:@"pushid"] forKey:@"pushid"];
    
    
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
    [TKLoadingView showTkloadingAddedTo:self.navigationController.view title:NSLocalizedString(@"loading", nil) activityAnimated:YES];
    
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Twitter
- (void)storeAccessToken:(NSString *)accessToken {
    [[NSUserDefaults standardUserDefaults]setObject:accessToken forKey:@"SavedAccessHTTPBody"];
}

- (NSString *)loadAccessToken {
    return [[NSUserDefaults standardUserDefaults]objectForKey:@"SavedAccessHTTPBody"];
}

#pragma mark - Table view data source

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    if(!section)
        return _rows;
    else 
        return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell == nil)
    {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        
    }
    
    if(!indexPath.section)
    {
        UITextField *textField = (UITextField *)[cell viewWithTag:111];
        if(!textField){
             textField = [[UITextField alloc] initWithFrame:CGRectMake(110, 13, 200, 25)];
            textField.delegate = self;
            textField.tag = 111;
            textField.backgroundColor = [UIColor clearColor];
            textField.borderStyle = UITextBorderStyleNone;
            textField.textColor = [UIColor colorWithRed:50.0/255 green:79.0/255 blue:133.0/255 alpha:1.0];
            textField.font = [UIFont systemFontOfSize:15];

            textField.clearButtonMode = UITextFieldViewModeWhileEditing;
            textField.keyboardType = UIKeyboardTypeASCIICapable;
            [cell addSubview:textField];
            [textField release];
            if(!indexPath.row)
            {
                cell.textLabel.text = NSLocalizedString(@"userNameLabel", nil);
                _userName = textField;
                _userName.keyboardType = UIKeyboardTypeEmailAddress;
                _userName.placeholder = NSLocalizedString(@"userPlabeholder", nil);
                _userName.returnKeyType = UIReturnKeyDone;
                [_userName becomeFirstResponder];
                if([UserDefaults valueForKey:@"myID"]){
                    _userName.text = [UserDefaults valueForKey:@"myID"];

                }
            }
            else
            {
                
                cell.textLabel.text =NSLocalizedString(@"passwordLabel", nil);
                _userpw = textField;
                textField.placeholder =NSLocalizedString(@"pwPlaceholder", nil);
                textField.returnKeyType = UIReturnKeyGo;
                textField.secureTextEntry = YES;
                
//                textField.text = @"123456";
            }
        }
    }
    else 
    {
//        cell.textLabel.text = @"忘记密码?";
//        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

    }
    
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%d",indexPath.row);
 
    if(!indexPath.section)
        [tableView deselectRowAtIndexPath:indexPath animated:NO];
    else 
    {
        BanBu_ForgetPWController *forgetPW = [[BanBu_ForgetPWController alloc] init];
        [self.navigationController pushViewController:forgetPW animated:YES];
        [forgetPW release];
    }
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [super touchesBegan:touches withEvent:event];
    if([_userName isFirstResponder]){
        [_userName resignFirstResponder];
    }
    if([_userpw isFirstResponder]){
        [_userpw isFirstResponder];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if(textField.returnKeyType == UIReturnKeyGo)
    {
        [self performSelector:@selector(login:)];
    }
    return YES;
}


- (void)banbuRequestDidFinished:(NSDictionary *)resDic error:(NSError *)error
{
   
//    NSLog(@"%@",resDic);
    self.navigationController.view.userInteractionEnabled = YES;
    [TKLoadingView dismissTkFromView:self.navigationController.view animated:YES afterShow:0.0];
    if(error)
    {
         if([error.domain isEqualToString:BanBuDataformatError])
        {
            [TKLoadingView showTkloadingAddedTo:self.navigationController.view title:NSLocalizedString(@"data_error", nil) activityAnimated:NO duration:2.0];
        }
        else
        {
            [TKLoadingView showTkloadingAddedTo:self.navigationController.view title:NSLocalizedString(@"network_error", nil) activityAnimated:NO duration:2.0];
        }
        
        return;
    }
    
    if([AppComManager respondsDic:resDic isFunctionData:BanBu_Check_Login])
    {
        [UserDefaults setValue:@"" forKey:@"QUser"];
        [UserDefaults setValue:@"" forKey:@"sinaUser"];
        [UserDefaults setValue:@"" forKey:@"FBUser"];
        [UserDefaults setValue:@"" forKey:@"TUser"];

//NSLog(@"%@",resDic);
        if([[resDic valueForKey:@"ok"] boolValue])
        {
            if(![[resDic objectForKey:@"bindlist"] isEqual:@""]){
                //绑定信息
                NSString *bindString;
                NSArray *bindArray;
                
                for(int i=0;i<[[resDic objectForKey:@"bindlist"] count];i++){
                    NSDictionary *bindDic= [[resDic objectForKey:@"bindlist"] objectAtIndex:i];
                    bindString = [bindDic objectForKey:@"bindstring"];
                    bindArray= [bindString componentsSeparatedByString:@","];
                    
                    if([[bindDic objectForKey:@"bindto"]isEqualToString:@"ten_weib"] && ![bindString isEqualToString:@""]){
                        
                        [UserDefaults setValue:[bindArray objectAtIndex:0] forKey:AppTokenKey];
                        [UserDefaults setValue:[bindArray objectAtIndex:1] forKey:AppTokenSecret];
                        [UserDefaults setValue:[bindArray objectAtIndex:2] forKey:@"QUser"];
                        
                    }
                    
                    if([[bindDic objectForKey:@"bindto"]isEqualToString:@"sina_wei"]&& ![bindString isEqualToString:@""]){
                        
                        
                        [UserDefaults setValue:[bindArray objectAtIndex:0] forKey:kWBAccessToken];
                        [UserDefaults setValue:[bindArray objectAtIndex:1] forKey:@"sinaUser"];
                        
                    }
                    if([[bindDic objectForKey:@"bindto"]isEqualToString:@"facebook"]&& ![bindString isEqualToString:@""]){
                        
                        
                        [UserDefaults setValue:[bindArray objectAtIndex:0] forKey:@"FBAccessToken"];
                        [UserDefaults setValue:[bindArray objectAtIndex:1] forKey:@"FBUser"];
                        

                    }
                    if([[bindDic objectForKey:@"bindto"]isEqualToString:@"twitter"]&& ![bindString isEqualToString:@""]){
                        
                         [UserDefaults setValue:[bindArray objectAtIndex:0] forKey:@"TAccessToken"];
                        [UserDefaults setValue:[bindArray objectAtIndex:1] forKey:@"TAccessTokenSecret"];

                        [UserDefaults setValue:[bindArray objectAtIndex:2] forKey:@"TUser"];
                        
                        
                    }
                }
 
            }
            
           
            MyAppDataManager.loginid = [resDic valueForKey:@"loginid"];
            MyAppDataManager.useruid = [resDic valueForKey:@"userid"];
            MyAppDataManager.userAvatar =[resDic valueForKey:@"uface"];
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
//            NSLog(@"%@----%@",[resDic valueForKey:@"userid"],MyAppDataManager.useruid);
            [UserDefaults setValue:MyAppDataManager.useruid forKey:@"myID"];
//            NSLog(@"%@--@", [UserDefaults valueForKey:@"myID"]);

            [UserDefaults synchronize];
//            [UserDefaults setValue:[resDic valueForKey:@"friendlist"] forKey:FriendShip];
            //是否多余
//            [UserDefaults setValue:[BanBu_MyProfileViewController buildMyProfile:resDic] forKey:MyProfile];
////            [BanBu_MyProfileViewController buildMyProfile:resDic];
//            [UserDefaults synchronize];
            BanBu_AppDelegate *delegate = (BanBu_AppDelegate *)[UIApplication sharedApplication].delegate;
            delegate.logined = YES;
            [delegate setViewController:YES];
            
        }
        else
        {
            
            [TKLoadingView showTkloadingAddedTo:self.navigationController.view title:NSLocalizedString(@"userNameOrpassWordError", nil) activityAnimated:NO duration:2.0];
            [TKLoadingView showTkloadingAddedTo:self.navigationController.view title:[MyAppDataManager IsInternationalLanguage:[resDic valueForKey:@"error"]] activityAnimated:NO duration:2.0];

        }
    }
 
    else if([AppComManager respondsDic:resDic isFunctionData:BanBu_Check_Login_Bind]){
//        [UserDefaults setValue:@"" forKey:@"QUser"];
//        [UserDefaults setValue:@"" forKey:@"sinaUser"];
//        [UserDefaults setValue:@"" forKey:@"FBUser"];
//        [UserDefaults setValue:@"" forKey:@"TUser"];
        if([[resDic valueForKey:@"ok"] boolValue])
        {
            
            /*
            if(![[resDic objectForKey:@"bindlist"] isEqual:@""]){
                //绑定信息
                NSString *bindString;
                NSArray *bindArray;
                
                for(int i=0;i<[[resDic objectForKey:@"bindlist"] count];i++){
                    NSDictionary *bindDic= [[resDic objectForKey:@"bindlist"] objectAtIndex:i];
                    bindString = [bindDic objectForKey:@"bindstring"];
                    bindArray= [bindString componentsSeparatedByString:@","];
                    
                    if([[bindDic objectForKey:@"bindto"]isEqualToString:@"ten_weib"] && ![bindString isEqualToString:@""]){
                        
                        [UserDefaults setValue:[bindArray objectAtIndex:0] forKey:AppTokenKey];
                        [UserDefaults setValue:[bindArray objectAtIndex:1] forKey:AppTokenSecret];
                        [UserDefaults setValue:[bindArray objectAtIndex:2] forKey:@"QUser"];
                        
                    }
                    
                    if([[bindDic objectForKey:@"bindto"]isEqualToString:@"sina_wei"]&& ![bindString isEqualToString:@""]){
                        
                        
                        [UserDefaults setValue:[bindArray objectAtIndex:0] forKey:kWBAccessToken];
                        [UserDefaults setValue:[bindArray objectAtIndex:1] forKey:@"sinaUser"];
                        
                    }
                    if([[bindDic objectForKey:@"bindto"]isEqualToString:@"facebook"]&& ![bindString isEqualToString:@""]){
                        
                        
                        [UserDefaults setValue:[bindArray objectAtIndex:0] forKey:@"FBAccessToken"];
                        [UserDefaults setValue:[bindArray objectAtIndex:1] forKey:@"FBUser"];
                        
                    }
                    if([[bindDic objectForKey:@"bindto"]isEqualToString:@"twitter"]&& ![bindString isEqualToString:@""]){
                        
                        [UserDefaults setValue:[bindArray objectAtIndex:0] forKey:@"TAccessToken"];
                        [UserDefaults setValue:[bindArray objectAtIndex:1] forKey:@"TAccessTokenSecret"];
                        
                        [UserDefaults setValue:[bindArray objectAtIndex:2] forKey:@"TUser"];
                        
                        
                    }

                }
                
            }
            
            
            */
            MyAppDataManager.loginid = [resDic valueForKey:@"loginid"];
            MyAppDataManager.useruid = [resDic valueForKey:@"userid"];
            MyAppDataManager.userAvatar =[resDic valueForKey:@"uface"];
       
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
            //            [UserDefaults setValue:[resDic valueForKey:@"friendlist"] forKey:FriendShip];
            //是否多余
//            [UserDefaults setValue:[BanBu_MyProfileViewController buildMyProfile:resDic] forKey:MyProfile];
//            //            [BanBu_MyProfileViewController buildMyProfile:resDic];
//            [UserDefaults synchronize];
            
            
            
            NSMutableDictionary *pars = [NSMutableDictionary dictionaryWithCapacity:2];
            if(_bindType == 1){
                [pars setValue:@"facebook" forKey:@"bindto"];
                //            [pars setValue:[NSString stringWithFormat:@"%@,%@",nil,@""] forKey:@"bindstring"];
                [pars setValue:[NSString stringWithFormat:@"%@,%@",[UserDefaults valueForKey:@"FBAccessToken"],[UserDefaults valueForKey:@"FBUser"]] forKey:@"bindstring"];
            }else if(_bindType == 2){
                [pars setValue:@"twitter" forKey:@"bindto"];
                [pars setValue:[NSString stringWithFormat:@"%@,%@,%@",[UserDefaults valueForKey:@"TAccessToken"],[UserDefaults valueForKey:@"TAccessTokenSecret"],[UserDefaults valueForKey:@"TUser"]] forKey:@"bindstring"];
                NSLog(@"%@",pars);
                
            }
           
            
            [AppComManager getBanBuData:BanBu_Set_User_accountbind par:pars delegate:self];
            
            
        }
        else
        {
            [MyAppDataManager.regDic setValue:[NSNumber numberWithInteger:_bindType] forKey:@"bindtype"];
            BanBu_RegViewController *reg = [[BanBu_RegViewController alloc] init];
            [self.navigationController pushViewController:reg animated:YES];
            [reg release];
//            [TKLoadingView showTkloadingAddedTo:self.navigationController.view title:[resDic valueForKey:@"error"] activityAnimated:NO duration:2.0];
            
        }

    }
    
    else if([AppComManager respondsDic:resDic isFunctionData:BanBu_Set_User_accountbind]){
        
        
        NSLog(@"%@",resDic);
        
        NSMutableDictionary *uidDic = [NSMutableDictionary dictionaryWithDictionary:[UserDefaults valueForKey:MyAppDataManager.useruid]];
        [uidDic setValue:[resDic valueForKey:@"bindlist"] forKey:@"bindlist"];
        [UserDefaults setValue:uidDic forKey:MyAppDataManager.useruid];
        [UserDefaults synchronize];
        
        BanBu_AppDelegate *delegate = (BanBu_AppDelegate *)[UIApplication sharedApplication].delegate;
        delegate.logined = YES;
        [delegate setViewController:YES];

        
        
    }
 
}




@end
