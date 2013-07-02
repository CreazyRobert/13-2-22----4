//
//  BanBu_MediaView.h
//  BanBu
//
//  Created by 来国 郑 on 12-7-25.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIButton+WebCache.h"
#import "RecordAudio.h"
#import "DDProgressView.h"
#import "MWPhotoBrowser.h"
#import <QuartzCore/QuartzCore.h>
#import "SCGIFImageView.h"
#import "BanBu_ChatToseePic.h"
@class BanBu_ChatViewController;
@class BanBu_ViewController;
@protocol MessageRadio;
typedef enum {
    MediaViewTypeImage = 0,
    MediaViewTypeVoice,
} MediaViewType;

typedef enum
{
    MediaStatusNormal,
    MediaStatusUpload,
    MediaStatusDownload,
    MediaStatusUploadFaild,
    MediaStatusDownloadFaild
    
} MediaStatus;

typedef enum
{
    MediaBroadStand,
    
    MediaBroadRadio
    
}MediaBroadType;
@interface BanBu_MediaView : UIView <RecordAudioDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,MWPhotoBrowserDelegate>
{
    RecordAudio *_audioManager;
    
}

@property(nonatomic, retain) NSString *mediaPath;
@property(nonatomic, assign) UIButton *showButton;
@property(nonatomic, retain) DDProgressView *progressBar;
@property(nonatomic, retain) UIImageView *playingView;
@property(nonatomic, assign) MediaStatus status;;
@property(nonatomic, assign) MediaViewType type;
@property(nonatomic, assign) BanBu_ChatViewController *appChatController;
@property(nonatomic,assign)  BanBu_ViewController *appViewController;
@property(nonatomic,retain)  NSMutableArray *showPhotos;
@property(nonatomic,assign)  MediaBroadType broadType;
@property(nonatomic,assign)  id<MessageRadio>delegate;
@property(nonatomic,retain)  SCGIFImageView *gifView;
- (void)setMedia:(NSString *)mediaStr;

-(void)radioAutoBroad:(MediaBroadType)type;

-(void)continueToBroad;

@end
@protocol MessageRadio <NSObject>

-(void)RunLoopMusic:(NSMutableArray *)row Url:(NSMutableArray *)url;

@end