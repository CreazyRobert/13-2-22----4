//
//  BanBu_MaskView.h
//  BanBu
//
//  Created by 来国 郑 on 12-7-25.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#define MaskViewTag 222

@interface BanBu_MaskView : UIView

@property (nonatomic, assign)SEL didTouchedSelector;
@property (nonatomic, assign)id delegate;

@end
