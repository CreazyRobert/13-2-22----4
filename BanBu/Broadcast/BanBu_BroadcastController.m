//
//  BanBu_BroadcastControllerViewController.m
//  BanBu
//
//  Created by 17xy on 12-7-31.
//
//

#import "BanBu_BroadcastController.h"
//#import "BanBu_PeopleProfileController.h"
#import "BanBu_BroadcastCell.h"
#import "BanBu_AppDelegate.h"
#import "BanBu_ReleaseController.h"
#import "BanBu_DynamicDetailsController.h"

#import "AppDataManager.h"
#import "AppCommunicationManager.h"
#import "TKLoadingView.h"
#import "BanBu_LocationManager.h"
//#import "BanBu_RefreshTime.h"
@interface BanBu_BroadcastController ()

@end

@implementation BanBu_BroadcastController

@synthesize currentPage = _currentPage;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
    }
    return self;
}

//变变变。。。
//-(void)changeView{
//    BanBu_AppDelegate *delegate =(BanBu_AppDelegate *)[UIApplication sharedApplication].delegate;
//    [delegate changeListAndBroadcast:NO];
//}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
//    self.title = @"附近广播"; 
    self.tableView.backgroundColor = [UIColor colorWithRed:255.0/255 green:250.0/255 blue:240.0/255 alpha:1.0];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
//    UIView *rightView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 88, 44)];
//    UILabel *lineLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 1, 44)];
//    [rightView addSubview:lineLabel];
//    [lineLabel release];
//    UIButton *sortButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    sortButton.frame = CGRectMake(1, 0, 44, 44);
//    sortButton.titleLabel.font = [UIFont systemFontOfSize:14];
//    [sortButton setTitle:NSLocalizedString(@"sortButton", nil) forState:UIControlStateNormal];
//    [sortButton addTarget:self action:@selector(sort:) forControlEvents:UIControlEventTouchUpInside];
//    [rightView addSubview:sortButton];
    
    UIButton *listButton = [UIButton buttonWithType:UIButtonTypeCustom];
    listButton.frame = CGRectMake(0, 0, 50, 30);
    listButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [listButton setBackgroundImage:[[UIImage imageNamed:@"app_nav_btn_bg1.png"] stretchableImageWithLeftCapWidth:15.0 topCapHeight:15.0] forState:UIControlStateNormal];
    [listButton setBackgroundImage:[[UIImage imageNamed:@"app_nav_btn_bg2.png"] stretchableImageWithLeftCapWidth:15.0 topCapHeight:15.0] forState:UIControlStateHighlighted];
    [listButton setTitle:NSLocalizedString(@"listButton", nil) forState:UIControlStateNormal];
    [listButton addTarget:self action:@selector(releaseRadio) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[[UIBarButtonItem alloc] initWithCustomView:listButton] autorelease];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    _DosPage = 0;

    NSString *broadcastPath = [DataCachePath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@-broadcastdata",MyAppDataManager.useruid]];
    [MyAppDataManager.nearDos addObjectsFromArray:[NSKeyedUnarchiver unarchiveObjectWithData:[NSData dataWithContentsOfFile:broadcastPath]]];
    
    NSLog(@"%@",MyAppDataManager.nearDos);
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    BanBu_SmallListView *listView = (BanBu_SmallListView *)[self.navigationController.view viewWithTag:102];
    if(listView)
    {
        [listView dismissWithAnimation:YES];
    }
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
//    NSMutableDictionary *parDic = [NSMutableDictionary dictionary];
//    [parDic setValue:MyAppDataManager.loginid forKey:@"loginid"];
//    [parDic setValue:[NSString stringWithFormat:@"%.f",AppLocationManager.curLocation.latitude ] forKey:@"plat"];
//    [parDic setValue:[NSString stringWithFormat:@"%.f",AppLocationManager.curLocation.longitude] forKey:@"plong"];
//    [parDic setValue:@"1" forKey:@"pageno"];
//    [AppComManager getBanBuData:BanBu_Get_User_Neardo par:parDic delegate:self];
    if(!MyAppDataManager. nearDos.count || !_DosPage){
        [self setRefreshing];
        return;
    }
    
    //判断是否要刷新页面
//    NSString *timeNowString = [BanBu_RefreshTime getCurrentTime:nil];
//    BOOL isReload = [BanBu_RefreshTime now:timeNowString isLaterBefore:[UserDefaults valueForKey:@"squares_updateTime"]];
//    if(isReload){
//        [self setRefreshing];
//    }
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];

}

- (void)dealloc
{

    [super dealloc];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void)releaseRadio{
    BanBu_ReleaseController *aRelease=[[BanBu_ReleaseController alloc]init];
    aRelease.hidesBottomBarWhenPushed =  YES;
    [self.navigationController pushViewController:aRelease animated:YES];
    [aRelease release];
}

- (void)sort:(UIButton *)button
{
    BanBu_SmallListView *listView = (BanBu_SmallListView *)[self.navigationController.view viewWithTag:102];
    if(listView)
    {
        [listView dismissWithAnimation:YES];
        return;
    }
    
    BanBu_SmallListView *smallList = [[BanBu_SmallListView alloc] initWithFrame:CGRectMake(0, 0, 80.0, 100) listTitles:[NSArray arrayWithObjects:@"仅女生",@"仅男生",@"全部", nil]];
    smallList.tag = 102;
    smallList.delegate = self;
    smallList.selectedIndex = 2;
    [smallList showFromPoint:CGPointMake(220.0, 65) inView:self.navigationController.view animation:YES];
    [smallList release];
}


#pragma mark -
#pragma mark small listview delegate
- (void)smallListView:(BanBu_SmallListView *)smallListView didSelectIndex:(NSInteger)index
{
    [smallListView dismissWithAnimation:YES];
}

#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [MyAppDataManager.nearDos count];
}


-(CGFloat)tableView:(UITableView *)tableView
heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
 
	return 84;
  
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
   
    static NSString *BroadcastCellIdentifier = @"BroadcastCellIdentifier";
    
    BanBu_BroadcastCell *cell=(BanBu_BroadcastCell *)[tableView dequeueReusableCellWithIdentifier:BroadcastCellIdentifier];
    if(cell == nil)
    {
        
        cell = [[[BanBu_BroadcastCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:BroadcastCellIdentifier] autorelease];
        cell.selectionStyle = UITableViewCellSelectionStyleBlue;
        
    }
    //        NSDictionary *nearDo= [MyAppDataManager.nearDos objectAtIndex:indexPath.row];
    //        //NSLog(@"%@",nearDo);
    //        NSDictionary *conArray = [MyAppDataManager.contentArr objectAtIndex:indexPath.row];
    
    NSDictionary *nearDo;
    NSDictionary *conArray;
    if(MyAppDataManager.nearDos.count){
        
        nearDo= [MyAppDataManager.nearDos objectAtIndex:indexPath.row];
        
    }else{
        nearDo= nil;
        
    }
    //        if(MyAppDataManager.contentArr.count){
    //            conArray =[MyAppDataManager.contentArr objectAtIndex:indexPath.row];
    //
    //        }else{
    //            conArray = nil;
    //
    //        }
    conArray = [AppComManager getAMsgFrom64String:[nearDo valueForKey:@"mcontent"]];
    /*
    //自适应文字长短
    {
        NSString *str;
        if([conArray count]==0){
            str = @"";
        }else{
            str=[MyAppDataManager IsMinGanWord:[conArray objectForKey:@"saytext"]];
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
    
    [cell setSignature:[nearDo objectForKey:@"sstar"]];
    [cell setSignatureson:[MyAppDataManager IsInternationalLanguage:[MyAppDataManager IsMinGanWord:[conArray objectForKey:@"saytext"]]]];
    
    [cell setAvatar:[nearDo objectForKey:@"uface"]];
    [cell setName:[MyAppDataManager IsMinGanWord:[MyAppDataManager theRevisedName:[nearDo objectForKey:@"pname"] andUID:[nearDo valueForKey:@"userid"]]]];
    
    [cell setAge:[nearDo objectForKey:@"oldyears"] sex:[[nearDo objectForKey:@"gender"] isEqualToString:@"m"]];
//    [cell setDistance:[NSString stringWithFormat:@"%@%@",NSLocalizedString(@"distanceLabel", nil),[nearDo objectForKey:@"dmeter"]] timeAgo:[nearDo objectForKey:@"ltime"]];
    [cell setshowIntimeandDistance:[NSString stringWithFormat:@"%@%@ | %@",NSLocalizedString(@"intimeLabel", nil),[nearDo objectForKey:@"admeter"],[nearDo objectForKey:@"mtime"]]];
//    [cell setcommend:[NSString stringWithFormat:NSLocalizedString(@"commendLabel", nil)]];
    [cell setcommendNum:[nearDo objectForKey:@"comments"]];
//        NSLog(@"%@",[nearDo objectForKey:@"comments"]);
    
    return cell;


}


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    NSDictionary *nearDo = [MyAppDataManager.nearDos objectAtIndex:indexPath.row];
    BanBu_DynamicDetailsController *aDyn= [[BanBu_DynamicDetailsController alloc]initWithDynamic:nearDo];
    aDyn.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:aDyn animated:YES];
    [aDyn release];
    
}


-(void)loadingData{
    if([self.view viewWithTag:100]){
        [[self.view viewWithTag:100]removeFromSuperview];
        [[self.view viewWithTag:101]removeFromSuperview];
    }
    if(_isLoadingRefresh){
        _DosPage = 1;
    }else{
        _DosPage++;
    }
    NSMutableDictionary *parDic = [NSMutableDictionary dictionary];
    [parDic setValue:[NSString stringWithFormat:@"%.f",AppLocationManager.curLocation.latitude*1000000] forKey:Latitude];
    [parDic setValue:[NSString stringWithFormat:@"%.f",AppLocationManager.curLocation.longitude*1000000] forKey:Longitude];
    [parDic setValue:[NSString stringWithFormat:@"%i",_DosPage] forKey:PageNo];
    [AppComManager getBanBuData:BanBu_Get_User_Neardo par:parDic delegate:self];
//    self.navigationController.view.userInteractionEnabled = NO;
    //NSLog(@"%@",parDic);

}

#pragma mark - BanBuRequetDelegate

- (void)banbuRequestDidFinished:(NSDictionary *)resDic error:(NSError *)error{
//    NSLog(@"%@",resDic);
    self.navigationController.view.userInteractionEnabled =YES;
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
    if([AppComManager respondsDic:resDic isFunctionData:BanBu_Get_User_Neardo]){
        if([[resDic valueForKey:@"ok"] boolValue]){
            if(_isLoadingRefresh)
            {
                [MyAppDataManager.nearDos removeAllObjects];
            }
            //先排序，后追加，再去重。
            NSArray *tempArr = [[[NSArray alloc]initWithArray:[resDic valueForKey:@"list"]]autorelease];
            NSArray *sortedArray = [tempArr sortedArrayUsingComparator: ^(id obj1, id obj2) {
                //                NSLog(@"%@",[obj1 objectForKey:@"actid"]);
                return [[obj2 objectForKey:@"actid"] compare:[obj1 objectForKey:@"actid"] options:NSCaseInsensitiveSearch];
                
            }];
  
            [MyAppDataManager.nearDos addObjectsFromArray:sortedArray];

            //去重
            
            for(int i=0;i<MyAppDataManager.nearDos.count;i++){
                //            NSLog(@"%@",[[reArray objectAtIndex:i] valueForKey:@"userid"]);
                for(int j=i+1;j<MyAppDataManager.nearDos.count;j++){
                    
                    if([[[MyAppDataManager.nearDos objectAtIndex:i] valueForKey:@"actid"] isEqualToString:[[MyAppDataManager.nearDos objectAtIndex:j] valueForKey:@"actid"]]){
                        
                        [MyAppDataManager.nearDos removeObjectAtIndex:j];
                        
                    }
                }
                
            }
    
            if([MyAppDataManager.nearDos count]){
                
                [self setLoadingMore:YES];

            }else{
                [self setLoadingMore:NO];
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
                noticeLabel.text = NSLocalizedString(@"noticeLabel1", nil);
                noticeLabel.textColor = [UIColor darkGrayColor];

                noticeLabel.font = [UIFont systemFontOfSize:16];
                noticeLabel.textAlignment = UITextAlignmentCenter;
                noticeLabel.backgroundColor = [UIColor clearColor];
                [self.tableView addSubview:noticeLabel];
                [noticeLabel release];
            }
            
            __block typeof(MyAppDataManager)blockDataManager = MyAppDataManager;
            dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
            dispatch_async(queue, ^{
                NSData *broadcastData = [NSKeyedArchiver archivedDataWithRootObject:blockDataManager.nearDos];
                NSString *path = [DataCachePath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@-broadcastdata",MyAppDataManager.useruid]];
                [broadcastData writeToFile:path atomically:YES];
                
                //            NSData *contentArrData = [NSKeyedArchiver archivedDataWithRootObject:blockDataManager.contentArr];
                //            NSString *path1 = [DataCachePath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@-contentArrdata",MyAppDataManager.useruid]];
                //            [contentArrData writeToFile:path1 atomically:YES];
                
            });
            
//            [BanBu_RefreshTime getCurrentTime:@"squares_updateTime"];

        }
        
    }
    [self.tableView reloadData];
    [self finishedLoading];

    
}




@end
