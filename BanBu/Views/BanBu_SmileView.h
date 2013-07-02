//
//  BanBu_SmileView.h
//  BanBu
//
//  Created by jie zheng on 12-7-16.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SCGIFImageView.h"
#define SmileViewDefaultHeight 216.0

typedef enum {
    SmileViewSmileType = 0,
    SmileViewCharactersPaintedType,
    SmileViewAddType
} SmileViewType;

typedef enum
{
  SmileViewLayoutStand,
    
  SmileViewLayoutAdd

}SmileViewLayoutType;




@protocol BanBu_SmileViewDelegate;

@interface BanBu_SmileView : UIView <UIScrollViewDelegate>
{
    UIScrollView *_contengView;
    UIButton *cancelButton;
    UIImageView *_arrow;
    

}

@property(nonatomic,assign) SmileViewType type;
@property(nonatomic,retain) NSMutableArray *inputedStr;
@property(nonatomic,assign) id<BanBu_SmileViewDelegate> delegate;
@property(nonatomic,assign) SmileViewLayoutType typeLay;
@property(nonatomic,retain) SCGIFImageView *gifView;
@property(nonatomic,retain) UIPageControl *pageControl;

@end

@protocol BanBu_SmileViewDelegate <NSObject>
@optional

- (void)banBu_SmileView:(BanBu_SmileView *)smileView didInputSmile:(NSString *)inputString isDelete:(BOOL)del type:(int) smile;

@optional

-(void)banBu_ActionView:(BanBu_SmileView *)actionView didInputBrand:(UIButton *)actionBrand isAdd:(BOOL)add;

-(NSString *)addActionCard;

@end
