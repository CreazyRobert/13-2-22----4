//
//  BanBu_ThrowBallController.h
//  BanBu
//
//  Created by mac on 12-8-19.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BroadcastRecordView.h"

@interface BanBu_ThrowBallController : UIViewController<UITextViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,BroadcastRecordViewDelegate,UIAlertViewDelegate,UIActionSheetDelegate>{
    UITextView *textview1;
    BOOL haveContent;
    NSMutableDictionary *saysDic;
    UIActionSheet *aSheet;
    UIAlertView *alertSuccess;
}
@property(assign,nonatomic)int btntag;

@end
