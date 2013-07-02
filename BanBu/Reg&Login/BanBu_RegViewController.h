//
//  BanBu_RegViewController.h
//  BanBu
//
//  Created by jie zheng on 12-7-6.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BanBu_RegViewController : UITableViewController<UITextFieldDelegate>
{
    UITextField *_emailField;
    UITextField *_pwField;
    UITextField *_confirmPwField;
    UITextField *_checkCodeField;
    UIImageView *_randCodeView;
    BOOL canNext;
    BOOL isTrue;
}

@end
