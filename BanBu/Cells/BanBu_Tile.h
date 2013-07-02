//
//  BanBu_Tile.h
//  BanBu
//
//  Created by laiguo zheng on 12-7-10.
//  Copyright (c) 2012年 17xy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIImageView+WebCache.h"

@interface BanBu_Tile : UIView
{
    UILabel *_sexLabel;
}

@property(nonatomic,retain)UIImageView *imageShow;
@property(nonatomic,retain)UILabel *titleLabel;
@property(nonatomic,assign)BOOL sex;
@property(nonatomic,retain)UILabel *headLabel;
@end
 