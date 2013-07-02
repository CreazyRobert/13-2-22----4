//
//  BanBu_DynamicController.m
//  BanBu
//
//  Created by mac on 12-8-7.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "BanBu_DynamicController.h"
#import "BanBu_DialogueCell.h"
#import "BanBu_BroadcastCell.h"
#import "BanBu_GridCell.h"
#import "BanBu_DynamicDetailsController.h"
#import "BanBu_PeopleProfileController.h"
#import "AppDataManager.h"
#import "AppCommunicationManager.h"
#import "TKLoadingView.h"
#import "UIBadgeView.h"
//#import "BanBu_RefreshTime.h"
@interface BanBu_DynamicController ()

-(NSString *)BindUserid:(NSString *)usrid;

@end

@implementation BanBu_DynamicController
@synthesize dataArr = _dataArr,type = _type,number=_number;


-(void)dealloc{
//    [_dataArr release];
    [super dealloc];
}

-(id)initWithDynamicDisplayType:(ADisplayType)type{
    self = [super initWithStyle:UITableViewStylePlain];
    if(self){
        _type = type;
    }
    return self;
}

// 建立个数
-(void)setNumber:(NSString *)number
{

  UIBadgeView *badgeView = (UIBadgeView *)[self.view viewWithTag:1414];
   if(!number||![number intValue])
    {
        if(badgeView)
            [badgeView removeFromSuperview];
    }
    else
    {
        float width = [number sizeWithFont:[UIFont boldSystemFontOfSize:14]].width+12;
        if(!badgeView)
        {
            badgeView = [[UIBadgeView alloc] initWithFrame:CGRectMake(self.navigationItem.rightBarButtonItem.customView.bounds.size.width-width, -2, width, 20)];
            badgeView.tag = 1414;
            badgeView.backgroundColor = [UIColor clearColor];
            badgeView.badgeColor = [UIColor redColor];
            [self.navigationItem.rightBarButtonItem.customView addSubview:badgeView];
//            [badgeView release];
        }
        badgeView.badgeString = number;
        [UIView animateWithDuration:0.5
                         animations:^{
                             badgeView.frame = CGRectMake(self.navigationItem.rightBarButtonItem.customView.bounds.size.width-width, -2, width, 20);
                             
                         }];
    }

    
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = NSLocalizedString(@"visitorLabel", nil);
    self.view.backgroundColor = [UIColor colorWithRed:255.0/255 green:250.0/255 blue:240.0/255 alpha:1.0];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    recordButton = [UIButton buttonWithType:UIButtonTypeCustom];
    recordButton.frame=CGRectMake(0, 0, 70, 30);
    [recordButton addTarget:self action:@selector(record:) forControlEvents:UIControlEventTouchUpInside];
    [recordButton setBackgroundImage:[[UIImage imageNamed:@"app_nav_btn_bg1.png"] stretchableImageWithLeftCapWidth:15.0 topCapHeight:15.0] forState:UIControlStateNormal];
//    [recordButton setBackgroundImage:[[UIImage imageNamed:@"app_nav_btn_bg2.png"] stretchableImageWithLeftCapWidth:15.0 topCapHeight:15.0] forState:UIControlStateHighlighted];
    [recordButton setTitleEdgeInsets:UIEdgeInsetsMake(3, 2, 2, 2)];
    [recordButton setTitle:_type == DisplayFriendsNews?NSLocalizedString(@"displayVisitRecord", nil):NSLocalizedString(@"displayFriendNews", nil) forState:UIControlStateNormal];
    recordButton.titleLabel.font = [UIFont systemFontOfSize:14];
    UIBarButtonItem *delItem = [[[UIBarButtonItem alloc] initWithCustomView:recordButton] autorelease];
    self.navigationItem.rightBarButtonItem = delItem;
     
//    _dataArr = [[NSMutableArray alloc] init];
//    [_dataArr addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"aaaa",@"name",@"123",@"ID",nil]];
//    [_dataArr addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"bbbb",@"name",@"456",@"ID",nil]];
//    [_dataArr addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"cccc",@"name",@"789",@"ID",nil]];
//    NSString *path = [DataCachePath stringByAppendingPathComponent:@"friendDosdata"];
//    [MyAppDataManager.friendDos addObjectsFromArray:[NSKeyedUnarchiver unarchiveObjectWithData:[NSData dataWithContentsOfFile:path]]];
//    NSString *path1 = [DataCachePath stringByAppendingPathComponent:@"friendViewListdata"];
//    [MyAppDataManager.friendViewList addObjectsFromArray:[NSKeyedUnarchiver unarchiveObjectWithData:[NSData dataWithContentsOfFile:path1]]];
    
//    contentArr = [[NSMutableArray alloc]initWithCapacity:10];

    
    
    if(![[UserDefaults valueForKey:[self BindUserid:MyAppDataManager.useruid]] boolValue]&&[MyAppDataManager.friendViewList count]>0){
        NSString *numberString = [[NSString alloc]initWithFormat:@"%i",[MyAppDataManager.friendViewList count]];
        self.number=numberString;
        [numberString release];
    }

    
}
-(NSString *)BindUserid:(NSString *)usrid
{
    
    return [@"myusridis"stringByAppendingString:usrid];
    
}



- (void)record:(UIButton *)button
{
 
    [UserDefaults setValue:@"1" forKey:[self BindUserid:MyAppDataManager.useruid]];
    
    //去掉 uibadageview
    for(UIView *s in self.navigationItem.rightBarButtonItem.customView.subviews )
    {
        if([s isKindOfClass:[UIBadgeView class]])
            
            [s removeFromSuperview];
    }
    
    if([self.view viewWithTag:100]){
        [[self.view viewWithTag:100]removeFromSuperview];
        [[self.view viewWithTag:101]removeFromSuperview];
    }

    
    self.title = _type == DisplayFriendsNews?NSLocalizedString(@"displayVisitRecord", nil):NSLocalizedString(@"displayFriendNews", nil);

    if(self.type == DisplayVisitRecord){
        self.type = DisplayFriendsNews;
        [button setTitle:NSLocalizedString(@"displayVisitRecord", nil) forState:UIControlStateNormal];
       // CGFloat btnLen = [NSLocalizedString(@"displayVisitRecord", nil) sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(100, 30)].width;
      //  button.frame = CGRectMake(button.frame.origin.x, button.frame.origin.y, btnLen+20, 30);
        
        button.frame=CGRectMake(0, 0,70, 30);
        
        if(!MyAppDataManager.friendsDos.count){
            
            [self setRefreshing];
            
            return;
        }
    }else{
        self.type = DisplayVisitRecord;
        [button setTitle:NSLocalizedString(@"displayFriendNews", nil) forState:UIControlStateNormal];
       // CGFloat btnLen = [NSLocalizedString(@"displayFriendNews", nil) sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(100, 30)].width;
      //  button.frame = CGRectMake(button.frame.origin.x, button.frame.origin.y, btnLen+20, 30);
        
        
        if(![MyAppDataManager.friendViewList count]){
            if(cryImageView || noticeLabel){
                [[self.view viewWithTag:100]removeFromSuperview];
                [[self.view viewWithTag:101]removeFromSuperview];
            }
            cryImageView = [[UIImageView alloc]initWithFrame:CGRectMake(136, 100, 48, 48)];
            cryImageView.tag = 100;
            cryImageView.image = [UIImage imageNamed:@"cry.png"];
            [self.tableView addSubview:cryImageView];
//            [cryImageView release];
            noticeLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 150, 300, 100)];
            noticeLabel.tag = 101;
            noticeLabel.numberOfLines = 0;
            noticeLabel.text = NSLocalizedString(@"visitRecordNoticeLabel", nil);
            noticeLabel.font = [UIFont systemFontOfSize:16];
            noticeLabel.textAlignment = UITextAlignmentCenter;
            noticeLabel.textColor = [UIColor darkGrayColor];
            noticeLabel.backgroundColor = [UIColor clearColor];
            [self.tableView addSubview:noticeLabel];
//            [noticeLabel release];
        }
        
        if(!MyAppDataManager.friendViewList.count){
        
            [self setRefreshing];
            return;
        }
        
        
        
         if([self.view viewWithTag:100])
         {
             [[self.view viewWithTag:100] removeFromSuperview];
         
             [[self.view viewWithTag:101] removeFromSuperview];
             
         }
        
        
    }
//    [UIView beginAnimations:@"change" context:nil];
//    [UIView setAnimationDuration:0.5];
//    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
//    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:self.tableView cache:YES];
//    [self.tableView reloadData];
//    [UIView commitAnimations];
    CATransition *animation = [CATransition animation];
    animation.duration = 0.8;
    animation.timingFunction = UIViewAnimationCurveEaseInOut;
    animation.type = @"rippleEffect";
    [self.tableView reloadData];
    [self.view.layer addAnimation:animation forKey:@"animation"];
}

-(void)setType:(ADisplayType)type{
    if(_type == type){
        return;
    }
    _type = type;
    [self.tableView reloadData];
    
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
//    self.dataArr=nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void)viewDidAppear:(BOOL)animated{
    if(!MyAppDataManager.friendsDos.count){
        [self setRefreshing];
        return;
    }
    //判断是否要刷新页面
//    NSString *timeNowString = [BanBu_RefreshTime getCurrentTime:nil];
//    BOOL isReload = [BanBu_RefreshTime now:timeNowString isLaterBefore:[UserDefaults valueForKey:@"friends_updateTime"]];
//    if(isReload){
//        [self setRefreshing];
//    }

}

#pragma mark - 请求数据

-(void)loadingData{
    if([self.view viewWithTag:100]){
        [[self.view viewWithTag:100]removeFromSuperview];
        [[self.view viewWithTag:101]removeFromSuperview];
    }
    if(_type == DisplayFriendsNews){

        NSMutableDictionary *parDic = [NSMutableDictionary dictionary];
        NSDateFormatter *formatter = [[[NSDateFormatter alloc] init] autorelease];
        [formatter setLocale:[NSLocale currentLocale]];
        [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSString *stime = [formatter stringFromDate:[NSDate date]];
        [parDic setValue:stime forKey:@"fromtime"];
        [AppComManager getBanBuData:BanBu_Get_Friend_FriendDos par:parDic delegate:self];
//        NSLog(@"%@",parDic);
//        self.navigationController.view.userInteractionEnabled = NO;

    }else{
        NSMutableDictionary *parDic = [NSMutableDictionary dictionary];
        [AppComManager getBanBuData:BanBu_Get_Friend_ViewList par:parDic delegate:self];
//        self.navigationController.view.userInteractionEnabled = NO;

    }
    
   
}



-(void)viewWillAppear:(BOOL)animated
{
   // 这是一进视图就要开始请求最近的来访记录
    [super viewWillAppear:animated];
    [AppComManager cancalHandlesForObject:self];
    
}


-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [AppComManager cancalHandlesForObject:self];

}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
//#warning Potentially incomplete method implementation.
    // Return the number of sections.

    return 1;

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//#warning Incomplete method implementation.
    // Return the number of rows in the section.
    if(_type ==DisplayFriendsNews){
        return MyAppDataManager.friendsDos.count;
    }else{
        if([MyAppDataManager.friendViewList count]%4!=0){
            
            gridViewRow = [MyAppDataManager.friendViewList count]/4+1;
        }else{
            gridViewRow = [MyAppDataManager.friendViewList count]/4;
        }
        //        NSLog(@"%d----%d",gridViewRow,[MyAppDataManager.nearBuddys count]);
        return gridViewRow;
    }

}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(_type == DisplayFriendsNews){
        return 85;
    }else{
        return 79;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(_type == DisplayFriendsNews){
        static NSString *BroadcastCellIdentifier = @"BroadcastCellIdentifier";
        
        BanBu_BroadcastCell *cell=(BanBu_BroadcastCell *)[tableView dequeueReusableCellWithIdentifier:BroadcastCellIdentifier];
        if(cell == nil)
        {
            
            cell = [[[BanBu_BroadcastCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:BroadcastCellIdentifier] autorelease];
            cell.selectionStyle = UITableViewCellSelectionStyleBlue;
            
        }
       
        NSDictionary *nearDo;
        if(MyAppDataManager.friendsDos.count){
            
            nearDo= [MyAppDataManager.friendsDos objectAtIndex:indexPath.row];
            
        }else{
            nearDo= nil;
            
        }
        /*
        //自适应文字长短
        {
            //        NSString *str=[[MyAppDataManager.broadcastContent objectAtIndex:indexPath.row]objectForKey:@"saytext"];
            NSString *str;
            if([MyAppDataManager.contentArr count]==0){
                str = @"";
            }else{
                str=[MyAppDataManager IsMinGanWord:[[MyAppDataManager.contentArr objectAtIndex:indexPath.row]objectForKey:@"saytext"]];
            }
            
            float total=0;
            int i;
            for(i=0;i<[str length];i++){
                ;
                if([[str substringWithRange:NSMakeRange( i, 1)] characterAtIndex:0]<'z' && [[str substringWithRange:NSMakeRange( i, 1)] characterAtIndex:0]>'0'){
                    total+=0.5;
                    
                }else {
                    total+=1;
                }
                if(total>=15){
                    break;
                }
            }
            [cell setSignature:[str substringWithRange:NSMakeRange( 0, i)]];
            [cell setSignatureson:[str substringWithRange:NSMakeRange( i, [str length]-i)]];
        }
        */

        NSDictionary *mcontentDic = [nearDo valueForKey:@"mcontent"];
        //截取字符串
        NSString *saytext = [mcontentDic objectForKey:@"saytext"];
//        NSLog(@"%@",saytext);
        if([saytext rangeOfString:@"-->"].location != NSNotFound && [saytext rangeOfString:@"<--"].location != NSNotFound){
            
            NSInteger start=[saytext rangeOfString:@"<--"].location+3;
            saytext = [saytext substringToIndex:start-3];
        }
        
        [cell setSignature:[nearDo objectForKey:@"sstar"]];
        [cell setSignatureson:saytext];
        [cell setAvatar:[nearDo objectForKey:@"uface"]];
        [cell setName:[nearDo objectForKey:@"pname"]];
        [cell setAge:[nearDo objectForKey:@"oldyears"] sex:[[nearDo objectForKey:@"gender"] isEqualToString:@"m"]];
         [cell setshowIntimeandDistance:[NSString stringWithFormat:@"%@%@ | %@",NSLocalizedString(@"intimeLabel", nil),[nearDo objectForKey:@"admeter"],[nearDo objectForKey:@"mtime"]]];
        [cell setcommend:[NSString stringWithFormat:NSLocalizedString(@"commendLabel", nil)]];
        [cell setcommendNum:[nearDo objectForKey:@"comments"]];
        
        return cell;

    }else
    {
        static NSString *VisitCellIdentifier=@"ViewCellIdentifier";
        BanBu_GridCell *cell = (BanBu_GridCell *)[tableView dequeueReusableCellWithIdentifier:VisitCellIdentifier];
        if(cell == nil)
        {
            cell = [[[BanBu_GridCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:VisitCellIdentifier] autorelease];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.delegate = self;
        }
        if(cell.contentView.subviews.count){
            for(UIButton *temp in cell.contentView.subviews){
                temp.hidden = YES;
            }
        }
        if(gridViewRow-1 == indexPath.row && MyAppDataManager.friendViewList.count%4 != 0){
            for (int i=0; i<MyAppDataManager.friendViewList.count%4; i++)
            {
                NSDictionary *personDic=[MyAppDataManager.friendViewList objectAtIndex:i+indexPath.row*4];
//                NSLog(@"%@",personDic);
                [cell setImage:[personDic valueForKey:@"uface"] distance:[MyAppDataManager IsInternationalLanguage:[personDic valueForKey:@"dmeter"]] sex:[[personDic valueForKey:@"gender"] isEqualToString:@"m"] flag:NO forTile:i name:[personDic valueForKey:@"pname"]];
            }
            
        }
        else{
            for (int i=0; i<4; i++)
            {
                NSDictionary *personDic=[MyAppDataManager.friendViewList objectAtIndex:i+indexPath.row*4];
                [cell setImage:[personDic valueForKey:@"uface"] distance:[MyAppDataManager IsInternationalLanguage:[personDic valueForKey:@"dmeter"]] sex:[[personDic valueForKey:@"gender"] isEqualToString:@"m"] flag:NO forTile:i name:[personDic valueForKey:@"pname"]];
            }
            
        }
        return  cell;

    }

}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (BOOL)tableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    NSDictionary *friendsDos = [MyAppDataManager.contentArr objectAtIndex:indexPath.row];
    BanBu_DynamicDetailsController *aDyn= [[BanBu_DynamicDetailsController alloc]initWithDynamic:friendsDos];
    aDyn.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:aDyn animated:YES];
    [aDyn release];
    
}

#pragma mark - gridDelegate

-(void)gridCell:(BanBu_GridCell *)cell didSelectedTile:(NSInteger)tileIndex realRow:(NSInteger)row{
//    NSLog(@"%d----%d",row,MyAppDataManager.friendViewList.count);
    if(row<[MyAppDataManager.friendViewList count]){
        
        NSDictionary *buddy = [MyAppDataManager.friendViewList objectAtIndex:row];
        BanBu_PeopleProfileController *peopleFfofile = [[BanBu_PeopleProfileController alloc] initWithProfile:buddy displayType:DisplayTypePeopleProfile];
        [self.navigationController pushViewController:peopleFfofile animated:YES];
        [peopleFfofile release];
        
    }
}

#pragma mark - BanBuDelegate

- (void)banbuRequestDidFinished:(NSDictionary *)resDic error:(NSError *)error
{
    self.navigationController.view.userInteractionEnabled = YES;
    [TKLoadingView dismissTkFromView:self.view animated:YES afterShow:0.0];
    if(error)
    {
        if([error.domain isEqualToString:BanBuDataformatError])
        {
            [TKLoadingView showTkloadingAddedTo:self.view title:NSLocalizedString(@"data_error", nil) activityAnimated:NO duration:2.0];
        }
        else
        {
            [TKLoadingView showTkloadingAddedTo:self.view title:NSLocalizedString(@"network_error", nil) activityAnimated:NO duration:2.0];
        }
        
        [self finishedLoading];
        return;
    }
    //NSLog(@"%@",resDic);
    if([AppComManager respondsDic:resDic isFunctionData:BanBu_Get_Friend_FriendDos]){
        if([[resDic valueForKey:@"ok"]boolValue]){
            if(_isLoadingRefresh)
            {
                
                [MyAppDataManager.friendsDos removeAllObjects];
            }
            //对名字和话，进行替换后，在存储
            for(int i=0;i<[[resDic valueForKey:@"list"] count];i++){
                
                NSMutableDictionary *aDic = [NSMutableDictionary dictionaryWithDictionary:[[resDic valueForKey:@"list"] objectAtIndex:i]];
                NSMutableDictionary *mcontentDic = [NSMutableDictionary dictionaryWithDictionary:[AppComManager getAMsgFrom64String:[aDic valueForKey:@"mcontent"]]];
                NSMutableString *saytextStr = [NSMutableString stringWithString:[mcontentDic valueForKey:@"saytext"]];
                if([saytextStr rangeOfString:@"__modifyuserfile__"].location != NSNotFound){
//                     NSLog(@"%@----%d",saytextStr,[saytextStr rangeOfString:@"__modifyuserfile__"].location);
                    if([[MyAppDataManager getPreferredLanguage] isEqual:@"zh-Hans"]){
                        [saytextStr replaceCharactersInRange:NSMakeRange([saytextStr rangeOfString:@"__modifyuserfile__"].location, 18) withString:@""];
                        
                        saytextStr = (NSMutableString *)[@"__modifyuserfile__ " stringByAppendingString:saytextStr];
                        //                            NSLog(@"%@",saytextStr);
                        
                    }
                }
                
                [mcontentDic setValue:[MyAppDataManager IsInternationalLanguage:(NSString *)saytextStr] forKey:@"saytext"];
                
                [mcontentDic setValue:[MyAppDataManager IsInternationalLanguage:[mcontentDic valueForKey:@"saytext"]] forKey:@"saytext"];
                [aDic setValue:mcontentDic forKey:@"mcontent"];
                
                if([MyAppDataManager theRevisedName:[aDic valueForKey:@"pname"] andUID:[aDic valueForKey:@"userid"]]){
                    //                    NSLog(@"%@----%@",[aDic valueForKey:@"userid"],[MyAppDataManager IsMinGanWord:[MyAppDataManager theRevisedName:[aDic valueForKey:@"pname"] andUID:[aDic valueForKey:@"userid"]]]);
                    [aDic setObject:[MyAppDataManager theRevisedName:[aDic valueForKey:@"pname"] andUID:[aDic valueForKey:@"userid"]] forKey:@"pname"];
                    
                }
                [MyAppDataManager.friendsDos addObject:aDic];
                
            }
            
  
            NSArray *sortedArray = [MyAppDataManager.friendsDos sortedArrayUsingComparator: ^(id obj1, id obj2) {
                
                return [[obj2 objectForKey:@"actid"] compare:[obj1 objectForKey:@"actid"] options:NSCaseInsensitiveSearch];

//                if ([[obj2 objectForKey:@"ameters"] integerValue] < [[obj1 objectForKey:@"ameters"] integerValue]) {
//                    return (NSComparisonResult)NSOrderedDescending;
//                }
//                if ([[obj2 objectForKey:@"ameters"] integerValue] > [[obj1 objectForKey:@"ameters"] integerValue]) {
//                    return (NSComparisonResult)NSOrderedAscending;
//                }
//                return (NSComparisonResult)NSOrderedSame;
            }];
            [MyAppDataManager.friendsDos removeAllObjects];
            [MyAppDataManager.friendsDos addObjectsFromArray:sortedArray];
            [MyAppDataManager.contentArr addObjectsFromArray:MyAppDataManager.friendsDos];
            
          
            if(![MyAppDataManager.friendsDos count]){
                if(cryImageView || noticeLabel){
                    [[self.view viewWithTag:100]removeFromSuperview];
                    [[self.view viewWithTag:101]removeFromSuperview];
                }
                cryImageView = [[UIImageView alloc]initWithFrame:CGRectMake(136, 100, 48, 48)];
                cryImageView.tag = 100;
                cryImageView.image = [UIImage imageNamed:@"cry.png"];
                [self.tableView addSubview:cryImageView];
                [cryImageView release];
                noticeLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 150, 300, 100)];
                noticeLabel.tag = 101;
                noticeLabel.numberOfLines = 0;
                noticeLabel.text = NSLocalizedString(@"friendNewsNoticeLabel", nil);
                noticeLabel.textColor = [UIColor darkGrayColor];
                noticeLabel.font = [UIFont systemFontOfSize:16];
                noticeLabel.textAlignment = UITextAlignmentCenter;
                noticeLabel.backgroundColor = [UIColor clearColor];
                [self.tableView addSubview:noticeLabel];
//                [noticeLabel release];
            }
            //        __block typeof(MyAppDataManager)blockDataManager = MyAppDataManager;
            //
            //        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
            //        dispatch_async(queue, ^{
            //
            //            NSData *friendDosData = [NSKeyedArchiver archivedDataWithRootObject:blockDataManager.friendsDos];
            //            NSString *path = [DataCachePath stringByAppendingPathComponent:@"friendDosdata"];
            //            [friendDosData writeToFile:path atomically:YES];
            //            
            //        });
//            [BanBu_RefreshTime getCurrentTime:@"friends_updateTime"];
         }
      }
    else if([AppComManager respondsDic:resDic isFunctionData:BanBu_Get_Friend_ViewList]){
//        NSLog(@"%@",resDic);
        if([[resDic valueForKey:@"ok"]boolValue]){
            if(_isLoadingRefresh)
            {
                
                [MyAppDataManager.friendViewList removeAllObjects];
            }
            [MyAppDataManager.friendViewList addObjectsFromArray:[resDic valueForKey:@"list"]];
            NSArray *sortedArray = [MyAppDataManager.friendViewList sortedArrayUsingComparator: ^(id obj1, id obj2) {
//                NSLog(@"%@",[obj1 objectForKey:@"linkid"]);
                return [[obj2 objectForKey:@"linkid"] compare:[obj1 objectForKey:@"linkid"] options:NSCaseInsensitiveSearch];
                
                //                if ([[obj2 objectForKey:@"ameters"] integerValue] < [[obj1 objectForKey:@"ameters"] integerValue]) {
                //                    return (NSComparisonResult)NSOrderedDescending;
                //                }
                //                if ([[obj2 objectForKey:@"ameters"] integerValue] > [[obj1 objectForKey:@"ameters"] integerValue]) {
                //                    return (NSComparisonResult)NSOrderedAscending;
                //                }
                //                return (NSComparisonResult)NSOrderedSame;
            }];
            [MyAppDataManager.friendViewList removeAllObjects];
            [MyAppDataManager.friendViewList addObjectsFromArray:sortedArray];

            if(![MyAppDataManager.friendViewList count]){
                if(cryImageView || noticeLabel){
                    [[self.view viewWithTag:100]removeFromSuperview];
                    [[self.view viewWithTag:101]removeFromSuperview];
                }
                cryImageView = [[UIImageView alloc]initWithFrame:CGRectMake(136, 100, 48, 48)];
                cryImageView.tag = 100;
                cryImageView.image = [UIImage imageNamed:@"cry.png"];
                [self.tableView addSubview:cryImageView];
//                [cryImageView release];
                noticeLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 150, 300, 100)];
                noticeLabel.tag = 101;
                noticeLabel.numberOfLines = 0;
                noticeLabel.text = NSLocalizedString(@"visitRecordNoticeLabel", nil);
                noticeLabel.font = [UIFont systemFontOfSize:16];
                noticeLabel.textAlignment = UITextAlignmentCenter;
                noticeLabel.textColor = [UIColor darkGrayColor];
                noticeLabel.backgroundColor = [UIColor clearColor];
                [self.tableView addSubview:noticeLabel];
//                [noticeLabel release];
            }
            
            
            
            //        __block typeof(MyAppDataManager)blockDataManager = MyAppDataManager;
            //
            //        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
            //        dispatch_async(queue, ^{
            //
            //            NSData *friendViewListData = [NSKeyedArchiver archivedDataWithRootObject:blockDataManager.friendViewList];
            //            NSString *path = [DataCachePath stringByAppendingPathComponent:@"friendViewListdata"];
            //            [friendViewListData writeToFile:path atomically:YES];
            //            
            //        });

        }

    }
    [self.tableView reloadData];
    [self finishedLoading];
}










@end
