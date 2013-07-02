//
//  WXOpen.h
//  AboutFactory
//
//  Created by Jc Zhang on 12-12-6.
//
//

#import <Foundation/Foundation.h>
#import "WXApi.h"
#define MyWXOpen [WXOpen sharedWXOpen]

@interface WXOpen : NSObject{
    enum WXScene _scene;

}

@property(nonatomic,assign)enum WXScene scene;
+ (WXOpen *)sharedWXOpen;

- (void) sendTextContent:(NSString*)nsText;
-(void) RespTextContent:(NSString *)nsText;

- (void) sendGifContentWithImageData:(NSData *)aData andThumbImage:(UIImage *)aImage;
- (void)RespGifContent;
//- (void) sendImageContentWithImageData:(NSData *)aData andThumbImage:(UIImage *)aImage;
- (void) sendImageContentWithImageData:(NSData *)aData andThumbData:(NSData *)thumbData;

- (void) RespImageContent;

-(void) sendMusicContentWithTitle:(NSString *)title andThumbImage:(UIImage *)thumb andMusicURL:(NSString *)url;
-(void) RespMusicContent;

- (void)sendNewsContentWithTitle:(NSString *)title andDescription:(NSString *)description andThumbImage:(UIImage *)imageString andWebPageURL:(NSString *)pageURL andScene:(NSInteger)scene;
- (void)respNewsContenWithTitle:(NSString *)title andDescription:(NSString *)description andThumbImage:(UIImage *)imageString andWebPageURL:(NSString *)pageURL andScene:(NSInteger)scene;


@end
