//
//  BanBu_DrawRectListCell.h
//  BanBu
//
//  Created by Jc Zhang on 13-4-25.
//
//

#import <UIKit/UIKit.h>
#import "UIImageView+WebCache.h"
@interface BanBu_DrawRectListCell : UITableViewCell{
    
    NSString *_nameString;
    NSString *_distanceString;
    NSString *_signatureString;
    NSString *_lastTimeString;
     NSString *_sexString;
}



@property(nonatomic,retain)UIButton *nameLabel;
@property(nonatomic,retain)UIButton *ageAndSexButton;
@property(nonatomic,retain)UIButton *distanceLabel;
@property(nonatomic,retain)UIButton *signatureLabel;
@property(nonatomic,retain)UIButton *lastTimeLabel;
@property(nonatomic,retain)UIImageView *iconView;


- (void)setAvatar:(NSString *)avatarUrlStr;
- (void)setName:(NSString *)name;
- (void)setAge:(NSString *)age sex:(NSString *)sex;
- (void)setDistance:(NSString *)disStr timeAgo:(NSString *)timeStr;
- (void)setSignature:(NSString *)signature;
- (void)setLastInfo:(NSString *)infoStr;


//tableviewcell出屏幕了停止加载图片，动画等等
- (void)cancelImageLoad;


@end
