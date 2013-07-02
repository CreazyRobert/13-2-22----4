//
//  BanBu_MyFriendViewController.m
//  BanBu
//
//  Created by laiguo zheng on 12-7-12.
//  Copyright (c) 2012年 17xy. All rights reserved.
//

#import "BanBu_MyFriendViewController.h"
#import "BanBu_ListCell.h"
#import "BanBu_PeopleProfileController.h"
#import "BanBu_AddNewFriendViewController.h"
#import "AppDataManager.h"
#import "AppCommunicationManager.h"
#import "TKLoadingView.h"
//#import "BanBu_RefreshTime.h"

#import "CJSONSerializer.h"
#import "CJSONDeserializer.h"

@interface BanBu_MyFriendViewController ()

@end

@implementation BanBu_MyFriendViewController

@synthesize listType = _listType;
//@synthesize currentPage = _currentPage;
@synthesize typeString = _typeString;
@synthesize number=_number;


- (void)viewDidLoad
{
    [super viewDidLoad];
    requestArr = [[NSMutableArray alloc]initWithCapacity:10];
    deleteArr = [[NSMutableArray alloc] init];
    
    self.navigationItem.title = @"";
    
    self.tableView.backgroundColor = [UIColor colorWithRed:255.0/255 green:250.0/255 blue:240.0/255 alpha:1.0];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    NSString *defaultTitle;
    if(summary.count){
        defaultTitle = [NSString stringWithFormat:@"%@(%@)",NSLocalizedString(@"summary_h", nil),[summary objectForKey:@"h"]];
    }else{
        defaultTitle = [NSString stringWithFormat:@"%@(0)",NSLocalizedString(@"summary_h", nil)];
        
    }
    
    backX = [defaultTitle sizeWithFont:[UIFont boldSystemFontOfSize:22] constrainedToSize:CGSizeMake(200, 44)].width+20+16;
    //    NSLog(@"%f",backX);
    NSDictionary *defaultSum = [[[UserDefaults valueForKey:MyAppDataManager.useruid]valueForKey:@"friendlist"]valueForKey:@"summary"];
    summary = [[NSDictionary alloc]initWithDictionary:defaultSum];
    
    UIView *centerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 260, 44)];

    
    categoryButton = [UIButton buttonWithType:UIButtonTypeCustom];
    categoryButton.frame = CGRectMake(160-backX/2, 0, backX, 44);
    [categoryButton addTarget:self action:@selector(categoryAction:) forControlEvents:UIControlEventTouchUpInside];
    //    categoryButton.backgroundColor = [UIColor greenColor];
    //    categoryButton.alpha = 0.5;
    [categoryButton setTitleEdgeInsets:UIEdgeInsetsMake(3, 2, 2, 2)];
    [categoryButton setTitle:[NSString stringWithFormat:@"%@(%@)",NSLocalizedString(@"summary_h", nil),[defaultSum objectForKey:@"h"]] forState:UIControlStateNormal];
    categoryButton.titleLabel.font = [UIFont boldSystemFontOfSize:19];
    [centerView addSubview:categoryButton];
    laImageView = [[UIImageView alloc]initWithFrame:CGRectMake(categoryButton.frame.origin.x+backX-16, 15, 16, 16)];
    laImageView.image = [UIImage imageNamed:@"down.png"];
    [centerView addSubview:laImageView];
    [laImageView release];
    self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:centerView] autorelease];
    [centerView release];
    
    UIButton *addButton = [UIButton buttonWithType:UIButtonTypeCustom];
    addButton.frame = CGRectMake(0, 0, 40, 30);
    [addButton addTarget:self action:@selector(addFriend:) forControlEvents:UIControlEventTouchUpInside];
    [addButton setBackgroundImage:[[UIImage imageNamed:@"app_nav_btn_bg1.png"] stretchableImageWithLeftCapWidth:15.0 topCapHeight:15.0] forState:UIControlStateNormal];
    //    [addButton setBackgroundImage:[[UIImage imageNamed:@"app_nav_btn_bg2.png"] stretchableImageWithLeftCapWidth:15.0 topCapHeight:15.0] forState:UIControlStateHighlighted];
    [addButton setImage:[UIImage imageNamed:@"btn_plus.png"] forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:addButton] autorelease];
    
    _listType = 0;
    //    _currentPage = 0;
    //    _currentPage = [UserDefaults integerForKey:FriendListPage];
    NSString *friendListPath = [DataCachePath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@-hlistdata",MyAppDataManager.useruid]];
    [MyAppDataManager.friends addObjectsFromArray:[NSKeyedUnarchiver unarchiveObjectWithData:[NSData dataWithContentsOfFile:friendListPath]]];
//    NSLog(@"%d",MyAppDataManager.friends.count);
    
//    NSLog(@"%@",[MyAppDataManager.friends objectAtIndex:0]);
    if(MyAppDataManager.friends.count){
        
        //将数据Arr转成NSString，然后国际化
        NSString *jsonStr = [[CJSONSerializer serializer] serializeArray:MyAppDataManager.friends];
        jsonStr = [MyAppDataManager IsInternationalLanguage:jsonStr];
        NSData *jsonData = [jsonStr dataUsingEncoding:NSUTF8StringEncoding];
        NSArray *deserializeArray = [[CJSONDeserializer deserializer]deserializeAsArray:jsonData error:nil];
        
        
        NSMutableArray *mutableArr = [NSMutableArray arrayWithArray:deserializeArray];
        
        self.tempNearPeople = mutableArr;
        NSLog(@"%@",[self.tempNearPeople objectAtIndex:0]);
        
        
    }else{
        NSMutableArray *mutableArr = [NSMutableArray arrayWithCapacity:0];
        self.tempNearPeople = mutableArr;
        
    }
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
}

-(void)rotateImageView{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3];
    CGAffineTransform transform = CGAffineTransformRotate(laImageView.transform, -M_PI);
    laImageView.transform = transform;
    [UIView commitAnimations];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    BanBu_SmallListView *listView = (BanBu_SmallListView *)[self.navigationController.view viewWithTag:102];
    if(listView){
        [listView dismissWithAnimation:YES];
        [self rotateImageView];
    }
}


- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

    if(!MyAppDataManager.friends.count)
    {
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

- (void)dealloc
{
    self.tempNearPeople = nil;
    [super dealloc];
    
}



- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void)categoryAction:(UIButton *)button{
    BanBu_SmallListView *listView = (BanBu_SmallListView *)[self.navigationController.view viewWithTag:102];
    if(listView)
    {
        [self rotateImageView];
        [listView dismissWithAnimation:YES];
        return;
    }
    [self rotateImageView];
    
    BanBu_SmallListView *smallList = [[BanBu_SmallListView alloc] initWithFrame:CGRectMake(0, 130.0-backX/2, 200.0, 150) listTitles:[NSArray arrayWithObjects:[NSString stringWithFormat:@"%@(%@)",NSLocalizedString(@"summary_h", nil),[summary objectForKey:@"h"]],[NSString stringWithFormat:@"%@(%@)",NSLocalizedString(@"summary_g", nil),[summary objectForKey:@"g"]],[NSString stringWithFormat:@"%@(%@)",NSLocalizedString(@"summary_f", nil),[summary objectForKey:@"f"]],nil]];
    smallList.tag = 102;
    smallList.delegate = self;
    smallList.selectedIndex = _listType;
    [smallList showFromPoint:CGPointMake(60, 65) inView:self.navigationController.view animation:YES];
    [smallList release];
    
}

- (void)addFriend:(UIButton *)button
{
    BanBu_AddNewFriendViewController *addNew = [[BanBu_AddNewFriendViewController alloc] init];
    addNew.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:addNew animated:YES];
    [addNew release];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return MyAppDataManager.friends.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
	
    return 84;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ListCellIdentifier = @"ListCellIdentifier";
    BanBu_ListCell *cell = (BanBu_ListCell *)[tableView dequeueReusableCellWithIdentifier:ListCellIdentifier];
    if(cell == nil)
    {
        cell = [[[BanBu_ListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ListCellIdentifier] autorelease];
        cell.selectionStyle = UITableViewCellSelectionStyleBlue;
        
    }
    if(MyAppDataManager.friends.count){
        NSDictionary *buddy = [self.tempNearPeople objectAtIndex:indexPath.row];
        
        [cell setAvatar:[buddy valueForKey:@"uface"]];
        [cell setName:[buddy valueForKey:@"pname"]];
        [cell setAge:[buddy valueForKey:@"oldyears"] sex: [buddy valueForKey:@"gender"]];
        [cell setDistance:[buddy valueForKey:@"dmeter"] timeAgo:[buddy valueForKey:@"dtime"]];
        [cell setLastInfo:[buddy valueForKey:@"ltime"]];
        [cell setSignature:[buddy valueForKey:@"sayme"]];
    }
   
//    [cell setNeedsDisplay];
    return cell;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *aFriend = [MyAppDataManager.friends objectAtIndex:indexPath.row];
    BanBu_PeopleProfileController *peopleFfofile = [[BanBu_PeopleProfileController alloc] initWithProfile:aFriend displayType:DisplayTypePeopleProfile];
    peopleFfofile.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:peopleFfofile animated:YES];
    [peopleFfofile release];
}

-(void)tableView:(UITableView *)tableView didEndDisplayingCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if(cell){
        [(BanBu_ListCell*)cell cancelImageLoad];
    }
}


#pragma mark -
#pragma mark small listview delegate
- (void)smallListView:(BanBu_SmallListView *)smallListView didSelectIndex:(NSInteger)index
{
    
    if([self.view viewWithTag:100]){
        [[self.view viewWithTag:100]removeFromSuperview];
        [[self.view viewWithTag:101]removeFromSuperview];
    }
    
    NSArray *titles;
    if(summary.count){
        titles = [NSArray arrayWithObjects:[NSString stringWithFormat:@"%@(%@)",NSLocalizedString(@"summary_h", nil),[summary objectForKey:@"h"]],[NSString stringWithFormat:@"%@(%@)",NSLocalizedString(@"summary_g", nil),[summary objectForKey:@"g"]],[NSString stringWithFormat:@"%@(%@)",NSLocalizedString(@"summary_f", nil),[summary objectForKey:@"f"]],nil];
    }else{
        titles = [NSArray arrayWithObjects:[NSString stringWithFormat:@"%@(0)",NSLocalizedString(@"summary_h", nil)],[NSString stringWithFormat:@"%@(0)",NSLocalizedString(@"summary_g", nil)],[NSString stringWithFormat:@"%@(0)",NSLocalizedString(@"summary_f", nil)],nil];
        
    }
    [smallListView dismissWithAnimation:YES];
    _listType = index;
    [categoryButton setTitle:[titles objectAtIndex:_listType] forState:UIControlStateNormal];
    
    backX = [[titles objectAtIndex:_listType] sizeWithFont:[UIFont boldSystemFontOfSize:19] constrainedToSize:CGSizeMake(200, 44)].width+20+16;
    categoryButton.frame = CGRectMake(160-backX/2, 0, backX, 44);
    laImageView.frame = CGRectMake(categoryButton.frame.origin.x+backX-16, 15, 16, 16);
    [self setRefreshing];
}



- (void)loadingData
{
    BanBu_SmallListView *listView = (BanBu_SmallListView *)[self.navigationController.view viewWithTag:102];
    if(listView)
    {
        [listView dismissWithAnimation:YES];
        [self rotateImageView];
    }
    if([self.view viewWithTag:100]){
        [[self.view viewWithTag:100]removeFromSuperview];
        [[self.view viewWithTag:101]removeFromSuperview];
    }
    //    if(_isLoadingRefresh)
    //        _currentPage = 1;
    //    else
    //        _currentPage ++;
    
    NSMutableDictionary *parDic = [NSMutableDictionary dictionary];
    NSArray *guanxi = [NSArray arrayWithObjects:@"h",@"g",@"f", nil];
    [parDic setValue:[guanxi objectAtIndex:_listType] forKey:@"linkkind"];
    //    [parDic setValue:[NSString stringWithFormat:@"%i",_currentPage] forKey:PageNo];
    [AppComManager getBanBuData:BanBu_Get_Friend_OfMy par:parDic delegate:self];
//    self.navigationController.view.userInteractionEnabled = NO;
    //NSLog(@"%@",parDic);
}




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
//    NSLog(@"%@",resDic);

    if([AppComManager respondsDic:resDic isFunctionData:BanBu_Get_Friend_OfMy]){
        if([[resDic valueForKey:@"ok"]boolValue]){

            
            if(_isLoadingRefresh)
            {
                [MyAppDataManager.friends removeAllObjects];
            }
            //对名字和话，进行替换后，在存储
            for(int i=0;i<[[resDic valueForKey:@"list"]count];i++){
                
                NSMutableDictionary *aDic = [NSMutableDictionary dictionaryWithDictionary:[[resDic valueForKey:@"list"] objectAtIndex:i]];
                if([MyAppDataManager theRevisedName:[aDic valueForKey:@"pname"] andUID:[aDic valueForKey:@"userid"]]){
                    [aDic setObject:[MyAppDataManager theRevisedName:[aDic valueForKey:@"pname"] andUID:[aDic valueForKey:@"userid"]] forKey:@"pname"];
                    
                }
                [MyAppDataManager.friends addObject:aDic];
            }
             
            NSMutableDictionary *uidDic = [NSMutableDictionary dictionaryWithDictionary:[UserDefaults valueForKey:MyAppDataManager.useruid]];
            [uidDic setValue:[resDic valueForKey:@"friendlist"] forKey:FriendShip];
            [UserDefaults setValue:uidDic forKey:MyAppDataManager.useruid];
            [UserDefaults synchronize];
            
            NSArray *sortedArray = [MyAppDataManager.friends sortedArrayUsingComparator: ^(id obj1, id obj2) {
                if ([[obj2 objectForKey:@"meters"] integerValue] < [[obj1 objectForKey:@"meters"] integerValue]) {
                    return (NSComparisonResult)NSOrderedDescending;
                }
                if ([[obj2 objectForKey:@"meters"] integerValue] > [[obj1 objectForKey:@"meters"] integerValue]) {
                    return (NSComparisonResult)NSOrderedAscending;
                }
                return (NSComparisonResult)NSOrderedSame;
            }];
            [MyAppDataManager.friends removeAllObjects];
            [MyAppDataManager.friends addObjectsFromArray:sortedArray];
 
            summary = [[NSDictionary alloc]initWithDictionary:[resDic objectForKey:@"summary"]];
            //++++++
            NSArray *titles;
            if(summary.count){
                titles = [NSArray arrayWithObjects:[NSString stringWithFormat:@"%@(%@)",NSLocalizedString(@"summary_h", nil),[summary objectForKey:@"h"]],[NSString stringWithFormat:@"%@(%@)",NSLocalizedString(@"summary_g", nil),[summary objectForKey:@"g"]],[NSString stringWithFormat:@"%@(%@)",NSLocalizedString(@"summary_f", nil),[summary objectForKey:@"f"]],nil];
            }else{
                titles = [NSArray arrayWithObjects:[NSString stringWithFormat:@"%@(0)",NSLocalizedString(@"summary_h", nil)],[NSString stringWithFormat:@"%@(0)",NSLocalizedString(@"summary_g", nil)],[NSString stringWithFormat:@"%@(0)",NSLocalizedString(@"summary_f", nil)],nil];
                
            }
            [categoryButton setTitle:[titles objectAtIndex:_listType] forState:UIControlStateNormal];
            //++++++
            if([MyAppDataManager.friends count]==0){
                if(cryImageView || noticeLabel){
                    [[self.view viewWithTag:100]removeFromSuperview];
                    [[self.view viewWithTag:101]removeFromSuperview];
                }
                cryImageView = [[UIImageView alloc]initWithFrame:CGRectMake(136, 100, 48, 48)];
                cryImageView.image = [UIImage imageNamed:@"cry.png"];
                cryImageView.tag= 100;
                [self.tableView addSubview:cryImageView];
                [cryImageView release];
                noticeLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 150, 300, 100)];
                noticeLabel.tag = 101;
                noticeLabel.numberOfLines = 0;
                NSArray *noticeArray = [NSArray arrayWithObjects:NSLocalizedString(@"friendNoticeLabel", nil),NSLocalizedString(@"friendNoticeLabel1", nil),NSLocalizedString(@"friendNoticeLabel2", nil), nil];
                noticeLabel.text = [noticeArray objectAtIndex:_listType];
                noticeLabel.font = [UIFont systemFontOfSize:16];
                noticeLabel.textAlignment = UITextAlignmentCenter;
                noticeLabel.backgroundColor = [UIColor clearColor];
                noticeLabel.textColor = [UIColor darkGrayColor];
                [self.tableView addSubview:noticeLabel];
                [noticeLabel release];
            }
            
            
            //将数据Arr转成NSString，然后国际化
            NSString *jsonStr = [[CJSONSerializer serializer] serializeArray:MyAppDataManager.friends];
            jsonStr = [MyAppDataManager IsInternationalLanguage:jsonStr];
            NSData *jsonData = [jsonStr dataUsingEncoding:NSUTF8StringEncoding];
            NSArray *deserializeArray = [[CJSONDeserializer deserializer]deserializeAsArray:jsonData error:nil];
            [self.tempNearPeople removeAllObjects];
            [self.tempNearPeople addObjectsFromArray:deserializeArray];
            
            
            __block typeof(MyAppDataManager)blockDataManager = MyAppDataManager;
            
            dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
            dispatch_async(queue, ^{
                
                NSData *listData = [NSKeyedArchiver archivedDataWithRootObject:blockDataManager.friends];
                NSArray *guanxi = [NSArray arrayWithObjects:@"h",@"g",@"f", nil];
                NSString *path = [DataCachePath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@-%@listdata",MyAppDataManager.useruid,[guanxi objectAtIndex:_listType]]];
                [listData writeToFile:path atomically:YES];
                
            });
            
//            [BanBu_RefreshTime getCurrentTime:@"friends_updateTime"];

        }
    }

    
    
    
    [self.tableView reloadData];
    [self finishedLoading];
    
    //NSLog(@"rrrr:%@",MyAppDataManager.friends);
    
}




@end
