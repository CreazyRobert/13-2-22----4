//
//  BanBu_MyFriendViewController.h
//  BanBu
//
//  Created by laiguo zheng on 12-7-12.
//  Copyright (c) 2012年 17xy. All rights reserved.
//

#import "EGORefreshTableViewController.h"
#import <UIKit/UIKit.h>
#import "BanBu_SmallListView.h"
#import "BanBu_AppDelegate.h"
#import "BanBu_DrawRectListCell.h"
typedef enum {
    ListTypeByDistance = 0,
    ListTypeByLastLoginTime,
    ListTypeByAddTime
} FriendListType;


@interface BanBu_MyFriendViewController : EGORefreshTableViewController <BanBu_SmallListViewDelegate>
{
    NSDictionary *summary;
    UIImageView *cryImageView;
    UILabel *noticeLabel;
    BOOL isSelected;
    CGFloat backX;
    int buttonTag;
    UIButton *categoryButton;
    UIImageView *laImageView;
    NSMutableArray *requestArr;
    
    NSMutableArray *deleteArr;
    UIButton *deleteButton;

}
@property(nonatomic,retain) NSMutableArray *tempNearPeople;

@property(nonatomic,assign) NSInteger currentPage;
@property(nonatomic,assign) FriendListType listType;
@property(nonatomic,retain) NSString *typeString;
@property(nonatomic,retain) NSString *number;
@end
