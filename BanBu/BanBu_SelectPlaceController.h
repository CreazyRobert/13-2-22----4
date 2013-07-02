//
//  BanBu_SelectPlaceController.h
//  BanBu
//
//  Created by mac on 12-9-10.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

//
//  BanBu_ThrowBallController.h
//  BanBu
//
//  Created by mac on 12-8-19.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SectionHeaderView.h"
@class MyActivityView;
@interface BanBu_SelectPlaceController : UIViewController<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,UIAlertViewDelegate,SectionHeaderViewDelegate>
{
    NSArray *indexTitle;
    NSMutableArray *indexData;
    NSMutableArray *cityData;
    UITextField *cityField;
    UITextField *placeField;
    NSString *tempPlaceStr;
    UIView *cityView;
    UIView *downView;
    
    NSString *provinceStr;
    NSString *cityStr;
    NSArray * placeData;
    NSArray *hotPlace;
    CGFloat buttonLength;
    CGFloat lineHeight;
    
    //tableview的扩展
    NSMutableArray *infoArray;
    NSInteger openSectionIndex;
    
    //经纬度
    NSString *posplat;
    NSString *posplong;
    
    
    UIButton *throwBtn;
    
    
    
    
    
    
    
}

@end
