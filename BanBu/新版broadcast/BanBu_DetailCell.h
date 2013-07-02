//
//  BanBu_DetailCell.h
//  BanBu
//
//  Created by Jc Zhang on 13-3-20.
//
//

#import <UIKit/UIKit.h>
#import "UIButton+WebCache.h"
#import "UIImageView+WebCache.h"

@interface BanBu_DetailCell : UITableViewCell

@property(nonatomic,retain)UIButton *iconButton;
@property(nonatomic,retain)UILabel *nameLabel;
@property(nonatomic,retain)UILabel *distanceAndTimeLabel;
@property(nonatomic,retain)UILabel *lastTimeLabel;
@property(nonatomic,retain)UILabel *sayTextLabel;
@property(nonatomic,retain)UIButton * playButton;
@property(nonatomic,retain)UILabel *timeLabel;

- (void)setAvatar:(NSString *)avatarUrlStr;

@end
