//
//  BanBu_PeopleProfileController.h
//  BanBu
//
//  Created by laiguo zheng on 12-7-12.
//  Copyright (c) 2012年 17xy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BanBu_PhotoManager.h"
#import "AppCommunicationManager.h"
#import "CustomAlertView.h"
#import "RadioButton.h"
#import "BanBu_NoteView.h"
#import "BanBu_ReportView.h"
@class BanBu_NavigationController;
typedef enum
{
    DisplayTypePeopleProfile = 0,
    DisplayTypePeopleNews
    
} DisplayType;
@interface BanBu_PeopleProfileController : UITableViewController <UIActionSheetDelegate,BanBuRequestDelegate,UIAlertViewDelegate,UITextViewDelegate,RadioButtonDelegate,UITextFieldDelegate,ChangeNameDelegate,ReportViewDelegate>
{
    BanBu_PhotoManager *_photoView;
    BOOL _linked;
    UIButton *_talkButton;
    UIButton *_linkButton;
    BOOL _isBlack;
    NSInteger _kind;
//    NSInteger _writeButtonTitleType;//1:好友请求，2：确认好友,3:写信息
    UIAlertView *greetAlert;
    
    
    
    CustomAlertView *customAlert;
    NSInteger reportMessIndex;
    UITextField * textView1;//举报详细信息
    
    BanBu_ReportView *aReportView;
    
    
    
    int grjsNum;
    BOOL isHaveGRJS;
    BanBu_NavigationController *aNC;
    BanBu_NoteView *aNote;
//    NSMutableArray *titleArr;
//    NSMutableArray *titleValueArr;
//    NSMutableDictionary *titleAndValueDic;
    NSMutableArray *titleAndValueArr;
}

@property(nonatomic, retain)NSMutableDictionary *profile;
@property(nonatomic, retain)NSArray *headerArr;
@property(nonatomic, retain)NSMutableArray *userActions;
@property(nonatomic, retain)UIView *toolbarView;
@property(nonatomic, assign)DisplayType type;
@property(nonatomic, assign)BOOL isRequestFriend;

- (id)initWithProfile:(NSDictionary *)profileDic displayType:(DisplayType)type;

@end
