//
//  BanBu_ReleaseController.h
//  BanBu
//
//  Created by mac on 12-8-11.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BroadcastRecordView.h"
#import "WBComposeViewController.h"
#import "QweiboViewController.h"

#import "WBEngine.h"


@interface BanBu_ReleaseController : UIViewController<UITextViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,BroadcastRecordViewDelegate,WBEngineDelegate,QVerifyWebViewControllerDelegate,UIAlertViewDelegate,UIActionSheetDelegate>{
    UITextView *textView;

    BOOL haveAttach;
    NSMutableArray *attachArr;
    BOOL haveSendLocation;
    UIAlertView *alertSucess;
    
    BOOL sinaIsOK;
    BOOL TXIsOK;
    UIImageView *veryImprotImageView;
    UIImageView *veryImprotImageView1;
    BOOL isAlert;
    NSDictionary *_tuyaDic;
    NSDictionary *_zhaoxiangDic;
    NSDictionary *_xiangceDic;
    BOOL isAgree;


    
}
@property(nonatomic,retain)UIImage * receiveImage;
@property(assign,nonatomic)int btntag;
@property(nonatomic,retain)WBEngine *wbEngine;
@property (nonatomic, retain) NSURLConnection *connection;
@property (nonatomic, retain) NSMutableData *responseData;
@end
