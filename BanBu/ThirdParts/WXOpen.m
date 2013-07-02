//
//  WXOpen.m
//  AboutFactory
//
//  Created by Jc Zhang on 12-12-6.
//
//

#import "WXOpen.h"

@implementation WXOpen
static WXOpen *sharedWXOpen = nil;

+ (WXOpen *)sharedWXOpen;
{
    @synchronized(self){
        if(sharedWXOpen == nil){
            sharedWXOpen = [[[self alloc] init] autorelease];
//            [sharedWXOpen initRaysource];
        }
    }
    return sharedWXOpen;
}


+(id)allocWithZone:(NSZone *)zone{
    @synchronized(self){
        if (sharedWXOpen == nil) {
            sharedWXOpen = [super allocWithZone:zone];
            return  sharedWXOpen;
        }
    }
    return nil;
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


- (void) sendTextContent:(NSString*)nsText
{
    SendMessageToWXReq* req = [[[SendMessageToWXReq alloc] init]autorelease];
    req.bText = YES;
    req.text = nsText;
    req.scene = _scene;
    
    [WXApi sendReq:req];
}

-(void) RespTextContent:(NSString *)nsText
{
    GetMessageFromWXResp* resp = [[[GetMessageFromWXResp alloc] init] autorelease];
    resp.text = nsText;
    resp.bText = YES;
    
    [WXApi sendResp:resp];
}

- (void) sendGifContentWithImageData:(NSData *)aData andThumbImage:(UIImage *)aImage
{
    //发送内容给微信
    WXMediaMessage *message = [WXMediaMessage message];
    [message setThumbImage:aImage];
    
    WXEmoticonObject *ext = [WXEmoticonObject object];
    ext.emoticonData = aData;
    
    message.mediaObject = ext;
    
    SendMessageToWXReq* req = [[[SendMessageToWXReq alloc] init]autorelease];
    req.bText = NO;
    req.message = message;
    req.scene = _scene;
    
    [WXApi sendReq:req];
}

- (void)RespGifContent
{
    
}

//- (void) sendImageContentWithImageData:(NSData *)aData andThumbImage:(UIImage *)aImage{
//    WXMediaMessage *message = [WXMediaMessage message];
//    [message setThumbImage:aImage];
////    NSLog(@"%@",bData);
//    WXImageObject *ext = [WXImageObject object];
//    ext.imageData = aData;
//    
//    message.mediaObject = ext;
//    SendMessageToWXReq *req = [[[SendMessageToWXReq alloc]init]autorelease];
//    req.bText = NO;
//    req.message = message;
//    req.scene = _scene;
//    [WXApi sendReq:req];
//    
//}
- (void) sendImageContentWithImageData:(NSData *)aData andThumbData:(NSData *)thumbData{
    WXMediaMessage *message = [WXMediaMessage message];
    message.thumbData = thumbData;
    //    NSLog(@"%@",bData);
    WXImageObject *ext = [WXImageObject object];
    ext.imageData = aData;
    
    message.mediaObject = ext;
    SendMessageToWXReq *req = [[[SendMessageToWXReq alloc]init]autorelease];
    req.bText = NO;
    req.message = message;
    req.scene = _scene;
    [WXApi sendReq:req];
    
}
- (void) RespImageContent{
    
}

-(void) sendMusicContentWithTitle:(NSString *)title andThumbImage:(UIImage *)thumb andMusicURL:(NSString *)url{
    
    WXMediaMessage *message = [WXMediaMessage message];
    NSArray *userArr = [NSArray array];
    userArr = [title componentsSeparatedByString:@"_"];
    message.title = [userArr objectAtIndex:0];

    if(userArr.count>1){
        message.description = [NSString stringWithFormat:@"提示：%@",[userArr objectAtIndex:1]];

    }
    [message setThumbImage:thumb];
    WXMusicObject *ext = [WXMusicObject object];
    ext.musicUrl = url;
    message.mediaObject = ext;
    SendMessageToWXReq *req = [[[SendMessageToWXReq alloc]init]autorelease];
    req.bText = NO;
    req.message = message;
    req.scene = _scene;
    [WXApi sendReq:req];
    
    
    
}
-(void) RespMusicContent{
    
}

- (void)sendNewsContentWithTitle:(NSString *)title andDescription:(NSString *)description andThumbImage:(UIImage *)imageString andWebPageURL:(NSString *)pageURL andScene:(NSInteger)scene{
    
    WXMediaMessage *message = [WXMediaMessage message];
    message.title = title;
    message.description = description;
    [message setThumbImage:imageString];

    WXWebpageObject *ext = [WXWebpageObject object];
    ext.webpageUrl = pageURL;
    
    message.mediaObject = ext;
    
    SendMessageToWXReq* req = [[[SendMessageToWXReq alloc] init]autorelease];
    req.bText = NO;
    req.message = message;
    req.scene = scene;
    
    [WXApi sendReq:req];
}

-(void)respNewsContenWithTitle:(NSString *)title andDescription:(NSString *)description andThumbImage:(UIImage *)imageString andWebPageURL:(NSString *)pageURL andScene:(NSInteger)scene{
    
}











@end
