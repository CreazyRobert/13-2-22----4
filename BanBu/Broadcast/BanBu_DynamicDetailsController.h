//
//  BanBu_twoDynamicController.h
//  BanBu
//
//  Created by apple on 12-8-16.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "BanBu_DynamicCell.h"
#import "MWPhotoBrowser.h"
#import "BanBu_ReplyViewController.h"
#import "BanBu_NavigationController.h"

@interface BanBu_DynamicDetailsController : UITableViewController<BanBu_dynamicCellDelegate,SDWebImageManagerObsever,MWPhotoBrowserDelegate,UITextViewDelegate,UIActionSheetDelegate>
{
    
    NSMutableArray *dataArr;
    
    NSIndexPath *select;
    BOOL _success;
    NSDictionary *contentDic;    
    NSMutableArray *imageArr;
    NSInteger selectedImageIndex;
    
    BanBu_NavigationController *aBNC;
    UITextView *_inputView;
}

@property(nonatomic,retain)NSMutableDictionary *dynamic;

-(id)initWithDynamic:(NSDictionary *)dynamicDic;

@end



