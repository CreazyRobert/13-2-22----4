//
//  TKTabBarItem.m
//  Ivan_Test
//
//  Created by jie zheng on 12-7-14.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "TKTabBarItem.h"
#import "UIBadgeView.h"

#define BadgeTag 11

@implementation TKTabBarItem

@synthesize title = _title;
@synthesize normalImage = _normalImage;
@synthesize selectedImage = _selectedImage;
@synthesize selected = _selected;
@synthesize useImageOnly = _useImageOnly;
@synthesize badgeValue = _badgeValue;
@synthesize space=_space;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        
    }
    return self;
}

- (void)setSelected:(BOOL)selected
{
    _selected = selected;
    self.image = _selected?_selectedImage:_normalImage;
}

- (void)setUseImageOnly:(BOOL)useImageOnly
{
    _useImageOnly = useImageOnly;
    if(useImageOnly)
    {
        self.contentMode = UIViewContentModeScaleToFill;
        if(_titleLabel)
        {
            [_titleLabel removeFromSuperview];
            _titleLabel = nil;
        }
    }
    else 
    {
        self.contentMode = UIViewContentModeTop;
        if(!_titleLabel)
        {
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 32, self.bounds.size.width, 16)];
            label.backgroundColor = [UIColor clearColor];
            label.textAlignment = UITextAlignmentCenter;
            label.font = [UIFont systemFontOfSize:13];
            label.textColor = [UIColor whiteColor];
            label.text = self.title;
            _titleLabel = label;
            [self addSubview:label];
            [label release];
        }
    }
    
    [self layoutIfNeeded];
    
}

-(void)setSpace:(BOOL)space
{
  if(_space==space)
      return;

    _space=space;
    
    if(space)
    {
      // 判定badageview
        
        UIImageView *dotView=(UIImageView *)[self viewWithTag:100];
        
        if(!dotView)
        {
            dotView=[[UIImageView alloc]initWithFrame:CGRectMake(self.bounds.size.width-20,2 , 15, 15)];
            
            dotView.backgroundColor=[UIColor clearColor];
        
            dotView.image=[UIImage imageNamed:@"five.png"];
            
            [self addSubview:dotView];
            
            [dotView release];
            
        
        }
        
        
        
        
        
        
        
        
    }else
    {
     UIImageView *badgeView = (UIImageView *)[self viewWithTag:1000];
        
        [badgeView removeFromSuperview];
    
    }
    
    
}
- (void)setBadgeValue:(NSString *)badgeValue
{
    [_badgeValue release];
    _badgeValue = [badgeValue retain];
    UIBadgeView *badgeView = (UIBadgeView *)[self viewWithTag:BadgeTag];
    if(!badgeValue||![badgeValue intValue])
    {
        if(badgeView)
            [badgeView removeFromSuperview];
    }
    else 
    {
        float width = [badgeValue sizeWithFont:[UIFont boldSystemFontOfSize:14]].width+12;
        if(!badgeView)
        {
            badgeView = [[UIBadgeView alloc] initWithFrame:CGRectMake(self.bounds.size.width-width, 2, width, 20)];
            badgeView.tag = BadgeTag;
            badgeView.backgroundColor = [UIColor clearColor];
            badgeView.badgeColor = [UIColor redColor];
            [self addSubview:badgeView];
            [badgeView release];
        }
        badgeView.badgeString = badgeValue;
        [UIView animateWithDuration:0.5
                         animations:^{
                             badgeView.frame = CGRectMake(self.bounds.size.width-width, 2, width, 20);

                         }];
    }
}

- (void)setNormalImage:(UIImage *)normalImage
{
    [_normalImage release];
    _normalImage = [normalImage retain];
    if(!_selected)
        self.image = normalImage;
}

- (void)setSelectedImage:(UIImage *)selectedImage
{
    [_selectedImage release];
    _selectedImage = [selectedImage retain];
    if(_selected)
        self.image = selectedImage;
}

- (void)setTitle:(NSString *)title
{
    [_title release];
    _title = [title retain];
    _titleLabel.text = _title;
}

- (void)dealloc
{
    [_title release];
    [_normalImage release];
    [_selectedImage release];
    [_badgeValue release];
    [super dealloc];
}

@end
