//
//  BanBu_ListViewController.h
//  BanBu
//
//  Created by laiguo zheng on 12-7-10.
//  Copyright (c) 2012年 17xy. All rights reserved.
//

#import "EGORefreshTableViewController.h"
#import "BanBu_GridCell.h"
#import "BanBu_SmallListView.h"
#import "BanBu_LocationManager.h"
#import "CQSegmentControl.h"
#import "BanBu_choiceController.h"
typedef enum {
    ListTypeGirl = 0,
    ListTypeBoy,
    ListTypeAll
} ListType;

@interface BanBu_ListViewController : EGORefreshTableViewController <BanBu_GridCellDelegate,BanBu_SmallListViewDelegate,BanBu_LocationManagerDelegate>
{
    BOOL _sortByList;
    BOOL _firstRun;
    UILabel *_locationTip;
    
    UIImageView *cryImageView;
    UILabel *noticeLabel;
    BOOL _isPeople;
    CQSegmentControl *_segmentedControl;
    NSInteger gridViewRow;
    
    CGFloat contentOffsetY;
    
    CGFloat oldContentOffsetY;
    
    CGFloat newContentOffsetY;

}

@property(nonatomic,assign) NSInteger currentPage;
@property(nonatomic,assign) NSInteger DosPage;
@property(nonatomic,assign) ListType listType;

@property(nonatomic,retain) NSMutableArray *tempNearPeople;

@property(nonatomic,retain) NSMutableDictionary *existDic;



@end
