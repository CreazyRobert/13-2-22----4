//
//  BanBu_BroadcastCell.h
//  BanBu
//
//  Created by apple on 12-8-5.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIImageView+WebCache.h"
#import "UIBadgeView.h"

@interface BanBu_BroadcastCell : UITableViewCell
{
    UILabel *_nameLabel;
    UIButton *_ageAndSexButton;
    UILabel *_distanceLabel;
    UILabel *_signatureLabel;
    UILabel *_signatureLabelson;
    UILabel *_showIntimeandDistance;
    UILabel *_commend;
    UILabel *_commendNum;
    UIBadgeView *aBadgeView;
    UIImageView *_iconView;
    
}
@property(nonatomic,retain)NSArray *features;
- (void)setAvatar:(NSString *)avatarUrlStr;
- (void)setName:(NSString *)name;
- (void)setAge:(NSString *)age sex:(BOOL)sex;
- (void)setDistance:(NSString *)disStr timeAgo:(NSString *)timeStr;
- (void)setSignature:(NSString *)signature;
- (void)setSignatureson:(NSString *)signature;
- (void)setcommend:(NSString *)commend;
- (void)setshowIntimeandDistance:(NSString *)str;
- (void)setcommendNum:(NSString *)num;
@end
