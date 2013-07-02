//
//  BanBu_NameAndSexController.h
//  BanBu
//
//  Created by jie zheng on 12-7-6.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    NameAndSexViewFullType = 0,
    NameAndSexViewNameOnlyType
} NameAndSexViewType;
@class SVSegmentedControl;
@interface BanBu_NameAndSexController : UITableViewController<UIAlertViewDelegate>
{
    UITextField *_nameField;
    SVSegmentedControl *_sexSeg;
}

@property(nonatomic, assign)NameAndSexViewType viewType;
@property(nonatomic, retain)NSString *name;
@property(nonatomic, assign)BOOL sex;

- (id)initWithViewType:(NameAndSexViewType)type;


@end
