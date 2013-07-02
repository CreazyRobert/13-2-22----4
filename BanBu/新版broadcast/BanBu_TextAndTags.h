//
//  BanBu_TextAndTags.h
//  BanBu
//
//  Created by Jc Zhang on 13-3-12.
//
//

#import <UIKit/UIKit.h>
#import "WBEngine.h"
#import "QWeiboAsyncApi.h"
#import "FHSTwitterEngine.h"
@interface BanBu_TextAndTags : UIViewController<UIAlertViewDelegate,UITextFieldDelegate,UITextViewDelegate,WBEngineDelegate,FHSTwitterEngineAccessTokenDelegate>{
    
    NSData *_imageData;
    NSData *_soundData;
    NSString *_imageString;
    NSString *_soundString;
    UITextView *aTextView;
    UITextField *backTextField;
    UITextField *tagTextField;
    NSString *_soundTime;
}


@property(nonatomic,retain)UIView *functionView;
@property (nonatomic, retain) NSURLConnection *connection;

-(id)initWithSendImage:(NSData *)aImageData andSoundData:(NSData *)aSoundData andSoundDuration:(NSString *)duration;

@end
