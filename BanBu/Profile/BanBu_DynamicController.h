//
//  BanBu_DynamicController.h
//  BanBu
//
//  Created by mac on 12-8-7.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGORefreshTableViewController.h"
#import "BanBu_GridCell.h"

typedef enum {
    DisplayFriendsNews = 0,
    DisplayVisitRecord
} ADisplayType;

@interface BanBu_DynamicController : EGORefreshTableViewController<BanBu_GridCellDelegate>{
//    BOOL _change;
    
    NSMutableArray *contentArr;
    UIImageView *cryImageView;
    UILabel *noticeLabel;
    UIButton *recordButton;
    NSInteger gridViewRow;

}


@property(nonatomic,retain) NSMutableArray *dataArr;
@property(nonatomic, assign)ADisplayType type;
@property(nonatomic,retain)NSString *number;
-(id)initWithDynamicDisplayType:(ADisplayType)type;

@end
