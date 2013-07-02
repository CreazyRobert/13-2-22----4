//
//  BanBu_MyBallsController.h
//  BanBu
//
//  Created by mac on 12-9-10.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "EGORefreshTableViewController.h"
#import "BanBu_AppDelegate.h"
#import "CJSONSerializer.h"
#import "BanBu_ViewController.h"
@interface BanBu_MyBallsController : UITableViewController{
    NSArray *saysArr;
}

@property(nonatomic, assign)NSInteger totalUnreadNum;

@end