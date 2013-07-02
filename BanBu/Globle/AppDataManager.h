//
//  AppDataManager.h
//  BanBu
//
//  Created by 17xy on 12-8-3.
//
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"
#import "FMDatabaseAdditions.h"
#import "FMDatabaseQueue.h"
#import "UIIImage_TKCategory.h"
#import "BanBu_ChatCell.h"
#import "BanBu_ViewController.h"
#import "BanBu_MyFriendViewController.h"
@class BanBu_ViewController;
@class BanBu_ChatViewController;
@class AppCommunicationManager;
@class BanBu_AppDelegate;
@class BanBu_MyFriendViewController;
#define DataCachePath [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)objectAtIndex:0] stringByAppendingPathComponent:@"Userdata"]
#define MyAppDataManager [AppDataManager sharedAppDataManager]
#define FileManager      [NSFileManager defaultManager]
#define UserDefaults     [NSUserDefaults standardUserDefaults]

#define  DIALOGS @"dialogs"
#define  TALKPEOPLES [@"talkPeoples" stringByAppendingString:MyAppDataManager.useruid]
#define  BallDialogs @"balldialogs"
#define  BallList [@"balllist" stringByAppendingString:MyAppDataManager.useruid]
//建一张表
#define  AgreeList [@"agreelist"stringByAppendingString:MyAppDataManager.useruid]

#define DefaultReadNum 20
#define AllData 1000000

#define VALUE(aKey,aDic)  [aDic valueForKey:aKey]
#define AsynRun(selector)  dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);dispatch_async(queue, ^{selector;})



#define BanBu_release(_v)  [_v release],_v=nil


typedef void (^MyDataManagerArray)(NSArray*);

typedef enum{
MessageTypeStand,

MessageTypeRadio

}MessageType;

@protocol AppDataManagerDelegate;

@interface AppDataManager : NSObject
{
      AVAudioPlayer *player;
    
     
    
}

@property(nonatomic, retain)NSString *musicName;

@property(nonatomic, retain)NSMutableDictionary *regDic;
@property(nonatomic, retain)NSString *loginid;
@property(nonatomic, retain)NSString *useruid;
@property(nonatomic, retain)NSString *chatuid;
@property(nonatomic, retain)NSString *userAvatar;
@property(nonatomic, retain)NSMutableArray *nearBuddys;
@property(nonatomic, retain)NSMutableArray *nearDos;
@property(nonatomic, retain)NSMutableArray *contentArr;
@property(nonatomic, retain)NSMutableArray *friends;
@property(nonatomic, retain)NSMutableArray *friendsDos;
@property(nonatomic, retain)NSMutableArray *friendViewList;
@property(nonatomic, retain)NSMutableArray *dialogs;
@property(nonatomic, retain)NSMutableArray *talkPeoples;
@property(nonatomic, retain)NSMutableArray *unLoginArr;

@property(nonatomic, retain)NSString *zibarString;
@property(nonatomic, retain)FMDatabase *dataBase;
@property(nonatomic, assign)BanBu_ChatViewController *appChatController;
@property(nonatomic, assign)BanBu_ViewController *appViewController;

// 这是实现代理的
// 这是执行的判断是否深查询

@property(nonatomic,assign)BOOL deep;
@property(nonatomic,assign)NSString *Lasttime;
@property(nonatomic,retain)NSMutableArray *readArr;
@property(nonatomic,assign)BOOL isSend;

// 这是不文明用语
@property(nonatomic,retain)NSString *LanguageDateString;
@property(nonatomic,retain)NSString *dateString;
@property(nonatomic,retain)NSString *blackString;
@property(nonatomic,retain)NSMutableDictionary *languageDictionary;

// 这是抛绣球的东西
@property(nonatomic,retain)NSMutableArray *playBall;
//@property(nonatomic,assign)BanBu_ChatViewController *viewController;
@property(nonatomic,retain)NSMutableArray *ballTalk;

@property(nonatomic,assign)NSInteger k;//控制

// 这是控制是不是对讲机模式
@property(nonatomic,assign)MessageType Messagetype;
@property(nonatomic,retain)NSMutableDictionary *messageRadioDictionary;
@property(nonatomic,retain)NSMutableArray *keyArr;
@property(nonatomic,retain)NSMutableArray *valueArr;

// 发过来的多语言

@property(nonatomic,retain)NSMutableArray *emiNameArr;
@property(nonatomic,retain)NSMutableArray *emiLanguageArr;

@property(nonatomic,assign)BOOL isSee;

// 这是同意申请的列表

@property(nonatomic,retain)NSMutableArray *agreeList;

// 这是搞收到消息的时间的
@property(nonatomic,assign)float time;
@property(nonatomic,retain)NSMutableArray *talkArr;

@property(nonatomic,assign)BOOL isPlay;

@property(nonatomic,retain)AVAudioPlayer *playert;

@property(nonatomic,retain)NSMutableArray *boolArr;

+ (AppDataManager *)sharedAppDataManager;

-(void)setMessagetype:(MessageType)Messagetype;

- (UIImage *)imageForImageUrlStr:(NSString *)fileUrlStr;
- (NSData *)imageDataForImageUrlStr:(NSString *)fileUrlStr;
- (void)insertData:(id)data forItem:(NSString *)itemName forUid:(NSString *)uid;
- (void)updateData:(id)data forItem:(NSString *)itemName forUid:(NSString *)uid;
- (void)deleteData:(id)data forItem:(NSString *)itemName forUid:(NSString *)uid;
- (void)removeTableNamed:(NSString *)tableName;
- (BOOL)readMoreDataForCurrentDialog:(NSInteger)readNum;
- (void)readTalkList:(NSString *)item;
- (void)updateDialogeListWithSendMsg:(NSDictionary *)aMsg forUid:(NSString *)uid Item:(NSString *)item;
-(void)updateDialogWithMessage:(NSDictionary *)amsg forUid:(NSString *)uid ;
-(NSString *)getTableNameForUid:(NSString *)uid;
-(NSString *)getPar1StrFromDic:(NSDictionary *)parDic;

-(NSString *)IsMinGanWord:(NSString *)input;
-(NSString *)IsInternationalLanguage:(NSString *)input;
-(NSString *)theRevisedName:(NSString*)oldname andUID:(NSString *)uid;

-(BOOL)readmoredataforBall:(NSString *)item;

- (void)sendTextMsg:(NSString *)msg forType:(ChatCellType)type toUid:(NSString *)uid From:(NSString *)from;

- (void)sendTextBall:(NSString *)msg forType:(ChatCellType)type toUid:(NSString *)uid;


//更新数据库
//- (void)updateData:(id)data forItem:(NSString *)itemName forUid:(NSString *)uid;

//重新发送

- (void)sendTextMsg:(NSString *)msg forType:(ChatCellType)type toUid:(NSString *)uid Number:(int)n From:(NSString *)from;


-(NSString *)currentTime:(NSString *)receiveTime;

- (UIImage *)scaleImage:(UIImage *)image proportion:(float)scale ;


// 建立同意列表

-(void)readAgree:(NSString *)userid;

- (void)insertAgreeData:(id)data forItem:(NSString *)itemName forUid:(NSString *)uid;

-(void)updateAgreeData:(id)data forItem:(NSString *)itemName forUid:(NSString *)uid;


// 加载更多

-(BOOL)readMoreTwentyMessage;


-(NSString*)currentTimeBeforeAweek;

-(NSString*)getPreferredLanguage;




@end

@protocol AppDataManagerDelegate <NSObject>

@optional

- (void)appDataManagerDidUpdateDialogs;

@end












