//
//  BanBu_ViewController.h
//  BanBu
//
//  Created by apple on 12-11-20.
//
//

#import <UIKit/UIKit.h>
#import "BanBu_SmileView.h"
#import "CFCube.h"
#import "BanBu_LocationManager.h"
#import "AppCommunicationManager.h"
#import "AppDataManager.h"
#import "TKLoadingView.h"
#import "RecordView.h"
#import "BanBu_MakeBigMapViewController.h"
#import "BanBu_ChatViewController.h"

@interface BanBu_ViewController : UIViewController <UITextViewDelegate,BanBu_SmileViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,BanBu_LocationManagerDelegate,UITableViewDataSource,UITableViewDelegate,CFCubeDelegate,BanBuRequestDelegate,RecordViewDelegate,MakeMap>
{
    CFCube *_inputBar;
    UIView *_topBar;
    UITextView *_inputView;
    NSMutableArray *_buttons;
    UIButton *_plusButton;
    UIButton *_smileButton;
    UIButton *_actionButton;
    RecordView *_recordView;
    
    BOOL _showMenu;
    BOOL _firstHere;
    BanBu_SmileView *_smileView;
}

@property(nonatomic, retain)UITableView *tableView;
@property(nonatomic, retain)NSDictionary *profile;
// 这是经纬度
@property(nonatomic,retain)NSString *lat;
@property(nonatomic,retain)NSString *lon;

- (id)initWithPeopleProfile:(NSDictionary *)profile;
- (void)tableViewAutoOffset;
- (BOOL)fiveMinuteLater:(NSString *)stime beforeTime:(NSString *)ltime;

@end
