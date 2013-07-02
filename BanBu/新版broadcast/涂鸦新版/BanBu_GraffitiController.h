//
//  RootViewController.h
//  兔丫丫
//
//  Created by mac on 12-8-6.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "WBEngine.h"
#import "QWeiboAsyncApi.h"
#import "ALAssetsLibrary+CustomPhotoAlbum.h"


@class Canvas2D;

@interface BanBu_GraffitiController : UIViewController<UIApplicationDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,WBEngineDelegate,FHSTwitterEngineAccessTokenDelegate>{
    UIView *bgView;
    UIView *sliderView;
    UIView *clearView;//整个底部的界面
//    UIButton *closeBtn;
//    UIButton *camBtn;
    UIImageView *pointView;
    BOOL isClose;
    UILabel *textLabel;
    Canvas2D *aCan;
    BOOL isCameraOrAlbum;
    BOOL isChat;
    UIActionSheet *emptySheet;
    UIActionSheet *sendSheet;
    
    UIImageView *tuyaImageView;//涂鸦模板
    UIImage *viewImage;
    UIImageView *sendImageview;
    
    //来自
    int _type;
    ALAssetsLibrary *_assetLibrary;

}

@property (nonatomic, retain) NSURLConnection *connection;//tencent


-(id)initwithImage:(UIImage *)sendImage andSourceType:(int)type;

@end
