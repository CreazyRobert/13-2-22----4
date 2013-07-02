//
//  BanBu_MuteViewController.h
//  BanBu
//
//  Created by jie zheng on 12-7-7.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BanBu_MuteViewController : UITableViewController<UIPickerViewDelegate,UIPickerViewDataSource>
{
    UILabel *_fromTime;
    UILabel *_endTime;
}

@property(nonatomic, retain)UIView *footerView;
@property(nonatomic, retain)UIPickerView *timePicker;

@end
