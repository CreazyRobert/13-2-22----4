//
//  BanBu_LoginViewController.h
//  BanBu
//
//  Created by jie zheng on 12-7-5.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BanBu_LoginViewController : UITableViewController<UITextFieldDelegate,FHSTwitterEngineAccessTokenDelegate>
{
    UITextField *_userName;
    UITextField *_userpw;
    NSString *_twitterLoginID;
    NSInteger _bindType;
    NSInteger _rows;
    
}

@property(nonatomic, retain)FHSTwitterEngine *twitterEngine;


@end
