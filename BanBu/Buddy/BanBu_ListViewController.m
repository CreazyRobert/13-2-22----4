//
//  BanBu_ListViewController.m
//  BanBu
//
//  Created by laiguo zheng on 12-7-10.
//  Copyright (c) 2012年 17xy. All rights reserved.
//

#import "BanBu_ListViewController.h"
#import "BanBu_ListCell.h"
#import "BanBu_PeopleProfileController.h"
#import "AppDataManager.h"
#import "AppCommunicationManager.h"
#import "TKLoadingView.h"

#import "BanBu_BroadcastCell.h"
#import "BanBu_DynamicDetailsController.h"
#import "BanBu_ReleaseController.h"
//#import "BanBu_RefreshTime.h"
#define HuaTag 111

#import "CJSONSerializer.h"
#import "CJSONDeserializer.h"
#import "TKTabBarController.h"
@interface BanBu_ListViewController ()



@end

@implementation BanBu_ListViewController
@synthesize currentPage =_currentPage;
@synthesize DosPage = _DosPage;
@synthesize listType = _listType;

- (void)viewDidLoad
{
    
//    NSLog(@"aabbbaaaa");
        _existDic = [[NSMutableDictionary alloc]initWithCapacity:1];

    [super viewDidLoad];
//    self.navigationItem.title = @"";
    
    self.tableView.backgroundColor = [UIColor colorWithRed:255.0/255 green:250.0/255 blue:240.0/255 alpha:1.0];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//    self.tableView.showsVerticalScrollIndicator = NO;

//    UIView *leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 270, 44)];
//    UIButton *sortButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    sortButton.frame = CGRectMake(0, 7, 50 ,30);
//    [sortButton setBackgroundImage:[[UIImage imageNamed:@"app_nav_btn_bg1.png"] stretchableImageWithLeftCapWidth:15.0 topCapHeight:15.0] forState:UIControlStateNormal];
//    [sortButton setBackgroundImage:[[UIImage imageNamed:@"app_nav_btn_bg2.png"] stretchableImageWithLeftCapWidth:15.0 topCapHeight:15.0] forState:UIControlStateHighlighted];
//    [sortButton setTitle:NSLocalizedString(@"sortButton", nil) forState:UIControlStateNormal];
//    sortButton.titleLabel.font = [UIFont systemFontOfSize:14];
//    [sortButton addTarget:self action:@selector(sort:) forControlEvents:UIControlEventTouchUpInside];
//    [leftView addSubview:sortButton];
    /*
	// Image And title
//	NSArray *titleItems = [NSArray arrayWithObjects:NSLocalizedStringFromTable(@"附近的人", @"XXXX...这就不写了", nil),NSLocalizedStringFromTable(@"附近广播", @"XXXX...这就不写了", nil), nil];
    NSArray *titleItems = [NSArray arrayWithObjects:NSLocalizedString(@"titleItem", nil),NSLocalizedString(@"titleItem1", nil), nil];

	UIImage *normal_left = [[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"nav_btn_left_bg1" ofType:@"png"]];
	UIImage *normal_right = [[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"nav_btn_right_bg1" ofType:@"png"]];
	NSMutableArray *unselectImages = [[NSMutableArray alloc]initWithObjects:normal_left, normal_right, nil];
	[normal_left release];
	[normal_right release];
	UIImage *select_left = [[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"nav_btn_left_bg2" ofType:@"png"]];
	UIImage *select_right = [[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"nav_btn_right_bg2" ofType:@"png"]];
	NSMutableArray *selectImages = [[NSMutableArray alloc]initWithObjects: select_left, select_right, nil];
	[select_left release];
	[select_right release];
	_segmentedControl= [[CQSegmentControl alloc] initWithItemsAndStype:titleItems stype:TitleAndImageSegmented];
    _segmentedControl.delegate = self;
    _segmentedControl.segmentedControlStyle = UISegmentedControlStyleBordered;
	for (UIView *subView in _segmentedControl.subviews)
	{
		[subView removeFromSuperview];
	}
	_segmentedControl.normalImageItems = unselectImages;
	[unselectImages release];
	_segmentedControl.highlightImageItems = selectImages;
	[selectImages release];
	_segmentedControl.selectedSegmentIndex = 0;
	_segmentedControl.frame = CGRectMake(90, 7, 140, 30);
	_segmentedControl.selectedItemColor = [UIColor whiteColor];
	_segmentedControl.unselectedItemColor = [UIColor whiteColor];
	_segmentedControl.font = [UIFont systemFontOfSize:14];
	[leftView addSubview:_segmentedControl];
	[_segmentedControl release];
    
    self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:leftView] autorelease];
    */
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(tochange:) name:@"toselect" object:nil];
    
    UIButton *listButton = [UIButton buttonWithType:UIButtonTypeCustom];
    listButton.frame = CGRectMake(0, 0, 50, 30);
    [listButton setBackgroundImage:[[UIImage imageNamed:@"app_nav_btn_bg1.png"] stretchableImageWithLeftCapWidth:15.0 topCapHeight:15.0] forState:UIControlStateNormal];
    [listButton setImage:[UIImage imageNamed:@"button_grid.png"] forState:UIControlStateNormal];
    [listButton setImageEdgeInsets:UIEdgeInsetsMake(3.0, 5.0, 2.0, 3.0)];
    [listButton addTarget:self action:@selector(changeList:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[[UIBarButtonItem alloc] initWithCustomView:listButton] autorelease];
    self.navigationItem.rightBarButtonItem = rightItem;

    // 筛选的
    UIButton *selectButton=[UIButton buttonWithType:UIButtonTypeCustom];
    [selectButton setTitle:NSLocalizedString(@"sortButton", nil)  forState:UIControlStateNormal];
    selectButton.titleLabel.font=[UIFont systemFontOfSize:15];

    CGFloat widthButton = [selectButton.titleLabel.text sizeWithFont:[UIFont systemFontOfSize:15]].width;
    selectButton.frame=CGRectMake(0, 0, widthButton +20, 30);
    
    [selectButton setBackgroundImage:[[UIImage imageNamed:@"app_nav_btn_bg1.png"] stretchableImageWithLeftCapWidth:15.0 topCapHeight:15.0] forState:UIControlStateNormal];
    
     [selectButton setImageEdgeInsets:UIEdgeInsetsMake(3.0, 5.0, 2.0, 3.0)];
    [selectButton addTarget:self action:@selector(toSelsect:) forControlEvents:UIControlEventTouchUpInside];

    UIBarButtonItem *leftButton = [[[UIBarButtonItem alloc] initWithCustomView:selectButton] autorelease];
    self.navigationItem.leftBarButtonItem = leftButton;

    _sortByList = YES;
    _currentPage = 0;
    
    
    
    
    NSString *listPath = [DataCachePath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@-nearbuddysdata",MyAppDataManager.useruid]];
    [MyAppDataManager.nearBuddys addObjectsFromArray:[NSKeyedUnarchiver unarchiveObjectWithData:[NSData dataWithContentsOfFile:listPath]]];

    NSString *contentPath = [DataCachePath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@-nearbuddydatacopy",MyAppDataManager.useruid]];
//    NSLog(@"%@",[NSKeyedUnarchiver unarchiveObjectWithData:[NSData dataWithContentsOfFile:contentPath]]);
    NSMutableArray *tempArr = [NSMutableArray array];
    [tempArr addObjectsFromArray:[NSKeyedUnarchiver unarchiveObjectWithData:[NSData dataWithContentsOfFile:contentPath]]];
    if(tempArr.count){
        
        //将数据Arr转成NSString，然后国际化
        NSString *jsonStr = [[CJSONSerializer serializer] serializeArray:tempArr];
        jsonStr = [MyAppDataManager IsInternationalLanguage:jsonStr];
        NSData *jsonData = [jsonStr dataUsingEncoding:NSUTF8StringEncoding];
        NSArray *deserializeArray = [[CJSONDeserializer deserializer]deserializeAsArray:jsonData error:nil];

        
        NSMutableArray *mutableArr = [NSMutableArray arrayWithArray:deserializeArray];

        self.tempNearPeople = mutableArr;


    }else{
        NSMutableArray *mutableArr = [NSMutableArray arrayWithCapacity:0];
        self.tempNearPeople = mutableArr;

    }

}

-(void)toSelsect:(UIButton *)sender
{
  
    BanBu_choiceController *choice=[[BanBu_choiceController alloc]init];
    
    BanBu_NavigationController *nav=[[[BanBu_NavigationController alloc]initWithRootViewController:choice] autorelease];
    
    nav.modalPresentationStyle=UIModalPresentationPageSheet;
    
    [self presentModalViewController:nav animated:YES];
    
    [choice release];
    


}

-(void)tochange:(NSNotification *)notif
{

   
   [self setRefreshing];
    
    
    

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

- (void)viewDidAppear:(BOOL)animated
{
    
//    NSLog(@"aaaaaaaaaa");
    [super viewDidAppear:animated];
    
    if(!MyAppDataManager.nearBuddys.count || !_currentPage)
    {
        [self setRefreshing];
        return;
    }
    
    
    AppLocationManager.delegate = self;
    if(!_firstRun)
    {
        _firstRun = YES;
//        if(!_locationTip)
//        {
//            _locationTip = [[UILabel alloc] initWithFrame:CGRectMake(0, 34, 320, 30)];
//            _locationTip.backgroundColor = [UIColor colorWithWhite:0 alpha:.8];
//            _locationTip.textAlignment = UITextAlignmentCenter;
//            _locationTip.text = @"       正在定位……";
//            _locationTip.textColor = [UIColor whiteColor];
//            _locationTip.font = [UIFont systemFontOfSize:14];
//            
//            UIActivityIndicatorView *hua = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(100, 5, 14, 20)];
//            hua.tag = HuaTag;
//            hua.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhite;
//            [_locationTip addSubview:hua];
//            [hua startAnimating];
//            [hua release];
//            [self.navigationController.view insertSubview:_locationTip atIndex:self.navigationController.view.subviews.count-1];
//            [_locationTip release];
//            
//            [UIView animateWithDuration:.5
//                             animations:^{
//                                 
//                                 _locationTip.frame = CGRectMake(0, 64, 320, 30);
//                                 
//                             }];
//        }
        
        //BanBu_LocationManager *locationManager = [BanBu_LocationManager sharedLocationManager];
        //[locationManager setDelegate:self];
        //[locationManager getCurrentAddress];
    }
    
    
    //判断是否要刷新页面
//    NSString *timeNowString = [BanBu_RefreshTime getCurrentTime:nil];
//    BOOL isReload = [BanBu_RefreshTime now:timeNowString isLaterBefore:[UserDefaults valueForKey:@"nearby_updateTime"]];
//    if(isReload){
//       [self setRefreshing];
//    }
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
}

- (void)dealloc
{
    
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"toselect" object:nil];
    self.tempNearPeople = nil;
    [_existDic release];
    [super dealloc];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)sort:(UIButton *)button
{
    BanBu_SmallListView *listView = (BanBu_SmallListView *)[self.navigationController.view viewWithTag:102];
    if(listView)
    {
        [listView dismissWithAnimation:YES];
        return;
    }
    
    BanBu_SmallListView *smallList = [[BanBu_SmallListView alloc] initWithFrame:CGRectMake(0, 0, 95, 100) listTitles:[NSArray arrayWithObjects:NSLocalizedString(@"listTitle", nil),NSLocalizedString(@"listTitle1", nil),NSLocalizedString(@"listTitle2", nil), nil]];
    smallList.tag = 102;
    smallList.delegate = self;
    smallList.selectedIndex = _listType;
    [smallList showFromPoint:CGPointMake(0.0, 65) inView:self.navigationController.view animation:YES];
    [smallList release];
}

- (void)changeList:(UIButton *)button
{
    _sortByList = !_sortByList;
    [button setImage:_sortByList?[UIImage imageNamed:@"button_grid.png"]:[UIImage imageNamed:@"button_list.png"] forState:UIControlStateNormal];
    
    [UIView beginAnimations:@"change" context:nil];
    [UIView setAnimationDuration:0.5f];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationRepeatAutoreverses:NO];
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:self.tableView cache:YES];
    [self.tableView reloadData];
    [UIView commitAnimations];
    
}


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	
//    if(_isPeople){
//        NSInteger row = [MyAppDataManager.nearBuddys count];
//        return _sortByList?row:row/4;
//    }
    if(_sortByList){
        return [MyAppDataManager.nearBuddys count];
    }else{
        if([MyAppDataManager.nearBuddys count]%4!=0){
            
            gridViewRow = [MyAppDataManager.nearBuddys count]/4+1;
        }else{
            gridViewRow = [MyAppDataManager.nearBuddys count]/4;
        }
//        NSLog(@"%d----%d",gridViewRow,[MyAppDataManager.nearBuddys count]);
        return gridViewRow;
    }
}


-(CGFloat)tableView:(UITableView *)tableView
heightForRowAtIndexPath:(NSIndexPath *)indexPath{
	
//    if(_isPeople){
        if(_sortByList)
            return 84;
        else
            return 79;
//    }
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
        if(_sortByList)
        {
            static NSString *ListCellIdentifier = @"ListCellIdentifier";
            BanBu_ListCell *cell = (BanBu_ListCell *)[tableView dequeueReusableCellWithIdentifier:ListCellIdentifier];
            if(cell == nil)
            {
                cell = [[[BanBu_ListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ListCellIdentifier] autorelease];
                cell.selectionStyle = UITableViewCellSelectionStyleBlue;
                
            }
            if(self.tempNearPeople.count){
//                NSLog(@"%d",indexPath.row);
                NSDictionary *buddy = [self.tempNearPeople objectAtIndex:indexPath.row];
                
//                NSLog(@"%@",buddy);
                //            NSLog(@"%@----%@-%@",[buddy valueForKey:@"userid"],[buddy valueForKey:@"llat"],[buddy valueForKey:@"llong"]);
                
                [cell setAvatar:[buddy valueForKey:@"uface"]];
                [cell setName:[buddy valueForKey:@"pname"]];
                [cell setAge:[buddy valueForKey:@"oldyears"] sex: [buddy valueForKey:@"gender"]];
            
                [cell setDistance:[buddy valueForKey:@"dmeter"] timeAgo:[buddy valueForKey:@"dtime"]];
                [cell setSignature:[buddy valueForKey:@"sayme"]];
                [cell setLastInfo:[buddy valueForKey:@"ltime"]];
                //            [cell sextNeedsDisplay];

            }
          
            return cell;
        }
        else
        {
            static NSString *GridCellIdentifier = @"GridCellIdentifier";
            BanBu_GridCell *cell = (BanBu_GridCell *)[tableView dequeueReusableCellWithIdentifier:GridCellIdentifier];
            if(cell == nil)
            {
                cell = [[[BanBu_GridCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:GridCellIdentifier] autorelease];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.delegate = self;
            }
            if(cell.contentView.subviews.count){
                for(UIButton *temp in cell.contentView.subviews){
                    temp.hidden = YES;
                }
            }
            if(gridViewRow-1 == indexPath.row && MyAppDataManager.nearBuddys.count%4 != 0){
                for (int i=0; i<MyAppDataManager.nearBuddys.count%4; i++)
                {
                    NSDictionary *personDic=[self.tempNearPeople objectAtIndex:i+indexPath.row*4];
//                    NSLog(@"%@",personDic);
                    [cell setImage:[personDic valueForKey:@"uface"] distance:[personDic valueForKey:@"dmeter"] sex:[[personDic valueForKey:@"gender"] isEqualToString:@"m"] flag:NO forTile:i name:[personDic valueForKey:@"pname"]];
                }
                
            }
            else{
                for (int i=0; i<4; i++)
                {
                    NSDictionary *personDic=[self.tempNearPeople objectAtIndex:i+indexPath.row*4];
                    [cell setImage:[personDic valueForKey:@"uface"] distance:[personDic valueForKey:@"dmeter"] sex:[[personDic valueForKey:@"gender"] isEqualToString:@"m"] flag:NO forTile:i name:[personDic valueForKey:@"pname"]];
                }
                
            }
            
            return  cell;
        }

 
}


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
        if(_sortByList)
        {
            [self.navigationController setNavigationBarHidden:NO animated:NO];

            NSDictionary *buddy = [MyAppDataManager.nearBuddys objectAtIndex:indexPath.row];
//            NSLog(@"%@",buddy);
            BanBu_PeopleProfileController *peopleFfofile = [[BanBu_PeopleProfileController alloc] initWithProfile:buddy displayType:DisplayTypePeopleProfile];
            peopleFfofile.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:peopleFfofile animated:YES];
            [peopleFfofile release];
        }

    

    
}

-(void)tableView:(UITableView *)tableView didEndDisplayingCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if(cell){
        [(BanBu_ListCell *)cell cancelImageLoad];
    }
}
/*
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{

    contentOffsetY = scrollView.contentOffset.y;
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
//    NSLog(@"%f",scrollView.contentOffset.y);
    newContentOffsetY = scrollView.contentOffset.y;
//    if(newContentOffsetY > oldContentOffsetY && oldContentOffsetY > contentOffsetY){
//        // 向上滚动
//        
//        
//    }else if (newContentOffsetY < oldContentOffsetY && oldContentOffsetY < contentOffsetY) { // 向下滚动
//        
//         NSLog(@"down");
//        
//    } else {
// 
//        NSLog(@"dragging");
//        
//    }
    if(scrollView.dragging){
        if(newContentOffsetY - contentOffsetY > 5.0){//向上拖拽
            // 隐藏导航栏和选项栏
//            [self.navigationController setNavigationBarHidden:YES animated:YES];
//            [(TKTabBarController *)self.tabBarController setTabBarHidde:YES];
//            
//            
//            BanBu_ListViewController *listVC = nil;
//            for(UIViewController *vc in self.navigationController.viewControllers){
//                if([vc isKindOfClass:[BanBu_ListViewController class]]){
//                    listVC = (BanBu_ListViewController *)vc;
//                    
//                    [UIView animateWithDuration:0.5 animations:^{
//                        listVC.view.frame = CGRectMake(0, 0, 320, __MainScreen_Height);
//                    }];
//                    break;
//                }
//            }

        }
        else if(contentOffsetY - newContentOffsetY > 5.0){//向下拖拽
            // 显示导航栏和选项栏
//            [self.navigationController setNavigationBarHidden:NO animated:YES];
            
//            [(TKTabBarController *)self.tabBarController setTabBarHidde:NO];
//            BanBu_ListViewController *listVC = nil;
//            for(UIViewController *vc in self.navigationController.viewControllers){
//                if([vc isKindOfClass:[BanBu_ListViewController class]]){
//                    listVC = (BanBu_ListViewController *)vc;
//                    
//                    [UIView animateWithDuration:0.5 animations:^{
//                        listVC.view.frame = CGRectMake(0, 0, 320, __MainScreen_Height-49);
//                    }];
//                    break;
//                }
//            }
        }
    }
    
    
}

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    oldContentOffsetY = scrollView.contentOffset.y;
}
*/
#pragma mark -
#pragma mark small listview delegate
- (void)smallListView:(BanBu_SmallListView *)smallListView didSelectIndex:(NSInteger)index
{
    [smallListView dismissWithAnimation:YES];
    _listType = index;
   // [self setRefreshing];
}

#pragma mark -
#pragma mark gridCell delegate

- (void)gridCell:(BanBu_GridCell *)cell didSelectedTile:(NSInteger)tileIndex realRow:(NSInteger)row
{
    NSDictionary *buddy = [MyAppDataManager.nearBuddys objectAtIndex:row];
    
    BanBu_PeopleProfileController *peopleFfofile = [[BanBu_PeopleProfileController alloc] initWithProfile:buddy displayType:DisplayTypePeopleProfile];
    peopleFfofile.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:peopleFfofile animated:YES];
    [peopleFfofile release];
}

- (void)banBu_LocationManager:(BanBu_LocationManager *)manager didGetLocation:(CLLocationCoordinate2D)coordinate success:(BOOL)success
{
    if(success)
      [self setRefreshing];
}

- (void)banBu_LocationManager:(BanBu_LocationManager *)manager didGetLocationAddr:(NSString *)addr
{
    if(!_locationTip)
        return;
    
    UILabel *tipView = _locationTip;
    _locationTip = nil;
        
    UIActivityIndicatorView *hua = (UIActivityIndicatorView *)[tipView viewWithTag:HuaTag];
    [hua removeFromSuperview];
    NSString *tip = nil;
    if(addr)
        tip = [NSString stringWithFormat:@"%@%@",NSLocalizedString(@"tipNotice", nil),addr];
    else
        tip =NSLocalizedString(@"tipNotice1", nil);
    tipView.text = tip;
    [UIView animateWithDuration:.5
                          delay:2.0
                        options:0
                     animations:^{
                         tipView.frame = CGRectMake(0, 34, 320, 30);
                     } completion:^(BOOL finished) {
                             [tipView removeFromSuperview];
                     }];
}

- (void)loadingData
{

    if([self.view viewWithTag:100]){
        [[self.view viewWithTag:100]removeFromSuperview];
        [[self.view viewWithTag:101]removeFromSuperview];
    }
    
    if(_isLoadingRefresh){
        [AppLocationManager getLocation];
        _currentPage = 1;

    }
    else{
        _currentPage ++;

//        if(_currentPage == 2){
//            _currentPage = 1;
//        }
    }
        
    NSMutableDictionary *parDic = [NSMutableDictionary dictionary];
//        [parDic setValue:[NSString stringWithFormat:@"%i",_listType] forKey:ListKey];
    [parDic setValue:[NSString stringWithFormat:@"%.f",AppLocationManager.curLocation.latitude*1000000] forKey:Latitude];
    [parDic setValue:[NSString stringWithFormat:@"%.f",AppLocationManager.curLocation.longitude*1000000] forKey:Longitude];

    [parDic setValue:[NSString stringWithFormat:@"%i",_currentPage] forKey:PageNo];
    
    NSString *langauage=[[MyAppDataManager getPreferredLanguage]substringToIndex:2];
//    NSLog(@"%@",langauage);
    
    if([langauage isEqual:@"zh"]){
        [parDic setValue:@"cn" forKey:@"lang"];

    }else if([langauage isEqual:@"ja"]){
        [parDic setValue:@"jp" forKey:@"lang"];
    }else{
        [parDic setValue:@"en" forKey:@"lang"];
    }
        // 判断有没有这个
    
    if([UserDefaults valueForKey:[NSString stringWithFormat:@"%@electNearBy",MyAppDataManager.useruid]])
    {
       NSMutableDictionary *ob= [UserDefaults valueForKey:[NSString stringWithFormat:@"%@electNearBy",MyAppDataManager.useruid]];
        
     
        NSMutableDictionary *dict=[[NSMutableDictionary alloc]init];
        
        switch ([[ob valueForKey:@"time"] intValue]) {
            case 0:
                
                [dict setValue:@"" forKey:@"lasttime"];
                
                break;
            case 1:
             
                [dict setValue:@"15" forKey:@"lasttime"];
                
            break;
            
            case 2:
                
                [dict setValue:@"60" forKey:@"lasttime"];
                
            break;
                
            case 3:
                
                [dict setValue:@"1440" forKey:@"lasttime"];
                
            break;
                
            case 4:
                [dict setValue:@"4320" forKey:@"lasttime"];
                
            break;
                
            default:
            
            break;
        }
        
        switch ([[ob valueForKey:@"sex"] intValue]) {
              case 0:
                
                [dict setValue:@"" forKey:@"gender"];
                break;
               case 1:
                
                [dict setValue:@"m" forKey:@"gender"];
                break;
               
                case 2:
                
                [dict setValue:@"f" forKey:@"gender"];
                
                break;
    
               default:
                break;
        }
        
        [parDic setValue:dict forKey:@"searchby"];
        
        [dict release];
        
    }
        [AppComManager getBanBuData:BanBu_Get_User_Nearby par:parDic delegate:self];
    
        // self.navigationController.view.userInteractionEnabled = NO;

}




- (void)banbuRequestDidFinished:(NSDictionary *)resDic error:(NSError *)error
{
//    NSDateFormatter *formatter = [[[NSDateFormatter alloc] init] autorelease];
//    [formatter setLocale:[NSLocale currentLocale]];
//    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss.SS"];
//    NSString *stime = [formatter stringFromDate:[NSDate date]];
    NSLog(@"1111111%@",stime);
    
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
        if(_isLoadingMore)
            _currentPage --;
        
       return;
    }

    if([AppComManager respondsDic:resDic isFunctionData:BanBu_Get_User_Nearby]){
        
        if([[resDic valueForKey:@"ok"] boolValue]){
//            NSLog(@"%@",[[resDic valueForKey:@"list"] objectAtIndex:0]);
//            NSArray *sortedArray = [[resDic valueForKey:@"list"] sortedArrayUsingComparator: ^(id obj1, id obj2) {
//                if ([[obj2 objectForKey:@"mtime"] integerValue] < [[obj1 objectForKey:@"mtime"] integerValue]) {
//                    return (NSComparisonResult)NSOrderedDescending;
//                }
//                if ([[obj2 objectForKey:@"mtime"] integerValue] > [[obj1 objectForKey:@"mtime"] integerValue]) {
//                    return (NSComparisonResult)NSOrderedAscending;
//                }
//                return (NSComparisonResult)NSOrderedSame;
//            }];
//            [MyAppDataManager.nearBuddys removeAllObjects];
//            [MyAppDataManager.nearBuddys addObjectsFromArray:sortedArray];
            
            
            //去除黑名单的人
            NSMutableArray *blacklistArr = [NSMutableArray arrayWithCapacity:0];
            
            NSArray *flistArr = [NSArray arrayWithArray:[[[UserDefaults valueForKey:MyAppDataManager.useruid] valueForKey:@"friendlist"] valueForKey:@"flist"]];
            //            NSLog(@"%@",flistArr);
            for(NSDictionary *blackDic in flistArr){
                if([[blackDic valueForKey:@"linkkind"]isEqualToString:@"x"]){
                    [blacklistArr addObject:[blackDic valueForKey:@"fuid"]];
                }
            }
//            NSLog(@"%@",blacklistArr);
            
            if(_isLoadingRefresh)
            {
                [MyAppDataManager.nearBuddys removeAllObjects];
                 //对名字和话，进行替换后，在存储
                for(int i=0;i<[[resDic valueForKey:@"list"]count];i++)
                {
                    
                    NSMutableDictionary *aDic = [NSMutableDictionary dictionaryWithDictionary:[[resDic valueForKey:@"list"] objectAtIndex:i]];
                    if([MyAppDataManager theRevisedName:[aDic valueForKey:@"pname"] andUID:[aDic valueForKey:@"userid"]]){
                    [aDic setObject:[MyAppDataManager theRevisedName:[aDic valueForKey:@"pname"] andUID:[aDic valueForKey:@"userid"]] forKey:@"pname"];
                    
                    }
                    BOOL isBlack = NO;
                    for(NSString *useridStr in blacklistArr){
                        if([useridStr isEqualToString:[aDic valueForKey:@"userid"]]){
                            isBlack = YES;
                            break;
                        }
                    }
                    if(!isBlack){
                        [MyAppDataManager.nearBuddys addObject:aDic];

                    }
                    
                    
                  }
            }
            else{
                NSMutableArray *filterArr = [NSMutableArray arrayWithArray:[resDic valueForKey:@"list"]];
//                NSLog(@"%@",resDic);
//                NSLog(@"%@",filterArr);
                NSMutableArray *congfuArr = [NSMutableArray array];
                
                for(int i=0;i<[filterArr count];i++)
                {
                    
                    BOOL isBlack = NO;
                    for(NSString *useridStr in blacklistArr){
                        if([useridStr isEqualToString:[[filterArr objectAtIndex:i] valueForKey:@"userid"]]){
                            isBlack = YES;
                            break;
                        }
                    }
                    if(isBlack){
                        
                        [congfuArr addObject:[filterArr objectAtIndex:i]];
                        
                    }
                    /*
                    //                     for(int j=0;j<MyAppDataManager.nearBuddys.count;j++)
                    //                     {
                    //                         if([[[filterArr objectAtIndex:i] valueForKey:@"userid"] isEqualToString:[[MyAppDataManager.nearBuddys objectAtIndex:j] valueForKey:@"userid"]])
                    //                         {
                    //                             //                    NSLog(@"%@----%@",[[reArray objectAtIndex:i] valueForKey:@"userid"],[[reArray objectAtIndex:j] valueForKey:@"userid"]);
                    //                             //                             [filterArr removeObject:[MyAppDataManager.nearBuddys objectAtIndex:j]];
                    //                             [congfuArr addObject:[MyAppDataManager.nearBuddys objectAtIndex:j]];
                    //                         }
                    //                         else
                    //                         {
                    //                             NSMutableDictionary *aDic = [NSMutableDictionary dictionaryWithDictionary:[filterArr objectAtIndex:i]];
                    //                             if([MyAppDataManager theRevisedName:[aDic valueForKey:@"pname"] andUID:[aDic valueForKey:@"userid"]])
                    //                             {
                    //                                 [aDic setObject:[MyAppDataManager theRevisedName:[aDic valueForKey:@"pname"] andUID:[aDic valueForKey:@"userid"]] forKey:@"pname"];
                    //
                    //                             }
                    //                                  [filterArr replaceObjectAtIndex:i withObject:aDic];
                    
                    //
                    //                         }
                    //                     }
                    
                    */
                    //修改去重******************
                    
                    if(_existDic&&[_existDic valueForKey:[[filterArr objectAtIndex:i] valueForKey:@"userid"]])
                    {
                        [congfuArr addObject:[filterArr objectAtIndex:i]];
                    }
                    else
                    {
                        NSMutableDictionary *aDic = [NSMutableDictionary dictionaryWithDictionary:[filterArr objectAtIndex:i]];
                        if([MyAppDataManager theRevisedName:[aDic valueForKey:@"pname"] andUID:[aDic valueForKey:@"userid"]])
                        {
                            [aDic setObject:[MyAppDataManager theRevisedName:[aDic valueForKey:@"pname"] andUID:[aDic valueForKey:@"userid"]] forKey:@"pname"];
                            [filterArr replaceObjectAtIndex:i withObject:aDic];
                            
                        }
                    }
                [_existDic setObject:[NSNumber numberWithBool:YES] forKey:[[filterArr objectAtIndex:i] objectForKey:@"userid"]];
                    //*******************
                    
                }
//                for(int i=0;i<filterArr.count;i++)
//                {
//                    
////                    NSLog(@"%@",filterArr);
////                    NSLog(@"%@",[[filterArr objectAtIndex:i] objectForKey:@"userid"]);
//                    [_existDic setObject:[NSNumber numberWithBool:YES] forKey:[[filterArr objectAtIndex:i] objectForKey:@"userid"]];
//                }
                [filterArr removeObjectsInArray:congfuArr];

                [MyAppDataManager.nearBuddys addObjectsFromArray:filterArr];


                
                
                
//                NSMutableArray *filterArr = [NSMutableArray arrayWithArray:[resDic valueForKey:@"list"]];
//                for(int i=0;i<[[resDic valueForKey:@"list"] count];i++){
//                    for(int j=0;j<MyAppDataManager.nearBuddys.count;j++){
//                        if([[[[resDic valueForKey:@"list"] objectAtIndex:i] valueForKey:@"userid"] isEqualToString:[[MyAppDataManager.nearBuddys objectAtIndex:j] valueForKey:@"userid"]]){
//                            //                    NSLog(@"%@----%@",[[reArray objectAtIndex:i] valueForKey:@"userid"],[[reArray objectAtIndex:j] valueForKey:@"userid"]);
//                            [filterArr removeObjectAtIndex:j];
//                        }else{
//                            NSMutableDictionary *aDic = [NSMutableDictionary dictionaryWithDictionary:[[resDic valueForKey:@"list"] objectAtIndex:i]];
//                            if([MyAppDataManager theRevisedName:[aDic valueForKey:@"pname"] andUID:[aDic valueForKey:@"userid"]]){
//                                [aDic setObject:[MyAppDataManager theRevisedName:[aDic valueForKey:@"pname"] andUID:[aDic valueForKey:@"userid"]] forKey:@"pname"];
//                                
//                            }
//                            [filterArr replaceObjectAtIndex:i withObject:aDic];
//                        }
//                    }
//                }
//                [MyAppDataManager.nearBuddys addObjectsFromArray:filterArr];
                
                /*
                 //去重，从第二页算
                 for(int i=0;i<MyAppDataManager.nearBuddys.count;i++){
                    //            NSLog(@"%@",[[reArray objectAtIndex:i] valueForKey:@"userid"]);
                    for(int j=i+1;j<MyAppDataManager.nearBuddys.count;j++){
                        
                        if([[[MyAppDataManager.nearBuddys objectAtIndex:i] valueForKey:@"userid"] isEqualToString:[[MyAppDataManager.nearBuddys objectAtIndex:j] valueForKey:@"userid"]]){
                            //                    NSLog(@"%@----%@",[[reArray objectAtIndex:i] valueForKey:@"userid"],[[reArray objectAtIndex:j] valueForKey:@"userid"]);
                             [MyAppDataManager.nearBuddys removeObjectAtIndex:j];
                            
                        }
                    }
                    
                }
                
                NSArray *sortedArray = [MyAppDataManager.nearBuddys sortedArrayUsingComparator: ^(id obj1, id obj2) {
                    if ([[obj2 objectForKey:@"meters"] integerValue] < [[obj1 objectForKey:@"meters"] integerValue]) {
                        return (NSComparisonResult)NSOrderedDescending;
                    }
                    if ([[obj2 objectForKey:@"meters"] integerValue] > [[obj1 objectForKey:@"meters"] integerValue]) {
                        return (NSComparisonResult)NSOrderedAscending;
                    }
                    return (NSComparisonResult)NSOrderedSame;
                }];
                [MyAppDataManager.nearBuddys removeAllObjects];
                [MyAppDataManager.nearBuddys addObjectsFromArray:sortedArray];
                 */
                
            }
            
      
             
            
//            NSLog(@"%d",MyAppDataManager.nearBuddys.count);
            if([MyAppDataManager.nearBuddys count]){
                [self setLoadingMore:YES];
            }else{
                [self setLoadingMore:NO];
                cryImageView = [[UIImageView alloc]initWithFrame:CGRectMake(136, 100, 48, 48)];
                cryImageView.tag = 100;
                cryImageView.image = [UIImage imageNamed:@"cry.png"];
                [self.tableView addSubview:cryImageView];
                [cryImageView release];
                noticeLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 150, 300, 100)];
                noticeLabel.tag = 101;
                noticeLabel.numberOfLines = 0;
                noticeLabel.text = NSLocalizedString(@"noticeLabel", nil);
                noticeLabel.font = [UIFont systemFontOfSize:16];
                noticeLabel.textAlignment = UITextAlignmentCenter;
                noticeLabel.backgroundColor = [UIColor clearColor];
                noticeLabel.textColor = [UIColor darkGrayColor];
                [self.tableView addSubview:noticeLabel];
                [noticeLabel release];
            }

//            //将数据Arr转成NSString，然后国际化
            NSString *jsonStr = [[CJSONSerializer serializer] serializeArray:MyAppDataManager.nearBuddys];
            jsonStr = [MyAppDataManager IsInternationalLanguage:jsonStr];
            NSData *jsonData = [jsonStr dataUsingEncoding:NSUTF8StringEncoding];
            NSArray *deserializeArray = [[CJSONDeserializer deserializer]deserializeAsArray:jsonData error:nil];
            [self.tempNearPeople removeAllObjects];
            [self.tempNearPeople addObjectsFromArray:deserializeArray];
            NSLog(@"%@",self.tempNearPeople);
//
//            NSDateFormatter *formatter2 = [[[NSDateFormatter alloc] init] autorelease];
//            [formatter2 setLocale:[NSLocale currentLocale]];
//            [formatter2 setDateFormat:@"yyyy-MM-dd HH:mm:ss.SS"];
//            NSString *stime2 = [formatter2 stringFromDate:[NSDate date]];
//            NSLog(@"222222222%@",stime2);

//            __block typeof(MyAppDataManager)blockDataManager = MyAppDataManager;

//            NSDateFormatter *formatter3 = [[[NSDateFormatter alloc] init] autorelease];
//            [formatter3 setLocale:[NSLocale currentLocale]];
//            [formatter3 setDateFormat:@"yyyy-MM-dd HH:mm:ss.SS"];
//            NSString *stime3 = [formatter3 stringFromDate:[NSDate date]];
//            NSLog(@"3333333333%@",stime3);
            __block typeof(MyAppDataManager)blockDataManager = MyAppDataManager;
            dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
            dispatch_async(queue, ^{
                NSData *listData = [NSKeyedArchiver archivedDataWithRootObject:blockDataManager.nearBuddys];
                NSString *path = [DataCachePath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@-nearbuddysdata",MyAppDataManager.useruid]];
                [listData writeToFile:path atomically:YES];
            });
            dispatch_queue_t queue1 = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
            dispatch_async(queue1, ^{
                NSData *listDataCopy = [NSKeyedArchiver archivedDataWithRootObject:self.tempNearPeople];
                NSString *path = [DataCachePath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@-nearbuddydatacopy",MyAppDataManager.useruid]];
                [listDataCopy writeToFile:path atomically:YES];
            });
            //存储刷新的最后时间
//            [BanBu_RefreshTime getCurrentTime:@"nearby_updateTime"];
        }
     }
    [self.tableView reloadData];
    [self finishedLoading];
    
//    NSDateFormatter *formatter1 = [[[NSDateFormatter alloc] init] autorelease];
//    [formatter1 setLocale:[NSLocale currentLocale]];
//    [formatter1 setDateFormat:@"yyyy-MM-dd HH:mm:ss.SS"];
//    NSString *stime1 = [formatter1 stringFromDate:[NSDate date]];
//    NSLog(@"4444444%@",stime1);
}



@end
