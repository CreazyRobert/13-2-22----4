//
//  BanBu_WorkViewController.h
//  BanBu
//
//  Created by jie zheng on 12-7-10.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BanBu_TextEditer.h"
@interface BanBu_WorkViewController : UITableViewController<UITextFieldDelegate,BanBu_TextEditerDelegate>
{
    UITextField *_customWork;
}
@property(nonatomic, assign)NSInteger workType;
@property(nonatomic, copy)NSString *workInfo;
@property(nonatomic, retain)NSArray *worksArray;
@property(nonatomic,assign)id<BanBu_TextEditerDelegate>delegate;
@property(nonatomic,assign)int select;
- (id)initWithWorkInfo:(NSString *)info type:(NSInteger)type;


@end
//@protocol BanBu_TextEditerDelegate <NSObject>
//@optional
//-(void)banBuTextEditerDidChangeValue:(NSString *)newValue forItem:(NSString *)item;
//-(void)chuanzhi:(int) k;
//@end