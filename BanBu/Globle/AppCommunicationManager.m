//
//  AppCommunicationManager.m
//  BanBu
//
//  Created by 来国 郑 on 12-7-26.
//  Copyright (c) 2012年 17xy. All rights reserved.
//


#import "AppCommunicationManager.h"
#import "CJSONSerializer.h"
#import "GTMBase64.h"
#import "NSDictionary_JSONExtensions.h"
#import <CommonCrypto/CommonDigest.h>
#import "AppDataManager.h"
#import "RecordAudio.h"
#import "BanBu_AppDelegate.h"
#import "Reachability.h"
#import "CJSONDeserializer.h"
#import "BanBu_RefreshTime.h"
#define SERVER_IP @"109.169.66.70"
#define SERVER_PORT 1001
#define GlobleSepTimeInterval  (_netStatus==NetReachableWifi?60:9)
@interface AppCommunicationManager()
{

    NSString *isDeep;
    
    MKNetworkEngine *engine;

}




@end

@implementation AppCommunicationManager

@synthesize networkQueue = _networkQueue;
@synthesize chatSocket = _chatSocket;
//what is this
@synthesize receiveSingleMsgTimer=_receiveSingleMsgTimer;
@synthesize delegate=_delegate;
@synthesize receivedata=_receivedata;
@synthesize receiveBallInfo=_receiveBallInfo;
@synthesize netStatus=_netStatus;

static AppCommunicationManager *sharedAppCommunicationManager = nil;

- (void)initRaysource
{
    [self creatCachePaths];
    _networkQueue = [[ASINetworkQueue alloc] init];
    [_networkQueue setMaxConcurrentOperationCount:6];
    [_networkQueue setShowAccurateProgress:YES];
    [_networkQueue go];
    
    _receivedata=[[NSMutableData alloc]init];
    
    _receiveInfo = [[NSMutableDictionary alloc] initWithCapacity:1];
    
    _receiveBallInfo=[[NSMutableDictionary alloc]initWithCapacity:1];
    
    // 写一个MKNETENG

//    engine=[[MKNetworkEngine alloc]initWithHostName:BanBuHost customHeaderFields:nil];
    


    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reachabilityChanged:)
                                                 name: kReachabilityChangedNotification
                                               object: nil];
    self.hostReach = [Reachability reachabilityWithHostname:@"www.baidu.com"];
    [_hostReach startNotifier];

}
- (void)reachabilityChanged:(NSNotification *)note {
    Reachability* curReach = [note object];
    
    
    //有的方法的条件可以满足可以不满足，都不影响执行。但如果你希望程序在某些条件不满足的时候产生错误告诉你，就用nsparameterassert让程序崩溃。
    
    NSParameterAssert([curReach isKindOfClass: [Reachability class]]);
    
    NetworkStatus status = [curReach currentReachabilityStatus];
    
    // 判断是不是3G Wifi 还是没有网络
    _netStatus=(int)status;
    NSLog(@"%d",_netStatus);
    if (status == NotReachable && !isReach) {
        isReach = YES;
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"network_unavailabel", nil) message:nil delegate:nil cancelButtonTitle:NSLocalizedString(@"confirmNotice", nil) otherButtonTitles: nil];
        [alertView show];
        [alertView release];
        if(_receiveMsgTimer)
        {
            [_receiveMsgTimer invalidate];
            
            _receiveMsgTimer = nil;
        }
    }
    else
    {
        NSInteger total = 0;
        for(NSDictionary *aTalk in MyAppDataManager.talkPeoples)
        {
            total += [VALUE(KeyUnreadNum, aTalk) integerValue];
            
            if([[aTalk valueForKey:@"userid"] intValue]<1000)
            {
                
                // 不需要了因为他们都是在一个navi
                //  [MyAppDelegate updateBadgeFriend:VALUE(KeyUnreadNum, aTalk)];
                
            }
        }
        NSLog(@"%d",total);
        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithObjectsAndKeys:MyAppDataManager.useruid,@"loginid",[NSString stringWithFormat:@"%d",total],@"pushcount",nil];
        [AppComManager getBanBuData:Banbu_Set_User_Pushcount par:dic delegate:self];
        
        isReach = NO;
        // 判断网络是WIFI 还是3g
        if([_receiveInfo count])
        {
            if(_receiveMsgTimer)
            {
                [_receiveMsgTimer invalidate];
                _receiveMsgTimer = nil;
            }
            _receiveMsgTimer = [NSTimer scheduledTimerWithTimeInterval:SepTimeInterval
                                                                target:self
                                                              selector:@selector(receviceMsg)
                                                              userInfo:nil
                                                               repeats:YES];
            
            [[NSRunLoop currentRunLoop] addTimer:_receiveMsgTimer forMode:NSDefaultRunLoopMode];
            
        }
    }
    //这是抛绣球的接受
    
//    if([_receiveBallInfo count])
//    {
//        if([_receiveSingleMsgTimer isValid])
//        {
//            [_receiveSingleMsgTimer invalidate];
//            
//            _receiveSingleMsgTimer=nil;
//            
//        }
//        
//        _receiveSingleMsgTimer=[NSTimer scheduledTimerWithTimeInterval:SepTimeInterval target:self selector:@selector(receiveBallMsg) userInfo:nil repeats:YES];
//        
//        
//        [[NSRunLoop currentRunLoop] addTimer:_receiveSingleMsgTimer forMode:NSDefaultRunLoopMode];
//    }
    
    
}

// 接受全局的网络绣球

-(void)receiveBallMsg
{
     //NSLog(@"receviceBallMsg");
    NSInteger counter = [[_receiveBallInfo valueForKey:@"counter"] integerValue];
    
    counter ++;
    
    NSString *fromUid = [_receiveBallInfo valueForKey:@"fromUid"];
    
    if(fromUid)
    {
        [self receiveBallFromUser:fromUid delegate:[_receiveBallInfo valueForKey:@"singleDelegate"]];
    }
    if(counter > GlobleSepTimeInterval/SepTimeInterval&&!fromUid)
    {
        //NSLog(@"receiveSingleBallMsg%@",_receiveBallInfo);
        
        counter = 0;
        
        [self receiveBallFromUser:nil delegate:[_receiveBallInfo valueForKey:@"globleDelegate"]];
    }
    
    [_receiveBallInfo setValue:[NSNumber numberWithInteger:counter] forKey:@"counter"];
    
    

}

- (void)receiveBallFromUser:(NSString *)userid delegate:(id)delegate     //如果userid为空，则为接收全局消息
{
    NSString *query = !userid?BanBu_ReceiveBallList:BanBu_ReceiveBallMessage;
    NSString *requestUrlStr = [BanBuHost_Chat stringByAppendingString:query];
    
    NSMutableDictionary *pars = [NSMutableDictionary dictionaryWithCapacity:1];
    [pars setValue:[self getPar:query] forKey:@"fc"];
    [pars setValue:MyAppDataManager.loginid forKey:@"loginid"];
    
     // 这是接受信息

    if(userid)
    {
        [pars setValue:userid forKey:@"fromuid"];
    }
    NSString *jsonfrom = [[CJSONSerializer serializer] serializeDictionary:pars];
    
    jsonfrom = [[jsonfrom dataUsingEncoding:NSUTF8StringEncoding] base64EncodedString];
    
    requestUrlStr = [requestUrlStr stringByAppendingString:jsonfrom];
    
    MKNetworkOperation *op = [[[MKNetworkOperation alloc] initWithURLString:requestUrlStr params:nil httpMethod:@"GET"] autorelease];
    
    __block typeof(delegate)blockDelegate = delegate;
    
    [op onCompletion:^(MKNetworkOperation *completedOperation)
     {
         if([blockDelegate respondsToSelector:@selector(banbuRequestDidFinished:error:)])
         {
             NSString *resStr = [completedOperation.responseString stringByTrimmingCharactersInSet:[NSCharacterSet controlCharacterSet]];
             NSError *error = nil;
             
             
             if(!resStr.length)
             {
                 error = [NSError errorWithDomain:BanBuDataformatError code:123 userInfo:[NSDictionary dictionaryWithObjectsAndKeys:query,@"fc",@"网络无响应",@"requestid",nil]];
                 [blockDelegate banbuRequestDidFinished:nil error:error];
                 return;
             }
            
             NSData *resFrom64 = [NSData dataFromBase64String:resStr];
             NSMutableDictionary *respondsDic = [NSMutableDictionary dictionaryWithDictionary:[NSDictionary dictionaryWithJSONData:resFrom64 error:&error]];
             //   [respondsDic setValue:[pars valueForKey:@"msgid"] forKey:@"requestid"];
             
             [blockDelegate banbuRequestDidFinished:respondsDic error:error];
             
         }
         
     }onError:^(NSError* error) {
         if([blockDelegate respondsToSelector:@selector(banbuRequestDidFinished:error:)])
         {
             NSError *aerror = (NSError *)error;
             NSError *error = [NSError errorWithDomain:aerror.domain
                                                  code:aerror.code
                                              userInfo:[NSDictionary dictionaryWithObjectsAndKeys:query,@"fc",@"请求失败",@"requestid",nil]];
             [blockDelegate banbuRequestDidFinished:nil error:error];
         }
     }];
    
    [op start];
}

- (void)creatCachePaths
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *cachePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"ImageCache"];
    NSArray *cachePaths = [NSArray arrayWithObjects:[cachePath stringByAppendingPathComponent:@"ChatImage"],[cachePath stringByAppendingPathComponent:@"ChatAudio"],nil];
    
    for(NSString *path in cachePaths)
    {
        if (![[NSFileManager defaultManager] fileExistsAtPath:path])
        {
            [[NSFileManager defaultManager] createDirectoryAtPath:path
                                      withIntermediateDirectories:YES
                                                       attributes:nil
                                                            error:NULL];
        }
    }
}

+ (AppCommunicationManager *)sharedAppCommunicationManager;
{
    @synchronized(self){
        if(sharedAppCommunicationManager == nil){
            sharedAppCommunicationManager = [[[self alloc] init] autorelease];
            [sharedAppCommunicationManager initRaysource];
       }
    }
    return sharedAppCommunicationManager;
}

+(id)allocWithZone:(NSZone *)zone{
    @synchronized(self){
        if (sharedAppCommunicationManager == nil) {
            sharedAppCommunicationManager = [super allocWithZone:zone];
            return  sharedAppCommunicationManager;
        }
    }
    return nil;
}

- (NSString *)getPar:(NSString *)parStr
{
    NSInteger start = [parStr rangeOfString:@"/" options:NSBackwardsSearch].location+2;
    NSInteger end = [parStr rangeOfString:@".php?" options:NSBackwardsSearch].location;
    return [parStr substringWithRange:NSMakeRange(start, end-start)];
    
}

- (BOOL)respondsDic:(NSDictionary *)dataDic isFunctionData:(NSString *)fc
{
    NSString *fcKey = [self getPar:fc];
    return [[dataDic valueForKey:@"fc"] isEqualToString:fcKey];
}


- (void)getBanBuData:(NSString *)query par:(NSDictionary *)parDic delegate:(id)adelegate
{
    
   
    
    NSString *requestUrlStr;
//    if([query isEqualToString:BanBu_Get_Server_List]){
//        requestUrlStr = [BanBuHost stringByAppendingString:query];
//    }else{
    requestUrlStr = [BanBuHost_Data stringByAppendingString:query];
//    }
    NSMutableDictionary *pars = [NSMutableDictionary dictionaryWithDictionary:parDic];
  
    if([query isEqualToString:BanBu_SendMessage_To_Server]||[query isEqual:BanBu_SendBall_To_User])
    {
        NSDictionary *says = [parDic valueForKey:@"says"];
        NSString *jsonValue = [[CJSONSerializer serializer] serializeDictionary:says];
        jsonValue = [[jsonValue dataUsingEncoding:NSUTF8StringEncoding] base64EncodedString];
        [pars setValue:jsonValue forKey:@"says"];
        [pars removeObjectForKey:@"msgid"];
    }
    if([query isEqualToString:BanBu_Send_Broadcast] || [query isEqualToString:BanBu_SendBall_To_Area] ||[query isEqualToString:BanBu_Reply_Broadcast]){
        NSDictionary *says = [parDic objectForKey:@"says"];
        NSString *jsonValue = [[CJSONSerializer serializer] serializeDictionary:says];
        jsonValue = [[jsonValue dataUsingEncoding:NSUTF8StringEncoding] base64EncodedString];
        [pars setValue:jsonValue forKey:@"says"];
        
    }

    [pars setValue:[self getPar:query] forKey:@"fc"];
   
    [pars setValue:MyAppDataManager.loginid forKey:@"loginid"];
    
    NSString *jsonfrom = [[CJSONSerializer serializer] serializeDictionary:pars];
    
    
    jsonfrom = [[jsonfrom dataUsingEncoding:NSUTF8StringEncoding] base64EncodedString];
    requestUrlStr = [requestUrlStr stringByAppendingString:jsonfrom];
    NSLog(@"%@----%@",[self getPar:query],requestUrlStr);
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:requestUrlStr]];
    request.delegate = adelegate;
    [request setRequestMethod:@"GET"];

    __block typeof(adelegate)blockDelegate = adelegate;
    
    [request setFailedBlock:^{
        if([blockDelegate respondsToSelector:@selector(banbuRequestDidFinished:error:)])
        {
            NSMutableDictionary *respondsDic = [NSMutableDictionary dictionaryWithCapacity:1];
            [respondsDic setValue:[parDic valueForKey:@"touid"] forKey:KeyUid];
            [respondsDic setValue:query forKey:@"fc"];
            [respondsDic setValue:[parDic valueForKey:@"msgid"] forKey:@"requestid"];

            NSError *error = [NSError errorWithDomain:request.error.domain code:request.error.code userInfo:respondsDic];
//            NSLog(@"%@----%@",respondsDic,error);
            [blockDelegate banbuRequestDidFinished:respondsDic error:error];
        }
    }];
    [request setCompletionBlock:^{

        if([blockDelegate respondsToSelector:@selector(banbuRequestDidFinished:error:)])
        {
            NSMutableDictionary *respondsDic = [NSMutableDictionary dictionaryWithCapacity:1];
            [respondsDic setValue:[parDic valueForKey:@"touid"] forKey:KeyUid];
            [respondsDic setValue:query forKey:@"fc"];
            [respondsDic setValue:[parDic valueForKey:@"msgid"] forKey:@"requestid"];

            NSString *resStr = [request.responseString stringByTrimmingCharactersInSet:[NSCharacterSet controlCharacterSet]];

            NSError *error = nil;
            if(!resStr.length)
            {
                error = [NSError errorWithDomain:BanBuDataformatError code:123 userInfo:respondsDic];
                [blockDelegate banbuRequestDidFinished:nil error:error];
                return;
            }
            NSData *resFrom64 = [NSData dataFromBase64String:resStr];
//            NSLo g(@"%@",resStr);
//            NSLog(@"%@",[NSDictionary dictionaryWithJSONData:resFrom64 error:&error]);
//            NSLog(@"%@",resStr);
            [respondsDic addEntriesFromDictionary:[NSDictionary dictionaryWithJSONData:resFrom64 error:&error]];
//            NSLog(@"%@",MyAppDataManager.loginid);
            if([[respondsDic valueForKey:@"error"] isEqualToString:@"__loginidinvalid__"])
            {
                [MyAppDelegate goToLogin:[MyAppDataManager  IsInternationalLanguage:@"__loginidinvalid__"]];
                [blockDelegate banbuRequestDidFinished:respondsDic error:error];

            }else{
                // 国际化语言包
//                NSLog(@"%@",query);
                
                if([query isEqualToString:BanBu_Get_Friend_FriendDo] || [query isEqualToString:BanBu_Get_Friend_FriendDos] || [query isEqualToString:BanBu_Get_User_Neardo]|| [query isEqualToString:BanBu_Get_Broadcast] ){
                    
                    if([MyAppDataManager.languageDictionary allValues].count == 0){
                        NSString *langugagePath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]stringByAppendingPathComponent:@"InterNationalanguage"];
                        [MyAppDataManager.languageDictionary removeAllObjects];
                        [MyAppDataManager.languageDictionary setDictionary:[NSKeyedUnarchiver unarchiveObjectWithData:[NSData dataWithContentsOfFile:langugagePath]]];
                     }
                    NSString *string=[[[NSString alloc]initWithData:resFrom64 encoding:NSUTF8StringEncoding] autorelease];
                    
                    string =[MyAppDataManager  IsInternationalLanguage:string];
//                    NSLog(@"%@",string);
                    resFrom64=[string dataUsingEncoding:NSUTF8StringEncoding];
//                    NSLog(@"%@",resFrom64);
                    [respondsDic addEntriesFromDictionary:[NSDictionary dictionaryWithJSONData:resFrom64 error:&error]];
                    
                }
                
               
                
                [blockDelegate banbuRequestDidFinished:respondsDic error:error];
            }
            
            
        }
    }];
    
    
    [_networkQueue addOperation:request];
  
}

-(void)getBanBuData:(NSString *)query par:(NSDictionary *)parDic delegate:(id)adelegate Unlogin:(BOOL)flag
{
    NSString *requestUrlStr = [BanBuHost_Data stringByAppendingString:query];
//    NSLog(@"%@",requestUrlStr);
    NSMutableDictionary *pars = [NSMutableDictionary dictionaryWithDictionary:parDic];
    
    [pars setValue:[self getPar:query] forKey:@"fc"];
   
    NSString *jsonfrom = [[CJSONSerializer serializer] serializeDictionary:pars];
    
    jsonfrom = [[jsonfrom dataUsingEncoding:NSUTF8StringEncoding] base64EncodedString];
    requestUrlStr = [requestUrlStr stringByAppendingString:jsonfrom];
   
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:requestUrlStr]];
    request.delegate = adelegate;
    [request setRequestMethod:@"GET"];
    
    __block typeof(adelegate)blockDelegate = adelegate;
    
    [request setFailedBlock:^{
        if([blockDelegate respondsToSelector:@selector(banbuRequestDidFinished:error:)])
        {
            NSMutableDictionary *respondsDic = [NSMutableDictionary dictionaryWithCapacity:1];
            [respondsDic setValue:[parDic valueForKey:@"touid"] forKey:KeyUid];
            [respondsDic setValue:query forKey:@"fc"];
            [respondsDic setValue:[parDic valueForKey:@"msgid"] forKey:@"requestid"];
            
            NSError *error = [NSError errorWithDomain:request.error.domain code:request.error.code userInfo:respondsDic];
            [blockDelegate banbuRequestDidFinished:nil error:error];
        }
    }];
    [request setCompletionBlock:^{
        
        if([blockDelegate respondsToSelector:@selector(banbuRequestDidFinished:error:)])
        {
            NSMutableDictionary *respondsDic = [NSMutableDictionary dictionaryWithCapacity:1];
            [respondsDic setValue:[parDic valueForKey:@"touid"] forKey:KeyUid];
            [respondsDic setValue:query forKey:@"fc"];
            [respondsDic setValue:[parDic valueForKey:@"msgid"] forKey:@"requestid"];
            
            NSString *resStr = [request.responseString stringByTrimmingCharactersInSet:[NSCharacterSet controlCharacterSet]];
            
            NSError *error = nil;
            if(!resStr.length)
            {
                error = [NSError errorWithDomain:BanBuDataformatError code:123 userInfo:respondsDic];
                [blockDelegate banbuRequestDidFinished:nil error:error];
                return;
            }
            NSData *resFrom64 = [NSData dataFromBase64String:resStr];
            
            [respondsDic addEntriesFromDictionary:[NSDictionary dictionaryWithJSONData:resFrom64 error:&error]];
            if([[respondsDic valueForKey:@"error"] isEqualToString:@"__loginidinvalid__"])
            {
                
                              
            }else{
                // 国际化语言包
                
                
                
                if([MyAppDataManager.languageDictionary allValues].count == 0){
                    NSString *langugagePath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]stringByAppendingPathComponent:@"InterNationalanguage"];
                    [MyAppDataManager.languageDictionary removeAllObjects];
                    [MyAppDataManager.languageDictionary setDictionary:[NSKeyedUnarchiver unarchiveObjectWithData:[NSData dataWithContentsOfFile:langugagePath]]];
                }
                
                NSString *string=[[[NSString alloc]initWithData:resFrom64 encoding:NSUTF8StringEncoding] autorelease];
                
                string =[MyAppDataManager  IsInternationalLanguage:string];
                
                resFrom64=[string dataUsingEncoding:NSUTF8StringEncoding];
                
                [respondsDic addEntriesFromDictionary:[NSDictionary dictionaryWithJSONData:resFrom64 error:&error]];
                
                [blockDelegate banbuRequestDidFinished:respondsDic error:error];
            }
            
            
        }
    }];
    
    
    [_networkQueue addOperation:request];
    
}

    
- (void)uploadRegAvatarImage:(NSData *)imageData Par:(NSDictionary *)parDic delegate:(id)adelegate;
{
    NSString *requestUrlStr = [BanBuHost_File stringByAppendingString:BanBu_Set_User_Avatar];
    NSMutableDictionary *pars = [NSMutableDictionary dictionaryWithDictionary:parDic];
    [pars setValue:[self getPar:BanBu_Set_User_Avatar] forKey:@"fc"];
//    [pars setValue:MyAppDataManager.loginid forKey:@"loginid"];
    NSString *encodedStr = [imageData base64EncodedString];
    [pars setValue:encodedStr forKey:@"photofile"];
    NSString *jsonfrom = [[CJSONSerializer serializer] serializeDictionary:pars];

    jsonfrom = [[jsonfrom dataUsingEncoding:NSUTF8StringEncoding] base64EncodedString];

    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:requestUrlStr]];
    request.delegate = adelegate;
  
    [request setPostValue:jsonfrom forKey:@"jsonfrom"];
    
    __block typeof(adelegate)blockDelegate = adelegate;

    
    [request setFailedBlock:^{
       

        if([blockDelegate respondsToSelector:@selector(banbuRequestDidFinished:error:)])
        {
            [blockDelegate banbuRequestDidFinished:nil error:request.error];
        }
    }];
    [request setCompletionBlock:^{
        
        if([blockDelegate respondsToSelector:@selector(banbuRequestDidFinished:error:)])
        {
             NSString *resStr = [request.responseString stringByTrimmingCharactersInSet:[NSCharacterSet controlCharacterSet]];
//            NSLog(@"res:%@",resStr);
            NSError *error = nil;
            if(!resStr.length)
            {
//                NSLog(@"上传失败原因----%@",error);
                error = [NSError errorWithDomain:BanBuDataformatError code:123 userInfo:nil];
                [blockDelegate banbuRequestDidFinished:nil error:error];
                return;
            }
            NSData *resFrom64 = [NSData dataFromBase64String:resStr];
            NSDictionary *respondsDic = [NSDictionary dictionaryWithJSONData:resFrom64 error:&error];
            [blockDelegate banbuRequestDidFinished:respondsDic error:error];
        }
    }];
    
    [_networkQueue addOperation:request];
    
}
- (void)uploadOneImages:(NSArray *)imageArr delegate:(id)delegate{
    
}
- (void)uploadSeveralImages:(NSArray *)imageArr delegate:(id)delegate
{
    ASINetworkQueue *uploadQueue = [[ASINetworkQueue alloc] init];
    uploadQueue.delegate = self;
    NSDictionary *userInfo = [NSDictionary dictionaryWithObject:delegate forKey:@"adelegate"];
    uploadQueue.userInfo = userInfo;
    [uploadQueue setQueueDidFinishSelector:@selector(uploadFinished:)];
    [uploadQueue setMaxConcurrentOperationCount:2];
    [uploadQueue setShowAccurateProgress:YES];
    [uploadQueue go];
    
    for(int i=0; i<imageArr.count; i++)
    {
        UIImage *image = [imageArr objectAtIndex:i];
        NSString *imagePathExtension = @"jpg";
        NSData *imageData ;

            imageData = UIImageJPEGRepresentation(image, 0.7);

        NSLog(@"%d",imageData.length);
        NSString *requestUrlStr = [BanBuHost_File stringByAppendingString:BanBu_Set_User_Avatar];
        NSMutableDictionary *pars = [NSMutableDictionary dictionary];
        [pars setValue:@"y" forKey:@"phone"];
        [pars setValue:imagePathExtension forKey:@"picformat"];
        [pars setValue:[self getPar:BanBu_Set_User_Avatar] forKey:@"fc"];
        [pars setValue:MyAppDataManager.loginid forKey:@"loginid"];
        NSString *encodedStr = [imageData base64EncodedString];
        [pars setValue:encodedStr forKey:@"photofile"];
//        NSLog(@"%@",pars);
        NSString *jsonfrom = [[CJSONSerializer serializer] serializeDictionary:pars];
        jsonfrom = [[jsonfrom dataUsingEncoding:NSUTF8StringEncoding] base64EncodedString];
        ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:requestUrlStr]];
        [request setPostValue:jsonfrom forKey:@"jsonfrom"];
        
        [request setFailedBlock:^{
            
            NSMutableDictionary *userInfo = [NSMutableDictionary dictionaryWithDictionary:uploadQueue.userInfo];
            NSInteger failNum = [[userInfo valueForKey:@"failNum"] integerValue];
            failNum ++;
            [userInfo setValue:[NSNumber numberWithInteger:failNum] forKey:@"failNum"];
            uploadQueue.userInfo = userInfo;
            
        }];
        [request setCompletionBlock:^{
            
            NSMutableDictionary *userInfo = [NSMutableDictionary dictionaryWithDictionary:uploadQueue.userInfo];
            NSString *resStr = [request.responseString stringByTrimmingCharactersInSet:[NSCharacterSet controlCharacterSet]];
            if(resStr.length)
            {
                NSData *resFrom64 = [NSData dataFromBase64String:resStr];
//                NSLog(@"%@",resStr);
                NSDictionary *respondsDic = [NSDictionary dictionaryWithJSONData:resFrom64 error:nil];
//                NSLog(@"%@",respondsDic);
                if([[respondsDic valueForKey:@"ok"] boolValue])
                {
                    NSInteger successNum = [[userInfo valueForKey:@"c"] integerValue];
                    successNum ++;
                    [userInfo setValue:[NSNumber numberWithInteger:successNum] forKey:@"successNum"];
                    [userInfo setValue:[respondsDic valueForKey:@"facelist"] forKey:@"facelist"];
                    uploadQueue.userInfo = userInfo;
                    return;
                }
            }
            NSInteger failNum = [[userInfo valueForKey:@"failNum"] integerValue];
            failNum ++;
            [userInfo setValue:[NSNumber numberWithInteger:failNum] forKey:@"failNum"];
            uploadQueue.userInfo = userInfo;
            
        }];
        [uploadQueue addOperation:request];
    }
}

- (void)getBanBuMedia:(NSString *)mediaUrlStr delegate:(id)adelegate
{
    NSString *savePath = [self pathForMedia:mediaUrlStr];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:mediaUrlStr]];
    [request setAllowResumeForFileDownloads:NO];
    [request setDownloadDestinationPath:savePath];
    request.delegate = adelegate;
    request.username = @"playvoice";

    [request setFailedBlock:^{
    
        if([adelegate respondsToSelector:@selector(removeTk)])
        {
            [adelegate removeTk];
        
        }else if([adelegate respondsToSelector:@selector(banbuDownloadRequest:didFinishedWithError:)])
        {
            [ASIHTTPRequest removeFileAtPath:savePath error:nil];
            NSMutableDictionary *respondsDic = [NSMutableDictionary dictionaryWithObject:request.username forKey:@"requestname"];
            [respondsDic setValue:@"n" forKey:@"ok"];
            
            //            [respondsDic setValue:uid forKey:KeyUid];
            [adelegate banbuDownloadRequest:respondsDic didFinishedWithError:request.error];
        }

        
        
    }];
    
    [request setCompletionBlock:^{
        
        if([adelegate respondsToSelector:@selector(reload)])
        {
            
            [adelegate reload];
            
        }else if ([adelegate respondsToSelector:@selector(seeBigPic)])
        {
            [adelegate seeBigPic];
        
        }else if([adelegate respondsToSelector:@selector(banbuDownloadRequest:didFinishedWithError:)])
        {
            if([[mediaUrlStr pathExtension] isEqualToString:@"amr"])
            {
                NSData *audioData = [RecordAudio decodeAMRToWav:savePath];
                [FileManager createFileAtPath:savePath contents:audioData attributes:nil];
            }
            
            NSMutableDictionary *respondsDic = [NSMutableDictionary dictionaryWithObject:request.username forKey:@"requestname"];
            //            [respondsDic setValue:uid forKey:KeyUid];
            [respondsDic setValue:@"y" forKey:@"ok"];
            [adelegate banbuDownloadRequest:respondsDic didFinishedWithError:nil];
        }
        
        
    }];
    
    
    [_networkQueue addOperation:request];
    
}
- (void)getBanBuMedia:(NSString *)mediaUrlStr forMsgID:(NSInteger)msgid fromUid:(NSString *)uid delegate:(id)adelegate
{
    NSString *savePath = [self pathForMedia:mediaUrlStr];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:mediaUrlStr]];
    
    [request setAllowResumeForFileDownloads:NO];
    [request setDownloadDestinationPath:savePath];
    request.delegate = adelegate;
    request.username = [NSString stringWithFormat:@"%i-%@",msgid,mediaUrlStr];
    
    __block typeof(adelegate)blockDelegate = adelegate;
    
    [request setDownloadSizeIncrementedBlock:^(long long size) {
        request.totalBytesSent = request.totalBytesRead;
    }];
    
    [request setBytesReceivedBlock:^(unsigned long long size, unsigned long long total)
     {

         if([blockDelegate respondsToSelector:@selector(banbuRequestNamed:uploadDataProgress:)])
         {
             [blockDelegate banbuRequestNamed:request.username downloadDataProgress:(float)(request.totalBytesRead-request.totalBytesSent)/(total-request.totalBytesSent)];
         }
         
     }];
    
    
    [request setFailedBlock:^{
        
        if([blockDelegate respondsToSelector:@selector(banbuDownloadRequest:didFinishedWithError:)])
        {
            [ASIHTTPRequest removeFileAtPath:savePath error:nil];
            NSMutableDictionary *respondsDic = [NSMutableDictionary dictionaryWithObject:request.username forKey:@"requestname"];
            [respondsDic setValue:uid forKey:KeyUid];
            [blockDelegate banbuDownloadRequest:respondsDic didFinishedWithError:request.error];
        }
    }];
    [request setCompletionBlock:^{
        float time=0.f;
        if([blockDelegate respondsToSelector:@selector(banbuDownloadRequest:didFinishedWithError:)])
        {
            if([[mediaUrlStr pathExtension] isEqualToString:@"amr"])
            {
                NSData *audioData = [RecordAudio decodeAMRToWav:savePath];
                if(audioData){
                [FileManager createFileAtPath:savePath contents:audioData attributes:nil];
            
                    RecordAudio *recod=[[[RecordAudio alloc]init] autorelease];
                    
                     time = [recod playDuration:audioData];
                    
                }
            }
            NSMutableDictionary *respondsDic = [NSMutableDictionary dictionaryWithObject:request.username forKey:@"requestname"];
            [respondsDic setValue:uid forKey:KeyUid];
            [respondsDic setValue:@"y" forKey:@"ok"];
            
            [respondsDic setValue:[NSNumber numberWithFloat:time ] forKey:@"time"];
            [blockDelegate banbuDownloadRequest:respondsDic didFinishedWithError:nil];
        }
    }];
    [_networkQueue addOperation:request];
}

- (void)uploadBanBuMedia:(NSData *)mediaData mediaName:(NSString *)mediaName par:(NSDictionary *)parDic delegate:(id)adelegate
{
    RecordAudio *recod=[[RecordAudio alloc]init];
    
    float time = [recod playDuration:mediaData];

    NSString *requestUrlStr = [BanBuHost_File stringByAppendingString:BanBu_UploadFile_To_Server];
    NSMutableDictionary *pars = [NSMutableDictionary dictionaryWithDictionary:parDic];
    [pars setValue:[self getPar:BanBu_UploadFile_To_Server] forKey:@"fc"];
    NSString *encodedStr = [mediaData base64EncodedString];
    [pars setValue:encodedStr forKey:@"sfile"];
    [pars setValue:MyAppDataManager.loginid forKey:@"loginid"];
    
    [pars setValue:@"chat" forKey:@"filefor"];
    
    
    

    NSString *jsonfrom = [[CJSONSerializer serializer] serializeDictionary:pars];
    jsonfrom = [[jsonfrom dataUsingEncoding:NSUTF8StringEncoding] base64EncodedString];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:requestUrlStr]];
    [request setRequestMethod:@"POST"];
    [request setShowAccurateProgress:YES];
    [request addPostValue:jsonfrom forKey:@"jsonfrom"];
    request.delegate = self;
    request.username = mediaName;
    
    __block typeof(adelegate)blockDelegate = adelegate;
    NSString *chatUid = [parDic valueForKey:KeyUid];
    [request setUploadSizeIncrementedBlock:^(long long size) {
        request.totalBytesRead = request.totalBytesSent;
    }];
    
    [request setBytesSentBlock:^(unsigned long long size, unsigned long long total)
     {
         if([blockDelegate respondsToSelector:@selector(banbuRequestNamed:uploadDataProgress:)])
         {
             [blockDelegate banbuRequestNamed:request.username uploadDataProgress:(float)(request.totalBytesSent-request.totalBytesRead)/(total-request.totalBytesRead)];
         }
         
     }];
    
    [request setFailedBlock:^{
        
        if([blockDelegate respondsToSelector:@selector(banbuUploadRequest:didFinishedWithError:)])
        {
             NSMutableDictionary *respondsDic = [NSMutableDictionary dictionaryWithObject:request.username forKey:@"requestname"];
            [respondsDic setValue:chatUid forKey:KeyUid]; 
            [blockDelegate banbuUploadRequest:respondsDic didFinishedWithError:request.error];
        }
    }];
    [request setCompletionBlock:^{
        
                
        if([blockDelegate respondsToSelector:@selector(banbuUploadRequest:didFinishedWithError:)])
        {
            NSString *resStr = [request.responseString stringByTrimmingCharactersInSet:[NSCharacterSet controlCharacterSet]];
            NSError *error = nil;
            NSString *media = [[mediaName pathExtension] isEqualToString:@"amr"]?@"sound":@"image";
            NSMutableDictionary *respondsDic = [NSMutableDictionary dictionaryWithObject:request.username forKey:@"requestname"];
            [respondsDic setValue:[parDic valueForKey:KeyShowFrom] forKey:KeyShowFrom];
            [respondsDic setValue:chatUid forKey:KeyUid];

            if(!resStr.length)
            {
                error = [NSError errorWithDomain:BanBuDataformatError code:123 userInfo:nil];
                [blockDelegate banbuUploadRequest:respondsDic didFinishedWithError:error];

                return;
            }
            
            NSData *resFrom64 = [NSData dataFromBase64String:resStr];
            [respondsDic setValue:media forKey:@"mediatype"];
            [respondsDic addEntriesFromDictionary:[NSDictionary dictionaryWithJSONData:resFrom64 error:&error]];

            if(![[respondsDic valueForKey:@"ok"] boolValue])
            {
                return;
            }
            
            [respondsDic setValue:@"mo" forKey:KeyShowFrom];
            if([media isEqualToString:@"image"])
                [FileManager createFileAtPath:[self pathForMedia:[respondsDic valueForKey:@"fileurl"]] contents:mediaData attributes:nil];
            else
            {
                NSString *oldAudioPath = [self pathForMedia:mediaName];
                [FileManager moveItemAtPath:oldAudioPath toPath:[self pathForMedia:[respondsDic valueForKey:@"fileurl"]] error:nil];
            }
            
           // 将时间传过去
            
            [respondsDic setValue:[NSNumber numberWithFloat:time] forKey:@"time"];
            
            [blockDelegate banbuUploadRequest:respondsDic didFinishedWithError:error];
        }
    }];
    
    [_networkQueue addOperation:request];
}

- (void)uploadBanBuBroadcastMedia:(NSData *)mediaData mediaName:(NSString *)mediaName par:(NSDictionary *)parDic delegate:(id)adelegate{
    
    NSString *requestUrlStr = [BanBuHost_File stringByAppendingString:BanBu_UploadFile_To_Server];
    NSMutableDictionary *pars = [NSMutableDictionary dictionaryWithDictionary:parDic];
    [pars setValue:[self getPar:BanBu_UploadFile_To_Server] forKey:@"fc"];
    NSString *encodedStr = [mediaData base64EncodedString];
    [pars setValue:encodedStr forKey:@"sfile"];
    [pars setValue:@"action" forKey:@"filefor"];
    [pars setValue:MyAppDataManager.loginid forKey:@"loginid"];
    NSString *jsonfrom = [[CJSONSerializer serializer] serializeDictionary:pars];
    jsonfrom = [[jsonfrom dataUsingEncoding:NSUTF8StringEncoding] base64EncodedString];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:requestUrlStr]];
    [request setRequestMethod:@"POST"];
    [request setShowAccurateProgress:YES];
    [request addPostValue:jsonfrom forKey:@"jsonfrom"];
    request.delegate = self;
    request.username = mediaName;
    
    __block typeof(adelegate)blockDelegate = adelegate;
    
    
    [request setFailedBlock:^{
        
        if([blockDelegate respondsToSelector:@selector(banbuUploadRequest:didFinishedWithError:)])
        {
            NSMutableDictionary *respondsDic = [NSMutableDictionary dictionaryWithObject:request.username forKey:@"requestname"];
            [blockDelegate banbuUploadRequest:respondsDic didFinishedWithError:request.error];
        }
    }];
    
    [request setCompletionBlock:^{
        
        if([blockDelegate respondsToSelector:@selector(banbuUploadRequest:didFinishedWithError:)])
        {
            NSString *resStr = [request.responseString stringByTrimmingCharactersInSet:[NSCharacterSet controlCharacterSet]];
            NSError *error = nil;
            NSMutableDictionary *respondsDic = [NSMutableDictionary dictionaryWithObject:request.username forKey:@"requestname"];
            
            if(!resStr.length)
            {
                error = [NSError errorWithDomain:BanBuDataformatError code:123 userInfo:nil];
                [blockDelegate banbuUploadRequest:respondsDic didFinishedWithError:error];
                
                return;
            }
            
            NSData *resFrom64 = [NSData dataFromBase64String:resStr];
            [respondsDic addEntriesFromDictionary:[NSDictionary dictionaryWithJSONData:resFrom64 error:&error]];
            [blockDelegate banbuUploadRequest:respondsDic didFinishedWithError:error];
        }
    }];
    
    [_networkQueue addOperation:request];
}

- (BOOL)requestWithNameIsRunning:(NSString *)name
{
    for(ASIHTTPRequest *request in _networkQueue.operations)
    {
        if(request.username == name)
        {
            return YES;
        }
    }

    return NO;
}

- (void)cancalHandlesForObject:(id)adelegate
{
    for(ASIHTTPRequest *request in _networkQueue.operations)
    {
        if(request.delegate == adelegate)
        {
            [request clearDelegatesAndCancel];
        }
    }
}

- (void)cancalHandleNemed:(NSString *)name forObject:(id)adelegate
{
    for(ASIHTTPRequest *request in _networkQueue.operations)
    {
        if(request.delegate == adelegate && [request.username isEqualToString:name])
        {
            [request clearDelegatesAndCancel];
        }
    }

}

- (NSString *)pathForMedia:(NSString *)mediaName
{
    const char *str = [mediaName UTF8String];
    unsigned char r[CC_MD5_DIGEST_LENGTH];
    CC_MD5(str, (CC_LONG)strlen(str), r);
    NSString *filename = [NSString stringWithFormat:@"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
                          r[0], r[1], r[2], r[3], r[4], r[5], r[6], r[7], r[8], r[9], r[10], r[11], r[12], r[13], r[14], r[15]];
//    NSArray *typeArr = [NSArray arrayWithObjects:@"ChatImage",@"ChatAudio", nil];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *cachePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"ImageCache"];
//    CacheType type = [[mediaName pathExtension] isEqualToString:@"amr"]?CacheTypeChatAudio:CacheTypeChatImage;
//    return [[cachePath stringByAppendingPathComponent:[typeArr objectAtIndex:type]] stringByAppendingPathComponent:filename];
       return [cachePath stringByAppendingPathComponent:filename];
}

- (NSArray *)getMessageDic:(NSDictionary *)sourceDic
{
    NSMutableArray *msgList = [NSMutableArray array];
    for (NSDictionary *msg in [sourceDic valueForKey:@"list"])
    {
        NSMutableDictionary *msgDic = [NSMutableDictionary dictionary];
        [msgDic setValue:[msg valueForKey:@"stime"] forKey:@"stime"];
        NSDictionary *contentDic = [NSDictionary dictionaryWithJSONData:[NSData dataFromBase64String:[msg valueForKey:@"says"]] error:nil];
        
        [msgDic addEntriesFromDictionary:contentDic];
        [msgList addObject:msgDic];
    }
    
    return msgList;
}

//附近的广播
-(NSArray *)getActionDic:(NSDictionary *)sourceDic{
    //    //NSLog(@"%@",sourceDic);
    
    NSMutableArray *actionArrary = [NSMutableArray array];
    for(NSDictionary* action in [sourceDic valueForKey:@"list"]){
//        //NSLog(@"%@",action);

        NSData *encodeData=[GTMBase64 decodeString:[action valueForKey:@"mcontent"]];
        NSString *base64String = [[NSString alloc]initWithData:encodeData encoding:NSUTF8StringEncoding];
        //NSLog(@"%@",base64String);
        NSRange startAndEnd = NSMakeRange(0, [base64String length]);
        NSString * replaceString= [base64String  stringByReplacingOccurrencesOfString:@"'" withString:@"\"" options:NSCaseInsensitiveSearch range:startAndEnd];
        encodeData = [GTMBase64 encodeData:[replaceString dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES]];
        [base64String release];
        NSString *encodeString = [[NSString alloc]initWithData:encodeData encoding:NSUTF8StringEncoding];
        NSMutableDictionary *cntDic=[NSDictionary dictionaryWithJSONData:[NSData dataFromBase64String:encodeString] error:nil];
        [encodeString release];
        if(cntDic == nil){
            [cntDic setValue:@"-" forKey:@"saytext"];
            [cntDic setValue:[NSArray array] forKey:@"attch"];
        }
        [actionArrary addObject:cntDic];
        
    }
    return actionArrary;
}

- (NSDictionary *)getAMsgFrom64String:(NSString *)encodedString
{
    NSData *decodedData = [NSData dataFromBase64String:encodedString];
    return [NSDictionary dictionaryWithJSONData:decodedData error:nil];
}



- (void)startReceiveMsgFromUid:(NSString *)uid forDelegate:(id)delegate
{
    if([_receiveMsgTimer isValid])
    {
        [_receiveMsgTimer invalidate];
        _receiveMsgTimer = nil;
    }
    
    if(uid)
    {
        [_receiveInfo setValue:uid forKey:@"fromUid"];
        [_receiveInfo setValue:delegate forKey:@"singleDelegate"];
    }
    else
    {
        [_receiveInfo setValue:delegate forKey:@"globleDelegate"];
        [_receiveInfo setValue:[NSNumber numberWithInteger:0] forKey:@"counter"];
        [self receiveMsgFromUser:nil delegate:delegate];
    }
    
    _receiveMsgTimer = [NSTimer scheduledTimerWithTimeInterval:SepTimeInterval
                                                        target:self
                                                      selector:@selector(receviceMsg)
                                                      userInfo:nil
                                                       repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:_receiveMsgTimer forMode:NSDefaultRunLoopMode];

}

- (void)stopReceiveMsgForUid:(NSString *)uid
{
    if(!_receiveMsgTimer)
        return;
    if(uid)
    {
        [_receiveInfo removeObjectForKey:@"fromUid"];
        [_receiveInfo removeObjectForKey:@"singleDelegate"];
    }
    else
    {
        [_receiveInfo removeObjectForKey:@"globleDelegate"];
        [_receiveInfo removeObjectForKey:@"counter"];
    }
    
    if(![_receiveInfo valueForKey:@"singleDelegate"] && ![_receiveInfo valueForKey:@"globleDelegate"])
    {
        [_receiveInfo removeAllObjects];
        [_receiveMsgTimer invalidate];
        _receiveMsgTimer = nil;
    }
}

- (void)receviceMsg
{
    
    NSInteger counter = [[_receiveInfo valueForKey:@"counter"] integerValue];
    NSString *fromUid = [_receiveInfo valueForKey:@"fromUid"];
    if(fromUid)
    {
#warning 不用定时了。。。。。。。。。
        [self receiveMsgFromUser:fromUid delegate:[_receiveInfo valueForKey:@"singleDelegate"]];
    }else{
        counter ++;

    }
     // 判断是不是Wifi  还是Wifi
    NSLog(@"%d",counter);
    if((counter > GlobleSepTimeInterval/SepTimeInterval)&&!fromUid)
    {
        counter = 0;
     
        [self receiveMsgFromUser:nil delegate:[_receiveInfo valueForKey:@"globleDelegate"]];
        
    }
    [_receiveInfo setValue:[NSNumber numberWithInteger:counter] forKey:@"counter"];
}

- (void)receiveMsgFromUser:(NSString *)userid delegate:(id)delegate     //如果userid为空，则为接收全局消息
{
    NSString *query = userid?BanBu_ReceiveMessage_From_Server:BanBu_AllOperation_Server;
   
    NSString *requestUrlStr = [BanBuHost_Chat stringByAppendingString:query];
    
    NSMutableDictionary *pars = [NSMutableDictionary dictionaryWithCapacity:1];
    [pars setValue:[self getPar:query] forKey:@"fc"];
    [pars setValue:MyAppDataManager.loginid forKey:@"loginid"];
   
    if(userid)
    {
        [pars setValue:userid forKey:@"fromuid"];
    }
    else
    {
        NSMutableArray *boolArr;

          NSMutableArray *interfaceList=[[[NSMutableArray alloc]initWithCapacity:10]autorelease];
        
           if([[[UserDefaults valueForKey:MyAppDataManager.useruid] valueForKey:@"settings"] valueForKey:@"boolKey"])
           {
            boolArr=[NSMutableArray arrayWithArray:[[[UserDefaults valueForKey:MyAppDataManager.useruid] valueForKey:@"settings"] valueForKey:@"boolKey"]];
           
//               NSLog(@"+_++)+_%@",boolArr);
               
           }
           else
           {
               boolArr=[NSMutableArray arrayWithObjects:@"1",@"1", nil];
           
           }
        // 判断该加什么
        if(1)
        {
            
            NSMutableString *udlist=[[NSMutableString alloc]init];
            
            for(NSMutableDictionary *t in MyAppDataManager.talkPeoples)
            {
                if([[t valueForKey:@"me"]intValue]==1)
                {
                    if([udlist length])
                    {
                        [udlist appendString:@","];
                    }
                    [udlist appendString:VALUE(@"userid", t)];
                    
                    
                }else
                {
                    continue;
                    
                }
            }

            
            NSMutableDictionary *allMessage=[[[NSMutableDictionary alloc]initWithCapacity:10] autorelease];
        
            // 这是fc 那一层的
            [allMessage setValue:[self getPar:BanBu_ReceiveMessage_From_All] forKey:@"fc"];
            
            // 这是prama 那一层的
            
            NSMutableDictionary *subAllMessage=[[[NSMutableDictionary alloc]initWithCapacity:10]autorelease];
            
            [subAllMessage setValue:udlist forKey:@"uidlist"];
//            NSLog(@"%@",udlist);
            NSDateFormatter *formatter = [[[NSDateFormatter alloc] init] autorelease];
            [formatter setLocale:[NSLocale currentLocale]];
            [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            NSString *stime = [formatter stringFromDate:[NSDate dateWithTimeInterval:-3600*24 sinceDate:[NSDate date]]];
            [pars setValue:stime forKey:@"fromtime"];
            
            NSString *ltime=[UserDefaults valueForKey:@"lasttime"];
            
            // 比较有没有大于三十分钟
            BOOL time=[self HalfHourLater:stime beforeTime:ltime];
            
            if([[UserDefaults valueForKey:@"first"] integerValue]==0)
            {
                [subAllMessage setValue:@"y" forKey:@"deep"];
                
                [UserDefaults setValue:stime forKey:@"lastime"];
                
                [UserDefaults setValue:[NSNumber numberWithInt:1] forKey:@"first"];
                
                // 比较有没有大于三十分钟
            }else{
                
                [subAllMessage setValue:@"n" forKey:@"deep"];
                
            }
            
            if(time)
            {
                [subAllMessage setValue:@"y" forKey:@"deep"];
                
            }
        
            
            isDeep=[subAllMessage valueForKey:@"deep"];
            
            NSString *paramaString=[[CJSONSerializer serializer]serializeDictionary:subAllMessage];
            
            paramaString=[[paramaString dataUsingEncoding:NSUTF8StringEncoding]base64EncodedString];
            
            
            [allMessage setValue:paramaString forKey:@"param"];

            
            [interfaceList addObject:allMessage];
            
        
            
        }
        if ([[boolArr objectAtIndex:1] boolValue])
        {
        
            NSMutableDictionary *allMessage=[[[NSMutableDictionary alloc]initWithCapacity:10] autorelease];
            
            // 这是fc 那一层的get_friendaction_ofmy
            [allMessage setValue:[self getPar:BanBu_Get_Friend_FriendDos] forKey:@"fc"];
        
            // 这是prama 的一层
             NSMutableDictionary *subAllMessage=[[[NSMutableDictionary alloc]initWithCapacity:10]autorelease];
            NSString *timeNowString = [BanBu_RefreshTime getCurrentTime:nil];
            [subAllMessage setValue:[MyAppDataManager currentTime:timeNowString] forKey:@"fromtime"];

//            if([UserDefaults valueForKey:@"thisCurrentTime"]){
//            
//                [subAllMessage setValue:[UserDefaults valueForKey:@"thisCurrentTime"] forKey:@"fromtime"];
//            }else
//            {
//                [subAllMessage setValue:[MyAppDataManager currentTimeBeforeAweek] forKey:@"fromtime"];
//                
//            }
            NSString *paramaString=[[CJSONSerializer serializer]serializeDictionary:subAllMessage];
            
            paramaString=[[paramaString dataUsingEncoding:NSUTF8StringEncoding]base64EncodedString];
            
            
            [allMessage setValue:paramaString forKey:@"param"];
            
//            NSLog(@"%@",allMessage);
            [interfaceList addObject:allMessage];

        
        
        }
        
//        if([[boolArr objectAtIndex:2] boolValue])
//        {
//        
//        
//        
//        }
//        
//        if([[boolArr objectAtIndex:3]boolValue])
//        {
//        
//        
//        
//        }
    
          [pars setValue:interfaceList forKey:@"interfacelist"];
        
    }
    
    NSString *jsonfrom = [[CJSONSerializer serializer] serializeDictionary:pars];
    
    jsonfrom = [[jsonfrom dataUsingEncoding:NSUTF8StringEncoding] base64EncodedString];
    
    requestUrlStr = [requestUrlStr stringByAppendingString:jsonfrom];
    
    MKNetworkOperation *op = [[[MKNetworkOperation alloc] initWithURLString:requestUrlStr params:nil httpMethod:@"GET"] autorelease];
    NSLog(@"%@",requestUrlStr);
    __block typeof(delegate)blockDelegate = delegate;

    [op onCompletion:^(MKNetworkOperation *completedOperation)
     {
         if([blockDelegate respondsToSelector:@selector(banbuRequestDidFinished:error:)])
         {
             NSString *resStr = [completedOperation.responseString stringByTrimmingCharactersInSet:[NSCharacterSet controlCharacterSet]];
             NSError *error = nil;
             if(!resStr.length)
             {
                 error = [NSError errorWithDomain:BanBuDataformatError code:123 userInfo:[NSDictionary dictionaryWithObjectsAndKeys:query,@"fc",[pars valueForKey:@"msgid"],@"requestid",nil]];
                 [blockDelegate banbuRequestDidFinished:nil error:error];
                 return;
             }
             
             NSData *resFrom64 = [NSData dataFromBase64String:resStr];
             NSMutableDictionary *respondsDic = [NSMutableDictionary dictionaryWithDictionary:[NSDictionary dictionaryWithJSONData:resFrom64 error:&error]];
             [respondsDic setValue:[pars valueForKey:@"msgid"] forKey:@"requestid"];
             
             [blockDelegate banbuRequestDidFinished:respondsDic error:error];
         }
         
     }onError:^(NSError* error) {
         if([blockDelegate respondsToSelector:@selector(banbuRequestDidFinished:error:)])
         {
             NSError *aerror = (NSError *)error;
             NSError *error = [NSError errorWithDomain:aerror.domain
                                                  code:aerror.code
                                              userInfo:[NSDictionary dictionaryWithObjectsAndKeys:query,@"fc",[pars valueForKey:@"msgid"],@"requestid",nil]];
             [blockDelegate banbuRequestDidFinished:nil error:error];
         }
     }];
    
    [op start];
}


// 接受全局的消息

- (void)receiveMsgFromAll:(NSString *)userid delegate:(id)delegate     //如果userid为空，则为接收全局消息
{
    NSString *query = userid?BanBu_ReceiveMessage_From_Server:BanBu_ReceiveMessage_From_All;
    
    NSString *requestUrlStr = [BanBuHost_Chat stringByAppendingString:query];
    
    NSMutableDictionary *pars = [NSMutableDictionary dictionaryWithCapacity:1];
    [pars setValue:[self getPar:query] forKey:@"fc"];
    [pars setValue:MyAppDataManager.loginid forKey:@"loginid"];
    if(userid)
    {
        [pars setValue:userid forKey:@"fromuid"];
    }
    else
    {
        NSDateFormatter *formatter = [[[NSDateFormatter alloc] init] autorelease];
        [formatter setLocale:[NSLocale currentLocale]];
        [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSString *stime = [formatter stringFromDate:[NSDate dateWithTimeInterval:-3600*24 sinceDate:[NSDate date]]];
        [pars setValue:stime forKey:@"fromtime"];
        
//        NSString *ltime=[UserDefaults valueForKey:@"lasttime"];
        
        // 比较有没有大于三十分钟
      
        
        [pars setValue:isDeep forKey:@"deep"];
        
        NSMutableString *udlist=[[NSMutableString alloc]init];
        
        for(NSMutableDictionary *t in MyAppDataManager.talkPeoples)
        {
            if([[t valueForKey:@"me"]intValue]==1)
            {
                if([udlist length])
                {
                    [udlist appendString:@","];
                }
                [udlist appendString:VALUE(@"userid", t)];
                
                
            }else
            {
                continue;
                
            }
        }
        
        
        [pars setValue:udlist forKey:@"uidlist"];
        
        [udlist release];
        
        
    }
    
 
    NSLog(@"+++++%@",pars);
    
        
    NSString *jsonfrom = [[CJSONSerializer serializer] serializeDictionary:pars];
    
    jsonfrom = [[jsonfrom dataUsingEncoding:NSUTF8StringEncoding] base64EncodedString];
    requestUrlStr = [requestUrlStr stringByAppendingString:jsonfrom];
    
    NSLog(@"%@",requestUrlStr);
    
    MKNetworkOperation *op = [[[MKNetworkOperation alloc] initWithURLString:requestUrlStr params:nil httpMethod:@"GET"] autorelease];
    
    __block typeof(delegate)blockDelegate = delegate;
    
    [op onCompletion:^(MKNetworkOperation *completedOperation)
     {
         if([blockDelegate respondsToSelector:@selector(banbuRequestDidFinished:error:)])
         {
             NSString *resStr = [completedOperation.responseString stringByTrimmingCharactersInSet:[NSCharacterSet controlCharacterSet]];
             NSError *error = nil;
             if(!resStr.length)
             {
                 error = [NSError errorWithDomain:BanBuDataformatError code:123 userInfo:[NSDictionary dictionaryWithObjectsAndKeys:query,@"fc",[pars valueForKey:@"msgid"],@"requestid",nil]];
                 [blockDelegate banbuRequestDidFinished:nil error:error];
                 return;
             }
             
             NSData *resFrom64 = [NSData dataFromBase64String:resStr];
             NSMutableDictionary *respondsDic = [NSMutableDictionary dictionaryWithDictionary:[NSDictionary dictionaryWithJSONData:resFrom64 error:&error]];
             [respondsDic setValue:[pars valueForKey:@"msgid"] forKey:@"requestid"];
             
             NSLog(@"- - - - - -- - %@",respondsDic);
             [blockDelegate banbuRequestDidFinished:respondsDic error:error];
         }
         
     }onError:^(NSError* error) {
         if([blockDelegate respondsToSelector:@selector(banbuRequestDidFinished:error:)])
         {
             NSError *aerror = (NSError *)error;
             NSError *error = [NSError errorWithDomain:aerror.domain
                                                  code:aerror.code
                                              userInfo:[NSDictionary dictionaryWithObjectsAndKeys:query,@"fc",[pars valueForKey:@"msgid"],@"requestid",nil]];
             [blockDelegate banbuRequestDidFinished:nil error:error];
         }
     }];
    
    
    [op start];
}



/**************抛绣球的***************/

// 开始接受绣球
-(void)startReceiveBallMsgFromUid:(NSString *)uid forDelegate:(id)delegate
{
    if([_receiveSingleMsgTimer isValid])
    {
        [_receiveSingleMsgTimer invalidate];
        
        _receiveSingleMsgTimer=nil;
        
    }
    if(uid)
    {
        [_receiveBallInfo setValue:uid forKey:@"fromUid"];
        [_receiveBallInfo setValue:delegate forKey:@"singleDelegate"];
        
    }else
    {
        
        [_receiveBallInfo setValue:delegate forKey:@"globleDelegate"];
        [_receiveBallInfo setValue:[NSNumber numberWithInteger:0] forKey:@"counter"];
        
        
        [self receiveBallFromUser:nil delegate:delegate];
        
    }
    
    _receiveSingleMsgTimer = [NSTimer scheduledTimerWithTimeInterval:SepTimeInterval
                                                              target:self
                                                            selector:@selector(receiveBallMsg)
                                                            userInfo:nil
                                                             repeats:YES];
    
    [[NSRunLoop currentRunLoop] addTimer:_receiveSingleMsgTimer forMode:NSDefaultRunLoopMode];
    
    
    
    
    
}


-(void)startReceiveMsg
{
    
    _receiveMsgTimer = [NSTimer scheduledTimerWithTimeInterval:SepTimeInterval
                                                        target:self
                                                      selector:@selector(receviceMsg)
                                                      userInfo:nil
                                                       repeats:YES];
    
    [[NSRunLoop currentRunLoop] addTimer:_receiveMsgTimer forMode:NSDefaultRunLoopMode];
    
}


-(void)startReceiveBallMsg
{
    
    _receiveSingleMsgTimer = [NSTimer scheduledTimerWithTimeInterval:SepTimeInterval
                                                              target:self
                                                            selector:@selector(receiveBallMsg)
                                                            userInfo:nil
                                                             repeats:YES];
    
    [[NSRunLoop currentRunLoop] addTimer:_receiveSingleMsgTimer forMode:NSDefaultRunLoopMode];
    
    
}
// 终止接受信息

-(void)stopReceiveBallMsgForUid:(NSString *)uid
{
    
    if(!_receiveSingleMsgTimer)
        
        return;
    
    if(uid)
    {
        [_receiveBallInfo removeObjectForKey:@"fromUid"];
        [_receiveBallInfo removeObjectForKey:@"singleDelegate"];
        
    }
    else
    {
        [_receiveBallInfo removeObjectForKey:@"globleDelegate"];
        [_receiveBallInfo removeObjectForKey:@"counter"];
    }
    
    if(![_receiveBallInfo valueForKey:@"singleDelegate"] && ![_receiveBallInfo valueForKey:@"globleDelegate"])
    {
        [_receiveBallInfo removeAllObjects];
        [_receiveSingleMsgTimer invalidate];
        _receiveSingleMsgTimer = nil;
    }
    
}





- (void)uploadFinished:(ASINetworkQueue *)queue
{
    NSMutableDictionary *resDic = [NSMutableDictionary dictionary];
    [resDic setValue:@"y" forKey:@"ok"];
    [resDic setValue:@"upload_my_photos" forKey:@"fc"];
    [resDic setValue:[queue.userInfo valueForKey:@"successNum"] forKey:@"successNum"];
    [resDic setValue:[queue.userInfo valueForKey:@"failNum"] forKey:@"failNum"];
    [resDic setValue:[queue.userInfo valueForKey:@"facelist"] forKey:@"facelist"];
    id adelegate = [queue.userInfo valueForKey:@"adelegate"];
    if([adelegate respondsToSelector:@selector(banbuRequestDidFinished:error:)])
        [adelegate banbuRequestDidFinished:resDic error:nil];
    queue.delegate = nil;
    [queue cancelAllOperations];
    [queue release];
    
}

- (void)creatChatConnect
{
    static BOOL connectOK = NO;
    if(!_chatSocket)
    {
        _chatSocket = [[AsyncSocket alloc] initWithDelegate:self];
        NSError *error = nil;
        connectOK = [_chatSocket connectToHost: SERVER_IP onPort: SERVER_PORT error: &error];
        if (!connectOK)
            //NSLog(@"connect error: %@", error);
        [_chatSocket setRunLoopModes:[NSArray arrayWithObject:NSRunLoopCommonModes]];
    }
    NSError *error = nil;
    if(![_chatSocket isConnected])
        [_chatSocket connectToHost:SERVER_IP onPort:SERVER_PORT error:&error];
    
}

- (void)DisconnectChat
{
    [_chatSocket disconnect];
}


#pragma mark - tcp


- (void)onSocket:(AsyncSocket *)sock didConnectToHost:(NSString *)host port:(UInt16)port
{
	NSLog(@"%s %d", __FUNCTION__, __LINE__);
    [_chatSocket readDataWithTimeout: -1 tag: 0];
}

- (void)onSocket:(AsyncSocket *)sock didWriteDataWithTag:(long)tag
{
    //NSLog(@"send:%s %d, tag = %ld", __FUNCTION__, __LINE__, tag);
    [_chatSocket readDataWithTimeout: -1 tag: 0];
}

// 这里必须要使用流式数据
- (void)onSocket:(AsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag
{
    NSString *msg = [[[NSString alloc] initWithData: data encoding:NSUTF8StringEncoding] autorelease];
    NSLog(@"recevice:%s %d, msg = %@", __FUNCTION__, __LINE__, msg);
    [_chatSocket readDataWithTimeout: -1 tag: 0];
}

- (void)onSocket:(AsyncSocket *)sock willDisconnectWithError:(NSError *)err
{
    //NSLog(@"%s %d, err = %@", __FUNCTION__, __LINE__, err);
}

- (void)onSocketDidDisconnect:(AsyncSocket *)sock
{
    //NSLog(@"%s %d", __FUNCTION__, __LINE__);
    self.chatSocket = nil;
}

- (BOOL)HalfHourLater:(NSString *)stime beforeTime:(NSString *)ltime
{
    if(!ltime || !stime)
        return NO;
    
    NSDateFormatter *formatter = [[[NSDateFormatter alloc] init] autorelease];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *currentDate = [formatter dateFromString:stime];
    if(!currentDate)
        return NO;
    NSDate *lastDate = [formatter dateFromString:ltime];
    if(!lastDate)
        return NO;
    
    return [currentDate timeIntervalSince1970]>[lastDate timeIntervalSince1970]+1800;
}





- (void)dealloc
{
    NSLog(@"this is dealloc1");
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kReachabilityChangedNotification object:nil];
    [_networkQueue cancelAllOperations];
    [_networkQueue release];
    [_chatSocket release];
    [_receiveInfo release];
    [_hostReach release];
    if(_receiveMsgTimer)
    {
        [_receiveMsgTimer invalidate];
        _receiveMsgTimer = nil;
    }
    if(_receiveSingleMsgTimer)
    {
        [_receiveSingleMsgTimer invalidate];
    
        _receiveSingleMsgTimer=nil;
    }
    [super dealloc];
}






- (id)copyWithZone:(NSZone *)zone
{
    return self;
}
- (id)retain
{
    return self;
}
- (NSUInteger)retainCount
{
    return NSUIntegerMax;  //denotes an object that cannot be released
}
- (oneway void)release
{
    //do nothing
}
- (id)autorelease
{
    return self;
}



@end
