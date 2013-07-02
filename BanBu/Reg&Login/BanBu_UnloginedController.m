//
//  BanBu_UnloginedController.m
//  BanBu
//
//  Created by jie zheng on 12-7-5.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "BanBu_UnloginedController.h"
#import "BanBu_LoginViewController.h"
#import "BanBu_RegViewController.h"
#import "BanBu_SettingViewController.h"
#import "BanBu_MyProfileViewController.h"
#import "BanBu_AppDelegate.h"
#import "AppDataManager.h"
#import "BanBu_SetAvatarViewController.h"
#import "BanBuAPIs.h"
#import "BanBu_UserAgreement.h"
#import "BanBu_PeopleProfileController.h"

@interface BanBu_UnloginedController ()

@end

@implementation BanBu_UnloginedController

@synthesize peopleLabel = _peopleLabel;
@synthesize currentPage=_currentPage;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = NSLocalizedString(@"fristTitle", nil);
    
    // 左登陆 右注册
    CGFloat btnLen = [NSLocalizedString(@"logButton", nil) sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(100, 30)].width;

    UIButton *loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
    loginButton.frame = CGRectMake(0, 0, btnLen+20, 30);
    [loginButton setBackgroundImage:[[UIImage imageNamed:@"app_nav_btn_bg1.png"] stretchableImageWithLeftCapWidth:15.0 topCapHeight:15.0] forState:UIControlStateNormal];
    [loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [loginButton setTitle:NSLocalizedString(@"logButton", nil) forState:UIControlStateNormal];
    loginButton.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    [loginButton addTarget:self action:@selector(goToLogin:) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.rightBarButtonItem=[[[UIBarButtonItem alloc]initWithCustomView:loginButton]autorelease];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor colorWithRed:255.0/255 green:250.0/255 blue:240.0/255 alpha:1.0];
    
//    NSString *langauage=[MyAppDataManager getPreferredLanguage];
//    if([langauage isEqual:@"zh-Hans"]){
        CGFloat btnLen1 = [NSLocalizedString(@"regButton", nil) sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(100, 30)].width;
        UIButton *regButton = [UIButton buttonWithType:UIButtonTypeCustom];
        regButton.frame = CGRectMake(0, 0, btnLen1+20, 30);
        [regButton setBackgroundImage:[[UIImage imageNamed:@"app_nav_btn_bg1.png"] stretchableImageWithLeftCapWidth:15.0 topCapHeight:15.0] forState:UIControlStateNormal];
        [regButton setTitle:NSLocalizedString(@"regButton", nil) forState:UIControlStateNormal];
        regButton.titleLabel.font = [UIFont boldSystemFontOfSize:14];
        [regButton addTarget:self action:@selector(goToReg:) forControlEvents:UIControlEventTouchUpInside];
        
        self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:regButton] autorelease];
//    }
    
    
    
    _currentPage=1;
    MyAppDataManager.regDic = [NSMutableDictionary dictionary];
    
    
    //
       
    self.tableView.scrollEnabled=NO;
   
 
    
    if(MyAppDataManager.unLoginArr)
    {
        [MyAppDataManager.unLoginArr removeAllObjects];
    }
    
//    //为了解决，当下载了服务器的ip后，在请求附近的人而加的监听
//    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(nearPeople) name:@"unlogin" object:nil];

}

-(void)viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:animated];
    [self nearPeople];
}

-(void)nearPeople{
    if(!MyAppDataManager.unLoginArr.count){
        NSMutableDictionary *parDic = [NSMutableDictionary dictionary];
        //        [parDic setValue:[NSString stringWithFormat:@"%i",_listType] forKey:ListKey];
        [parDic setValue:[NSString stringWithFormat:@"%.f",AppLocationManager.curLocation.latitude*1000000] forKey:Latitude];
        [parDic setValue:[NSString stringWithFormat:@"%.f",AppLocationManager.curLocation.longitude*1000000] forKey:Longitude];
        [parDic setValue:[NSString stringWithFormat:@"%i",_currentPage] forKey:PageNo];
        
        [AppComManager getBanBuData:BanBu_Get_User_Nearby par:parDic delegate:self Unlogin:YES];
        [TKLoadingView showTkloadingAddedTo:self.view title:NSLocalizedString(@"loadingNotice", nil) activityAnimated:YES];
    }
}

-(void)toMakeMore
{
    _currentPage++;
 
     if(_currentPage>3)
     {
     
         UIAlertView *alert=[[UIAlertView alloc]initWithTitle:NSLocalizedString(@"noticeNotLog", nil) message:nil delegate:self cancelButtonTitle:NSLocalizedString(@"cancelNotice", nil) otherButtonTitles:NSLocalizedString(@"logButton", nil), nil];
     
         
         [alert show];
         [alert release];
//         [TKLoadingView showTkloadingAddedTo:self.view title:NSLocalizedString(@"noticeNotLog", nil) activityAnimated:NO duration:2.0];
         return;
     }
    
    
    NSMutableDictionary *parDic = [NSMutableDictionary dictionary];
    //        [parDic setValue:[NSString stringWithFormat:@"%i",_listType] forKey:ListKey];
    [parDic setValue:[NSString stringWithFormat:@"%.f",AppLocationManager.curLocation.latitude*1000000] forKey:Latitude];
    [parDic setValue:[NSString stringWithFormat:@"%.f",AppLocationManager.curLocation.longitude*1000000] forKey:Longitude];
    [parDic setValue:[NSString stringWithFormat:@"%i",_currentPage] forKey:PageNo];
    
    [AppComManager getBanBuData:BanBu_Get_User_Nearby par:parDic delegate:self Unlogin:YES];
    
    activityView.hidden=NO;
    [activityView startAnimating];
    
    moreLabel.hidden=YES;
    
    self.tableView.scrollEnabled=YES;

}

-(void)banBu_LocationManager:(BanBu_LocationManager *)manager didGetLocation:(CLLocationCoordinate2D)coordinate success:(BOOL)success
{
    if(success==YES)
    {
        
        NSMutableDictionary *parDic = [NSMutableDictionary dictionary];
        //        [parDic setValue:[NSString stringWithFormat:@"%i",_listType] forKey:ListKey];
        [parDic setValue:[NSString stringWithFormat:@"%.f",AppLocationManager.curLocation.latitude*1000000] forKey:Latitude];
        [parDic setValue:[NSString stringWithFormat:@"%.f",AppLocationManager.curLocation.longitude*1000000] forKey:Longitude];
        [parDic setValue:[NSString stringWithFormat:@"%i",_currentPage] forKey:PageNo];
        
        self.tableView.scrollEnabled=NO;
        [AppComManager getBanBuData:BanBu_Get_User_Nearby par:parDic delegate:self Unlogin:YES];
        [TKLoadingView showTkloadingAddedTo:self.view title:NSLocalizedString(@"loadingNotice", nil) activityAnimated:YES];
        
        
        if(MyAppDataManager.unLoginArr)
        {
            [MyAppDataManager.unLoginArr removeAllObjects];
        }
        
        
    }
    
}

-(void)banBu_LocationManager:(BanBu_LocationManager *)manager didShowIndelegate:(NSString *)addre
{
    
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"您没有打开定位功能" message:@"请前往设置定位服务功能打开定位" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
    
    [alert show];
    
    
    [alert release];
    
    
}

// 这是 登陆注册 和取消

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
      if(buttonIndex==0)
      {
      
         // do nothing
      
      }else if(buttonIndex==1)
      {
          BanBu_LoginViewController *login=[[BanBu_LoginViewController alloc]init];

          CATransition *animation = [CATransition animation];
          animation.duration = .5f;
          animation.timingFunction=UIViewAnimationCurveEaseInOut;

          animation.fillMode = kCAFillModeForwards;
          animation.type = kCATransitionPush;
          animation.subtype = kCATransitionFade;
          [self.view.window.layer addAnimation:animation forKey:@"animation"];
          [self.navigationController pushViewController:login animated:NO];
          
          [login release];

      }
//      else
//      {
//      
//          BanBu_RegViewController *regsiter=[[BanBu_RegViewController alloc]init];
//          
//          CATransition *animation = [CATransition animation];
//          animation.duration = .5f;
//          animation.timingFunction=UIViewAnimationCurveEaseInOut;
//          animation.fillMode = kCAFillModeForwards;
//          animation.type = kCATransitionReveal;
//          animation.subtype = kCATransitionFade;
//          
//          [self.view.window.layer addAnimation:animation forKey:@"animation"];
// 
//          [self.navigationController pushViewController:regsiter animated:NO];
//          [regsiter release];
//          
//      
//      }
    
}






- (void)banbuRequestDidFinished:(NSDictionary *)resDic error:(NSError *)error
{

    NSLog(@"%@",resDic);
    [TKLoadingView dismissTkFromView:self.view animated:YES afterShow:0.0];
    
    activityView.hidden=YES;
    
    [activityView stopAnimating];
    
    moreLabel.hidden=NO; 
    
     if(![[resDic valueForKey:@"ok"] boolValue])
     {
        if(_currentPage>1)
            _currentPage--;
     }
    
//     if(!([resDic valueForKey:@"list"]&&[[resDic valueForKey:@"list"] count]>0))
//     {
//        // 从本地读取
//          NSString *str=@"unlogined";
//          NSString *path = [DataCachePath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@-nearbuddysdata",str]]; 
//         
//        
//         [MyAppDataManager.unLoginArr addObjectsFromArray:[NSKeyedUnarchiver unarchiveObjectWithData:[NSData dataWithContentsOfFile:path]]];
//         
//          if([MyAppDataManager.unLoginArr count]>16)
//          {
//              NSArray *arr=[MyAppDataManager.unLoginArr subarrayWithRange:NSMakeRange(0, 16)];
//              [MyAppDataManager.unLoginArr removeAllObjects];
//              
//              [MyAppDataManager.unLoginArr addObjectsFromArray:arr];
//           
//          }
//
//         [self.tableView reloadData];
//     
//         
//         return;
//     }
    if([[resDic valueForKey:@"ok"] boolValue]){
        
         if([[resDic valueForKey:@"list"] count]>16)
         {
             NSArray * array;
             if(__MainScreen_Height<500 )
             {
                 array =  [[resDic valueForKey:@"list"] subarrayWithRange:NSMakeRange(0, 16)];
             }else
             {
                 if([[resDic valueForKey:@"list"] count]<20){
                     array =  [[resDic valueForKey:@"list"] subarrayWithRange:NSMakeRange(0, 16)];

                 }else{
                     array =  [[resDic valueForKey:@"list"] subarrayWithRange:NSMakeRange(0, 20)];
 
                 }
//                 array =  [[resDic valueForKey:@"list"] subarrayWithRange:NSMakeRange(0, 20)];

             }
            [MyAppDataManager.unLoginArr addObjectsFromArray:array];
         }else
         {
             [MyAppDataManager.unLoginArr addObjectsFromArray:[resDic valueForKey:@"list"]];
         
         }
        //去重

        for(int i=0;i<MyAppDataManager.unLoginArr.count;i++){
//            NSLog(@"%@",[[reArray objectAtIndex:i] valueForKey:@"userid"]);
            for(int j=i+1;j<MyAppDataManager.unLoginArr.count;j++){
                
                if([[[MyAppDataManager.unLoginArr objectAtIndex:i] valueForKey:@"userid"] isEqualToString:[[MyAppDataManager.unLoginArr objectAtIndex:j] valueForKey:@"userid"]]){
//                    NSLog(@"%@----%@",[[reArray objectAtIndex:i] valueForKey:@"userid"],[[reArray objectAtIndex:j] valueForKey:@"userid"]);

                    [MyAppDataManager.unLoginArr removeObjectAtIndex:j];

                }
            }
            
        }
        
//        NSLog(@"%d",[MyAppDataManager.unLoginArr count]);

        NSArray *sortedArray = [MyAppDataManager.unLoginArr sortedArrayUsingComparator: ^(id obj1, id obj2) {
        
            if ([[obj2 objectForKey:@"meters"] integerValue] < [[obj1 objectForKey:@"meters"] integerValue]){
                
                return (NSComparisonResult)NSOrderedDescending;
            

            }if ([[obj2 objectForKey:@"meters"] integerValue] > [[obj1 objectForKey:@"meters"] integerValue]){
                
                return (NSComparisonResult)NSOrderedAscending;
                
            }
            return (NSComparisonResult)NSOrderedSame;
            
        }];
        
        [MyAppDataManager.unLoginArr removeAllObjects];
        [MyAppDataManager.unLoginArr addObjectsFromArray:sortedArray];
        if(!_one){
//            self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;

            _one = YES;
            UIView *footView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 70)];
            //加个label
            footView.backgroundColor = [UIColor clearColor];
            //    moreLabel=[[UILabel alloc]initWithFrame:CGRectMake(68, 10,190 ,35 )];
            //
            //    moreLabel.backgroundColor=[UIColor clearColor];
            //
            //    moreLabel.textColor=[UIColor grayColor];
            //
            //    moreLabel.textAlignment=NSTextAlignmentCenter;
            //
            //    moreLabel.text=@"点击获取更多";
            //
            //    moreLabel.userInteractionEnabled=YES;
            //
            //    [footView addSubview:moreLabel];
            
            _loadMoreButton = [UIButton buttonWithType:UIButtonTypeCustom];
            _loadMoreButton.frame = CGRectMake(8, 10, 304, 50);
            [_loadMoreButton setBackgroundImage:[[UIImage imageNamed:@"btn_big_normal_normal.9.png"] stretchableImageWithLeftCapWidth:10.0 topCapHeight:0] forState:UIControlStateNormal];
            [_loadMoreButton setBackgroundImage:[[UIImage imageNamed:@"btn_big_normal_press.9.png"] stretchableImageWithLeftCapWidth:10.0 topCapHeight:0] forState:UIControlStateHighlighted];
            
            [_loadMoreButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
            [_loadMoreButton setTitle:NSLocalizedString(@"loadMoreButton", nil) forState:UIControlStateNormal];
            [_loadMoreButton addTarget:self action:@selector(toMakeMore) forControlEvents:UIControlEventTouchUpInside];
            _loadMoreButton.titleLabel.font = [UIFont systemFontOfSize:18];
            [footView addSubview:_loadMoreButton];
            
            [moreLabel release];
            /*这是风火轮 */
            CGFloat btnLen = [NSLocalizedString(@"loadMoreButton", nil) sizeWithFont:[UIFont systemFontOfSize:18] constrainedToSize:CGSizeMake(300, 30)].width;
            activityView=[[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
            
            activityView.frame=CGRectMake(135-btnLen/2, 25, 20, 20);
            
            activityView.hidden=YES;
            
            [footView addSubview:activityView];
            
            [activityView release];
          

            // tap 手势 加载更多
            
            //    UITapGestureRecognizer *oneTap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(toMakeMore)];
            //    
            //    [footView addGestureRecognizer:oneTap];
            //    
            //    [oneTap release];
            
            self.tableView.tableFooterView=footView;
            
            [footView release];
        }
    
    }
    
    __block typeof(MyAppDataManager)blockDataManager = MyAppDataManager;
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        NSString *str=@"unlogined";
        NSData *listData = [NSKeyedArchiver archivedDataWithRootObject:blockDataManager.unLoginArr];
        NSString *path = [DataCachePath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@-nearbuddysdata",str]];
        [listData writeToFile:path atomically:YES];
        
    });

    
    [self.tableView reloadData];
    
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
  
    return 79;

}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

     if([MyAppDataManager.unLoginArr count]%4!=0){
        
        gridViewRow = [MyAppDataManager.unLoginArr count]/4+1;
    }else{
        gridViewRow = [MyAppDataManager.unLoginArr count]/4;
    }
     return gridViewRow;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
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
    if(gridViewRow-1 == indexPath.row && MyAppDataManager.unLoginArr.count%4 != 0){
        for (int i=0; i<MyAppDataManager.unLoginArr.count%4; i++)
        {
            NSDictionary *personDic=[MyAppDataManager.unLoginArr objectAtIndex:i+indexPath.row*4];
//            NSLog(@"%@",personDic);
            [cell setImage:[personDic valueForKey:@"uface"] distance:[personDic valueForKey:@"dmeter"] sex:[[personDic valueForKey:@"gender"] isEqualToString:@"m"] flag:NO forTile:i name:[personDic valueForKey:@"pname"]];
        }
        
    }
    else{
        for (int i=0; i<4; i++)
        {
            NSDictionary *personDic=[MyAppDataManager.unLoginArr objectAtIndex:i+indexPath.row*4];
            [cell setImage:[personDic valueForKey:@"uface"] distance:[personDic valueForKey:@"dmeter"] sex:[[personDic valueForKey:@"gender"] isEqualToString:@"m"] flag:NO forTile:i name:[personDic valueForKey:@"pname"]];
        }
        
    }
    return  cell;

}

// 代理方法

-(void)gridCell:(BanBu_GridCell *)cell didSelectedTile:(NSInteger)tileIndex realRow:(NSInteger)row
{
   
    
    NSDictionary *buddy = [MyAppDataManager.unLoginArr objectAtIndex:row];
    
    //这是错的
    /*
    BanBu_PeopleprofileC *profileC=[[BanBu_PeopleprofileC alloc]init];
    
     NSLog(@"this is my un log%@", profileC);
    [self.navigationController pushViewController:profileC animated:YES];
    
    [profileC release];
    */
    NSMutableDictionary *dic=[[NSMutableDictionary alloc]initWithDictionary:buddy] ;

    BanBu_ProfileViewController *profile=[[BanBu_ProfileViewController alloc]initWithDictionary:dic DisplayType:DisplayTypePeopleProfile];

    [self.navigationController pushViewController:profile animated:YES];

    [profile release];
    [dic release];

}
- (void)goToLogin:(UIButton *)button
{
    BanBu_LoginViewController *login = [[BanBu_LoginViewController alloc] init];
    [self.navigationController pushViewController:login animated:YES];
    [login release];
}

- (void)goToReg:(UIButton *)button
{
    [MyAppDataManager.regDic removeObjectForKey:@"regby"];
    [MyAppDataManager.regDic removeObjectForKey:@"email"];

    BanBu_RegViewController *reg = [[BanBu_RegViewController alloc] init];
    [self.navigationController pushViewController:reg animated:YES];
    [reg release];
    
}

-(void)goToScan:(UIButton *)button{
    //NSLog(@"浏览");

}

- (void)complete:(id)sender
{
    BanBu_SettingViewController *setting = [[BanBu_SettingViewController alloc] init];
    [self.navigationController pushViewController:setting animated:YES];
    [setting release];
}


- (void)my:(id)sender
{
    BanBu_MyProfileViewController *my = [[BanBu_MyProfileViewController alloc] init];
    [self.navigationController pushViewController:my animated:YES];
    [my release];
}

-(void)information{
    BanBu_UserAgreement *agreement = [[BanBu_UserAgreement alloc]init];
    [self.navigationController pushViewController:agreement animated:YES];
    [agreement release];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    self.peopleLabel = nil;

}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [AppComManager cancalHandlesForObject:self];
    [TKLoadingView dismissTkFromView:self.view animated:NO afterShow:0.0];

}

- (void)dealloc
{
//    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"unlogin" object:nil];
    [_peopleLabel release];
    [super dealloc];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
















@end
