//
//  BanBu_BlacklistViewController.h
//  BanBu
//
//  Created by jie zheng on 12-7-8.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGORefreshTableViewController.h"
@interface BanBu_BlacklistViewController : EGORefreshTableViewController{
    UIButton *unlock;
    NSIndexPath *tempIndexPath;
}

@property(nonatomic,retain) NSMutableArray *dataArr;

@end
