//
//  BanBu_IceBreaker_Voice.h
//  BanBu
//
//  Created by Jc Zhang on 12-12-12.
//
//

#import <UIKit/UIKit.h>
//#import "BanBu_IceCell.h"
#import "EGORefreshTableViewController.h"
#import "BanBu_NavigationController.h"
@interface BanBu_IceBreaker_Voice : EGORefreshTableViewController<UIActionSheetDelegate>{
    BanBu_NavigationController *aBNC;
    NSInteger _selectedRow;
}

@property(retain,nonatomic) NSArray *dataArray;
@property(nonatomic,retain)NSString *voiceString;
@property(retain,nonatomic) NSMutableDictionary *parDic;

-(void)popself1;
@end
