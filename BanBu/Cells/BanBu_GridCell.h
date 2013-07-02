//
//  BanBu_GridCell.h
//  BanBu
//
//  Created by laiguo zheng on 12-7-10.
//  Copyright (c) 2012年 17xy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BanBu_Tile.h"

@protocol BanBu_GridCellDelegate;

@interface BanBu_GridCell : UITableViewCell

@property(nonatomic,retain)BanBu_Tile *tile0;
@property(nonatomic,retain)BanBu_Tile *tile1;
@property(nonatomic,retain)BanBu_Tile *tile2;
@property(nonatomic,retain)BanBu_Tile *tile3;

@property(nonatomic,assign)id<BanBu_GridCellDelegate> delegate;

- (void)setImage:(NSString *)imageUrlStr distance:(NSString *)dis sex:(BOOL)sex flag:(BOOL)flag forTile:(NSInteger)index name:(NSString *)name;
- (void)cancelImageLoad;

@end

@protocol BanBu_GridCellDelegate <NSObject>
@optional

- (void)gridCell:(BanBu_GridCell *)cell didSelectedTile:(NSInteger)tileIndex realRow:(NSInteger)row;

@end
