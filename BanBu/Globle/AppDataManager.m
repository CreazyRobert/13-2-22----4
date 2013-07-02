  //
//  AppDataManager.m
//  BanBu
//
//  Created by 17xy on 12-8-3.
//
//

#import "AppDataManager.h"
#import "AppCommunicationManager.h"
#import "BanBu_SmileLabel.h"
#import "BanBu_AppDelegate.h"
#import "BanBu_ChatViewController.h"
#import "CJSONSerializer.h"
#import "NSDictionary_JSONExtensions.h"
#import <CommonCrypto/CommonDigest.h>
#import "CJSONDeserializer.h"
#import "BanBu_MyFriendViewController.h"
#define DataBasePath  [DataCachePath stringByAppendingPathComponent:@"data.db"]
@interface AppDataManager()

-(void)createMusic;
@end
@implementation AppDataManager
@synthesize regDic = _regDic;
@synthesize loginid = _loginid;
@synthesize nearBuddys=_nearBuddys;
@synthesize nearDos = _nearDos;
@synthesize zibarString = _zibarString;
@synthesize deep=_deep;
@synthesize isSend=_isSend;
@synthesize LanguageDateString=_LanguageDateString;
@synthesize dateString=_dateString;
@synthesize blackString=_blackString;
@synthesize languageDictionary=_languageDictionary;
@synthesize ballTalk=_ballTalk;
@synthesize Messagetype=_Messagetype;
@synthesize unLoginArr=_unLoginArr;
@synthesize emiNameArr=_emiNameArr;
@synthesize emiLanguageArr=_emiLanguageArr;
@synthesize isSee=_isSee;
@synthesize agreeList=_agreeList;
@synthesize time=_time;
@synthesize talkArr=_talkArr;
@synthesize isPlay=_isPlay;
@synthesize playert=_playert;
@synthesize boolArr=_boolArr;

static AppDataManager *sharedAppDataManager = nil;

-(NSString *)theRevisedName:(NSString*)oldname andUID:(NSString *)uid{
    NSString *output = [NSString string];

    NSMutableDictionary *uidDic = [NSMutableDictionary dictionaryWithDictionary:[UserDefaults valueForKey:MyAppDataManager.useruid]];
    NSArray *renameArr = [NSArray arrayWithArray:[uidDic valueForKey:@"renameflist"]];
    for(NSDictionary *renameDic in renameArr){
        if([[renameDic valueForKey:@"friendid"] isEqualToString:uid]){
            output = [renameDic valueForKey:@"fname"];
            break;
        }
    }
    return ![output isEqualToString:@""]?output:oldname;
}


 #warning 加入全局的异常断点后，导致player出错。

-(void)createMusic
{
    NSLog(@"%@",_musicName);
   if(![[[[UserDefaults valueForKey:MyAppDataManager.useruid] valueForKey:@"settings"] valueForKey:@"MusicSwith"] length]){
        return;
   }else{
       MyAppDataManager.musicName = [[[UserDefaults valueForKey:MyAppDataManager.useruid] valueForKey:@"settings"] valueForKey:@"MusicSwith"];
   }
    NSString *path=[[NSBundle mainBundle]pathForResource:_musicName ofType:@"mp3"];
    
  if(player)
  {
      [player release];
      
      player=nil;
  
  }
    NSError *musicError;
    
    player=[[AVAudioPlayer alloc]initWithData:[NSData dataWithContentsOfFile:path] error:&musicError];
    
    [player prepareToPlay];
    
    player.volume=1.0;
    
    [player play];
    
}
-(NSString *)IsMinGanWord:(NSString *)input
{
    if(!input)
    {
        input=@"";
        
        return nil;
    }
    
    NSMutableString *change=[[[NSMutableString alloc]initWithString:input] autorelease];
    
    NSArray *stringArr=[MyAppDataManager.blackString componentsSeparatedByString:@","];

    for(int k=0;k<[stringArr count];k++)
    {
        NSRange range=[input rangeOfString:[stringArr objectAtIndex:k]];
        
        if(range.length==0)
        {
            continue;
            
        }else{
            
            NSMutableString *string=[[[NSMutableString alloc]init] autorelease];
            
            for(int i=0;i<range.length;i++)
            {
                
                [string appendString:@"*"];
                
                
            }
            
            [change replaceCharactersInRange:range withString:string];
            
            input=[NSString stringWithString:change];
            
            k=0;
            
            // input=[input substringFromIndex:range.length];
        }
        
        
    }
    
    NSString *output=[NSString stringWithString:change];
    return output;
}

//国际语言
-(NSString *)IsInternationalLanguage:(NSString *)input
{
    
//    NSLog(@"%@",input);
//    NSLog(@"%@",MyAppDataManager.languageDictionary);
    NSString *langauage=[self getPreferredLanguage];
    
    if(!input)
    {
        input=@"";
        
        return nil;
    }
    
    if([langauage isEqual:@"zh-Hans"])
    {
        NSMutableDictionary *chineseDictionary=[[MyAppDataManager.languageDictionary objectForKey:@"language"] objectForKey:@"cn"];
        
        NSArray *keyArr=[chineseDictionary allKeys];
        
        for(int i=0;i<[keyArr count];i++)
        {
            NSString *key=[keyArr objectAtIndex:i];
            
            NSRange range=[input rangeOfString:key];
            
            if(range.length==0)
                continue;
            
            NSString *value=[chineseDictionary valueForKey:[keyArr objectAtIndex:i]];
            
            input=[input stringByReplacingOccurrencesOfString:key withString:value];
            
        }
        
        NSString *outstring=[NSString stringWithString:input];
        
        return outstring;
        
    }else if ([langauage isEqual:@"ja"])
    {
        
        NSMutableDictionary *chineseDictionary=[[MyAppDataManager.languageDictionary objectForKey:@"language"] objectForKey:@"jp"];
        
        NSArray *keyArr=[chineseDictionary allKeys];
        
        for(int i=0;i<[keyArr count];i++)
        {
            NSString *key=[keyArr objectAtIndex:i];
            
            NSString *value=[chineseDictionary valueForKey:[keyArr objectAtIndex:i]];
            
            input=[input stringByReplacingOccurrencesOfString:key withString:value];
            
        }
        
        NSString *outstring=[NSString stringWithString:input];
        return outstring;
        
    }else
    {
        NSMutableDictionary *chineseDictionary=[[MyAppDataManager.languageDictionary objectForKey:@"language"] objectForKey:@"en"];
        
        NSArray *keyArr=[chineseDictionary allKeys];
        for(int i=0;i<[keyArr count];i++)
        {
            NSString *key=[keyArr objectAtIndex:i];
            
            NSString *value=[chineseDictionary valueForKey:[keyArr objectAtIndex:i]];
            input=[input stringByReplacingOccurrencesOfString:key withString:value];
        }
        NSString *outstring=[NSString stringWithString:input];
        return outstring;
        
    }
}


-(NSString*)getPreferredLanguage
{
    
    NSUserDefaults* defs = [NSUserDefaults standardUserDefaults];
    NSArray* languages = [defs objectForKey:@"AppleLanguages"];
    NSString* preferredLang = [languages objectAtIndex:0];
    return preferredLang;
}

/*
// 这是返回字符串
const  static  NSString* (^e_tt)(NSString *)=^(NSString *str)
{
    
    return BanBu_release(str);
    
};

// 这是返回构造表的 表名
const static  NSString * (^bindString)(NSString *,NSString *)=^(NSString *a,NSString *b)
{    NSString *u=[NSString stringWithFormat:@"tabel_%@_%@",a,b];
    
     return BanBu_release(u);
};
 
 void (^insertDataForItemandUid)(id,NSString*,NSString*)=^(id data,NSString *itemName,NSString *uid)
 {
 if([itemName isEqual:DIALOGS])
 {
 
 }
 
 };
 

*/

NSString *(^bindLink)(NSString *,NSString *)=^(NSString *itemName,NSString *UID)
{

    return itemName;
};

- (void)initRaysource
{
    _nearBuddys = [[NSMutableArray alloc] initWithCapacity:10];
    _nearDos = [[NSMutableArray alloc] initWithCapacity:10];
    _contentArr = [[NSMutableArray alloc]initWithCapacity:10];
    _dialogs = [[NSMutableArray alloc] initWithCapacity:10];
    _friends = [[NSMutableArray alloc] initWithCapacity:10];
    _friendsDos = [[NSMutableArray alloc] initWithCapacity:10];
    _friendViewList= [[NSMutableArray alloc] initWithCapacity:10];
    _talkPeoples = [[NSMutableArray alloc] initWithCapacity:10];
    _zibarString = nil;
    
    _readArr=[[NSMutableArray alloc]initWithCapacity:10];
    
    _playBall=[[NSMutableArray alloc]initWithCapacity:10];
    
    _ballTalk=[[NSMutableArray alloc]initWithCapacity:10];
    
    _isSend=NO;
    
    _languageDictionary=[[NSMutableDictionary alloc]initWithCapacity:10];
    
    _Messagetype=MessageTypeStand;
    
    _keyArr=[[NSMutableArray alloc]initWithCapacity:10];
    
    _valueArr=[[NSMutableArray alloc]initWithCapacity:10];
    
    _messageRadioDictionary=[[NSMutableDictionary alloc]init];
    
    _unLoginArr=[[NSMutableArray alloc]initWithCapacity:10];
    
    _boolArr=[[NSMutableArray alloc]initWithCapacity:10];
    
    _emiNameArr=[[NSMutableArray alloc]initWithObjects:@"打怪兽",@"嘟嘟嘴",@"多变",@"饿了",@"高兴",@"歌王",@"好烦啊",@"加油",@"惊讶",@"可爱",@"可怜",@"麦霸",@"怒火",@"饶命",@"撒娇",@"睡觉",@"痛苦",@"羞羞脸",@"阴谋",@"眨眼",@"发大财",@"喷饭",@"炸飞了",@"凄凉",@"T台秀",@"读书",@"扭屁股",@"舞蹈",@"得意",@"运动",@"救命",@"滚远点",@"江南舞",@"走你", nil];
    
    

    _emiLanguageArr=[[NSMutableArray alloc]initWithObjects:NSLocalizedString(@"smileItem", nil),NSLocalizedString(@"smileItem1", nil),NSLocalizedString(@"smileItem2", nil),NSLocalizedString(@"smileItem3", nil),NSLocalizedString(@"smileItem4", nil),NSLocalizedString(@"smileItem5", nil),NSLocalizedString(@"smileItem6", nil),NSLocalizedString(@"smileItem7", nil),NSLocalizedString(@"smileItem8", nil),NSLocalizedString(@"smileItem9", nil),NSLocalizedString(@"smileItem10", nil),NSLocalizedString(@"smileItem12", nil),NSLocalizedString(@"smileItem13", nil),NSLocalizedString(@"smileItem15", nil),NSLocalizedString(@"smileItem16", nil),NSLocalizedString(@"smileItem17", nil),NSLocalizedString(@"smileItem19", nil),NSLocalizedString(@"smileItem20", nil),NSLocalizedString(@"smileItem22", nil),NSLocalizedString(@"smileItem23", nil),NSLocalizedString(@"smileItem24", nil),NSLocalizedString(@"smileItem25", nil),NSLocalizedString(@"smileItem26", nil),NSLocalizedString(@"smileItem27", nil),NSLocalizedString(@"smileItem28", nil),NSLocalizedString(@"smileItem29", nil),NSLocalizedString(@"smileItem30", nil),NSLocalizedString(@"smileItem31", nil),NSLocalizedString(@"smileItem32", nil),NSLocalizedString(@"smileItem33", nil),NSLocalizedString(@"smileItem34", nil),NSLocalizedString(@"smileItem35", nil),NSLocalizedString(@"smileItem36", nil),NSLocalizedString(@"smileItem37", nil), nil];
    
    _agreeList=[[NSMutableArray alloc]initWithCapacity:10];
    
    _talkArr=[[NSMutableArray alloc]initWithCapacity:10];
    
    
   
    if(![FileManager fileExistsAtPath:DataCachePath])
        [FileManager createDirectoryAtPath:DataCachePath withIntermediateDirectories:NO attributes:nil error:nil];
    
    _dataBase = [[FMDatabase alloc] initWithPath:DataBasePath];
    if(![_dataBase open])
    {
        [_dataBase close];
        _dataBase = nil;
    }
}

// 这是关闭聊天的公共接收

+ (AppDataManager *)sharedAppDataManager;
{
    @synchronized(self){
        if(sharedAppDataManager == nil){
            sharedAppDataManager = [[[self alloc] init] autorelease];
            [sharedAppDataManager initRaysource];
        }
    }
    return sharedAppDataManager;
}

-(void)setMessagetype:(MessageType)Messagetype
{
  if(Messagetype==_Messagetype)
      return;

    _Messagetype=Messagetype;
    
}


-(NSString *)getTableNameForUid:(NSString *)uid
{
    return [NSString stringWithFormat:@"tabel_%@_%@",self.useruid,uid];

   // return bindString(self.useruid,uid);

}

- (void)insertData:(id)data forItem:(NSString *)itemName forUid:(NSString *)uid
{
    if([itemName isEqualToString:DIALOGS])
    {
        if(![_dataBase goodConnection])
            [_dataBase open];
        NSString *tableName = [self getTableNameForUid:uid];
    
        if(![_dataBase tableExists:tableName])
        {
            NSDictionary *queryDic = [NSDictionary dictionaryWithObjectsAndKeys:
                                      DBFieldType_INTEGER, KeyID,
                                      DBFieldType_TEXT,    KeyContent,
                                      DBFieldType_BOOL,    KeyMe,
                                      DBFieldType_INTEGER, KeyStatus,
                                      DBFieldType_INTEGER, KeyType,
                                      DBFieldType_INTEGER, KeyHeight,
                                      DBFieldType_TEXT,    KeyStime,
                                      DBFieldType_BOOL,    KeyShowtime,
                                      DBFieldType_TEXT,    KeyUface,
                                      DBFieldType_INTEGER, KeyMediaStatus,
                                      DBFieldType_TEXT,    KeyShowFrom,
                                       nil];
            
            NSString *query = [NSString stringWithFormat:@"CREATE TABLE %@ (%@)",tableName,[self getPar1StrFromDic:queryDic]];
         
            [_dataBase executeUpdate:query];
        }
        
        NSString *query = [NSString stringWithFormat:@"INSERT INTO %@ (ID,content,me,status,type,height,stime,showtime,uface,mediastatus,msgfrom) VALUES (?,?,?,?,?,?,?,?,?,?,?)",tableName];
        NSArray *dataArr = nil;
        if([data isKindOfClass:[NSDictionary class]])
            dataArr = [NSArray arrayWithObject:data];
        else
            dataArr = [NSArray arrayWithArray:data];
        for(NSDictionary *aChat in dataArr)
        {
                       
            BOOL s = [_dataBase executeUpdate:query,
                      VALUE(KeyID, aChat),
                      VALUE(KeyContent, aChat),
                      VALUE(KeyMe, aChat),
                      VALUE(KeyStatus, aChat),
                      VALUE(KeyType, aChat),
                      VALUE(KeyHeight, aChat),
                      VALUE(KeyStime, aChat),
                      VALUE(KeyShowtime, aChat),
                      VALUE(KeyUface, aChat),
                      VALUE(KeyMediaStatus, aChat),
                      VALUE(KeyShowFrom, aChat)
                      ];
            if(!s){
                NSLog(@"database action error:%@",[[_dataBase lastError] description]);

            }
        }
    }
    //*****i XXXXXX 改过
    else if([itemName isEqualToString:TALKPEOPLES])
    {     
        if(![_dataBase goodConnection])
            [_dataBase open];
        if(![_dataBase tableExists:TALKPEOPLES])
        {
            NSDictionary *queryDic = [NSDictionary dictionaryWithObjectsAndKeys:
                                      DBFieldType_INTEGER, KeyID,
                                      DBFieldType_TEXT,    KeyFromUid,
                                      DBFieldType_TEXT,    KeyUface,
                                      DBFieldType_TEXT,    KeyUname,
                                      DBFieldType_TEXT,    KeyAge,
                                      DBFieldType_BOOL,    KeySex,
                                      DBFieldType_TEXT,    KeyContent,
                                      DBFieldType_TEXT,    KeyStime,
                                      DBFieldType_INTEGER, KeyUnreadNum,
                                      DBFieldType_TEXT,    KeyType,
                                      
                                      DBFieldType_TEXT,    KeyCompany,
                                      DBFieldType_TEXT,    KeyHbody,
                                      DBFieldType_TEXT,    KeyJobtitle,
                                      DBFieldType_TEXT,    KeyLiked,
                                      
                                      DBFieldType_TEXT,    KeyLovego,
                                      DBFieldType_TEXT,    KeySayme,
                                      DBFieldType_TEXT,    KeySchool,
                                      DBFieldType_TEXT,    KeySstar,
                                      DBFieldType_TEXT,    KeyWbody,
                                      DBFieldType_TEXT,    KeyXblood,
                                      DBFieldType_TEXT,    KeyDtime,
                                      DBFieldType_TEXT,    KeyDmeter,
                                      DBFieldType_TEXT,    KeyFacelist,
                                      DBFieldType_BOOL,    KeyMe,
                                      DBFieldType_TEXT,    KeyStatus,
                                      nil];
            
           
            
            NSString *query = [NSString stringWithFormat:@"CREATE TABLE %@ (%@)",TALKPEOPLES,[self getPar1StrFromDic:queryDic]];

            BOOL f = [_dataBase executeUpdate:query];
            if(!f)
            {
              NSLog(@"创建失败!");
            }
                
        
        }
        
        NSString *query = [NSString stringWithFormat:@"INSERT INTO %@ (ID,userid,uface,pname,oldyears,sex,content,stime,unreadnum,type,company,hbody,jobtitle,liked,lovego,sayme,school,sstar,wbody,xblood,ltime,dmeter,facelist,me,status) VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)",TALKPEOPLES];
        NSArray *dataArr = nil;
        if([data isKindOfClass:[NSDictionary class]])
            dataArr = [NSArray arrayWithObject:data];
        else
            dataArr = [NSArray arrayWithArray:data];
        for(NSDictionary *aChat in dataArr)
        {
            BOOL s = [_dataBase executeUpdate:query,
                      VALUE(KeyID, aChat),
                      VALUE(KeyFromUid, aChat),
                      VALUE(KeyUface, aChat),
                      VALUE(KeyUname, aChat),
                      VALUE(KeyAge, aChat),
                      VALUE(KeySex, aChat),
                      VALUE(KeyLasttalk, aChat),
                      VALUE(KeyStime, aChat),
                      VALUE(KeyUnreadNum, aChat),
                      VALUE(KeyType, aChat),
                      VALUE(KeyCompany, aChat),
                      VALUE(KeyHbody, aChat),
                      VALUE(KeyJobtitle, aChat),
                      VALUE(KeyLiked, aChat),
                      VALUE(KeyLovego, aChat),
                      VALUE(KeySayme, aChat),
                      VALUE(KeySchool, aChat),
                      VALUE(KeySstar, aChat),
                      VALUE(KeyWbody, aChat),
                      VALUE(KeyXblood, aChat),
                      VALUE(KeyDtime, aChat),
                      VALUE(KeyDmeter, aChat),
                      VALUE(KeyFacelist, aChat),
                      VALUE(KeyMe, aChat),
                      VALUE(KeyStatus, aChat)
                      ];
            if(!s)
            {
                NSLog(@"database action error:%@",[[_dataBase lastError] description]);

            }
            
        }
    }
    
    
    
    
    
    else if([itemName isEqualToString:BallDialogs])
    {
        if(![_dataBase goodConnection])
            [_dataBase open];
        NSString *tableName = [self getTableNameForUid:uid];
        
        tableName=[tableName stringByAppendingString:@"ball"];
        if(![_dataBase tableExists:tableName])
        {
            NSDictionary *queryDic = [NSDictionary dictionaryWithObjectsAndKeys:
                                      DBFieldType_INTEGER, KeyID,
                                      DBFieldType_TEXT,    KeyContent,
                                      DBFieldType_BOOL,    KeyMe,
                                      DBFieldType_INTEGER, KeyStatus,
                                      DBFieldType_INTEGER, KeyType,
                                      DBFieldType_INTEGER, KeyHeight,
                                      DBFieldType_TEXT,    KeyStime,
                                      DBFieldType_BOOL,    KeyShowtime,
                                      DBFieldType_TEXT,    KeyUface,
                                      DBFieldType_INTEGER, KeyMediaStatus,nil];
            
            NSString *query = [NSString stringWithFormat:@"CREATE TABLE %@ (%@)",tableName,[self getPar1StrFromDic:queryDic]];
            
            [_dataBase executeUpdate:query];
        }
        
        
        
        NSString *query = [NSString stringWithFormat:@"INSERT INTO %@ (ID,content,me,status,type,height,stime,showtime,uface,mediastatus) VALUES (?,?,?,?,?,?,?,?,?,?)",tableName];
        NSArray *dataArr = nil;
        if([data isKindOfClass:[NSDictionary class]])
            dataArr = [NSArray arrayWithObject:data];
        else
            dataArr = [NSArray arrayWithArray:data];
        for(NSDictionary *aChat in dataArr)
        {
        
            BOOL s = [_dataBase executeUpdate:query,
                      VALUE(KeyID, aChat),
                      VALUE(KeyContent, aChat),
                      VALUE(KeyMe, aChat),
                      VALUE(KeyStatus, aChat),
                      VALUE(KeyType, aChat),
                      VALUE(KeyHeight, aChat),
                      VALUE(KeyStime, aChat),
                      VALUE(KeyShowtime, aChat),
                      VALUE(KeyUface, aChat),
                      VALUE(KeyMediaStatus, aChat)];
            if(!s){
               NSLog(@"database action error:%@",[[_dataBase lastError] description]);

            }
        }

    }
    else
    {
        if(![_dataBase goodConnection])
            [_dataBase open];
        if(![_dataBase tableExists:BallList])
        {
            NSDictionary *queryDic = [NSDictionary dictionaryWithObjectsAndKeys:
                                      DBFieldType_INTEGER, KeyID,
                                      DBFieldType_TEXT,    KeyFromUid,
                                      DBFieldType_TEXT,    KeyUface,
                                      DBFieldType_TEXT,    KeyUname,
                                      DBFieldType_TEXT,    KeyAge,
                                      DBFieldType_BOOL,    KeySex,
                                      DBFieldType_TEXT,    KeyContent,
                                      DBFieldType_TEXT,    KeyStime,
                                      DBFieldType_INTEGER, KeyUnreadNum,
                                      DBFieldType_TEXT,    KeyType,
                                      
                                      DBFieldType_TEXT,    KeyCompany,
                                      DBFieldType_TEXT,    KeyHbody,
                                      DBFieldType_TEXT,    KeyJobtitle,
                                      DBFieldType_TEXT,    KeyLiked,
                                      
                                      DBFieldType_TEXT,    KeyLovego,
                                      DBFieldType_TEXT,    KeySayme,
                                      DBFieldType_TEXT,    KeySchool,
                                      DBFieldType_TEXT,    KeySstar,
                                      DBFieldType_TEXT,    KeyWbody,
                                      DBFieldType_TEXT,    KeyXblood,
                                      DBFieldType_TEXT,    KeyFacelist,
                                      nil];
            
            
            
            NSString *query = [NSString stringWithFormat:@"CREATE TABLE %@ (%@)",BallList,[self getPar1StrFromDic:queryDic]];
            
            BOOL f = [_dataBase executeUpdate:query];
            if(!f){
               
              NSLog(@"创建失败!");
            }
            
            
        }
        
        NSString *query = [NSString stringWithFormat:@"INSERT INTO %@ (ID,userid,uface,pname,oldyears,sex,content,stime,unreadnum,type,company,hbody,jobtitle,liked,lovego,sayme,school,sstar,wbody,xblood,facelist) VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)",BallList];
        NSArray *dataArr = nil;
        if([data isKindOfClass:[NSDictionary class]])
            dataArr = [NSArray arrayWithObject:data];
        else
            dataArr = [NSArray arrayWithArray:data];
        for(NSDictionary *aChat in dataArr)
        {
         
            BOOL s = [_dataBase executeUpdate:query,
                      VALUE(KeyID, aChat),
                      VALUE(KeyFromUid, aChat),
                      VALUE(KeyUface, aChat),
                      VALUE(KeyUname, aChat),
                      VALUE(KeyAge, aChat),
                      VALUE(KeySex, aChat),
                      VALUE(KeyLasttalk, aChat),
                      VALUE(KeyStime, aChat),
                      VALUE(KeyUnreadNum, aChat),
                      VALUE(KeyType, aChat),
                      VALUE(KeyCompany, aChat),
                      VALUE(KeyHbody, aChat),
                      VALUE(KeyJobtitle, aChat),
                      VALUE(KeyLiked, aChat),
                      VALUE(KeyLovego, aChat),
                      VALUE(KeySayme, aChat),
                      VALUE(KeySchool, aChat),
                      VALUE(KeySstar, aChat),
                      VALUE(KeyWbody, aChat),
                      VALUE(KeyXblood, aChat),
                      VALUE(KeyFacelist, aChat)
                      ];
            if(!s)
            {
                NSLog(@"database action error:%@",[[_dataBase lastError] description]);

            }
            
        }
    
    }
    
}

// 建一张表存放通过的人
-(void)deleteData:(id)data forItemId:(NSString *)itemName forUid:(NSString *)uid
{
    
    if([itemName isEqualToString:DIALOGS])
    {
        
        if(![_dataBase goodConnection])
            [_dataBase open];
        NSString *tableName = [self getTableNameForUid:uid];
        if(![_dataBase tableExists:tableName])
        {
            [_dataBase close];
            return;
        }
        
        NSString *query = [NSString stringWithFormat:@"DELETE FROM %@ WHERE ID=?",tableName];
        NSArray *dataArr = nil;
        if([data isKindOfClass:[NSDictionary class]])
            dataArr = [NSArray arrayWithObject:data];
        else
            dataArr = [NSArray arrayWithArray:data];
        for(NSDictionary *aChat in dataArr)
        {
            
            BOOL s = [_dataBase executeUpdate:query,VALUE(KeyID, aChat)];
            if(!s)
            {
                NSLog(@"database action error:%@",[[_dataBase lastError] description]);
                
            }
            
        }
    }
    
}

- (void)updateData:(id)data forItem:(NSString *)itemName forUid:(NSString *)uid
{
       
    if([itemName isEqualToString:DIALOGS])
    {
        if(![_dataBase goodConnection])
            [_dataBase open];
        NSString *tableName = [self getTableNameForUid:uid];
        
        if(![_dataBase tableExists:tableName])
        {
            [_dataBase close];
            return ;
        }
        
        //(ID,userid,uface,pname,oldyears,sex,content,stime,unreadnum,type)
       
        NSString *query = [NSString stringWithFormat:@"UPDATE %@ SET ID=?,content=?,me=?,status=?,type=?,height=?,stime=?,showtime=?,uface=?,mediastatus=?,msgfrom=? WHERE ID=?",tableName];
        NSArray *dataArr = nil;
        if([data isKindOfClass:[NSDictionary class]])
            dataArr = [NSArray arrayWithObject:data];
        else
            dataArr = [NSArray arrayWithArray:data];
        for(NSDictionary *aChat in dataArr)
        {
            BOOL s = [_dataBase executeUpdate:query,
                      VALUE(KeyID, aChat),
                      VALUE(KeyContent, aChat),
                      VALUE(KeyMe, aChat),
                      VALUE(KeyStatus, aChat),
                      VALUE(KeyType, aChat),
                      VALUE(KeyHeight, aChat),
                      VALUE(KeyStime, aChat),
                      VALUE(KeyShowtime, aChat),
                      VALUE(KeyUface, aChat),
                      VALUE(KeyMediaStatus, aChat),
                      VALUE(KeyShowFrom, aChat),
                      VALUE(KeyID, aChat)];
          
            if(!s)
            {
                NSLog(@"database action error:%@",[[_dataBase lastError] description]);

            }
            
        
        }
    }
    else if([itemName isEqualToString:TALKPEOPLES])
    {
        if(![_dataBase goodConnection])
            [_dataBase open];
        if(![_dataBase tableExists:TALKPEOPLES])
        {
            [_dataBase close];
            return ;
        }
       // (ID,userid,uface,pname,oldyears,sex,content,stime,unreadnum,type)=?
         //company,hbody,jobtitle,liked,lovego,sayme,school,sstar,wbody,xblood
        NSString *query = [NSString stringWithFormat:@"UPDATE %@ SET ID=?,userid=?,uface=?,pname=?,oldyears=?,sex=?,content=?,stime=?,unreadnum=?,type=?,company=?,hbody=?,jobtitle=?,liked=?,lovego=?,sayme=?,school=?,sstar=?,wbody=?,xblood=?,facelist=?,ltime=?,dmeter=?,me=?,status=? WHERE ID=?",TALKPEOPLES];
        NSArray *dataArr = nil;
        if([data isKindOfClass:[NSDictionary class]])
            dataArr = [NSArray arrayWithObject:data];
        else
            dataArr = [NSArray arrayWithArray:data];
        for(NSDictionary *aChat in dataArr)
        {
            BOOL s = [_dataBase executeUpdate:query,
                      VALUE(KeyID, aChat),
                      VALUE(KeyFromUid, aChat),
                      VALUE(KeyUface, aChat),
                      VALUE(KeyUname, aChat),
                      VALUE(KeyAge, aChat),
                      VALUE(KeySex, aChat),
                      VALUE(KeyLasttalk, aChat),
                      VALUE(KeyStime, aChat),
                      VALUE(KeyUnreadNum, aChat),
                      VALUE(KeyType, aChat),
                      VALUE(KeyCompany, aChat),
                      VALUE(KeyHbody, aChat),
                      VALUE(KeyJobtitle, aChat),
                      VALUE(KeyLiked, aChat),
                      VALUE(KeyLovego, aChat),
                      VALUE(KeySayme, aChat),
                      VALUE(KeySchool, aChat),
                      VALUE(KeySstar, aChat),
                      VALUE(KeyWbody, aChat),
                      VALUE(KeyXblood, aChat),
                      VALUE(KeyFacelist, aChat),
                      VALUE(KeyDtime, aChat),
                      VALUE(KeyDmeter, aChat),
                      VALUE(KeyMe, aChat),
                      VALUE(KeyStatus, aChat),
                      VALUE(KeyID, aChat)
                      ];
            if(!s){
               
                NSLog(@"database action error:%@",[[_dataBase lastError] description]);

            }
            
        }
        
    }else if([itemName isEqual:BallDialogs])
    {
        if(![_dataBase goodConnection])
            [_dataBase open];
        NSString *tableName = [self getTableNameForUid:uid];
        
        tableName=[tableName stringByAppendingString:@"ball"];
        
        if(![_dataBase tableExists:tableName])
        {
            [_dataBase close];
            return ;
        }
        
        //(ID,userid,uface,pname,oldyears,sex,content,stime,unreadnum,type)
        
        NSString *query = [NSString stringWithFormat:@"UPDATE %@ SET ID=?,content=?,me=?,status=?,type=?,height=?,stime=?,showtime=?,uface=?,mediastatus=? WHERE ID=?",tableName];
        NSArray *dataArr = nil;
        if([data isKindOfClass:[NSDictionary class]])
            dataArr = [NSArray arrayWithObject:data];
        else
            dataArr = [NSArray arrayWithArray:data];
        for(NSDictionary *aChat in dataArr)
        {
                       
            BOOL s = [_dataBase executeUpdate:query,
                      VALUE(KeyID, aChat),
                      VALUE(KeyContent, aChat),
                      VALUE(KeyMe, aChat),
                      VALUE(KeyStatus, aChat),
                      VALUE(KeyType, aChat),
                      VALUE(KeyHeight, aChat),
                      VALUE(KeyStime, aChat),
                      VALUE(KeyShowtime, aChat),
                      VALUE(KeyUface, aChat),
                      VALUE(KeyMediaStatus, aChat),
                      VALUE(KeyID, aChat)];
            
            if(!s){
              NSLog(@"database action error:%@",[[_dataBase lastError] description]);

            }
            
            
        }
    
    }else
    {
        if(![_dataBase goodConnection])
            [_dataBase open];
        if(![_dataBase tableExists:BallList])
        {
            [_dataBase close];
            return ;
        }
       
        NSString *query = [NSString stringWithFormat:@"UPDATE %@ SET ID=?,userid=?,uface=?,pname=?,oldyears=?,sex=?,content=?,stime=?,unreadnum=?,type=?,company=?,hbody=?,jobtitle=?,liked=?,lovego=?,sayme=?,school=?,sstar=?,wbody=?,xblood=?,facelist=? WHERE ID=?",BallList];
        NSArray *dataArr = nil;
        if([data isKindOfClass:[NSDictionary class]])
            dataArr = [NSArray arrayWithObject:data];
        else
            dataArr = [NSArray arrayWithArray:data];
        for(NSDictionary *aChat in dataArr)
        {
            
            BOOL s = [_dataBase executeUpdate:query,
                      VALUE(KeyID, aChat),
                      VALUE(KeyFromUid, aChat),
                      VALUE(KeyUface, aChat),
                      VALUE(KeyUname, aChat),
                      VALUE(KeyAge, aChat),
                      VALUE(KeySex, aChat),
                      VALUE(KeyLasttalk, aChat),
                      VALUE(KeyStime, aChat),
                      VALUE(KeyUnreadNum, aChat),
                      VALUE(KeyType, aChat),
                      VALUE(KeyCompany, aChat),
                      VALUE(KeyHbody, aChat),
                      VALUE(KeyJobtitle, aChat),
                      VALUE(KeyLiked, aChat),
                      VALUE(KeyLovego, aChat),
                      VALUE(KeySayme, aChat),
                      VALUE(KeySchool, aChat),
                      VALUE(KeySstar, aChat),
                      VALUE(KeyWbody, aChat),
                      VALUE(KeyXblood, aChat),
                      VALUE(KeyFacelist, aChat),
                      VALUE(KeyID, aChat)
                      ];
            if(!s)
            {
                NSLog(@"database action error:%@",[[_dataBase lastError] description]);

            }
            
        }
    
    }
    
   
}

// 这是更新对话的列表中的状态
-(void)updateDialogWithMessage:(NSDictionary *)amsg forUid:(NSString *)uid
{


}

- (void)deleteData:(id)data forItem:(NSString *)itemName forUid:(NSString *)uid
{
    if([itemName isEqualToString:DIALOGS])
    {
        
        if(![_dataBase goodConnection])
            [_dataBase open];
        NSString *tableName = [self getTableNameForUid:uid];
        if(![_dataBase tableExists:tableName])
        {
            [_dataBase close];
            return;
        }
        
        NSString *query = [NSString stringWithFormat:@"DELETE FROM %@ WHERE ID=?",tableName];
        NSArray *dataArr = nil;
        if([data isKindOfClass:[NSDictionary class]])
            dataArr = [NSArray arrayWithObject:data];
        else
            dataArr = [NSArray arrayWithArray:data];
        for(NSDictionary *aChat in dataArr)
        {
            
            BOOL s = [_dataBase executeUpdate:query,VALUE(KeyID, aChat)];
            if(!s)
            {
                NSLog(@"database action error:%@",[[_dataBase lastError] description]);

            }
            
        }
    }
    else if([itemName isEqual:TALKPEOPLES])
    {
        if(![_dataBase goodConnection])
            [_dataBase open];
        if(![_dataBase tableExists:TALKPEOPLES])
        {
            [_dataBase close];
            return;
        }
        
        NSString *query = [NSString stringWithFormat:@"DELETE FROM %@ WHERE ID=?",TALKPEOPLES];
        NSArray *dataArr = nil;
        if([data isKindOfClass:[NSDictionary class]])
            dataArr = [NSArray arrayWithObject:data];
        else
            dataArr = [NSArray arrayWithArray:data];
        for(NSDictionary *aChat in dataArr)
        {
        
            BOOL s = [_dataBase executeUpdate:query,VALUE(KeyID, aChat)];
            if(!s)
            {
                NSLog(@"database action error:%@",[[_dataBase lastError] description]);

            }
            NSString *query = [NSString stringWithFormat:@"SELECT ID FROM %@ WHERE ID=(SELECT MAX(ID) FROM %@)",TALKPEOPLES,TALKPEOPLES];
            NSInteger maxID =[_dataBase intForQuery:query];
            for(int i=[VALUE(KeyID, aChat) integerValue]+1; i<maxID+1; i++)
                [_dataBase executeUpdate:@"UPDATE %@ SET ID=? WHERE ID=?",TALKPEOPLES,[NSNumber numberWithInteger:i-1],[NSNumber numberWithInteger:i]];
            
        }
    }else if([itemName isEqualToString:BallDialogs])
    {
    
        if(![_dataBase goodConnection])
            [_dataBase open];
        NSString *tableName = [self getTableNameForUid:uid];
        
        tableName=[tableName stringByAppendingString:@"ball"];
        
        if(![_dataBase tableExists:tableName])
        {
            [_dataBase close];
            return;
        }
        
        NSString *query = [NSString stringWithFormat:@"DELETE FROM %@ WHERE ID=?",tableName];
        NSArray *dataArr = nil;
        if([data isKindOfClass:[NSDictionary class]])
            dataArr = [NSArray arrayWithObject:data];
        else
            dataArr = [NSArray arrayWithArray:data];
        for(NSDictionary *aChat in dataArr)
        {
            
            BOOL s = [_dataBase executeUpdate:query,VALUE(KeyID, aChat)];
            if(!s)
            {
               NSLog(@"database action error:%@",[[_dataBase lastError] description]);

            }
            
        }
    
    }else
    {
        if(![_dataBase goodConnection])
            [_dataBase open];
        if(![_dataBase tableExists:BallList])
        {
            [_dataBase close];
            return;
        }
        
        NSString *query = [NSString stringWithFormat:@"DELETE FROM %@ WHERE ID=?",BallList];
        NSArray *dataArr = nil;
        if([data isKindOfClass:[NSDictionary class]])
            dataArr = [NSArray arrayWithObject:data];
        else
            dataArr = [NSArray arrayWithArray:data];
        for(NSDictionary *aChat in dataArr)
        {
            
            BOOL s = [_dataBase executeUpdate:query,VALUE(KeyID, aChat)];
            if(!s)
            {
                NSLog(@"database action error:%@",[[_dataBase lastError] description]);

            }
            
            
            NSString *query = [NSString stringWithFormat:@"SELECT ID FROM %@ WHERE ID=(SELECT MAX(ID) FROM %@)",BallList,BallList];
            NSInteger maxID =[_dataBase intForQuery:query];
            for(int i=[VALUE(KeyID, aChat) integerValue]+1; i<maxID+1; i++)
                [_dataBase executeUpdate:@"UPDATE %@ SET ID=? WHERE ID=?",BallList,[NSNumber numberWithInteger:i-1],[NSNumber numberWithInteger:i]];
            
        }
        
        
        
        
        
    
    
    }
    
    
}

- (void)removeTableNamed:(NSString *)tableName
{
    if(![_dataBase goodConnection])
        [_dataBase open];
    [_dataBase executeUpdate:[NSString stringWithFormat:@"DROP TABLE IF EXISTS %@",tableName] withArgumentsInArray:nil];
}

#warning 通过用户的id，取出talkarr和dialogs

- (NSMutableArray *)readMoreDataForCurrentDialogFromUid:(NSString *)_uid :(NSInteger)readNum
{
    NSInteger fromIndex = AllData;
    /******************************************/
    //    [_dialogs removeAllObjects];
    /****************************************/
    
    if(![_dataBase goodConnection])
    {
        if(![_dataBase open])
            return NO;
    }
    
    NSString *tableName = [self getTableNameForUid:_uid];
    
    if(![_dataBase tableExists:tableName])
    {
        [_dataBase close];
        return NO;
    }
    if(readNum == AllData)
    {
        NSString *query = [NSString stringWithFormat:@"SELECT * FROM %@",tableName];
        FMResultSet *rs = [_dataBase executeQuery:query];
        
        NSMutableArray *newMsgs = [NSMutableArray arrayWithCapacity:1];
        while ([rs next]) {
            NSDictionary *amsg = [NSDictionary dictionaryWithObjectsAndKeys:
                                  [NSNumber numberWithInteger:[rs intForColumn:KeyID]],     KeyID,
                                  [MyAppDataManager IsInternationalLanguage:[rs stringForColumn:KeyContent]],                          KeyContent,
                                  [NSNumber numberWithBool:[rs boolForColumn:KeyMe]],       KeyMe,
                                  [NSNumber numberWithInteger:[rs intForColumn:KeyStatus]], KeyStatus,
                                  [NSNumber numberWithInteger:[rs intForColumn:KeyType]],   KeyType,
                                  [NSNumber numberWithInteger:[rs intForColumn:KeyHeight]], KeyHeight,
                                  [rs stringForColumn:KeyStime],                            KeyStime,
                                  [NSNumber numberWithBool:[rs boolForColumn:KeyShowtime]], KeyShowtime,
                                  [rs stringForColumn:KeyUface],                            KeyUface,
                                  [NSNumber numberWithInteger:[rs intForColumn:KeyMediaStatus]],KeyMediaStatus,
                                  [rs stringForColumn:KeyShowFrom],                         KeyShowFrom,
                                  nil];
            [newMsgs addObject:amsg];
            
        }
        return newMsgs;
    }
    else
    {
        NSLog(@"************************************************************%@",tableName);
        NSString *query = [NSString stringWithFormat:@"SELECT ID FROM %@ WHERE ID=(SELECT MAX(ID) FROM %@)",tableName,tableName];
        fromIndex =[_dataBase intForQuery:query];
        
        NSInteger toIndex = (fromIndex>19)?(fromIndex-readNum):0;
        NSLog(@"%d",toIndex);
        query = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE ID BETWEEN ? AND ?",tableName];
        
        FMResultSet *rs = [_dataBase executeQuery:query,[NSNumber numberWithInteger:toIndex],[NSNumber numberWithInteger:fromIndex]];
        NSMutableArray *newMsgs = [NSMutableArray arrayWithCapacity:1];
        while ([rs next]) {
            NSDictionary *amsg = [NSDictionary dictionaryWithObjectsAndKeys:
                                  [NSNumber numberWithInteger:[rs intForColumn:KeyID]],     KeyID,
                                  [MyAppDataManager IsInternationalLanguage:[rs stringForColumn:KeyContent]],                          KeyContent,
                                  [NSNumber numberWithBool:[rs boolForColumn:KeyMe]],       KeyMe,
                                  [NSNumber numberWithInteger:[rs intForColumn:KeyStatus]], KeyStatus,
                                  [NSNumber numberWithInteger:[rs intForColumn:KeyType]],   KeyType,
                                  [NSNumber numberWithInteger:[rs intForColumn:KeyHeight]], KeyHeight,
                                  [rs stringForColumn:KeyStime],                            KeyStime,
                                  [NSNumber numberWithBool:[rs boolForColumn:KeyShowtime]], KeyShowtime,
                                  [rs stringForColumn:KeyUface],                            KeyUface,
                                  [NSNumber numberWithInteger:[rs intForColumn:KeyMediaStatus]],KeyMediaStatus,
                                  
                                  [rs stringForColumn:KeyShowFrom],                        KeyShowFrom,
                                  
                                  nil];
            [newMsgs addObject:amsg];
        }
        //        [newMsgs addObjectsFromArray:_dialogs];
        return newMsgs;
        //        self.dialogs = [NSMutableArray arrayWithArray:newMsgs];
        
    }
    return nil;
    
}


// 这是对话的
- (BOOL)readMoreDataForCurrentDialog:(NSInteger)readNum
{
    NSInteger fromIndex = AllData;
    /******************************************/
//    [_dialogs removeAllObjects];
    /****************************************/
    if(_dialogs.count)
    {
        fromIndex = [[[_dialogs objectAtIndex:0] valueForKey:KeyID] integerValue]-1;
        
        if(fromIndex<1)
            return NO;
    }
    if(![_dataBase goodConnection])
    {
        if(![_dataBase open])
            return NO;
    }
    
    NSString *tableName = [self getTableNameForUid:self.chatuid];
  
    if(![_dataBase tableExists:tableName])
    {
        [_dataBase close];
        return NO;
    }
    
    if(readNum == DefaultReadNum)
    {
        NSString *query = [NSString stringWithFormat:@"SELECT ID FROM %@ WHERE ID=(SELECT MAX(ID) FROM %@)",tableName,tableName];
        fromIndex =[_dataBase intForQuery:query];
        
        NSInteger toIndex = (fromIndex>19)?(fromIndex-DefaultReadNum):0;
        query = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE ID BETWEEN ? AND ?",tableName];
        
        FMResultSet *rs = [_dataBase executeQuery:query,[NSNumber numberWithInteger:toIndex],[NSNumber numberWithInteger:fromIndex]];
        NSMutableArray *newMsgs = [NSMutableArray arrayWithCapacity:1];
        while ([rs next]) {
            NSDictionary *amsg = [NSDictionary dictionaryWithObjectsAndKeys:
                                  [NSNumber numberWithInteger:[rs intForColumn:KeyID]],     KeyID,
                                  [MyAppDataManager IsInternationalLanguage:[rs stringForColumn:KeyContent]],                          KeyContent,
                                  [NSNumber numberWithBool:[rs boolForColumn:KeyMe]],       KeyMe,
                                  [NSNumber numberWithInteger:[rs intForColumn:KeyStatus]], KeyStatus,
                                  [NSNumber numberWithInteger:[rs intForColumn:KeyType]],   KeyType,
                                  [NSNumber numberWithInteger:[rs intForColumn:KeyHeight]], KeyHeight,
                                  [rs stringForColumn:KeyStime],                            KeyStime,
                                  [NSNumber numberWithBool:[rs boolForColumn:KeyShowtime]], KeyShowtime,
                                  [rs stringForColumn:KeyUface],                            KeyUface,
                                  [NSNumber numberWithInteger:[rs intForColumn:KeyMediaStatus]],KeyMediaStatus,
                                  
                                   [rs stringForColumn:KeyShowFrom],                        KeyShowFrom,
                                  
                                  nil];
            [newMsgs addObject:amsg];
        }
        [newMsgs addObjectsFromArray:_dialogs];
        
        self.dialogs = [NSMutableArray arrayWithArray:newMsgs];
        
    }
    else
    {
        NSString *query = [NSString stringWithFormat:@"SELECT * FROM %@",tableName];
        FMResultSet *rs = [_dataBase executeQuery:query];
       
        while ([rs next]) {
            NSDictionary *amsg = [NSDictionary dictionaryWithObjectsAndKeys:
                                  [NSNumber numberWithInteger:[rs intForColumn:KeyID]],     KeyID,
                                   [MyAppDataManager IsInternationalLanguage:[rs stringForColumn:KeyContent]],                          KeyContent,
                                  [NSNumber numberWithBool:[rs boolForColumn:KeyMe]],       KeyMe,
                                  [NSNumber numberWithInteger:[rs intForColumn:KeyStatus]], KeyStatus,
                                  [NSNumber numberWithInteger:[rs intForColumn:KeyType]],   KeyType,
                                  [NSNumber numberWithInteger:[rs intForColumn:KeyHeight]], KeyHeight,
                                  [rs stringForColumn:KeyStime],                            KeyStime,
                                  [NSNumber numberWithBool:[rs boolForColumn:KeyShowtime]], KeyShowtime,
                                  [rs stringForColumn:KeyUface],                            KeyUface,
                                  [NSNumber numberWithInteger:[rs intForColumn:KeyMediaStatus]],KeyMediaStatus,
                                  [rs stringForColumn:KeyShowFrom],                         KeyShowFrom,
                                  nil];
            [_talkArr addObject:amsg];
        
        }
    }
    return YES;
}
-(BOOL)readMoreTwentyMessage
{
    
    if(![_dataBase goodConnection])
    {
        if(![_dataBase open])
            return NO;
    }
    
    NSString *tableName = [self getTableNameForUid:self.chatuid];
    
    if(![_dataBase tableExists:tableName])
    {
        [_dataBase close];
        return NO;
    }
    

    int number=[_dialogs count];
    
    if(number==0)
        return NO;
        
    NSString *query = [NSString stringWithFormat:@"SELECT ID FROM %@ WHERE ID=(SELECT MAX(ID) FROM %@)",tableName,tableName];

    int  fromIndex =[_dataBase intForQuery:query];
    
    
    number=fromIndex-number;
    
    NSInteger toIndex = (number>19)?(number-DefaultReadNum):0;
    query = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE ID BETWEEN ? AND ?",tableName];
   
    [_dialogs removeAllObjects];
    FMResultSet *rs = [_dataBase executeQuery:query,[NSNumber numberWithInteger:toIndex],[NSNumber numberWithInteger:fromIndex]];
    

    NSMutableArray *newMsgs = [NSMutableArray arrayWithCapacity:1];
    while ([rs next]) {
        NSDictionary *amsg = [NSDictionary dictionaryWithObjectsAndKeys:
                              [NSNumber numberWithInteger:[rs intForColumn:KeyID]],     KeyID,
                              [MyAppDataManager IsInternationalLanguage:[rs stringForColumn:KeyContent]],                          KeyContent,
                              [NSNumber numberWithBool:[rs boolForColumn:KeyMe]],       KeyMe,
                              [NSNumber numberWithInteger:[rs intForColumn:KeyStatus]], KeyStatus,
                              [NSNumber numberWithInteger:[rs intForColumn:KeyType]],   KeyType,
                              [NSNumber numberWithInteger:[rs intForColumn:KeyHeight]], KeyHeight,
                              [rs stringForColumn:KeyStime],                            KeyStime,
                              [NSNumber numberWithBool:[rs boolForColumn:KeyShowtime]], KeyShowtime,
                              [rs stringForColumn:KeyUface],                            KeyUface,
                              [NSNumber numberWithInteger:[rs intForColumn:KeyMediaStatus]],KeyMediaStatus,
                              
                              [rs stringForColumn:KeyShowFrom],                        KeyShowFrom,
                              
                              nil];
        [newMsgs addObject:amsg];
    }
    [newMsgs addObjectsFromArray:_dialogs];
    
    self.dialogs = [NSMutableArray arrayWithArray:newMsgs];
    
   return YES;
}


// 这是抛绣球的

-(BOOL)readmoredataforBall:(NSString *)item
{
  if([item isEqual:BallDialogs])
  {
  
      NSInteger fromIndex = AllData;
      if(_ballTalk.count)
      {
          fromIndex = [[[_ballTalk objectAtIndex:0] valueForKey:KeyID] integerValue]-1;
          if(fromIndex<1)
              return NO;
      }
      if(![_dataBase goodConnection])
      {
          if(![_dataBase open])
              return NO;
      }
      
      NSString *tableName = [self getTableNameForUid:self.chatuid];
      tableName=[tableName stringByAppendingString:@"ball"];
      if(![_dataBase tableExists:tableName])
      {
          [_dataBase close];
          return NO;
      }
      
          NSString *query = [NSString stringWithFormat:@"SELECT ID FROM %@ WHERE ID=(SELECT MAX(ID) FROM %@)",tableName,tableName];
          fromIndex =[_dataBase intForQuery:query];
          NSInteger toIndex = (fromIndex>19)?(fromIndex-DefaultReadNum):0;
          query = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE ID BETWEEN ? AND ?",tableName];
          FMResultSet *rs = [_dataBase executeQuery:query,[NSNumber numberWithInteger:toIndex],[NSNumber numberWithInteger:fromIndex]];
          NSMutableArray *newMsgs = [NSMutableArray arrayWithCapacity:1];
          while ([rs next]) {
              NSDictionary *amsg = [NSDictionary dictionaryWithObjectsAndKeys:
                                    [NSNumber numberWithInteger:[rs intForColumn:KeyID]],     KeyID,
                                    [rs stringForColumn:KeyContent],                          KeyContent,
                                    [NSNumber numberWithBool:[rs boolForColumn:KeyMe]],       KeyMe,
                                    [NSNumber numberWithInteger:[rs intForColumn:KeyStatus]], KeyStatus,
                                    [NSNumber numberWithInteger:[rs intForColumn:KeyType]],   KeyType,
                                    [NSNumber numberWithInteger:[rs intForColumn:KeyHeight]], KeyHeight,
                                    [rs stringForColumn:KeyStime],                            KeyStime,
                                    [NSNumber numberWithBool:[rs boolForColumn:KeyShowtime]], KeyShowtime,
                                    [rs stringForColumn:KeyUface],                            KeyUface,
                                    [NSNumber numberWithInteger:[rs intForColumn:KeyMediaStatus]],KeyMediaStatus,
                                    nil];
              [newMsgs addObject:amsg];
          }
          [newMsgs addObjectsFromArray:_ballTalk];
          
          self.ballTalk = [NSMutableArray arrayWithArray:newMsgs];
  
      
      
      
         return YES;
  }
    
    return NO;
    
}

- (void)readTalkList:(NSString *)item
{
    if([item isEqual:TALKPEOPLES]){
        if(![_dataBase goodConnection])
            [_dataBase open];
        if(![_dataBase tableExists:TALKPEOPLES])
        {
            NSDictionary *queryDic = [NSDictionary dictionaryWithObjectsAndKeys:
                                      DBFieldType_INTEGER, KeyID,
                                      DBFieldType_TEXT,    KeyFromUid,
                                      DBFieldType_TEXT,    KeyUface,
                                      DBFieldType_TEXT,    KeyUname,
                                      DBFieldType_TEXT,    KeyAge,
                                      DBFieldType_BOOL,    KeySex,
                                      DBFieldType_TEXT,    KeyContent,
                                      DBFieldType_TEXT,    KeyStime,
                                      DBFieldType_INTEGER, KeyUnreadNum,
                                      DBFieldType_TEXT,    KeyType,
                                      DBFieldType_TEXT,    KeyCompany,
                                      DBFieldType_TEXT,    KeyHbody,
                                      DBFieldType_TEXT,    KeyJobtitle,
                                      DBFieldType_TEXT,    KeyLiked,
                                      
                                      DBFieldType_TEXT,    KeyLovego,
                                      DBFieldType_TEXT,    KeySayme,
                                      DBFieldType_TEXT,    KeySchool,
                                      DBFieldType_TEXT,    KeySstar,
                                      DBFieldType_TEXT,    KeyWbody,
                                      DBFieldType_TEXT,    KeyXblood,
                                      DBFieldType_TEXT,    KeyDtime,
                                      DBFieldType_TEXT,    KeyDmeter,
                                      DBFieldType_TEXT,    KeyFacelist,
                                      DBFieldType_BOOL,     KeyMe,
                                      DBFieldType_TEXT,    KeyStatus,
                                      nil];
            
            NSString *query = [NSString stringWithFormat:@"CREATE TABLE %@ (%@)",TALKPEOPLES,[self getPar1StrFromDic:queryDic]];
           
            [_dataBase executeUpdate:query];
           
            return;
        }
        else
        {
    //        NSString *query = [NSString stringWithFormat:@"SELECT * FROM %@",TALKPEOPLES];
            NSString *query = [NSString stringWithFormat:@"SELECT * FROM %@ ORDER BY %@ DESC",TALKPEOPLES,KeyStime];
            
            FMResultSet *rs = [_dataBase executeQuery:query];
            [_talkPeoples removeAllObjects];
            while ([rs next]) {
                
                NSString *type = [rs stringForColumn:KeyType];
                NSString *str1;
                if([type isEqualToString:@"text"]||[type isEqualToString:@"emi"])
                {
//                    if([type isEqual:@"emi"])
//                    {
//                        NSString *str = [rs stringForColumn:KeyLasttalk];
//                        int t=[MyAppDataManager.emiNameArr indexOfObject:str];
//                        str1=[MyAppDataManager.emiLanguageArr objectAtIndex:t];
//
//                    }
//                    else
//                    {
//                        str1 = [rs stringForColumn:KeyLasttalk];
//                    }
                    str1 =  [rs stringForColumn:KeyLasttalk];
                }
                else
                {
                    NSDictionary *mapDic = [NSDictionary dictionaryWithObjectsAndKeys:NSLocalizedString(@"talkPicture", nil),@"image",NSLocalizedString(@"talkLocation", nil),@"location",NSLocalizedString(@"talkSound", nil),@"sound",nil];
                    //                str1 = ;
                    if(![[rs stringForColumn:KeyLasttalk] isEqualToString:@""])
                    {
//                        NSLog(@"%@",[rs stringForColumn:KeyType]);
                        str1 = [NSString stringWithFormat:@"%@",VALUE([rs stringForColumn:KeyType], mapDic)];
                    }
                    else
                        str1=@"";

                }
//                NSLog(@"%@",[rs stringForColumn:KeyContent]);
                NSDictionary *amsg = [NSDictionary dictionaryWithObjectsAndKeys:
                                      [NSNumber numberWithInteger:[rs intForColumn:KeyID]],    KeyID,
                                      [rs stringForColumn:KeyFromUid],                         KeyFromUid,
                                      [rs stringForColumn:KeyUface],                           KeyUface,
                                      
                                      [MyAppDataManager theRevisedName:[rs stringForColumn:KeyUname] andUID:[rs stringForColumn:KeyFromUid]],
                                          KeyUname,
                                      [rs stringForColumn:KeyAge],                             KeyAge,
                                      [NSNumber numberWithBool:[rs boolForColumn:KeySex]],
                                      KeySex,
                                      [MyAppDataManager IsInternationalLanguage:str1],
                                      KeyContent,
                                      [MyAppDataManager currentTime:[rs stringForColumn:KeyStime]],                           KeyStime,
                                      [rs stringForColumn:KeyType],                            KeyType,
    //                                  [MyAppDataManager IsInternationalLanguage:str1],
    //                                      KeySayme,
                                      [rs stringForColumn:KeySchool],                          KeySchool,
                                      [rs stringForColumn:KeyLiked],                           KeyLiked,
                                      [rs stringForColumn:KeySayme],                           KeySayme,
                                      [rs stringForColumn:KeyJobtitle],                       KeyJobtitle,
                                      [rs stringForColumn:KeyHbody],                          KeyHbody,
                                       [rs stringForColumn:KeySstar],                          KeySstar,
                                      [rs stringForColumn:KeyWbody],                          KeyWbody,
                                      [rs stringForColumn:KeyXblood],                         KeyXblood,
                                      [rs stringForColumn:KeyDtime],KeyDtime,
                                      
                                      [rs stringForColumn:KeyDmeter],KeyDmeter,
                                      
                                      [NSNumber numberWithInteger:[rs intForColumn:KeyUnreadNum]],KeyUnreadNum,
                                      
                                      [rs stringForColumn:KeyFacelist],                       KeyFacelist,
                                      
                                      [rs stringForColumn:KeyMe],                             KeyMe,
                                      [rs stringForColumn:KeyStatus],                         KeyStatus,
                                      nil];

                //            NSLog(@"%@-----%@",str1,[rs stringForColumn:KeySayme]);
                NSData *temp=[[amsg valueForKey:@"facelist"] dataUsingEncoding:NSUTF8StringEncoding];
                
                NSArray *arr=[[NSArray alloc]initWithArray:[[CJSONDeserializer deserializer] deserializeAsArray:temp error:nil]];
             
                NSMutableDictionary *dic=[NSMutableDictionary dictionaryWithDictionary:amsg];
                
                [dic setValue:arr forKey:@"facelist"];
            
                [arr release];
                
    //            NSLog(@"%@-----%@",amsg,dic);
                
                [_talkPeoples addObject:dic];
                
            
            }
            
            }
        
    
    }
    else{
        if(![_dataBase goodConnection])
            [_dataBase open];
        if(![_dataBase tableExists:BallList])
        {
            NSDictionary *queryDic = [NSDictionary dictionaryWithObjectsAndKeys:
                                      DBFieldType_INTEGER, KeyID,
                                      DBFieldType_TEXT,    KeyFromUid,
                                      DBFieldType_TEXT,    KeyUface,
                                      DBFieldType_TEXT,    KeyUname,
                                      DBFieldType_TEXT,    KeyAge,
                                      DBFieldType_BOOL,    KeySex,
                                      DBFieldType_TEXT,    KeyContent,
                                      DBFieldType_TEXT,    KeyStime,
                                      DBFieldType_INTEGER, KeyUnreadNum,
                                      DBFieldType_TEXT,    KeyType,
                                      DBFieldType_TEXT,    KeyCompany,
                                      DBFieldType_TEXT,    KeyHbody,
                                      DBFieldType_TEXT,    KeyJobtitle,
                                      DBFieldType_TEXT,    KeyLiked,
                                      
                                      DBFieldType_TEXT,    KeyLovego,
                                      DBFieldType_TEXT,    KeySayme,
                                      DBFieldType_TEXT,    KeySchool,
                                      DBFieldType_TEXT,    KeySstar,
                                      DBFieldType_TEXT,    KeyWbody,
                                      DBFieldType_TEXT,    KeyXblood,
                                      DBFieldType_TEXT,    KeyFacelist,
                                      nil];
            
            NSString *query = [NSString stringWithFormat:@"CREATE TABLE %@ (%@)",BallList,[self getPar1StrFromDic:queryDic]];
            
            [_dataBase executeUpdate:query];
            
            return;
        }
        else
        {
            NSString *query = [NSString stringWithFormat:@"SELECT * FROM %@",BallList];
            FMResultSet *rs = [_dataBase executeQuery:query];
            [_playBall removeAllObjects];
            while ([rs next]) {
                NSDictionary *amsg = [NSDictionary dictionaryWithObjectsAndKeys:
                                      [NSNumber numberWithInteger:[rs intForColumn:KeyID]],    KeyID,
                                      [rs stringForColumn:KeyFromUid],                         KeyFromUid,
                                      [rs stringForColumn:KeyUface],                           KeyUface,
                                      [rs stringForColumn:KeyUname],                           KeyUname,
                                      [rs stringForColumn:KeyAge],                             KeyAge,
                                      [NSNumber numberWithBool:[rs boolForColumn:KeySex]],     KeySex,
                                      [rs stringForColumn:KeyLasttalk],                        KeyContent,
                                      [rs stringForColumn:KeyStime],                           KeyStime,
                                      [rs stringForColumn:KeyType],                            KeyType,
                                      [rs stringForColumn:KeySayme],                           KeySayme,
                                      [rs stringForColumn:KeySchool],                          KeySchool,
                                      [rs stringForColumn:KeyLiked],                           KeyLiked,
                                      [rs stringForColumn:KeySayme],                           KeySayme,
                                      [rs stringForColumn:KeyJobtitle],                       KeyJobtitle,
                                      [rs stringForColumn:KeyHbody],                          KeyHbody,
                                      [rs stringForColumn:KeySstar],                          KeySstar,
                                      [rs stringForColumn:KeyWbody],                          KeyWbody,
                                      [rs stringForColumn:KeyXblood],                         KeyXblood,
                                      [NSNumber numberWithInteger:[rs intForColumn:KeyUnreadNum]],KeyUnreadNum,
                                      [rs stringForColumn:KeyFacelist],                       KeyFacelist,
                                      nil];
                
                
                
                NSData *temp=[[amsg valueForKey:@"facelist"] dataUsingEncoding:NSUTF8StringEncoding];
                
                NSArray *arr=[[NSArray alloc]initWithArray:[[CJSONDeserializer deserializer] deserializeAsArray:temp error:nil]];
                
                NSMutableDictionary *dic=[NSMutableDictionary dictionaryWithDictionary:amsg];
                
                [dic setValue:arr forKey:@"facelist"];
                //加一个BOOL，判断是否选中
                [dic setValue:@"0" forKey:@"isChecked"];
                
                [arr release];
                
                [_playBall addObject:dic];
                
                
            }
            
        }
    
    }
        
}

- (UIImage *)imageForImageUrlStr:(NSString *)fileUrlStr
{
    NSString *filePath = [AppComManager pathForMedia:fileUrlStr];
    NSData *imageData = [NSData dataWithContentsOfFile:filePath];
    if(imageData)
        return [UIImage imageWithData:imageData];
    else
        return [UIImage imageNamed:@"defaultuser.png"];
}

-(NSData *)imageDataForImageUrlStr:(NSString *)fileUrlStr{
    NSString *filePath = [AppComManager pathForMedia:fileUrlStr];
    NSData *imageData = [NSData dataWithContentsOfFile:filePath];
    
    return imageData;
}

- (void)banbuRequestDidFinished:(NSDictionary *)resDic error:(NSError *)error
{
//    NSLog(@"%@",resDic);
    static  BOOL isRead=NO;
    if(error)
    {
        if(![error.domain isEqualToString:BanBuDataformatError] && [[error.userInfo valueForKey:@"fc"] isEqualToString:BanBu_SendMessage_To_Server])
        {
            NSInteger row = [[error.userInfo valueForKey:@"requestid"] integerValue];
            NSMutableDictionary *amsg = [NSMutableDictionary dictionaryWithDictionary:[self.dialogs objectAtIndex:row]];
            [amsg setValue:[NSNumber numberWithInteger:ChatStatusSendFail] forKey:KeyStatus];
            [self.dialogs replaceObjectAtIndex:row withObject:amsg];
            
            [self updateData:amsg forItem:DIALOGS forUid:[resDic valueForKey:KeyUid]];
            //啊 我擦
            NSMutableDictionary *dic=[[[NSMutableDictionary alloc]initWithDictionary:[UserDefaults valueForKey:@"my"]] autorelease];
            [dic setValue:@"0" forKey:KeyStatus];
            
            [self updateDialogeListWithSendMsg:dic forUid:[resDic valueForKey:KeyUid] Item:DIALOGS];
            
            
            if(_appChatController)
            {
                BanBu_ChatCell *cell = (BanBu_ChatCell *)[_appChatController.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:0]];
                if(cell)
                {
                    [cell setStatus:ChatStatusSendFail];
                }
            }
        }
        return;
    }
    
    
    
    if([[resDic valueForKey:@"ok"] boolValue])
    {
        // 接收个人 对 个人的聊天
        if([AppComManager respondsDic:resDic isFunctionData:BanBu_ReceiveMessage_From_Server])
        {
            NSLog(@"%@",resDic);

            NSArray *msglist = [AppComManager getMessageDic:resDic];
            
            NSInteger rowNum = self.dialogs.count;
            
            if([[resDic valueForKey:@"statuslist"] count]>0)
            {
                /// what is this are hahaha
                //???????????????_isSend=yes;
                
                NSLog(@"%@",resDic);
                if([[[[resDic valueForKey:@"statuslist"] objectAtIndex:0 ]valueForKey:@"status"] isEqual:@"r"]&&_isSend==YES)
                {
                    _isSend=NO;
                    
                    isRead=YES;
                    
                    /***************************************************/
                    
                    // 这样的时间消耗度太大了
                    for(int i=0;i<[MyAppDataManager.dialogs count];i++)
                    {
                        // [UserDefaults valueForKey:@"read"]
                        if([MyAppDataManager.dialogs count]!=0){
                            
                            NSMutableDictionary *amsg=[MyAppDataManager.dialogs objectAtIndex:i];
                            
                            NSMutableDictionary *amsg1=[[[NSMutableDictionary alloc]initWithDictionary:amsg] autorelease];
                            
                            // 判断这条消息是不是自己的
                            
                            if([[amsg1 valueForKey:KeyMe] boolValue]&&[[amsg1 valueForKey:KeyStatus] intValue]==1)
                            {
                                
                                [amsg1 setValue:[NSNumber numberWithInteger:ChatStatusReaded] forKey:KeyStatus];
                                
                                [amsg1 setValue:@"0" forKey:KeyMediaStatus];
                                
                                [MyAppDataManager.dialogs replaceObjectAtIndex:i withObject:amsg1];
                                
                                 [_appChatController.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:i inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
                            
                                
                                [self updateData:amsg1 forItem:DIALOGS forUid:[resDic valueForKey:KeyFromUidTalk]];
                                
#warning 点对点的更新已读送达状态，先禁掉。
                                
                                //为了更新对话列表里的消息状态
                                
//                                NSMutableDictionary *dic=[[[NSMutableDictionary alloc]initWithDictionary:[UserDefaults valueForKey:@"my"]] autorelease];
//                                
//                                if(!VALUE(KeySex, dic))
//                                {
//                                    if(VALUE(KeyGender, dic))
//                                    {
//                                        BOOL isMan=[VALUE(KeyGender, dic)isEqual:@"m"];
//                                        
//                                        [dic setValue:[NSNumber numberWithBool:isMan] forKey:KeySex];
//                                        
//                                    }
//                                }else{
//                                    [dic setValue:VALUE(KeySex, dic) forKey:KeySex];
//                                    
//                                }
//                                
//                                [dic setValue:[NSNumber numberWithInteger:ChatStatusReaded] forKey:KeyStatus];
//                                
//                                [self updateDialogeListWithSendMsg:dic forUid:[resDic valueForKey:KeyFromUidTalk] Item:DIALOGS];
                                
                            }
                           
                            
                            // 更新数据库
                            
                            
                                                       
                           
                            
                        }
                        
                    }
                    
                    
                    
//  ???                  [_appChatController.tableView reloadData];
                    
                    
                }
            }else
            {
                isRead=NO;
            }
            // 防止两次刷新/*************************************/
            if([[resDic valueForKey:@"list"]count]==0)
            {
                return;
            }
            /******************************************/
            for(NSDictionary *dic in msglist)
            {
                NSArray *mapArr = [NSArray arrayWithObjects:@"text",@"image",@"location",@"sound",@"emi",nil];
                ChatCellType type = [mapArr indexOfObject:VALUE(KeyType, dic)];
                
                NSString *says = VALUE(KeyContent, dic);
                
                NSString *stime = VALUE(KeyStime, dic);
                
                NSInteger row = self.dialogs.count;
                
                NSMutableDictionary *amsg = [NSMutableDictionary dictionaryWithCapacity:2];
                [amsg setValue:[NSNumber numberWithInt:self.talkArr.count] forKey:KeyID];
                [amsg setValue:[NSNumber numberWithInt:type] forKey:KeyType];
                [amsg setValue:says forKey:KeyContent];
                [amsg setValue:[NSNumber numberWithBool:NO] forKey:KeyMe];
                [amsg setValue:VALUE(KeyUface, _appChatController.profile) forKey:KeyUface];
                [amsg setValue:[NSNumber numberWithInt:ChatStatusNone] forKey:KeyStatus];
                
                [amsg setValue:VALUE(KeyShowFrom, dic) forKey:KeyShowFrom];
                
                NSString *lastTimeStr = nil;
                if(row)
                    
                    lastTimeStr = [[MyAppDataManager.dialogs objectAtIndex:row-1] valueForKey:KeyStime];
                
                
                [amsg setValue:stime forKey:KeyStime];
                
                BOOL showTime = NO;
                if(!self.dialogs.count)
                {
                    showTime = YES;
                }
                else
                    showTime = [_appChatController fiveMinuteLater:stime beforeTime:lastTimeStr];
                
                
                
                [amsg setValue:[NSNumber numberWithBool:showTime] forKey:KeyShowtime];
                
                // 接受到的msg 的信息
                
                BOOL showFrom=![VALUE(KeyShowFrom, dic) isEqual:@"mo"];
                
                // 显示时间只显示一次 次奥
                
                float height = 0;
                
                if(type == ChatCellTypeImage)
                {
                    [amsg setValue:[NSNumber numberWithInteger:MediaStatusDownload] forKey:KeyMediaStatus];
                    height = ImageTypeHeight;
                }
                else if(type == ChatCellTypeLocation)
                    height = locationTypeHeight;
                else if(type == ChatCellTypeVoice)
                {
                    [amsg setValue:[NSNumber numberWithInteger:MediaStatusDownload] forKey:KeyMediaStatus];
                    height = VoiceTypeHeight;
                }else if(type==ChatCellTypeEmi)
                {
                    height = ImageTypeHeight;
                }
                else
                    height = [BanBu_SmileLabel heightForText:[MyAppDataManager IsInternationalLanguage:says]];
                
                height += 2*CellMarge+(showTime?TimeLabelHeight:0)+(showFrom?18:0);
                
                if(type==ChatCellTypeImage||type==ChatCellTypeVoice)
                {
                    height=height+(showFrom?8:0);
                }
                
                
                [amsg setValue:[NSNumber numberWithFloat:height] forKey:KeyHeight];
                
                
                if((type == ChatCellTypeImage) || (type == ChatCellTypeVoice))
                {
                    
                    //  [AppComManager getBanBuMedia:[amsg valueForKey:KeyContent] forMsgID:MyAppDataManager.talkArr.count fromUid:[resDic valueForKey:KeyUid] delegate:self];
                    
                }
                [self.talkArr addObject:amsg];
                
                // 这里加一个回调判断是否已经读了发送的信息
                
                [self insertData:amsg forItem:DIALOGS forUid:[resDic valueForKey:KeyFromUidTalk]];
                
                
                [amsg setValue:[MyAppDataManager IsInternationalLanguage:says] forKey:KeyContent];

                [self.dialogs addObject:amsg];
                
            

                NSMutableDictionary *amsgt=[[[NSMutableDictionary alloc]initWithDictionary:[UserDefaults valueForKey:@"zouni"]] autorelease];
                
                //   NSMutableDictionary *amsgt=[MyAppDataManager.talkPeoples objectAtIndex:[VALUE(KeyID, amsg) intValue]-1];
                
                [amsgt setValue:VALUE(KeyID, amsg) forKey:KeyID];
                
                [amsgt setValue:VALUE(KeyMe, amsg) forKey:KeyMe];
                
                [amsgt setValue:VALUE(KeyContent, amsg) forKey:KeyContent];
                
                [amsgt setValue:VALUE(KeyStatus, amsg) forKey:KeyStatus];
                
            
                NSMutableDictionary *amsgtt=[[[NSMutableDictionary alloc]init]autorelease];
                
                
                [amsgtt setValue:VALUE(KeyID, amsg) forKey:KeyID];
                
                [amsgtt setValue:VALUE(KeyMe, amsg) forKey:KeyMe];
                
                [amsgtt setValue:VALUE(KeyContent, amsg) forKey:KeyContent];
                
                [amsgtt setValue:VALUE(KeyStatus, amsg) forKey:KeyStatus];
                
                [amsgtt setValue:VALUE(KeyStime, amsg) forKey:KeyStime];
                
                [amsgtt setValue:VALUE(KeyFacelist, amsgt) forKey:KeyFacelist];
                
                [amsgtt setValue:VALUE(KeyDmeter, amsgt) forKey:KeyDmeter];
                
                [amsgtt setValue:VALUE(KeyHbody, amsgt) forKey:KeyHbody];
                
                [amsgtt setValue:VALUE(KeyJobtitle, amsgt) forKey:KeyJobtitle];
                
                [amsgtt setValue:VALUE(KeyLiked, amsgt) forKey:KeyLiked];
                
                [amsgtt setValue:VALUE(@"ltime", amsgt) forKey:@"ltime"];
                
                [amsgtt setValue:VALUE(KeyAge, amsgt) forKey:KeyAge];
                
                [amsgtt setValue:VALUE(KeyPname, amsgt) forKey:KeyPname];
                
                [amsgtt setValue:VALUE(KeySayme, amsgt) forKey:KeySayme];
                
                [amsgtt setValue:VALUE(KeySchool, amsgt) forKey:KeySchool];
                
                if(!VALUE(KeySex, amsgt))
                {
                    if(VALUE(KeyGender, amsgt))
                    {
                        BOOL isMan=[VALUE(KeyGender, amsgt)isEqual:@"m"];
                        
                        [amsgtt setValue:[NSNumber numberWithBool:isMan] forKey:KeySex];
                        
                    }
                }else{
                    [amsgtt setValue:VALUE(KeySex, amsgt) forKey:KeySex];

                }

                
                [amsgtt setValue:VALUE(KeySstar, amsgt) forKey:KeySstar];
                
                [amsgtt setValue:[mapArr objectAtIndex:[VALUE(KeyType, amsg) intValue]] forKey:KeyType];
                
                [amsgtt setValue:VALUE(KeyUface, amsgt) forKey:KeyUface];
                
                [amsgtt setValue:@"0" forKey:KeyUnreadNum];
                
                [amsgtt setValue:VALUE(KeyFromUid, amsgt) forKey:KeyFromUid];
                
                [amsgtt setValue:VALUE(KeyWbody, amsgt) forKey:KeyWbody];
                
                [amsgtt setValue:VALUE(KeyXblood, amsgt) forKey:KeyXblood];
                
                
//                NSLog(@"%@",amsgtt);
                [self updateDialogeListWithSendMsg:amsgtt forUid:[resDic valueForKey:KeyFromUidTalk] Item:DIALOGS];
                
            }
            
            if(_appChatController)
            {
                // 这是每次取到更新列表的东西
            
              
                
                [_appChatController.tableView beginUpdates];
                
                NSMutableArray *indexPaths = [NSMutableArray array];
                
                for(int i=rowNum; i<self.dialogs.count; i++)
                    [indexPaths addObject:[NSIndexPath indexPathForRow:i inSection:0]];
                [_appChatController.tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationNone];
                [_appChatController.tableView endUpdates];
                
                
                if([[resDic valueForKey:@"list"] count]>0)
                {
                    [_appChatController tableViewAutoOffset];
                }
                
                
            }
        }
        
        // 从服务器获取全部的数据
        
        else if([AppComManager respondsDic:resDic isFunctionData:BanBu_ReceiveMessage_From_All])
        {
            NSLog(@"%@",resDic);
 
            BOOL keyMe=NO;
            
            // 获取对话的语言包是个数组
            id list = [resDic valueForKey:@"list"];
            
            // NSMutableDictionary *userInfor=[NSMutableDictionary dictionaryWithCapacity:10];
            NSMutableArray *msgBuffer=[NSMutableArray arrayWithCapacity:1];
            // 现在
            
            // 这是所有的加入黑名单的人
            
            NSMutableArray *blackList=[[NSMutableArray alloc] initWithArray:[[[UserDefaults valueForKey:MyAppDataManager.useruid] valueForKey:@"friendlist"] valueForKey:@"flist"]];
            
            if([list isKindOfClass:[NSArray class]])
            {
                
                for(NSDictionary *people in list)
                {
                    id MSG=[people valueForKey:@"msglist"];
                    
                    BOOL tr=NO;
                    
                    if([MSG isKindOfClass:[NSArray class]]&&tr==NO)
                    {
                        for(NSDictionary *talk in MSG)
                        {
                            
                            BOOL m = [VALUE(KeyGender, people) isEqualToString:@"m"]?YES:NO;
                            
                            NSMutableDictionary *amsg = [NSMutableDictionary dictionaryWithCapacity:10];
                            
                            [amsg setValue:[people valueForKey:KeyFromUid] forKey:KeyFromUid];
                            
                            for(NSDictionary * dic in blackList)
                            {
                                
                                if([VALUE(@"fuid", dic) isEqual:VALUE(KeyFromUid, amsg)]&&[VALUE(@"linkkind", dic)isEqual:@"x"])
                                {
                                    
                                    tr=YES;
                                    
                                    break;
                                }
                                
                            }
                            
                            
                            NSString *jsonfrom = [[CJSONSerializer serializer] serializeArray:  VALUE(@"facelist", people)];
                            
                            [amsg setValue:jsonfrom forKey:@"facelist"];
                            
                            [amsg setValue:[NSNumber numberWithBool:m] forKey:KeySex];
                            
                            [amsg setValue:VALUE(KeyAge, people) forKey:KeyAge];
                            
                            [amsg setValue:VALUE(KeyUface, people) forKey:KeyUface];
                            
                            //                            NSString *string111 =[MyAppDataManager  IsInternationalLanguage:VALUE(KeyUname, people)];
                            
                            
                            [amsg setValue:VALUE(KeyUname, people) forKey:KeyUname];
                            
                            [amsg setValue:VALUE(@"company", people) forKey:@"company"];
                            
                            [amsg setValue:VALUE(@"hbody", people) forKey:@"hbody"];
                            
                            [amsg setValue:VALUE(@"jobtitle", people) forKey:@"jobtitle"];
                            
                            [amsg setValue:VALUE(@"liked", people) forKey:@"liked"];
                            
                            [amsg setValue:VALUE(@"lovego", people) forKey:@"lovego"];
                            
                            [amsg setValue:VALUE(@"sayme", people) forKey:@"sayme"];
                            
                            [amsg setValue:VALUE(@"school", people) forKey:@"school"];
                            
                            [amsg setValue:VALUE(@"sstar", people) forKey:@"sstar"];
                            
                            [amsg setValue:VALUE(@"wbody", people) forKey:@"wbody"];
                            
                            [amsg setValue:VALUE(@"xblood", people) forKey:@"xblood"];
                            
                            [amsg setValue:[NSNumber numberWithBool:keyMe] forKey:@"Me"];
                            
                            //                            NSString *string =[MyAppDataManager  IsInternationalLanguage:VALUE(@"sstar", people)];
                            
                            [amsg setValue:VALUE(@"sstar", people) forKey:@"sstar"];
                            
                            
                            // dmeter 的改良
                            //                            NSString *string1=[MyAppDataManager IsInternationalLanguage:VALUE(KeyDmeter, people)];
                            
                            [amsg setValue:VALUE(KeyDmeter, people) forKey:KeyDmeter];
                            
                            // dtime 的改良
                            //                            NSString *string2=[MyAppDataManager IsInternationalLanguage:VALUE(@"ltime", people)];
                            
                            [amsg setValue:VALUE(@"ltime", people) forKey:KeyDtime];
                            
                            NSDictionary *says=[AppComManager getAMsgFrom64String:VALUE(KeySays, talk)];
                            
                            NSMutableDictionary *sayss=[NSMutableDictionary dictionaryWithDictionary:says];
                            
                            
                            // 获取当前日历 加上相差的时间
                            /*
                             NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
                             
                             NSDateComponents *offsetComponents = [[NSDateComponents alloc] init];
                             
                             [offsetComponents setHour:1];
                             [offsetComponents setMinute:30];
                             
                             // Calculate when, according to Tom Lehrer, World War III will end
                             NSDate *endOfWorldWar3 = [gregorian dateByAddingComponents:offsetComponents toDate:nil options:0];
                             */
                            
                            
                            
                            [amsg setValue:VALUE(KeyStime, talk) forKey:KeyStime];
                            
                            //                            [amsg setValue: [self IsInternationalLanguage:[sayss valueForKey:KeyContent]]  forKey:KeyContent];
                            [amsg setValue:[sayss valueForKey:KeyContent] forKey:KeyContent];
                            
                            [amsg setValue:VALUE(KeyType, sayss) forKey:KeyType];
                            
                            [amsg setValue:VALUE(KeyShowFrom, sayss) forKey:KeyShowFrom];
                            
                            [amsg setValue:VALUE(KeyStatus, sayss) forKey:KeyStatus];
                            // 加入黑名单的
                            
                            if(tr==NO)
                            {
                                [msgBuffer addObject:amsg];
                            }
                        }
                    }
                }
                [blackList release];
                
                /***** 插入到已有的记录里，原来没有就append到后面 ******/
                if(![_dataBase goodConnection])
                    [_dataBase open];
                
                for(NSMutableDictionary *amsg in msgBuffer)
                {
                    
                    NSString *uid = [amsg valueForKey:KeyFromUid];
                    
                    NSString *query = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE userid=%@",TALKPEOPLES,uid];
                    FMResultSet *rs = [_dataBase executeQuery:query];
                    BOOL new = YES;
                    while ([rs next]) {
                        
                        new = NO;
                        NSInteger msgID = [rs intForColumn:KeyID];
                        [amsg setValue:[NSNumber numberWithInteger:msgID] forKey:KeyID];
                        NSInteger unReadNum = [rs intForColumn:KeyUnreadNum];
                        unReadNum ++;
                        [amsg setValue:[NSNumber numberWithInteger:unReadNum] forKey:KeyUnreadNum];
                        [self updateData:amsg forItem:TALKPEOPLES forUid:uid];
                        
                    }
                    if(new)
                    {
                        NSInteger ID = 0;
                        if([_dataBase tableExists:TALKPEOPLES])
                        {
                            NSString *query = [NSString stringWithFormat:@"SELECT ID FROM %@ WHERE ID=(SELECT MAX(ID) FROM %@)",TALKPEOPLES,TALKPEOPLES];
                            ID =[_dataBase intForQuery:query]+1;
                        }
                        
                        [amsg setValue:[NSNumber numberWithInteger:ID] forKey:KeyID];
                        [amsg setValue:[NSNumber numberWithInteger:1] forKey:KeyUnreadNum];
                        
                        
                        [self insertData:amsg forItem:TALKPEOPLES forUid:uid];
                    }
                    
                    
                    BanBu_AppDelegate *appDelegate = (BanBu_AppDelegate *)[[UIApplication sharedApplication] delegate];
                    
                    [appDelegate updateBadge];
                    
                    NSInteger msgID = 0;
                    
                    NSString *tableName = [self getTableNameForUid:uid];
                    
                    if([_dataBase tableExists:tableName])
                    {
                        NSString *query = [NSString stringWithFormat:@"SELECT ID FROM %@ WHERE ID=(SELECT MAX(ID) FROM %@)",tableName,tableName];
                        
                        msgID =[_dataBase intForQuery:query]+1;
                        
                        
                    }
                    NSMutableDictionary *msg = [NSMutableDictionary dictionaryWithCapacity:1];
                    
                    NSArray *mapArr = [NSArray arrayWithObjects:@"text",@"image",@"location",@"sound",@"emi",nil];
                    NSInteger type = [mapArr indexOfObject:VALUE(KeyType, amsg)];
                    CGFloat height = 0;
                    // 这里是稿时间的
                    
                    BOOL showFrom=![VALUE(KeyShowFrom, amsg) isEqual:@"mo"];
                    
                    if(type == ChatCellTypeText)
                        height = [BanBu_SmileLabel heightForText:[MyAppDataManager IsInternationalLanguage:VALUE(KeyLasttalk, amsg)]]+2*CellMarge+TimeLabelHeight;
                    else if(type == ChatCellTypeImage)
                        height = ImageTypeHeight+2*CellMarge+TimeLabelHeight;
                    else if(type == ChatCellTypeLocation)
                        height = locationTypeHeight+2*CellMarge+TimeLabelHeight;
                    
                    else if(type==ChatCellTypeEmi)
                        height = ImageTypeHeight+2*CellMarge+TimeLabelHeight;
                    else
                        height = VoiceTypeHeight+2*CellMarge+TimeLabelHeight;
                    
                    height=height+(showFrom?18:0);
                    
                    if(type==ChatCellTypeVoice||type==ChatCellTypeImage)
                    {
                        height=height+(showFrom?8:0);
                        
                    }
                    //                        BOOL showTime = YES;
                    //                        height += 2*CellMarge+(showTime?TimeLabelHeight:0);
                    //                        NSLog(@"%@",amsg);
                    
                    [msg setValue:[NSNumber numberWithInteger:msgID] forKey:KeyID];
                    [msg setValue:VALUE(KeyLasttalk, amsg) forKey:KeyContent];
                    [msg setValue:[NSNumber numberWithBool:NO] forKey:KeyMe];
                    [msg setValue:[NSNumber numberWithInteger:4] forKey:KeyStatus];
                    [msg setValue:[NSNumber numberWithInteger:type] forKey:KeyType];
                    
                    
                    [msg setValue:VALUE(KeyShowFrom, amsg) forKey:KeyShowFrom];
                    
                    [msg setValue:VALUE(KeyStime, amsg) forKey:KeyStime];
              
                    
#warning 显示发送消息的时间
                    // 获取当前时间
                    static int k=0;
//                    NSLog(@"%d",k);
                    [UserDefaults setValue:VALUE(KeyStime, amsg) forKey:[self UserDefautsKey:k]];
                    
                    
                    self.chatuid = nil;
                    [self.dialogs removeAllObjects];
                    self.chatuid = [amsg valueForKey:KeyFromUid];
                    //                    [self readMoreDataForCurrentDialog:AllData];
                    [self readMoreDataForCurrentDialog:DefaultReadNum];
//                    NSLog(@"%@ %@",self.chatuid,self.dialogs);
                    if(!self.dialogs.count)
                    {
                        k=0;
                    }
                    
                    if(k==0){
                        [msg setValue:[NSNumber numberWithBool:YES] forKey:KeyShowtime];
                        
                        [msg setValue:[NSNumber numberWithFloat:height] forKey:KeyHeight];
                    }else
                    {
                     
//                        NSLog(@"%@------%@",[self UserDefautsKey:k],[self UserDefautsKey:k-1]);
                        BOOL isShow=[self fiveMinuteLater:[UserDefaults valueForKey:[self UserDefautsKey:k]] beforeTime:[UserDefaults valueForKey:[self UserDefautsKey:k-1]]];
                        
                        [msg setValue:[NSNumber numberWithBool:isShow] forKey:KeyShowtime];
                        
                        [UserDefaults  removeObjectForKey:[self UserDefautsKey:k-1]];
                        if(!isShow){
                            [msg setValue:[NSNumber numberWithFloat:(height-TimeLabelHeight)] forKey:KeyHeight];
                        }else
                        {
                            [msg setValue:[NSNumber numberWithFloat:height] forKey:KeyHeight];
                            
                        }
                        
                        
                        
                    }
                    k++;
                    
                    
                    
                    [msg setValue:VALUE(KeyUface, amsg) forKey:KeyUface];
                    
                    [msg setValue:[NSNumber numberWithInt:MediaStatusDownload] forKey:KeyMediaStatus];
                    
                    self.chatuid = nil;
                    [self.dialogs removeAllObjects];
                    [self insertData:msg forItem:DIALOGS forUid:uid];
                    
                }
            }
            
            [self createMusic];
            
            [self readTalkList:TALKPEOPLES];
            
            
        }
        else if([AppComManager respondsDic:resDic isFunctionData:BanBu_SendMessage_To_Server])
        {
            _isSend=YES;
            //
            //            NSLog(@"resDic::::%@",resDic);
            //            NSLog(@"chatUid::::%@",self.chatuid);
            NSInteger row = [[resDic valueForKey:@"requestid"] integerValue];
            NSInteger count = self.dialogs.count;
            
            NSLog(@"---------aaa%d %d",self.talkArr.count,self.dialogs.count);
            if(![self.chatuid isEqualToString:[resDic valueForKey:@"uid"]])
            {
                [self.talkArr removeAllObjects];
                [self.dialogs removeAllObjects];
                self.talkArr = [self readMoreDataForCurrentDialogFromUid:[resDic valueForKey:KeyUid] :AllData];
                self.dialogs = [self readMoreDataForCurrentDialogFromUid:[resDic valueForKey:KeyUid] :DefaultReadNum];
            }
            NSLog(@"---------bbb%d %d",self.talkArr.count,self.dialogs.count);
            NSMutableDictionary *amsg = [NSMutableDictionary dictionaryWithDictionary:[self.talkArr objectAtIndex:row]];
            [amsg setValue:[NSNumber numberWithInteger:ChatStatusSent] forKey:KeyStatus];
            [amsg setValue:@"0" forKey:KeyMediaStatus];
            
            if([self.chatuid isEqualToString:[resDic valueForKey:@"uid"]])
            {
                int rowtt=_talkArr.count-row;
                
                int dialogrowt=_dialogs.count-rowtt;
                
#warning 去除0  对话崩溃。**********
                //            if(dialogrowt>0){
                [_dialogs replaceObjectAtIndex:dialogrowt withObject:amsg];
                
            }
            
            [_readArr addObject:amsg];
            
            [UserDefaults setValue:_readArr forKey:@"read"];
            
            // 更新数据库
            [self updateData:amsg forItem:DIALOGS forUid:[resDic valueForKey:KeyUid]];
            
            // 在这里更新状态
            
            //其实可以amsg+profile
            
            NSMutableDictionary *dic=[[[NSMutableDictionary alloc]initWithDictionary:[UserDefaults valueForKey:@"my"]] autorelease];
            
            if(!VALUE(KeySex, dic))
            {
                if(VALUE(KeyGender, dic))
                {
                    BOOL isMan=[VALUE(KeyGender, dic)isEqual:@"m"];
                    
                    [dic setValue:[NSNumber numberWithBool:isMan] forKey:KeySex];
                    
                }
            }else{
                [dic setValue:VALUE(KeySex, dic) forKey:KeySex];
                
            }
            
            [dic setValue:@"1" forKey:KeyStatus];
            
            [self updateDialogeListWithSendMsg:dic forUid:[resDic valueForKey:KeyUid] Item:DIALOGS];
            
            
            
            // 这是发送成功的 记录下来将他们 特么的用NSUSER
            
            // 用一个字典将发送的消息 和 他的位置记录下来
            /******************************************************/
            /*
             NSMutableDictionary *readDic=[[NSMutableDictionary alloc]init];
             
             [readDic setValue:amsg forKey:@"send"];
             
             [readDic setValue:[NSNumber numberWithInt:row] forKey:@"location"];
             
             [UserDefaults setValue:readDic forKey:@"sendSuccess"];
             
             [readDic release];*/
            /***************************************************/
            
            if(_appChatController &&[self.chatuid isEqualToString:[resDic valueForKey:@"uid"]])
            {
                int rowt=_talkArr.count-row;
                
                int dialogrow=_dialogs.count-rowt;
                
                
                BanBu_ChatCell *cell = (BanBu_ChatCell *)[_appChatController.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:dialogrow inSection:0]];
                if(cell)
                {
                    
                    [cell setStatus:ChatStatusSent];
                    
                }
            }
            if(![self.chatuid isEqualToString:[resDic valueForKey:KeyUid]])
            {
                [self.talkArr removeAllObjects];
                [self.dialogs removeAllObjects];
                [self readMoreDataForCurrentDialog:AllData];
                self.dialogs=[self readMoreDataForCurrentDialogFromUid:self.chatuid :count-1];
            }
            NSLog(@"---------cccc%d %d",self.talkArr.count,self.dialogs.count);
            
        }
        
       
        else if([AppComManager respondsDic:resDic isFunctionData:BanBu_ReceiveBallList])
        {
            BOOL keyMe=NO;
            
            // 获取对话的语言包是个数组
            id list = [resDic valueForKey:@"list"];
            
            // NSMutableDictionary *userInfor=[NSMutableDictionary dictionaryWithCapacity:10];
            NSMutableArray *msgBuffer=[NSMutableArray arrayWithCapacity:1];
            // 现在
            
            // 这是所有的加入黑名单的人
            
            NSMutableArray *blackList=[[NSMutableArray alloc] initWithArray:[[[UserDefaults valueForKey:MyAppDataManager.useruid] valueForKey:@"friendlist"] valueForKey:@"flist"]];
            
            if([list isKindOfClass:[NSArray class]])
            {
                for(NSDictionary *people in list)
                {
                    
                    id MSG=[people valueForKey:@"msglist"];
                    
                    BOOL tr=NO;
                    
                    if([MSG isKindOfClass:[NSArray class]]&&tr==NO)
                    {
                        for(NSDictionary *talk in MSG)
                        {
                            BOOL m = [VALUE(KeyGender, people) isEqualToString:@"m"]?YES:NO;
                            
                            NSMutableDictionary *amsg = [NSMutableDictionary dictionaryWithCapacity:10];
                            
                            [amsg setValue:[people valueForKey:KeyFromUid] forKey:KeyFromUid];
                            
                            for(NSDictionary * dic in blackList)
                            {
                                
                                if([VALUE(@"fuid", dic) isEqual:VALUE(KeyFromUid, amsg)]&&[VALUE(@"linkkind", dic)isEqual:@"x"])
                                {
                                    
                                    tr=YES;
                                    
                                    break;
                                }
                                
                                
                            }
                            
                            NSString *jsonfrom = [[CJSONSerializer serializer] serializeArray:  VALUE(@"facelist", people)];
                            
                            [amsg setValue:jsonfrom forKey:@"facelist"];
                            
                            [amsg setValue:[NSNumber numberWithBool:m] forKey:KeySex];
                            
                            [amsg setValue:VALUE(KeyAge, people) forKey:KeyAge];
                            
                            [amsg setValue:VALUE(KeyUface, people) forKey:KeyUface];
                            
                            [amsg setValue:VALUE(KeyUname, people) forKey:KeyUname];
                            
                            [amsg setValue:VALUE(@"company", people) forKey:@"company"];
                            
                            [amsg setValue:VALUE(@"hbody", people) forKey:@"hbody"];
                            
                            [amsg setValue:VALUE(@"jobtitle", people) forKey:@"jobtitle"];
                            
                            [amsg setValue:VALUE(@"liked", people) forKey:@"liked"];
                            
                            [amsg setValue:VALUE(@"lovego", people) forKey:@"lovego"];
                            
                            [amsg setValue:VALUE(@"sayme", people) forKey:@"sayme"];
                            
                            [amsg setValue:VALUE(@"school", people) forKey:@"school"];
                            
                            [amsg setValue:VALUE(@"sstar", people) forKey:@"sstar"];
                            
                            [amsg setValue:VALUE(@"wbody", people) forKey:@"wbody"];
                            
                            [amsg setValue:VALUE(@"xblood", people) forKey:@"xblood"];
                            
                            [amsg setValue:[NSNumber numberWithBool:keyMe] forKey:@"Me"];
                            
                            // [amsg setValue:VALUE(@"ltime", people) forKey:@"ltime"];
                            NSData *data=[VALUE(@"sstar", people) dataUsingEncoding:NSUTF8StringEncoding];
                            
                            NSString *string=[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
                            
                            [amsg setValue:string forKey:@"sstar"];
                            
//                            string =[MyAppDataManager  IsInternationalLanguage:string];
                            
                            NSDictionary *says=[AppComManager getAMsgFrom64String:VALUE(KeySays, talk)];
                            
                            NSMutableDictionary *sayss=[NSMutableDictionary dictionaryWithDictionary:says];
                            
                            [amsg setValue:VALUE(KeyStime, talk) forKey:KeyStime];
                            
                            [amsg setValue:[sayss valueForKey:KeyContent]  forKey:KeyContent];
                            
                            [amsg setValue:VALUE(KeyType, sayss) forKey:KeyType];
                            
                            // 加入黑名单的
                            
                            if(tr==NO)
                            {
                                [msgBuffer addObject:amsg];
                            }
                        }
                    }
                }
                
                /***** 插入到已有的记录里，原来没有就append到后面 ******/
                
                if(![_dataBase goodConnection])
                    [_dataBase open];
                
                for(NSMutableDictionary *amsg in msgBuffer)
                {
                    NSString *uid = [amsg valueForKey:KeyFromUid];
                    
                    NSString *query = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE userid=%@",BallList,uid];
                    FMResultSet *rs = [_dataBase executeQuery:query];
                    BOOL new = YES;
                    while ([rs next]) {
                        
                        new = NO;
                        NSInteger msgID = [rs intForColumn:KeyID];
                        
                        [amsg setValue:[NSNumber numberWithInteger:msgID] forKey:KeyID];
                        
                        NSInteger unReadNum = [rs intForColumn:KeyUnreadNum];
                        unReadNum ++;
                        [amsg setValue:[NSNumber numberWithInteger:unReadNum] forKey:KeyUnreadNum];
                        
                        [self updateData:amsg forItem:BallList forUid:uid];
                        
                    }
                    if(new)
                    {
                        NSInteger ID = 0;
                        if([_dataBase tableExists:BallList])
                        {
                            NSString *query = [NSString stringWithFormat:@"SELECT ID FROM %@ WHERE ID=(SELECT MAX(ID) FROM %@)",BallList,BallList];
                            ID =[_dataBase intForQuery:query]+1;
                        }
                        
                        [amsg setValue:[NSNumber numberWithInteger:ID] forKey:KeyID];
                        [amsg setValue:[NSNumber numberWithInteger:1] forKey:KeyUnreadNum];
                        [self insertData:amsg forItem:BallList forUid:uid];
                    }
                    
                    //                    BanBu_AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
                    //                    [appDelegate updateBallBadge];
                    
                    NSInteger msgID = 0;
                    NSString *tableName = [self getTableNameForUid:uid];
                    
                    tableName=[tableName stringByAppendingString:@"ball"];
                    
                    if([_dataBase tableExists:tableName])
                    {
                        NSString *query = [NSString stringWithFormat:@"SELECT ID FROM %@ WHERE ID=(SELECT MAX(ID) FROM %@)",tableName,tableName];
                        
                        msgID =[_dataBase intForQuery:query]+1;
                        
                        
                    }
                    NSMutableDictionary *msg = [NSMutableDictionary dictionaryWithCapacity:1];
                    
                    NSArray *mapArr = [NSArray arrayWithObjects:@"text",@"image",@"location",@"sound",nil];
                    NSInteger type = [mapArr indexOfObject:VALUE(KeyType, amsg)];
                    CGFloat height = 0;
                    if(type == ChatCellTypeText)
                        height = [BanBu_SmileLabel heightForText:[MyAppDataManager IsInternationalLanguage:VALUE(KeyLasttalk, amsg)]]+2*CellMarge+TimeLabelHeight;
                    else if(type == ChatCellTypeImage)
                        height = ImageTypeHeight+2*CellMarge+TimeLabelHeight;
                    else if(type == ChatCellTypeLocation)
                        height = locationTypeHeight+2*CellMarge+TimeLabelHeight;
                    else
                        height = VoiceTypeHeight+2*CellMarge+TimeLabelHeight;
                    
                    [msg setValue:[NSNumber numberWithInteger:msgID] forKey:KeyID];
                    [msg setValue:VALUE(KeyLasttalk, amsg) forKey:KeyContent];
                    [msg setValue:[NSNumber numberWithBool:NO] forKey:KeyMe];
                    [msg setValue:[NSNumber numberWithInteger:4] forKey:KeyStatus];
                    [msg setValue:[NSNumber numberWithInteger:type] forKey:KeyType];
                    [msg setValue:[NSNumber numberWithFloat:height] forKey:KeyHeight];
                    [msg setValue:VALUE(KeyStime, amsg) forKey:KeyStime];
                    [msg setValue:[NSNumber numberWithBool:YES] forKey:KeyShowtime];
                    [msg setValue:VALUE(KeyUface, amsg) forKey:KeyUface];
                    [msg setValue:[NSNumber numberWithInt:MediaStatusDownload] forKey:KeyMediaStatus];
                    
                    
                    [self insertData:msg forItem:BallDialogs forUid:uid];
                }
            }
            
            [self readTalkList:BallList];
            
            
            
        }
        else if([AppComManager respondsDic:resDic isFunctionData:BanBu_ReceiveBallMessage])
        {
            
            
            // 这是接收的一个一个的绣球
            NSArray *msglist = [AppComManager getMessageDic:resDic];
            
            NSInteger rowNum = self.ballTalk.count;
            
            /// what is this are hahaha
            for(NSDictionary *dic in msglist)
            {
                
                NSArray *mapArr = [NSArray arrayWithObjects:@"text",@"image",@"location",@"sound",nil];
                ChatCellType type = [mapArr indexOfObject:VALUE(KeyType, dic)];
                NSString *says = VALUE(KeyContent, dic);
                
                NSString *stime = VALUE(KeyStime, dic);
                NSInteger row = self.dialogs.count;
                NSMutableDictionary *amsg = [NSMutableDictionary dictionaryWithCapacity:2];
                [amsg setValue:[NSNumber numberWithInt:self.dialogs.count] forKey:KeyID];
                [amsg setValue:[NSNumber numberWithInt:type] forKey:KeyType];
                [amsg setValue:says forKey:KeyContent];
                [amsg setValue:[NSNumber numberWithBool:NO] forKey:KeyMe];
                [amsg setValue:VALUE(KeyUface, _appChatController.profile) forKey:KeyUface];
                [amsg setValue:[NSNumber numberWithInt:ChatStatusNone] forKey:KeyStatus];
                NSString *lastTimeStr = nil;
                if(row)
                    lastTimeStr = [[MyAppDataManager.dialogs objectAtIndex:row-1] valueForKey:KeyStime];
                [amsg setValue:stime forKey:KeyStime];
                BOOL showTime = [_appViewController fiveMinuteLater:stime beforeTime:lastTimeStr];
                [amsg setValue:[NSNumber numberWithBool:showTime] forKey:KeyShowtime];
                
                float height = 0;
                
                if(type == ChatCellTypeImage)
                {
                    [amsg setValue:[NSNumber numberWithInteger:MediaStatusDownload] forKey:KeyMediaStatus];
                    height = ImageTypeHeight;
                }
                else if(type == ChatCellTypeLocation)
                    height = locationTypeHeight;
                else if(type == ChatCellTypeVoice)
                {
                    [amsg setValue:[NSNumber numberWithInteger:MediaStatusDownload] forKey:KeyMediaStatus];
                    height = VoiceTypeHeight;
                }
                else
                    height = [BanBu_SmileLabel heightForText:says];
                height += 2*CellMarge+(showTime?TimeLabelHeight:0);
                [amsg setValue:[NSNumber numberWithFloat:height] forKey:KeyHeight];
                
                if((type == ChatCellTypeImage) || (type == ChatCellTypeVoice))
                {
                    [AppComManager getBanBuMedia:[amsg valueForKey:KeyContent] forMsgID:MyAppDataManager.ballTalk.count fromUid:[resDic valueForKey:KeyUid] delegate:self];
                }
                [self.ballTalk addObject:amsg];
                
                // 这里加一个回调判断是否已经读了发送的信息
                
                [self insertData:amsg forItem:BallDialogs forUid:[resDic valueForKey:KeyFromUidTalk]];
                
            }
            
            if(_appViewController)
            {
                // 这是每次取到更新列表的东西
                
                [_appViewController.tableView beginUpdates];
                NSMutableArray *indexPaths = [NSMutableArray array];
                for(int i=rowNum; i<self.ballTalk.count; i++)
                    [indexPaths addObject:[NSIndexPath indexPathForRow:i inSection:0]];
                [_appViewController.tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationNone];
                [_appViewController.tableView endUpdates];
                
                [_appViewController tableViewAutoOffset];
            }
            
        }
        else if([AppComManager respondsDic:resDic isFunctionData:BanBu_SendBall_To_User])
        {
            NSInteger row = [[resDic valueForKey:@"requestid"] integerValue];
            
            NSMutableDictionary *amsg = [NSMutableDictionary dictionaryWithDictionary:[self.ballTalk objectAtIndex:row]];
            [amsg setValue:[NSNumber numberWithInteger:ChatStatusSent] forKey:KeyStatus];
            [self.ballTalk replaceObjectAtIndex:row withObject:amsg];
            
            
            
            // 更新数据库
            [self updateData:amsg forItem:BallDialogs forUid:[resDic valueForKey:KeyUid]];
            
            if(_appViewController)
            {
                BanBu_ChatCell *cell = (BanBu_ChatCell *)[_appViewController.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:0]];
                if(cell)
                {
                    
                    [cell setStatus:ChatStatusSent];
                    
                    
                }
            }
            
            
        }
        else if ([AppComManager respondsDic:resDic isFunctionData:BanBu_AllOperation_Server])
        {
#warning 新消息的打印
//            NSLog(@"++___++_++__++%@",resDic);
            NSLog(@"++___++_++__++");

            if([[resDic valueForKey:@"resultlist"]isKindOfClass:[NSArray class]]){
            
                NSArray *resultList=[NSArray arrayWithArray:[resDic valueForKey:@"resultlist"]];
             
               for(NSDictionary *temp in resultList)
               {
                
                   if([[temp valueForKey:@"fc"]isEqual:[AppComManager getPar:BanBu_ReceiveMessage_From_All ]])
                   {
                       
                       
                       if(![[temp valueForKey:@"result"]isEqual:@"0"]){
                         
                           [AppComManager receiveMsgFromAll:nil delegate:self];
         
                       }
       
#warning  不更新啦！！！！
/*
                       //获取到
                       if([[temp valueForKey:@"statuslist"] count ]>0)
                       {
                           // 这是状态列表
                           NSArray *Listarr=[temp valueForKey:@"statuslist"];
                           NSMutableArray *statusArr = [NSMutableArray arrayWithArray:_talkPeoples];
                           // 这是取出 touid
                           for(int i=0;i<statusArr.count;i++)
                           {
                               NSMutableDictionary *tt = [statusArr objectAtIndex:i];
                               NSLog(@"%@",tt);
                               if([[tt valueForKey:@"status"]isEqualToString:@"1"]){
                                   for(NSMutableDictionary *status in Listarr)
                                   {
                                       
                                       if([[tt valueForKey:@"userid"] isEqual:[status valueForKey:@"touid"]])
                                       {
                                           
                                           if([[status valueForKey:@"status"]isEqual:@"r"])
                                           {
                                               [tt setValue:@"3"forKey:@"status"];
                                               [self updateDialogeListWithSendMsg:tt forUid:[tt valueForKey:@"userid"] Item:DIALOGS];
                                               
                                           }
                                       }
                                       
                                   }
                               }
                               
                               
                           }
      
     
                       }

       */
                   }
                   if ([[temp valueForKey:@"fc"]isEqual:[AppComManager getPar:BanBu_Get_Friend_FriendDos]])
                   {//
                   
                       [MyAppDelegate updateDialoge:[temp valueForKey:@"result"]];
                       
                   }

                
                       
                       
               }
                
        
            }
 
        }
    }
    
    
}

// 更新对话的列表
- (void)updateDialogeListWithSendMsg:(NSMutableDictionary *)aMsg forUid:(NSString *)uid Item:(NSString *)item
{
    if([item isEqual:DIALOGS])
    {
    if(![_dataBase goodConnection])
        [_dataBase open];
    NSString *query = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE userid=%@",TALKPEOPLES,uid];
    FMResultSet *rs = [_dataBase executeQuery:query];
    BOOL new = YES;
    while ([rs next]) {
        
        new = NO;
        
        NSInteger msgID = [rs intForColumn:KeyID];
        [aMsg setValue:[NSNumber numberWithInteger:msgID] forKey:KeyID];
        [aMsg setValue:[NSNumber numberWithInteger:0] forKey:KeyUnreadNum];
    
        [self updateData:aMsg forItem:TALKPEOPLES forUid:uid];
        
    }
    if(new)
    {
        NSInteger ID = 0;
        if([_dataBase tableExists:TALKPEOPLES])
        {
            NSString *query = [NSString stringWithFormat:@"SELECT ID FROM %@ WHERE ID=(SELECT MAX(ID) FROM %@)",TALKPEOPLES,TALKPEOPLES];
            ID =[_dataBase intForQuery:query]+1;
        }
        
        [aMsg setValue:[NSNumber numberWithInteger:ID] forKey:KeyID];
      
        [aMsg setValue:[NSNumber numberWithInteger:0] forKey:KeyUnreadNum];
        [self insertData:aMsg forItem:TALKPEOPLES forUid:uid];
    }
    
    BanBu_AppDelegate *appDelegate = (BanBu_AppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDelegate updateBadge];

    }else
    {

    if(![_dataBase goodConnection])
        [_dataBase open];
    NSString *query = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE userid=%@",BallList,uid];
    FMResultSet *rs = [_dataBase executeQuery:query];
    BOOL new = YES;
    while ([rs next]) {
        
        new = NO;
        
        NSInteger msgID = [rs intForColumn:KeyID];
        [aMsg setValue:[NSNumber numberWithInteger:msgID] forKey:KeyID];
        [aMsg setValue:[NSNumber numberWithInteger:0] forKey:KeyUnreadNum];
        [self updateData:aMsg forItem:BallList forUid:uid];
        
    }
    if(new)
    {
        NSInteger ID = 0;
        if([_dataBase tableExists:BallList])
        {
            NSString *query = [NSString stringWithFormat:@"SELECT ID FROM %@ WHERE ID=(SELECT MAX(ID) FROM %@)",BallList,BallList];
            ID =[_dataBase intForQuery:query]+1;
        }
        
        [aMsg setValue:[NSNumber numberWithInteger:ID] forKey:KeyID];
        
        [aMsg setValue:[NSNumber numberWithInteger:0] forKey:KeyUnreadNum];
        [self insertData:aMsg forItem:BallList forUid:uid];
    }
    
}

}

// 从数据库根据USERID中取一条信息

-(NSMutableDictionary *)ReadTalkListFromuserid:(NSString *)userid
{
    NSDictionary *dictionary=[[[NSDictionary alloc]init]autorelease];
    
    if(![_dataBase goodConnection])
        [_dataBase open];
    NSString *query = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE userid=%@",TALKPEOPLES,userid];
    FMResultSet *rs = [_dataBase executeQuery:query];
    
    while ([rs next]) {
        
       dictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                              [NSNumber numberWithInteger:[rs intForColumn:KeyID]],    KeyID,
                              [rs stringForColumn:KeyFromUid],                         KeyFromUid,
                              [rs stringForColumn:KeyUface],                           KeyUface,
                              [rs stringForColumn:KeyUname],                           KeyUname,
                              [rs stringForColumn:KeyAge],                             KeyAge,
                              [NSNumber numberWithBool:[rs boolForColumn:KeySex]],     KeySex,
                              [rs stringForColumn:KeyLasttalk],                        KeyContent,
                              [rs stringForColumn:KeyStime],                           KeyStime,
                              [rs stringForColumn:KeyType],                            KeyType,
                              [rs stringForColumn:KeySayme],                           KeySayme,
                              [rs stringForColumn:KeySchool],                          KeySchool,
                              [rs stringForColumn:KeyLiked],                           KeyLiked,
                              [rs stringForColumn:KeySayme],                           KeySayme,
                              [rs stringForColumn:KeyJobtitle],                       KeyJobtitle,
                              [rs stringForColumn:KeyHbody],                          KeyHbody,
                              [rs stringForColumn:KeySstar],                          KeySstar,
                              [rs stringForColumn:KeyWbody],                          KeyWbody,
                              [rs stringForColumn:KeyXblood],                         KeyXblood,
                              [rs stringForColumn:KeyDtime],KeyDtime,
                              
                              [rs stringForColumn:KeyDmeter],KeyDmeter,
                              
                              [NSNumber numberWithInteger:[rs intForColumn:KeyUnreadNum]],KeyUnreadNum,
                              
                              [rs stringForColumn:KeyFacelist],                       KeyFacelist,
                              
                              [rs stringForColumn:KeyMe],                             KeyMe,
                              [rs stringForColumn:KeyStatus],                         KeyStatus,
                              nil];
        
        
        NSData *temp=[[dictionary valueForKey:@"facelist"] dataUsingEncoding:NSUTF8StringEncoding];
        
        NSArray *arr=[[NSArray alloc]initWithArray:[[CJSONDeserializer deserializer] deserializeAsArray:temp error:nil]];
        
        NSMutableDictionary *dic=[NSMutableDictionary dictionaryWithDictionary:dictionary];
        
        [dictionary release];
        
        [dic setValue:arr forKey:@"facelist"];
        
        [arr release];
        
        return dic;
    }
    
    return nil;
}

-(BOOL)upDateTalkListFrom:(NSString *)usrid
{




    return true;
}











//{a j,b k,c l,}   like this
-(NSString *)getPar1StrFromDic:(NSDictionary *)parDic
{
    NSMutableString *str = [NSMutableString stringWithCapacity:1];
    for(NSString *key in parDic)
        [str appendFormat:@"%@ %@,",key,[parDic valueForKey:key]];
    [str deleteCharactersInRange:NSMakeRange(str.length-1, 1)];
    return str;
}

/*********聊天数据处理**********/


// 发送聊天的信息 这一步是关键啊
- (void)sendTextMsg:(NSString *)msg forType:(ChatCellType)type toUid:(NSString *)uid From:(NSString *)from
{
    NSArray *mapArr = [NSArray arrayWithObjects:@"text",@"image",@"location",@"sound",@"emi",nil];
    NSMutableDictionary *sendDic = [NSMutableDictionary dictionary];
    [sendDic setValue:uid forKey:@"touid"];
    [sendDic setValue:[NSString stringWithFormat:@"%i",self.talkArr.count-1] forKey:@"msgid"];
    [sendDic setValue:[NSDictionary dictionaryWithObjectsAndKeys:msg,KeyContent,[mapArr objectAtIndex:type],KeyType,from,KeyShowFrom,nil] forKey:@"says"];
    
    // 这是发送的嘛啊？
    
    NSLog(@"%@",sendDic);
    
    [AppComManager getBanBuData:BanBu_SendMessage_To_Server par:sendDic delegate:self];
}

- (void)sendTextMsg:(NSString *)msg forType:(ChatCellType)type toUid:(NSString *)uid Number:(int)n From:(NSString *)from
{
    NSArray *mapArr = [NSArray arrayWithObjects:@"text",@"image",@"location",@"sound",@"emi",nil];
    NSMutableDictionary *sendDic = [NSMutableDictionary dictionary];
    [sendDic setValue:uid forKey:@"touid"];
    [sendDic setValue:[NSString stringWithFormat:@"%d",n] forKey:@"msgid"];
    [sendDic setValue:[NSDictionary dictionaryWithObjectsAndKeys:msg,KeyContent,[mapArr objectAtIndex:type],KeyType,from,KeyShowFrom,nil] forKey:@"says"];
 
//    NSLog(@"%@",sendDic);
    [AppComManager getBanBuData:BanBu_SendMessage_To_Server par:sendDic delegate:self];
}

// 发送抛绣球的

-(void)sendTextBall:(NSString *)msg forType:(ChatCellType)type toUid:(NSString *)uid
{
    NSArray *mapArr = [NSArray arrayWithObjects:@"text",@"image",@"location",@"sound",@"emi",nil];
    NSMutableDictionary *sendDic = [NSMutableDictionary dictionary];
    [sendDic setValue:uid forKey:@"touid"];
    [sendDic setValue:[NSString stringWithFormat:@"%i",self.ballTalk.count-1] forKey:@"msgid"];
    [sendDic setValue:[NSDictionary dictionaryWithObjectsAndKeys:msg,KeyContent,[mapArr objectAtIndex:type],KeyType,nil] forKey:@"says"];
    
    [AppComManager getBanBuData:BanBu_SendBall_To_User par:sendDic delegate:self];

}
- (void)banbuRequestNamed:(NSString *)requestname uploadDataProgress:(float)progress
{
    if(self.appChatController)
    {
        NSInteger row = [[[requestname componentsSeparatedByString:@"-"] objectAtIndex:0] integerValue];
        
       
        int rowt=MyAppDataManager.talkArr.count-row;
        
        int dilogsRow=MyAppDataManager.dialogs.count-rowt;
        
        NSLog(@"- =- =- =- =- = -= -= -= - %d",dilogsRow);
    
        BanBu_ChatCell *cell = (BanBu_ChatCell *)[_appChatController.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:dilogsRow inSection:0]];
        if(cell)
        {
            // 判断是不是照片或者录音
            if(![[requestname pathExtension] isEqual:@"amr"]){
            
                [cell.mediaView setMedia:requestname];
                
                cell.mediaView.progressBar.progress = progress;
            
            }else
            {
            
                NSLog(@"ha ha ha  this is ))))((())_(_()_)_)");
            
            }
                
        }
    }
}

- (void)banbuUploadRequest:(NSDictionary *)resDic didFinishedWithError:(NSError *)error
{
    if(error)
    {
        if(_appChatController)
        {
//            [TKLoadingView showTkloadingAddedTo:_appChatController.navigationController.view title:@"上传失败" activityAnimated:NO duration:2.0];
        
        }
        
    
        NSInteger row = [[[[resDic valueForKey:@"requestname"] componentsSeparatedByString:@"-"] objectAtIndex:0] integerValue];

        int rowt=_talkArr.count-row;
        
        int dialogrowt=_dialogs.count-rowt;
        
        
        
        NSMutableDictionary *amsg = [NSMutableDictionary dictionaryWithDictionary:[self.talkArr objectAtIndex:row]];
        [amsg setValue:[NSNumber numberWithInteger:ChatStatusSendFail] forKey:KeyStatus];
        [amsg setValue:[NSNumber numberWithInteger:MediaStatusUploadFaild] forKey:KeyMediaStatus];
        
        [self.talkArr replaceObjectAtIndex:row withObject:amsg];
        
        [self.dialogs replaceObjectAtIndex:dialogrowt withObject:amsg];
        
        [self updateData:amsg forItem:DIALOGS forUid:[resDic valueForKey:KeyUid]];
        
        // 更新
        
        NSMutableDictionary *dic=[[[NSMutableDictionary alloc]initWithDictionary:[UserDefaults valueForKey:@"my"]] autorelease];
        [dic setValue:@"0" forKey:KeyStatus];
        
        [self updateDialogeListWithSendMsg:dic forUid:[resDic valueForKey:KeyUid] Item:DIALOGS];


        if(_appChatController)
        {
            BanBu_ChatCell *cell = (BanBu_ChatCell *)[_appChatController.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:dialogrowt inSection:0]];
            if(cell)
            {
               
                if(![[[resDic valueForKey:@"requestname"]pathExtension]isEqual:@"amr"]){
                [cell setStatus:ChatStatusSendFail];
                [cell.mediaView setStatus:MediaStatusDownloadFaild];
                [cell.mediaView setMedia:[resDic valueForKey:@"requestname"]];
                    
                }else
                {
                    [cell setStatus:ChatStatusSendFail];
                    
                    [cell.voiceView setStatus:MediaStatusDownloadFaild];
                    
                   
                
                }
            }
        }
        return;
    }
    NSInteger count = self.dialogs.count;

    if([[resDic valueForKey:@"ok"] boolValue])
    {
        //获取上传pic的uid
        if(![self.chatuid isEqualToString:[resDic valueForKey:KeyUid]])
        {
            [self.talkArr removeAllObjects];
            [self.dialogs removeAllObjects];
            self.talkArr = [self readMoreDataForCurrentDialogFromUid:[resDic valueForKey:KeyUid] :AllData];
            self.dialogs = [self readMoreDataForCurrentDialogFromUid:[resDic valueForKey:KeyUid] :DefaultReadNum];
        }
        
        NSInteger row = [[[[resDic valueForKey:@"requestname"] componentsSeparatedByString:@"-"] objectAtIndex:0] integerValue];
        
        NSMutableDictionary *amsg = [NSMutableDictionary dictionaryWithDictionary:[self.talkArr objectAtIndex:row]];
        [amsg setValue:[resDic valueForKey:@"fileurl"] forKey:KeyContent];
        [amsg setValue:[NSNumber numberWithInteger:MediaStatusNormal] forKey:KeyMediaStatus];
       
        int dilogsRow;
        if([self.chatuid isEqualToString:[resDic valueForKey:@"uid"]]){
        
            int rowt=MyAppDataManager.talkArr.count-row;
            
           dilogsRow=MyAppDataManager.dialogs.count-rowt;
            
            //????????? [self.dialogs replaceObjectAtIndex:row withObject:amsg];
            
            [_talkArr replaceObjectAtIndex:row withObject:amsg];
            
            [self.dialogs replaceObjectAtIndex:dilogsRow withObject:amsg];
            

        }
        
        
        
        [self updateData:amsg forItem:DIALOGS forUid:[resDic valueForKey:KeyUid]];
        ChatCellType type = [[amsg valueForKey:KeyType] integerValue];
        
         // 打印的 别烦我
    

       [self sendTextMsg:VALUE(KeyFileUrl, resDic) forType:type toUid:[resDic valueForKey:KeyUid] Number:row From:[resDic valueForKey:KeyShowFrom]];
       
        
        if(_appChatController &&[self.chatuid isEqualToString:[resDic valueForKey:@"uid"]])
        {
            //???????????
            BanBu_ChatCell *cell = (BanBu_ChatCell *)[_appChatController.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:dilogsRow inSection:0]];
            if(cell)
        
            {
                if(type==1)
               {
                [cell.mediaView setStatus:MediaStatusNormal];
                [cell.mediaView setMedia:VALUE(KeyFileUrl, resDic)];
               }else
               {
                    // 到此结束 voiceView
                   
                   [cell.voiceView setStatus:MediaStatusNormal];
                   
                   [cell.voiceView setMedia:VALUE(KeyFileUrl, resDic)];
                   
                   [cell setVoiceViewLong:[[resDic valueForKey:@"time"] floatValue]];
                   
               }
        }
    }
        if(![self.chatuid isEqualToString:[resDic valueForKey:KeyUid]])
        {
            [self.talkArr removeAllObjects];
            [self.dialogs removeAllObjects];
            [self readMoreDataForCurrentDialog:AllData];
            self.dialogs=[self readMoreDataForCurrentDialogFromUid:self.chatuid :count-1];
        }

    }

 
    
}

- (void)banbuDownloadRequest:(NSDictionary *)resDic didFinishedWithError:(NSError *)error
{

    NSString *fromUid = [resDic valueForKey:KeyUid];
    if(error)
    {
        if(_appChatController)
        {
//        [TKLoadingView showTkloadingAddedTo:_appChatController.navigationController.view title:@"下载失败" activityAnimated:NO duration:2.0];
        }
       NSInteger row = [[[[resDic valueForKey:@"requestname"] componentsSeparatedByString:@"-"] objectAtIndex:0] integerValue];
        NSMutableDictionary *amsg = [NSMutableDictionary dictionaryWithDictionary:[self.talkArr objectAtIndex:row]];
        [amsg setValue:[NSNumber numberWithInteger:ChatStatusNone] forKey:KeyStatus];
        [amsg setValue:[NSNumber numberWithInteger:MediaStatusDownloadFaild] forKey:KeyMediaStatus];
        
        int rowtt=MyAppDataManager.talkArr.count-row;
    
        int dilogsRowt=MyAppDataManager.dialogs.count-rowtt;
        
        //????????? [self.dialogs replaceObjectAtIndex:row withObject:amsg];
        
        //!!!!!!!!![self.talkArr replaceObjectAtIndex:row withObject:amsg];
        [self.dialogs replaceObjectAtIndex:dilogsRowt withObject:amsg];
        
        //[self.dialogs replaceObjectAtIndex:row withObject:amsg];
        [self updateData:amsg forItem:DIALOGS forUid:fromUid];
        int type=[[amsg valueForKey:@"type"] integerValue];
        if(_appChatController)
        {
            BanBu_ChatCell *cell = (BanBu_ChatCell *)[_appChatController.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:dilogsRowt inSection:0]];
            
            
            if(cell)
            {
                
                //[cell.mediaView setStatus:MediaStatusDownloadFaild];
                
                if(type==1)
                {
                 [cell.mediaView setStatus:MediaStatusDownloadFaild];
                   
                }else
                {
                    // 到此结束 voiceView
                    
                    [cell.voiceView setStatus:MediaStatusDownloadFaild];
                    
                    [cell setVoiceViewLong:[[resDic valueForKey:@"time"] floatValue]];
                    
                }

               [ _appChatController.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:dilogsRowt inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
                
            }
            
        }
        
        return;
    }
    NSInteger count = self.dialogs.count;

    if([[resDic valueForKey:@"ok"] boolValue])
    {
        
        if(![self.chatuid isEqualToString:[resDic valueForKey:KeyUid]])
        {
            [self.talkArr removeAllObjects];
            [self.dialogs removeAllObjects];
            self.talkArr = [self readMoreDataForCurrentDialogFromUid:[resDic valueForKey:KeyUid] :AllData];
            self.dialogs = [self readMoreDataForCurrentDialogFromUid:[resDic valueForKey:KeyUid] :DefaultReadNum];
        }
        
        NSInteger row = [[[[resDic valueForKey:@"requestname"] componentsSeparatedByString:@"-"] objectAtIndex:0] integerValue];
        
        NSLog(@"- - - -= -= -= -= -= -= -= -= -%d++++++++%d",row,MyAppDataManager.talkArr.count);
        
        
        NSMutableDictionary *amsg = [NSMutableDictionary dictionaryWithDictionary:[MyAppDataManager.talkArr objectAtIndex:row]];
        [amsg setValue:[NSNumber numberWithInteger:MediaStatusNormal] forKey:KeyMediaStatus];
        
        int dilogsRow;
        if([self.chatuid isEqualToString:[resDic valueForKey:@"uid"]]){
            int rowt=MyAppDataManager.talkArr.count-row;
            
           dilogsRow=MyAppDataManager.dialogs.count-rowt;
            
            
            //????????? [self.dialogs replaceObjectAtIndex:row withObject:amsg];
            
            //!!!!!!!!![self.talkArr replaceObjectAtIndex:row withObject:amsg];
            [self.dialogs replaceObjectAtIndex:dilogsRow withObject:amsg];

        }
             
        [self updateData:amsg forItem:DIALOGS forUid:fromUid];
        
        int type=[[amsg valueForKey:@"type"] integerValue];
        
        // 判断是不是对讲机模式  且收到的是语音
        if(_Messagetype==MessageTypeRadio&&[[amsg valueForKey:@"type"] integerValue]==3)
        {
            
            if(_appChatController &&[self.chatuid isEqualToString:[resDic valueForKey:@"uid"]])
            {
                BanBu_ChatCell *cell = (BanBu_ChatCell *)[_appChatController.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:0]];
                if(cell)
                {
                    // 将对讲机的url 和 row 放入字典当中
                    [_valueArr addObject:cell.mediaView.mediaPath];
                    
                    [_keyArr addObject:[NSString stringWithFormat:@"%d",row]];
                    
                    [cell.mediaView setStatus:MediaStatusNormal];
                    
                    [cell.mediaView radioAutoBroad:MediaBroadRadio];
                    
                    [_messageRadioDictionary setValue:_valueArr forKey:@"value"];
                    
                    [_messageRadioDictionary setValue:_keyArr forKey:@"key"];
                    
                    
                }
                [_appChatController.tableView reloadData];
            }
            
            
        }else
        {
            if(_appChatController &&[self.chatuid isEqualToString:[resDic valueForKey:@"uid"]])
            {
                BanBu_ChatCell *cell = (BanBu_ChatCell *)[_appChatController.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:dilogsRow inSection:0]];
                if(cell)
                {
                    if(type==1)
                    {
                        [cell.mediaView setStatus:MediaStatusNormal];
                        [cell.mediaView setMedia:VALUE(KeyFileUrl, resDic)];
                    }else
                    {
                        // 到此结束 voiceView
                        
                        [cell.voiceView setStatus:MediaStatusNormal];
                        
                        [cell.voiceView setMedia:VALUE(KeyFileUrl, resDic)];
                        
                        [cell setVoiceViewLong:[[resDic valueForKey:@"time"] floatValue]];
                        
                    }

                }
               
                
                [_appChatController.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:dilogsRow inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
            
            }
            
            
        }
        
        if(![self.chatuid isEqualToString:[resDic valueForKey:KeyUid]])
        {
            [self.talkArr removeAllObjects];
            [self.dialogs removeAllObjects];
            [self readMoreDataForCurrentDialog:AllData];
            self.dialogs=[self readMoreDataForCurrentDialogFromUid:self.chatuid :count-1];
        }
    }
}

- (void)banbuRequestNamed:(NSString *)requestname downloadDataProgress:(float)progress
{
    if(_appChatController)
    {
        NSInteger row = [[[requestname componentsSeparatedByString:@"-"] objectAtIndex:0] integerValue];
        int rowt=MyAppDataManager.talkArr.count-row;
        
        int dilogsRow=MyAppDataManager.dialogs.count-rowt;
        
        BanBu_ChatCell *cell = (BanBu_ChatCell *)[_appChatController.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:dilogsRow inSection:0]];
        if(cell){
        
            if(![[requestname pathExtension] isEqual:@"amr"]){
                
                cell.mediaView.progressBar.progress = progress;
                
            }else
            {
                // 这里是下载过程中的进度条
                
                NSLog(@"ha ha ha  this is ))))((())_(_()_)_)");
                
            }

        
        
        }
    
    }

}
+(id)allocWithZone:(NSZone *)zone{
    @synchronized(self){
        if (sharedAppDataManager == nil) {
            sharedAppDataManager = [super allocWithZone:zone];
            return  sharedAppDataManager;
        }
    }
    return nil;
}


- (BOOL)fiveMinuteLater:(NSString *)stime beforeTime:(NSString *)ltime
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
    
    return [currentDate timeIntervalSince1970]>[lastDate timeIntervalSince1970]+180;
}

-(NSString *)currentTime:(NSString *)receiveTime
{
    
    int hostTime=[[UserDefaults valueForKey:@"hostTime"] intValue];
    
    NSTimeInterval secondsPerDay = hostTime* 60;
    
    // 获取一个时间
    NSDateFormatter *formatter = [[[NSDateFormatter alloc] init] autorelease];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *currentDate = [formatter dateFromString:receiveTime];
    // 加上我们的当前时间
    NSString *stime = [formatter stringFromDate:[NSDate dateWithTimeInterval:secondsPerDay sinceDate:currentDate]];

    //    NSLog(@"%@",stime);
    return stime;
    
}
-(NSString*)currentTimeBeforeAweek
{
    NSDateFormatter * dateFormatter = [[[NSDateFormatter alloc] init]autorelease];
    NSDate *nowDate = [NSDate date];
    NSTimeInterval  interval = 24*60*60*7; //1:天数
    NSDate *date1 = [nowDate initWithTimeIntervalSinceNow:-interval];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    return  ([NSString stringWithFormat:@"%@",[dateFormatter stringFromDate:date1]]);
    
}



// 读取申请人表

-(void)readAgree:(NSString *)userid
{
            if(![_dataBase goodConnection])
                [_dataBase open];
            if(![_dataBase tableExists:AgreeList])
            {
                NSDictionary *queryDic = [NSDictionary dictionaryWithObjectsAndKeys:
                                          DBFieldType_INTEGER, KeyID,
                                          DBFieldType_TEXT,    KeyFromUid,
                                          DBFieldType_TEXT,    KeyUface,
                                          DBFieldType_TEXT,    KeyUname,
                                          DBFieldType_TEXT,    KeyAge,
                                          DBFieldType_BOOL,    KeySex,
                                          DBFieldType_TEXT,    KeyContent,
                                          DBFieldType_TEXT,    KeyStime,
                                          DBFieldType_INTEGER, KeyUnreadNum,
                                          DBFieldType_TEXT,    KeyType,
                                          DBFieldType_TEXT,    KeyCompany,
                                          DBFieldType_TEXT,    KeyHbody,
                                          DBFieldType_TEXT,    KeyJobtitle,
                                          DBFieldType_TEXT,    KeyLiked,
                                          
                                          DBFieldType_TEXT,    KeyLovego,
                                          DBFieldType_TEXT,    KeySayme,
                                          DBFieldType_TEXT,    KeySchool,
                                          DBFieldType_TEXT,    KeySstar,
                                          DBFieldType_TEXT,    KeyWbody,
                                          DBFieldType_TEXT,    KeyXblood,
                                          DBFieldType_TEXT,    KeyDtime,
                                          DBFieldType_TEXT,    KeyDmeter,
                                          DBFieldType_TEXT,    KeyFacelist,
                                          DBFieldType_BOOL,     KeyMe,
                                          DBFieldType_TEXT,    KeyStatus,
                                          nil];
                
                NSString *query = [NSString stringWithFormat:@"CREATE TABLE %@ (%@)",AgreeList,[self getPar1StrFromDic:queryDic]];
                
                [_dataBase executeUpdate:query];
                
                return;
            }
            else
            {
                NSString *query = [NSString stringWithFormat:@"SELECT * FROM %@",AgreeList];
                FMResultSet *rs = [_dataBase executeQuery:query];
                [_agreeList removeAllObjects];
                while ([rs next]) {
                    NSDictionary *amsg = [NSDictionary dictionaryWithObjectsAndKeys:
                                          [NSNumber numberWithInteger:[rs intForColumn:KeyID]],    KeyID,
                                          [rs stringForColumn:KeyFromUid],                         KeyFromUid,
                                          [rs stringForColumn:KeyUface],                           KeyUface,
                                          [rs stringForColumn:KeyUname],                           KeyUname,
                                          [rs stringForColumn:KeyAge],                             KeyAge,
                                          [NSNumber numberWithBool:[rs boolForColumn:KeySex]],     KeySex,
                                          [rs stringForColumn:KeyLasttalk],                        KeyContent,
                                          [rs stringForColumn:KeyStime],                           KeyStime,
                                          [rs stringForColumn:KeyType],                            KeyType,
                                          [rs stringForColumn:KeySayme],                           KeySayme,
                                          [rs stringForColumn:KeySchool],                          KeySchool,
                                          [rs stringForColumn:KeyLiked],                           KeyLiked,
                                          [rs stringForColumn:KeySayme],                           KeySayme,
                                          [rs stringForColumn:KeyJobtitle],                       KeyJobtitle,
                                          [rs stringForColumn:KeyHbody],                          KeyHbody,
                                          [rs stringForColumn:KeySstar],                          KeySstar,
                                          [rs stringForColumn:KeyWbody],                          KeyWbody,
                                          [rs stringForColumn:KeyXblood],                         KeyXblood,
                                          [rs stringForColumn:KeyDtime],KeyDtime,
                                          
                                          [rs stringForColumn:KeyDmeter],KeyDmeter,
                                          
                                          [NSNumber numberWithInteger:[rs intForColumn:KeyUnreadNum]],KeyUnreadNum,
                                          
                                          [rs stringForColumn:KeyFacelist],                       KeyFacelist,
                                          
                                          [rs stringForColumn:KeyMe],                             KeyMe,
                                          [rs stringForColumn:KeyStatus],                         KeyStatus,
                                          nil];
                    
                    NSData *temp=[[amsg valueForKey:@"facelist"] dataUsingEncoding:NSUTF8StringEncoding];
                    
                    NSArray *arr=[[NSArray alloc]initWithArray:[[CJSONDeserializer deserializer] deserializeAsArray:temp error:nil]];
                    
                    NSMutableDictionary *dic=[NSMutableDictionary dictionaryWithDictionary:amsg];
                    
                    [dic setValue:arr forKey:@"facelist"];
                    
                    [arr release];
                    
                    [_agreeList addObject:dic];
                    
                }
            }

}

// 如果有新的人 则加入到数据库当中
- (void)insertAgreeData:(id)data forItem:(NSString *)itemName forUid:(NSString *)uid{
    if(![_dataBase goodConnection])
        [_dataBase open];
    if(![_dataBase tableExists:AgreeList])
    {
        NSDictionary *queryDic = [NSDictionary dictionaryWithObjectsAndKeys:
                                  DBFieldType_INTEGER, KeyID,
                                  DBFieldType_TEXT,    KeyFromUid,
                                  DBFieldType_TEXT,    KeyUface,
                                  DBFieldType_TEXT,    KeyUname,
                                  DBFieldType_TEXT,    KeyAge,
                                  DBFieldType_BOOL,    KeySex,
                                  DBFieldType_TEXT,    KeyContent,
                                  DBFieldType_TEXT,    KeyStime,
                                  DBFieldType_INTEGER, KeyUnreadNum,
                                  DBFieldType_TEXT,    KeyType,
                                  
                                  DBFieldType_TEXT,    KeyCompany,
                                  DBFieldType_TEXT,    KeyHbody,
                                  DBFieldType_TEXT,    KeyJobtitle,
                                  DBFieldType_TEXT,    KeyLiked,
                                  
                                  DBFieldType_TEXT,    KeyLovego,
                                  DBFieldType_TEXT,    KeySayme,
                                  DBFieldType_TEXT,    KeySchool,
                                  DBFieldType_TEXT,    KeySstar,
                                  DBFieldType_TEXT,    KeyWbody,
                                  DBFieldType_TEXT,    KeyXblood,
                                  DBFieldType_TEXT,    KeyDtime,
                                  DBFieldType_TEXT,    KeyDmeter,
                                  DBFieldType_TEXT,    KeyFacelist,
                                  DBFieldType_BOOL,    KeyMe,
                                  DBFieldType_TEXT,    KeyStatus,
                                  nil];
        
        
        
        NSString *query = [NSString stringWithFormat:@"CREATE TABLE %@ (%@)",AgreeList,[self getPar1StrFromDic:queryDic]];
        
        BOOL f = [_dataBase executeUpdate:query];
        if(!f)
        {
            NSLog(@"创建失败!");
        }
        
        
    }
    
    NSString *query = [NSString stringWithFormat:@"INSERT INTO %@ (ID,userid,uface,pname,oldyears,sex,content,stime,unreadnum,type,company,hbody,jobtitle,liked,lovego,sayme,school,sstar,wbody,xblood,ltime,dmeter,facelist,me,status) VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)",AgreeList];
    NSArray *dataArr = nil;
    if([data isKindOfClass:[NSDictionary class]])
        dataArr = [NSArray arrayWithObject:data];
    else
        dataArr = [NSArray arrayWithArray:data];
    for(NSDictionary *aChat in dataArr)
    {
        BOOL s = [_dataBase executeUpdate:query,
                  VALUE(KeyID, aChat),
                  VALUE(KeyFromUid, aChat),
                  VALUE(KeyUface, aChat),
                  VALUE(KeyUname, aChat),
                  VALUE(KeyAge, aChat),
                  VALUE(KeySex, aChat),
                  VALUE(KeyLasttalk, aChat),
                  VALUE(KeyStime, aChat),
                  VALUE(KeyUnreadNum, aChat),
                  VALUE(KeyType, aChat),
                  VALUE(KeyCompany, aChat),
                  VALUE(KeyHbody, aChat),
                  VALUE(KeyJobtitle, aChat),
                  VALUE(KeyLiked, aChat),
                  VALUE(KeyLovego, aChat),
                  VALUE(KeySayme, aChat),
                  VALUE(KeySchool, aChat),
                  VALUE(KeySstar, aChat),
                  VALUE(KeyWbody, aChat),
                  VALUE(KeyXblood, aChat),
                  VALUE(KeyDtime, aChat),
                  VALUE(KeyDmeter, aChat),
                  VALUE(KeyFacelist, aChat),
                  VALUE(KeyMe, aChat),
                  VALUE(KeyStatus, aChat)
                  ];
        if(!s)
        {
            NSLog(@"database action error:%@",[[_dataBase lastError] description]);
            
        }
    }
}

// 如果一个人改变了 更新表
-(void)updateAgreeData:(id)data forItem:(NSString *)itemName forUid:(NSString *)uid;
{
    if(![_dataBase goodConnection])
        [_dataBase open];
    if(![_dataBase tableExists:AgreeList])
    {
        [_dataBase close];
        return ;
    }
    // (ID,userid,uface,pname,oldyears,sex,content,stime,unreadnum,type)=?
    //company,hbody,jobtitle,liked,lovego,sayme,school,sstar,wbody,xblood
    NSString *query = [NSString stringWithFormat:@"UPDATE %@ SET ID=?,userid=?,uface=?,pname=?,oldyears=?,sex=?,content=?,stime=?,unreadnum=?,type=?,company=?,hbody=?,jobtitle=?,liked=?,lovego=?,sayme=?,school=?,sstar=?,wbody=?,xblood=?,facelist=?,ltime=?,dmeter=?,me=?,status=? WHERE ID=?",AgreeList];
    NSArray *dataArr = nil;
    if([data isKindOfClass:[NSDictionary class]])
        dataArr = [NSArray arrayWithObject:data];
    else
        dataArr = [NSArray arrayWithArray:data];
    for(NSDictionary *aChat in dataArr)
    {
        
        BOOL s = [_dataBase executeUpdate:query,
                  VALUE(KeyID, aChat),
                  VALUE(KeyFromUid, aChat),
                  VALUE(KeyUface, aChat),
                  VALUE(KeyUname, aChat),
                  VALUE(KeyAge, aChat),
                  VALUE(KeySex, aChat),
                  VALUE(KeyLasttalk, aChat),
                  VALUE(KeyStime, aChat),
                  VALUE(KeyUnreadNum, aChat),
                  VALUE(KeyType, aChat),
                  VALUE(KeyCompany, aChat),
                  VALUE(KeyHbody, aChat),
                  VALUE(KeyJobtitle, aChat),
                  VALUE(KeyLiked, aChat),
                  VALUE(KeyLovego, aChat),
                  VALUE(KeySayme, aChat),
                  VALUE(KeySchool, aChat),
                  VALUE(KeySstar, aChat),
                  VALUE(KeyWbody, aChat),
                  VALUE(KeyXblood, aChat),
                  VALUE(KeyFacelist, aChat),
                  VALUE(KeyDtime, aChat),
                  VALUE(KeyDmeter, aChat),
                  VALUE(KeyMe, aChat),
                  VALUE(KeyStatus, aChat),
                  VALUE(KeyID, aChat)
                  ];
        if(!s){
            
            NSLog(@"database action error:%@",[[_dataBase lastError] description]);
            
        }
        
    }
}

- (UIImage *)scaleImage:(UIImage *)image proportion:(float)scale {
    UIGraphicsBeginImageContext(CGSizeMake(image.size.width/scale, image.size.height/scale));
    CGRect imageRect = CGRectMake(0.0, 0.0, image.size.width/scale, image.size.height/scale);
    [image drawInRect:imageRect];
    image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}
- (void)dealloc
{
    self.dataBase = nil;
    // 滞空 让object 即使在此release 也不崩溃
    [_useruid release],_useruid=nil;
    [_userAvatar release],_userAvatar=nil;
    [_loginid release],_loginid=nil;
    [_chatuid release],_chatuid=nil;
    [_regDic release],_regDic=nil;
    [_nearBuddys release];
    [_nearDos release];
    [_contentArr release];
    [_friends release];
    [_friendsDos release];
    [_dialogs release];
    [_talkPeoples release];
    [_languageDictionary release];
    [_playBall release];
    
    [_ballTalk release];
    
    [_messageRadioDictionary release],_messageRadioDictionary=nil;
    
    [_keyArr release],_keyArr=nil;
    
    [_valueArr release],_valueArr=nil;
    
    [_unLoginArr release],_unLoginArr=nil;
    
    [_emiLanguageArr release],_emiLanguageArr=nil;
    
    [_emiNameArr release],_emiNameArr=nil;
    
    [_agreeList release],_agreeList=nil;
    
    [_talkArr release],_talkArr=nil;
    
    [_boolArr release],_boolArr=nil;
    
    [player release],player=nil;
    
    [super dealloc];
}

-(NSString *)UserDefautsKey:(int )from
{
    
    NSString *fr=[NSString stringWithFormat:@"%d",from*100+from*10+123];

    return [@"amsg" stringByAppendingString:fr];

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
