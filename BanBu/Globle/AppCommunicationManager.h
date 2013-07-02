//
//  AppCommunicationManager.h
//  BanBu
//
//  Created by 来国 郑 on 12-7-26.
//  Copyright (c) 2012年 17xy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASIHttprequest.h"
#import "ASIFormDataRequest.h"
#import"ASIProgressDelegate.h"
#import "ASINetworkQueue.h"
#import "BanBuAPIs.h"
#import "AsyncSocket.h"
#import "BanBuRequestDelegate.h"
#import "NSData+Base64.h"
#import "MKNetworkKit.h"
#import "RecordAudio.h"
@class AppDataManager;



#define AppComManager [AppCommunicationManager sharedAppCommunicationManager]

#define SepTimeInterval 3

#define MaxRetryTimes 5
typedef enum
{
    CacheTypeChatImage = 0,
    
    CacheTypeChatAudio
    
} CacheType;

typedef enum {
  NetReachableNone,
  
  NetReachableWifi,
    
  NetReachable3G


}NetStatus;




@protocol BanBuRequestDelegate;

@interface AppCommunicationManager : NSObject<ASIProgressDelegate>{
    BOOL isReach;
}

@property(nonatomic, retain)Reachability *hostReach;
@property(nonatomic, retain)ASINetworkQueue *networkQueue;
@property(nonatomic, retain)AsyncSocket *chatSocket;
@property(nonatomic, assign)NSTimer *receiveMsgTimer;
@property(nonatomic, retain)NSMutableDictionary *receiveInfo;
@property(nonatomic,assign)NetStatus netStatus;
// 这是接受绣球的timer

@property(nonatomic,assign)NSTimer *receiveSingleMsgTimer;

// 这是回调
@property(nonatomic,retain)NSMutableData *receivedata;
@property(nonatomic,assign)id<BanBuRequestDelegate>delegate;

//这是抛绣球的资料
@property(nonatomic,retain)NSMutableDictionary *receiveBallInfo;

+ (AppCommunicationManager *)sharedAppCommunicationManager;
- (BOOL)requestWithNameIsRunning:(NSString *)name;
- (void)cancalHandlesForObject:(id)adelegate;
- (void)cancalHandleNemed:(NSString *)name forObject:(id)adelegate;
- (void)getBanBuData:(NSString *)query par:(NSDictionary *)parDic delegate:(id)adelegate;
- (void)uploadRegAvatarImage:(NSData *)imageData Par:(NSDictionary *)parDic delegate:(id)adelegate;
- (void)getBanBuMedia:(NSString *)mediaUrlStr forMsgID:(NSInteger)msgid fromUid:(NSString *)uid delegate:(id)adelegate;
- (void)uploadBanBuMedia:(NSData *)mediaData mediaName:(NSString *)mediaName par:(NSDictionary *)parDic delegate:(id)adelegate;
- (void)uploadBanBuBroadcastMedia:(NSData *)mediaData mediaName:(NSString *)mediaName par:(NSDictionary *)parDic delegate:(id)adelegate;

- (void)creatChatConnect;
- (void)DisconnectChat;
- (BOOL)respondsDic:(NSDictionary *)dataDic isFunctionData:(NSString *)fc;
- (NSArray *)getMessageDic:(NSDictionary *)sourceDic;
-(NSArray *)getActionDic:(NSDictionary *)sourceDic;
- (NSDictionary *)getAMsgFrom64String:(NSString *)encodedString;

- (void)startReceiveMsgFromUid:(NSString *)uid forDelegate:(id)delegate;
- (void)stopReceiveMsgForUid:(NSString *)uid;
- (void)receiveMsgFromUser:(NSString *)userid delegate:(id)delegate;

- (NSString *)pathForMedia:(NSString *)mediaName;
- (void)uploadSeveralImages:(NSArray *)imageArr delegate:(id)delegate;

//-(void)getBanBuReadMessage:(NSString *)query par:(NSDictionary *)parDic;

// 这是接受绣球的信息
//-(void)startReceiveBallMsgFromUid:(NSString *)uid forDelegate:(id)delegate;
//停止接受的
//-(void)stopReceiveBallMsgForUid:(NSString *)uid;


-(void)startReceiveMsg;


-(void)startReceiveBallMsg;


- (void)getBanBuMedia:(NSString *)mediaUrlStr delegate:(id)adelegate;

-(void)getBanBuData:(NSString *)query par:(NSDictionary *)parDic delegate:(id)adelegate Unlogin:(BOOL)flag;

- (void)receiveMsgFromAll:(NSString *)userid delegate:(id)delegate;

- (NSString *)getPar:(NSString *)parStr;

@end
