//
//  BanBu_ChangePWViewController.h
//  BanBu
//
//  Created by jie zheng on 12-7-7.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BanBu_ChangePWViewController : UITableViewController<UITextFieldDelegate>
{
    UITextField *_oldPWField;
    UITextField *_newPWField;
    UITextField *_confirmPWField;
}

@end
