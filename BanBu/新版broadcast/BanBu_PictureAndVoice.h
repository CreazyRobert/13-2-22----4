//
//  BanBu_PictureAndVoice.h
//  BanBu
//
//  Created by Jc Zhang on 13-3-11.
//
//

#import <UIKit/UIKit.h>
#import "RecordView.h"

@interface BanBu_PictureAndVoice : UIViewController<UINavigationControllerDelegate, UIImagePickerControllerDelegate, RecordViewDelegate,AVAudioPlayerDelegate>{
    
    UIButton *_playButton;
    UIImageView *disPlayImageView;
    RecordView *_recordView;
    NSData *_sendSoundData;
    NSString *_soundDuration;
}

@property(nonatomic,retain) AVAudioPlayer *player;

@property(nonatomic,retain)UIView *contentView;
@property(nonatomic,retain)UIImageView *playingView;
@end
