   //
//  BanBu_MyProfileViewController.m
//  BanBu
//
//  Created by jie zheng on 12-7-8.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "BanBu_MyProfileViewController.h"
#import "BanBu_NameAndSexController.h"
#import "BanBu_BirthdayViewController.h"
#import "BanBu_WorkViewController.h"
#import "BanBu_ZibarController.h"

#import "AppCommunicationManager.h"
#import "AppDataManager.h"
#import "TKLoadingView.h"
#import "BanBu_AppDelegate.h"

@interface BanBu_MyProfileViewController ()

@end

@implementation BanBu_MyProfileViewController

@synthesize myProfile = _myProfile;
@synthesize imagePathExtension = _imagePathExtension;

- (id)init
{
    self = [super initWithStyle:UITableViewStylePlain];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)abc:(NSNotification *)notifi{


    [UserDefaults setValue:@"fb" forKey:@"FBUser"];
    NSMutableDictionary *pars = [NSMutableDictionary dictionaryWithCapacity:2];
    [pars setValue:@"facebook" forKey:@"bindto"];
    
    [pars setValue:[NSString stringWithFormat:@"%@,%@",[(FBSession *)[notifi object] accessToken],@"fb"] forKey:@"bindstring"];
    [AppComManager getBanBuData:BanBu_Set_User_accountbind par:pars delegate:self];
    [TKLoadingView showTkloadingAddedTo:self.navigationController.view title:NSLocalizedString(@"chuliNotice", nil) activityAnimated:YES];
    self.navigationController.view.userInteractionEnabled = NO;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(abc:) name:@"abc" object:nil];

    self.view.backgroundColor = [UIColor scrollViewTexturedBackgroundColor];
    self.tableView.backgroundColor = [UIColor colorWithRed:255.0/255 green:250.0/255 blue:240.0/255 alpha:1.0];
    self.title =[[UserDefaults valueForKey:MyAppDataManager.useruid] valueForKey:@"pname"];
    
    UIButton *edit = [UIButton buttonWithType:UIButtonTypeCustom];
    CGFloat btnLen = [NSLocalizedString(@"editAvatar", nil) sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(100, 30)].width;
    edit.frame=CGRectMake(0, 0, btnLen+20, 30);
    [edit addTarget:self action:@selector(edit:) forControlEvents:UIControlEventTouchUpInside];
    [edit setBackgroundImage:[[UIImage imageNamed:@"app_nav_btn_bg1.png"] stretchableImageWithLeftCapWidth:15.0 topCapHeight:15.0] forState:UIControlStateNormal];
//    [edit setBackgroundImage:[[UIImage imageNamed:@"app_nav_btn_bg2.png"] stretchableImageWithLeftCapWidth:15.0 topCapHeight:15.0] forState:UIControlStateHighlighted];
    [edit setTitleEdgeInsets:UIEdgeInsetsMake(3, 2, 2, 2)];
    [edit setTitle:NSLocalizedString(@"editAvatar", nil) forState:UIControlStateNormal];
    edit.titleLabel.font = [UIFont systemFontOfSize:14];
    UIBarButtonItem *editItem = [[[UIBarButtonItem alloc] initWithCustomView:edit] autorelease];
    self.navigationItem.rightBarButtonItem = editItem;

    
    BanBu_PhotoManager *photiView = [[BanBu_PhotoManager alloc] initWithPhotos:nil owner:self];
    _photoView = photiView;
    [self.tableView addSubview:photiView];
    [self.tableView setContentInset:UIEdgeInsetsMake(_photoView.contentViewHeight, 0, 0, 0)];
    [photiView release];
    
    _myProfile = [[NSMutableDictionary alloc] initWithDictionary:[BanBu_MyProfileViewController buildMyProfile:[UserDefaults valueForKey:MyAppDataManager.useruid]]];
//    NSLog(@"%@",_myProfile);
    if([_myProfile count])
    {
        _photoView.myPhotos = [_myProfile valueForKey:@"facelist"];
//        id faces = [_myProfile valueForKey:@"facelist"];
//        if([faces isKindOfClass:[NSArray class]])
//        {
//            if([faces count]){
//                _photoView.myPhotos = faces;
//                
//            }else{
//                _photoView.myPhotos = [NSArray arrayWithObject:[NSDictionary dictionaryWithObject:[_myProfile valueForKey:@"uface"] forKey:@"facefile"]];
//                
//            }
//        }

    }

        
    UIView  *headView = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 30)];
    headView.backgroundColor = [UIColor colorWithRed:255.0/255 green:250.0/255 blue:240.0/255 alpha:1.0];

    UILabel *sexLabel = [[UILabel alloc] initWithFrame:CGRectMake(10,5,20,20)];
    sexLabel.font = [UIFont systemFontOfSize:14];
    sexLabel.textAlignment = UITextAlignmentCenter;
    sexLabel.textColor = [UIColor whiteColor];
    sexLabel.layer.cornerRadius = 4.0f;
//    NSString *sex = [[myinfo valueForKey:@"gender"] isEqualToString:@"m"]?@"y":@"n";
//    data = [NSDictionary dictionaryWithObjectsAndKeys:@"y",@"DefaultValue",sex,@"realValue",@"0",@"showType",nil];
//    [myData setValue:data forKey:[titles objectAtIndex:0]];
//    data = [NSDictionary dictionaryWithObjectsAndKeys:@"24",@"DefaultValue",[myinfo valueForKey:@"oldyears"],@"realValue",@"0",@"showType",nil];
//    [myData setValue:data forKey:[titles objectAtIndex:1]];
//    data = [NSDictionary dictionaryWithObjectsAndKeys:@"巨蟹",@"DefaultValue",[myinfo valueForKey:@"sstar"],@"realValue",@"0",@"showType",nil];
//    [myData setValue:data forKey:[titles objectAtIndex:2]];
//    NSLog(@"%@",[[_myProfile valueForKey:@"gender"]valueForKey:@"realValue"] );
    if([[[_myProfile valueForKey:@"gender"]valueForKey:@"realValue"] boolValue])
    {
        sexLabel.backgroundColor = [UIColor colorWithRed:103.0/255 green:187.0/255 blue:1.0 alpha:1.0];
        sexLabel.text = @"♂";
    }
    else
    {
        sexLabel.backgroundColor = [UIColor colorWithRed:253.0/255 green:163.0/255 blue:200.0 alpha:1.0];
        sexLabel.text = @"♀";
    }
    [headView addSubview:sexLabel];
    [sexLabel release];
    
    titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, 0, 100, 30)];
    titleLabel.font = [UIFont systemFontOfSize:14];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textColor = [UIColor colorWithRed:56.0/255 green:84.0/255 blue:135.0/255 alpha:1.0];
//    NSLog(@"%@",[[_myProfile valueForKey:@"sstar"] valueForKey:@"realValue"]);
    titleLabel.text = [NSString stringWithFormat:@"%@ %@",[MyAppDataManager IsInternationalLanguage:[[_myProfile valueForKey:@"sstar"] valueForKey:@"realValue"]],[[_myProfile valueForKey:@"oldyears"] valueForKey:@"realValue"]];
    [headView addSubview:titleLabel];
    [titleLabel release];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 29, 320, 1.0)];
    lineView.backgroundColor = [UIColor colorWithRed:224.0/255 green:224.0/255 blue:224.0/255 alpha:1.0];
    [headView addSubview:lineView];
    [lineView release];
    
    self.tableView.tableHeaderView = headView;
    [headView release];
    
       
    _engine = [[WBEngine alloc] initWithAppKey:kWBSDKDemoAppKey appSecret:kWBSDKDemoAppSecret];
    [_engine setDelegate:self];
    [_engine setRootViewController:self];
    [_engine setRedirectURI:@"http://www.halfeet.com"];
    [_engine setIsUserExclusive:NO];
    
    //twitter
    FHSTwitterEngine * aEngine = [[FHSTwitterEngine alloc]initWithConsumerKey:@"2cZXkfmSC6UrPUkhSPtfwQ" andSecret:@"mdoijXeFbK6dGVs5C61rADMOWSgFdNtPOBsxgnKw"];

    self.twitterEngine = aEngine;
    [aEngine release];
    
}
 

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
//    [BanBu_MyProfileViewController buildMyProfile:[UserDefaults valueForKey:MyAppDataManager.useruid]];
//    titleLabel.text = [NSString stringWithFormat:@"%@ %@",[MyAppDataManager IsInternationalLanguage:[[_myProfile valueForKey:@"sstar"] valueForKey:@"realValue"]],[[_myProfile valueForKey:@"oldyears"] valueForKey:@"realValue"]];
//    
//    [self.tableView reloadData];
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    self.myProfile = nil;
}

- (void)dealloc
{
    [shareString release];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"abc" object:nil];
    [_myProfile release];
    [_editBuffer release];
    [_engine release];
    [super dealloc];
}

- (void)edit:(UIButton *)button
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3];
    self.tableView.contentOffset = CGPointMake(0, -125);
    [UIView commitAnimations];
    [_photoView setEdit:!_photoView.edit];
    _editting = _photoView.edit;
    [UIView animateWithDuration:0.5
                     animations:^{
                         if(self.tableView.contentOffset.y<0)
                             [self.tableView setContentOffset:CGPointMake(0, -_photoView.contentViewHeight) animated:NO];

                     } completion:^(BOOL finished) {
                         [self.tableView setContentInset:UIEdgeInsetsMake(_photoView.contentViewHeight, 0, 0, 0)];
                         if(!_editting)
                         {
                             if(_photoView.delPhotoArr.count || _photoView.addPhotoArr.count)
                             {
                                 UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"noticeNotice", <#comment#>)
                                                                                 message:NSLocalizedString(@"profileAlertNotice", nil)
                                                                                delegate:self
                                                                       cancelButtonTitle:NSLocalizedString(@"cancelNotice", nil)
                                                                       otherButtonTitles:NSLocalizedString(@"saveButton", nil), nil];
                                 [alert show];
                                 [alert release];
                             }
                         }

                     }];
    

    [button setTitle:_photoView.edit?NSLocalizedString(@"finishButton", nil):NSLocalizedString(@"editAvatar", nil) forState:UIControlStateNormal];
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
 
    
    [self.twitterEngine loadAccessToken];
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:3] withRowAnimation:UITableViewRowAnimationNone];
    //遍历是否有未审核的图片

    for(NSDictionary *photoDic in [_myProfile valueForKey:@"facelist"]){
        
        if([[photoDic valueForKey:@"facefile"] rangeOfString:@"verify"].location != NSNotFound){
            NSDictionary *parDic = [[[NSDictionary alloc]init]autorelease];
            [AppComManager getBanBuData:BanBu_Get_My_Facelist par:parDic delegate:self];
            
        }
    }
    
    
    
}

-(void)viewWillDisappear:(BOOL)animated
{
    
    [super viewWillDisappear:animated];
    [AppComManager cancalHandlesForObject:self];
    
    
}

#pragma mark - Twitter
- (void)storeAccessToken:(NSString *)accessToken {
    [[NSUserDefaults standardUserDefaults]setObject:accessToken forKey:@"SavedAccessHTTPBody"];
}

- (NSString *)loadAccessToken {
    return [[NSUserDefaults standardUserDefaults]objectForKey:@"SavedAccessHTTPBody"];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [[_myProfile valueForKey:@"sections"] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    return [[_myProfile valueForKey:[NSString stringWithFormat:@"%i",section]] count];
}

//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
//{
//    if(section == 1)
//        return @"基本信息";
//    else if(section == 2)
//        return @"个人介绍";
//    else if(section == 3)
//        return @"绑定信息";
//    return nil;
//    
//}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    
    
    UILabel *titleLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 30)];
    titleLabel1.backgroundColor = [UIColor lightGrayColor];
    titleLabel1.textColor = [UIColor whiteColor];
    titleLabel1.font = [UIFont boldSystemFontOfSize:14];
    if(section == 0)
        titleLabel1.text= NSLocalizedString(@"profileSection", nil);
    else if(section == 1)
        titleLabel1.text= NSLocalizedString(@"profileSection1", nil);
    else if(section == 2)
        titleLabel1.text= NSLocalizedString(@"profileSection2", nil);
    
    return [titleLabel1 autorelease];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    NSLog(@"%d,%d",indexPath.section,indexPath.row);

    NSString *cellTitle = [[_myProfile valueForKey:[NSString stringWithFormat:@"%i",indexPath.section]] objectAtIndex:indexPath.row];
    NSDictionary *adata = [_myProfile valueForKey:cellTitle];
    if(![[adata valueForKey:@"showType"] boolValue])
        return 40;
    
    NSString *detailValue = [adata valueForKey:@"realValue"];
    if(![detailValue stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length){
        detailValue = [adata valueForKey:@"DefaultValue"];
//        NSLog(@"%@%d,%d",detailValue,indexPath.section,indexPath.row);
        return [detailValue sizeWithFont:[UIFont systemFontOfSize:16] constrainedToSize:CGSizeMake(300, 1000)].height+30;
    }else{
//        NSLog(@"%@",detailValue);
        return [detailValue sizeWithFont:[UIFont systemFontOfSize:15] constrainedToSize:CGSizeMake(300, 1000)].height+30;
    }

}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if(section < 3){
        return 30;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
   static NSString *CellIdentifier = @"Cell";
      
    NSString *cellTitle = [[_myProfile valueForKey:[NSString stringWithFormat:@"%i",indexPath.section]] objectAtIndex:indexPath.row];
    NSDictionary *adata = [_myProfile valueForKey:cellTitle];
    
    BOOL showType = [[adata valueForKey:@"showType"] boolValue];
   
    UITableViewCell *cell = [[[UITableViewCell alloc] initWithStyle:showType?UITableViewCellStyleSubtitle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier] autorelease];
    cell.detailTextLabel.numberOfLines = 0;
    cell.textLabel.text = cellTitle;
    
    if(indexPath.section != 3)
    {    
        if([[adata valueForKey:@"canEdit"] boolValue])
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        else 
            cell.accessoryType = UITableViewCellAccessoryNone;
        
        NSString *detailValue = [adata valueForKey:@"realValue"];
//        NSLog(@"%@----%@",detailValue,[adata valueForKey:@"DefaultValue"]);
        if(![detailValue stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length)
        {
            detailValue = [adata valueForKey:@"DefaultValue"];
        }
        else 
            cell.detailTextLabel.textColor = [UIColor colorWithRed:56.0/255 green:84.0/255 blue:135.0/255 alpha:1.0];
        cell.detailTextLabel.text = detailValue;
//        if([cellTitle isEqualToString:@"性别"])
//        {
//            if([detailValue boolValue])
//            {
//                cell.detailTextLabel.textColor = [UIColor colorWithRed:103.0/255 green:187.0/255 blue:1.0 alpha:1.0];
//                cell.detailTextLabel.text = @"♂";
//            }
//            else
//            {
//                cell.detailTextLabel.textColor = [UIColor colorWithRed:253.0/255 green:163.0/255 blue:200.0 alpha:1.0];
//                cell.detailTextLabel.text = @"♀";
//            }
//        }
        
    }
    else 
    {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        NSString *langauage=[self getPreferredLanguage];
        if([langauage isEqual:@"zh-Hans"]){
            if(indexPath.row == 0)
            {
                NSString *sUser = [UserDefaults valueForKey:@"sinaUser"];
                //NSLog(@"%d",[[UserDefaults valueForKey:@"sinaUser"] isEqualToString:@""]);
                cell.detailTextLabel.text = [sUser isEqual:@""]?NSLocalizedString(@"weiboUnBing", nil):NSLocalizedString(@"weiboBing", nil);
                //NSLog(@"%@",[UserDefaults valueForKey:@"sinaUser"]);
                //			cell.detailTextLabel.text = ([_engine isLoggedIn] && ![_engine isAuthorizeExpired])?@"已绑定":@"未绑定";
            }
            else if(indexPath.row == 1)
            {
                NSString *qUser = [UserDefaults valueForKey:@"QUser"];
                cell.detailTextLabel.text = [qUser isEqual:@""]?NSLocalizedString(@"weiboUnBing", nil):NSLocalizedString(@"weiboBing", nil);
            }
        }else{
            
            if(indexPath.row == 0)
            {
                NSString *tUser = [UserDefaults valueForKey:@"TUser"];
                cell.detailTextLabel.text = [tUser isEqual:@""]?NSLocalizedString(@"weiboUnBing", nil):NSLocalizedString(@"weiboBing", nil);
                

            }else if(indexPath.row == 1){
                
                              NSString *sUser = [UserDefaults valueForKey:@"FBUser"];
                //NSLog(@"%d",[[UserDefaults valueForKey:@"sinaUser"] isEqualToString:@""]);
                cell.detailTextLabel.text = [sUser isEqual:@""]?NSLocalizedString(@"weiboUnBing", nil):NSLocalizedString(@"weiboBing", nil);
                //NSLog(@"%@",[UserDefaults valueForKey:@"sinaUser"]);
                //			cell.detailTextLabel.text = ([_engine isLoggedIn] && ![_engine isAuthorizeExpired])?@"已绑定":@"未绑定";

            }
            
            
        }
        
        
    }
    if(indexPath.section == 1){
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }else {
        if(indexPath.section == 0 &&indexPath.row ==0){
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }else{
            cell.selectionStyle = UITableViewCellSelectionStyleBlue;
            
        }
    }
    if(indexPath.section == 1){
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }else {
        if(indexPath.section == 0 &&indexPath.row ==0){
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }else{
            cell.selectionStyle = UITableViewCellSelectionStyleBlue;
            
        }
    }
    return cell;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellTitle = [[_myProfile valueForKey:[NSString stringWithFormat:@"%i",indexPath.section]] objectAtIndex:indexPath.row];
//    NSDictionary *adata = [_myProfile valueForKey:cellTitle];
    
    if(indexPath.section == 3)
    {
        NSString *langauage=[self getPreferredLanguage];
        if([langauage isEqual:@"zh-Hans"]){
            if(indexPath.row){
                
                if([[UserDefaults valueForKey:@"QUser"] isEqualToString:@""]){
                    
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"bangdingTX", nil)
                                                                    message:nil
                                                                   delegate:self
                                                          cancelButtonTitle:NSLocalizedString(@"cancelNotice", nil)
                                                          otherButtonTitles:NSLocalizedString(@"confirmNotice", nil), nil];
                    alert.tag = 101;
                    [alert show];
                    [alert release];
                    
                }else{
                    
                    [tableView deselectRowAtIndexPath:indexPath animated:YES];
                    [self bindingWeibo:indexPath.row];
                    
                }
                
            }else{
                
                if([[UserDefaults valueForKey:@"sinaUser"] isEqualToString:@""]){
                    
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"bangdingSina", nil)
                                                                    message:nil
                                                                   delegate:self
                                                          cancelButtonTitle:NSLocalizedString(@"cancelNotice", nil)
                                                          otherButtonTitles:NSLocalizedString(@"confirmNotice", nil), nil];
                    alert.tag = 101;
                    [alert show];
                    [alert release];
                    
                }else{
                    
                    [tableView deselectRowAtIndexPath:indexPath animated:YES];
                    [self bindingWeibo:indexPath.row];
                }
                
            }

        }
        else{
            if(indexPath.row){
                if([[UserDefaults valueForKey:@"FBUser"] isEqualToString:@""]){
                    
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Connect to Facebook"
                                                                    message:nil
                                                                   delegate:self
                                                          cancelButtonTitle:NSLocalizedString(@"cancelNotice", nil)
                                                          otherButtonTitles:NSLocalizedString(@"confirmNotice", nil), nil];
                    alert.tag = 101;
                    [alert show];
                    [alert release];
                    
                }else{
                    
                    [tableView deselectRowAtIndexPath:indexPath animated:YES];
                    if(![[UserDefaults valueForKey:@"FBUser"] isEqual:@""])
                    {
                        
                        UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"FaceBook"
                                                                           delegate:self
                                                                  cancelButtonTitle:NSLocalizedString(@"cancelNotice", nil)
                                                             destructiveButtonTitle:nil
                                                                  otherButtonTitles:NSLocalizedString(@"reBinding", nil),nil];
                        //            sheet.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
                        //            [sheet showFromTabBar:self.navigationController.tabBarController.tabBar];
                        [sheet showInView:self.view.window];
                        [sheet release];
                        
                    }
                    
                    else
                    {
                        [MyAppDelegate openSessionWithAllowLoginUI:YES];
                    }
                }

            }else{
                if([[UserDefaults valueForKey:@"TUser"] isEqualToString:@""]){
                    
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Connect to Twitter"
                                                                    message:nil
                                                                   delegate:self
                                                          cancelButtonTitle:NSLocalizedString(@"cancelNotice", nil)
                                                          otherButtonTitles:NSLocalizedString(@"confirmNotice", nil), nil];
                    alert.tag = 101;
                    [alert show];
                    [alert release];
                    
                }else{
                    
                    [tableView deselectRowAtIndexPath:indexPath animated:YES];
                    if(![[UserDefaults valueForKey:@"TUser"] isEqual:@""])
                    {
                        
                        UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"Twitter"
                                                                           delegate:self
                                                                  cancelButtonTitle:NSLocalizedString(@"cancelNotice", nil)
                                                             destructiveButtonTitle:nil
                                                                  otherButtonTitles:NSLocalizedString(@"reBinding", nil),nil];
                        //            sheet.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
                        //            [sheet showFromTabBar:self.navigationController.tabBarController.tabBar];
                        [sheet showInView:self.view.window];
                        [sheet release];
                        
                    }
                    
                    else
                    {

                    }
                }

            }
                        

            
        }

    
        
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:indexPath.row?NSLocalizedString(@"bangdingTX", nil):NSLocalizedString(@"bangdingSina", nil)
//                                                        message:nil
//                                                       delegate:self
//                                              cancelButtonTitle:NSLocalizedString(@"cancelNotice", nil)
//                                              otherButtonTitles:NSLocalizedString(@"confirmNotice", nil), nil];
//        alert.tag = 101;
//        [alert show];
//        [alert release];

//        [self.tableView deselectRowAtIndexPath:indexPath animated:YES];


    }
    else 
    {
        if([cellTitle isEqualToString:NSLocalizedString(@"s0c1", nil)])
        {
//            BanBu_NameAndSexController *name = [[BanBu_NameAndSexController alloc] initWithViewType:NameAndSexViewNameOnlyType];
//            [self.navigationController pushViewController:name animated:YES];
//            name.name = [adata valueForKey:@"realValue"];
//            [name release];
            BanBu_ZibarController *zibar = [[BanBu_ZibarController alloc]init];
            
            zibar.hidesBottomBarWhenPushed=YES;
            
            [self.navigationController pushViewController:zibar animated:YES];
            
            [zibar release];
    
        }
        else if([cellTitle isEqualToString:NSLocalizedString(@"s2c3", nil)]){
            NSString *zhiyeStr = [[_myProfile valueForKey:cellTitle] valueForKey:@"realValue"];
            NSArray *workArr =  [[NSArray alloc] initWithObjects:NSLocalizedString(@"workItem", nil),NSLocalizedString(@"workItem1", nil),NSLocalizedString(@"workItem2", nil),NSLocalizedString(@"workItem3", nil),NSLocalizedString(@"workItem4", nil),NSLocalizedString(@"workItem5", nil),NSLocalizedString(@"workItem6", nil),NSLocalizedString(@"workItem7", nil),NSLocalizedString(@"workItem8", nil),NSLocalizedString(@"workItem9", nil),NSLocalizedString(@"workItem10", nil), nil];
            
            if([zhiyeStr isEqualToString:@""]){
                BanBu_WorkViewController *work = [[BanBu_WorkViewController alloc]initWithWorkInfo:@"" type:0];
                work.delegate = self;
                [self.navigationController pushViewController:work animated:YES];
                [work release];
            }else{
                //NSLog(@"%@",zhiyeStr);
                NSArray *doubleArr = [NSArray arrayWithArray:[zhiyeStr componentsSeparatedByString:@"-"]];
                //NSLog(@"%@",doubleArr);
                for (int i =0 ; i<workArr.count; i++) {
                    if([[doubleArr objectAtIndex:0] isEqualToString:[workArr objectAtIndex:i]]){
                        _workType = i;
                        break;

                    }
                }
                BanBu_WorkViewController *work = [[BanBu_WorkViewController alloc]initWithWorkInfo:[doubleArr objectAtIndex:1] type:_workType];
                work.delegate = self;
                [self.navigationController pushViewController:work animated:YES];
                [work release];
            }
            
          
        }
        else
        {
            NSString *cellTitle = [[_myProfile valueForKey:[NSString stringWithFormat:@"%i",indexPath.section]] objectAtIndex:indexPath.row];
            NSDictionary *adata = [_myProfile valueForKey:cellTitle];
            if([[adata valueForKey:@"canEdit"] boolValue])
            {
                
                BanBu_TextEditer *editer;
                /*将个人资料未做多语言存储就出问题了，要注释掉下边的语句，当初为啥添的忘了。*/
                //因为英文的名字太长了。。。
//                if(indexPath.section == 0){
//                    cellTitle = @"Signature";
//                }
//                if(indexPath.section == 2){
//                    if(indexPath.row == 0){
//                        cellTitle = @"Interests";
//                    } 
//                }
                
                editer = [[BanBu_TextEditer alloc] initWithTitle:cellTitle oldText:[adata valueForKey:@"realValue"] description:[adata valueForKey:@"DefaultValue"]];

                
                editer.delegate = self;
                [self.navigationController pushViewController:editer animated:YES];
                [editer release];
            }
            else
                [tableView deselectRowAtIndexPath:indexPath animated:YES];
        }
        
        
        
    }
}


-(void)bindingWeibo:(NSInteger)weiboType
{
    //0 sina  1  tengxun
	if(!weiboType)
	{
        if(![[UserDefaults valueForKey:@"sinaUser"] isEqual:@""])
        {
            
            UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:NSLocalizedString(@"sinaSheetTitle", nil)
                                                               delegate:self
                                                      cancelButtonTitle:NSLocalizedString(@"cancelNotice", nil)
                                                 destructiveButtonTitle:nil
                                                      otherButtonTitles:NSLocalizedString(@"reBinding", nil),nil];
//            sheet.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
//            [sheet showFromTabBar:self.navigationController.tabBarController.tabBar];
            [sheet showInView:self.view.window];
            [sheet release];
            
        }
        
		else
		{
            [_engine logOut];
            [_engine logIn];
		}
		
	}
	else
	{
        if(![[UserDefaults valueForKey:@"QUser"] isEqual:@""])
        {
            UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:NSLocalizedString(@"TXSheetTitle", nil)
                                                               delegate:self
                                                      cancelButtonTitle:NSLocalizedString(@"cancelNotice", nil)
                                                 destructiveButtonTitle:nil
                                                      otherButtonTitles:NSLocalizedString(@"reBinding", nil),nil];
//            sheet.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
//            [sheet showFromTabBar:self.navigationController.tabBarController.tabBar];
            [sheet showInView:self.view.window];

            [sheet release];

        }

		else 
        {
			QVerifyWebViewController *qverify = [[QVerifyWebViewController alloc] init];
            qverify.delegate = self;
			[self presentModalViewController:qverify animated:YES];
			[qverify release];
		}
	}
    
}

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if([actionSheet.title isEqualToString:NSLocalizedString(@"sinaSheetTitle", nil)])
    {
        if(buttonIndex == actionSheet.firstOtherButtonIndex)
        {
            [_engine logOut];
            NSMutableDictionary *pars = [NSMutableDictionary dictionaryWithCapacity:2];
            [pars setValue:@"sina_wei" forKey:@"bindto"];
            //            [pars setValue:[NSString stringWithFormat:@"%@,%@",nil,@""] forKey:@"bindstring"];
            [pars setValue:@"" forKey:@"bindstring"];
            
            [AppComManager getBanBuData:BanBu_Set_User_accountbind par:pars delegate:self];
            
            [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:3] withRowAnimation:UITableViewRowAnimationNone];
        }
    }
    else if([actionSheet.title isEqualToString:NSLocalizedString(@"TXSheetTitle", nil)])
    {
        if(buttonIndex == actionSheet.firstOtherButtonIndex)
        {
            [UserDefaults removeObjectForKey:AppTokenKey];
            [UserDefaults removeObjectForKey:AppTokenSecret];
            [UserDefaults setValue:@"" forKey:@"QUser"];
            [user synchronize];
            
            NSMutableDictionary *pars = [NSMutableDictionary dictionaryWithCapacity:2];
            [pars setValue:@"ten_weib" forKey:@"bindto"];
            //            [pars setValue:[NSString stringWithFormat:@"%@,%@,%@",nil,nil,@""] forKey:@"bindstring"];
            [pars setValue:@"" forKey:@"bindstring"];
            
            [AppComManager getBanBuData:BanBu_Set_User_accountbind par:pars delegate:self];
            [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:3] withRowAnimation:UITableViewRowAnimationNone];            
        }
    }
    else if([actionSheet.title isEqualToString:@"FaceBook"])
    {
        if(buttonIndex == actionSheet.firstOtherButtonIndex){
            [[FBSession activeSession] closeAndClearTokenInformation];
            [UserDefaults setValue:@"" forKey:@"FBUser"];
            NSMutableDictionary *pars = [NSMutableDictionary dictionaryWithCapacity:2];
            [pars setValue:@"facebook" forKey:@"bindto"];
            //            [pars setValue:[NSString stringWithFormat:@"%@,%@",nil,@""] forKey:@"bindstring"];
            [pars setValue:@"" forKey:@"bindstring"];
            
            [AppComManager getBanBuData:BanBu_Set_User_accountbind par:pars delegate:self];
            
            [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:3] withRowAnimation:UITableViewRowAnimationNone];
        }
        
    }
    else if([actionSheet .title isEqualToString:@"Twitter"])
    {
        if(buttonIndex == actionSheet.firstOtherButtonIndex){
            [self.twitterEngine clearAccessToken];
            [UserDefaults setValue:@"" forKey:@"TUser"];
            NSMutableDictionary *pars = [NSMutableDictionary dictionaryWithCapacity:2];
            [pars setValue:@"twitter" forKey:@"bindto"];
            //            [pars setValue:[NSString stringWithFormat:@"%@,%@",nil,@""] forKey:@"bindstring"];
            [pars setValue:@"" forKey:@"bindstring"];
            
            [AppComManager getBanBuData:BanBu_Set_User_accountbind par:pars delegate:self];
            
            [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:3] withRowAnimation:UITableViewRowAnimationNone];

            
        }
    }
}

- (void)getSinaUserName
{
    [_engine loadRequestWithMethodName:@"users/show.json"
                            httpMethod:@"GET"
                                params:[NSDictionary dictionaryWithObjectsAndKeys:_engine.userID,@"uid",_engine.accessToken,@"access_token",nil]
                          postDataType:kWBRequestPostDataTypeNone
                      httpHeaderFields:nil];
}

//- (void)engineDidLogIn:(WBEngine *)engine
//{
//  [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:3] withRowAnimation:UITableViewRowAnimationNone];
//    [self getSinaUserName];
//}
//
//- (void)engineDidLogOut:(WBEngine *)engine
//{
//    [user removeObjectForKey:@"sinaUser"];
//}
//
//- (void)engine:(WBEngine *)engine requestDidFailWithError:(NSError *)error
//{
//    [TKLoadingView showTkloadingAddedTo:self.navigationController.view title:[error domain] activityAnimated:NO];
//    [TKLoadingView dismissTkFromView:self.navigationController.view animated:YES afterShow:1.5f];
//    
//}
//- (void)engine:(WBEngine *)engine requestDidSucceedWithResult:(id)result
//{
//    NSString *name = [result valueForKey:@"screen_name"];
//    if(name)
//    {
//        [user setValue:name forKey:@"sinaUser"];
//        [user synchronize];
//    }
//}


- (void)qVerifyWebViewControllerDidDismiss:(QVerifyWebViewController *)qVerifyWebViewController
{
   // [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:3] withRowAnimation:UITableViewRowAnimationNone];

}
// 获取当前机器语言
-(NSString*)getPreferredLanguage
{
    NSUserDefaults* defs = [NSUserDefaults standardUserDefaults];
    NSArray* languages = [defs objectForKey:@"AppleLanguages"];
    NSString* preferredLang = [languages objectAtIndex:0];
    return preferredLang;
}

+ (NSDictionary *)buildMyProfile:(NSDictionary *)dataDic
{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    NSMutableDictionary *myData = [[NSMutableDictionary alloc] initWithCapacity:1];
//    NSArray *titles = [NSArray arrayWithObjects:NSLocalizedString(@"s0c0", nil),NSLocalizedString(@"s0c1", nil),NSLocalizedString(@"s0c2", nil), nil];
    NSArray *titles = [NSArray arrayWithObjects:NSLocalizedString(@"s0c0", nil),NSLocalizedString(@"s0c2", nil), nil];

    [myData setValue:titles forKey:@"0"];
    NSDictionary *data = [NSDictionary dictionaryWithObjectsAndKeys:@"",@"DefaultValue",[dataDic valueForKey:@"userid"],@"realValue",@"0",@"showType",nil];
    [myData setValue:data forKey:[titles objectAtIndex:0]];
 //    data = [NSDictionary dictionaryWithObjectsAndKeys:@"",@"DefaultValue",@"",@"realValue",@"0",@"showType",@"1",@"canEdit",nil];
//    [myData setValue:data forKey:[titles objectAtIndex:1]];
  
    data = [NSDictionary dictionaryWithObjectsAndKeys:NSLocalizedString(@"s0c2DefaluteValue", nil),@"DefaultValue",[dataDic valueForKey:@"sayme"],@"realValue",@"1",@"showType",@"1",@"canEdit",nil];
    [myData setValue:data forKey:[titles objectAtIndex:1]];
    
    //1 section
    titles = [NSArray arrayWithObjects:NSLocalizedString(@"s1c0", nil),NSLocalizedString(@"s1c1", nil),NSLocalizedString(@"s1c2", nil),nil] ;
    [myData setValue:titles forKey:@"1"];
    
    NSString *sex = [[dataDic valueForKey:@"gender"] isEqualToString:@"m"]?@"y":@"n";
    data = [NSDictionary dictionaryWithObjectsAndKeys:@"y",@"DefaultValue",sex,@"realValue",@"0",@"showType",nil];
    [myData setValue:data forKey:@"gender"];
    data = [NSDictionary dictionaryWithObjectsAndKeys:@"",@"DefaultValue",[dataDic valueForKey:@"oldyears"],@"realValue",@"0",@"showType",nil];
    [myData setValue:data forKey:@"oldyears"];
    data = [NSDictionary dictionaryWithObjectsAndKeys:@"",@"DefaultValue",[dataDic valueForKey:@"sstar"],@"realValue",@"0",@"showType",nil];
    [myData setValue:data forKey:@"sstar"];
    
    
    
    
//    NSArray *heightArr = [NSArray arrayWithObjects:@"a",@"b",@"c",@"d",@"e",@"<160",@"160-165",@"165-170",@"170-175",@">175", nil];
//    NSArray *weightArr = [NSArray arrayWithObjects:@"a",@"b",@"c",@"d",@"e",@"<40",@"40-50",@"50-60",@"60-70",@">70", nil];
    
    data = [NSDictionary dictionaryWithObjectsAndKeys:@"",@"DefaultValue",[dataDic valueForKey:@"hbody"],@"realValue",@"0",@"showType",nil];
    [myData setValue:data forKey:[titles objectAtIndex:0]];
    data = [NSDictionary dictionaryWithObjectsAndKeys:@"",@"DefaultValue",[dataDic valueForKey:@"xblood"],@"realValue",@"0",@"showType",nil];
    [myData setValue:data forKey:[titles objectAtIndex:1]];
    data = [NSDictionary dictionaryWithObjectsAndKeys:@"24",@"DefaultValue",[dataDic valueForKey:@"wbody"],@"realValue",@"0",@"showType",nil];
    [myData setValue:data forKey:[titles objectAtIndex:2]];
    
    
    //2 section
    titles = [NSArray arrayWithObjects:NSLocalizedString(@"s2c0", nil),NSLocalizedString(@"s2c1", nil),NSLocalizedString(@"s2c2", nil),NSLocalizedString(@"s2c3", nil),NSLocalizedString(@"s2c4", nil), nil];
    [myData setValue:titles forKey:@"2"];
    
    data = [NSDictionary dictionaryWithObjectsAndKeys:NSLocalizedString(@"s2c0DefaluteValue", nil),@"DefaultValue",[dataDic valueForKey:@"liked"],@"realValue",@"1",@"showType",@"1",@"canEdit",nil];

    [myData setValue:data forKey:[titles objectAtIndex:0]];
    data = [NSDictionary dictionaryWithObjectsAndKeys:NSLocalizedString(@"s2c1DefaluteValue", nil),@"DefaultValue",[dataDic valueForKey:@"lovego"],@"realValue",@"1",@"showType",@"1",@"canEdit",nil];

    [myData setValue:data forKey:[titles objectAtIndex:1]];
    data = [NSDictionary dictionaryWithObjectsAndKeys:NSLocalizedString(@"s2c2DefaluteValue", nil),@"DefaultValue",[dataDic valueForKey:@"company"],@"realValue",@"1",@"showType",@"1",@"canEdit",nil];

    [myData setValue:data forKey:[titles objectAtIndex:2]];
    
    data = [NSDictionary dictionaryWithObjectsAndKeys:NSLocalizedString(@"s2c3DefaluteValue", nil),@"DefaultValue",[dataDic valueForKey:@"jobtitle"],@"realValue",@"1",@"showType",@"1",@"canEdit",nil];

    [myData setValue:data forKey:[titles objectAtIndex:3]];
    data = [NSDictionary dictionaryWithObjectsAndKeys:NSLocalizedString(@"s2c4DefaluteValue", nil),@"DefaultValue",[dataDic valueForKey:@"school"],@"realValue",@"1",@"showType",@"1",@"canEdit",nil];

    [myData setValue:data forKey:[titles objectAtIndex:4]];
//    data = [NSDictionary dictionaryWithObjectsAndKeys:@"关于你的更多说明",@"DefaultValue",[dataDic valueForKey:@"sayme"],@"realValue",@"1",@"showType",@"1",@"canEdit",nil];
//    [myData setValue:data forKey:[titles objectAtIndex:4]];
    
    //3 section
    NSUserDefaults* defs = [NSUserDefaults standardUserDefaults];
    NSArray* languages = [defs objectForKey:@"AppleLanguages"];
    NSString* preferredLang = [languages objectAtIndex:0];
    if([preferredLang isEqual:@"zh-Hans"]){
        titles = [NSArray arrayWithObjects:NSLocalizedString(@"s3c0", nil),NSLocalizedString(@"s3c1", nil), nil];
        [myData setValue:titles forKey:@"3"];
        data = [NSDictionary dictionaryWithObjectsAndKeys:@"0",@"realValue",@"0",@"showType",nil];
        [myData setValue:data forKey:[titles objectAtIndex:0]];
        data = [NSDictionary dictionaryWithObjectsAndKeys:@"0",@"realValue",@"0",@"showType",nil];
        [myData setValue:data forKey:[titles objectAtIndex:1]];
    }else{
        titles = [NSArray arrayWithObjects:@"Twitter",@"Facebook", nil];
        [myData setValue:titles forKey:@"3"];
        data = [NSDictionary dictionaryWithObjectsAndKeys:@"0",@"realValue",@"0",@"showType",nil];
        [myData setValue:data forKey:[titles objectAtIndex:0]];
        data = [NSDictionary dictionaryWithObjectsAndKeys:@"0",@"realValue",@"0",@"showType",nil];
        [myData setValue:data forKey:[titles objectAtIndex:1]];

        
    }

    

    id faces = [dataDic valueForKey:@"facelist"];
    if([faces isKindOfClass:[NSArray class]])
    {
        [myData setValue:faces forKey:@"facelist"];

    }
    
    [myData setValue:[NSArray arrayWithObjects:@"0",@"1",@"2",@"3", nil] forKey:@"sections"];
    [myData setValue:[dataDic valueForKey:@"userid"] forKey:@"userid"];
    [myData setValue:[dataDic valueForKey:@"uface"] forKey:KeyUface];

    [pool drain];
    
//    NSLog(@"%@",myData);
    return [myData autorelease];
}


- (void)banbuRequestDidFinished:(NSDictionary *)resDic error:(NSError *)error
{
    self.navigationController.view.userInteractionEnabled = YES;
    [TKLoadingView dismissTkFromView:self.navigationController.view animated:YES afterShow:0.0];
    if(error)
    {
        if([AppComManager respondsDic:resDic isFunctionData:BanBu_Del_My_Avatar] || [AppComManager respondsDic:resDic isFunctionData:BanBu_Upload_My_Photos])
        {
            [_photoView clearEditData];
            _photoView.myPhotos = [_myProfile valueForKey:@"facelist"];
        }
        if([error.domain isEqualToString:BanBuDataformatError])
        {
            [TKLoadingView showTkloadingAddedTo:self.view title:NSLocalizedString(@"data_error", nil) activityAnimated:NO duration:2.0];
        }
        else
        {
            [TKLoadingView showTkloadingAddedTo:self.view title:NSLocalizedString(@"network_error", nil) activityAnimated:NO duration:2.0];
        }
        return;
    }

    if([AppComManager respondsDic:resDic isFunctionData:BanBu_Set_My_Info])
    {
        if([[resDic valueForKey:@"ok"] boolValue])
        {
            
            NSLog(@"%@---%@",[[_editBuffer allValues] lastObject],[[_editBuffer allKeys] lastObject]);
            NSMutableDictionary *infoUpdata = [NSMutableDictionary dictionaryWithDictionary:[UserDefaults valueForKey:MyAppDataManager.useruid]];
            
            [infoUpdata setValue:[[_editBuffer allValues] lastObject] forKey:[[_editBuffer allKeys] lastObject]];
            
            [UserDefaults setValue:infoUpdata forKey:MyAppDataManager.useruid];
            [UserDefaults synchronize];

#warning 未完成的个人资料分享
            NSString *langauage=[[MyAppDataManager getPreferredLanguage]substringToIndex:2];
            
            if(![langauage isEqual:@"zh"]){
                NSLog(@"%@",shareString);
                //分享修改后的资料
                
                if([[UserDefaults valueForKey:@"TUser"] length]){
                    FHSTwitterEngine * aEngine = [[[FHSTwitterEngine alloc]initWithConsumerKey:@"2cZXkfmSC6UrPUkhSPtfwQ" andSecret:@"mdoijXeFbK6dGVs5C61rADMOWSgFdNtPOBsxgnKw"]autorelease];
                    [aEngine loadAccessToken];
                    dispatch_async(GCDBackgroundThread, ^{
                        @autoreleasepool {
                            
                            //发送的内容
                            [aEngine postTweet:shareString];
                            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                            dispatch_sync(GCDMainThread, ^{
                                
                            });
                        }
                    });
                    
                }
//                /*
                if([[UserDefaults valueForKey:@"FBUser"] length]){
                                        
                    BOOL displayedNativeDialog = [FBNativeDialogs presentShareDialogModallyFrom:self
                                                                                    initialText:nil
                                                                                          image:nil
                                                                                            url:nil
                                                                                        handler:nil];
                    if (!displayedNativeDialog) {
                        
                        [self performPublishAction:^{
                            
                            [FBRequestConnection startForPostStatusUpdate:shareString
                                                        completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
                                                            
                                                        }];
                        }];
                    }else{
//                        [self openSessionWithAllowLoginUI:YES];
//                        NSArray *permission = [[NSArray alloc]initWithObjects:@"publish_actions", nil];
//                        [FBSession openActiveSessionWithPublishPermissions:permission defaultAudience:FBSessionDefaultAudienceFriends allowLoginUI:YES completionHandler:^(FBSession *session, FBSessionState status, NSError *error) {
//                            ;
//                        }];
                     
                    }
                    
                }
//                */
                
            }
           
            NSDictionary *mapDic = [NSDictionary dictionaryWithObjectsAndKeys:NSLocalizedString(@"s0c2", nil),@"sayme",NSLocalizedString(@"s2c0", nil),@"liked",NSLocalizedString(@"s2c1", nil),@"lovego",NSLocalizedString(@"s2c2", nil),@"company",NSLocalizedString(@"s2c3", nil),@"jobtitle",NSLocalizedString(@"s2c4", nil),@"school",nil];
            for(NSString *key in [_editBuffer allKeys])
            {
                NSMutableDictionary *item = [NSMutableDictionary dictionaryWithDictionary:[_myProfile valueForKey:[mapDic valueForKey:key]]];
                [item setValue:[MyAppDataManager IsMinGanWord:[_editBuffer valueForKey:key]] forKey:@"realValue"];
                [_myProfile setValue:item forKey:[mapDic valueForKey:key]];
            }
//            [UserDefaults setValue:_myProfile forKey:MyProfile];
//            [UserDefaults synchronize];
//            NSLog(@"%@",_myProfile);
 
            self.editBuffer = nil;
            [self.tableView reloadData];

        }
        else{
            if([[resDic valueForKey:@"error"] isEqualToString:@"__loginidinvalid__"]){
                [self.navigationController popToRootViewControllerAnimated:NO];
                
            }
        }
        

    }
    else if([AppComManager respondsDic:resDic isFunctionData:BanBu_Del_My_Avatar])
    {
        _photoView.delPhotoArr = nil;
        //NSLog(@"%@",resDic);
        if(![[resDic valueForKey:@"ok"] boolValue]){
            
            _photoView.myPhotos = [[_myProfile valueForKey:@"facelist"]objectAtIndex:0];

        }else{

            if([[resDic valueForKey:@"error"] isEqualToString:@"__loginidinvalid__"]){
                [self.navigationController popToRootViewControllerAnimated:NO];
                
            }
            [TKLoadingView showTkloadingAddedTo:self.navigationController.view title:NSLocalizedString(@"updateAvatarSuccess", nil) activityAnimated:NO duration:1.0];
 
            //更新本地文件字典用用户useruid关键字的字典
            NSMutableDictionary *faceidUpdata = [NSMutableDictionary dictionaryWithDictionary:[UserDefaults valueForKey:MyAppDataManager.useruid]];
            if([[resDic valueForKey:@"facelist"]count]){
                [faceidUpdata setValue:[resDic valueForKey:@"facelist"] forKey:@"facelist"];
                [faceidUpdata setValue:[[[resDic valueForKey:@"facelist"]objectAtIndex:0] valueForKey:@"facefile"] forKey:@"uface"];
            }
            [UserDefaults setValue:faceidUpdata forKey:MyAppDataManager.useruid];
            //同步
            [UserDefaults synchronize];
//            NSLog(@"%@",[UserDefaults valueForKey:MyAppDataManager.useruid]);
            //如果添加头像数组为空的话 开始设置用户头像，防止用户仅剩一张头像添加一张删除一张头像造成的删除先完成而取不到头像的bug
            if(_photoView.addPhotoArr.count == 0)
            MyAppDataManager.userAvatar = [[UserDefaults valueForKey:MyAppDataManager.useruid] valueForKey:@"uface"];


        }
        if(_photoView.addPhotoArr.count){
            
            [TKLoadingView showTkloadingAddedTo:self.navigationController.view title:NSLocalizedString(@"sendAvater", nil) activityAnimated:YES];

        }
 
    }
    else if([AppComManager respondsDic:resDic isFunctionData:BanBu_Upload_My_Photos]){
//        NSLog(@"%@",resDic);
        [_photoView clearEditData];
        if([[resDic valueForKey:@"ok"]boolValue]){
 
//            NSString *msg = [NSString stringWithFormat:@"头像更新完成:%i失败/%i完成",[[resDic valueForKey:@"failNum"] intValue],[[resDic valueForKey:@"successNum"] intValue]];
//            [TKLoadingView showTkloadingAddedTo:self.navigationController.view title:msg activityAnimated:NO duration:2.0f];
            if(![[resDic valueForKey:@"successNum"] integerValue]){
                _photoView.myPhotos = [_myProfile valueForKey:@"facelist"];

            }
            else
            {

                //更新本地文件字典用用户useruid关键字的字典
                NSMutableDictionary *faceidUpdata = [NSMutableDictionary dictionaryWithDictionary:[UserDefaults valueForKey:MyAppDataManager.useruid]];
                [faceidUpdata setValue:[resDic valueForKey:@"facelist"] forKey:@"facelist"];
                [faceidUpdata setValue:[[[resDic valueForKey:@"facelist"]objectAtIndex:0] valueForKey:@"facefile"] forKey:@"uface"];
                [UserDefaults setValue:faceidUpdata forKey:MyAppDataManager.useruid];

                //开始同步
                [UserDefaults synchronize];
            }
        }
#warning 传头像的分享
        //上传头像的分享
        NSString *langauage=[[MyAppDataManager getPreferredLanguage]substringToIndex:2];
        
        if(![langauage isEqual:@"zh"]){
             //分享修改后的资料
            
            if([[UserDefaults valueForKey:@"TUser"] length]){
                FHSTwitterEngine * aEngine = [[[FHSTwitterEngine alloc]initWithConsumerKey:@"yrGeGrsKPfiGoMcCMVCcJA" andSecret:@"DgEMm4H6BkD6d7QSCzDaZFf6mB3mr7CKLqxlD88bxY"]autorelease];
                [aEngine loadAccessToken];
                dispatch_async(GCDBackgroundThread, ^{
                    @autoreleasepool {
                        
                        //发送的内容
                        [aEngine postTweet:NSLocalizedString(@"photoShare", nil)];
                        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                        dispatch_sync(GCDMainThread, ^{
                            
                        });
                    }
                });
                
            }
    
            if([[UserDefaults valueForKey:@"FBUser"] length]){
                
                
                
                BOOL displayedNativeDialog = [FBNativeDialogs presentShareDialogModallyFrom:self
                                                                                initialText:nil
                                                                                      image:nil
                                                                                        url:nil
                                                                                    handler:nil];
                if (!displayedNativeDialog) {
                    
                    [self performPublishAction:^{
                        
                        [FBRequestConnection startForPostStatusUpdate:NSLocalizedString(@"photoShare", nil)
                                                    completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
                                                        
                                                     }];
                    }];
                }
                
            }
    
                          
        }
        
        
        //修改第三处缓存
        MyAppDataManager.userAvatar = [[UserDefaults valueForKey:MyAppDataManager.useruid] valueForKey:@"uface"];

        [TKLoadingView showTkloadingAddedTo:self.navigationController.view title:NSLocalizedString(@"updateAvatarSuccess", nil) activityAnimated:NO duration:1.0];

    }
    else if([AppComManager respondsDic:resDic isFunctionData:BanBu_Set_User_accountbind]){
        if([[resDic valueForKey:@"ok"]boolValue]){
            //NSLog(@"%@",resDic);
            [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:3] withRowAnimation:UITableViewRowAnimationNone];
            NSString *langauage=[self getPreferredLanguage];
            if([langauage isEqual:@"zh-Hans"]){
                [TKLoadingView showTkloadingAddedTo:self.navigationController.view title:NSLocalizedString(@"reBindingSuccess", nil) activityAnimated:NO duration:2.0];

            }else{
                if([[UserDefaults valueForKey:@"FBUser"]isEqualToString:@""] || [[UserDefaults valueForKey:@"TUser"]isEqualToString:@""]){
                    [TKLoadingView showTkloadingAddedTo:self.navigationController.view title:NSLocalizedString(@"reBindingSuccess", nil) activityAnimated:NO duration:2.0];

                }

            }
            NSLog(@"%@",resDic);
            
            NSMutableDictionary *bindUpdata = [NSMutableDictionary dictionaryWithDictionary:[UserDefaults valueForKey:MyAppDataManager.useruid]];
            
            [bindUpdata setValue:[resDic valueForKey:@"bindlist"] forKey:@"bindlist"];
            
            [UserDefaults setValue:bindUpdata forKey:MyAppDataManager.useruid];
            
        }
        else{
            if([[resDic valueForKey:@"error"] isEqualToString:@"__loginidinvalid__"]){
                [self.navigationController popToRootViewControllerAnimated:NO];
            }
        }
    }
    else if([AppComManager respondsDic:resDic isFunctionData:BanBu_Get_My_Facelist]){
        
        if([[resDic valueForKey:@"ok"] boolValue]){
//            NSLog(@"%@",resDic);
            _photoView.myPhotos = [resDic valueForKey:@"facelist"];
//            NSMutableDictionary*faceUpdate = [NSMutableDictionary dictionaryWithDictionary:[UserDefaults valueForKey:MyProfile]];
//            [faceUpdate setValue:[resDic valueForKey:@"facelist"] forKey:@"facelist"];
//            [UserDefaults setValue:faceUpdate forKey:MyProfile];
//            [UserDefaults synchronize];
        }
    }
    
}

- (void)banBuTextEditerDidChangeValue:(NSString *)newValue forItem:(NSString *)item
{
    NSLog(@"%@-----%@",newValue,item);
    
    NSString *langauage=[[MyAppDataManager getPreferredLanguage]substringToIndex:2];
    
    if([langauage isEqual:@"en"]){
        
        shareString = [[NSString alloc]initWithFormat:@"I've update my profile in Halfeet(www.halfeet.com).%@ have changed to:%@ ",item,newValue];
     }else if([langauage isEqual:@"ja"]){
        shareString = [[NSString alloc]initWithFormat:@"私は私のプロフィール(www.halfeet.com)を更新しました.%@ 更新：%@",item,newValue];

 
    }
    
    NSLog(@"%@",shareString);
    
    NSDictionary *mapDic = [NSDictionary dictionaryWithObjectsAndKeys:@"sayme",NSLocalizedString(@"s0c2", nil),@"liked",NSLocalizedString(@"s2c0", nil),@"lovego",NSLocalizedString(@"s2c1", nil),@"company",NSLocalizedString(@"s2c2", nil),@"jobtitle",NSLocalizedString(@"s2c3", nil),@"school",NSLocalizedString(@"s2c4", nil),nil];
//    //NSLog(@"%@",[mapDic valueForKey:@"jobtitle"]);
//    //NSLog(@"%@",item);
NSLog(@"%@",[mapDic valueForKey:item]);

    if(!self.editBuffer)
    {
        _editBuffer = [[NSMutableDictionary alloc] initWithCapacity:1];
    }
    [_editBuffer setValue:newValue.length?newValue:@"-" forKey:[mapDic valueForKey:item]];

    
    NSString *msg = [NSString stringWithFormat:NSLocalizedString(@"changeInfo", nil),item];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"noticeNotice", nil)
                                                    message:msg
                                                   delegate:self
                                          cancelButtonTitle:NSLocalizedString(@"cancelNotice", nil)
                                          otherButtonTitles:NSLocalizedString(@"saveButton", nil), nil];
    alert.tag = 100;
    [alert show];
    [alert release];
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if(alertView.tag == 101){

        if(buttonIndex == 1){
//            NSLog(@"%d",[self.tableView indexPathForSelectedRow].row);
            NSString *langauage=[self getPreferredLanguage];
            if([langauage isEqual:@"zh-Hans"]){
                [self bindingWeibo:[self.tableView indexPathForSelectedRow].row];
            }else{
                if([self.tableView indexPathForSelectedRow].row){
                    [MyAppDelegate openSessionWithAllowLoginUI:YES];

                }else{
                    [self presentModalViewController:[self.twitterEngine OAuthLoginWindow] animated:YES];
                }

            }
            [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];

//            [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:3] withRowAnimation:UITableViewRowAnimationNone];
        }


    }
    else{
        if(buttonIndex == alertView.cancelButtonIndex)
        {
            if(alertView.tag == 100)
                self.editBuffer = nil;
            else
            {
                [UIView animateWithDuration:0.3 animations:^{
                    self.view.userInteractionEnabled = NO;
                    [_photoView setMyPhotos:[_myProfile valueForKey:@"facelist"]];
                } completion:^(BOOL finish){
                    self.view.userInteractionEnabled = YES;
                }];
                
                [_photoView clearEditData];
            }
            return;
            
        }
        if(alertView.tag == 100)
        {
            NSLog(@"%@",_editBuffer);

            [AppComManager getBanBuData:BanBu_Set_My_Info par:_editBuffer delegate:self];
            self.navigationController.view.userInteractionEnabled = NO;
            [TKLoadingView showTkloadingAddedTo:self.navigationController.view title:NSLocalizedString(@"updateInfo", nil) activityAnimated:YES];

            return;
        }
        if(_photoView.addPhotoArr.count)
        {
            NSLog(@"添加列表%@",_photoView.addPhotoArr);
            NSLog(@"%d",_photoView.addPhotoArr.count);
            NSMutableDictionary *uploadDic = [NSMutableDictionary dictionary];
            //        [uploadDic setValue:@"y" forKey:@"phone"];
            [uploadDic setValue:@"png" forKey:@"picformat"];
            [uploadDic setValue:MyAppDataManager.loginid forKey:@"loginid"];
            [AppComManager uploadSeveralImages:_photoView.addPhotoArr delegate:self];
            //        [AppComManager  uploadRegAvatarImage:UIImagePNGRepresentation([_photoView.addPhotoArr objectAtIndex:0]) Par:uploadDic delegate:self];
            
            self.navigationController.view.userInteractionEnabled = NO;
            [TKLoadingView showTkloadingAddedTo:self.navigationController.view title:NSLocalizedString(@"updateAvatar", nil) activityAnimated:YES];
        }
        if(_photoView.delPhotoArr.count)
        {
            NSLog(@"删除列表%@",_photoView.delPhotoArr);
            NSLog(@"%d",_photoView.delPhotoArr.count);
            NSString *faceids = [_photoView.delPhotoArr componentsJoinedByString:@","];
            NSMutableDictionary *sendDic = [NSMutableDictionary dictionaryWithCapacity:1];
            [sendDic setValue:faceids forKey:@"faceid"];
            [AppComManager getBanBuData:BanBu_Del_My_Avatar par:sendDic delegate:self];
            self.navigationController.view.userInteractionEnabled = NO;
            [TKLoadingView showTkloadingAddedTo:self.navigationController.view title:NSLocalizedString(@"updateAvatar", nil) activityAnimated:YES];
            
        }

    }
        
}
    
//facebook发一条动态
 - (void) performPublishAction:(void (^)(void)) action  //1
    {
        
        
        if ([[FBSession activeSession]isOpen]) {
            /*
             * if the current session has no publish permission we need to reauthorize
             */
            if ([FBSession.activeSession.permissions indexOfObject:@"publish_actions"] == NSNotFound)
            {
                [FBSession.activeSession reauthorizeWithPublishPermissions:[NSArray arrayWithObject:@"publish_actions"] defaultAudience:FBSessionDefaultAudienceFriends completionHandler:^(FBSession *session, NSError *error)
                 {
                     if (!error) {
                         action();
                     }
                 }];
            }
            else {
                action();
            }
        }else{
            /*
             * open a new session with publish permission
             */
            [FBSession openActiveSessionWithPublishPermissions:[NSArray arrayWithObject:@"publish_actions"]
                                               defaultAudience:FBSessionDefaultAudienceFriends
                                                  allowLoginUI:YES
                                             completionHandler:^(FBSession *session, FBSessionState status, NSError *error) {
                                                 if (!error && status == FBSessionStateOpen) {
                                                     action();
                                                 }else{
                                                     NSLog(@"error");
                                                 }
                                             }];
        }
        
        
         }
    
    
-(BOOL)openSessionWithAllowLoginUI:(BOOL)allowLoginUI{
    
    NSArray *permission = [[NSArray alloc]initWithObjects:@"publish_actions", nil];
    
 
    return [FBSession openActiveSessionWithPublishPermissions:permission defaultAudience:FBSessionDefaultAudienceFriends allowLoginUI:YES completionHandler:^(FBSession *session, FBSessionState status, NSError *error) {
//        [FBRequestConnection startForPostStatusUpdate:shareString
//                                    completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
//                                        
//                                    }];
    }];
//    return [FBSession reauthorizeWithPublishPermissions:permission defaultAudience:FBSessionDefaultAudienceFriends completionHandler:^(FBSession *session, NSError *error) {
//        ;
//    }];
    
}


@end
