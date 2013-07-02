//
//  BanBu_DigiCell.h
//  BanBu
//
//  Created by Jc Zhang on 13-3-15.
//
//

#import <UIKit/UIKit.h>
#import "UIButton+WebCache.h"
#import "UIImageView+WebCache.h"
@protocol PlayVoiceDelegate <NSObject>

-(void)playVoiceButton:(UIButton *)sender;
-(void)seeProfile:(UIButton *)sender;


@end


@interface BanBu_DigiCell : UITableViewCell{
    
    UIButton * _playButton;
    UIImageView *bkView;
}

@property(nonatomic,assign)id<PlayVoiceDelegate>delegate;
@property(nonatomic,retain)UIView *shadowView;
@property(nonatomic,retain)UIImageView *headImageView;
@property(nonatomic,retain)UIButton *iconButton;
@property(nonatomic,retain)UILabel *nameLabel;
@property(nonatomic,retain)UILabel *distanceAndTimeLabel;
@property(nonatomic,retain)UILabel *lastTimeLabel;
@property(nonatomic,retain)UILabel *sayTextLabel;
@property(nonatomic,retain)UIView *tagsView;//标签
@property(nonatomic,retain)UIButton * playButton;
@property(nonatomic,retain)UILabel *soundTimeLabel;
@property(nonatomic,retain)UIButton *telButton;

//关于回复
@property(nonatomic,retain)UIView *commentView;
@property(nonatomic,retain)UILabel *numLabel;
//一条回复
@property(nonatomic,retain)UIButton *iconBtn1;
@property(nonatomic,retain)UIButton *iconBtn2;
@property(nonatomic,retain)UIButton *iconBtn3;
@property(nonatomic,retain)UILabel * nameLabel1;
@property(nonatomic,retain)UILabel * nameLabel2;
@property(nonatomic,retain)UILabel * nameLabel3;

@property(nonatomic,retain)UILabel *soundTimeLabel1;
@property(nonatomic,retain)UILabel *soundTimeLabel2;
@property(nonatomic,retain)UILabel *soundTimeLabel3;



@property(nonatomic,retain)UIButton *voiceBtn1;
@property(nonatomic,retain)UIButton *voiceBtn2;
@property(nonatomic,retain)UIButton *voiceBtn3;
@property(nonatomic,retain)UILabel *textLabel1;
@property(nonatomic,retain)UILabel *textLabel2;
@property(nonatomic,retain)UILabel *textLabel3;

@property(nonatomic,retain)UILabel *timeLabel1;
@property(nonatomic,retain)UILabel *timeLabel2;
@property(nonatomic,retain)UILabel *timeLabel3;

@property(nonatomic,retain)UIView *lineView1;
@property(nonatomic,retain)UIView *lineView2;
@property(nonatomic,retain)UIView *lineView3;
@property(nonatomic,retain)UIView *lineView4;


- (void)setAvatar:(NSString *)avatarUrlStr;
- (void)setHeadImage:(NSString *)headImageUrlStr;



@end
