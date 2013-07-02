//
//  BanBu_DialogueControllerViewController.h
//  BanBu
//
//  Created by 17xy on 12-7-30.
//
//

#import <UIKit/UIKit.h>
#import "AppDataManager.h"
#import "BanBu_AppDelegate.h"
#import "BanBu_RequestViewController.h"
@interface BanBu_DialogueController : UITableViewController<AppDataManagerDelegate>{
    
    NSMutableArray *deleteArr;
//    NSMutableArray *black;
    
    UIButton *deleteButton;
    BOOL _isPush;
}

@property(nonatomic, assign)NSInteger totalUnreadNum;
@property(nonatomic,assign)BanBu_RequestViewController *ProRequest;

- (void)updateBadgeShow;

//-(void)seeMyFriend:(NSString *)str;
@end
