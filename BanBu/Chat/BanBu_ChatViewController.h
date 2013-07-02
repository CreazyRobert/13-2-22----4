//
//  BanBu_ChatViewController.h
//  BanBu
//
//  Created by jie zheng on 12-7-15.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BanBu_SmileView.h"
#import "CFCube.h"
#import "BanBu_LocationManager.h"
#import "AppCommunicationManager.h"
#import "AppDataManager.h"
#import "TKLoadingView.h"
#import "RecordView.h"
#import "BanBu_MakeBigMapViewController.h" 
#import "BanBu_HeaderView.h"
#import "BanBu_SmallListView.h"
#import "BanBu_MediaView.h"
#import "BanBu_ShareView.h"
#import "BanBu_ChatDelegate.h"
#import "WBEngine.h"
//#import "SDWebImageManager.h"
typedef enum {
    
    ChatCellTypeTextd = 0,
    ChatCellTypeImaged,
    ChatCellTypeLocationd,
    ChatCellTypeVoiced,
    ChatCellTypeEmid
    
} ChatCellTyped;

typedef enum
{
    ListDelete,
    ListBlackCommit,
    ListOneProfile
   
}ListTypey;

@interface BanBu_ChatViewController : UIViewController <UITextViewDelegate,BanBu_SmileViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,BanBu_LocationManagerDelegate,UITableViewDataSource,UITableViewDelegate,CFCubeDelegate,BanBuRequestDelegate,RecordViewDelegate,MakeMap,UIActionSheetDelegate,BanBu_SmallListViewDelegate,MessageRadio,UIAlertViewDelegate,BanBu_ChatDelegate,WBEngineDelegate,FHSTwitterEngineAccessTokenDelegate>
{
    CFCube *_inputBar;
    UIView *_topBar; 
    UITextView *_inputView;
    NSMutableArray *_buttons;
    UIButton *_plusButton;
    UIButton *_smileButton;
    UIButton *_actionButton;
    UIButton *_plusButton2;
    UIButton *_smileButton2;
    UIButton *_actionButton2;
    RecordView *_recordView;
    
    BOOL _showMenu;
    BOOL _firstHere;
    BanBu_SmileView *_smileView;
    
    BOOL _showSmile;
    
    BanBu_ShareView *_shareViewOne;
    
    UIView *_backView;
    
}
@property (nonatomic, retain) NSURLConnection *connection;//tencent
@property(nonatomic, retain)UITableView *tableView;
@property(nonatomic, retain)NSDictionary *profile;
// 这是经纬度
@property(nonatomic,retain)NSString *lat;
@property(nonatomic,retain)NSString *lon;
@property(nonatomic,retain)NSIndexPath *location;
@property(nonatomic,retain)NSMutableArray *selectArr;
@property(nonatomic,assign)int rowt;
// 标记这是 记录 你点击的cell 发送的是什么类型
@property(nonatomic,assign)ChatCellTyped type;

@property(nonatomic,assign,setter = setList:)ListTypey listType;
@property(nonatomic,retain)NSMutableArray *latiArr;

@property(nonatomic,assign)NSString *fromPbTu;



- (id)initWithPeopleProfile:(NSDictionary *)profile;
- (void)tableViewAutoOffset;
- (BOOL)fiveMinuteLater:(NSString *)stime beforeTime:(NSString *)ltime;

-(BOOL)stopLastVoiceView:(int)row;

@end
