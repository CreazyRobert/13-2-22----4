//
//  BanBu_SmallListView.h
//  BanBu
//
//  Created by laiguo zheng on 12-7-11.
//  Copyright (c) 2012年 17xy. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BanBu_SmallListViewDelegate;

@interface BanBu_SmallListView : UIView <UITableViewDelegate,UITableViewDataSource>
{
    UITableView *_listView;
    
}

@property(nonatomic, assign)NSInteger selectedIndex;
@property(nonatomic, assign)id<BanBu_SmallListViewDelegate> delegate;
@property(nonatomic, retain)NSArray *listTitles;

- (id)initWithFrame:(CGRect)frame listTitles:(NSArray *)titles;
- (void)showFromPoint:(CGPoint)originPoint inView:(UIView *)superView animation:(BOOL)animationed;
- (void)dismissWithAnimation:(BOOL)animationed;

@end

@protocol BanBu_SmallListViewDelegate <NSObject>
@optional

- (void)smallListView:(BanBu_SmallListView *)smallListView didSelectIndex:(NSInteger)index;

@end
