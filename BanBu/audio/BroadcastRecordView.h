//
//  BroadcastRecordView.h
//  BanBu
//
//  Created by mac on 12-8-29.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RecordAudio.h"

@protocol BroadcastRecordViewDelegate;

@interface BroadcastRecordView : UIView<RecordAudioDelegate>{
    UIButton *_cancelBtn;
    RecordAudio *_recorder;
    BOOL toggle;

}

@property(nonatomic,retain)UIImageView *volumeView;
@property(nonatomic,retain)UIImageView *progressView;
@property(nonatomic,retain)UILabel *timeLabel;
@property(nonatomic,retain)NSString *audioPath;
@property(nonatomic,assign)id<BroadcastRecordViewDelegate>delegate;

@end

@protocol BroadcastRecordViewDelegate <NSObject>

- (void)recordView:(BroadcastRecordView *)recordView recordDidCompleted:(NSData *)audioData recordTime:(int)duration;

@end