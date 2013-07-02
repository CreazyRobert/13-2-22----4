//
//  BanBu_BirthdayViewController.h
//  BanBu
//
//  Created by jie zheng on 12-7-6.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BanBu_BirthdayViewController : UITableViewController{
    BOOL isFirst;
}

@property(nonatomic, assign) UIDatePicker *birthdayPicker;
@property(nonatomic, retain) NSString *birthdayStr;

- (void)setDate:(NSDate *)date;


@end
