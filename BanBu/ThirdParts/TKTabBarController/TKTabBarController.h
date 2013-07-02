//
//  TKTabBarController.h
//  Ivan_Test
//
//  Created by laiguo zheng on 12-7-13.
//  Copyright (c) 2012年 17xy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TKTabBarController : UITabBarController
{
    UIImageView *_overlayBarView;
    NSMutableArray *_customItems;
    UIImageView *_animationView;
}

@property(nonatomic,retain) UIImageView *slideView;
@property(nonatomic,assign) BOOL useImageOnly;
@property(nonatomic,retain)NSArray *naviArr;
- (void)setTabBarBackgroundImage:(UIImage *)image;
- (void)setNormaolImage:(UIImage *)normalImage selectedImage:(UIImage *)selectedImage forItemWithIndex:(NSInteger)index;
- (void)setAnimationImage:(UIImage *)image;
-(void)setTabBarHidde:(BOOL)hidden;

@end
