//
//  BanBu_SetAvatarViewController.h
//  BanBu
//
//  Created by jie zheng on 12-7-7.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIDevice+Helper.h"
@interface BanBu_SetAvatarViewController : UIViewController<UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIAlertViewDelegate>
{
    UIImageView *_avatorView;
    BOOL _picked;
    BOOL _useDefaultImage;
    
    UIScrollView *avatarScroll;
}

@property(nonatomic, retain) NSString *imagePathExtension;
@property(nonatomic, retain) NSMutableArray *facelist;
@end
