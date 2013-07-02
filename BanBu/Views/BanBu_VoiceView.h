//
//  BanBu_VoiceView.h
//  BanBu
//
//  Created by apple on 13-2-17.
//
//

#import <UIKit/UIKit.h>
#import "RecordAudio.h"
#import "DDProgressView.h"
#import "BanBu_MediaView.h"
@class BanBu_ChatViewController;
// media 的5 种形态

@interface BanBu_VoiceView : UIView<RecordAudioDelegate>
{

    RecordAudio *_audioManager;
    BOOL isSlect;

}
@property(nonatomic, retain) NSString *mediaPath;
@property(nonatomic, assign) UIButton *showButton;
@property(nonatomic, retain) DDProgressView *progressBar;
@property(nonatomic, retain) UIImageView *playingView;
@property(nonatomic, assign) MediaStatus status;
@property(nonatomic, assign) BanBu_ChatViewController *appChatController;

@property(nonatomic,assign)BOOL isLeft;

@property(nonatomic,retain)NSString *timeview;
@property(nonatomic,retain)UILabel *timeLabel;
@property(nonatomic,assign)BOOL isPlay;
- (void)setMedia:(NSString *)mediaStr;
-(void)setTime:(CGFloat)time;
-(void)stopPlaying:(UITapGestureRecognizer *)tap;

@end
