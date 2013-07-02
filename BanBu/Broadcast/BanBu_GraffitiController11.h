//
//  RootViewController.h
//  兔丫丫
//
//  Created by mac on 12-8-6.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Canvas2D;
@interface BanBu_GraffitiController11 : UIViewController<UIApplicationDelegate,UIActionSheetDelegate>{
    UIView *bgView;
    UIButton *closeBtn;
    BOOL isClose;
    UILabel *textLabel;
    Canvas2D *aCan;
    
    UIActionSheet *emptySheet;
    UIActionSheet *sendSheet;
    
    UIImageView *tuyaImageView;//涂鸦模板
    UIImage *viewImage;
    UIImageView *sendImageview;

}
@end
