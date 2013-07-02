//
//  BanBu_MessageOptionViewController.h
//  BanBu
//
//  Created by apple on 13-3-5.
//
//

#import <UIKit/UIKit.h>
#import "BanBu_MessageOptionCell.h"
@class BanBu_MessageOptionCell;
@interface BanBu_MessageOptionViewController : UITableViewController<UITableViewDataSource,UITableViewDataSource>
{
    
    
}
+(id)share;
-(void)tomakeChangeThePic:(int )cell;
+(void)haha;
@property(nonatomic,assign)BOOL flag;


@end
