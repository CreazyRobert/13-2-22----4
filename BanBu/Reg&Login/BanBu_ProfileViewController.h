//
//  BanBu_ProfileViewController.h
//  BanBu
//
//  Created by apple on 13-1-11.
//
//

#import <UIKit/UIKit.h>
#import "BanBu_PhotoManager.h"
#import "BanBu_PeopleProfileController.h"
@interface BanBu_ProfileViewController : UITableViewController<UIAlertViewDelegate,UIActionSheetDelegate>
{
    int grjsNum;
    BOOL isHaveGRJS;
//    NSMutableDictionary *titleAndValueDic;
    NSMutableArray *titleAndValueArr;

}
@property(nonatomic,retain)NSMutableDictionary *dictionary;
@property(nonatomic,assign)DisplayType type;
@property(nonatomic, retain)NSArray *headerArr;
@property(nonatomic,retain)BanBu_PhotoManager *photoView;
@property(nonatomic,retain)UIView *toolbarView;
@property(nonatomic, retain)NSMutableArray *userActions;
-(id)initWithDictionary:(NSMutableDictionary *)dictionary DisplayType:(DisplayType)type;
+(BanBu_ProfileViewController *)getBanBu;
@end
