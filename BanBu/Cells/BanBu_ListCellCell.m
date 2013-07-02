//
//  BanBu_ListCellCell.m
//  BanBu
//
//  Created by laiguo zheng on 12-7-10.
//  Copyright (c) 2012年 17xy. All rights reserved.
//

#import "BanBu_ListCellCell.h"
#import <QuartzCore/QuartzCore.h>

#define x 80
#define featureEndx 300
#define sep 5.0


@implementation BanBu_ListCellCell

@synthesize features = _features;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
//        UIImageView *bkView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 84)];
//        bkView.image = [[UIImage imageNamed:@"listbg.png"] stretchableImageWithLeftCapWidth:2.0 topCapHeight:4.0];
////        bkView.backgroundColor=[UIColor redColor];
//        self.backgroundView = bkView;
//        [bkView release];
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 83, 320, 1.0)];
        lineView.backgroundColor = [UIColor colorWithRed:224.0/255 green:224.0/255 blue:224.0/255 alpha:1.0];
        [self.contentView addSubview:lineView];
        [lineView release];
//        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(5,20, 60, 50)];
//        _iconView = imageView;
//        _iconView.contentMode = UIViewContentModeScaleAspectFit;
//		_iconView.layer.borderWidth = 1.0f;
//		_iconView.layer.borderColor = [[UIColor lightTextColor] CGColor];
//		[self addSubview:_iconView];
//        [imageView release];
		
		
		
//		_ageAndSexLabel = [[UILabel alloc] initWithFrame:CGRectMake(x, 28, 220, 40)];
//		_ageAndSexLabel.backgroundColor = [UIColor yellowColor];
//		_ageAndSexLabel.lineBreakMode = UILineBreakModeTailTruncation;
//		_ageAndSexLabel.numberOfLines = 0;
//		_ageAndSexLabel.font = [UIFont fontWithName:@"YaHei_Consolas_Hybrid" size:13];
//		_ageAndSexLabel.textColor = [UIColor darkGrayColor];
//		[self addSubview:_ageAndSexLabel];
//        [_ageAndSexLabel release];
        
        _signatureLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 10, 250, 30)];
		_signatureLabel.backgroundColor = [UIColor clearColor];
		_signatureLabel.font = [UIFont systemFontOfSize:15];
		_signatureLabel.textColor = [UIColor blackColor];
		[self.contentView addSubview:_signatureLabel];
        [_signatureLabel release];
        
        _distanceLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 45, 150, 30)];
		_distanceLabel.backgroundColor = [UIColor clearColor];
		_distanceLabel.lineBreakMode = UILineBreakModeTailTruncation;
		_distanceLabel.numberOfLines = 0;
//		_distanceLabel.font = [UIFont fontWithName:@"YaHei_Consolas_Hybrid" size:10];
        _distanceLabel.font = [UIFont systemFontOfSize:13];

		_distanceLabel.textColor = [UIColor darkGrayColor];
		[self.contentView addSubview:_distanceLabel];
        [_distanceLabel release];
        
//        CGFloat btnLen = [NSLocalizedString(@"commendLabel", nil) sizeWithFont:[UIFont systemFontOfSize:13] constrainedToSize:CGSizeMake(70, 15)].width;

//        commend=[[UILabel alloc]initWithFrame:CGRectMake(x+210-btnLen, 45, btnLen, 30)];
//        commend.backgroundColor=[UIColor clearColor];
//        commend.text = NSLocalizedString(@"commendLabel", nil);
//        commend.font = [UIFont systemFontOfSize:13];
//
////		commend.font = [UIFont fontWithName:@"YaHei_Consolas_Hybrid" size:10];
//        commend.textColor=[UIColor darkGrayColor];
//        [self.contentView addSubview:commend];
//        [commend release];

		UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(x+210, 40 , 20, 20)];;
        _commendNum = label;
		_commendNum.backgroundColor = [UIColor clearColor];
        _commendNum.textColor=[UIColor redColor];
        _commendNum.font = [UIFont systemFontOfSize:10];
		[self.contentView addSubview:_commendNum];
        [label release];
        UIImageView *pinglunImageView = [[UIImageView alloc]initWithFrame:CGRectMake(x+182, 48, 28, 24)];
        pinglunImageView.image = [UIImage imageNamed:@"dongtai.png"];
        [self addSubview:pinglunImageView];
        [pinglunImageView release];
        
        aBadgeView = [[UIBadgeView alloc]initWithFrame:CGRectZero];
        aBadgeView.backgroundColor = [UIColor clearColor];
        aBadgeView.badgeColor = [UIColor redColor];
        [self addSubview:aBadgeView];
        [aBadgeView release];
        //职业
//        for(int i=0; i<4; i++)
//        {
//            UIImageView *featureView = [[UIImageView alloc] initWithFrame:CGRectMake(featureEndx-(sep+10)*(i+1), 10, 10, 10)]; 
//            featureView.backgroundColor = [UIColor redColor];
//            featureView.tag = i;
//            [self addSubview:featureView];
//            [featureView release];
//        }
        
    }
    return self;
}

//- (void)setAvatar:(NSString *)avatarUrlStr
//{
//    [_iconView setImageWithURL:[NSURL URLWithString:avatarUrlStr] placeholderImage:[UIImage imageNamed:@"icon_default.png"]];
//}

-(void)setcommendNum:(NSString *)num
{
//    _commendNum.text=num;
    float width = [num sizeWithFont:[UIFont boldSystemFontOfSize:14]].width+12;
    //    NSLog(@"%f",width);
    aBadgeView.frame = CGRectMake(x+180+20, 50, width, 20);
    
    aBadgeView.badgeString = num;
    
}

//- (void)setAge:(NSInteger)age sex:(BOOL)sex
//{
//    _ageAndSexLabel.text = [NSString stringWithFormat:@"%i %@",age,sex?@"♂":@"♀"];
//    
//}

- (void)setDistance:(NSString *)disStr timeAgo:(NSString *)timeStr
{
    _distanceLabel.text = [NSString stringWithFormat:@"%@  %@",disStr,timeStr];
}

- (void)setSignature:(NSString *)signature
{
    _signatureLabel.text = signature;
}

- (void)setFeatures:(NSArray *)features
{
    for(int i=0; i<4; i++)
    {
        UIImageView *imageView = (UIImageView *)[self viewWithTag:i];
        if(i<features.count)
            imageView.image = [UIImage imageNamed:[features objectAtIndex:i]];
        else 
            imageView.image = nil;
    }
    
    [_features release];
    _features = [features retain];
          
}

//- (void)willMoveToSuperview:(UIView *)newSuperview {
//	[super willMoveToSuperview:newSuperview];
//	if(!newSuperview) {
//		[_iconView cancelCurrentImageLoad];
//        _iconView.image = nil;
//	}
//}
- (void)layoutSubviews
{
    if(self.highlighted)
    {
        _distanceLabel.textColor = [UIColor whiteColor];
        _signatureLabel.textColor = [UIColor whiteColor];
        commend.textColor = [UIColor whiteColor];
        
    }
    else
    {
        _distanceLabel.textColor = [UIColor grayColor];
        _signatureLabel.textColor = [UIColor darkGrayColor];
       
        commend.textColor = [UIColor darkGrayColor];
        
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

}

- (void)dealloc
{
    [_features release];
    [super dealloc];
}

@end
