//
//  BanBu_ChatCell.h
//  BanBu
//
//  Created by 来国 郑 on 12-7-24.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIImageView+WebCache.h"
#import "BanBu_SmileLabel.h"
#import "BanBu_MediaView.h"
#import <MapKit/MapKit.h>
#import "SCGIFImageView.h"
#import "BanBu_VoiceView.h"
#define CellMarge 5.0
#define ImageTypeHeight 80
#define VoiceTypeHeight 40
#define locationTypeHeight 80
#define TimeLabelHeight 24.0
#define FromLabelHeight 24.0

typedef enum {
    ChatStatusSendFail = 0,
    ChatStatusSent,
    ChatStatusSending,
    ChatStatusReaded,
    ChatStatusNone
} ChatStatus;

typedef enum {
    ChatCellTypeText = 0,
    ChatCellTypeImage,
    ChatCellTypeLocation,
    ChatCellTypeVoice,
    ChatCellTypeEmi
    
} ChatCellType;

@protocol MakeMap;

@interface BanBu_ChatCell : UITableViewCell <MKMapViewDelegate,UITextViewDelegate>
{
    UIImageView *_bkView;
}

@property(nonatomic, retain)UIImageView *avatar;
//@property(nonatomic, retain)UIImage
@property(nonatomic, retain)UILabel *smileLabel;
@property(nonatomic, retain)BanBu_MediaView *mediaView;
@property(nonatomic,retain)BanBu_VoiceView *voiceView;
@property(nonatomic, retain)MKMapView *mapView;
@property(nonatomic, retain)UIImageView *statusView;
@property(nonatomic, assign)BOOL atLeft;
@property(nonatomic, assign)BOOL showTime;
@property(nonatomic, assign)ChatCellType type;
@property(nonatomic, assign)ChatStatus status;
@property(nonatomic, assign)float bkViewWidth;
@property(nonatomic, retain)UILabel *timeLabel;
@property(nonatomic, assign)id<MakeMap>delegate;
@property(nonatomic,retain)SCGIFImageView *emiImage;
@property(nonatomic,assign)int statuss;
@property(nonatomic,retain)UILabel *demeterLabel;
//监控是不是来自破冰语
@property(nonatomic,retain)UILabel *fromLabel;
@property(nonatomic,assign)BOOL showFrom;
@property(nonatomic,retain)NSString *from;
@property(nonatomic,retain)UIButton *mapButton;
- (void)setSmileLabelText:(NSString *)text;
- (void)setStatus:(ChatStatus)status;
- (void)setMediaVoice:(NSString *)voicePath duration:(NSString *)duration;
- (void)setLocationLat:(CLLocationDegrees)lat andLong:(CLLocationDegrees)lon;
- (void)setAvatarImage:(NSString *)imageStr;

-(void)setEmi:(NSString *)text;

-(void)setVoiceViewLong:(CGFloat)time;


@end
@protocol MakeMap <NSObject>

-(void)MakeBigMap;

-(void)menuShow:(UIView *)sender tableCell:(BanBu_ChatCell *)sendert;

@optional

-(void)pushTheNextViewController:(NSString *)indext;

@end