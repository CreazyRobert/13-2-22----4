//
//  BanBu_SettingViewController.h
//  BanBu
//
//  Created by jie zheng on 12-7-7.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BanBu_SettingViewController : UITableViewController<UIActionSheetDelegate>{
    UISwitch *_messageSwitch;
    UISwitch *_friendDosSwitch;
    UISwitch *_soundSwitch;
}

@end
