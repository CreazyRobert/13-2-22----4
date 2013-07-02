//
//  BanBu_icePicController.h
//  BanBu
//
//  Created by apple on 12-12-11.
//
//

#import <UIKit/UIKit.h>
#import "EGORefreshTableViewController.h"
#import "WaterFlowView.h"
#import "BanBuRequestDelegate.h"
#import "MWPhoto.h"
#import "MWPhotoBrowser.h"
#import "BanBu_photoBrowserViewController.h"
#import "SCGIFViewController.h"

@protocol selectImage <NSObject>

-(void)placeImageToTuya:(NSString *)string;

@end
@interface BanBu_icePicController :EGORefreshTableViewController<WaterFlowViewDataSource,WaterFlowViewDelegate,BanBuRequestDelegate,UIActionSheetDelegate,BrowserGifDelegate>
{
    // 存放数据的数组
    
    
    
    //控制瀑布流的view
    WaterFlowView *waterFlow;
    NSString *thumbImageStr;
    NSString *saybeforString;
    id<selectImage> delegate;
    NSArray *suffixArr;
    
}
@property(nonatomic,retain)NSMutableDictionary *receiveDictionary;
@property(nonatomic,retain)NSMutableArray *showPhotoes;
@property(nonatomic,retain)NSMutableArray *urlArray;
@property(retain,nonatomic) NSMutableDictionary *parDic;
@property (assign,nonatomic)id<selectImage> delegate;
@property (retain,nonatomic) NSString *hints;
@property (retain,nonatomic) NSMutableArray *arrayData;

-(id)initWithDictionary:(NSDictionary *)receiveDictionary;


//-(void)dataSouceDidLoad;
//-(void)dataSouceDidError;

@end



