     //
//  BanBu_AppDelegate.m
//  BanBu
//
//  Created by jie zheng on 12-7-5.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "BanBu_AppDelegate.h"
#import "TKTabBarController.h"
#import <QuartzCore/QuartzCore.h>


#import "BanBu_UnloginedController.h"
#import "UINavigationBar+TKCategory.h"
#import "BanBu_NavigationController.h"
#import "BanBu_ListViewController.h"
#import "BanBu_MyFriendViewController.h"
#import "BanBu_ChatViewController.h"
#import "BanBu_LocationManager.h"
#import "BanBu_DialogueController.h"
#import "BanBu_SelectController.h"
#import "BanBu_MySpaceViewController.h"
#import "AppCommunicationManager.h"
#import "AppDataManager.h"
#import "UIImageView+WebCache.h"
#import "BanBu_LocationManager.h"
#import "BanBu_NavigationController.h"
#import "BanBu_BroadcastController.h"
#import "BanBu_BroadcastTVC.h"


NSString *const SCSessionStateChangedNotification = @"com.halfeet.scrapt:SCSessionStateChangedNotification";

@implementation BanBu_AppDelegate

@synthesize window = _window;
@synthesize tabbarController = _tabbarController;
@synthesize logined = _logined;
@synthesize string=_string;
- (void)dealloc
{
    self.tokenCaching = nil;
    [_window release];
    [_pushid release];
    [_tabbarController release];
    [super dealloc];
}

- (NSUInteger)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window {
    return UIInterfaceOrientationMaskPortrait;
}

void uncaughtExceptionHandler(NSException *exception) {
    NSLog(@"CRASH: %@", exception);
    NSLog(@"Stack Trace: %@", [exception callStackSymbols]);
    // Internal error reporting
}
#pragma CLLocationManager delegate method

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    NSSetUncaughtExceptionHandler(&uncaughtExceptionHandler);


    if(![FBSession defaultAppID]){
        [FBSession setDefaultAppID:@"471677566220485"];
    }
    /*
    NSString * stringPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString * documentFile = [stringPath stringByAppendingPathComponent:@"one"];
    if (![[NSFileManager defaultManager] fileExistsAtPath:documentFile]) {
        
        [[NSFileManager defaultManager] createDirectoryAtPath:documentFile withIntermediateDirectories:YES attributes:nil error:nil];
        //获取设备信息
        UIDevice *currentDevice = [UIDevice currentDevice];
        NSString *model = [currentDevice model];
        NSString *systemVersion = [currentDevice systemVersion];
        //    NSLog(@"model:%@sys:%@",model,systemVersion);
        //获取用户语言种类
        NSArray *languageArray = [NSLocale preferredLanguages];
        NSString *language = [languageArray objectAtIndex:0];
        NSLocale *locale = [NSLocale currentLocale];
        NSString *country = [locale localeIdentifier];
        //        NSLog(@"language=%@\ncountry=%@",language,country);
        //    NSLog(@"%@",languageArray);
        //获取应用程序版本信息
        NSString *appVersion = [[NSBundle mainBundle] objectForInfoDictionaryKey:(NSString *)kCFBundleVersionKey];
//    NSLog(@"%@",appVersion);
        //记录设备数据
        NSString *deviceSpecs = [NSString stringWithFormat:@"%@::%@::%@::%@::%@",model,systemVersion,language,country,appVersion];
        
        NSLog(@"%@",deviceSpecs);
                                                                                 }
  */
    //默认的ip
    NSString * stringPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString * documentFile = [stringPath stringByAppendingPathComponent:@"one"];
    if (![[NSFileManager defaultManager] fileExistsAtPath:documentFile]) {
        NSDictionary *aDic = [NSDictionary dictionaryWithObjectsAndKeys:@"http://74.117.60.99",@"chatserver",@"http://74.117.60.99",@"database",@"http://74.117.60.99",@"fileupload", nil];
        [UserDefaults setValue:aDic forKey:@"serverlist"];
        
    }
    
    
    
    UIApplication *app = [UIApplication sharedApplication];
    [app setStatusBarStyle:UIStatusBarStyleBlackOpaque animated:YES];
    [app setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
    
    _logined = NO;
    
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
//    self.window.backgroundColor = [UIColor colorWithRed:255.0/255 green:250.0/255 blue:240.0/255 alpha:1.0];
    self.window.backgroundColor = [UIColor colorWithRed:255.0/255 green:250.0/255 blue:240.0/255 alpha:1.0];
    self.tabbarController = [[[TKTabBarController alloc] init] autorelease];
    self.tabbarController.useImageOnly = NO;
   
    BanBu_DialogueController *dialogue = [[[BanBu_DialogueController alloc] init] autorelease];
    BanBu_ListViewController *luckPeople = [[[BanBu_ListViewController alloc] init] autorelease];
    BanBu_MyFriendViewController *myFriend = [[[BanBu_MyFriendViewController alloc] init] autorelease];
//    BanBu_SelectController *select = [[[BanBu_SelectController alloc]init]autorelease];
    BanBu_BroadcastTVC *broadcast = [[[BanBu_BroadcastTVC alloc] initWithStyle:UITableViewStylePlain] autorelease];
    broadcast.title = NSLocalizedString(@"broadcastTitle", nil);
    BanBu_MySpaceViewController *mySpace = [[[BanBu_MySpaceViewController alloc] init ] autorelease];
    
    luckPeople.title = NSLocalizedString(@"luckPeopleTitle", nil);
//    select.title = NSLocalizedString(@"selectTitle", nil);
    dialogue.title = NSLocalizedString(@"dialogueTitle", nil);
    myFriend.title = NSLocalizedString(@"myFriendTitle", nil);
    mySpace.title = NSLocalizedString(@"mySpaceTitle", nil);
    
    BanBu_NavigationController *nav1 = [[[BanBu_NavigationController alloc] initWithRootViewController:luckPeople] autorelease];
    BanBu_NavigationController *nav2 = [[[BanBu_NavigationController alloc] initWithRootViewController:broadcast] autorelease];
    BanBu_NavigationController *nav3 = [[[BanBu_NavigationController alloc] initWithRootViewController:dialogue] autorelease];
    BanBu_NavigationController *nav4 = [[[BanBu_NavigationController alloc] initWithRootViewController:myFriend] autorelease];
    BanBu_NavigationController *nav5 = [[[BanBu_NavigationController alloc] initWithRootViewController:mySpace] autorelease];
    
    self.tabbarController.viewControllers = [NSArray arrayWithObjects:nav1,nav2,nav3,nav4,nav5, nil];
    [_tabbarController setNormaolImage:[UIImage imageNamed:@"nearby.png"] selectedImage:[UIImage imageNamed:@"nearby_selected.png"] forItemWithIndex:0];
    [_tabbarController setNormaolImage:[UIImage imageNamed:@"throwball.png"] selectedImage:[UIImage imageNamed:@"throwball_selected.png"] forItemWithIndex:1];
    [_tabbarController setNormaolImage:[UIImage imageNamed:@"chat.png"] selectedImage:[UIImage imageNamed:@"chat_selected.png"] forItemWithIndex:2];

    [_tabbarController setNormaolImage:[UIImage imageNamed:@"myfriend.png"]
                         selectedImage:[UIImage imageNamed:@"myfriend_selected.png"] forItemWithIndex:3];
    [_tabbarController setNormaolImage:[UIImage imageNamed:@"myapplication.png"] selectedImage:[UIImage imageNamed:@"myapplication_selected.png"] forItemWithIndex:4];
    
//    [_tabbarController setAnimationImage:[UIImage imageNamed:@"green_background.png"]];
    //+++++++++++
    [UserDefaults setValue:[NSNumber numberWithInt:0] forKey:@"first"];
    

    if([UserDefaults valueForKey:@"myID"] && [[UserDefaults valueForKey: [UserDefaults valueForKey:@"myID"]] valueForKey:@"loginid"] ){
      
        MyAppDataManager.useruid = [UserDefaults valueForKey:@"myID"] ;

//        //NSLog(@"%@",[UserDefaults valueForKey:@"myID"]);
//        //NSLog(@"%@",[UserDefaults valueForKey:MyAppDataManager.useruid]);
        MyAppDataManager.loginid = [[UserDefaults valueForKey:MyAppDataManager.useruid] valueForKey:@"loginid"];
        MyAppDataManager.userAvatar =[[UserDefaults valueForKey:MyAppDataManager.useruid] valueForKey:@"uface"];
//        BanBu_AppDelegate *delegate = (BanBu_AppDelegate *)[UIApplication sharedApplication].delegate;
//        delegate.logined = YES;
//        [delegate setViewController:YES];
        _logined = YES;
        [self setViewController:YES];
    }else{
        if(!_logined)
        {
            BanBu_UnloginedController *unLogin = [[[BanBu_UnloginedController alloc] init] autorelease];
            BanBu_NavigationController *nav = [[[BanBu_NavigationController alloc] initWithRootViewController:unLogin] autorelease];
            
            self.window.rootViewController = nav;
        }
        else
        {
            //[[_tabbarController.viewControllers objectAtIndex:2] updateBadgeShow];
            
            
            
            self.window.rootViewController = self.tabbarController;
        }
    }
    
//    if ([self openSessionWithAllowLoginUI:NO]) {
//        // To-do, show logged in view
//    } else {
//        // No, display the login page.
//        NSLog(@"失败了。。。");
////        [self showLoginView];
//    }

    [self.window makeKeyAndVisible];
    
    self.numberOfLogin = [[UserDefaults valueForKey:@"numberOfLogin"] integerValue];
    if(self.numberOfLogin<100)
    self.numberOfLogin++;
    if(self.numberOfLogin >10 &&self.numberOfLogin <100){
        self.numberOfLogin = 0;
    }
//    NSLog(@"+++++%d",self.numberOfLogin);
    if(self.numberOfLogin==2)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"pinglunTitle", nil) message:NSLocalizedString(@"pinglunNotice", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"laterButton", nil) otherButtonTitles:NSLocalizedString(@"newButton",nil), nil];
        alert.tag = 157;
        [alert show];
        [alert release];
    }
    
    [UserDefaults setInteger:self.numberOfLogin forKey:@"numberOfLogin"];
    
    
    application.applicationIconBadgeNumber = 0;
    
//    if(![[UserDefaults valueForKey:@"pushid"] length])
        [application registerForRemoteNotificationTypes:
         (UIRemoteNotificationTypeBadge |
          UIRemoteNotificationTypeAlert |
          UIRemoteNotificationTypeSound)];
    
//    [application registerForRemoteNotificationTypes:<#(UIRemoteNotificationType)#>]; 

    //启动程序时，向微信终端注册id
    [WXApi registerApp:@"wx62511a38111194c5"];
    return YES;
}
- (void)application:(UIApplication*)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)deviceToken
{
    NSDateFormatter *formatter = [[[NSDateFormatter alloc] init]autorelease];
    [formatter setLocale:[NSLocale currentLocale]];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    self.lastWarningTime = [UserDefaults valueForKey:@"lastWarningTime"];
    if(self.lastWarningTime == nil)
    {
        self.lastWarningTime = @"0000-00-00 00:00:00";
    }
    NSDate *date = [[NSDate alloc]init];
    date = [formatter dateFromString:self.lastWarningTime];
    NSLog(@"%@",date);
    NSLog(@"%d %d",[[[formatter stringFromDate:[NSDate date]] substringWithRange:NSMakeRange(8, 2)] integerValue],[[[formatter stringFromDate:date] substringWithRange:NSMakeRange(8, 2)] integerValue]);
    if([[[formatter stringFromDate:[NSDate date]] substringWithRange:NSMakeRange(8, 2)] integerValue]-[[[formatter stringFromDate:date] substringWithRange:NSMakeRange(8, 2)] integerValue] >=1||self.numberOfLogin == 1)
        if(![[UIApplication sharedApplication] enabledRemoteNotificationTypes])
        {
            self.lastWarningTime = [formatter stringFromDate:[NSDate date]];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"openPush", nil) message:NSLocalizedString(@"howOpenPush", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"confirmNotice", nil) otherButtonTitles:nil, nil];
            
            [alert show];
            [alert release];
            [UserDefaults setObject:self.lastWarningTime forKey:@"lastWarningTime"];
        }
    
    
    
    NSString *pushToken = [[[[deviceToken description]
                             stringByReplacingOccurrencesOfString:@"<" withString:@""]
                            stringByReplacingOccurrencesOfString:@">" withString:@""]
                           stringByReplacingOccurrencesOfString:@" " withString:@""] ;
    NSLog(@"%@",pushToken);
    
    UIRemoteNotificationType types = [[UIApplication sharedApplication] enabledRemoteNotificationTypes];
//    NSLog(@"%d",types);
    if(types == UIRemoteNotificationTypeNone)
    {
        NSLog(@"nimen");
    }
//    NSLog(@"%u",[[UIApplication sharedApplication] enabledRemoteNotificationTypes]);
    self.pushid = [NSString stringWithFormat:@"%@",deviceToken];
    
    [UserDefaults setValue:self.pushid forKeyPath:@"pushid"];
}

- (void)application:(UIApplication*)application didFailToRegisterForRemoteNotificationsWithError:(NSError*)error
{
    NSLog(@"Failed to get token, error: %@", error);
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
    
}

- (void)goToLogin:(NSString *)detailMsg
{

//     NSMutableDictionary *uidDic = [NSMutableDictionary dictionaryWithDictionary:[UserDefaults valueForKey:MyAppDataManager.useruid]];
//    [uidDic setValue:[resDic valueForKey:@"list"] forKey:@"renameflist"];
//    [UserDefaults setValue:uidDic forKey:MyAppDataManager.useruid];
//    [UserDefaults synchronize];
    
//    [UserDefaults removeObjectForKey:@"myID"];
//    [UserDefaults synchronize];
//    MyAppDataManager.loginid = nil;

//    BanBu_UnloginedController *unLogin = [[[BanBu_UnloginedController alloc] init] autorelease];
//    BanBu_NavigationController *nav = [[[BanBu_NavigationController alloc] initWithRootViewController:unLogin] autorelease];
//    self.window.rootViewController = nav;
    [self setViewController:NO];
    if(!_isFirstVaild){
        _isFirstVaild = !_isFirstVaild;
        UIAlertView *jidiaole = [[UIAlertView alloc]initWithTitle:detailMsg message:nil delegate:self cancelButtonTitle:NSLocalizedString(@"confirmNotice", nil) otherButtonTitles:nil];
        [jidiaole show];
        [jidiaole release];
    }
    
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(alertView.tag == 157)
    {
        if(buttonIndex == 1)
        {
        NSString *stringURL = @"https://itunes.apple.com/cn/app/ban-bu/id606817878?mt=8";
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:stringURL]];
            [UserDefaults setInteger:100 forKey:@"numberOfLogin"];

        }
    }
    
    _isFirstVaild = NO;
    
    
}

- (void)setViewController:(BOOL)login
{
    [UserDefaults setValue:[NSNumber numberWithInt:0] forKey:@"first"];

    _logined = login;
    
    id visibleController = nil;
    if(login)
    {
        self.tabbarController.selectedIndex = 0;
        visibleController = self.tabbarController;
      
        [MyAppDataManager readTalkList:TALKPEOPLES];
        
        [AppComManager startReceiveMsgFromUid:nil forDelegate:MyAppDataManager];
        
        
        [self updateBadge];
    }
    else
        {
            if([AppComManager.receiveMsgTimer isValid])
            {
                [AppComManager.receiveMsgTimer invalidate];
                
                AppComManager.receiveMsgTimer=nil;
                
            }
            
            BanBu_UnloginedController *unLogin = [[[BanBu_UnloginedController alloc] init] autorelease];
            BanBu_NavigationController *nav = [[[BanBu_NavigationController alloc] initWithRootViewController:unLogin] autorelease];
            visibleController = nav;
        }
    
    CATransition *animation = [CATransition animation];
    animation.duration = .5f;
    animation.timingFunction = UIViewAnimationCurveEaseInOut;
    animation.fillMode = kCAFillModeForwards;
    animation.type = kCATransitionPush;
    animation.subtype = kCATransitionFade;
    self.window.rootViewController = visibleController;
    [self.window.layer addAnimation:animation forKey:@"animation"];


}

- (void)updateBadge
{
    UINavigationController *nav = [_tabbarController.viewControllers objectAtIndex:2];
    
    BanBu_DialogueController *diavc = nil;
    for(BanBu_DialogueController *dia in nav.viewControllers)
    {
         if([dia isMemberOfClass:[BanBu_DialogueController class]])
         {
             diavc = dia;
             break;
         }
    }
    
    [diavc updateBadgeShow];
    
    
    

    
}



-(void)updateDialoge:(NSString *)str
{
        if([str intValue]==0)
        return;
    UINavigationController *nav = [_tabbarController.viewControllers objectAtIndex:4];
    
    BanBu_MySpaceViewController *diavc = nil;
    for(BanBu_MySpaceViewController *dia in nav.viewControllers)
    {
        if([dia isMemberOfClass:[BanBu_MySpaceViewController  class]])
        {
            diavc = dia;
            break;
        }
    }
    
    
    [diavc createTheBandageView:str];
    
    
}



 

#pragma mark - WXApiDelegate

//-(BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation{
//    NSLog(@"%@",sourceApplication);
//    return [WXApi handleOpenURL:url delegate:self];
//}
-(void) onRequestAppMessage
{
    // 微信请求App提供内容， 需要app提供内容后使用sendRsp返回
    
    
}

-(void) onReq:(BaseReq*)req
{
    //    NSLog(@"%d",req.type);
    if([req isKindOfClass:[GetMessageFromWXReq class]])
    {
        [self onRequestAppMessage];
    }
    else if([req isKindOfClass:[ShowMessageFromWXReq class]])
    {
        //        ShowMessageFromWXReq* temp = (ShowMessageFromWXReq*)req;
        //        [self onShowMediaMessage:temp.message];
    }
    
    
}

-(void) onResp:(BaseResp*)resp
{
    if([resp isKindOfClass:[SendMessageToWXResp class]])
    {
        
        if(resp.errCode == 0){
            
            [TKLoadingView showTkloadingAddedTo:self.window title:NSLocalizedString(@"shareSuccess", nil) activityAnimated:NO duration:2.0];
            
        }else if(resp.errCode == -2){
            
            [TKLoadingView showTkloadingAddedTo:self.window title:NSLocalizedString(@"errcode_cancel", nil) activityAnimated:NO duration:2.0];
            
        }
    }
    else if([resp isKindOfClass:[SendAuthResp class]])
    {
        //        NSString *strTitle = [NSString stringWithFormat:@"Auth结果"];
        //        NSString *strMsg = [NSString stringWithFormat:@"Auth结果:%d", resp.errCode];
        //
        //        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:strTitle message:strMsg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        //        [alert show];
        //        [alert release];
    }
}

-(void)saveLastTime
{
    
    MyAppDataManager.deep=NO;
    
    NSDateFormatter *formatter = [[[NSDateFormatter alloc] init] autorelease];
    [formatter setLocale:[NSLocale currentLocale]];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *stime = [formatter stringFromDate:[NSDate date]];
    
    [UserDefaults setValue:stime forKey:@"lasttime"];
    
}




- (void)applicationWillResignActive:(UIApplication *)application
{

    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    if(MyAppDataManager.useruid)
    {
    _logined = NO;
    [self saveLastTime];
    NSMutableDictionary *uidDic = [NSMutableDictionary dictionaryWithDictionary:[UserDefaults valueForKey:MyAppDataManager.useruid]];
    
    if([uidDic valueForKey:@"loginid"]){
        NSInteger total = 0;
        for(NSDictionary *aTalk in MyAppDataManager.talkPeoples)
        {
            total += [VALUE(KeyUnreadNum, aTalk) integerValue];
            
            if([[aTalk valueForKey:@"userid"] intValue]<1000)
            {
                
                // 不需要了因为他们都是在一个navi
                //  [MyAppDelegate updateBadgeFriend:VALUE(KeyUnreadNum, aTalk)];
                
            }
        }
        //    NSLog(@"%d",total);
        application.applicationIconBadgeNumber  = total;
        
        //    [self updateBadge];
    }else{
        application.applicationIconBadgeNumber  = 0;

    }
    }
    

    
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
//    NSMutableDictionary *parDic = [NSMutableDictionary dictionary];
//    [AppComManager getBanBuData:BanBu_Get_Server_List par:parDic delegate:self];
    [self interandword];
    [AppLocationManager getLocation];
    [[FBSession activeSession] handleDidBecomeActive];
    if([AppComManager.receiveMsgTimer isValid])
    {
        [AppComManager.receiveMsgTimer invalidate];
        
        AppComManager.receiveMsgTimer=nil;
        
    }

 
    if(MyAppDataManager.useruid && !_logined)
    {
//        NSLog(@"%@",MyAppDataManager.chatuid);
        [AppComManager receiveMsgFromUser:MyAppDataManager.chatuid delegate:MyAppDataManager];
    }
 
   

    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
   
}


- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    [[FBSession activeSession] close];

}

-(void)interandword{
    // 序列化存储各种数据
    //判断有没有这么一个文件 并且判断有没有超过三十天
    // 获取当前时间
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *dateStr = [formatter stringFromDate:[NSDate date]];
    NSLog(@"datestr----%@",dateStr);
    NSDate *miniDate = [formatter dateFromString:dateStr];

    NSLog(@"beforestr----%@",[UserDefaults valueForKey:@"internationalTime"]);
    NSDate *beforeDate=[formatter dateFromString:[UserDefaults valueForKey:@"badwordtime"]];
    
    NSTimeInterval time=[miniDate timeIntervalSinceDate:beforeDate];
    
    int days=((int)time)/(3600*24);
    // 这是国际语言包
    
    NSDate *languageDate=[formatter dateFromString:[UserDefaults valueForKey:@"internationalTime"]];
    
    NSTimeInterval time2=[miniDate timeIntervalSinceDate:languageDate];
    
    int languageDays=((int)time2)/(3600*24);
    
    NSLog(@"时间过去了多少%d",languageDays);
    
    [formatter release];
    
    
    // 这是不文明用语的路劲
    NSString  *path1 =[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)objectAtIndex:0] stringByAppendingPathComponent:@"BadWord"];
    
    // 这是国际语言包的路径
    NSString  *path2 =[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)objectAtIndex:0] stringByAppendingPathComponent:@"InterNationalanguage"];
    
    
    // 这是判断不文明用语
//    NSLog(@"%d",days);
    if(![FileManager fileExistsAtPath:path1]||days>=30)
    {
        NSMutableDictionary *loginDic = [NSMutableDictionary dictionary];
        
        [AppComManager getBanBuData:BanBu_BadWordto_check par:loginDic delegate:self];
        //        self.navigationController.view.userInteractionEnabled = NO;
        
    }else{
        
        
//        [MyAppDataManager.blackString stringByAppendingString:[NSKeyedUnarchiver unarchiveObjectWithData:[NSData dataWithContentsOfFile:path1]]];
        
        NSString *str=[NSKeyedUnarchiver unarchiveObjectWithData:[NSData dataWithContentsOfFile:path1]];
        
        MyAppDataManager.blackString=str;
        
    }
    
    // this is  unuseful
    // [MyAppDataManager.blackString stringByAppendingString:[NSKeyedUnarchiver unarchiveObjectWithData:[NSData dataWithContentsOfFile:path1]]];
    
//    NSString *str=[NSKeyedUnarchiver unarchiveObjectWithData:[NSData dataWithContentsOfFile:path1]];
//    
//    MyAppDataManager.blackString=str;
    
    
    // 这是国际用语
//    NSLog(@"%@", path2);
    if(![FileManager fileExistsAtPath:path2]||languageDays>=1)
    {
        NSMutableDictionary *loginDic = [NSMutableDictionary dictionary];
        
        [AppComManager getBanBuData:BanBu_Internationar_Language par:loginDic delegate:self];
        //        self.navigationController.view.userInteractionEnabled = NO;
        
    }else
    {
        
         [MyAppDataManager.languageDictionary setDictionary:[NSKeyedUnarchiver unarchiveObjectWithData:[NSData dataWithContentsOfFile:path2]]];
//    NSLog(@"i i i%@",MyAppDataManager.languageDictionary);
        
        
        
    }
    


}


- (void)banbuRequestDidFinished:(NSDictionary *)resDic error:(NSError *)error
{
 
    
    if(error)
    {
        // 这是不文明用语的路劲
        NSString  *path1 =[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)objectAtIndex:0] stringByAppendingPathComponent:@"BadWord"];
        
        // 这是国际语言包的路径
        NSString  *path2 =[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)objectAtIndex:0] stringByAppendingPathComponent:@"InterNationalanguage"];
        
        if([FileManager fileExistsAtPath:path1])
        {
            NSString *str=[NSKeyedUnarchiver unarchiveObjectWithData:[NSData dataWithContentsOfFile:path1]];
            MyAppDataManager.blackString=str;
            
        }

        if([FileManager fileExistsAtPath:path2])
        {
            
            [MyAppDataManager.languageDictionary setDictionary:[NSKeyedUnarchiver unarchiveObjectWithData:[NSData dataWithContentsOfFile:path2]]];
            //    NSLog(@"i i i%@",MyAppDataManager.languageDictionary);
        }

        if([error.domain isEqualToString:BanBuDataformatError])
        {
//            [TKLoadingView showTkloadingAddedTo:self.window title:NSLocalizedString(@"data_error", nil) activityAnimated:NO duration:2.0];
        }
        else
        {
//            [TKLoadingView showTkloadingAddedTo:self.window title:NSLocalizedString(@"network_error", nil) activityAnimated:NO duration:2.0];
        }
        
   
        return;
    }
    if([AppComManager respondsDic:resDic isFunctionData:BanBu_BadWordto_check])
    {
    
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSString *dateStr = [formatter stringFromDate:[NSDate date]];
        [formatter release];
        
        [UserDefaults setValue:dateStr forKey:@"badwordtime"];
        
        [UserDefaults synchronize];
        
        MyAppDataManager.dateString=dateStr;
        MyAppDataManager.blackString=[resDic objectForKey:@"list"];

        __block typeof(MyAppDataManager)blockDataManager = MyAppDataManager;
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_async(queue, ^{
            
            NSData *listData=[NSKeyedArchiver archivedDataWithRootObject:blockDataManager.blackString];
            
            NSString  *path1 =[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)objectAtIndex:0] stringByAppendingPathComponent:@"BadWord"];
            
            // NSString *path = [DataCachePath stringByAppendingPathComponent:@"listdata"];
            
            [listData writeToFile:path1 atomically:YES];
 
        });
 
    }
    // 判断一下 是不是国际语言包
    
    else if([AppComManager respondsDic:resDic isFunctionData:BanBu_Internationar_Language])
    {
        //        //NSLog(@"%@",resDic);
        
        [MyAppDataManager.languageDictionary setValue:resDic forKey:@"language"];
        
//    NSLog(@"*****************%@",MyAppDataManager.languageDictionary);
        
        
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSString *dateStr = [formatter stringFromDate:[NSDate date]];
        [formatter release];
        
        // 把上一次的网络解析
        
        [UserDefaults setValue:dateStr forKey:@"internationalTime"];
        
        [UserDefaults synchronize];
        
//        MyAppDataManager.LanguageDateString=dateStr;
        
        // 把获取到的数据存入到文件当中去
        __block typeof(MyAppDataManager)blockDataManager = MyAppDataManager;

        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_async(queue, ^{
            
            NSData *listData=[NSKeyedArchiver archivedDataWithRootObject:blockDataManager.languageDictionary];
            
            NSString  *path1 =[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)objectAtIndex:0] stringByAppendingPathComponent:@"InterNationalanguage"];
            
            // NSString *path = [DataCachePath stringByAppendingPathComponent:@"listdata"];
            
            [listData writeToFile:path1 atomically:YES];

            
        });
        
    

    }
    
//    else if([AppComManager respondsDic:resDic isFunctionData:BanBu_Get_Server_List]){
//        NSLog(@"%@",resDic);
//        NSMutableDictionary *aDic = [NSMutableDictionary dictionaryWithDictionary:[resDic valueForKey:@"serverlist"]];
//        [aDic setValue:[NSString stringWithFormat:@"http://%@",[aDic valueForKey:@"database"]] forKey:@"database"];
//        [aDic setValue:[NSString stringWithFormat:@"http://%@",[aDic valueForKey:@"fileupload"]] forKey:@"fileupload"];
//        [aDic setValue:[NSString stringWithFormat:@"http://%@",[aDic valueForKey:@"chatserver"]] forKey:@"chatserver"];
//        [UserDefaults setValue:aDic forKey:@"serverlist"];
//        //请求国际化语言包和不文明用语
//        [self interandword];
//    
//        [[NSNotificationCenter defaultCenter]postNotificationName:@"unlogin" object:nil];
//    }

}

#pragma mark - FaceBookShare

- (void)sessionStateChanged:(FBSession *)session
                      state:(FBSessionState) state
                      error:(NSError *)error{
//    NSLog(@"%d",state);
    switch (state) {
        case FBSessionStateOpen:
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:SCSessionStateChangedNotification object:session];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"abc" object:session];
//            [[NSNotificationCenter defaultCenter] postNotificationName:@"def" object:session];
            
        }
            break;
        case FBSessionStateClosed:
        case FBSessionStateClosedLoginFailed:
            [FBSession.activeSession closeAndClearTokenInformation];

            break;
            
        default:
            break;
    }
    
//    NSLog(@"%@",session.accessToken);
    if(error){
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"error" message:error.localizedDescription delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alertView show];
        [alertView release];
    }
}
-(BOOL)openSessionWithAllowLoginUI:(BOOL)allowLoginUI{
    
    NSArray *permission = [[NSArray alloc]initWithObjects:@"email",@"user_photos", nil];

//    return [FBSession openActiveSessionWithPublishPermissions:permission defaultAudience:FBSessionDefaultAudienceEveryone allowLoginUI:YES completionHandler:^(FBSession *session, FBSessionState status, NSError *error) {
//        [self sessionStateChanged:session state:status error:error];
//
//    }];
//     [[FBSession activeSession] reauthorizeWithPublishPermissions:permission defaultAudience:FBSessionDefaultAudienceEveryone completionHandler:^(FBSession *session, NSError *error) {
//        [self sessionStateChanged:session state:nil error:error];
//
//    }];
    return [FBSession openActiveSessionWithReadPermissions:permission allowLoginUI:YES completionHandler:^(FBSession *session, FBSessionState status, NSError *error) {
        [self sessionStateChanged:session state:status error:error];
    }];
    
}
 
- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    // FBSample logic
    // We need to handle URLs by passing them to FBSession in order for SSO authentication
    // to work.
    if([sourceApplication isEqualToString:@"com.tencent.xin"]){
        return [WXApi handleOpenURL:url delegate:self];
        
    }
    return [FBSession.activeSession handleOpenURL:url];
}

+ (NSString *)FBErrorCodeDescription:(FBErrorCode) code {
    switch(code){
        case FBErrorInvalid :{
            return @"FBErrorInvalid";
        }
        case FBErrorOperationCancelled:{
            return @"FBErrorOperationCancelled";
        }
        case FBErrorLoginFailedOrCancelled:{
            return @"FBErrorLoginFailedOrCancelled";
        }
        case FBErrorRequestConnectionApi:{
            return @"FBErrorRequestConnectionApi";
        }case FBErrorProtocolMismatch:{
            return @"FBErrorProtocolMismatch";
        }
        case FBErrorHTTPError:{
            return @"FBErrorHTTPError";
        }
        case FBErrorNonTextMimeTypeReturned:{
            return @"FBErrorNonTextMimeTypeReturned";
        }
        case FBErrorNativeDialog:{
            return @"FBErrorNativeDialog";
        }
        default:
            return @"[Unknown]";
    }
}



@end
