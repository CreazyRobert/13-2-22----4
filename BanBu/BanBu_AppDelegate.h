//
//  BanBu_AppDelegate.h
//  BanBu
//
//  Created by jie zheng on 12-7-5.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WXApi.h"
#import <FacebookSDK/FacebookSDK.h>
#import <FacebookSDK/FBSessionTokenCachingStrategy.h>

extern NSString *const SCSessionStateChangedNotification;

@class TKTabBarController;
#define MyAppDelegate (BanBu_AppDelegate *)[UIApplication sharedApplication].delegate

@interface BanBu_AppDelegate : UIResponder <UIApplicationDelegate,WXApiDelegate,UIAlertViewDelegate>{
    BOOL _isFirstVaild;

}

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, assign) BOOL logined;
@property (strong, nonatomic) TKTabBarController *tabbarController;
@property (nonatomic,retain) NSString *string;
@property (nonatomic,retain)FBSessionTokenCachingStrategy *tokenCaching;
@property (nonatomic,retain) NSString *pushid;
@property (nonatomic,retain) NSString *lastWarningTime;//推送最后提醒时间保存，每天登陆提醒一次
@property NSInteger numberOfLogin;
- (void)setViewController:(BOOL)login;
- (void)updateBadge;
//-(void)updateBallBadge;
-(void)saveLastTime;
- (void)goToLogin:(NSString *)detailMsg;
-(void)updateDialoge:(NSString *)str;
//FaceBookShare
- (BOOL)openSessionWithAllowLoginUI:(BOOL)allowLoginUI;

+ (NSString *)FBErrorCodeDescription:(FBErrorCode) code;

@end
