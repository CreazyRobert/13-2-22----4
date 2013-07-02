//
//  BanBu_MyProfileViewController.h
//  BanBu
//
//  Created by jie zheng on 12-7-8.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BanBu_PhotoManager.h"
#import "BanBuRequestDelegate.h"
#import "WBComposeViewController.h"
#import "QVerifyWebViewController.h"
#import "BanBu_TextEditer.h"


@interface BanBu_MyProfileViewController : UITableViewController<BanBuRequestDelegate,WBEngineDelegate,QVerifyWebViewControllerDelegate,UIActionSheetDelegate,UIAlertViewDelegate,BanBu_TextEditerDelegate>
{
    BanBu_PhotoManager *_photoView;
    BOOL _editting;
    NSInteger _workType;
    BOOL _isLeave;
    UILabel *titleLabel;
    NSString *shareString;
}

@property(nonatomic, retain)NSMutableDictionary *myProfile;
@property(nonatomic, retain)NSMutableDictionary *editBuffer;
@property (nonatomic, retain) WBEngine *engine;
@property(nonatomic, retain)FHSTwitterEngine *twitterEngine;
@property(nonatomic, retain) NSString *imagePathExtension;

-(void)bindingWeibo:(NSInteger)weiboType;
+ (NSDictionary *)buildMyProfile:(NSDictionary *)dataDic;


@end
