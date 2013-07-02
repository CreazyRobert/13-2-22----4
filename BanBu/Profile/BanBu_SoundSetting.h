//
//  BanBu_SoundSetting.h
//  BanBu
//
//  Created by Jc Zhang on 13-6-8.
//
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
@interface BanBu_SoundSetting : UITableViewController{
    
    NSInteger _selectRow;
    NSInteger _sectionNumber;
    UISwitch *_soundSwitch;
    AVAudioPlayer *_player;

}

@end
