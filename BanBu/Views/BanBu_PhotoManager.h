//
//  BanBu_PhotoManager.h
//  BanBu
//
//  Created by jie zheng on 12-7-8.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MWPhotoBrowser.h"
#import "UIButton+WebCache.h"

@interface BanBu_PhotoManager : UIView <UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,MWPhotoBrowserDelegate>
{
    UIScrollView *_contentView;
    NSInteger _rows;
    UIButton *_lockedButton;
    id _owner;
    UIImage *shareImage;
}

@property(nonatomic,assign)BOOL edit;
@property(nonatomic,retain)NSMutableArray *myPhotos;
@property(nonatomic,retain)UIButton *addButton;
@property(nonatomic,assign)CGFloat contentViewHeight;
@property(nonatomic,retain)NSArray *showPhotos;

@property(nonatomic, retain)NSMutableArray *delPhotoArr;
@property(nonatomic, retain)NSMutableArray *addPhotoArr;



- (id)initWithPhotos:(NSArray *)photos owner:(id)owner;
- (void)clearEditData;



@end
