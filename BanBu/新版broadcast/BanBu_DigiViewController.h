//
//  BanBu_DigiViewController.h
//  BanBu
//
//  Created by Jc Zhang on 13-3-7.
//
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "BanBu_DetailCell.h"
#import "WBEngine.h"
#import "QWeiboAsyncApi.h"
#import "RecordView.h"
#import "MWPhotoBrowser.h"
@interface BanBu_DigiViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate,UITextViewDelegate,AVAudioPlayerDelegate,UIActionSheetDelegate,WBEngineDelegate,FHSTwitterEngineAccessTokenDelegate,RecordViewDelegate,MWPhotoBrowserDelegate>{
    
    UIButton *_textAndSoundBtn;
    NSArray *replyList;
    
    UIButton *_voiceButton;
    UIActivityIndicatorView *_playHUD;
    UIImageView *animationBackgroundView;
    NSInteger labelSelect;
    UIButton * sendBtn;//发送按钮
    RecordView *_recordView;
    NSData *_sendSoundData;
    NSString *_soundTime;
    BOOL _isReplyed;
    UIImageView *_headImageView;
    BOOL _isRefreshContent;
    UILabel *_sayTextLabel;
    NSString *headImageString;

}

@property(nonatomic,retain)UITableView *broadTableView;
@property(nonatomic,retain)UIView *chatView;
@property(nonatomic,retain)UITextView *inputTextView;
@property(nonatomic,retain)UIButton *tabvoiceButton;
@property(nonatomic, retain)NSMutableDictionary *broadcast;
@property(nonatomic,retain) AVAudioPlayer *player;
@property (nonatomic, retain) NSURLConnection *connection;//tencent
@property(nonatomic,retain) NSData *sendImageData;
@property(nonatomic,retain)UIImageView *playingView;
@property(nonatomic,retain)  NSMutableArray *showPhotos;//浏览原图

@property(nonatomic,assign)NSInteger selectSection;
- (id)initWithBroadcast:(NSDictionary *)broadcastDic;

@end
