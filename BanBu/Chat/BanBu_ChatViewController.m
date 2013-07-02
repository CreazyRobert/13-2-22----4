 //
//  BanBu_ChatViewController.m
//  BanBu
//
//  Created by jie zheng on 12-7-15.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "BanBu_ChatViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "BanBu_NoticeView.h"
#import "BanBu_NoticeView1.h"
#import "BanBu_ChatCell.h"
#import "BanBu_MaskView.h"
#import "BanBu_PeopleProfileController.h"
#import "CJSONSerializer.h"
#import "BanBu_IceBreakerController.h"
#import "BanBu_GraffitiController.h"
#import "BanBu_HeaderView.h"
#import "BanBu_SmallListView.h"
#import "BanBu_IceBreaker_Voice.h"
#import "BanBu_icePicController.h"
#import "BanBu_SearchIceViewController.h"
#import "BanBu_MyProfileViewController.h"
#import "BanBu_DialogueController.h"
#import "ShareViewController.h"
#import "WXOpen.h"
#define InputViewDefaultHeight 28.0
#define InputBarY 372.0
#define SmileStr  @"[装可爱]|[睁大眼睛]|[阴谋得逞]|[压力好大]|[兴高采烈]|[太帅了]|[睡觉]|[求饶]|[求包养]|[俏皮]|[怒发冲冠]|[目瞪口呆]|[路过]|[泪流满面]|[可怜兮兮]|[害羞]|[歌舞王后]|[高歌一曲]|[发奋图强]|[嘟嘟嘴]|[大跌眼镜]|[打怪兽]|[吃包子]|[不同意]"

// 832 行 发送图片

@interface BanBu_ChatViewController()

- (void)tableViewAutoOffset;

- (BOOL)fiveMinuteLater:(NSString *)stime beforeTime:(NSString *)ltime;

- (void)sendOneMsg:(id)MsgData type:(ChatCellType)type filePathExtension:(NSString *)pathExtension From:(NSString *)from;
-(void)rotateImageView;

-(void)ShareOrDelete:(id)number;

-(NSMutableArray *)returnArrNumber:(NSString *)t;


@end

@implementation BanBu_ChatViewController

@synthesize tableView = _tableView;

@synthesize lat=_lat,lon=_lon;
@synthesize location=_location;
@synthesize selectArr=_selectArr;
@synthesize rowt=_rowt;
@synthesize type=_type;
@synthesize listType=_listType;
@synthesize latiArr=_latiArr;
BOOL iskeyboard = NO;
BOOL isSmileView = NO;
- (id)initWithPeopleProfile:(NSDictionary *)profile
{
    self = [super init];
    if (self) {
//        NSLog(@"%@",profile);
        self.profile = profile;
        
        MyAppDataManager.chatuid = [profile valueForKey:KeyFromUid];
    
        NSString *jsonfrom = [[CJSONSerializer serializer] serializeArray: VALUE(@"facelist", profile)];
        
        NSMutableDictionary *taProfile=[[[NSMutableDictionary alloc]initWithDictionary:profile]autorelease];
        
        [taProfile setValue:jsonfrom forKey:@"facelist"];
        
        [UserDefaults setValue:taProfile forKey:@"zouni"];
        
        self.title = [MyAppDataManager IsInternationalLanguage:[MyAppDataManager IsMinGanWord:[MyAppDataManager theRevisedName:VALUE(KeyUname, _profile) andUID:VALUE(KeyUid, _profile)]]];

    }
    return self;
}

-(void)refreshViewDidCallBack
{
    
}

-(void)switchVoiceOrTextButton
{
//    if([_inputView isFirstResponder])
//    {
//    [_inputView becomeFirstResponder];
    
//    SmileViewSmileType = 0,
//    SmileViewCharactersPaintedType,
//    SmileViewAddType
//    if(_smileView.type == SmileViewSmileType)
//    {
//    [_actionButton setImage:[UIImage imageNamed:@"btn_send.png"] forState:UIControlStateNormal];
////    [_smileView becomeFirstResponder];
//    isSmileView = YES;
//    }
//    if(_smileView.type == SmileViewCharactersPaintedType)
//    {
//        [_actionButton setImage:[UIImage imageNamed:@"btn_typevoice.png"] forState:UIControlStateNormal];
//        isSmileView = NO;
//    }


    
}

// 删除聊天记录之后要把ID 归零
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.multipleTouchEnabled = NO;
    
    self.navigationItem.leftBarButtonItem = [self createBackButton];
    
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(switchVoiceOrTextButton) name:@"switchVoiceOrText" object:nil];

    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(listeningAction:) name:@"Mynotification" object:nil];

    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(iceAction:) name:@"iceWord" object:nil];

    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(icePic:) name:@"icePic" object:nil];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(iceVoice:) name:@"iceVoice" object:nil];
    
    
        
    _latiArr=[[NSMutableArray alloc]init];
    
    MyAppDataManager.appChatController = self;
    
//    refresh=[[RefreshView alloc]initWithFrame:CGRectMake(0, 0, 1, 1)];
//        
//    [refresh setupWithOwner:self.tableView delegate:self];
    
    
    /*
     //?????? ****************
    
     [MyAppDataManager.dialogs removeAllObjects];
    
    // 获取全部的对话
  //  [MyAppDataManager readMoreDataForCurrentDialog:AllData];
    */
     
    // 一进来读取20 条
     [MyAppDataManager.dialogs removeAllObjects];
     [MyAppDataManager.talkArr removeAllObjects];
    
    [MyAppDataManager readMoreDataForCurrentDialog:AllData];
    
    [MyAppDataManager readMoreDataForCurrentDialog:DefaultReadNum];
    
    
    _selectArr=[[[NSMutableArray alloc]initWithCapacity:10]autorelease];
    
    _firstHere = YES;
        
    UIImageView *bkView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    
    bkView.tag=606;
    
    bkView.image = [UIImage imageNamed:@"chatbg.png"];
    [self.view addSubview:bkView];
    [bkView release];
    
    // 写一个tableview 的headerView
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, __MainScreen_Height-88) style:UITableViewStylePlain];
    self.tableView = tableView;
    [self.view addSubview:tableView];
    [tableView release];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor colorWithRed:255.0/255 green:250.0/255 blue:240.0/255 alpha:1.0];
    
    // banbu 的headview
    BanBu_HeaderView *header=[[BanBu_HeaderView alloc]initWithDelegate:self Selector:@selector(pushnext) Frame:CGRectMake(0, 0, 320, 64) TableView:self.tableView];
//    NSLog(@"%@",[self.profile valueForKey:@"sstar"]);
    [header setStar:[MyAppDataManager IsInternationalLanguage:[self.profile valueForKey:@"sstar"]]];
    
    [header setHeadImaget:[self.profile valueForKey:@"uface"]];
    
//    NSLog(@"%@",[self.profile allKeys]);
    if([[self.profile allKeys] containsObject:@"sex"])
    {
    
        [header setAgeAndSext:[self.profile valueForKey:@"sex"]];
    
    }else
    {
     
        [header setGender:[self.profile valueForKey:@"gender"]];
    
    }
    [header setNameLabelt:[MyAppDataManager theRevisedName:[self.profile valueForKey:@"pname"] andUID:[self.profile valueForKey:@"userid"]]];
    
    [header setAge:[self.profile valueForKey:@"oldyears"]];
    if(_listType == 0){
        self.tableView.tableHeaderView=header;
        
    }
    
    [header release];
    
   /* UIButton *profileButton = [UIButton buttonWithType:UIButtonTypeCustom];
    profileButton.frame=CGRectMake(0, 0, 70, 30);
    [profileButton addTarget:self action:@selector(seeProfile:) forControlEvents:UIControlEventTouchUpInside];
    [profileButton setBackgroundImage:[[UIImage imageNamed:@"app_nav_btn_bg1.png"] stretchableImageWithLeftCapWidth:15.0 topCapHeight:15.0] forState:UIControlStateNormal];
    [profileButton setBackgroundImage:[[UIImage imageNamed:@"app_nav_btn_bg2.png"] stretchableImageWithLeftCapWidth:15.0 topCapHeight:15.0] forState:UIControlStateHighlighted];
    [profileButton setTitleEdgeInsets:UIEdgeInsetsMake(3, 2, 2, 2)];
    [profileButton setTitle:NSLocalizedString(@"profileButton", nil) forState:UIControlStateNormal];
    profileButton.titleLabel.font = [UIFont systemFontOfSize:14];
   
    UIBarButtonItem *profileItem = [[[UIBarButtonItem alloc] initWithCustomView:profileButton] autorelease];
    self.navigationItem.rightBarButtonItem = profileItem;
 */
    
//    _listType=0;
    
   // 各种操作和
    // 这是 topbar
    //
//    UIView *showView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 80, 44)];
    
    UIButton *actionButton=[UIButton buttonWithType:UIButtonTypeCustom];
    
    actionButton.frame=CGRectMake(0, 7, 50, 30);
    
    [actionButton addTarget:self action:@selector(changeList) forControlEvents:UIControlEventTouchUpInside];
    
//    [actionButton setTitle:NSLocalizedString(@"opera", nil) forState:UIControlStateNormal];

//    actionButton.titleLabel.font=[UIFont systemFontOfSize:15];
    [actionButton setImage:[UIImage imageNamed:@"ic_topbar_more.png"] forState:UIControlStateNormal];
    
    [actionButton setBackgroundImage:[[UIImage imageNamed:@"app_nav_btn_bg1.png"] stretchableImageWithLeftCapWidth:15.0 topCapHeight:15.0] forState:UIControlStateNormal];
    
    [actionButton setTitleEdgeInsets:UIEdgeInsetsMake(3, 2, 2, 2)];
    
//    [showView addSubview:actionButton];
    
     
    // 旋转的小按钮
    
//    UIImageView *laImageView = [[UIImageView alloc]initWithFrame:CGRectMake(65, 15, 16, 16)];
//    laImageView.image = [UIImage imageNamed:@"down.png"];
//
//    laImageView.tag=100;
//    
//    [showView addSubview:laImageView];
//    
//    [laImageView release];
    
//    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(changeList)];
//    
//    [showView addGestureRecognizer:tap];
//    [tap release];
    if(_listType == 0){
        self.navigationItem.rightBarButtonItem=[[[UIBarButtonItem alloc]initWithCustomView:actionButton]autorelease];

    }
    
//    [showView release];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    
    imageView.image = [[UIImage imageNamed:@"bottom-bar.png"] stretchableImageWithLeftCapWidth:2.0 topCapHeight:10.0];
    imageView.userInteractionEnabled = YES;
    UIButton *plusButton = [UIButton buttonWithType:UIButtonTypeCustom];
    plusButton.frame = CGRectMake(320-28-5, 8.0, 28.0, 28.0);
    _plusButton = plusButton;
    [plusButton addTarget:self action:@selector(plusAction:) forControlEvents:UIControlEventTouchUpInside];
    [plusButton setBackgroundImage:[UIImage imageNamed:@"btn_plus_br.png"] forState:UIControlStateNormal];
    [plusButton setImage:[UIImage imageNamed:@"btn_plus.png"] forState:UIControlStateNormal];
    [imageView addSubview:plusButton];
    
    UIButton *smileButton = [UIButton buttonWithType:UIButtonTypeCustom];
    smileButton.frame = CGRectMake(320-28-5-5-28, 8.0, 28, 28);
    _smileButton = smileButton;
    [smileButton setImage:[UIImage imageNamed:@"btn_smlie.png"] forState:UIControlStateNormal];
    [smileButton addTarget:self action:@selector(smileAction:) forControlEvents:UIControlEventTouchUpInside];
    [imageView addSubview:smileButton];
    
    UIButton *actionsButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _actionButton = actionsButton;
    actionsButton.frame = CGRectMake(3, 8, 58.0, 28);
    [actionsButton setImage:[UIImage imageNamed:@"btn_typevoice.png"] forState:UIControlStateNormal];
    [actionsButton addTarget:self action:@selector(switchVoice:) forControlEvents:UIControlEventTouchUpInside];
    [imageView addSubview:actionsButton];
    
    _inputView = [[UITextView alloc] initWithFrame:CGRectMake(_actionButton.frame.origin.x+58, 8.0,185, 28.0)];
    _inputView.delegate = self;
    _inputView.backgroundColor = [UIColor whiteColor];
    _inputView.layer.borderColor = [[UIColor grayColor] CGColor];
    _inputView.layer.borderWidth = 1.0;
    _inputView.layer.cornerRadius = 4.0;
    _inputView.textColor = [UIColor darkTextColor];
    _inputView.font = [UIFont systemFontOfSize:14];
    _inputView.returnKeyType = UIReturnKeySend;
    _inputView.enablesReturnKeyAutomatically = YES;
    [imageView addSubview:_inputView];
    [_inputView release];

     
    
    UIImageView *imageView2 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    
    imageView2.image = [[UIImage imageNamed:@"bottom-bar.png"] stretchableImageWithLeftCapWidth:2.0 topCapHeight:10.0];
    imageView2.userInteractionEnabled = YES;

    UIButton *plusButton2 = [UIButton buttonWithType:UIButtonTypeCustom];
    plusButton2.frame = CGRectMake(320-28-5, 8.0, 28.0, 28.0);
    _plusButton2 = plusButton2;
    [plusButton2 addTarget:self action:@selector(plusAction:) forControlEvents:UIControlEventTouchUpInside];
    [plusButton2 setBackgroundImage:[UIImage imageNamed:@"btn_plus_br.png"] forState:UIControlStateNormal];
    [plusButton2 setImage:[UIImage imageNamed:@"btn_plus.png"] forState:UIControlStateNormal];
    [imageView2 addSubview:plusButton2];
    
    
    
    UIButton *smileButton2 = [UIButton buttonWithType:UIButtonTypeCustom];
    smileButton2.frame = CGRectMake(320-28-5-5-28, 8.0, 28, 28);
    _smileButton2 = smileButton2;
    [smileButton2 setImage:[UIImage imageNamed:@"btn_smlie.png"] forState:UIControlStateNormal];
    [smileButton2 addTarget:self action:@selector(smileAction:) forControlEvents:UIControlEventTouchUpInside];
    [imageView2 addSubview:smileButton2];
    
    
    UIButton *actionsButton2 = [UIButton buttonWithType:UIButtonTypeCustom];
    _actionButton2 = actionsButton2;
    actionsButton2.frame = CGRectMake(3, 8, 58.0, 28);
    [actionsButton2 setImage:[UIImage imageNamed:@"btn_typevoice.png"] forState:UIControlStateNormal];
    [actionsButton2 addTarget:self action:@selector(switchVoice:) forControlEvents:UIControlEventTouchUpInside];
    [imageView2 addSubview:actionsButton2];
    
    //录音按钮
    UIButton *voiceButton = [UIButton buttonWithType:UIButtonTypeCustom];
    voiceButton.frame = CGRectMake(_actionButton2.frame.origin.x+58, 8.0,185, 28.0);
    [voiceButton setImage:[UIImage imageNamed:@"btn_voice.png"]  forState:UIControlStateNormal];

    voiceButton.layer.cornerRadius = 5;
    voiceButton.layer.masksToBounds = YES;
    [voiceButton addTarget:self action:@selector(voiceTap) forControlEvents:UIControlEventTouchUpInside];
    [imageView2 addSubview:voiceButton];
    
//    UILabel *tipLabel = [[UILabel alloc]initWithFrame:CGRectMake(35, 3, 140, 24)];
//    tipLabel.text = NSLocalizedString(@"holdtotalk", nil);
//    tipLabel.font = [UIFont systemFontOfSize:14];
//    tipLabel.textAlignment = UITextAlignmentCenter;
//    tipLabel.backgroundColor = [UIColor clearColor];
//    [voiceButton addSubview:tipLabel];
//    [tipLabel release];
    
    
    UILongPressGestureRecognizer *aLongPress = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(record:)];
    [voiceButton addGestureRecognizer:aLongPress];
    [aLongPress release];
    

       
//    UIButton *voiceButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    [voiceButton setImage:[UIImage imageNamed:@"btn_voice.png"] forState:UIControlStateNormal];
//    [voiceButton setImage:[UIImage imageNamed:@"btn_voice_press.png"] forState:UIControlStateSelected];
//    [voiceButton setImage:[UIImage imageNamed:@"btn_voice_press.png"] forState:UIControlStateHighlighted];
//    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(record:)];
//    [voiceButton addGestureRecognizer:longPress];
//    [longPress release];
//    voiceButton.frame = CGRectMake(0,0,320, 44);
    
    // 翻滚的输入框
    CFCube *cube = [[CFCube alloc] initWithFrame:CGRectMake(0, __MainScreen_Height-88,320,44)];
    _inputBar = cube;
    _inputBar.delegate = self;
    cube.visibleContentView = imageView;
    cube.hiddenContentView = imageView2;
    [imageView release];
    [imageView2 release];
    [self.view addSubview:_inputBar];
    [cube release];
    
    _buttons = [[NSMutableArray alloc] initWithCapacity:4];
    NSArray *images = [NSArray arrayWithObjects:@"btn_gallery.png",@"btn_takepic.png",@"btn_location.png",@"btn_drawpic.png",@"btn_ice.png",@"btn_gallery_press.png",@"btn_takepic_press.png",@"btn_location_press.png",@"btn_drawpic_press.png",@"btn_ice_press.png", nil];
    for(int i=0; i<5; i++)
    {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(4.0, 458, 46, 46);
        button.tag = i;
        [button setBackgroundImage:[UIImage imageNamed:@"btn_circle.png"] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:[images objectAtIndex:i]] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:[images objectAtIndex:5+i]] forState:UIControlStateHighlighted];
        [button addTarget:self action:@selector(actions:) forControlEvents:UIControlEventTouchUpInside];
        [_buttons addObject:button];
    }
    
    
    
    
    /*
    UIView *barView = [[UIView alloc] initWithFrame:CGRectMake(0, 30, 320, 34)];
    
    barView.alpha=0;
    
    images = [NSArray arrayWithObjects:@"btn_history.png",@"btn_deletemsg.png",@"btn_report.png",nil];
    float x = 0;
    for(int i=0; i<3; i++)
    {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        UIImage *image = [UIImage imageNamed:[images objectAtIndex:i]];
        button.frame = CGRectMake(x, 0,image.size.width, 34);
        button.tag = i;
        [button setImage:image forState:UIControlStateNormal];
        [button addTarget:self action:@selector(topBarButtonActions:) forControlEvents:UIControlEventTouchUpInside];
        [barView addSubview:button];
        x += image.size.width;
    }
    _topBar = barView;
     barView.hidden = YES;
    [self.navigationController.view insertSubview:_topBar atIndex:1];
    [barView release];
     */
     
    [_inputBar addObserver:self forKeyPath:@"frame" options:1 context:nil];
    [_tableView addObserver:self forKeyPath:@"contentOffset" options:1 context:nil];

    // 不一定管用

    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardShowNotify:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardShowNotify:) name:UIKeyboardWillHideNotification object:nil];
    
    
    // 这是是不是第一次进入的标志位
    if([MyAppDataManager.dialogs count]!=0)
    {
        [UserDefaults setValue:@"1" forKey:self.title];
        
    }
    // 每次加载tableview 时候出现的？？？？？？？？？？？？？？？？？
      CGFloat offset = self.tableView.contentSize.height-self.tableView.bounds.size.height;
   if(offset<1)
    offset = 0;
   [self.tableView setContentOffset:CGPointMake(0, offset)];
}

-(void)voiceTap{
    
    [TKLoadingView showTkloadingAddedTo:self.view title:NSLocalizedString(@"timeshortNoticte", nil) activityAnimated:NO duration:1.0];
    
}

//-(void)voiceAction:(UILongPressGestureRecognizer *)sender{
//    
//    
//    UIButton *button = (UIButton *)sender.view;
//    if(button.selected)
//    {
//        CGPoint point = [sender locationInView:_recordView];
//        if(sender.state == UIGestureRecognizerStateEnded)
//        {
//            button.selected = NO;
//            [_recordView touchesEndInView:point];
//            _recordView = nil;
//        }else{
//            
//            [_recordView touchesMovedInView:point];
//            
//        }
//        
//        return;
//    }
//    button.selected = YES;
//    _recordView = [[RecordView alloc]initWithFrame:CGRectMake(0, 0, 320, __MainScreen_Height+20)];
//    NSString *fileName = @"huifu.amr";
//    _recordView.audioPath = [AppComManager pathForMedia:fileName];
//    NSLog(@"%@", [AppComManager pathForMedia:fileName]);
//    _recordView.delegate = self;
//    [self.navigationController.view addSubview:_recordView];
//    [_recordView release];
//    
//    
//}


-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if( [text isEqualToString:@"\n"]){
        if(![[_inputView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] isEqualToString:@""]){
            [self sendOneMsg:[MyAppDataManager IsMinGanWord:_inputView.text] type:ChatCellTypeText filePathExtension:nil From:@"mo"];
            
            _inputView.text = @"";
            [self textViewDidChange:_inputView];
        }else{
            UIAlertView *kongAlert = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"kongAlert", nil) message:nil delegate:nil cancelButtonTitle:NSLocalizedString(@"confirmNotice", nil) otherButtonTitles: nil];
            [kongAlert show];
            [kongAlert release];
        }
        
         return NO;
    }else{
        return YES;

    }

}

-(void)changeList
{
//    BanBu_SmallListView *list=(BanBu_SmallListView *)[self.navigationController.view viewWithTag:102];
//
//    if(!list)
//    {
//        NSArray *arr=[NSArray arrayWithObjects:NSLocalizedString(@"deleteMes",nil),NSLocalizedString(@"pullBlackAndReport",nil),NSLocalizedString(@"myinfoLabel",nil),@"取消",nil];
//        
//        BanBu_SmallListView *smallList = [[BanBu_SmallListView alloc] initWithFrame:CGRectMake(0, 50, 150.0, 150) listTitles:arr];
//        smallList.tag = 102;
//        smallList.delegate = self;
//        smallList.selectedIndex=_listType;
//        [smallList showFromPoint:CGPointMake(175, 65) inView:self.navigationController.view animation:YES];
//        [smallList release];
//
//        [self rotateImageView];
//    
//    }else
//    {
//        [self rotateImageView];
//        [list dismissWithAnimation:YES];
//        return;
//   }
   
    /*
    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, __MainScreen_Width, __MainScreen_Height+40)];
    
    view.tag=9990;
    
    view.backgroundColor=[UIColor darkGrayColor];
    
    view.alpha=.6;
    
    _backView=view;
    
    [self.navigationController.view insertSubview:view aboveSubview:self.tableView];
    
    [view release];
    
    BanBu_ShareView *share=[[BanBu_ShareView alloc]initWithController:self Sel:@selector(ShareOrDelete:) Tag:2 ButtonNum:4 SelButtonName:@selector(returnArrNumber:)];
    
    _shareViewOne=share;
    
    share.frame=CGRectMake(20, 100, 280, 210);
    
    share.tag=10000;
    
    [self.navigationController.view insertSubview:share aboveSubview:view];
    
    [self.navigationController.view bringSubviewToFront:share];
    
    [share release];
    
     [_shareViewOne setHeadLabelString:[_profile valueForKey:@"pname"]];
    */
    
//    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:NSLocalizedString(@"moreTitle", nil) message:nil delegate:self cancelButtonTitle:NSLocalizedString(@"cancelNotice", nil) otherButtonTitles:NSLocalizedString(@"deleteMes", nil),NSLocalizedString(@"pullBlackAndReport",nil),NSLocalizedString(@"myinfoLabel",nil),NSLocalizedString(@"loadMoreButton",nil), nil];
//    
//    alert.tag=10101;
//    
//    [alert show];
//    
//    [alert release];
    
    UIActionSheet *aSheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:NSLocalizedString(@"cancelNotice", nil) destructiveButtonTitle:nil otherButtonTitles:NSLocalizedString(@"myinfoLabel",nil),NSLocalizedString(@"seeMoreMessage",nil),NSLocalizedString(@"deleteMes", nil), nil];
    aSheet.tag = 10101;
    [aSheet showInView:self.view.window];
    [aSheet release];
    
    
    
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{

 
}

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{

  
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if(self.tableView.contentInset.top != 0)
        [self.tableView setContentInset:UIEdgeInsetsMake(0, 0, 0, 0)];
    
    }

// 旋转小箭头
-(void)rotateImageView
{
    UIImageView *la=(UIImageView *)[self.navigationController.view viewWithTag:100];

    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3];
    CGAffineTransform transform = CGAffineTransformRotate(la.transform, -M_PI);
    la.transform = transform;
    [UIView commitAnimations];

}

-(void)smallListView:(BanBu_SmallListView *)smallListView didSelectIndex:(NSInteger)index
{
    
    BanBu_SmallListView *list=(BanBu_SmallListView *)[self.navigationController.view viewWithTag:102];
    
    [list dismissWithAnimation:YES];
        
   if(index==0)
   {
       //上面
       [MyAppDataManager removeTableNamed:[MyAppDataManager getTableNameForUid:VALUE(KeyFromUid, _profile)]];
       
       [MyAppDataManager.dialogs removeAllObjects];
       
       [MyAppDataManager.readArr removeAllObjects];
       
       [MyAppDataManager.talkArr removeAllObjects];
       
       [UserDefaults setValue:MyAppDataManager.readArr forKey:@"read"];
       
       [self.tableView reloadData];
       
     
  }
   if(index==1)
   {
       [MyAppDataManager setMessagetype:MessageTypeStand];
      
   }
   if(index==2)
   {       
       [self seeProfile:nil];
       
       [MyAppDataManager setMessagetype:MessageTypeStand];
       
   }
    
    
   if(_listType==index)
   {
       return;
   }
    
    _listType=index;

}




// 导入到head 的内部



//点击 推出下一个页面 点击head 那么推出下一个页面
-(void)pushself
{
//    BanBu_MyProfileViewController *myProfile = [[BanBu_MyProfileViewController alloc] init];
//    myProfile.editing = NO;
//    myProfile.hidesBottomBarWhenPushed = YES;
//    [self.navigationController pushViewController:myProfile animated:YES];
//    [myProfile release];
//    [AppComManager getBanBuData:BanBu_Get_My_Facelist par:parDic delegate:self];
    BanBu_PeopleProfileController *peopleFfofile = [[BanBu_PeopleProfileController alloc] initWithProfile:[UserDefaults valueForKey:MyAppDataManager.useruid]  displayType:DisplayTypePeopleProfile];
    peopleFfofile.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:peopleFfofile animated:YES];
    [peopleFfofile release];
}
-(void)pushnext
{
    BanBu_PeopleProfileController *profile = nil;
    for(UIViewController *vc in [self.navigationController viewControllers])
        if([vc isKindOfClass:[BanBu_PeopleProfileController class]])
        {
            profile = (BanBu_PeopleProfileController *)vc;
            break;
        }
    if(profile)
    {
        [self.navigationController popToViewController:profile animated:YES];
    }
    else
    {
        NSDictionary *proDic = [NSDictionary dictionaryWithDictionary:_profile];
        
        profile = [[BanBu_PeopleProfileController alloc] initWithProfile:proDic displayType:DisplayTypePeopleProfile];
        NSLog(@"----看的这个人资料%@",proDic);

        [self.navigationController pushViewController:profile animated:YES];
        [profile release];
    }

    

}
- (void)seeProfile:(UIButton *)button
{
    BanBu_PeopleProfileController *profile = nil;
    for(UIViewController *vc in [self.navigationController viewControllers])
        if([vc isKindOfClass:[BanBu_PeopleProfileController class]])
        {
            profile = (BanBu_PeopleProfileController *)vc;
            break;
        }
    if(profile)
    {
        [self.navigationController popToViewController:profile animated:YES];
    }
    else
    {
        
        NSDictionary *proDic = [NSDictionary dictionaryWithDictionary:_profile];
        
        profile = [[BanBu_PeopleProfileController alloc] initWithProfile:proDic displayType:DisplayTypePeopleProfile];

        [self.navigationController pushViewController:profile animated:YES];
        [profile release];
    }
        
}


- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{

    CGRect rect = [[change objectForKey:@"new"] CGRectValue];
        
    if([keyPath isEqualToString:@"contentOffset"])
    {
        return;
    }
   
    [self tableViewAutoOffset];
    
    if(rect.origin.y == __MainScreen_Height-88)
    {
      [_actionButton setImage:_actionButton.selected?[UIImage imageNamed:@"btn_voicekey.png"]:[UIImage imageNamed:@"btn_typevoice.png"] forState:UIControlStateNormal];
        CGRect frame = _inputView.frame;
        frame.size.height = InputViewDefaultHeight;
        if(_inputView.frame.size.height == frame.size.height)
            return;
        _inputView.frame = frame;
        frame = _inputBar.visibleContentView.frame;
        frame.origin.y = 0;
        frame.size.height = 44;
        _inputBar.visibleContentView.frame = frame; 
        
        CGRect rect = _plusButton.frame;
        rect.origin.y = 8.0;
        _plusButton.frame = rect;
        rect = _smileButton.frame;
        rect.origin.y = 8.0;
        _smileButton.frame = rect;
        rect = _actionButton.frame;
        rect.origin.y = 8.0;
        _actionButton.frame = rect;
        
    }
//    NSLog(@"%f",rect.origin.y);
    if(rect.origin.y < __MainScreen_Height-88)
    {
//        [_actionButton setImage:[UIImage imageNamed:@"btn_send.png"] forState:UIControlStateNormal];

        BanBu_MaskView *maskView = (BanBu_MaskView *)[self.view viewWithTag:MaskViewTag];
        if(maskView == nil)
        {
            maskView = [[BanBu_MaskView alloc] initWithFrame:self.view.bounds];
            maskView.tag = MaskViewTag;
            maskView.delegate = self;
            [maskView setDidTouchedSelector:@selector(tapped:)];
            [self.view addSubview:maskView];
            [self.view bringSubviewToFront:_inputBar];
            [self.view bringSubviewToFront:_smileView];
            
            [maskView release];
        }
        else
            maskView.hidden = NO;
    }
}
-(void)setList:(ListTypey)listType
{
    if(_listType==listType)
        return;
    
    _listType=listType;

}
- (void)plusAction:(UIButton *)button
{
//    _showMenu = !_showMenu;
    if(_inputBar.isUP){
        [self performSelector:@selector(switchVoice:) withObject:_actionButton];
    }
 //    NSLog(@"%d",button.selected);
//       if(!button.selected)
//       {
//        if(_smileView)
//        {
//             [self performSelector:@selector(textViewDidChange:) withObject:_inputView];
//
//            [_inputView becomeFirstResponder];
//            return;
//        }
    
               
//    }
    
    if(!_smileView)
    {
        
        _smileView = [[BanBu_SmileView alloc] initWithFrame:CGRectMake(0, __MainScreen_Height-44, 320, SmileViewDefaultHeight)];
        _smileView.type = SmileViewAddType;
        _smileView.delegate = self;
        [self.view addSubview:_smileView];
        [_smileView release];
        [_smileView.pageControl setFrame:CGRectMake(0, 190, 320, 10)];
        
        [_actionButton setImage:[UIImage imageNamed:@"btn_typevoice.png"] forState:UIControlStateNormal];
        isSmileView = NO;
        
        
        if([_inputView isFirstResponder])
            [_inputView resignFirstResponder];
        
    }
    else
    {
//        NSLog(@"222222222222");
//        [_smileView removeFromSuperview];
//        _smileView = [[BanBu_SmileView alloc] initWithFrame:CGRectMake(0, __MainScreen_Height-44, 320, SmileViewDefaultHeight)];
//        [_smileView.pageControl setFrame:CGRectMake(0, 190, 320, 10)];
//
//        _smileView.type = SmileViewAddType;
//        _smileView.delegate = self;
//        [self.view addSubview:_smileView];
//        [_smileView release];
//        
//        [_actionButton setImage:[UIImage imageNamed:@"btn_typevoice.png"] forState:UIControlStateNormal];
//        isSmileView = NO;
//        
//        if([_inputView isFirstResponder])
//            [_inputView resignFirstResponder];
        [self performSelector:@selector(textViewDidChange:) withObject:_inputView];
        
        [_inputView becomeFirstResponder];

    }
     [UIView animateWithDuration:.5
                     animations:^{
                         _smileView.frame = CGRectMake(0, __MainScreen_Height-260, 320, SmileViewDefaultHeight);
                         _inputBar.frame = CGRectMake(0, _smileView.frame.origin.y-44.0, 320, 44);
                     }
                     completion:^(BOOL finished) {
                         //                         [self performSelector:@selector(textViewDidChange:) withObject:_inputView];
                         
                     }];

    
  
}

- (void)smileAction:(UIButton *)button
{
//    _showSmile=!_showSmile;
    if(_inputBar.isUP){
        [self performSelector:@selector(switchVoice:) withObject:_actionButton];

    }
    [_actionButton setImage:[UIImage imageNamed:@"btn_typevoice.png"] forState:UIControlStateNormal];
    isSmileView = NO;
    button.selected = !button.selected;

    [button setImage:button.selected?[UIImage imageNamed:@"btn_keyboard.png"]:[UIImage imageNamed:@"btn_smlie.png"] forState:UIControlStateNormal];

    
//    if(!button.selected)
//    {
//        if(_smileView)
//        {
//        [_inputView becomeFirstResponder];
//         [self performSelector:@selector(textViewDidChange:) withObject:_inputView];
//        return;
//        }
//    }
    
    if(!_smileView)
    {
        _smileView = [[BanBu_SmileView alloc] initWithFrame:CGRectMake(0, __MainScreen_Height-44, 320, SmileViewDefaultHeight)];
        [_smileView.pageControl setFrame:CGRectMake(0, 164, 320, 10)];

        _smileView.type = SmileViewSmileType;
        _smileView.delegate = self;
        [self.view addSubview:_smileView];
        [_smileView release];
        
        if([_inputView isFirstResponder])
            [_inputView resignFirstResponder];
    }else
    {
//        [_smileView removeFromSuperview];
//        _smileView = [[BanBu_SmileView alloc] initWithFrame:CGRectMake(0, __MainScreen_Height-44, 320, SmileViewDefaultHeight)];
//        [_smileView.pageControl setFrame:CGRectMake(0, 164, 320, 10)];
//        _smileView.type = SmileViewSmileType;
//        _smileView.delegate = self;
//        [self.view addSubview:_smileView];
//        [_smileView release];
//        if([_inputView isFirstResponder])
//            [_inputView resignFirstResponder];
    
        [_inputView becomeFirstResponder];
        [self performSelector:@selector(textViewDidChange:) withObject:_inputView];

    }
    
    [UIView animateWithDuration:.5
                     animations:^{
                         _smileView.frame = CGRectMake(0, __MainScreen_Height-260, 320, SmileViewDefaultHeight);
                         _inputBar.frame = CGRectMake(0, _smileView.frame.origin.y-44.0, 320, 44);
                     }
     completion:^(BOOL finished) {
//         [self performSelector:@selector(textViewDidChange:) withObject:_inputView];

     }];
    

}

//-(BOOL) respondsToSelector:(SEL)aSelector {
//    printf("SELECTOR: %s\n", [NSStringFromSelector(aSelector) UTF8String]);
//    return [super respondsToSelector:aSelector];
//}
/*???????????????????????????????????????????????????????*/
- (void)switchVoice:(UIButton *)button
{
       //88-120
    [UIView animateWithDuration:.3
                     animations:^{
                         _smileView.frame = CGRectMake(0,__MainScreen_Height, 320, 0);
                         _inputBar.frame = CGRectMake(0, __MainScreen_Height-88, 320, 44);
                     }
        ];
    
    
//    if([_inputView isFirstResponder]||isSmileView)
//    {
//        [self sendOneMsg:[MyAppDataManager IsMinGanWord:_inputView.text] type:ChatCellTypeText filePathExtension:nil From:@"mo"];
//        
//        _inputView.text = nil;
//        
//        [self tableViewAutoOffset];
//        
//        [UIView animateWithDuration:.0
//                         animations:^{
//                             _smileView.frame = CGRectMake(0,__MainScreen_Height-44-216, 320, 216);
//                             _inputBar.frame = CGRectMake(0, __MainScreen_Height-88, 320, 44);
//                         }
//         ];
//        _smileView.frame = CGRectMake(0,__MainScreen_Height-44-216, 320, 216);
//        _inputBar.frame = CGRectMake(0, __MainScreen_Height-88, 320, 44);
//        if(isSmileView)
//        {
//            [UIView animateWithDuration:0.3 animations:^{_smileView.frame = CGRectMake(0, __MainScreen_Height, 320, 216);}];
//            _smileButton.selected = NO;
//            [_smileButton setImage:[UIImage imageNamed:@"btn_smlie.png"] forState:UIControlStateNormal];
//        }
//        isSmileView = NO;
//        [_inputView resignFirstResponder];
//        
//        return;
//    }
    if(button.selected){
        [_inputView becomeFirstResponder];
    }else{
        [_inputView resignFirstResponder];
    }
    button.selected = !button.selected;
    [button setImage:button.selected?[UIImage imageNamed:@"btn_voicekey.png"]:[UIImage imageNamed:@"btn_typevoice.png"] forState:UIControlStateNormal];
   
    button.enabled = NO;
//    [_inputBar.hiddenContentView addSubview:_plusButton];
    [_inputBar.hiddenContentView addSubview:button];
    if(button.selected)
    {
        [_inputBar flipWithStyle:CFCubeFLipDown];
    }
    else 
    {
        [_inputBar flipWithStyle:CFCubeFlipUp];
    }
}

#pragma CFCube delegate method

- (void)cfCubeFlipDidStop:(CFCube *)cfCube
{
    _actionButton.enabled = YES;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    MyAppDataManager.isSend=YES;
//    NSLog(@"%@",MyAppDataManager.chatuid);
//    [AppComManager receiveMsgFromUser:MyAppDataManager.chatuid delegate:MyAppDelegate];

}
/**************** end *************/


- (UIBarButtonItem*)createBackButton {
    
    UIButton *btn_return=[UIButton buttonWithType:UIButtonTypeCustom];
    
    [btn_return addTarget:self action:@selector(popself) forControlEvents:UIControlEventTouchUpInside];
    
    [btn_return setBackgroundImage:[[UIImage imageNamed:@"app_nav_back_bg1.png"] stretchableImageWithLeftCapWidth:15.0 topCapHeight:15.0] forState:UIControlStateNormal];
    [btn_return setBackgroundImage:[[UIImage imageNamed:@"app_nav_back_bg2.png"] stretchableImageWithLeftCapWidth:15.0 topCapHeight:15.0] forState:UIControlStateHighlighted];
    CGFloat btnLen = [NSLocalizedString(@"returnButton", nil) sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(100, 30)].width;
    //    NSLog(@"%f",btnLen);
    btn_return.frame=CGRectMake(0, 0, btnLen+20, 30);
    [btn_return setTitleEdgeInsets:UIEdgeInsetsMake(3, 9, 2, 2)];
    [btn_return setTitle:NSLocalizedString(@"returnButton", nil) forState:UIControlStateNormal];
    btn_return.titleLabel.font = [UIFont systemFontOfSize:14];
    UIBarButtonItem *bar_itemreturn=[[[UIBarButtonItem alloc] initWithCustomView:btn_return] autorelease];
    
    return bar_itemreturn;
    
}

-(void)popself{
    
    [AppComManager stopReceiveMsgForUid:MyAppDataManager.chatuid];
    MyAppDataManager.chatuid = nil;

    [AppComManager startReceiveMsgFromUid:nil forDelegate:MyAppDataManager];
    [self.navigationController popToRootViewControllerAnimated:YES];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [AppComManager cancalHandlesForObject:self];
    //+++++++++++
        if([MyAppDataManager.dialogs count]==0)
    {
        
        //[UserDefaults removeObjectForKey:self.title];
        
    }
    
    if([_inputView isFirstResponder])
        [_inputView resignFirstResponder];
  

}
// actionView 的代理方法

-(void)banBu_ActionView:(BanBu_SmileView *)actionView didInputBrand:(UIButton *)actionBrand isAdd:(BOOL)add
{
//   if(add==YES)
//   {
//   
//   
//   }else
//   {
    
       
       UIButton *t=(UIButton *)[self.view viewWithTag:actionBrand.tag];
       
       
       [self actions:t];
   
//   }
    
}


- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

    self.tabBarController.tabBar.frame=CGRectMake(-320, 431, 320, 49);
    
    if(![UserDefaults valueForKey:self.title])
    {
        
        _firstHere = NO;
        BanBu_NoticeView1 *notice = [[BanBu_NoticeView1 alloc] initWithFrame:self.navigationController.view.bounds];
        CATransition *animation = [CATransition animation];
        animation.duration = .5f;
        animation.timingFunction=UIViewAnimationCurveEaseInOut;
        animation.fillMode = kCAFillModeForwards;
        animation.type = kCATransitionReveal;
        animation.subtype = kCATransitionFade;
        
        [self.view.window.layer addAnimation:animation forKey:@"animation"];
        [self.navigationController.view addSubview:notice];
        [notice release];

        [UserDefaults setValue:@"1" forKey:self.title];
        
    }
    /******************************************************* i dont know ?????????????????????*/
//    CGFloat offset = self.tableView.contentSize.height-self.tableView.bounds.size.height;
//    if(offset<1)
//        offset = 0;
//    [self.tableView setContentOffset:CGPointMake(0, offset)];
    
   [AppComManager startReceiveMsgFromUid:MyAppDataManager.chatuid forDelegate:MyAppDataManager];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
    self.tableView = nil;
   
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    return MyAppDataManager.dialogs.count;

}

- (float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *amsg = [MyAppDataManager.dialogs objectAtIndex:indexPath.row];
//    NSLog(@"%f",[VALUE(KeyHeight, amsg) floatValue]);
    return [VALUE(KeyHeight, amsg) floatValue];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    BanBu_ChatCell *cell = (BanBu_ChatCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell == nil)
    {
        cell = [[[BanBu_ChatCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    NSDictionary *amsg;
    if([MyAppDataManager.dialogs count]!=0)
    {
    amsg = [MyAppDataManager.dialogs objectAtIndex:indexPath.row];
        
    }else
    {
        amsg=nil;
    }
//    NSLog(@"%@",amsg);
    BOOL me = [VALUE(KeyMe,amsg) boolValue];
    
    cell.showTime = [VALUE(KeyShowtime, amsg) boolValue];
    
    cell.atLeft = !me;
//    NSLog(@"%@",[[UserDefaults valueForKey:MyAppDataManager.useruid] valueForKey:@"uface"]);
//    NSLog(@"%@",[[[UserDefaults valueForKey:MyAppDataManager.useruid] valueForKey:@"uface"] valueForKey:@"facefile"]);
    if(cell.atLeft)
        [cell setAvatarImage:VALUE(KeyUface, amsg)];
    else
        [cell setAvatarImage:[[UserDefaults valueForKey:MyAppDataManager.useruid] valueForKey:@"uface"]];//    [cell setAvatarImage:];
    
    cell.type = [VALUE(KeyType, amsg) integerValue];
        
    cell.status = [VALUE(KeyStatus, amsg) integerValue];
    
    cell.from=VALUE(KeyShowFrom, amsg);
    
    cell.showFrom=![VALUE(KeyShowFrom, amsg) isEqual:@"mo"];

    cell.delegate=self;
    
    // string
//    cell.showTime = NO;
    if(cell.showTime)
    {
       
        
      cell.timeLabel.text=[[amsg valueForKey:KeyStime] substringWithRange:NSMakeRange(5, [[amsg valueForKey:KeyStime]length]-5-3)];
    
        cell.demeterLabel.text=[MyAppDataManager IsInternationalLanguage:[_profile valueForKey:KeyDmeter]];
  

    }
    

    if(cell.type == ChatCellTypeText)
    {
        
//        NSLog(@"%@",[amsg valueForKey:KeyContent]);
       
        [cell setSmileLabelText:[amsg valueForKey:KeyContent]];
        
    }
    else if(cell.type == ChatCellTypeLocation)
    {
        cell.delegate=self;
        // point
        NSArray *firstWords = [[amsg valueForKey:KeyContent] componentsSeparatedByString:@","];

        if(firstWords.count>1)
        {
            CLLocationDegrees lat = [[firstWords objectAtIndex:1]floatValue]/1000000;
            CLLocationDegrees lon = [[firstWords objectAtIndex:0] floatValue]/1000000;
            
            if([_latiArr count]!=0)
            {
                [_latiArr removeAllObjects];
            }
            
            [_latiArr addObjectsFromArray:firstWords];
            
            [cell setLocationLat:lat andLong:lon];
        }
       
    }else if (cell.type==ChatCellTypeEmi)
    {
     [cell setEmi:[amsg valueForKey:KeyContent]];    
  
    }
    else
    {
        // 一个判断 判断他不是image类型的
        if(cell.type!=ChatCellTypeVoice){
        
        MediaStatus status = [VALUE(KeyMediaStatus, amsg) integerValue];
        NSString *content = VALUE(KeyContent, amsg);
        [cell.mediaView setStatus:status];
        [cell.mediaView setMedia:content];
       
        cell.mediaView.appChatController=self;
        cell.mediaView.delegate=self;
        
        if(status == MediaStatusDownload)
        {
             
         [AppComManager getBanBuMedia:content forMsgID:[VALUE(KeyID, amsg) integerValue] fromUid:MyAppDataManager.chatuid delegate:MyAppDataManager];
        }
       }else
       {
           
           // 声音的入口
    
           MediaStatus status = [VALUE(KeyMediaStatus, amsg) integerValue];
           NSString *content = VALUE(KeyContent, amsg);
           [cell.voiceView setStatus:status];
           [cell.voiceView setMedia:content];
           // 根据content 判断有没有这么一个语音片段 如果有 那么算出长度来
           // 或者把 前面已经取到的时间 存入数据库 留给你了
           
           cell.voiceView.isLeft=!me;
           
           NSData *data=[NSData dataWithContentsOfFile:[AppComManager pathForMedia:content]];
           
           
           
           if(data)
           {
               AVAudioPlayer *player=[[AVAudioPlayer alloc]initWithData:data error:nil];
           
               [cell setVoiceViewLong:player.duration];
               [player release];
               
           }
           
           cell.voiceView.appChatController=self;
           
           cell.voiceView.tag=indexPath.row;
           
           if(status == MediaStatusDownload)
           {
               [AppComManager getBanBuMedia:content forMsgID:[VALUE(KeyID, amsg) integerValue] fromUid:MyAppDataManager.chatuid delegate:MyAppDataManager];
           }

       }
    
    }
    if(cell.atLeft == YES && ![MyAppDataManager.chatuid isEqualToString:@"400"])
    {
         
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pushnext)];
        cell.avatar.userInteractionEnabled = YES;
        tap.numberOfTapsRequired = 1;
        [cell.avatar addGestureRecognizer:tap];
        [tap release];
    }
    if(cell.atLeft == NO)
    {
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pushself)];
        cell.avatar.userInteractionEnabled = YES;
        tap.numberOfTapsRequired = 1;
        [cell.avatar addGestureRecognizer:tap];
        [tap release];
    }
    return cell;
}


#pragma mark - Table view delegate


-(BOOL)stopLastVoiceView:(int)row
{
    BanBu_ChatCell *cell = (BanBu_ChatCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:0]];
    [cell.voiceView stopPlaying:nil];
    cell.voiceView.isPlay=NO;
    return YES;
}

//对讲机模式

-(void)RunLoopMusic:(NSMutableArray *)row Url:(NSMutableArray *)url
{
    BanBu_ChatCell *cell = (BanBu_ChatCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:[[url objectAtIndex:0] intValue]  inSection:0]];
    
    [cell.mediaView continueToBroad];
    

}
-(void)MakeBigMap
{
    CLLocationDegrees lat = [[_latiArr objectAtIndex:1]doubleValue]/1000000;
    CLLocationDegrees lon = [[_latiArr objectAtIndex:0] doubleValue]/1000000;

    BanBu_MakeBigMapViewController *BigMap=[[BanBu_MakeBigMapViewController alloc]initWithCGPoint:lat andLon:lon];
//     [BigMap setLocationLat:(lat) long:lon];
    
    [self.navigationController pushViewController:BigMap animated:YES];
    
    [BigMap release];

}
//- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
//{
//    if(scrollView.contentOffset.y < 0)
//    {
//      //  [self showTopBar];
//        
//    }
//    
//}



- (void)keyboardShowNotify:(NSNotification *)notification
{
    //216   252
    CGFloat keyboardHeight = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
    if([notification.name isEqualToString:UIKeyboardWillHideNotification])
    {
        if(_smileView)
            keyboardHeight = 216;
        else 
            keyboardHeight = 0;
    }
    [UIView animateWithDuration:0.3
                     animations:^{
                         CGRect rect = _inputBar.frame;
                         rect.origin.y = __MainScreen_Height-88 - keyboardHeight;
                         _inputBar.frame = rect;
                     }
                     completion:^(BOOL finished) {
                         ;                     }
     ];
    
}

#pragma BanBu_SmileView Delegate

- (void)banBu_SmileView:(BanBu_SmileView *)smileView didInputSmile:(NSString *)inputString isDelete:(BOOL)del type:(int)smile
{

    
    if(del)
    {
        if([_inputView hasText])
        {
            if(smileView.inputedStr.count)
            {
                NSInteger deleteLength = [[smileView.inputedStr lastObject] length];
                _inputView.text = [_inputView.text stringByReplacingCharactersInRange:NSMakeRange(_inputView.text.length-deleteLength,deleteLength) withString:@""];
                [smileView.inputedStr removeLastObject];
            }
            else 
                _inputView.text = [_inputView.text substringToIndex:_inputView.text.length-1];
            
        }
   
    
    
    }
    else{
        
        if(smile==0)
        {
        _inputView.text = [_inputView.text stringByAppendingString:inputString];
    
        [self performSelector:@selector(textViewDidChange:) withObject:_inputView];
       
        [_inputView scrollRectToVisible:CGRectMake(0, _inputView.contentSize.height-10, _inputView.contentSize.width, 6) animated:YES];
   
    }else
    {
    
    
        [self sendOneMsg:inputString type:ChatCellTypeEmi filePathExtension:@"emo" From:@"mo"];
        
        
    }

        
    }
}


#pragma mark UITextView delegate

- (void)textViewDidBeginEditing:(UITextView *)textView
{
//     [_actionButton setImage:[UIImage imageNamed:@"btn_send.png"] forState:UIControlStateNormal];
    if(_smileView)
    {
        [UIView animateWithDuration:0.5
                         animations:^{
                             _smileView.frame = CGRectMake(0, __MainScreen_Height, 320, 216);
                             
                         } completion:^(BOOL finished) {
                             
                             [_smileView removeFromSuperview];
                             _smileView = nil;
                         }];
    }

    if(_smileButton.selected)
    {
        _smileButton.selected = NO;
        [_smileButton setImage:[UIImage imageNamed:@"btn_smlie.png"] forState:UIControlStateNormal];
    }
    if(textView.text.length)
        [self performSelector:@selector(textViewDidChange:) withObject:textView];
}



- (void)textViewDidChange:(UITextView *)textView
{
    float overPass = textView.contentSize.height - InputViewDefaultHeight;
    if(overPass > 60)
        return;
    if(overPass < 7)
        overPass = 0;
    if(textView.frame.size.height == (overPass+InputViewDefaultHeight))
        return;
    {
        [UIView animateWithDuration:0.5
                         animations:^{
                             
                             CGRect frame = textView.frame;
                             frame.size.height = overPass+InputViewDefaultHeight;
                             if(textView.frame.size.height == frame.size.height)
                                 return;
                             textView.frame = frame; 
                             
                             frame = _inputBar.visibleContentView.frame;
                             frame.origin.y = 0 - overPass;
                             frame.size.height = 44 + overPass;
                             _inputBar.visibleContentView.frame = frame;
                             
                             CGRect rect = _plusButton.frame;
                             rect.origin.y = frame.size.height - 36;
                             _plusButton.frame = rect;
                             rect = _smileButton.frame;
                             rect.origin.y = frame.size.height - 36;
                             _smileButton.frame = rect;
                             rect = _actionButton.frame;
                             rect.origin.y = frame.size.height - 36;
                             _actionButton.frame = rect;


                         }
         completion:^(BOOL finished) {
             [textView scrollRangeToVisible:NSMakeRange(textView.text.length-20, 10)];
             [self tableViewAutoOffset];
             }];
    }
    
}


-(void)textViewDidEndEditing:(UITextView *)textView
{


}



- (void)tapped:(BanBu_MaskView *)maskView
{

    maskView.hidden = YES;
      
    if(_smileView)
    {
        [UIView animateWithDuration:0.5
                         animations:^{
                             _smileView.frame = CGRectMake(0,__MainScreen_Height-44, 320, 216);
                             _inputBar.frame = CGRectMake(0, __MainScreen_Height-88, 320, 44);
                             
                         } completion:^(BOOL finished) {
                             
                             [_smileView removeFromSuperview];
                             _smileView = nil;
                            
                             if(_smileButton.selected)
                             {
                                 _smileButton.selected = NO;
                                 [_smileButton setImage:[UIImage imageNamed:@"btn_smlie.png"] forState:UIControlStateNormal];
                             }

                         }];
    }
    
    [_inputView resignFirstResponder];
    [self.tableView setContentInset:UIEdgeInsetsMake(0, 0, 0, 0)];
    
}

-(void)menuShow:(UIView *)sender tableCell:(BanBu_ChatCell *)sendert
{
    [self.view becomeFirstResponder];

    if((sendert.statuss==0||sendert.statuss==2)&&sendert.atLeft==NO)
    {
        /*
        UIMenuItem *share1 = [[UIMenuItem alloc] initWithTitle:NSLocalizedString(@"forward", nil) action:@selector(share1:)];
        UIMenuItem *reconnect2 = [[UIMenuItem alloc] initWithTitle:NSLocalizedString(@"retransmission", nil) action:@selector(reconnect1:)];
        UIMenuItem *delete3 = [[UIMenuItem alloc] initWithTitle:NSLocalizedString(@"deleteButton", nil) action:@selector(delete1:)];
        itemArr=[NSArray arrayWithObjects:share1, reconnect2,delete3,nil];
        
        [share1 release];
        
        [reconnect2 release];
        
        [delete3 release];
  */
        
   // 分享的页面
        
        
        /*
            UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, __MainScreen_Width, __MainScreen_Height+40)];
            
            view.tag=9999;
        
           _backView=view;
            view.backgroundColor=[UIColor darkGrayColor];
        
            view.alpha=.6;
        
         [self.navigationController.view insertSubview:view aboveSubview:self.tableView];
        
            [view release];

        BanBu_ShareView *share=[[BanBu_ShareView alloc]initWithController:self Sel:@selector(ShareOrDelete:) Tag:1 ButtonNum:3 SelButtonName:@selector(returnArrNumber:)];
        
             _shareViewOne=share;
         
            share.frame=CGRectMake(20, 130, 280, 170);
    
            share.tag=10000;
            
        [self.navigationController.view insertSubview:share aboveSubview:view];
        
        [self.navigationController.view bringSubviewToFront:share];
        
            [share release];
        */

        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:nil message:nil delegate:self cancelButtonTitle:NSLocalizedString(@"cancelNotice", nil) otherButtonTitles:NSLocalizedString(@"deleteButton", nil),NSLocalizedString(@"resend", nil), nil];
        
        alert.tag=12345;
        
        [alert show];
        
        [alert release];
        
        
        
        
                
    }else
    {
        /*if([self.view viewWithTag:9999])
        {
            [[self.view viewWithTag:9999] removeFromSuperview];
        }
        if([self.view  viewWithTag:10000])
        {
            [[self.view  viewWithTag:10000] removeFromSuperview];
            
        }

        UIMenuItem *share1 = [[UIMenuItem alloc] initWithTitle:NSLocalizedString(@"forward", nil) action:@selector(share1:)];
        UIMenuItem *delete3 = [[UIMenuItem alloc] initWithTitle:NSLocalizedString(@"deleteButton", nil) action:@selector(delete1:)];
        itemArr=[NSArray arrayWithObjects:share1, delete3,nil];
        
        [share1 release];
        
        [delete3 release];
    
        */
        /*
        UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, __MainScreen_Width, __MainScreen_Height+40)];
        
        view.tag=9999;
        
        view.backgroundColor=[UIColor darkGrayColor];
        
        view.alpha=.6;
        
        _backView=view;
        
        [self.navigationController.view insertSubview:view aboveSubview:self.tableView];
        
        [view release];
        
        BanBu_ShareView *share=[[BanBu_ShareView alloc]initWithController:self Sel:@selector(ShareOrDelete:) Tag:0 ButtonNum:2 SelButtonName:@selector(returnArrNumber:)];
        
        _shareViewOne=share;
        
        share.frame=CGRectMake(20, 150, 280, 130);
        
        share.tag=10000;
        
        [self.navigationController.view insertSubview:share aboveSubview:view];
        
        [self.navigationController.view bringSubviewToFront:share];
        
        [share release];
    */

//        UIAlertView *alertT=[[UIAlertView alloc]initWithTitle:NSLocalizedString(@"confirmDelete", nil) message:nil delegate:self cancelButtonTitle:NSLocalizedString(@"cancelNotice", nil) otherButtonTitles:NSLocalizedString(@"deleteButton", nil),NSLocalizedString(@"copyButton", nil),NSLocalizedString(@"shareButton", nil), nil];
        
        
 
//        UILabel *aLabel = (UILabel *)[sendert viewWithTag:101];
//        NSLog(@"%@",aLabel.text);
//        BanBu_VoiceView *aVoice = (BanBu_VoiceView *)[sendert viewWithTag:102];
//        NSLog(@"%@",aVoice.mediaPath);
        
        UIAlertView *alertT;
        
        
        if(sendert.type == ChatCellTypeLocation || sendert.type == ChatCellTypeEmi){
//            alertT=[[UIAlertView alloc]initWithTitle:NSLocalizedString(@"confirmDelete", nil) message:nil delegate:self cancelButtonTitle:NSLocalizedString(@"cancelNotice", nil) otherButtonTitles:NSLocalizedString(@"deleteButton", nil), nil];
            alertT=[[UIAlertView alloc]initWithTitle:nil message:nil delegate:self cancelButtonTitle:NSLocalizedString(@"cancelNotice", nil) otherButtonTitles:NSLocalizedString(@"deleteButton", nil), nil];


        }else{
            alertT=[[UIAlertView alloc]initWithTitle:nil message:nil delegate:self cancelButtonTitle:NSLocalizedString(@"cancelNotice", nil) otherButtonTitles:NSLocalizedString(@"deleteButton", nil),NSLocalizedString(@"copyButton", nil),NSLocalizedString(@"shareButton", nil), nil];



        }
        
        [alertT show];
        
        alertT.tag=66;
        
        [alertT release];
        
         
        
        
        
        
        
    }

//    [_shareViewOne setHeadLabelString:[_profile valueForKey:@"pname"]];
    
//     UIMenuController * menu = [UIMenuController sharedMenuController];
//    [menu setMenuItems:itemArr];
//    
//    [menu setArrowDirection:UIMenuControllerArrowDown];
//    [menu setTargetRect:CGRectMake(0, 5, 30, 60) inView:sender];
//    [menu setMenuVisible: YES animated: YES];
    

    NSIndexPath *indexpath =[self.tableView indexPathForCell:sendert];

   _rowt =indexpath.row;
    
    _type=(int)sendert.type;
    
    _fromPbTu = [NSString stringWithString:sendert.from];


}

//判断是不是share 还是 delete

-(void)ShareOrDelete:(id)number
{
    if(_shareViewOne)
    {
        [_shareViewOne removeFromSuperview];
    }
    if(_backView)
    {
        //[[self.navigationController.view viewWithTag:9999] removeFromSuperview];
        [_backView removeFromSuperview];
        
    }

           
     if ([number intValue]==0||[number intValue]==100)
    {
      
        [self delete1:nil];
    
    }else if([number intValue]==1)
    {
        [self reconnect1:nil];
    
    }else if([number intValue]==3||[number intValue]==102)
    {
              
    }else if ([number intValue]==200)
    {
    
        [MyAppDataManager removeTableNamed:[MyAppDataManager getTableNameForUid:VALUE(KeyFromUid, _profile)]];
        
        [MyAppDataManager.dialogs removeAllObjects];
        
        [MyAppDataManager.readArr removeAllObjects];
        
        [MyAppDataManager.talkArr removeAllObjects];
        
        [UserDefaults setValue:MyAppDataManager.readArr forKey:@"read"];
        
        [self.tableView reloadData];

    
    }else if ([number intValue]==202)
    {
    
    
     [self seeProfile:nil];
     
    }
    
}

-(NSMutableArray *)returnArrNumber:(NSString *)t
{    
  
    if([t isEqual:@"3"])
    {
        return [[[NSMutableArray alloc]initWithObjects:NSLocalizedString(@"deleteButton", nil),NSLocalizedString(@"resend", nil),NSLocalizedString(@"cancelNotice", nil),nil]autorelease];
        
    }else if([t isEqual:@"2"])
    {
        
        return [[[NSMutableArray alloc]initWithObjects:NSLocalizedString(@"deleteButton", nil),NSLocalizedString(@"cancelNotice", nil),nil]autorelease];
        
    }else
    {
    
      return [NSArray arrayWithObjects:NSLocalizedString(@"deleteMes",nil),NSLocalizedString(@"pullBlackAndReport",nil),NSLocalizedString(@"myinfoLabel",nil),NSLocalizedString(@"cancelNotice", nil),nil];
    }

    

}




-(BOOL)canBecomeFirstResponder
{
    return YES;

}

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender
{
    [super canPerformAction:action withSender:sender];
    
    if(action == @selector(reconnect1:)||action==@selector(share1:)||action==@selector(delete1:) )
    {
       
        return YES;
   
    }
    return NO;
}



// 这是发送s
-(void)reconnect1:(id)sender{
    
    
//    UIActionSheet *reconnect=[[UIActionSheet alloc]initWithTitle:NSLocalizedString(@"confomForward", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"cancelNotice", nil) destructiveButtonTitle:NSLocalizedString(@"confirmNotice", nil) otherButtonTitles: nil];
    UIActionSheet *reconnect=[[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:NSLocalizedString(@"cancelNotice", nil) destructiveButtonTitle:NSLocalizedString(@"confirmNotice", nil) otherButtonTitles: nil];

    
    reconnect.tag=2345;
    
    [reconnect showInView:self.view.window];
    
    [reconnect release];
    
    
   [[UIMenuController sharedMenuController] setMenuVisible:NO animated:YES];
    
}
-(void)share1:(id)sender
{

[[UIMenuController sharedMenuController] setMenuVisible:NO animated:YES];

}


// 删除
-(void)delete1:(id)sender
{
    
    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, __MainScreen_Width, __MainScreen_Height)];
    
    view.backgroundColor=[UIColor darkGrayColor];
    
    view.alpha=.2;
    
    view.tag=1010;
    [self.view insertSubview:view aboveSubview:self.tableView];
    
    [view release];
    
    
    
//    UIActionSheet *delete=[[UIActionSheet alloc]initWithTitle:NSLocalizedString(@"confirmDelete", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"cancelNotice", nil) destructiveButtonTitle:NSLocalizedString(@"confirmNotice", nil) otherButtonTitles: nil];
    UIActionSheet *delete=[[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:NSLocalizedString(@"cancelNotice", nil) destructiveButtonTitle:NSLocalizedString(@"confirmNotice", nil) otherButtonTitles: nil];


    delete.tag=1234;
    
    [delete showInView:self.view.window];
    
    [delete release];
    
    
    [[UIMenuController sharedMenuController] setMenuVisible:NO animated:YES];

}

/*******************************************/
// 进行删除的操作


-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if(actionSheet.tag==1234)
    {
        if(buttonIndex==0)
        {
            [MyAppDataManager.dialogs removeObjectAtIndex:_rowt];
            
            
            //***(*(*(*(*
            [MyAppDataManager.talkArr removeObjectAtIndex:(MyAppDataManager.talkArr.count-(MyAppDataManager.dialogs.count-_rowt)-1)];
            
            NSMutableArray *message=[MyAppDataManager.dialogs mutableCopy];
            
            [MyAppDataManager removeTableNamed:[MyAppDataManager getTableNameForUid:VALUE(KeyFromUid, _profile)]];
            
            int k=0;
            
            
            
            for(NSMutableDictionary *temp in MyAppDataManager.dialogs)
            {
                
                NSMutableDictionary *dictionary=[[NSMutableDictionary alloc]initWithDictionary:temp];
                
                [dictionary setValue:[NSNumber numberWithInt:k] forKey:@"ID"];
                
                [message replaceObjectAtIndex:k withObject:dictionary];
                
                k++;
                
                [MyAppDataManager insertData:dictionary forItem:DIALOGS forUid:VALUE(KeyFromUid, _profile)];
                
                [dictionary release];
                
                
            }
            MyAppDataManager.dialogs=[message retain];
            int i = 0;
            for(NSMutableDictionary *dic1 in MyAppDataManager.talkPeoples)
            {
//                NSLog(@"%@  %@",MyAppDataManager.chatuid,[dic1 objectForKey:@"userid"]);
                //                NSLog(@"%@ %@",[dic1 objectForKey:@"userid"],[dic1 objectForKey:KeyLasttalk]);
                
                if([[dic1 objectForKey:@"userid"] isEqualToString: MyAppDataManager.chatuid])
                {
                    //                  [dic1 setObject:@"" forKey:KeyLasttalk];
                    if([MyAppDataManager.dialogs count]>0)
                    {
                        [dic1 setObject:[[MyAppDataManager.dialogs lastObject] valueForKey:KeyContent] forKey:KeyLasttalk];
                        ChatCellType type = [[[MyAppDataManager.dialogs lastObject]valueForKey:KeyType]intValue];
//                        NSLog(@"%@",dic1);
//                        NSLog(@"%d",type);
                        switch (type) {
                            case ChatCellTypeText:{
                                [dic1 setObject:[[MyAppDataManager.dialogs lastObject] valueForKey:KeyContent] forKey:KeyLasttalk];
                                [dic1 setObject:@"text" forKey:KeyType];
                            }
                                
                                break;
                            case ChatCellTypeLocation:{
                                [dic1 setObject:@"talkLocation" forKey:KeyLasttalk];
                                [dic1 setObject:@"location" forKey:KeyType];

                            }
                                
                                break;
                            case ChatCellTypeVoice:{
                                [dic1 setObject:@"talkSound" forKey:KeyLasttalk];
                                [dic1 setObject:@"sound" forKey:KeyType];
                            }
                 
                                break;
                            case ChatCellTypeEmi:{
                                [dic1 setObject:[[MyAppDataManager.dialogs lastObject] valueForKey:KeyContent] forKey:KeyLasttalk];
                                [dic1 setObject:@"emi" forKey:KeyType];
                            }
                        
                                break;
                            case ChatCellTypeImage:{
                                [dic1 setObject:@"talkPicture" forKey:KeyLasttalk];
                                [dic1 setObject:@"image" forKey:KeyType];
                            }

                                break;
                            default:
                                break;
                        }
                    }
                    else
                        [dic1 setObject:@"" forKey:KeyLasttalk];
                    
                    [MyAppDataManager.talkPeoples replaceObjectAtIndex:i withObject:dic1];
                    
                    
                    
                    [MyAppDataManager updateData:MyAppDataManager.talkPeoples forItem:TALKPEOPLES forUid:MyAppDataManager.chatuid];
                    break;
                }
                i++;
            }
            for(BanBu_DialogueController * con in self.navigationController.viewControllers)
            {
                if([con isKindOfClass:[BanBu_DialogueController class]])
                {
                    [con updateBadgeShow];
                    
                    break;
                }
            }
            [self.tableView reloadData];
            
            [message release];
            
        }
        
        UIView *sender=(UIView *)[self.view viewWithTag:1010];
        
        [sender removeFromSuperview];
        
    }
    else if(actionSheet.tag == 10101){
        if(buttonIndex==0)
        {
            [self seeProfile:nil];
            
            
        }else if(buttonIndex==1)
        {
            
            // 多加载20 条
            
            [MyAppDataManager readMoreTwentyMessage];
            
            [self.tableView reloadData];
            
            
            
        }else if(buttonIndex==2)
        {
            [MyAppDataManager removeTableNamed:[MyAppDataManager getTableNameForUid:VALUE(KeyFromUid, _profile)]];
            
            [MyAppDataManager.dialogs removeAllObjects];
            
            [MyAppDataManager.readArr removeAllObjects];
            
            [MyAppDataManager.talkArr removeAllObjects];
            
            [UserDefaults setValue:MyAppDataManager.readArr forKey:@"read"];
            
            int i = 0;
            for(NSMutableDictionary *dic1 in MyAppDataManager.talkPeoples)
            {
                //                NSLog(@"%@",MyAppDataManager.chatuid);
                //                NSLog(@"%@ %@",[dic1 objectForKey:@"userid"],[dic1 objectForKey:KeyLasttalk]);
                
                if([[dic1 objectForKey:@"userid"] isEqualToString: MyAppDataManager.chatuid])
                {
                    [dic1 setObject:@"" forKey:KeyLasttalk];
                    //                    [dic1 setObject:@"" forKey:KeyType];
                    [MyAppDataManager.talkPeoples replaceObjectAtIndex:i withObject:dic1];
                    
                    [MyAppDataManager updateData:MyAppDataManager.talkPeoples forItem:TALKPEOPLES forUid:MyAppDataManager.chatuid];
                    break;
                }
                
                
                i++;
            }
            [self.tableView reloadData];
            //             NSLog(@"%@",[MyAppDataManager.talkPeoples objectAtIndex:0]);
            //           [UserDefaults setValue:MyAppDataManager.readArr forKey:@"read"];
            //
            //
            for(BanBu_DialogueController * con in self.navigationController.viewControllers)
            {
                if([con isKindOfClass:[BanBu_DialogueController class]])
                {
                    [con updateBadgeShow];
                    
                    break;
                }
            }
            
            
            
            //           [self.tableView reloadData];
        }
    }
    
    else if(actionSheet.tag == 1111){
         NSDictionary *amsg = [NSDictionary dictionaryWithDictionary:[MyAppDataManager.dialogs objectAtIndex:_rowt]];
        
        
        NSString *langauage=[MyAppDataManager getPreferredLanguage];
        if([langauage isEqual:@"zh-Hans"]){
 
            if(buttonIndex == 1){
//                NSLog(@"%@",headImageString);
                ShareViewController *share = [[ShareViewController alloc] initWithURLString:nil];
                share.sayContent = [amsg valueForKey:@"content"];
                [self.navigationController pushViewController:share animated:YES];
            }else if(buttonIndex == 0){
                UIActionSheet *shareSheet=[[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:NSLocalizedString(@"cancelNotice", nil) destructiveButtonTitle:nil otherButtonTitles:@"分享给微信好友",@"分享到微信好友圈",@"分享到新浪微博",@"分享到腾讯微博", nil];
                shareSheet.tag = 10010;
                [shareSheet showInView:self.view];
                [shareSheet release];
            }
            
            
        }
        else{
            
            if(buttonIndex == 1){
                if([[UserDefaults valueForKey:@"FBUser"] length]){
                    
                    
                    BOOL displayedNativeDialog = [FBNativeDialogs presentShareDialogModallyFrom:self
                                                                                    initialText:[amsg valueForKey:@"content"]
                                                                                          image:nil
                                                                                            url:nil
                                                                                        handler:nil];
                    
                    if (!displayedNativeDialog) {
                        
                        [self performPublishAction:^{
                            
                            
                            [FBRequestConnection startForUploadPhoto:nil
                                                   completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
                                                       //                                       [self showAlert:@"Photo Post" result:result error:error];
                                                       [TKLoadingView dismissTkFromView:self.view animated:NO afterShow:0.0];
                                                       [TKLoadingView showTkloadingAddedTo:self.view title:NSLocalizedString(@"shareSuccess", nil) activityAnimated:NO duration:2.0 ];
                                                       
                                                       
                                                   }];
                            
                            
                            
                        }];
                        
                    }
     
                }else{
                    BanBu_MyProfileViewController *profile = [[BanBu_MyProfileViewController alloc]autorelease];
                    profile.tableView.contentOffset = CGPointMake(0, 360);
                    [self.navigationController pushViewController:profile animated:YES];
                }
            }else if(buttonIndex == 0){
                if([[UserDefaults valueForKey:@"TUser"] length]){
                    FHSTwitterEngine * aEngine = [[[FHSTwitterEngine alloc]initWithConsumerKey:@"2cZXkfmSC6UrPUkhSPtfwQ" andSecret:@"mdoijXeFbK6dGVs5C61rADMOWSgFdNtPOBsxgnKw"]autorelease];
                    [aEngine loadAccessToken];
                    [TKLoadingView showTkloadingAddedTo:self.view title:NSLocalizedString(@"sendingNotice", nil) activityAnimated:YES];
                    
                    dispatch_async(GCDBackgroundThread, ^{
                        @autoreleasepool {
                            [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
                            NSError *returnCode = [aEngine postTweet:@"Share a good thing" withImageData:nil];
                            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                            
                            NSString *title = nil;
                            //                                NSString *message = nil;
                            
                            if (returnCode) {
                                //                                    title = [NSString stringWithFormat:@"Error %d",returnCode.code];
                                //                                    message = returnCode.domain;
                                title = NSLocalizedString(@"errcode_fail", nil);
                            } else {
                                //                                    title = @"Tweet Posted";
                                //                                    message = tweetField.text;
                                title = NSLocalizedString(@"shareSuccess", nil);
                            }
                            
                            dispatch_sync(GCDMainThread, ^{
                                [TKLoadingView dismissTkFromView:self.view animated:NO afterShow:0.0];
                                [TKLoadingView showTkloadingAddedTo:self.view title:title activityAnimated:NO duration:2.0];
                            });
                        }
                    });

                    
                }else{
                    
                    
                    BanBu_MyProfileViewController *profile = [[BanBu_MyProfileViewController alloc]autorelease];
                    profile.tableView.contentOffset = CGPointMake(0, 360);
                    [self.navigationController pushViewController:profile animated:YES];
                }
            }
        }
    }
    else if(actionSheet.tag ==10010){
        
           NSDictionary *amsg = [NSDictionary dictionaryWithDictionary:[MyAppDataManager.dialogs objectAtIndex:_rowt]];
        if(buttonIndex == 0){
            MyWXOpen.scene = WXSceneSession;
            [MyWXOpen sendTextContent:[amsg valueForKey:@"content"]];
 
            
            
        }
        else if(buttonIndex == 1){
            MyWXOpen.scene = WXSceneTimeline;
            [MyWXOpen sendTextContent:[amsg valueForKey:@"content"]];

            
        }
        else if(buttonIndex == 2){
            
            if([[UserDefaults valueForKey:@"sinaUser"] length]){
                WBEngine *_wbEngine = [[WBEngine alloc] initWithAppKey:kWBSDKDemoAppKey appSecret:kWBSDKDemoAppSecret];
                [_wbEngine setDelegate:self];
                [_wbEngine setRootViewController:self];
                [_wbEngine setRedirectURI:@"http://www.halfeet.com"];
                [_wbEngine setIsUserExclusive:NO];
                
                //NSLog(@"%@",_receiveImage);
                [_wbEngine sendWeiBoWithText:[NSString stringWithFormat:@"%@",[amsg valueForKey:@"content"]] image: nil];
                [TKLoadingView showTkloadingAddedTo:self.view title:NSLocalizedString(@"sendingNotice", nil) activityAnimated:YES];
 
                
            }else{
                BanBu_MyProfileViewController *profile = [[BanBu_MyProfileViewController alloc]autorelease];
                profile.tableView.contentOffset = CGPointMake(0, 360);
                [self.navigationController pushViewController:profile animated:YES];
            }
        }
        else if(buttonIndex == 3){
            if([[UserDefaults valueForKey:@"QUser"] length]){
                
                QWeiboAsyncApi *api = [[[QWeiboAsyncApi alloc] init] autorelease];
                NSString *tokenKey = [user valueForKey:AppTokenKey];
                NSString *tokenSecret = [user valueForKey:AppTokenSecret];
                
                NSString *imagePath = [NSTemporaryDirectory() stringByAppendingFormat:@"releaseImage"];
                UIImage *tempImage = nil;
                UIImageView *sendImageView = [[UIImageView alloc]initWithImage:tempImage] ;
                if(sendImageView.image)
                {
                    NSData *imageData;
                    //            if(!imageData)
                    imageData = UIImageJPEGRepresentation(sendImageView.image, 0.7);
                    [imageData writeToFile:imagePath atomically:YES];
                    //                    //NSLog(@"%@",imageData);
                }
                self.connection	= [api publishMsgWithConsumerKey:AppKey
                                                  consumerSecret:AppSecret
                                                  accessTokenKey:tokenKey
                                               accessTokenSecret:tokenSecret
                                                         content:[NSString stringWithFormat:@"%@",[amsg valueForKey:@"content"]]
                                                       imageFile:sendImageView.image?imagePath:nil
                                                      resultType:RESULTTYPE_JSON
                                                        delegate:self];
                [sendImageView release];
                [TKLoadingView showTkloadingAddedTo:self.view title:NSLocalizedString(@"sendingNotice", nil) activityAnimated:YES];
 
            }else{
                
                BanBu_MyProfileViewController *profile = [[BanBu_MyProfileViewController alloc]autorelease];
                profile.tableView.contentOffset = CGPointMake(0, 360);
                [self.navigationController pushViewController:profile animated:YES];
                
            }
        }
        
    }
    else
    {
        
        if(buttonIndex==0)
        {
            
            NSMutableDictionary *messageDic=[MyAppDataManager.dialogs objectAtIndex:_rowt];
            
            
            [self ReconnectOneMsg:nil amsg:messageDic];
            
        }
    }
    
}

/*
- (void)showTopBar
{
    _topBar.hidden = NO;
    
    [UIView animateWithDuration:0.5
                     animations:^{
                         CGRect rect = _topBar.frame;
                         rect.origin.y = (rect.origin.y<64?64:30);
                         _topBar.frame = rect;
                     }
                     completion:^(BOOL finished) {
                        if(_topBar.frame.origin.y < 64)
                             _topBar.hidden = YES;
                         else 
                         {
                            [self performSelector:@selector(showTopBar) withObject:nil afterDelay:3.0];
                         }
                     }];
    
}
 */

/****************************************/
/*      发送图片、照相、地理位置、声音        */
/****************************************/
- (void)actions:(UIButton *)button
{
    
//    if(_showMenu)
//        [self performSelector:@selector(plusAction:) withObject:_plusButton];
    
     
    if(button.tag < 2)
    {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        if(button.tag == 0)
        {
            if ([UIImagePickerController isSourceTypeAvailable:
                 UIImagePickerControllerSourceTypeCamera]) {
                picker.sourceType = UIImagePickerControllerSourceTypeCamera;
            }
            
        }
        else if(button.tag == 1)
        {        
            picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;        
        }
        [picker setAllowsEditing:YES];
        [self presentModalViewController:picker animated:YES];
        [picker release];
    }
    else if(button.tag ==2)
    {
        BanBu_SearchIceViewController *aSearch = [[BanBu_SearchIceViewController alloc]init];
        [self.navigationController pushViewController:aSearch animated:YES];
        [aSearch release];

        
        
        
       
    }
    else if(button.tag==3){
        //涂鸦。。。。
        BanBu_GraffitiController *aGraff=[[BanBu_GraffitiController alloc]initwithImage:nil andSourceType:1];
        [self presentModalViewController:aGraff animated:YES];
        [aGraff release];
    }
    else {
 
        // 发送消息前发一条信息
        
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:NSLocalizedString(@"noticeNotice", ni) message:NSLocalizedString(@"sendLocation", nil) delegate:self cancelButtonTitle:@"YES" otherButtonTitles:@"NO", nil];
        
        alert.tag=101010;
        
        [alert show];
        
        [alert release];
    }
    
}
#pragma  mark- alert

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
      if(alertView.tag==101010)
      {
       if(buttonIndex==0)
       {
        [self sendOneMsg:nil type:ChatCellTypeLocation filePathExtension:nil From:@"mo"];
       
       }else
       {
           return;
       
       }
      }
      else if (alertView.tag==10101)
      {
          if(buttonIndex==0)
          {
          
            
          
          }else if(buttonIndex==1)
          {
              
              [MyAppDataManager removeTableNamed:[MyAppDataManager getTableNameForUid:VALUE(KeyFromUid, _profile)]];
              
              [MyAppDataManager.dialogs removeAllObjects];
              
              [MyAppDataManager.readArr removeAllObjects];
              
              [MyAppDataManager.talkArr removeAllObjects];
              
              [UserDefaults setValue:MyAppDataManager.readArr forKey:@"read"];
              
              [self.tableView reloadData];

          
          }else if(buttonIndex==2)
          {
//           NSLog(@"2");
              
          }else if(buttonIndex==3)
          {
          
              [self seeProfile:nil];
              
          }else
          {
          
           // 多加载20 条
              
              [MyAppDataManager readMoreTwentyMessage];
              
              [self.tableView reloadData];
          
          }
    
      }
      else if(alertView.tag==12345)
      {
          if(buttonIndex==0)
          {
          
           }else if (buttonIndex==1)
          {
              alertView.hidden=YES;
              
              [self delete1:nil];
              
          }else
          {
              alertView.hidden=YES;
              
              [self reconnect1:nil];
             
          
          }
          
          

      }
      else
      {
          
//          NSLog(@"%@",[MyAppDataManager.dialogs objectAtIndex:_rowt]);
          if (buttonIndex)
          {
              
              NSDictionary *amsg = [NSDictionary dictionaryWithDictionary:[MyAppDataManager.dialogs objectAtIndex:_rowt]];
              
              if(buttonIndex == 1){
                  
                  alertView.hidden=YES;
                  
                  [self delete1:nil];
                  
                  
              }
              else if(buttonIndex == 2){
                  UIPasteboard *paste = [UIPasteboard generalPasteboard];
                  [paste setString:[amsg valueForKey:@"content"]];
              }
              else if(buttonIndex == 3){
                  //分享
              
                  [self performSelector:@selector(afterDelayShare) withObject:nil afterDelay:0.5];
                  
              }

          }
                
      }

}

-(void)afterDelayShare{
    UIActionSheet *actionSheet;
    NSString *langauage=[MyAppDataManager getPreferredLanguage];
    if([langauage isEqual:@"zh-Hans"]){
        actionSheet = [[[UIActionSheet alloc] initWithTitle:nil delegate:self
                                          cancelButtonTitle:NSLocalizedString(@"cancelNotice", nil) destructiveButtonTitle:nil
                                          otherButtonTitles:NSLocalizedString(@"分享到微信、微博", nil),NSLocalizedString(@"分享到QQ空间、人人网", nil),  nil] autorelease];;
    }else{
        actionSheet = [[[UIActionSheet alloc] initWithTitle:nil delegate:self
                                          cancelButtonTitle:NSLocalizedString(@"cancelNotice", nil) destructiveButtonTitle:nil
                                          otherButtonTitles: @"Twitter",@"Facebook",  nil] autorelease];
    }
    actionSheet.tag = 1111;//分享
    [actionSheet showInView:self.view];

}

#pragma mark  -
- (void)imagePickerController:(UIImagePickerController *)picker
        didFinishPickingImage:(UIImage *)image
                  editingInfo:(NSDictionary *)editingInfo {
    NSString *imagePathExtension = nil;
    if(picker.sourceType == UIImagePickerControllerSourceTypeCamera)
        imagePathExtension = @"jpg";
    else
    {
        imagePathExtension = [[[editingInfo valueForKey:UIImagePickerControllerReferenceURL] pathExtension] lowercaseString];
        if([imagePathExtension isEqualToString:@"gif"])
            imagePathExtension = @"jpg";
    }
    
    NSData *data = nil;
   image=[MyAppDataManager scaleImage:image proportion:2];
    
    if([imagePathExtension isEqualToString:@"png"])
        data = UIImagePNGRepresentation(image);
    else
        data = UIImageJPEGRepresentation(image, .6);

    // 这是 发送图片的 类型和方法
    [self sendOneMsg:data type:ChatCellTypeImage filePathExtension:imagePathExtension From:@"mo"];
    
    [picker dismissModalViewControllerAnimated:YES];    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [picker dismissModalViewControllerAnimated:YES];
}

- (void)record:(UILongPressGestureRecognizer *)longPress
{
    UIButton *button = (UIButton *)longPress.view;
    
    if(button.selected)
    {
        CGPoint point = [longPress locationInView:_recordView];
        if(longPress.state == UIGestureRecognizerStateEnded)
        {
            button.selected = NO;
            [_recordView touchesEndInView:point];
            _recordView = nil;
        }
        else
            [_recordView touchesMovedInView:point];
        
        return;
    }
    
    button.selected = YES;
    RecordView *recordView = [[RecordView alloc] initWithFrame:CGRectMake(0, 20, 320, __MainScreen_Height-44)];
    _recordView = recordView;
    NSString *fileName = [NSString stringWithFormat:@"%i-%@.%@",MyAppDataManager.dialogs.count,MyAppDataManager.chatuid,@"amr"];
    _recordView.audioPath = [AppComManager pathForMedia:fileName];
    recordView.delegate = self;
    [self.navigationController.view addSubview:recordView];
    [recordView release];
    
}

- (void)topBarButtonActions:(UIButton *)button
{
    if(button.tag == 1)
    {
       
        //上面
        [MyAppDataManager removeTableNamed:[MyAppDataManager getTableNameForUid:VALUE(KeyFromUid, _profile)]];
        
        [MyAppDataManager.dialogs removeAllObjects];
        
        [MyAppDataManager.readArr removeAllObjects];
        
        [UserDefaults setValue:MyAppDataManager.readArr forKey:@"read"];
        
        
        [self.tableView reloadData];
        
    }else if(button.tag==0)
    {
        
    }else{
    
    
    }
    
    
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    _topBar.hidden = YES;
    

    [MyAppDataManager.readArr removeAllObjects];
    
    [UserDefaults setValue:MyAppDataManager.readArr forKey:@"read"];
    

}

/*************end**************/
/************** chat **************/

- (void)sendOneMsg:(id)MsgData type:(ChatCellType)type filePathExtension:(NSString *)pathExtension From:(NSString *)from
{
    NSMutableDictionary *amsg = [NSMutableDictionary dictionaryWithCapacity:2];
    [amsg setValue:[NSNumber numberWithInt:MyAppDataManager.talkArr.count] forKey:KeyID];
    [amsg setValue:[NSNumber numberWithInt:type] forKey:KeyType];
    [amsg setValue:[NSNumber numberWithBool:YES] forKey:KeyMe];
    [amsg setValue:[NSNumber numberWithInt:ChatStatusSending] forKey:KeyStatus];
    [amsg setValue:MyAppDataManager.userAvatar forKey:KeyUface];
    
//    NSLog(@"%@",MyAppDataManager.userAvatar);
    NSInteger row = MyAppDataManager.dialogs.count;
    
    NSString *lastTimeStr = nil;
    if(row)
        lastTimeStr = [[MyAppDataManager.dialogs objectAtIndex:row-1] valueForKey:KeyStime];
    NSDateFormatter *formatter = [[[NSDateFormatter alloc] init] autorelease];
    [formatter setLocale:[NSLocale currentLocale]];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *stime = [formatter stringFromDate:[NSDate date]];
    [amsg setValue:stime forKey:KeyStime];
    BOOL showTime = [self fiveMinuteLater:stime beforeTime:lastTimeStr];
    
      if([MyAppDataManager.dialogs count]==0)
          showTime=YES;
    
    [amsg setValue:[NSNumber numberWithBool:showTime] forKey:KeyShowtime];
    
    [amsg setValue:from forKey:KeyShowFrom];
    switch (type) {
        case ChatCellTypeText:
        {
            if([MsgData length]==0)
            {
                return;
            
            }
            
            [amsg setValue:MsgData forKey:KeyContent];
            
            if(!pathExtension)
            {
                 if([from isEqual:@"mo"])
                 {
                     
                     //  cell 的高度有点小 加大一点
//                     [amsg setValue:[NSNumber numberWithFloat:[BanBu_SmileLabel heightForText:MsgData]+2*CellMarge+(showTime?TimeLabelHeight:0)]forKey:KeyHeight];
                     [amsg setValue:[NSNumber numberWithFloat:[BanBu_SmileLabel heightForText:MsgData]+2*CellMarge+(showTime?TimeLabelHeight:0)]forKey:KeyHeight];

//                     NSLog(@"%f",[BanBu_SmileLabel heightForText:MsgData]+2*CellMarge+(showTime?TimeLabelHeight:0));
                
                 }else
                 {
                     [amsg setValue:[NSNumber numberWithFloat:[BanBu_SmileLabel heightForText:MsgData]+2*CellMarge+(showTime?TimeLabelHeight:0)+FromLabelHeight] forKey:KeyHeight];
                 }
                      
    
            }else
            {
             // 这是发送地图的没有来自半步破冰语的所以不用判断是否来自mo wb tu yu
            [amsg setValue:[NSNumber numberWithFloat:locationTypeHeight+2*CellMarge+(showTime?TimeLabelHeight:0)] forKey:KeyHeight];
            
            }
            break;
        }
        case ChatCellTypeLocation:
        {
             // 发送消息
            
            // 构造发送的地址字符串
            NSString *string=[NSString stringWithFormat:@"%0.f,%0.f",AppLocationManager.curLocation.longitude*1000000,AppLocationManager.curLocation.latitude*1000000];
            
            //[amsg setValue:NSStringFromCGPoint(CGPointMake(AppLocationManager.curLocation.longitude, AppLocationManager.curLocation.latitude)) forKey:KeyContent];
        
            [amsg setValue:string forKey:KeyContent];
            
            [amsg setValue:[NSNumber numberWithFloat:locationTypeHeight+2*CellMarge+(showTime?TimeLabelHeight:0)] forKey:KeyHeight];
           
            break;
        
        }
        case ChatCellTypeImage:
        {
          
            NSString *fileName = [NSString stringWithFormat:@"%i-%@.%@",MyAppDataManager.talkArr.count,MyAppDataManager.chatuid,pathExtension];
            [amsg setValue:fileName  forKey:KeyContent];
            
            [amsg setValue:[NSNumber numberWithInteger:MediaStatusUpload] forKey:KeyMediaStatus];
            
            if([from isEqual:@"mo"])
            {
            
                [amsg setValue:[NSNumber numberWithFloat:ImageTypeHeight+2*CellMarge+(showTime?TimeLabelHeight:0)] forKey:KeyHeight];
         
            }else
            {
             
                [amsg setValue:[NSNumber numberWithFloat:ImageTypeHeight+2*CellMarge+(showTime?TimeLabelHeight:0)+FromLabelHeight] forKey:KeyHeight];
                
            }
            
            
            break;
        }
        case ChatCellTypeVoice:
        {
            NSString *fileName = [NSString stringWithFormat:@"%i-%@.%@",MyAppDataManager.talkArr.count,MyAppDataManager.chatuid,pathExtension];
            [amsg setValue:fileName forKey:KeyContent];
            
            [amsg setValue:[NSNumber numberWithInteger:MediaStatusUpload] forKey:KeyMediaStatus];
            
             if([from isEqual:@"mo"])
             {
                 
              [amsg setValue:[NSNumber numberWithFloat:VoiceTypeHeight+2*CellMarge+(showTime?TimeLabelHeight:0)] forKey:KeyHeight];
             }else
             {
                
             [amsg setValue:[NSNumber numberWithFloat:VoiceTypeHeight+2*CellMarge+(showTime?TimeLabelHeight:0)+FromLabelHeight] forKey:KeyHeight];
             }
            break;
        }
        case ChatCellTypeEmi:
        {
           [amsg setValue:MsgData forKey:KeyContent];
            
           [amsg setValue:[NSNumber numberWithFloat:ImageTypeHeight+2*CellMarge+(showTime?TimeLabelHeight:0)] forKey:KeyHeight];
        
            break;
        
        }
            
            
        default:
            break;
    }
    [UserDefaults setValue:@"1" forKey:self.title];
    
    [MyAppDataManager.dialogs addObject:amsg];
    
    [MyAppDataManager.talkArr addObject:amsg];
    // 把对话插入到数据库当中去
  
    
    [MyAppDataManager insertData:amsg forItem:DIALOGS forUid:MyAppDataManager.chatuid];
  

    BOOL isMan = NO;
    if(!VALUE(KeySex, _profile))
    {
        if(VALUE(KeyGender, _profile))
        {
            isMan=[VALUE(KeyGender, _profile)isEqual:@"m"];
            
            //            [dic setValue:[NSNumber numberWithBool:isMan] forKey:KeySex];
            
        }
    }else{
        isMan = [VALUE(KeySex, _profile) boolValue];
        //        [amsgtt setValue:VALUE(KeySex, dic) forKey:KeySex];
        
    }
    
    NSMutableDictionary *aNewDialog = [NSMutableDictionary dictionaryWithDictionary:_profile];
    [aNewDialog setValue:VALUE(KeyContent, amsg) forKey:KeyLasttalk];
    NSArray *mapArr = [NSArray arrayWithObjects:@"text",@"image",@"location",@"sound",@"emi",nil];
    [aNewDialog setValue:[mapArr objectAtIndex:type] forKey:KeyType];
    [aNewDialog setValue:VALUE(KeyStime, amsg) forKey:KeyStime];
   
    [aNewDialog setValue:VALUE(KeyMe, amsg) forKey:KeyMe];
    
    // 更新对话列表***********************
    
    NSString *jsonfrom = [[CJSONSerializer serializer] serializeArray: VALUE(@"facelist", aNewDialog)];
    
    [aNewDialog setValue:jsonfrom forKey:@"facelist"];
    
    [aNewDialog setValue:VALUE(KeyStatus, amsg) forKey:KeyStatus];
    
    //保存我最后发的消息
    [UserDefaults setValue:aNewDialog forKey:@"my"];
    
    [aNewDialog setValue:[NSNumber numberWithBool:isMan] forKey:KeySex];
    
    /* 构造一个人、*/
//    NSLog(@"%@",aNewDialog);
    [MyAppDataManager updateDialogeListWithSendMsg:aNewDialog forUid:VALUE(KeyFromUid, aNewDialog) Item:DIALOGS];
    
    
    
   

    // 插入到uitableview 里面去
//判断为0不插入
//    NSLog(@"+*++*+*+*+*+*+*+*+*+%d+*+*+*+*+*+*+",MyAppDataManager.dialogs.count-1);
    
    
    [self.tableView beginUpdates];

    [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:MyAppDataManager.dialogs.count-1 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
     [self.tableView endUpdates];
     [self tableViewAutoOffset];
    
    // 如果大于35条删去
    

    
    if(type==ChatCellTypeText || type==ChatCellTypeLocation||type==ChatCellTypeEmi)
    {
        
        [MyAppDataManager sendTextMsg:VALUE(KeyContent, amsg) forType:type toUid:MyAppDataManager.chatuid From:from];
    }
    else
    {
        // 这是判断的是不是破冰语 
        if([MsgData length]<100&&[MsgData isKindOfClass:[NSString class]])
        {
            
            if([[MsgData pathExtension]isEqual:@"jpg"]||[[MsgData pathExtension]isEqual:@"gif"])
            {
                
                NSInteger row = MyAppDataManager.dialogs.count-1;
                
                [amsg setValue:@"0" forKey:KeyMediaStatus];
                
                [amsg setValue:MsgData forKey:KeyContent];
                
                [amsg setValue:from forKey:KeyShowFrom];
                
                // 更新数据库
                [MyAppDataManager updateData:amsg forItem:DIALOGS forUid:MyAppDataManager.chatuid];
               
                
                [MyAppDataManager sendTextMsg:MsgData forType:ChatCellTypeImage toUid:MyAppDataManager.chatuid From:from];
                if(self)
                {
                    BanBu_ChatCell *cell = (BanBu_ChatCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:0]];
                    if(cell)
                    {
                        [cell.mediaView setStatus:MediaStatusNormal];
                        
                        [cell.mediaView setMedia:MsgData];
                    }
                }

            }else if ([[MsgData pathExtension]isEqual:@"mp3"])
            {
            
             //   NSInteger row = [[amsg valueForKey:@"ID"] integerValue];
               
                
                NSInteger row =MyAppDataManager.dialogs.count-1;
                
                [amsg setValue:@"0" forKey:KeyMediaStatus];
                
                [amsg setValue:MsgData forKey:KeyContent];
                
                [amsg setValue:from forKey:KeyShowFrom];
                // 更新数据库
                [MyAppDataManager updateData:amsg forItem:DIALOGS forUid:MyAppDataManager.chatuid ];
                
                [MyAppDataManager sendTextMsg:MsgData forType:ChatCellTypeVoice toUid:MyAppDataManager.chatuid From:from];
                
                if(self)
                {
                    BanBu_ChatCell *cell = (BanBu_ChatCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:0]];
                    if(cell)
                    {
                        
//                        [cell.mediaView setStatus:MediaStatusNormal];
//                        [cell.mediaView setMedia:MsgData];
                        
                        [cell.voiceView setStatus:MediaStatusNormal];
                        
                        [cell.voiceView setMedia:MsgData];
                        
                        [cell setVoiceViewLong:MyAppDataManager.time];
                        
                      //  [cell setVoiceViewLong:[[resDic valueForKey:@"time"] floatValue]];
                        
                        
                        
                    }
                }

            
            }
                
                
        
        }else{
            
           NSString *savePath = [AppComManager pathForMedia:[amsg valueForKey:KeyContent]];
          
            NSMutableData *data=[[NSMutableData alloc]init];
            
           
            if(![FileManager fileExistsAtPath:savePath])
            {
                [data appendData:MsgData];
                
                [FileManager createFileAtPath:savePath contents:data attributes:nil];
                
                [data release];
                
            }
           
        // 判断不是破冰语
        NSMutableDictionary *sendDic = [NSMutableDictionary dictionaryWithCapacity:0];
        [sendDic setValue:pathExtension forKey:@"extname"];
        [sendDic setValue:MyAppDataManager.chatuid forKey:KeyUid];
        [sendDic setValue:from forKey:KeyShowFrom];
        [AppComManager uploadBanBuMedia:MsgData
                              mediaName:VALUE(KeyContent, amsg)
                                    par:sendDic
                               delegate:MyAppDataManager];
        
        }
        
    }


}

 
/*****************************************************************************/

- (void)ReconnectOneMsg:(id)MsgData amsg:(NSMutableDictionary *)dictionary
{
    
    NSMutableDictionary *aNewDialog = [NSMutableDictionary dictionaryWithDictionary:_profile];
    [aNewDialog setValue:VALUE(KeyContent, dictionary) forKey:KeyLasttalk];
    NSArray *mapArr = [NSArray arrayWithObjects:@"text",@"image",@"location",@"sound",@"emi",nil];
    [aNewDialog setValue:[mapArr objectAtIndex:_type] forKey:KeyType];
    
    NSString *jsonfrom = [[CJSONSerializer serializer] serializeArray: VALUE(@"facelist", aNewDialog)];
    
    [aNewDialog setValue:jsonfrom forKey:@"facelist"];

    [UserDefaults setValue:aNewDialog forKey:@"my"];

    if((_type==ChatCellTypeTextd || _type==ChatCellTypeLocationd||_type==ChatCellTypeEmid)&&![_fromPbTu isEqualToString:@"ty"])
    {
       
        [MyAppDataManager sendTextMsg:VALUE(KeyContent, dictionary) forType:(int)_type toUid:MyAppDataManager.chatuid Number:[[dictionary valueForKey:@"ID"] intValue] From:@"mo"] ;
    }
    else
    {
        MsgData=VALUE(KeyContent, dictionary);
        
        NSString *content=[NSString stringWithString:MsgData];
        
        if(![FileManager fileExistsAtPath:[AppComManager pathForMedia:MsgData]])
        {
        
            return;
        
        }else
        {
        
            if([[[content componentsSeparatedByString:@"-"] objectAtIndex:0] intValue]<1000)
            {
                
                NSData *data=[NSData dataWithContentsOfFile:[AppComManager pathForMedia:content]];
                
                // 判断是不是破冰语
                NSMutableDictionary *sendDic = [NSMutableDictionary dictionaryWithCapacity:1];
                [sendDic setValue:[content pathExtension] forKey:@"extname"];
                [sendDic setValue:MyAppDataManager.chatuid forKey:KeyUid];
                
                NSString *mediaName=[NSString stringWithFormat:@"%@",VALUE(KeyID, dictionary)];
                
                mediaName=[mediaName stringByAppendingString:@"-1010.jpg"];
                
                [AppComManager uploadBanBuMedia:data
                                      mediaName:mediaName
                                            par:sendDic
                                       delegate:MyAppDataManager];

            }else
            {
                if([[content pathExtension]isEqual:@"jpg"])
                {
                    [MyAppDataManager sendTextMsg:MsgData forType:ChatCellTypeImage toUid:MyAppDataManager.chatuid Number:[[dictionary valueForKey:@"ID"] intValue] From:_fromPbTu];
                
                }else
                {
                    [MyAppDataManager sendTextMsg:MsgData forType:ChatCellTypeVoice toUid:MyAppDataManager.chatuid Number:[[dictionary valueForKey:@"ID"] intValue] From:_fromPbTu];
                
                }
            
            
            }
        
        }
        
          
    }
   
}

// 显示破冰语的东东

-(void)pushTheNextViewController:(NSString *)indext
{
    /*
    if([indext isEqual:@"wb"])
    {
        
        NSMutableDictionary *parDic = [NSMutableDictionary dictionary];
        [parDic setValue:@"test" forKey:@"kind"];
        [parDic setValue:@"" forKey:@"keyword"];
        
        
        BanBu_IceBreakerController *ice=[[BanBu_IceBreakerController alloc]init];
        
        ice.parDic=parDic;
        
        [self.navigationController pushViewController:ice animated:YES];
        
        [ice release];
        
    }else if ([indext isEqual:@"yu"])
    {
        NSMutableDictionary *parDic = [NSMutableDictionary dictionary];
        [parDic setValue:@"sound" forKey:@"kind"];
        [parDic setValue:@"" forKey:@"keyword"];
        
        BanBu_IceBreaker_Voice *voice=[[BanBu_IceBreaker_Voice alloc]init];
        
        voice.parDic=parDic;
        
        [self.navigationController pushViewController:voice animated:YES];
        
        [voice release];
        
    }else
    {
        NSMutableDictionary *parDic = [NSMutableDictionary dictionary];
        [parDic setValue:@"image" forKey:@"kind"];
        [parDic setValue:@"" forKey:@"keyword"];
        
        BanBu_icePicController *pic=[[BanBu_icePicController alloc]init];
        
        pic.parDic=parDic;
        
        [self.navigationController pushViewController:pic animated:YES];
        
        [pic release];
        
    }
    */
    
//    if(_showMenu)
//        
//    [self performSelector:@selector(plusAction:) withObject:_plusButton];
    if([indext isEqualToString:@"pb"]){
        BanBu_SearchIceViewController *search=[[BanBu_SearchIceViewController alloc]init];
        
        [self.navigationController pushViewController:search animated:YES];
        
        [search release];
    }else if([indext isEqualToString:@"ty"]){
        BanBu_GraffitiController *aGraff=[[BanBu_GraffitiController alloc]initwithImage:nil andSourceType:1];
        [self presentModalViewController:aGraff animated:YES];
        [aGraff release];
    }
   
    
    

}





/************** chat **************/

#pragma recordView delegate method

- (void)recordView:(RecordView *)recordView recordDidCompleted:(NSData *)audioData recordTime:(int)duration
{
     if([audioData length]<100)
     {
         return;
     
     }

    [self sendOneMsg:audioData type:ChatCellTypeVoice filePathExtension:@"amr" From:@"mo"];
}


-(void)tableViewAutoup
{
  CGRect rect = _inputBar.frame;
    
    
    float offset = self.tableView.contentSize.height -rect.origin.y+48 ;
    

    if(offset<0)
        offset = 0;
    [UIView animateWithDuration:.6 animations:^{
        
       // [self.tableView setContentSize:CGSizeMake(320, offset)];
       [self.tableView setContentInset:UIEdgeInsetsMake(-offset, 0, 0, 0)];
        
       
        
    }];

    
}



- (void)tableViewAutoOffset
{
    CGRect rect = _inputBar.frame;
    NSInteger cellNum = MyAppDataManager.dialogs.count;
    if(cellNum)
    {

        float offset = self.tableView.contentSize.height -rect.origin.y + 24;
        if(offset<0)
            offset = 0;
        [UIView animateWithDuration:0.6 animations:^{
            [self.tableView setContentInset:UIEdgeInsetsMake(-offset, 0, 0, 0)];

        }];
       
            
    }
}

- (BOOL)fiveMinuteLater:(NSString *)stime beforeTime:(NSString *)ltime
{
    if(!ltime || !stime)
        return NO;
    
    NSDateFormatter *formatter = [[[NSDateFormatter alloc] init] autorelease];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *currentDate = [formatter dateFromString:stime];
    if(!currentDate)
        return NO;
    NSDate *lastDate = [formatter dateFromString:ltime];
    if(!lastDate)
        return NO;
    
    return [currentDate timeIntervalSince1970]>[lastDate timeIntervalSince1970]+300;
}


- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"Mynotification" object:nil];
   
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"iceWord" object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"icePic" object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"iceVoice" object:nil];
    
    MyAppDataManager.appChatController = nil;
    
    [_inputBar removeObserver:self forKeyPath:@"frame"];
    [_tableView removeObserver:self forKeyPath:@"contentOffset"];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidHideNotification object:nil];

    [_topBar removeFromSuperview];
    _topBar = nil;
        
    [_buttons release],_buttons=nil;
    [_tableView release],_tableView=nil;
    _inputBar = nil;
    [_profile release],_profile=nil;
    
    [_latiArr release],_latiArr=nil;
    [super dealloc];

}


//涂鸦—————————————
//监听
-(void)listeningAction:(NSNotification *)value{
 
//    veryImprotImageView = [[UIImageView alloc]initWithImage:[[value userInfo] objectForKey:@"tuyaImage"]];
//    _receiveImage = veryImprotImageView.image;
    NSString *imagePathExtension = @"jpg";
    
    
    NSData *data = nil;
    data = UIImageJPEGRepresentation([[value userInfo] objectForKey:@"tuyaImage"], 1.0);
    
    // 这是 发送图片的 类型和方法
    [self sendOneMsg:data type:ChatCellTypeImage filePathExtension:imagePathExtension From:@"ty"];
 
}

-(void)iceAction:(NSNotification *)notifi{

    [self sendOneMsg:[notifi object] type:ChatCellTypeText filePathExtension:nil From:@"pb"];

}

-(void)icePic:(NSNotification *)notifi{

     NSString* str =[[notifi object] valueForKey:@"image"];
  
     NSString *gifStr=[[notifi object] valueForKey:@"filetype"];
    

      if([gifStr isEqual:@"jpg"]||[gifStr isEqual:@"png"])
      {
     [self sendOneMsg:str type:ChatCellTypeImage filePathExtension:gifStr From:@"pb"];
      }
     if([gifStr isEqual:@"gif"])
     {
     

         [self sendOneMsg:str type:ChatCellTypeImage filePathExtension:@"gif" From:@"pb"];
     
     }
    
    
    
}
-(void)iceVoice:(NSNotification *)notifi
{
  
    NSString *str=[[notifi object]valueForKey:@"music"];
    
   [self sendOneMsg:str type:ChatCellTypeVoice filePathExtension:@"amr" From:@"pb"];

}

-(void)RequestOneMsg:(id)object type:(ChatCellType)type filePathExtension:(NSString *)pathExtension From:(NSString *)from
{
   
    [MyAppDataManager.dialogs removeAllObjects];
    
    [MyAppDataManager readMoreDataForCurrentDialog:AllData];
    
    [self  sendOneMsg:object type:type filePathExtension:pathExtension From:from];
    

}





/*******************分享************/

- (void) performPublishAction:(void (^)(void)) action {
    // we defer request for permission to post to the moment of post, then we check for the permission
    if ([FBSession.activeSession.permissions indexOfObject:@"publish_actions"] == NSNotFound) {
        // if we don't already have the permission, then we request it now
        [FBSession.activeSession reauthorizeWithPublishPermissions:[NSArray arrayWithObject:@"publish_actions"]
                                                   defaultAudience:FBSessionDefaultAudienceFriends
                                                 completionHandler:^(FBSession *session, NSError *error) {
                                                     if (!error) {
                                                         [TKLoadingView showTkloadingAddedTo:self.view title:NSLocalizedString(@"sendingNotice", nil) activityAnimated:YES];
                                                         
                                                         action();
                                                     }
                                                     //For this example, ignore errors (such as if user cancels).
                                                 }];
    } else {
        [TKLoadingView showTkloadingAddedTo:self.view title:NSLocalizedString(@"sendingNotice", nil) activityAnimated:YES];
        
        action();
    }
    
}


- (void)engine:(WBEngine *)engine requestDidFailWithError:(NSError *)error{
//    NSLog(@"%@",error);
    
    TKLoadingView *indictor = nil;
	for(indictor in self.view.subviews)
		if([indictor isKindOfClass:[TKLoadingView class]])
		{
			[indictor setActivityAnimating:NO withShowMsg:NSLocalizedString(@"errcode_fail", nil)];
			[indictor dismissAfterDelay:1.0 animated:YES];
		}
}
- (void)engine:(WBEngine *)engine requestDidSucceedWithResult:(id)result{
//    NSLog(@"asdfasdf");
    TKLoadingView *indictor = nil;
	for(indictor in self.view.subviews)
		if([indictor isKindOfClass:[TKLoadingView class]])
		{
			[indictor setActivityAnimating:NO withShowMsg:NSLocalizedString(@"shareSuccess", nil)];
			[indictor dismissAfterDelay:1.0 animated:YES];
		}
}

- (void) connectionDidFinishLoading:(NSURLConnection *)connection {
	
    
    TKLoadingView *indictor = nil;
	for(indictor in self.view.subviews)
		if([indictor isKindOfClass:[TKLoadingView class]])
		{
			[indictor setActivityAnimating:NO withShowMsg:NSLocalizedString(@"shareSuccess", nil)];
			[indictor dismissAfterDelay:1.0 animated:YES];
		}
    
}
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
	
    TKLoadingView *indictor = nil;
	for(indictor in self.view.subviews)
		if([indictor isKindOfClass:[TKLoadingView class]])
		{
			[indictor setActivityAnimating:NO withShowMsg:NSLocalizedString(@"errcode_fail", nil)];
			[indictor dismissAfterDelay:1.0 animated:YES];
		}
}


- (void)storeAccessToken:(NSString *)accessToken {
    [[NSUserDefaults standardUserDefaults]setObject:accessToken forKey:@"SavedAccessHTTPBody"];
}

- (NSString *)loadAccessToken {
    return [[NSUserDefaults standardUserDefaults]objectForKey:@"SavedAccessHTTPBody"];
}




@end
