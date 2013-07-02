//
//  BanBu_AddNewFriendViewController.h
//  BanBu
//
//  Created by laiguo zheng on 12-7-12.
//  Copyright (c) 2012年 17xy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZBarSDK.h"
#import "AppDataManager.h"
#import "AppCommunicationManager.h"
#import "BanBuAPis.h"
#import "TKLoadingView.h"
#import "BanBu_PeopleProfileController.h"
#import "BanBu_zbar.h"
#import "NSDictionary_JSONExtensions.h"
#import <CommonCrypto/CommonDigest.h>


@interface BanBu_AddNewFriendViewController : UITableViewController<ZBarReaderDelegate,UIAlertViewDelegate,UITextFieldDelegate>
{
    UITextField *_IDInput;
    
    NSTimer *time;

    UIImageView *lineImage;
    
    ZBarReaderViewController *reader;
    
    BOOL flag;
    
    
}

@end
