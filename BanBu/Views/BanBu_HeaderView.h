//
//  BanBu_HeaderView.h
//  BanBu
//
//  Created by apple on 12-12-21.
//
//

#import <UIKit/UIKit.h>
#import "UIImageView+WebCache.h"
#import "BanBu_ChatViewController.h"
@interface BanBu_HeaderView : UIView<SDImageCacheDelegate>
{



}
@property(nonatomic,retain)UIImageView *headImage;

@property(nonatomic,retain)UILabel *nameLabel;

@property(nonatomic,retain)UILabel *nameAndsex;

@property(nonatomic,retain)UILabel *starLabel;

@property(nonatomic,retain)UIButton *nextButton;

@property(nonatomic,retain)UILabel *ageLabel;


@property(nonatomic,assign)SEL nextView;

@property(nonatomic,assign)BanBu_ChatViewController *chat;


-(BanBu_HeaderView *)initWithDelegate:(BanBu_ChatViewController *)table Selector:(SEL)nextView Frame:(CGRect)rect TableView:(UITableView *)tablet ;


-(void)setHeadImaget:(NSString *)headImage;

-(void)setNameLabelt:(NSString*)name;

-(void)setStar:(NSString *)star;

-(void)setAgeAndSext:(NSString *)ageAndsex;

-(void)setAge:(NSString *)age;

-(void)setGender:(NSString *)sex;

@end
