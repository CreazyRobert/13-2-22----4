//
//  WaterFlowView.h
//  BanBu
//
//  Created by apple on 12-12-11.
//
//

#import <UIKit/UIKit.h>
#import "waterFlowCell.h"
@protocol WaterFlowViewDelegate;
@protocol WaterFlowViewDataSource;
@class WaterFlowView;
@interface WaterFlowView : UIScrollView<UIScrollViewDelegate,UITableViewDataSource,UITableViewDelegate>
{



}
@property(nonatomic,assign)int cloumn;
@property(nonatomic,assign)int cellTotal;
@property(nonatomic,assign)float cellWidth;
@property(nonatomic,retain)NSMutableArray *tableViews;
@property(nonatomic,assign)id<WaterFlowViewDelegate>delegatee;
@property(nonatomic,assign)id<WaterFlowViewDataSource>datasouce;

// 实现的方法

-(void)reloadData;
-(void)relayoutDisplaySubviews;
-(NSInteger)waterFlowView:(WaterFlowView *)waterFlowView numberOfRowsInColumn:(NSInteger)colunm;

@end
@protocol WaterFlowViewDelegate <NSObject>

/*
 返回每个cell的高度
 */
- (CGFloat)waterFlowView:(WaterFlowView *)waterFlowView heightForRowAtIndexPath:(IndexPath *)indexPath;


/*
 跟据参数indexPath的行列属性，定位哪行哪列被选中
 */
- (void)waterFlowView:(WaterFlowView *)waterFlowView didSelectRowAtIndexPath:(IndexPath *)indexPath;


@end
@protocol WaterFlowViewDataSource <NSObject>
- (UIView *)waterFlowView:(WaterFlowView *)waterFlowView cellForRowAtIndexPath:(IndexPath *)indexPath;

/*
 将cell上的子视图传出，方便自定义子视图的样式，实现个性化定制
 */
-(void)waterFlowView:(WaterFlowView *)waterFlowView  relayoutCellSubview:(UIView *)view withIndexPath:(IndexPath *)indexPath;


/*
 返回瀑布效果的列数
 */
- (NSInteger)numberOfColumsInWaterFlowView:(WaterFlowView *)waterFlowView;

/*
 返回cell的总数，每个cell的行号通过总数和列号来确定
 */
- (NSInteger)numberOfAllWaterFlowView:(WaterFlowView *)waterFlowView;


@end

