//
//  BanBu_SelectController.h
//  BanBu
//
//  Created by mac on 12-9-7.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BanBu_SelectController : UIViewController{
    BOOL isHidden;
    UILabel *label1;
    UILabel *label2;
    UILabel *label3;
    NSTimer *aTimer;

}
@property(nonatomic,assign)int totalUnreadNum;
-(void)updateBadgeShow;
@end
