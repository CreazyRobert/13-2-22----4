//
//  BanBu_DynamicCell.h
//  BanBu
//
//  Created by apple on 12-8-16.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SDWebImageCompat.h"
#import "UIImageView+WebCache.h"
@protocol BanBu_dynamicCellDelegate;

typedef enum{
    DynamicMe = 0,
    DynamicTa
}DynamicType;

@interface BanBu_DynamicCell : UIView<SDWebImageManagerObsever>
{
  
    UIImageView *headImage;    
    UILabel *descriptionLabel;
    UILabel *nameLabel;
    UIButton *sexBtn;
    UIView *commitBtn;
    UIButton *zhuanfaBtn;
    
    UIImageView *backGround;
    //举报用
    UIImageView *jubaoView;
    
}

@property(nonatomic,retain)NSString *descriptionString;
@property(nonatomic,retain)UILabel *starLabel;
@property(nonatomic,retain)NSString *starString;
@property(nonatomic,retain)NSString  *picString;
@property(nonatomic,retain)NSMutableArray *picArr;
@property(nonatomic,retain)NSString  *sexbtnString;
@property(nonatomic,retain)NSString *zhuanfabtnString;
@property(nonatomic,retain)NSString  *commitbtnString;
@property(nonatomic,retain)NSString *timeString;
@property(nonatomic,retain)UILabel *timeLabel;
@property(nonatomic,assign)id<BanBu_dynamicCellDelegate>delegate;
@property(nonatomic,retain)UIImageView *headImage;
@property(nonatomic,retain)UILabel *nameLabel; 
@property(nonatomic,retain)NSString *gender;
@property(nonatomic,retain)NSString *age;
@property(nonatomic,assign)DynamicType type;

@property(nonatomic,assign)NSInteger selctedRow;

- (void)setAvatar:(NSString *)avatarUrlStr;


@end
@protocol BanBu_dynamicCellDelegate <NSObject>


-(void)pushNextViewController;

-(void)pushTobigPic:(NSNumber *)sender ;
-(void)reload;
-(void)transFormtheNew:(NSInteger)selectedrow;

-(void)information;

@end