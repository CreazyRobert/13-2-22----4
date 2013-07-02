//
//  BanBu_UnloginedController.h
//  BanBu
//
//  Created by jie zheng on 12-7-5.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BanBu_GridCell.h"
#import "BanBu_LocationManager.h"

#import "BanBu_ProfileViewController.h"
@interface BanBu_UnloginedController : UITableViewController<BanBu_GridCellDelegate,UIAlertViewDelegate,BanBu_LocationManagerDelegate>
{
    UIActivityIndicatorView *activityView;
    UILabel *moreLabel;
    UIButton *_loadMoreButton;
    BOOL _one;
    NSInteger gridViewRow;

}
@property(nonatomic, retain) UILabel *peopleLabel;

@property(nonatomic,assign)int currentPage;

@end
