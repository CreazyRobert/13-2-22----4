//
//  BanBu_IceBreakerController.h
//  BanBu
//
//  Created by mac on 12-8-18.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGORefreshTableViewController.h"
#import "BanBu_NavigationController.h"

@interface BanBu_IceBreakerController : EGORefreshTableViewController<UIActionSheetDelegate>{
//    NSArray *dataArray;
    BanBu_NavigationController *aBNC;
    NSInteger selectedRow;

}

@property(retain,nonatomic) NSArray *dataArray;
@property(retain,nonatomic) NSMutableDictionary *parDic;
@end
