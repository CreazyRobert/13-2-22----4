//
//  BanBu_BroadcastCell.m
//  BanBu
//
//  Created by apple on 12-8-5.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "BanBu_BroadcastCell.h"
#import <QuartzCore/QuartzCore.h>
#define x 90
#define featureEndx 310

#define sep 2.0

#define boyColor [UIColor colorWithRed:48.0/255 green:169.0/255 blue:217.0/255 alpha:1.0]

#define girlColor [UIColor colorWithRed:252.0/255 green:192.0/255 blue:213.0/255 alpha:1.0]

@implementation BanBu_BroadcastCell
@synthesize features=_features;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
//        UIImageView *bkView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 84)];
//        bkView.image = [[UIImage imageNamed:@"listbg.png"] stretchableImageWithLeftCapWidth:2.0 topCapHeight:4.0];
//        self.backgroundView = bkView;
//        [bkView release];
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 83, 320, 1.0)];
        lineView.backgroundColor = [UIColor colorWithRed:224.0/255 green:224.0/255 blue:224.0/255 alpha:1.0];
        [self.contentView addSubview:lineView];
        [lineView release];
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(5,5, 74, 74)];
        _iconView = imageView;
        _iconView.contentMode = UIViewContentModeScaleAspectFit;
		_iconView.layer.borderWidth = 1.0f;
		_iconView.layer.borderColor = [[UIColor lightTextColor] CGColor];
		[self addSubview:_iconView];
        [imageView release];
		
		UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(x,5, 120, 20)];
        _nameLabel = label;
		_nameLabel.textAlignment = UITextAlignmentLeft;
		_nameLabel.backgroundColor = [UIColor clearColor];
		_nameLabel.font = [UIFont systemFontOfSize:16];
		[self addSubview:_nameLabel];
        [label release];
		
        _ageAndSexButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _ageAndSexButton.frame = CGRectMake(x+199, 5, 28, 14);
        _ageAndSexButton.titleLabel.font = [UIFont systemFontOfSize:11];
        [_ageAndSexButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_ageAndSexButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 2, 0, 10)];
		[self addSubview:_ageAndSexButton];
        
        _distanceLabel = [[UILabel alloc] initWithFrame:CGRectMake(165, 8, 147, 14)];
		_distanceLabel.backgroundColor = [UIColor clearColor];
        _distanceLabel.textAlignment=UITextAlignmentRight;
		_distanceLabel.font = [UIFont systemFontOfSize:11];
		_distanceLabel.textColor = [UIColor grayColor];
		[self addSubview:_distanceLabel];
        [_distanceLabel release];
		
		_signatureLabel = [[UILabel alloc] initWithFrame:CGRectMake(x+125,2, 70, 20)];
		_signatureLabel.backgroundColor = [UIColor clearColor];
        _signatureLabel.numberOfLines=0;
		_signatureLabel.font = [UIFont systemFontOfSize:13];
		_signatureLabel.textColor = [UIColor darkGrayColor];
        [_signatureLabel setTextAlignment:UITextAlignmentRight];
		[self addSubview:_signatureLabel];
        [_signatureLabel release];
        
        _signatureLabelson=[[UILabel alloc]initWithFrame:CGRectMake(x,33,320-x-8,20 )];
        
        _signatureLabelson.backgroundColor=[UIColor clearColor];
        
        _signatureLabelson.font=[UIFont systemFontOfSize:13];
        
        _signatureLabelson.textColor=[UIColor darkGrayColor];
        
        [self addSubview:_signatureLabelson];
        
        [_signatureLabelson release];

        _showIntimeandDistance=[[UILabel alloc]initWithFrame:CGRectMake(x,58 , 180, 20)];
        
        _showIntimeandDistance.backgroundColor=[UIColor clearColor];
        
        _showIntimeandDistance.font=[UIFont systemFontOfSize:13];
        
        _showIntimeandDistance.textColor=[UIColor darkGrayColor];
        
        [self addSubview:_showIntimeandDistance];
        
        [_showIntimeandDistance release];
        
        _commend=[[UILabel alloc]initWithFrame:CGRectMake(x+160, 60, 50, 15)];
        
        _commend.backgroundColor=[UIColor clearColor];
        
        _commend.textAlignment = UITextAlignmentRight;
        _commend.font=[UIFont systemFontOfSize:13];
        
        _commend.textColor=[UIColor darkGrayColor];
        
        [self addSubview:_commend];
        
        [_commend release];
        
//        _commendNum=[[UILabel alloc]initWithFrame:CGRectMake(x+180+30, 52 , 20, 20)];
//        
//        _commendNum.backgroundColor=[UIColor clearColor];
//        
//        
//        _commendNum.font=[UIFont boldSystemFontOfSize:10];
//        
//        
//        _commendNum.textColor=[UIColor redColor];
//        
//        [self addSubview:_commendNum];
//        
//        [_commendNum release];
        UIImageView *pinglunImageView = [[UIImageView alloc]initWithFrame:CGRectMake(x+182, 53, 28, 24)];
        pinglunImageView.image = [UIImage imageNamed:@"dongtai.png"];
        [self addSubview:pinglunImageView];
        [pinglunImageView release];
        
        aBadgeView = [[UIBadgeView alloc]initWithFrame:CGRectZero];
        aBadgeView.backgroundColor = [UIColor clearColor];
        aBadgeView.badgeColor = [UIColor redColor];
        [self addSubview:aBadgeView];
        [aBadgeView release];
        
        
//        for(int i=0; i<4; i++)
//        {
//            UIImageView *featureView = [[UIImageView alloc] initWithFrame:CGRectMake(featureEndx-(sep+15)*(i+1), 10, 15, 11)]; 
//            featureView.backgroundColor = [UIColor clearColor];
//            featureView.tag = i;
//            [self addSubview:featureView];
//            [featureView release];
//        }
        
    }
  
        
        
        
        
        
    return  self;    
        
        
    
   

}


- (void)setAvatar:(NSString *)avatarUrlStr
{
    [_iconView setImageWithURL:[NSURL URLWithString:avatarUrlStr] placeholderImage:[UIImage imageNamed:@"icon_default.png"] andType:0];
}

- (void)setName:(NSString *)name
{
    _nameLabel.text = name;
}


- (void)setAge:(NSString *)age sex:(BOOL)sex
{
    if(sex)
    {
        [_ageAndSexButton setBackgroundImage:[UIImage imageNamed:@"boy.png"] forState:UIControlStateNormal];
        [_ageAndSexButton setBackgroundImage:[UIImage imageNamed:@"boy.png"] forState:UIControlStateHighlighted];
        [_ageAndSexButton setTitle:age forState:UIControlStateNormal];
    }
    
    else 
    {
        [_ageAndSexButton setBackgroundImage:[UIImage imageNamed:@"girl.png"] forState:UIControlStateNormal];
        [_ageAndSexButton setBackgroundImage:[UIImage imageNamed:@"girl.png"] forState:UIControlStateHighlighted];
        [_ageAndSexButton setTitle:age forState:UIControlStateNormal];
    }
    
}

- (void)setDistance:(NSString *)disStr timeAgo:(NSString *)timeStr
{
    _distanceLabel.text = [NSString stringWithFormat:@"%@ | %@",disStr,timeStr];
    _distanceLabel.font=[UIFont systemFontOfSize:10];
    
    _distanceLabel.textColor=[UIColor grayColor];
    
}

- (void)setSignature:(NSString *)signature
{
    _signatureLabel.text = signature;

}
-(void)setSignatureson:(NSString *)signature
{
    _signatureLabelson.text=signature;
    
}
- (void)setFeatures:(NSArray *)features
{
    for(int i=0; i<4; i++)
    {
        UIImageView *imageView = (UIImageView *)[self viewWithTag:i];
        if(i<features.count)
            imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"icon_industry%@_list.png",[features objectAtIndex:i]]];
        else 
            imageView.image = nil;
    }
    
    [_features release];
    _features = [features retain];
    
}


-(void)setshowIntimeandDistance:(NSString *)str
{
    _showIntimeandDistance.text=str;
    _showIntimeandDistance.font=[UIFont systemFontOfSize:11];
    _showIntimeandDistance.textColor=[UIColor grayColor];
    
    
}


-(void)setcommend:(NSString *)commend
{
    
//    _commend.text=commend;
//    CGFloat btnLen = [NSLocalizedString(@"commendLabel", nil) sizeWithFont:[UIFont systemFontOfSize:13] constrainedToSize:CGSizeMake(70, 15)].width;
//    _commend.frame = CGRectMake(x+210-btnLen, 60, btnLen, 15);
    
}

-(void)setcommendNum:(NSString *)num
{
//    _commendNum.text=num;
    float width = [num sizeWithFont:[UIFont boldSystemFontOfSize:14]].width+12;
//    NSLog(@"%f",width);
    aBadgeView.frame = CGRectMake(x+180+20, 50, width, 20);

    aBadgeView.badgeString = num;
    
    
}
- (void)layoutSubviews
{
    if(self.highlighted)
    {
        _nameLabel.textColor = [UIColor whiteColor];
        _distanceLabel.textColor = [UIColor whiteColor];
        _signatureLabel.textColor = [UIColor whiteColor];
        _signatureLabelson.textColor = [UIColor whiteColor];
        _showIntimeandDistance.textColor = [UIColor whiteColor];
        _commend.textColor = [UIColor whiteColor];
    
    }
    else 
    { 
        _nameLabel.textColor = [UIColor blackColor];
        _distanceLabel.textColor = [UIColor grayColor];
        _signatureLabel.textColor = [UIColor darkGrayColor];
        _signatureLabelson.textColor = [UIColor darkGrayColor];
        _showIntimeandDistance.textColor = [UIColor darkGrayColor];
        _commend.textColor = [UIColor darkGrayColor];
        
    }
}

- (void)willMoveToSuperview:(UIView *)newSuperview {
	[super willMoveToSuperview:newSuperview];
	if(!newSuperview) {
		[_iconView cancelCurrentImageLoad];
        _iconView.image = nil;
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
