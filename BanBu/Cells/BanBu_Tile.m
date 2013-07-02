//
//  BanBu_Tile.m
//  BanBu
//
//  Created by laiguo zheng on 12-7-10.
//  Copyright (c) 2012年 17xy. All rights reserved.
//

#import "BanBu_Tile.h"

#define titleLabelHeight 15
#define boyColor [UIColor colorWithRed:48.0/255 green:169.0/255 blue:217.0/255 alpha:1.0]
#define girlColor [UIColor colorWithRed:252.0/255 green:192.0/255 blue:213.0/255 alpha:1.0]

@implementation BanBu_Tile

@synthesize titleLabel = _titleLabel;
@synthesize sex = _sex;
@synthesize imageShow = _imageShow;
@synthesize headLabel=_headLabel;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor clearColor];
        
        _imageShow = [[UIImageView alloc] initWithFrame:self.bounds];
        [self addSubview:_imageShow];
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.bounds.size.height-titleLabelHeight, self.bounds.size.width, titleLabelHeight)];
        titleLabel.backgroundColor = [UIColor colorWithWhite:0 alpha:0.6];
        titleLabel.font = [UIFont systemFontOfSize:14];
        titleLabel.textColor = [UIColor whiteColor];
        titleLabel.textAlignment = UITextAlignmentLeft;
        self.titleLabel = titleLabel;
        [self addSubview:titleLabel];
        [titleLabel release];
        
        UILabel *sexLabel = [[UILabel alloc] initWithFrame:CGRectMake(titleLabel.frame.origin.x+3, titleLabel.frame.origin.y, titleLabel.frame.size.width, titleLabel.frame.size.height)];
        _sexLabel = sexLabel;
        sexLabel.backgroundColor = [UIColor clearColor];
        sexLabel.textAlignment = UITextAlignmentRight;
        sexLabel.font = [UIFont systemFontOfSize:14];
        [self addSubview:sexLabel];
        [sexLabel release];
        
        _headLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.bounds.size.width, titleLabelHeight)];
        _headLabel.backgroundColor=[UIColor colorWithWhite:0 alpha:.3];
        
        _headLabel.font = [UIFont systemFontOfSize:14];
        _headLabel.textColor = [UIColor whiteColor];
        _headLabel.textAlignment = UITextAlignmentCenter;

         
        [self addSubview:_headLabel];
        
        [_headLabel release];
        
    }
    return self;
}

- (void)setSex:(BOOL)sex
{
    if(sex)
    {
        _sexLabel.text = @"♂ ";
        _sexLabel.textColor = boyColor;
    }
    else 
    {
        _sexLabel.text = @"♀ ";
        _sexLabel.textColor = girlColor;
    }
    _sex = sex;
}




- (void)dealloc
{
    [_imageShow release];
    [_titleLabel release];
    [super dealloc];
    
}

@end
 

