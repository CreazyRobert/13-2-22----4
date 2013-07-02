//
//  BanBu_BroadcastControllerViewController.h
//  BanBu
//
//  Created by 17xy on 12-7-31.
//
//

#import "EGORefreshTableViewController.h"
#import "BanBu_SmallListView.h"

@interface BanBu_BroadcastController : EGORefreshTableViewController<BanBu_SmallListViewDelegate>
{
    NSMutableArray *contentArr;
    UIImageView *cryImageView;
    UILabel *noticeLabel;
}

@property(nonatomic,assign) NSInteger currentPage;

@property(nonatomic,assign) NSInteger DosPage;
@end
