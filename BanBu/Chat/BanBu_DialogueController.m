//
//  BanBu_DialogueControllerViewController.m
//  BanBu
//
//  Created by 17xy on 12-7-30.
//
//

#import "BanBu_DialogueController.h"
#import "BanBu_DialogueCell.h"
#import "BanBu_ChatViewController.h"
#import "AppDataManager.h"
#import "AppCommunicationManager.h"
#import "TKLoadingView.h"
#import "CJSONSerializer.h"
#import "NSDictionary_JSONExtensions.h"
#import <CommonCrypto/CommonDigest.h>
#import "CJSONDeserializer.h"
@interface BanBu_DialogueController ()

@end

@implementation BanBu_DialogueController
@synthesize ProRequest=_ProRequest;

- (id)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [MyAppDataManager readTalkList:TALKPEOPLES];
    
    self.title = NSLocalizedString(@"dialogueTitle", nil);
    
    self.tableView.backgroundColor = [UIColor colorWithRed:255.0/255 green:250.0/255 blue:240.0/255 alpha:1.0];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.allowsSelectionDuringEditing = YES;

    CGFloat btnLen = [NSLocalizedString(@"clearButton", nil) sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(150, 30)].width;
    UIButton *clearButton = [UIButton buttonWithType:UIButtonTypeCustom];
    clearButton.frame=CGRectMake(0, 0, btnLen+20, 30);
    [clearButton addTarget:self action:@selector(clearFlag) forControlEvents:UIControlEventTouchUpInside];
    [clearButton setBackgroundImage:[[UIImage imageNamed:@"app_nav_btn_bg1.png"] stretchableImageWithLeftCapWidth:15.0 topCapHeight:15.0] forState:UIControlStateNormal];
    [clearButton setBackgroundImage:[[UIImage imageNamed:@"app_nav_btn_bg2.png"] stretchableImageWithLeftCapWidth:15.0 topCapHeight:15.0] forState:UIControlStateHighlighted];
    [clearButton setTitleEdgeInsets:UIEdgeInsetsMake(3, 2, 2, 2)];
    [clearButton setTitle:NSLocalizedString(@"clearButton", nil) forState:UIControlStateNormal];
    clearButton.titleLabel.font = [UIFont systemFontOfSize:14];
    UIBarButtonItem *clearItem = [[[UIBarButtonItem alloc] initWithCustomView:clearButton] autorelease];
    self.navigationItem.leftBarButtonItem = clearItem;

    CGFloat btnLen1 = [NSLocalizedString(@"deleteButton", nil) sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(150, 30)].width;
    deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
    deleteButton.frame=CGRectMake(0, 0, btnLen1+20, 30);
    deleteButton.tag = 101;
    [deleteButton addTarget:self action:@selector(setEditing:animated:) forControlEvents:UIControlEventTouchUpInside];
    [deleteButton setBackgroundImage:[[UIImage imageNamed:@"app_nav_btn_bg1.png"] stretchableImageWithLeftCapWidth:15.0 topCapHeight:15.0] forState:UIControlStateNormal];
    [deleteButton setBackgroundImage:[[UIImage imageNamed:@"app_nav_btn_bg2.png"] stretchableImageWithLeftCapWidth:15.0 topCapHeight:15.0] forState:UIControlStateHighlighted];
    [deleteButton setTitleEdgeInsets:UIEdgeInsetsMake(3, 2, 2, 2)];
    [deleteButton setTitle:NSLocalizedString(@"deleteButton", nil) forState:UIControlStateNormal];
    deleteButton.titleLabel.font = [UIFont systemFontOfSize:14];
    UIBarButtonItem *delItem = [[[UIBarButtonItem alloc] initWithCustomView:deleteButton] autorelease];
    self.navigationItem.rightBarButtonItem = delItem;
//    NSLog(@"%@",MyAppDataManager.talkPeoples);
	deleteArr = [[NSMutableArray alloc] init];
    self.tableView.backgroundColor = [UIColor clearColor];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self updateBadgeShow];
    _isPush = YES;
    
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
//    self.navigationController.view.userInteractionEnabled = YES;
}

- (void) setEditing:(BOOL)editting animated:(BOOL)animated
{
	
	[super setEditing:!self.editing animated:YES];
    if(self.editing){
        CGFloat btnLen1 = [NSLocalizedString(@"finishButton", nil) sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(150, 30)].width;
        deleteButton.frame=CGRectMake(320-btnLen1-20-5, 7, btnLen1+20, 30);

        [deleteButton setTitle:NSLocalizedString(@"finishButton", nil) forState:UIControlStateNormal];
    }else{
        CGFloat btnLen1 = [NSLocalizedString(@"deleteButton", nil) sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(150, 30)].width;
        deleteButton.frame=CGRectMake(320-btnLen1-20-5, 7, btnLen1+20, 30);
        [deleteButton setTitle:NSLocalizedString(@"deleteButton", nil) forState:UIControlStateNormal];
    }
    
    
    
    if(deleteArr.count){
        NSMutableArray *tempArr = [NSMutableArray array];
        for(NSIndexPath *indexPath in deleteArr){
            //                NSLog(@"%@",MyAppDataManager.talkPeoples);
            NSDictionary *aTalk = [MyAppDataManager.talkPeoples objectAtIndex:indexPath.row];
            [tempArr addObject:aTalk];
            
        }
        for(NSDictionary *aTalk in tempArr){
            [MyAppDataManager deleteData:aTalk forItem:TALKPEOPLES forUid:VALUE(KeyFromUid, aTalk)];
            [MyAppDataManager removeTableNamed:[MyAppDataManager getTableNameForUid:VALUE(KeyFromUid, aTalk)]];
            
            [MyAppDataManager readTalkList:TALKPEOPLES];
        }
        [self.tableView deleteRowsAtIndexPaths:deleteArr withRowAnimation:UITableViewRowAnimationFade];

        [self updateBadgeShow];
        
        [deleteArr removeAllObjects];
    }
    
}

-(void)refresh:(UIButton *)button{

    [button setTitle:NSLocalizedString(@"deleteButton", nil) forState:UIControlStateNormal];
    [self.tableView setEditing:NO animated:YES];
}



- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (void)dealloc
{
    [deleteArr release];
    
    [super dealloc];
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

    return MyAppDataManager.talkPeoples.count;
}

- (float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 84;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    BanBu_DialogueCell *cell = (BanBu_DialogueCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell == nil)
    {
        cell = [[[BanBu_DialogueCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
//        cell.multipleSelectionBackgroundView = [[[UIView alloc] initWithFrame:cell.bounds] autorelease];
 
    }
    NSDictionary *aTalk;
    if([MyAppDataManager.talkPeoples count]!=0)
    {
      aTalk = [MyAppDataManager.talkPeoples objectAtIndex:indexPath.row];
    }else
    {
        aTalk=nil;
    }
    [cell setAvatar:VALUE(KeyUface, aTalk)];
    [cell setName:[MyAppDataManager IsInternationalLanguage:VALUE(KeyUname, aTalk)]];
//    NSLog(@"%@-----%@",VALUE(KeyStime, aTalk),[VALUE(KeyStime, aTalk) substringFromIndex:5]);
//    NSLog(@"%@",aTalk);
    [cell setLastInfo: VALUE(KeyStime, aTalk)];
    [cell setAge:VALUE(KeyAge, aTalk) sex:[VALUE(KeySex, aTalk) boolValue]];
    [cell setDistance:[MyAppDataManager IsInternationalLanguage:VALUE(KeyDmeter, aTalk)]];
    [cell setlastDialogue:VALUE(KeyLasttalk, aTalk) andType:VALUE(KeyType, aTalk)];
    
#warning 隐藏掉对话列表的送达和已读状态
    if(![VALUE(KeyLasttalk, aTalk) isEqualToString:@""])
    {
        if([VALUE(KeyMe, aTalk) boolValue])
        {
            if([aTalk valueForKey:@"status"]){
//                [cell setReadAndSend:[VALUE(KeyStatus, aTalk) intValue]];

            }
            
        }else{
//            [cell setReadAndSend:4];
            
        }
        cell.receiveAndsend.hidden = NO;
        [cell setReceiveAndsend11:[VALUE(KeyMe, aTalk) boolValue]];
    }
    else
    {
        cell.receiveAndsend.hidden = YES;
//        [cell setReadAndSend:4];

    }

    NSInteger unReadNum = [VALUE(KeyUnreadNum, aTalk) integerValue];
    [cell setBadageValue:[NSString stringWithFormat:@"%i",unReadNum]];

    
    //多选删除
    NSMutableDictionary *talkPeopleDic = [NSMutableDictionary dictionaryWithDictionary:[MyAppDataManager.talkPeoples objectAtIndex:indexPath.row]];
    BOOL isChecked = [[talkPeopleDic valueForKey:@"isChecked"] boolValue];
    [cell setChecked:isChecked];
    
    return cell;
}

// 这是单选删除的东西
/*
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (BOOL)tableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSDictionary *aTalk = [MyAppDataManager.talkPeoples objectAtIndex:indexPath.row];
        [MyAppDataManager deleteData:aTalk forItem:TALKPEOPLES forUid:VALUE(KeyFromUid, aTalk)];
    
         [MyAppDataManager removeTableNamed:[MyAppDataManager getTableNameForUid:VALUE(KeyFromUid, aTalk)]];
        
        [MyAppDataManager readTalkList:TALKPEOPLES];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationTop];
        [self updateBadgeShow];
    }
}
*/

- (void)updateBadgeShow
{
    
//    NSLog(@"%@",MyAppDataManager.talkPeoples);
    [MyAppDataManager readTalkList:TALKPEOPLES];
//    NSLog(@"%@", [[MyAppDataManager.talkPeoples lastObject] valueForKey:@"stime"] );
//    NSArray *tempArr = [[[NSArray alloc]initWithArray:MyAppDataManager.talkPeoples]autorelease];
//    NSArray *sortedArray = [tempArr sortedArrayUsingComparator: ^(id obj1, id obj2) {
//
//        return [[obj2 objectForKey:KeyStime] compare:[obj1 objectForKey:KeyStime] options:NSCaseInsensitiveSearch];
//        
//    }];
//    [MyAppDataManager.talkPeoples removeAllObjects];
//    [MyAppDataManager.talkPeoples addObjectsFromArray:sortedArray];
//    NSLog(@"%@", sortArr );

    [deleteArr removeAllObjects];
     _totalUnreadNum = 0;
    for(NSDictionary *aTalk in MyAppDataManager.talkPeoples)
    {
        _totalUnreadNum += [VALUE(KeyUnreadNum, aTalk) integerValue];
        
        if([[aTalk valueForKey:@"userid"] intValue]<1000)
        {
             
              // 不需要了因为他们都是在一个navi
          //  [MyAppDelegate updateBadgeFriend:VALUE(KeyUnreadNum, aTalk)];
        
        }
    }
    [self.tableView reloadData];
    self.navigationController.tabBarItem.badgeValue = [NSString stringWithFormat:@"%i",_totalUnreadNum];
    
//    NSLog(@"+++++++++++%d", MyAppDataManager.talkPeoples.count );

}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return UITableViewCellEditingStyleNone;
}

#pragma mark - Table view delegate
 
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(self.tableView.editing){
        NSMutableDictionary *talkPeopleDic = [NSMutableDictionary dictionaryWithDictionary:[MyAppDataManager.talkPeoples objectAtIndex:indexPath.row]];
        BOOL isChecked = [[talkPeopleDic valueForKey:@"isChecked"] boolValue];
        [talkPeopleDic setValue:[NSString stringWithFormat:@"%d",!isChecked] forKey:@"isChecked"];
        [MyAppDataManager.talkPeoples replaceObjectAtIndex:indexPath.row withObject:talkPeopleDic];
        
        BanBu_DialogueCell *cell = (BanBu_DialogueCell *)[tableView cellForRowAtIndexPath:indexPath];
        [cell setChecked:!isChecked];
        if(!isChecked){
            [deleteArr addObject:indexPath];
        }else{
            [deleteArr removeObject:indexPath];
        }
    }
 
    else{

        NSLog(@"%@********************",MyAppDataManager.talkPeoples);
        NSMutableDictionary *aTalk1 =  [NSMutableDictionary dictionaryWithDictionary:[MyAppDataManager.talkPeoples objectAtIndex:indexPath.row]];
#warning 避免不必要的网络请求，看某一个的对话，三秒后，才会再次获取新消息，而不是立马请求服务器，获取数据。
//        [AppComManager receiveMsgFromUser:[aTalk1 valueForKey:@"userid"] delegate:MyAppDataManager];
        
        NSDictionary *userDic = [NSDictionary dictionaryWithDictionary:[MyAppDataManager.talkPeoples objectAtIndex:indexPath.row]];
        
        if([VALUE(KeyUnreadNum, aTalk1) integerValue]!=0)
        {
            NSMutableDictionary *unReadDic = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%d",0-[VALUE(KeyUnreadNum, aTalk1) integerValue]],@"pushcount",nil];
            //        NSLog(@"%@",[NSString stringWithFormat:@"%d",0-[VALUE(KeyUnreadNum, aTalk1) integerValue]]);
            [AppComManager getBanBuData:Banbu_Set_User_Pushcount par:unReadDic delegate:self];
            // 判断这个用户的usrid 如果小于一个确定的数  那么 跳入到对应的
        }

        if([[userDic valueForKey:@"userid"] intValue]==200)
        {
            // 跳到
             
             NSMutableDictionary *aTalk =  [NSMutableDictionary dictionaryWithDictionary:[MyAppDataManager.talkPeoples objectAtIndex:indexPath.row]];
             [aTalk setValue:[NSNumber numberWithInteger:0] forKey:KeyUnreadNum];
             [MyAppDataManager.talkPeoples replaceObjectAtIndex:indexPath.row withObject:aTalk];
           
//             [MyAppDataManager updateData:aTalk forItem:TALKPEOPLES forUid:VALUE(@"userid", aTalk)];
             
             MyAppDataManager.isSee=YES;
             
             [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationNone];

            // 推到好友请求的页面
             
    
             BanBu_RequestViewController *request=[[BanBu_RequestViewController alloc]initWithNumber:[NSString stringWithFormat:@"%@",[aTalk valueForKey:KeyUnreadNum]] MutableDictionary:aTalk];
             
             request.hidesBottomBarWhenPushed = YES;
             
             _ProRequest=request;
             
             [self.navigationController pushViewController:request animated:YES];
             
             [request release];
             
             
           //  [(TKTabBarController*)[MyAppDelegate tabbarController] setSelectedIndex:3];
             
             [self updateBadgeShow];
    
                return;
         }
        else{
            if(_isPush){
                
                NSMutableDictionary *aTalk =  [NSMutableDictionary dictionaryWithDictionary:[MyAppDataManager.talkPeoples objectAtIndex:indexPath.row]];
                NSLog(@"----------%@",aTalk);
                NSMutableArray *blackList=[[NSMutableArray alloc] initWithArray:[[[UserDefaults valueForKey:MyAppDataManager.useruid] valueForKey:@"friendlist"] valueForKey:@"flist"]];
                //判断此人是不是在黑名单，是就不能和他对话
                for(NSDictionary * dic in blackList)
                {
                    
                    if([VALUE(@"fuid", dic) isEqual:VALUE(KeyFromUid, aTalk)]&&[VALUE(@"linkkind", dic)isEqual:@"x"])
                    {
                        //                     [TKLoadingView showTkloadingAddedTo:self.navigationController.view title:@"你已经将他拉入黑名单,如果想和他对话请去黑名单解除" activityAnimated:NO duration:2];
                        [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationNone];
                        
                        return;
                    }
                }
                [aTalk setValue:[NSNumber numberWithInteger:0] forKey:KeyUnreadNum];
#warning 注释掉了replaceobject
                //更新对话列表
                [MyAppDataManager.talkPeoples replaceObjectAtIndex:indexPath.row withObject:aTalk];
                //更新数据库
                NSString *jsonfrom = [[CJSONSerializer serializer] serializeArray: VALUE(@"facelist", aTalk)];
                //            NSLog(@"jsonfrom-----------%@",jsonfrom);
                [aTalk setValue:jsonfrom forKey:@"facelist"];
                [MyAppDataManager updateData:aTalk forItem:TALKPEOPLES forUid:VALUE(@"userid", aTalk)];
                
                //            NSLog(@"aa----------bb");
                
                BanBu_ChatViewController *chat = [[BanBu_ChatViewController alloc] initWithPeopleProfile:userDic];
                if([[userDic valueForKey:@"userid"] intValue]<1000){
                    chat.listType = 1;
                }else{
                    chat.listType = 0;
                }
                chat.hidesBottomBarWhenPushed = YES;
                //            self.navigationController.view.userInteractionEnabled = NO;
                _isPush = NO;
                [self.navigationController pushViewController:chat animated:YES];
                [chat release];
                
            }
        }
               
    }
 }


-(void)tableView:(UITableView *)tableView didEndDisplayingCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if(cell){
        [(BanBu_ListCell*)cell cancelImageLoad];
    }
}

- (void)clearFlag
{
    for(int i=0; i<MyAppDataManager.talkPeoples.count; i++)
    {
        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:[MyAppDataManager.talkPeoples objectAtIndex:i]];
        [dic setValue:[NSNumber numberWithInt:0] forKey:KeyUnreadNum];
        [MyAppDataManager.talkPeoples replaceObjectAtIndex:i withObject:dic];
    }
    [MyAppDataManager updateData:MyAppDataManager.talkPeoples forItem:TALKPEOPLES forUid:nil];
    [self.tableView reloadData];
    _totalUnreadNum = 0;
    self.navigationController.tabBarItem.badgeValue = @"0";
    
}

- (void)banbuRequestDidFinished:(NSDictionary *)resDic error:(NSError *)error
{
    
    
    
}

@end
