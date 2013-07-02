//
//  EGORefreshTableViewController.h
//  PullToRefresh
//
//  Created by apple on 11-9-10.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "Colors.h"

typedef enum{
	EGOOPullRefreshPulling = 0,
	EGOOPullRefreshNormal,
	EGOOPullRefreshLoading,	
} EGOPullRefreshState;


@interface EGORefreshTableViewController : UITableViewController {
	
	EGOPullRefreshState _state;
	
	UILabel *_lastUpdatedLabel;
	UILabel *_statusLabel;
	CALayer *_arrowImage;
	UIActivityIndicatorView *_activityView;
	UIView *_headerView;
    BOOL _isLoadingRefresh;
    BOOL _isLoadingMore;
	UIView *_footerView;
	UIButton *_loadMoreButton;
	UIActivityIndicatorView *_loadMoreHud;
	BOOL _loadMore;

}


- (void)addHeaderView:(CGRect)frame arrowImageName:(NSString *)arrow textColor:(UIColor *)textColor;

- (void)refreshLastUpdatedDate;
- (void)finishedLoading;
- (void)loadingData;
- (void)setLoadingMore:(BOOL)flag;
- (void)setRefreshing;

@end
