//
//  AppComManagerDelegate.h
//  BanBu
//
//  Created by zhengziyan19 on 12-8-9.
//
//

@class AppCommunicationManager;

@protocol BanBuRequestDelegate<NSObject>
@optional

- (void)banbuRequestNamed:(NSString *)requestname uploadDataProgress:(float)progress;
- (void)banbuUploadRequest:(NSDictionary *)resDic didFinishedWithError:(NSError *)error;
- (void)banbuRequestNamed:(NSString *)requestname downloadDataProgress:(float)progress;
- (void)banbuDownloadRequest:(NSDictionary *)resDic didFinishedWithError:(NSError *)error;
- (void)banbuRequestDidFinished:(NSDictionary *)resDic error:(NSError *)error;

-(void)seeBigPic;

-(void)removeTk;
@end
