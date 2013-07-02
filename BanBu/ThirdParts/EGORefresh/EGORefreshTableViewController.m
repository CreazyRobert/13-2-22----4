//
//  EGORefreshTableViewController.m
//  PullToRefresh
//
//  Created by apple on 11-9-10.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "EGORefreshTableViewController.h"


@interface EGORefreshTableViewController (Private)
- (void)setState:(EGOPullRefreshState)aState;
@end

@implementation EGORefreshTableViewController

#define TEXT_COLOR	 [UIColor colorWithRed:87.0/255.0 green:108.0/255.0 blue:137.0/255.0 alpha:1.0]
#define BK_COLOR [UIColor colorWithRed:226.0/255.0 green:231.0/255.0 blue:237.0/255.0 alpha:1.0]
#define FLIP_ANIMATION_DURATION 0.18f

- (id)initWithStyle:(UITableViewStyle)style {
	self = [super initWithStyle:style];
	if (self != nil) {
		//[self addHeaderView:self.tableView.frame arrowImageName:@"blueArrow.png" textColor:TEXT_COLOR];
	}
	return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
	self = [super initWithCoder:aDecoder];
	if (self != nil) {
		//[self addHeaderView:self.tableView.frame arrowImageName:@"blueArrow.png" textColor:TEXT_COLOR];
	}
	return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
	self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
	if (self != nil) {
		
	}
    return self;
}

-(void)viewDidLoad
{
	[self addHeaderView:self.tableView.frame arrowImageName:@"blueArrow.png" textColor:TEXT_COLOR];
    self.tableView.backgroundColor = BK_COLOR;
    
}

- (void)addHeaderView:(CGRect)frame arrowImageName:(NSString *)arrow textColor:(UIColor *)textColor
{
	_headerView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - self.tableView.bounds.size.height,self.tableView.bounds.size.width, self.tableView.bounds.size.height)];
	_headerView.backgroundColor = BK_COLOR;
	_headerView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
	
	
	UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, frame.size.height - 30.0f, frame.size.width, 20.0f)];
	label.autoresizingMask = UIViewAutoresizingFlexibleWidth;
	label.font = [UIFont systemFontOfSize:14.0f];
	label.textColor = textColor;
	label.shadowColor = [UIColor colorWithWhite:0.9f alpha:1.0f];
	label.shadowOffset = CGSizeMake(0.0f, 1.0f);
	label.backgroundColor = [UIColor clearColor];
	label.textAlignment = UITextAlignmentCenter;
	[_headerView addSubview:label];
	_lastUpdatedLabel=label;
	[label release];
	
	UILabel *sLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, frame.size.height - 48.0f, frame.size.width, 20.0f)];
	sLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
	sLabel.font = [UIFont boldSystemFontOfSize:13.0f];
	sLabel.textColor = textColor;
	sLabel.shadowColor = [UIColor colorWithWhite:0.9f alpha:1.0f];
	sLabel.shadowOffset = CGSizeMake(0.0f, 1.0f);
	sLabel.backgroundColor = [UIColor clearColor];
	sLabel.textAlignment = UITextAlignmentCenter;
	[_headerView addSubview:sLabel];
	_statusLabel=sLabel;
	[sLabel release];
	
	CALayer *layer = [CALayer layer];
	layer.frame = CGRectMake(25.0f, frame.size.height - 65.0f, 30.0f, 55.0f);
	layer.contentsGravity = kCAGravityResizeAspect;
	layer.contents = (id)[UIImage imageNamed:arrow].CGImage;
	
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 40000
	if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)]) {
		layer.contentsScale = [[UIScreen mainScreen] scale];
	}
#endif
	
	[[_headerView layer] addSublayer:layer];
	_arrowImage=layer;
	
	UIActivityIndicatorView *view = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
	view.frame = CGRectMake(25.0f, frame.size.height - 38.0f, 20.0f, 20.0f);
	[_headerView addSubview:view];
	_activityView = view;
	[view release];
	
	[self.tableView addSubview:_headerView];
	[_headerView release];
	[self setState:EGOOPullRefreshNormal];
}

- (void)setLoadingMore:(BOOL)flag
{
	if(flag)
	{
		_loadMore = YES;
		if(_footerView)
			return;
		_footerView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f,self.tableView.bounds.size.width,70.0f)];
//		_footerView.backgroundColor = BK_COLOR;
		_footerView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
		
		_loadMoreButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _loadMoreButton.frame = CGRectMake(8, 10, 304, 50);
//        _loadMoreButton.backgroundColor = [UIColor redColor];
        
       
        [_loadMoreButton setBackgroundImage: [[UIImage imageNamed:@"btn_big_normal_normal.9.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(20, 20, 20, 20)] forState:UIControlStateNormal];
        [_loadMoreButton setBackgroundImage: [[UIImage imageNamed:@"btn_big_normal_normal.9.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(20, 20, 20, 20)] forState:UIControlStateHighlighted];

//        [_loadMoreButton setBackgroundImage:[[UIImage imageNamed:@"btn_big_normal_normal.9.png"] stretchableImageWithLeftCapWidth:20.0 topCapHeight:20] forState:UIControlStateNormal];
//        [_loadMoreButton setBackgroundImage:[[UIImage imageNamed:@"btn_big_normal_press.9.png"] stretchableImageWithLeftCapWidth:20.0 topCapHeight:20] forState:UIControlStateHighlighted];

        [_loadMoreButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [_loadMoreButton setTitle:NSLocalizedString(@"loadMoreButton", nil) forState:UIControlStateNormal];
        [_loadMoreButton addTarget:self action:@selector(loadMore) forControlEvents:UIControlEventTouchUpInside];
        _loadMoreButton.titleLabel.font = [UIFont systemFontOfSize:18];
        [_footerView addSubview:_loadMoreButton];
		
		UIActivityIndicatorView *view = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
		view.frame = CGRectMake(60.0f,15.0f, 20.0f, 20.0f);
		[_loadMoreButton addSubview:view];
		_loadMoreHud = view;
		[view release];
		self.tableView.tableFooterView = _footerView;
        [_footerView release];
	}
	else
	{
		_loadMore = NO;
		if(self.tableView.tableFooterView)
		{
			self.tableView.tableFooterView = nil;
		}
		_footerView = nil;
	}
}


- (void)refreshLastUpdatedDate {
	
	NSDate *date = [NSDate date];
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	[dateFormatter setDateFormat:@"yyyy-MM-dd  HH:mm:ss"];
	NSString *timeStr = [dateFormatter stringFromDate:date];
	_lastUpdatedLabel.text = [NSString stringWithFormat:@"%@%@",NSLocalizedString(@"lastRefresh", nil),timeStr];
	[dateFormatter release];
	[[NSUserDefaults standardUserDefaults] setObject:timeStr forKey:@"EGORefreshTableView_LastRefresh"];
	[[NSUserDefaults standardUserDefaults] synchronize];
	
}

- (void)setState:(EGOPullRefreshState)aState{
	
	switch (aState) {
		case EGOOPullRefreshPulling:
			
			_statusLabel.text = NSLocalizedString(@"loosenRefresh", @"Release to refresh status");
			[CATransaction begin];
			[CATransaction setAnimationDuration:FLIP_ANIMATION_DURATION];
			_arrowImage.transform = CATransform3DMakeRotation((M_PI / 180.0) * 180.0f, 0.0f, 0.0f, 1.0f);
			[CATransaction commit];
			
			break;
		case EGOOPullRefreshNormal:
			
			if (_state == EGOOPullRefreshPulling) {
				[CATransaction begin];
				[CATransaction setAnimationDuration:FLIP_ANIMATION_DURATION];
				_arrowImage.transform = CATransform3DIdentity;
				[CATransaction commit];
			}
			
			_statusLabel.text = NSLocalizedString(@"pulldownRefresh", @"Pull down to refresh status");
			[_activityView stopAnimating];
			[CATransaction begin];
			[CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions];
			_arrowImage.hidden = NO;
			_arrowImage.transform = CATransform3DIdentity;
			[CATransaction commit];
			
			[self refreshLastUpdatedDate];
			
			break;
		case EGOOPullRefreshLoading:
			
			_statusLabel.text = NSLocalizedString(@"loadingNotice", @"Loading Status");
			[_activityView startAnimating];
			[CATransaction begin];
			[CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions];
			_arrowImage.hidden = YES;
			[CATransaction commit];
			
			break;
		default:
			break;
	}
	
	_state = aState;
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (_isLoadingMore || _isLoadingRefresh) {
		return;
		
		CGFloat offset = MAX(scrollView.contentOffset.y * -1, 0);
		offset = MIN(offset, 60);
		//scrollView.contentInset = UIEdgeInsetsMake(offset, 0.0f, 0.0f, 0.0f);
		
	} else if (scrollView.isDragging) {
		
		if (_state == EGOOPullRefreshPulling && scrollView.contentOffset.y > -65.0f && scrollView.contentOffset.y < 0.0f && !_isLoadingRefresh) {
			[self setState:EGOOPullRefreshNormal];
		} else if (_state == EGOOPullRefreshNormal && scrollView.contentOffset.y < -65.0f && !_isLoadingRefresh) {
			[self setState:EGOOPullRefreshPulling];
		}
		
		if (scrollView.contentInset.top != 0) {
			scrollView.contentInset = UIEdgeInsetsZero;
		}
		
	}
	
    //	if(self.tableView.tableFooterView && scrollView.contentSize.height>scrollView.frame.size.height && !_isLoadingMore)
    //	{
    //		if(scrollView.contentOffset.y > scrollView.contentSize.height+40-scrollView.frame.size.height)
    //			_loadMoreLabel.text = @"松开加载更多";
    //		else
    //			_loadMoreLabel.text = @"上拉加载更多";
    //
    //	}
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    
    
    if (scrollView.contentOffset.y <= - 65.0f && !_isLoadingRefresh) {
		_isLoadingRefresh = YES;
		[self setState:EGOOPullRefreshLoading];
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:0.2];
		scrollView.contentInset = UIEdgeInsetsMake(60.0f, 0.0f, 0.0f, 0.0f);
		[UIView commitAnimations];
		[self loadingData];
	}
	
    //	if(self.tableView.tableFooterView &&!_isLoadingMore)
    //	{
    //		if(scrollView.contentOffset.y > scrollView.contentSize.height+40-scrollView.frame.size.height)
    //		{
    //			_isLoadingMore = YES;
    //			_loadMoreLabel.text = @"正在加载……";
    //			[_loadMoreHud startAnimating];
    //			[self loadingData];
    //		}
    //	}
}

- (void)loadMore
{
    if(_isLoadingMore)
        return;
    _isLoadingMore = YES;
    [_loadMoreHud startAnimating];
    [_loadMoreButton setTitle:NSLocalizedString(@"loadingNotice", nil) forState:UIControlStateNormal];
    [self loadingData];
}

-(void)loadingData
{
	//[self performSelector:@selector(finishedLoading) withObject:nil afterDelay:1.0f];
    
}

- (void)setRefreshing
{
    if(!_isLoadingRefresh){
        _isLoadingRefresh = YES;
        
        [self setState:EGOOPullRefreshLoading];
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.4];
        if(self.tableView.contentSize.height > 60)
            self.tableView.contentOffset = CGPointMake(0.0, -60.0);
        else
            self.tableView.contentInset = UIEdgeInsetsMake(60.0f, 0.0f, 0.0f, 0.0f);
        
        [UIView commitAnimations];
        [self loadingData];
    }
   
}

- (void)finishedLoading
{
	if(_isLoadingRefresh)
    {
        [UIView animateWithDuration:.3
                         animations:^{
                             [self setState:EGOOPullRefreshNormal];
                             [self.tableView setContentOffset:CGPointZero animated:NO];
                             [self.tableView setContentInset:UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f)];
                         }
                         completion:^(BOOL finished) {
                             _isLoadingRefresh = NO;
                         }];
    }
    if(_isLoadingMore)
    {
        [_loadMoreHud stopAnimating];
        [_loadMoreButton setTitle:NSLocalizedString(@"loadMoreButton", nil) forState:UIControlStateNormal];
        _isLoadingMore = NO;
    }
	
}


- (void)didReceiveMemoryWarning {
    
    //NSLog(@"superLowMemery");
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    _activityView = nil;
	_statusLabel = nil;
	_arrowImage = nil;
	_lastUpdatedLabel = nil;
    _activityView = nil;
    _headerView = nil;
    _footerView = nil;
    _loadMoreButton = nil;
    _loadMoreHud = nil;
    [super viewDidUnload];
    
}


- (void)dealloc {
	
	_activityView = nil;
	_statusLabel = nil;
	_arrowImage = nil;
	_lastUpdatedLabel = nil;
    _activityView = nil;
    _headerView = nil;
    _footerView = nil;
    _loadMoreButton = nil;
    _loadMoreHud = nil;
    [super dealloc];
}


@end
