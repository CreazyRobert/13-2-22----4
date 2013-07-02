//
//  BanBu_ListCellCell.h
//  BanBu
//
//  Created by laiguo zheng on 12-7-10.
//  Copyright (c) 2012年 17xy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIImageView+WebCache.h"
#import "UIBadgeView.h"

@interface BanBu_ListCellCell : UITableViewCell
{
    UILabel *_commendNum;
    UILabel *_ageAndSexLabel;
    UILabel *_distanceLabel;
    UILabel *_signatureLabel;
    UILabel *commend;
    UIBadgeView *aBadgeView;

//    UIImageView *_iconView;
    
}

@property(nonatomic,retain) NSArray *features;

//- (void)setAvatar:(NSString *)avatarUrlStr;
-(void)setcommendNum:(NSString *)num;
//- (void)setAge:(NSInteger)age sex:(BOOL)sex;
- (void)setDistance:(NSString *)disStr timeAgo:(NSString *)timeStr;
- (void)setSignature:(NSString *)signature;


@end
