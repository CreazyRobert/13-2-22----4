//
//  TKTabBarItem.h
//  Ivan_Test
//
//  Created by jie zheng on 12-7-14.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TKTabBarItem : UIImageView
{
    UILabel *_titleLabel;
    
    
}

@property(nonatomic,retain)NSString *title;
@property(nonatomic,retain)UIImage *normalImage;
@property(nonatomic,retain)UIImage *selectedImage;
@property(nonatomic,retain)NSString *badgeValue;
@property(nonatomic,assign)BOOL selected;
@property(nonatomic,assign)BOOL useImageOnly;
@property(nonatomic,assign)BOOL space;
@end
