//
//  BanBu_ListCellCell.m
//  BanBu
//
//  Created by laiguo zheng on 12-7-10.
//  Copyright (c) 2012年 17xy. All rights reserved.
//

#import "BanBu_ListCell.h"
#import <QuartzCore/QuartzCore.h>

#define x 90
#define featureEndx 310
#define sep 2.0

#define boyColor [UIColor colorWithRed:48.0/255 green:169.0/255 blue:217.0/255 alpha:1.0]
#define girlColor [UIColor colorWithRed:252.0/255 green:192.0/255 blue:213.0/255 alpha:1.0]


@implementation BanBu_ListCell

@synthesize features = _features;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        

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
//		_iconView.layer.borderWidth = 1.0f;
//		_iconView.layer.borderColor = [[UIColor lightTextColor] CGColor];
		[self.contentView addSubview:_iconView];
        [imageView release];
		
		UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(x,5, 160, 20)];
        _nameLabel = label;
		_nameLabel.textAlignment = UITextAlignmentLeft;
		_nameLabel.backgroundColor = [UIColor clearColor];
		_nameLabel.font = [UIFont systemFontOfSize:16];
		[self.contentView addSubview:_nameLabel];
        [label release];
		
        _ageAndSexButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _ageAndSexButton.userInteractionEnabled = NO;
        _ageAndSexButton.frame = CGRectMake(x, 35, 28, 14);
        _ageAndSexButton.titleLabel.font = [UIFont systemFontOfSize:11];
        [_ageAndSexButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_ageAndSexButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 2, 0, 10)];
		[self.contentView addSubview:_ageAndSexButton];
 
//        _ageAndSexButton = [[UIImageView alloc]init];
//        _ageAndSexButton.frame = CGRectMake(x, 35, 28, 14);
// 		[self.contentView addSubview:_ageAndSexButton];
        
        _distanceLabel = [[UILabel alloc] initWithFrame:CGRectMake(x+50, 33, 160, 16)];
		_distanceLabel.backgroundColor = [UIColor clearColor];
		_distanceLabel.font = [UIFont systemFontOfSize:13];
		_distanceLabel.textColor = [UIColor grayColor];
		[self.contentView addSubview:_distanceLabel];
        [_distanceLabel release];
		
		_signatureLabel = [[UILabel alloc] initWithFrame:CGRectMake(x,55, 220, 20)];
		_signatureLabel.backgroundColor = [UIColor clearColor];
		_signatureLabel.font = [UIFont systemFontOfSize:13];
		_signatureLabel.textColor = [UIColor darkGrayColor];
        
		[self.contentView addSubview:_signatureLabel];
        [_signatureLabel release];
        
       /* for(int i=0; i<4; i++)
        {
            UIImageView *featureView = [[UIImageView alloc] initWithFrame:CGRectMake(featureEndx-(sep+15)*(i+1), 10, 15, 11)]; 
            featureView.backgroundColor = [UIColor clearColor];
            featureView.tag = i;
            [self addSubview:featureView];
            [featureView release];
        }*/
        
        _lastTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(x+160, 8, 60, 15)];
        _lastTimeLabel.backgroundColor = [UIColor clearColor];
		_lastTimeLabel.font = [UIFont systemFontOfSize:13];
        _lastTimeLabel.textAlignment = UITextAlignmentRight; 
		_lastTimeLabel.textColor = [UIColor grayColor];
		[self.contentView addSubview:_lastTimeLabel];
        [_lastTimeLabel release];
    }
    return self;
}

- (void)setLastInfo:(NSString *)infoStr;
{
    _lastTimeLabel.text = infoStr;
}

- (void)setAvatar:(NSString *)avatarUrlStr
{
    [_iconView setImageWithURL:[NSURL URLWithString:avatarUrlStr] placeholderImage:[UIImage imageNamed:@"icon_default.png"] andType:1];
}

- (void)setName:(NSString *)name
{
    _nameLabel.text = name;
}

//-(void)drawRect:(CGRect)rect{
//    UIImage * imagePic=[UIImage imageNamed:[NSString stringWithFormat:@"%@.png",_sexString]];
//    [imagePic drawInRect:CGRectMake(x, 35, 28, 14)];
//}

- (void)setAge:(NSString *)age sex:(NSString *)sex
{
    [_ageAndSexButton setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@.png",sex]] forState:UIControlStateNormal];
    [_ageAndSexButton setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@.png",sex]] forState:UIControlStateHighlighted];
    [_ageAndSexButton setTitle:age forState:UIControlStateNormal];
    
    
//    if(sex)
//    {
//        [_ageAndSexButton setBackgroundImage:[UIImage imageNamed:@"boy.png"] forState:UIControlStateNormal];
//         [_ageAndSexButton setTitle:age forState:UIControlStateNormal];
//    }
//        
//    else 
//    {
//        [_ageAndSexButton setBackgroundImage:[UIImage imageNamed:@"girl.png"] forState:UIControlStateNormal];
//         [_ageAndSexButton setTitle:age forState:UIControlStateNormal];
//    }
    
}

- (void)setDistance:(NSString *)disStr timeAgo:(NSString *)timeStr
{
    
    
    _distanceLabel.text = [NSString stringWithFormat:@"%@ | %@",disStr,timeStr];
}

- (void)setSignature:(NSString *)signature
{
    _signatureLabel.text = signature;
}

- (void)setFeatures:(NSArray *)features
{
    for(int i=0; i<4; i++)
    {
        UIImageView *imageView = (UIImageView *)[self.contentView viewWithTag:i];
        if(i<features.count)
            imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"icon_industry%@_list.png",[features objectAtIndex:i]]];
        else 
            imageView.image = nil;
    }
    
    [_features release];
    _features = [features retain];
          
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    if(self.highlighted)
    {
        _nameLabel.textColor = [UIColor whiteColor];
        _distanceLabel.textColor = [UIColor whiteColor];
        _signatureLabel.textColor = [UIColor whiteColor];
        _lastTimeLabel.textColor = [UIColor whiteColor];
//        [_ageAndSexButton setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@.png",_sexString]] forState:UIControlStateHighlighted];

    }
    else
    { 
        _nameLabel.textColor = [UIColor blackColor];
        _distanceLabel.textColor = [UIColor grayColor];
        _signatureLabel.textColor = [UIColor darkGrayColor];
        _lastTimeLabel.textColor = [UIColor grayColor];

    }
}


-(void)cancelImageLoad{
    
    [_iconView cancelCurrentImageLoad];
    _iconView.image = nil;
}

- (void)willMoveToSuperview:(UIView *)newSuperview {
	[super willMoveToSuperview:newSuperview];
	if(!newSuperview) {
		[self cancelImageLoad];
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
