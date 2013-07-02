//
//  RecordView.h
//  BanBu
//
//  Created by zhengziyan19 on 12-8-20.
//
//

#import <UIKit/UIKit.h>
#import "RecordAudio.h"

@protocol RecordViewDelegate;

@interface RecordView : UIView <RecordAudioDelegate>
{
    UIButton *_cancelBtn;
    RecordAudio *_recorder;
}

@property (nonatomic, retain) UIImageView *volumeView;
@property (nonatomic, retain) UIImageView *progressView;
@property (nonatomic, retain) UILabel *timeLabel;
@property (nonatomic, retain) NSString *audioPath;
@property (nonatomic, assign) id<RecordViewDelegate> delegate;

- (void)touchesMovedInView:(CGPoint)point;
- (void)touchesEndInView:(CGPoint)point;

@end

@protocol RecordViewDelegate <NSObject>
@optional

- (void)recordView:(RecordView *)recordView recordDidCompleted:(NSData *)audioData recordTime:(int)duration;

@end