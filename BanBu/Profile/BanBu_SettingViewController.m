//
//  BanBu_SettingViewController.m
//  BanBu
//
//  Created by jie zheng on 12-7-7.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "BanBu_SettingViewController.h"
#import "BanBu_NavigationController.h"
#import "BanBu_StealthViewController.h"
#import "BanBu_LocationHelperController.h"
#import "BanBu_RemindViewController.h"
#import "BanBu_MuteViewController.h"
#import "BanBu_ChangePWViewController.h"
#import "BanBu_BlacklistViewController.h"
#import "BanBu_AppDelegate.h"
#import "AppDataManager.h"
#import "AppCommunicationManager.h"
#import "BanBu_UserAgreement.h"
#import "BanBu_HelpViewController.h"
#import "BanBu_FeedbackView.h"
#import "BanBu_MessageOptionViewController.h"
#import "BanBu_ListViewController.h"
#import "BanBu_BroadcastTVC.h"
#import "BanBu_SoundSetting.h"
@interface BanBu_SettingViewController ()

@end

@implementation BanBu_SettingViewController

- (id)init
{
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.tableView.backgroundView = nil;
    self.tableView.backgroundColor = [UIColor colorWithRed:255.0/255 green:250.0/255 blue:240.0/255 alpha:1.0];
    self.title = NSLocalizedString(@"settingTitle", nil);
    
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 70)];
    footerView.backgroundColor = [UIColor clearColor];
    UIButton *exitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    exitBtn.frame = CGRectMake(10, 10, 300, 40);
    [exitBtn setBackgroundImage:[[UIImage imageNamed:@"btn_red.png"] stretchableImageWithLeftCapWidth:10.0 topCapHeight:0.0] forState:UIControlStateNormal];
    [exitBtn setTitle:NSLocalizedString(@"exitBtn", nil) forState:UIControlStateNormal];
    [exitBtn addTarget:self action:@selector(exit:) forControlEvents:UIControlEventTouchUpInside];
    [footerView addSubview:exitBtn];
    self.tableView.tableFooterView = footerView;
    [footerView release];
    
    

    
   

}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [AppComManager cancalHandlesForObject:self];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section == 0){
        return 2;
    }
    return 3;

}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if(section == 0)
        return NSLocalizedString(@"userNameMan", nil);
    else if(section == 1)
        return NSLocalizedString(@"messageMan", nil);
    return nil;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell == nil)
    {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier] autorelease];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
    }
    
    if(indexPath.section == 0)
    {
        if(!indexPath.row)
        {
            cell.textLabel.text = NSLocalizedString(@"PWSettingLabel", nil);
        }
        else if(indexPath.row==1)
        {
            cell.textLabel.text = NSLocalizedString(@"blackLabel", nil);
            
        }
        
    }
    else if(indexPath.section == 1)
    {
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if(indexPath.row<=1){
            cell.accessoryType = UITableViewCellAccessoryNone;
            UISwitch *aSwitch = [[UISwitch alloc]initWithFrame:CGRectMake(310-80, 7, 80, 30)];
            [aSwitch addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
            cell.accessoryView = aSwitch;
            [aSwitch release];
            
            
            if(indexPath.row == 0)
            {
                cell.textLabel.text=NSLocalizedString(@"notificChat", nil);
                _messageSwitch = aSwitch;
                _messageSwitch.on = YES;
                _messageSwitch.userInteractionEnabled = NO;
                
            }
            else if(indexPath.row == 1)
            {
                cell.textLabel.text=NSLocalizedString(@"notificFriend", nil);
                _friendDosSwitch = aSwitch;
                if([[[[[UserDefaults valueForKey:MyAppDataManager.useruid] valueForKey:@"settings"] valueForKey:@"boolKey"] objectAtIndex:1]boolValue]){
                    _friendDosSwitch.on = YES;
                }else{
                    _friendDosSwitch.on = NO;
                }
            }
            else{
//                cell.textLabel.text = NSLocalizedString(@"soundSwitch", nil);
//                _soundSwitch = aSwitch;
//                if([[[[UserDefaults valueForKey:MyAppDataManager.useruid] valueForKey:@"settings"] valueForKey:@"MusicSwith"] length]){
//                    _soundSwitch.on = YES;
//                }else{
//                    _soundSwitch.on = NO;
//                }
            }

        }
        else if(indexPath.row == 2){
            
            cell.textLabel.text = NSLocalizedString(@"soundSwitch", nil);
           
        }
        
        
        
    }
    else if(indexPath.section == 2)
    {
        if(!indexPath.row)
        {
            cell.textLabel.text = NSLocalizedString(@"feedBackLabel", nil);
        }
        else if(indexPath.row == 1)
        {
            cell.textLabel.text = NSLocalizedString(@"helpTitle", nil);
        }
        else
        {
            cell.textLabel.text = NSLocalizedString(@"userAgreeTitle", nil);
            
        }
    }

    
    return cell;

}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    if(indexPath.section == 0)
    {
        if(indexPath.row==0)
        {
            //           UIActionSheet *actionSheet = [[UIActionSheet alloc]
            //                                         initWithTitle:@"密码设置"
            //                                         delegate:self
            //                                         cancelButtonTitle:@"取消"
            //                                         destructiveButtonTitle:nil
            //                                         otherButtonTitles:@"修改密码",nil];
            //            [actionSheet showFromTabBar:self.navigationController.tabBarController.tabBar];
            //            [actionSheet release];
            BanBu_ChangePWViewController *changePW = [[BanBu_ChangePWViewController alloc] init];
            BanBu_NavigationController *nav = [[[BanBu_NavigationController alloc] initWithRootViewController:changePW] autorelease];
            if ([nav.navigationBar respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)])
            {
                NSString *path = [[NSBundle mainBundle] pathForResource:@"topbar" ofType:@"png"];
                UIImage *image = [UIImage imageWithContentsOfFile:path];
                [nav.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
            }
            
            [self presentModalViewController:nav animated:YES];
            [changePW release];
        }
        else if(indexPath.row==1)
        {
            BanBu_BlacklistViewController *blackList = [[BanBu_BlacklistViewController alloc] init];
            [self.navigationController pushViewController:blackList animated:YES];
            [blackList release];
        }
        
    }
    else if(indexPath.section == 1)
    {
//        if(!indexPath.row)
//        {
//            
//            BanBu_MessageOptionViewController *messageReceive=[[BanBu_MessageOptionViewController alloc]init];
//            
//            [self.navigationController pushViewController:messageReceive animated:YES];
//            
//            [messageReceive release];
//            
//        }
        if(indexPath.row == 2){
            BanBu_SoundSetting *sound = [[BanBu_SoundSetting alloc]initWithStyle:UITableViewStyleGrouped];
            [self.navigationController pushViewController:sound animated:YES];
            [sound release];
        }
    }
    else if(indexPath.section == 2)
    {
        if(!indexPath.row)
        {
            //cell.textLabel.text = @"意见反馈";
            BanBu_FeedbackView *aFeed = [[BanBu_FeedbackView alloc]init];
            [self.navigationController pushViewController:aFeed animated:YES];
            [aFeed release];
        }
        else if(indexPath.row == 1)
        {
            //cell.textLabel.text = @"给半步评价";后改为“关于半步”
            BanBu_HelpViewController *ahelp = [[BanBu_HelpViewController alloc]init];
            [self.navigationController pushViewController:ahelp animated:YES];
            [ahelp release];
        }
        else
        {
            //cell.textLabel.text = @"用户帮助";后改为“用户协议”
            BanBu_UserAgreement *agree = [[BanBu_UserAgreement alloc]init];
            [self.navigationController pushViewController:agree animated:YES];
            [agree release];
        }
    
    }

}

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if(!buttonIndex)
    {
        BanBu_ChangePWViewController *changePW = [[BanBu_ChangePWViewController alloc] init];
        BanBu_NavigationController *nav = [[[BanBu_NavigationController alloc] initWithRootViewController:changePW] autorelease];
        if ([nav.navigationBar respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)])
        { 
            NSString *path = [[NSBundle mainBundle] pathForResource:@"topbar" ofType:@"png"];
            UIImage *image = [UIImage imageWithContentsOfFile:path];
            [nav.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
        }  

        [self presentModalViewController:nav animated:YES];
        [changePW release];
        
    }
    if(buttonIndex == 1) 
    {
        UIAlertView *alertView = [[UIAlertView alloc] 
                                  initWithTitle:@"密码重置"
                                  message:@"我们已向您的注册的邮箱发了密码重置邮件，请查收！"
                                  delegate:nil
                                  cancelButtonTitle:@"好的"
                                  otherButtonTitles:nil, nil];
        [alertView show];
        [alertView release];
    }
}

-(void)switchAction:(UISwitch *)sender{
    NSMutableDictionary *settingsDic = [NSMutableDictionary dictionaryWithDictionary:[[UserDefaults valueForKey:MyAppDataManager.useruid] valueForKey:@"settings"]];
    if(sender == _messageSwitch){
//        [MyAppDataManager.boolArr addObject:[NSNumber numberWithBool:cell.flag]];

    }else if(sender == _friendDosSwitch){
        [MyAppDataManager.boolArr removeAllObjects];
        
        [MyAppDataManager.boolArr addObjectsFromArray: [[[UserDefaults valueForKey:MyAppDataManager.useruid] valueForKey:@"settings"] valueForKey:@"boolKey"]];
        if(sender.on){
            [MyAppDataManager.boolArr replaceObjectAtIndex:1 withObject:[NSNumber numberWithBool:1]];
            
        }else{
            [MyAppDataManager.boolArr replaceObjectAtIndex:1 withObject:[NSNumber numberWithBool:0]];
        }
        [settingsDic setValue:MyAppDataManager.boolArr forKey:@"boolKey"];
    }else if(sender == _soundSwitch){
        if(sender.on){
            MyAppDataManager.musicName = @"msg_1";
            
        }else{
            MyAppDataManager.musicName = @"";
            
        }
        [settingsDic setValue:MyAppDataManager.musicName forKey:@"MusicSwith"];
        
    }
 
    NSMutableDictionary *settingsUpdata = [NSMutableDictionary dictionaryWithDictionary:[UserDefaults valueForKey:MyAppDataManager.useruid]];
    [settingsUpdata setValue:settingsDic forKey:@"settings"];
    [UserDefaults setValue:settingsUpdata forKey:MyAppDataManager.useruid];
//    NSLog(@"%@",[[[UserDefaults valueForKey:MyAppDataManager.useruid] valueForKey:@"settings"]valueForKey:@"boolKey"] );

}

- (void)exit:(UIButton *)button
{

#warning 当点击退出时，关掉消息的接受。
    if([AppComManager.receiveMsgTimer isValid])
    {
        [AppComManager.receiveMsgTimer invalidate];
        
        AppComManager.receiveMsgTimer=nil;
        
    }
    
    
    
    NSMutableDictionary *parDic = [NSMutableDictionary dictionary];
    [parDic setValue:@"apple" forKey:@"server"];
    [parDic setValue:@"" forKey:@"pushid"];
    [AppComManager getBanBuData:Banbu_Set_User_Pushid par:parDic delegate:self];
    
    [TKLoadingView showTkloadingAddedTo:self.navigationController.view title:NSLocalizedString(@"chuliNotice", nil) activityAnimated:YES];
    
   

}


#pragma mark - BanBuDelegate

- (void)banbuRequestDidFinished:(NSDictionary *)resDic error:(NSError *)error{
    
    self.navigationController.view.userInteractionEnabled = YES;
    [TKLoadingView dismissTkFromView:self.navigationController.view animated:YES afterShow:0.0];
    if(error)
    {
        return;
    }
//    NSLog(@"%@",resDic);
    if([AppComManager respondsDic:resDic isFunctionData:Banbu_Set_User_Pushid]){
        if([[resDic valueForKey:@"ok"]boolValue]){
            [self.navigationController popViewControllerAnimated:YES];
            
            [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
            BanBu_ListViewController *acontrol = (BanBu_ListViewController *)[self.tabBarController.viewControllers objectAtIndex:0];
            acontrol.currentPage = 0;
            BanBu_BroadcastTVC *bcontrol = (BanBu_BroadcastTVC *)[self.tabBarController.viewControllers objectAtIndex:0];
            bcontrol.DosPage = 0;
            
            
            NSArray *guanxi = [NSArray arrayWithObjects:@"g",@"f",@"h", nil];
            
            for (int i=0; i<guanxi.count; i++) {
                NSString *path = [DataCachePath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@-%@listdata",MyAppDataManager.useruid,[guanxi objectAtIndex:i]]];
                [FileManager removeItemAtPath:path error:nil];
                
            }
            
//            [UserDefaults removeObjectForKey:@"myID"];
            [UserDefaults synchronize];
            
            [MyAppDataManager.friendsDos removeAllObjects];
            [MyAppDataManager.contentArr removeAllObjects];
            [MyAppDataManager.friendViewList removeAllObjects];
            [MyAppDataManager.friends removeAllObjects];
            
            [MyAppDataManager.dialogs removeAllObjects];
            
            NSMutableDictionary *uidDic = [NSMutableDictionary dictionaryWithDictionary:[UserDefaults valueForKey:MyAppDataManager.useruid]];
            [uidDic removeObjectForKey:@"loginid"];
            [UserDefaults setValue:uidDic forKey:MyAppDataManager.useruid];
            [UserDefaults synchronize];
            
            BanBu_AppDelegate *delegate = (BanBu_AppDelegate *)[UIApplication sharedApplication].delegate;
            [delegate setViewController:NO];
            
            //    [delegate saveLastTime];
            
        }
        else{
            NSLog(@"------%@",[MyAppDataManager IsInternationalLanguage:[resDic valueForKey:@"error"]]);
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
        
    }

}











@end
