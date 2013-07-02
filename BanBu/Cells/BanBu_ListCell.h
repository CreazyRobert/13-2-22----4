//
//  BanBu_ListCellCell.h
//  BanBu
//
//  Created by laiguo zheng on 12-7-10.
//  Copyright (c) 2012年 17xy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIImageView+WebCache.h"

@interface BanBu_ListCell : UITableViewCell
{
    UILabel *_nameLabel;
    UIButton *_ageAndSexButton;
//    UIImageView *_ageAndSexButton;

    UILabel *_distanceLabel;
    UILabel *_signatureLabel;
    UILabel *_lastTimeLabel;
    UIImageView *_iconView;
    NSString *_sexString;
}

@property(nonatomic,retain) NSArray *features;
@property(nonatomic,retain) NSString *sexString;
- (void)setAvatar:(NSString *)avatarUrlStr;
- (void)setName:(NSString *)name;
- (void)setAge:(NSString *)age sex:(NSString *)sex;
- (void)setDistance:(NSString *)disStr timeAgo:(NSString *)timeStr;
- (void)setSignature:(NSString *)signature;
- (void)setLastInfo:(NSString *)infoStr;

//tableviewcell出屏幕了停止加载图片，动画等等
- (void)cancelImageLoad;


@end
