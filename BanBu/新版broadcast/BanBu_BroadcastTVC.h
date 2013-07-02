//
//  BanBu_BroadcastTVC.h
//  BanBu
//
//  Created by Jc Zhang on 13-3-15.
//
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "EGORefreshTableViewController.h"
#import "BanBu_DigiCell.h"

@interface BanBu_BroadcastTVC : EGORefreshTableViewController<PlayVoiceDelegate,AVAudioPlayerDelegate>{
    
    CGFloat _textHeight;
    CGFloat _headImageViewHeight;
    NSString *_imageContentString;
    NSString *_soundContentString;
    NSString *_soundTimeString;
    
    NSInteger commentCount;
    
    NSMutableArray *contentArr;
    UIImageView *cryImageView;
    UILabel *noticeLabel;
    
    UIButton *_voiceButton;
    UIActivityIndicatorView *_playHUD;
    UIImageView *animationBackgroundView;
    NSString *keywordString;
    UIButton *listButton;
    UIButton *btn_return;
    BOOL isFirst;
    UIView *footerView;
    
    NSString *farDemeter;
    
}
@property(nonatomic,assign) NSInteger DosPage;
@property(nonatomic,retain) AVAudioPlayer *player;


@end
