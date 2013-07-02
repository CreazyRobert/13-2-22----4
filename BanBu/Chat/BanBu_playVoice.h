//
//  BanBu_playVoice.h
//  BanBu
//
//  Created by Jc Zhang on 12-12-13.
//
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "BanBu_IceBreaker_Voice.h"
@class BanBu_IceBreaker_Voice;


@interface BanBu_playVoice : UIViewController<AVAudioPlayerDelegate,UIActionSheetDelegate>{

    AVAudioPlayer *_player;
    UIButton *playButton;
//    UIImageView *gifImageView;
}

@property(nonatomic,retain)NSString *voiceURL;
@property(nonatomic,assign)BanBu_IceBreaker_Voice *push;
@property(nonatomic,retain)NSString *naviTitle;

//-(void)initWithPlayVoice:();

@end
