//
//  BanBu_PeopleProfileController.m
//  BanBu
//
//  Created by laiguo zheng on 12-7-12.
//  Copyright (c) 2012年 17xy. All rights reserved.
//

#import "BanBu_PeopleProfileController.h"
#import "BanBu_ChatViewController.h"
#import "BanBu_ListCellCell.h"
#import "TKLoadingView.h"
#import "BanBu_BlacklistViewController.h"
#import "BanBu_DynamicDetailsController.h"
#import "BanBu_GreetingViewController.h"

@interface BanBu_PeopleProfileController ()

@end

@implementation BanBu_PeopleProfileController

@synthesize profile = _profile;
@synthesize toolbarView = _toolbarView;
@synthesize type = _type;
- (id)initWithProfile:(NSDictionary *)profileDic displayType:(DisplayType)type;
{
    self = [super initWithStyle:UITableViewStylePlain];
    if (self) {
        
        _profile = [[NSMutableDictionary alloc] initWithDictionary:profileDic];
//        NSLog(@"%@",_profile);
        _type = type;
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title =  [MyAppDataManager IsInternationalLanguage:[MyAppDataManager theRevisedName:[_profile valueForKey:@"pname"] andUID:[_profile valueForKey:@"userid"]]];
    NSMutableArray *arr = [[NSMutableArray alloc]initWithCapacity:1];
    self.userActions = arr;
    [arr release];
//    self.view.backgroundColor = [UIColor scrollViewTexturedBackgroundColor];
     // 今天不出去了
    
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
    
    self.navigationItem.leftBarButtonItem=bar_itemreturn;
    
    
    

    self.tableView.backgroundColor = [UIColor colorWithRed:255.0/255 green:250.0/255 blue:240.0/255 alpha:1.0];
    BanBu_PhotoManager *photiView = [[BanBu_PhotoManager alloc] initWithPhotos:nil owner:self];
    _photoView = photiView;
    [self.tableView addSubview:photiView];
    [self.tableView setContentInset:UIEdgeInsetsMake(_photoView.contentViewHeight, 0, 0, 0)];
    [photiView release];
    
    UIButton *listButton = [UIButton buttonWithType:UIButtonTypeCustom];
    listButton.frame=CGRectMake(0, 0, 70, 30);
    [listButton addTarget:self action:@selector(listStyle:) forControlEvents:UIControlEventTouchUpInside];
    [listButton setBackgroundImage:[[UIImage imageNamed:@"app_nav_btn_bg1.png"] stretchableImageWithLeftCapWidth:15.0 topCapHeight:15.0] forState:UIControlStateNormal];
    [listButton setBackgroundImage:[[UIImage imageNamed:@"app_nav_btn_bg2.png"] stretchableImageWithLeftCapWidth:15.0 topCapHeight:15.0] forState:UIControlStateHighlighted];
    [listButton setTitleEdgeInsets:UIEdgeInsetsMake(3, 2, 2, 2)];
    [listButton setTitle:_type == DisplayTypePeopleProfile?NSLocalizedString(@"displayPeopleNews", nil):NSLocalizedString(@"displayPeopleProfile", nil) forState:UIControlStateNormal];
    listButton.titleLabel.font = [UIFont systemFontOfSize:14];
    UIBarButtonItem *list = [[[UIBarButtonItem alloc] initWithCustomView:listButton] autorelease];
    self.navigationItem.rightBarButtonItem = list;
    
    
    UIView *barView = [[UIView alloc] initWithFrame:CGRectMake(0, __MainScreen_Height+20, 320, 44)];
    NSArray *images = [NSArray arrayWithObjects:@"button_gochat.png",@"button_addfriend.png",@"button_block.png",@"button_delbuddy.png",nil];
    NSArray *titles = [NSArray arrayWithObjects:NSLocalizedString(@"writeMessage", nil),NSLocalizedString(@"addLink", nil),NSLocalizedString(@"pullBlackReport", nil),NSLocalizedString(@"delLink", nil), nil];
    float x = 0;
    for(int i=0; i<3; i++)
    {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        UIImage *image = [UIImage imageNamed:[images objectAtIndex:i]];

        button.frame = CGRectMake(x, 0,image.size.width, 44);
        button.tag = i;
        [button setBackgroundImage:image forState:UIControlStateNormal];
        [button setTitle:[titles objectAtIndex:i] forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont boldSystemFontOfSize:15];
        [button addTarget:self action:@selector(action:) forControlEvents:UIControlEventTouchUpInside];
        [barView addSubview:button];
        x += image.size.width;
        if(i == 0)
            _talkButton = button;
        if(i == 1)
            _linkButton = button;
    }
    
    self.toolbarView = barView;
    [self.navigationController.view addSubview:_toolbarView];
    [barView release];
    
    UIView *footer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 45)];
    footer.backgroundColor = [UIColor clearColor];
    self.tableView.tableFooterView = footer;
    [footer release];
    
    
    
    
    /*************************************************************************/
    id faces = [_profile valueForKey:@"facelist"];
    if([faces isKindOfClass:[NSArray class]])
    {
        //NSLog(@"%@",faces);
        if([faces count]){
            _photoView.myPhotos = faces;
        }else{
            NSMutableDictionary *pars = [NSMutableDictionary dictionaryWithCapacity:2];
            [pars setValue:[_profile valueForKey:@"userid"] forKey:@"email_uid"];
            [AppComManager getBanBuData:BanBu_Get_User_Info par:pars delegate:self];
        }
    }
    
    UIView  *headView = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 30)];
    headView.backgroundColor = [UIColor colorWithRed:255.0/255 green:250.0/255 blue:240.0/255 alpha:1.0];
    
    
    UILabel *sexLabel = [[UILabel alloc] initWithFrame:CGRectMake(10,5,20,20)];
    sexLabel.font = [UIFont systemFontOfSize:14];
    sexLabel.textAlignment = UITextAlignmentCenter;
    sexLabel.textColor = [UIColor whiteColor];
    sexLabel.layer.cornerRadius = 4.0f;
//    NSLog(@"%@",_profile );
    if([_profile valueForKey:@"gender" ]){
        if([[_profile valueForKey:@"gender" ] isEqualToString:@"m"])
        {
            sexLabel.backgroundColor = [UIColor colorWithRed:103.0/255 green:187.0/255 blue:1.0 alpha:1.0];
            sexLabel.text = @"♂";
        }
        else
        {
            sexLabel.backgroundColor = [UIColor colorWithRed:253.0/255 green:163.0/255 blue:200.0 alpha:1.0];
            sexLabel.text = @"♀";
        }

    }else{
        if([[_profile valueForKey:@"sex" ]intValue])
        {
            sexLabel.backgroundColor = [UIColor colorWithRed:103.0/255 green:187.0/255 blue:1.0 alpha:1.0];
            sexLabel.text = @"♂";
        }
        else
        {
            sexLabel.backgroundColor = [UIColor colorWithRed:253.0/255 green:163.0/255 blue:200.0 alpha:1.0];
            sexLabel.text = @"♀";
        }

    }
    
    [headView addSubview:sexLabel];
    [sexLabel release];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, 0, 100, 30)];
    titleLabel.font = [UIFont systemFontOfSize:14];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textColor = [UIColor colorWithRed:56.0/255 green:84.0/255 blue:135.0/255 alpha:1.0];
    titleLabel.text = [NSString stringWithFormat:@"%@ %@",[MyAppDataManager IsInternationalLanguage:[_profile valueForKey:@"sstar"]],[_profile valueForKey:@"oldyears"]];
    [headView addSubview:titleLabel];
    [titleLabel release];
    
    UILabel *distanceLabel = [[UILabel alloc] initWithFrame:CGRectMake(150, 0, 160, 30)];
    distanceLabel.font = [UIFont systemFontOfSize:14];
    distanceLabel.backgroundColor = [UIColor clearColor];

    distanceLabel.textColor = [UIColor colorWithRed:56.0/255 green:84.0/255 blue:135.0/255 alpha:1.0];
    distanceLabel.textAlignment = UITextAlignmentRight;
//    NSLog(@"%@",_profile );

    if(![[_profile allKeys] containsObject:@"dmeter"] || ![[_profile allKeys] containsObject:@"ltime"]){
//        NSMutableDictionary *pars = [NSMutableDictionary dictionaryWithCapacity:2];
//        [pars setValue:[_profile valueForKey:@"userid"] forKey:@"email_uid"];
//        [AppComManager getBanBuData:BanBu_Get_User_Info par:pars delegate:self];
//        self.navigationController.view.userInteractionEnabled = NO;
//        distanceLabel.text = @"";
    }
    else{
//        distanceLabel.text = [NSString stringWithFormat:@"%@ | %@",[_profile valueForKey:@"dmeter"],[_profile valueForKey:@"ltime"]];
    
        NSString *interLtime = [MyAppDataManager IsInternationalLanguage:[_profile valueForKey:@"ltime"]];
        NSString *interDmeter = [MyAppDataManager IsInternationalLanguage:[_profile valueForKey:@"dmeter"]];
        
        CGFloat btnLen = [interLtime sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(100, 30)].width;
        CGFloat btnLen1 = [interDmeter sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(100, 30)].width;
        UILabel *ltimeLabel = [[UILabel alloc]initWithFrame:CGRectMake(310-btnLen, 0, btnLen, 30)];
        ltimeLabel.text = interLtime;
        ltimeLabel.font = [UIFont systemFontOfSize:14];
        ltimeLabel.backgroundColor = [UIColor clearColor];
        ltimeLabel.textColor = [UIColor colorWithRed:56.0/255 green:84.0/255 blue:135.0/255 alpha:1.0];
        [headView addSubview:ltimeLabel];
        [ltimeLabel release];
        UIImageView *ltimeImageView = [[UIImageView alloc]initWithFrame:CGRectMake(ltimeLabel.frame.origin.x-30+6, 3+6, 12, 12)];
        ltimeImageView.image = [UIImage imageNamed:@"ic_user_loctime.png"];
        [headView addSubview:ltimeImageView];
        [ltimeImageView release];
        
        UILabel *dmeterLabel = [[UILabel alloc]initWithFrame:CGRectMake(ltimeImageView.frame.origin.x-btnLen1-5, 0, btnLen1, 30)];
        dmeterLabel.text = interDmeter;
        dmeterLabel.font = [UIFont systemFontOfSize:14];
        dmeterLabel.backgroundColor = [UIColor clearColor];
        dmeterLabel.textColor = [UIColor colorWithRed:56.0/255 green:84.0/255 blue:135.0/255 alpha:1.0];
        [headView addSubview:dmeterLabel];
        [dmeterLabel release];
        UIImageView *dmeterImageView = [[UIImageView alloc]initWithFrame:CGRectMake(dmeterLabel.frame.origin.x-27+6, 3+6, 12, 12)];
        dmeterImageView.image = [UIImage imageNamed:@"ic_user_location.png"];
        [headView addSubview:dmeterImageView];
        [dmeterImageView release];
        
    }
    [headView addSubview:distanceLabel];
    [distanceLabel release];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 29, 320, 1.0)];
    lineView.backgroundColor = [UIColor colorWithRed:224.0/255 green:224.0/255 blue:224.0/255 alpha:1.0];
    [headView addSubview:lineView];
    [lineView release];
    
    self.tableView.tableHeaderView = headView;
    [headView release];
   
//    titleArr = [[NSMutableArray alloc]initWithCapacity:10];
//    titleValueArr = [[NSMutableArray alloc]initWithCapacity:10];
//    titleAndValueDic = [[NSMutableDictionary alloc]initWithCapacity:10];
    titleAndValueArr = [[NSMutableArray alloc]initWithCapacity:10];
    
    NSArray *grjsArr = [NSArray arrayWithObjects: @"liked" ,@"lovego" , @"company" , @"jobtitle" , @"school" , nil];
    NSArray *titleArr1 = [NSArray arrayWithObjects: NSLocalizedString(@"s2c0", nil),NSLocalizedString(@"s2c1", nil),NSLocalizedString(@"s2c2", nil),NSLocalizedString(@"s2c3", nil),NSLocalizedString(@"s2c4", nil), nil];

    //NSLog(@"%@",[_profile valueForKey:[grjsArr objectAtIndex:3]]);
    for (int i=0; i<5; i++) {
        NSLog(@"%@----%@",[grjsArr objectAtIndex:i],[_profile valueForKey:[grjsArr objectAtIndex:i]]);
        if([[_profile valueForKey:[grjsArr objectAtIndex:i]] length]){
            NSDictionary *aDic = [NSDictionary dictionaryWithObject:[_profile valueForKey:[grjsArr objectAtIndex:i]] forKey:[titleArr1 objectAtIndex:i]];
            [titleAndValueArr addObject:aDic];
//            [titleAndValueDic setValue:[_profile valueForKey:[grjsArr objectAtIndex:i]] forKey:[titleArr1 objectAtIndex:i]];
//            [titleArr addObject:[titleArr1 objectAtIndex:i]];
//            [titleValueArr addObject:[_profile valueForKey:[grjsArr objectAtIndex:i]]];
            grjsNum++;
        }
    }
//    NSLog(@"%@",titleAndValueArr);
    //    grjsNum = 5;
    grjsNum?(isHaveGRJS = YES):(isHaveGRJS = NO);
    //NSLog(@"%d%d",grjsNum,isHaveGRJS);

    
//    NSLog(@"%@",_profile);
    if([MyAppDataManager.useruid isEqualToString:[_profile valueForKey:@"userid"]]){
        _kind = 5;//自己
        return;
    }

    if(![[[[UserDefaults valueForKey:MyAppDataManager.useruid]valueForKey:FriendShip] valueForKey:@"flist"] count]){
        _kind = 4;
        return;
    }
      for(NSDictionary *find in [[[UserDefaults valueForKey:MyAppDataManager.useruid]valueForKey:FriendShip] valueForKey:@"flist"]){
//        //NSLog(@"ni%@wo%@",[find valueForKey:@"fuid"],[_profile valueForKey:@"userid"]);
        if([[find valueForKey:@"fuid"] isEqualToString:[_profile valueForKey:@"userid"]]){
            _linked = YES;
//            NSLog(@"%@",find);

            NSArray *frindshipArr = [NSArray arrayWithObjects:@"g",@"f",@"h",@"x", nil];
            //NSLog(@"%@",[find valueForKey:@"linkkind"]);
//            NSLog(@"%@",[find valueForKey:@"linkkind"]);
            _kind = [frindshipArr indexOfObject:[find valueForKey:@"linkkind"]];
//            NSLog(@"%d",_kind);

            if(_kind == 1 || _kind == 3){
                _linked = NO;
            }
            break;
        }
        _kind = 4;
    }
//    NSLog(@"%d",_kind);
//    if(_kind == 10){
//        _kind = 4;//陌生人
//    }

    [_linkButton setBackgroundImage:_linked?[UIImage imageNamed:@"button_delbuddy.png"]:[UIImage imageNamed:@"button_addfriend.png"] forState:UIControlStateNormal];
    [_linkButton setTitle:_linked?[titles objectAtIndex:3]:[titles objectAtIndex:1] forState:UIControlStateNormal];
    //声明看过此人(偷偷的)
    NSMutableDictionary *parDic = [NSMutableDictionary dictionary];
    [parDic setValue:[_profile valueForKey:@"userid"] forKey:@"email_uid"];
    [AppComManager getBanBuData:BanBu_Set_User_View par:parDic delegate:self];
//    self.navigationController.view.userInteractionEnabled = NO;

    //NSLog(@"%@",parDic);
    
    

}

-(void)popself
{
  if(_type==DisplayTypePeopleProfile)
  {
      [self.navigationController popViewControllerAnimated:YES];
  
  }else
  {
      [self listStyle:(UIButton *)self.navigationItem.rightBarButtonItem.customView];
    
  }


}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    /*************************写信息按钮**************************/
//    if(_kind == 2){
//    
//        [_talkButton setTitle:NSLocalizedString(@"writeMessage", nil) forState:UIControlStateNormal];
//        _writeButtonTitleType = 3;
//    
//    }else{
//        if(_isRequestFriend){
//            
//            //确认请求
//            [_talkButton setTitle:[NSString stringWithFormat:@"      %@",NSLocalizedString(@"confirmFriend", nil)] forState:UIControlStateNormal];
//            _writeButtonTitleType = 2;
//            
//        }else{
////            if(_kind == 0 || _kind == 1 || _kind == 3 || (_kind == 4 && !_isRequestFriend)){
////
////
////
////            }
////
////            else if(_kind == 4 && _isRequestFriend){
////                
////               
////                
////            }
//            //好友请求
//            [_talkButton setTitle:[NSString stringWithFormat:@"      %@",NSLocalizedString(@"requestUser", nil)] forState:UIControlStateNormal];
//            _writeButtonTitleType = 1;
//        }
//
//    }
//    NSLog(@"%d--%d",_kind,_writeButtonTitleType);

    if(_type == DisplayTypePeopleNews)
        return;
    if(_kind != 5){
        [UIView animateWithDuration:0.5
                     animations:^{
                         CGRect rect = _toolbarView.frame;
                         rect.origin.y -= 44;
                         _toolbarView.frame = rect;
                     }];
    }else{
        UIView *footer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 1)];
        footer.backgroundColor = [UIColor clearColor];
        self.tableView.tableFooterView = footer;
        [footer release];
    }
    
    
//    if(!_success)
//    {
//        NSMutableDictionary *pars = [NSMutableDictionary dictionaryWithCapacity:2];
//        [pars setValue:@"" forKey:@"email"];
//        [pars setValue:[_profile valueForKey:@"uid"] forKey:@"userid"];
//        [pars setValue:@"y" forKey:@"format"];
//        [AppComManager getBanBuData:BanBu_Get_User_Info par:pars delegate:self];
//        self.navigationController.view.userInteractionEnabled = NO;
//    }
    
}



//- (NSString *)realKey:(NSString *)faceKay
//{
//    if([faceKay isEqualToString:@"基本信息"])
//        return @"jbxx";
//    else if([faceKay isEqualToString:@"个人介绍"])
//        return @"grjs";
//    else if([faceKay isEqualToString:@"账号信息"])
//        return @"zhxx";
//    return @"grqm";
//}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    if(_type == DisplayTypePeopleNews)
        return;
    [UIView animateWithDuration:0.5
                     animations:^{
                         CGRect rect = _toolbarView.frame;
                         rect.origin.y += 44;
                         _toolbarView.frame = rect;
                     }];
     [AppComManager cancalHandlesForObject:self];
}
- (void)viewDidUnload
{
    [super viewDidUnload];
    self.profile = nil;
//    _success =NO;
    [_toolbarView removeFromSuperview];
    self.toolbarView = nil;
    _photoView = nil;
}

- (void)dealloc
{
    [titleAndValueArr release];
    [_profile release];
    _photoView = nil;
    [_toolbarView removeFromSuperview];
    [_toolbarView release];
    [_headerArr release];
    [_userActions release];
    
    [super dealloc];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


-(void)sendMessageTochat{
    NSLog(@"sd");
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if(_type == DisplayTypePeopleNews)
        return 1;
    return isHaveGRJS?4:3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(_type == DisplayTypePeopleNews)
        return _userActions.count;
    else{
        if(isHaveGRJS){
            if(section == 0){
                return 1;
            }else if(section == 1){
                return 3;
            }else if(section == 2){
                
                //NSLog(@"%d",grjsNum);
                return grjsNum;
            }else{
                return 2;
            }
        }else{
            if(section == 0){
                return 1;
            }else if(section == 1){
                return 3;
            }else{
                return 2;
            }
        }
    }
//        return (NSInteger)[[_profile valueForKey:[self realKey:[_headerArr objectAtIndex:section]]] count];
}

- (float)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if(_type == DisplayTypePeopleNews)
        return 0;
    else{
        if(isHaveGRJS){
            if(section ==(3)){
                return 0;
            }else{
                return 30;
            }
        }
        else{
            if(section ==(2) ){
                return 0;
            }else{
                return 30;
            }
        }
    }
    
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if(_type == DisplayTypePeopleNews)
        return nil;
    if(section == 3)
        return nil;
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 30)];
    titleLabel.backgroundColor = [UIColor lightGrayColor];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.font = [UIFont boldSystemFontOfSize:14];
    if(isHaveGRJS){
        if(section == 0)
            titleLabel.text= NSLocalizedString(@"profileSection", nil);
        else if(section == 1)
            titleLabel.text= NSLocalizedString(@"profileSection1", nil);
        else if(section == 2)
            titleLabel.text= NSLocalizedString(@"profileSection3", nil);
    }else{
        if(section == 0)
            titleLabel.text= NSLocalizedString(@"profileSection", nil);
        else if(section == 1)
            titleLabel.text= NSLocalizedString(@"profileSection3", nil);
    }
    return [titleLabel autorelease];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(_type == DisplayTypePeopleNews)
        return 84;
    else{
        if(indexPath.section == 0){
            NSString *detailValue = [_profile valueForKey:@"sayme"];
            if([detailValue stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length){
                return [detailValue sizeWithFont:[UIFont systemFontOfSize:15] constrainedToSize:CGSizeMake(300, 1000)].height+30;

            }else{
                return 40;
            }
        }else{
            
            if(indexPath.section == 2){
                if(isHaveGRJS){
//                    NSArray *keyValue = [NSArray arrayWithObjects:@"liked",@"company",@"school",@"lovego",@"jobtitle", nil];
                    NSString * detailValue =  [[[titleAndValueArr objectAtIndex:indexPath.row] allValues] objectAtIndex:0];
                        
                    return [detailValue sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(300, 1000)].height+30;
                }
                else{
                    return 40;
                }
                
            }
            return 40 ;
        }
        
    }
    
   
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(_type == DisplayTypePeopleNews)
    {
        static NSString *ListCellIdentifier = @"NewsCellIdentifier";
        BanBu_ListCellCell *cell = (BanBu_ListCellCell *)[tableView dequeueReusableCellWithIdentifier:ListCellIdentifier];
        if(cell == nil)
        {
            cell = [[[BanBu_ListCellCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ListCellIdentifier] autorelease];
            cell.selectionStyle = UITableViewCellSelectionStyleBlue;
            
        }
        
        NSDictionary *aData = [_userActions objectAtIndex:indexPath.row];
        NSDictionary *mcontentDic = [aData valueForKey:@"mcontent"];
//        NSLog(@"%@",aData);
//        [cell setAvatar:[aData valueForKey:@"uface"]];
//        [cell setName:[aData valueForKey:@"pname"]];
//        [cell setAge:[aData valueForKey:@"oldyears"] sex:[[aData valueForKey:@"gender"] isEqualToString:@"男"]];
        
        NSString *saytext = [mcontentDic objectForKey:@"saytext"];
//        NSLog(@"%@",saytext);
        if([saytext rangeOfString:@"-->"].location != NSNotFound && [saytext rangeOfString:@"<--"].location != NSNotFound){
            
            //            NSLog(@"%@------%d%d",[saytext substringWithRange:NSMakeRange(start, end-start)],start,end);
            NSInteger start=[saytext rangeOfString:@"<--"].location+3;
             [cell setSignature: [saytext substringToIndex:start-3]];
  
        }else{
            [cell setSignature: saytext];
 
        }

        [cell setcommendNum:[aData valueForKey:@"comments"]];
        [cell setDistance:[NSString stringWithFormat:@"%@%@",NSLocalizedString(@"intimeLabel", nil),[aData valueForKey:@"mtime"]] timeAgo:@""];
        
         return cell;
        
    }
    else
    {

        static NSString *CellIdentifier = @"ProfileCellIdentifier";
        BOOL showType;
        if(isHaveGRJS){
            if(indexPath.section == 0 || indexPath.section == 2){
                showType = YES;
            }else{
                showType = NO;
            }
            
        }else{
            if(indexPath.section){
                showType = NO;
            }else{
                showType = YES;
            }
        }
        
        UITableViewCell *cell = [[[UITableViewCell alloc] initWithStyle:showType?UITableViewCellStyleSubtitle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier] autorelease];
        cell.detailTextLabel.numberOfLines = 0;
        if(isHaveGRJS){
            if(indexPath.section){
                if (indexPath.section == 1) {
//                    NSArray *heightArr = [NSArray arrayWithObjects:@"a",@"b",@"c",@"d",@"e",@"<160",@"160-165",@"165-170",@"170-175",@">175", nil];
//                    NSArray *weightArr = [NSArray arrayWithObjects:@"a",@"b",@"c",@"d",@"e",@"<40",@"40-50",@"50-60",@"60-70",@">70", nil];
                    if(indexPath.row == 0){
                        cell.textLabel.text = NSLocalizedString(@"s1c0", nil);
                        if(![[_profile valueForKey:@"hbody"] isEqualToString:@"-"]){
                            cell.detailTextLabel.text = [_profile valueForKey:@"hbody"];
                        }else{
                            cell.detailTextLabel.text =@"<160";
                        }
                    }else if(indexPath.row == 1){
                        cell.textLabel.text = NSLocalizedString(@"s1c1", nil);
                        if(![[_profile valueForKey:@"xblood"] isEqualToString:@""]){
                            cell.detailTextLabel.text = [_profile valueForKey:@"xblood"];
                        }else{
                            cell.detailTextLabel.text =@"A";
                        }
                    }else if(indexPath.row == 2){
                        cell.textLabel.text = NSLocalizedString(@"s1c2", nil);
                        if(![[_profile valueForKey:@"wbody"] isEqualToString:@"-"]){
                            cell.detailTextLabel.text = [_profile valueForKey:@"wbody"];
                        }else{
                            cell.detailTextLabel.text =@"<40";
                        }                    }
                }else if(indexPath.section == 2){

                    cell.textLabel.text = [[[titleAndValueArr objectAtIndex:indexPath.row] allKeys] objectAtIndex:0];
                    cell.detailTextLabel.text =  [[[titleAndValueArr objectAtIndex:indexPath.row] allValues] objectAtIndex:0];

                   
                                      
                }else if(indexPath.section == 3){
                    if(indexPath.row == 0){
                        cell.textLabel.text = NSLocalizedString(@"s0c0", nil);
                        cell.detailTextLabel.text = [_profile valueForKey:@"userid"];
                    }else if(indexPath.row == 1){
                        NSArray *frindshipArr = [NSArray arrayWithObjects:NSLocalizedString(@"friendShip", nil),NSLocalizedString(@"friendShip1", nil),NSLocalizedString(@"friendShip2", nil),NSLocalizedString(@"friendShip3", nil),NSLocalizedString(@"friendShip4", nil),NSLocalizedString(@"friendShip5", nil), nil];
                        cell.textLabel.text = NSLocalizedString(@"relationshipLabel", nil);
                        cell.detailTextLabel.text =  [frindshipArr objectAtIndex:_kind];
//                        if(_kind == 3){
//                            _isBlack =  YES;
//                        }else{
//                            _isBlack = NO;
//                        }
//                        //NSLog(@"%d",_kind);
                    }
                }
                
                
                
            }else{
                id faces = [_profile valueForKey:@"facelist"];
                if([faces isKindOfClass:[NSArray class]])
                {
                    if([faces count]){
                        _photoView.myPhotos = faces;

                    }else{
//                        _photoView.myPhotos = [NSArray arrayWithObject:[NSDictionary dictionaryWithObject:[_profile valueForKey:@"uface"] forKey:@"facefile"]];
//                        NSMutableDictionary *parDic = [NSMutableDictionary dictionary];
//                        parDic setValue:<#(id)#> forKey:<#(NSString *)#>
                        
                    }
                }
                cell.textLabel.text = NSLocalizedString(@"s0c2", nil);
                cell.detailTextLabel.text =  [_profile valueForKey:@"sayme"];
            }
        }else{
            if(indexPath.section){
                if (indexPath.section == 1) {
//                    NSArray *heightArr = [NSArray arrayWithObjects:@"a",@"b",@"c",@"d",@"e",@"<160",@"160-165",@"165-170",@"170-175",@">175", nil];
//                    NSArray *weightArr = [NSArray arrayWithObjects:@"a",@"b",@"c",@"d",@"e",@"<40",@"40-50",@"50-60",@"60-70",@">70", nil];
                    if(indexPath.row == 0){
                        cell.textLabel.text = NSLocalizedString(@"s1c0", nil);
//                        //NSLog(@"%@",[_profile valueForKey:@"hbody"]);
                        if(![[_profile valueForKey:@"hbody"] isEqualToString:@""]){
                            cell.detailTextLabel.text = [_profile valueForKey:@"hbody"];
                        }else{
                            cell.detailTextLabel.text =@"<160";
                        }
                    }else if(indexPath.row == 1){
                        cell.textLabel.text = NSLocalizedString(@"s1c1", nil);
                        if(![[_profile valueForKey:@"xblood"] isEqualToString:@""]){
                            cell.detailTextLabel.text = [_profile valueForKey:@"xblood"];
                        }else{
                            cell.detailTextLabel.text =@"A";
                        }
                    }else if(indexPath.row == 2){
                        cell.textLabel.text = NSLocalizedString(@"s1c2", nil);
                        if(![[_profile valueForKey:@"wbody"] isEqualToString:@""]){
                            cell.detailTextLabel.text = [_profile valueForKey:@"wbody"];
                        }else{
                            cell.detailTextLabel.text =@"<40";
                        }                    }
                }else if(indexPath.section == 2){
                    if(indexPath.row == 0){
                        cell.textLabel.text = NSLocalizedString(@"s0c0", nil);
                        cell.detailTextLabel.text = [_profile valueForKey:@"userid"];
                    }else if(indexPath.row == 1){
                        NSArray *frindshipArr = [NSArray arrayWithObjects:NSLocalizedString(@"friendShip", nil),NSLocalizedString(@"friendShip1", nil),NSLocalizedString(@"friendShip2", nil),NSLocalizedString(@"friendShip3", nil),NSLocalizedString(@"friendShip4", nil),NSLocalizedString(@"friendShip5", nil), nil];
                        cell.textLabel.text = NSLocalizedString(@"relationshipLabel", nil);
                        cell.detailTextLabel.text =  [frindshipArr objectAtIndex:_kind];
                        //                        if(_kind == 3){
                        //                            _isBlack =  YES;
                        //                        }else{
                        //                            _isBlack = NO;
                        //                        }
                        //                        //NSLog(@"%d",_kind);
                    }
                }
                
                
                
            }else{
                id faces = [_profile valueForKey:@"facelist"];
                if([faces isKindOfClass:[NSArray class]])
                {
                    if([faces count]){
                        _photoView.myPhotos = faces;
                        
                    }else{
//                        _photoView.myPhotos = [NSArray arrayWithObject:[NSDictionary dictionaryWithObject:[_profile valueForKey:@"uface"] forKey:@"facefile"]];
                        
                    }
                }
                cell.textLabel.text = NSLocalizedString(@"s0c2", nil);
                cell.detailTextLabel.text =  [_profile valueForKey:@"sayme"];
            }
        }
        
        cell.detailTextLabel.textColor = [UIColor colorWithRed:56.0/255 green:84.0/255 blue:135.0/255 alpha:1.0];

        cell.selectionStyle = UITableViewCellSelectionStyleNone;

        return cell;
    }
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(_type == DisplayTypePeopleNews){
        for(NSString *keyStr in [[_userActions objectAtIndex:indexPath.row] allKeys]){
            [_profile setValue:[[_userActions objectAtIndex:indexPath.row] valueForKey:keyStr] forKey:keyStr];
        }
        BanBu_DynamicDetailsController *aDyn= [[BanBu_DynamicDetailsController alloc]initWithDynamic:_profile];
    //    aDyn.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:aDyn animated:YES];
        [aDyn release];
    }else{
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
}

- (void)listStyle:(UIButton *)button
{
    
//    if (aNC.isLoading) {
//        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"上次的操作还没结束！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
//        [alert show];
//        [alert release];
//        return;
//        
//    }
    if(self.type == DisplayTypePeopleProfile)
    {
        self.type = DisplayTypePeopleNews;
        [button setTitle:NSLocalizedString(@"displayPeopleProfile", nil) forState:UIControlStateNormal];
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        UIView *footer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 0)];
        footer.backgroundColor = [UIColor clearColor];
        self.tableView.tableFooterView = footer;
        [footer release];
        
    }
    else
    {
        self.type = DisplayTypePeopleProfile;
        [button setTitle:NSLocalizedString(@"displayPeopleNews", nil) forState:UIControlStateNormal];
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        [AppComManager cancalHandlesForObject:self];
        [TKLoadingView dismissTkFromView:self.navigationController.view animated:YES afterShow:0.0];
        UIView *footer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 45)];
        footer.backgroundColor = [UIColor clearColor];
        self.tableView.tableFooterView = footer;
        [footer release];

    }
    
    [UIView beginAnimations:@"change" context:nil];
    [UIView setAnimationDuration:0.5f];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationRepeatAutoreverses:NO];
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:self.tableView cache:YES];
    [self.tableView reloadData];
    [UIView commitAnimations];
    
    [UIView animateWithDuration:0.5
                     animations:^{
                         CGRect rect = _toolbarView.frame;
                         rect.origin.y += _type==DisplayTypePeopleNews?44:-44;
                         _toolbarView.frame = rect;
                     }
     completion:^(BOOL finished) {
         if((_type == DisplayTypePeopleNews) && !self.userActions.count)
         {
             NSMutableDictionary *sendDic = [NSMutableDictionary dictionary];
             [sendDic setValue:[_profile valueForKey:@"userid"] forKey:@"frienduid"];
             [AppComManager getBanBuData:BanBu_Get_Friend_FriendDo par:sendDic delegate:self];
             [TKLoadingView showTkloadingAddedTo:self.navigationController.view title:NSLocalizedString(@"loadingNotice", nil) activityAnimated:YES];
//             self.navigationController.view.userInteractionEnabled = NO;


         }
     }];



}

- (void)setType:(DisplayType)type
{
    if(_type == type)
        return;
    _type = type;
    [self.tableView reloadData];
}

- (void)action:(UIButton *)button
{
    if(button.tag == 2)
    {
        UIActionSheet *blockSheet;
        if(_kind == 2){
           blockSheet = [[UIActionSheet alloc]
               initWithTitle:nil
               delegate:self
               cancelButtonTitle:NSLocalizedString(@"cancelNotice", nil)
               destructiveButtonTitle:nil
               otherButtonTitles:NSLocalizedString(@"addNote", nil),NSLocalizedString(@"pullBlackTitle", nil),NSLocalizedString(@"pullBlackAndReport", nil),NSLocalizedString(@"viewBlackList", nil),nil];
        }else{
           blockSheet = [[UIActionSheet alloc]
               initWithTitle:nil
               delegate:self
               cancelButtonTitle:NSLocalizedString(@"cancelNotice", nil)
               destructiveButtonTitle:nil
                         otherButtonTitles:NSLocalizedString(@"pullBlackTitle", nil),NSLocalizedString(@"pullBlackAndReport", nil),NSLocalizedString(@"viewBlackList", nil),nil];
        }
        blockSheet.tag = 1;
        [blockSheet showFromTabBar:self.navigationController.tabBarController.tabBar];
        [blockSheet release];
    }
    else if(button.tag == 1)        
    {
        NSString *title = _linked?NSLocalizedString(@"unlinkButton", nil):NSLocalizedString(@"linkButton", nil);
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title
                                                            message:nil
                                                           delegate:self cancelButtonTitle:NSLocalizedString(@"cancelNotice", nil) otherButtonTitles:NSLocalizedString(@"confirmNotice", nil), nil];
        [alertView show];
        [alertView release];
    }
    else
        
    {
        
        /*
        if(_writeButtonTitleType == 1){
            
            //好友请求

            BanBu_GreetingViewController *aGreet = [[BanBu_GreetingViewController alloc]initWithStyle:UITableViewStyleGrouped];
            aGreet.touid = [_profile valueForKey:@"userid"];
            BanBu_NavigationController *nav = [[[BanBu_NavigationController alloc] initWithRootViewController:aGreet] autorelease];

            [self presentModalViewController:nav animated:YES];
            [aGreet release];

        }
        
        else if(_writeButtonTitleType == 2){
                
            //确认请求
            greetAlert = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"addFriend", nil) message:nil delegate:self cancelButtonTitle:NSLocalizedString(@"cancelNotice", nil) otherButtonTitles:NSLocalizedString(@"confirmNotice", nil), nil];
            [greetAlert show];
            [greetAlert release];
            
           
                
        }
        else if(_writeButtonTitleType == 3){//好友
            
            BanBu_ChatViewController *chat = nil;
            for(UIViewController *vc in [self.navigationController viewControllers])
                if([vc isKindOfClass:[BanBu_ChatViewController class]])
                {
                    chat = (BanBu_ChatViewController *)vc;
                    break;
                }
            if(chat)
            {
                [self.navigationController popToViewController:chat animated:YES];
            }
            else
            {
                
                chat = [[BanBu_ChatViewController alloc] initWithPeopleProfile:_profile];
                [self.navigationController pushViewController:chat animated:YES];
                [chat release];
            }
            
        }
         */
        BanBu_ChatViewController *chat = nil;
        for(UIViewController *vc in [self.navigationController viewControllers])
            if([vc isKindOfClass:[BanBu_ChatViewController class]])
            {
                chat = (BanBu_ChatViewController *)vc;
                break;
            }
        if(chat)
        {
            [self.navigationController popToViewController:chat animated:YES];
        }
        else
        {
            
            chat = [[BanBu_ChatViewController alloc] initWithPeopleProfile:_profile];
            [self.navigationController pushViewController:chat animated:YES];
            [chat release];
        }

       
    }
    
}

#pragma alertDelegate


- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if(alertView == greetAlert){
        if(buttonIndex == alertView.firstOtherButtonIndex){
            
            NSMutableDictionary *parDic = [NSMutableDictionary dictionary];
            [parDic setValue:[_profile valueForKey:@"userid"] forKey:LinkTouID];
            [parDic setValue:@"friend" forKey:Action];

            [AppComManager getBanBuData:BanBu_Set_Friend_Link par:parDic delegate:self];
            self.navigationController.view.userInteractionEnabled = NO;
            
        }
        return;
    }
    if(alertView == customAlert){
        if(buttonIndex == alertView.firstOtherButtonIndex)
        {
            NSArray *messageArr = [NSArray arrayWithObjects:NSLocalizedString(@"badMessage", nil),NSLocalizedString(@"badMessage1", nil),NSLocalizedString(@"badMessage2", nil),NSLocalizedString(@"badMessage3", nil), nil];
            NSMutableDictionary *pars = [NSMutableDictionary dictionaryWithCapacity:2];
            [pars setValue:[_profile valueForKey:@"userid"] forKey:ReportTouID];
//            //NSLog(@"%@",[messageArr objectAtIndex:reportMessIndex]);

            if(![textView1.text isEqualToString:@""]){
                NSString *mess = [NSString stringWithFormat:@"%@,%@",[messageArr objectAtIndex:reportMessIndex],textView1.text];

                [pars setValue:mess forKey:@"saytext"];
                
            }else{
                [pars setValue:[messageArr objectAtIndex:reportMessIndex] forKey:@"saytext"];
                
            }
            [AppComManager getBanBuData:BanBu_Report_User par:pars delegate:self];
            self.navigationController.view.userInteractionEnabled = NO;

            _isBlack = YES;
            //NSLog(@"%@",pars);
        }
        return;
    }
    if(buttonIndex == alertView.firstOtherButtonIndex)
    {
        NSString *action = _linked?@"unlink":@"link";
        NSMutableDictionary *pars = [NSMutableDictionary dictionaryWithCapacity:2];
        [pars setValue:[_profile valueForKey:@"userid"] forKey:LinkTouID];
        [pars setValue:action forKey:Action];
        [AppComManager getBanBuData:BanBu_Set_Friend_Link par:pars delegate:self];
        self.navigationController.view.userInteractionEnabled = NO;
        _isBlack = NO;
        //NSLog(@"%@",pars);
        if(!_linked){
            NSString *str ;
            NSString *langauage=[[MyAppDataManager getPreferredLanguage]substringToIndex:2];

            if([langauage isEqual:@"en"]){
                
                str = [NSString stringWithFormat:@"I followed %@ in Halfeet.",self.title];
            }else if([langauage isEqual:@"ja"]){
                
                str = [NSString stringWithFormat:@"私は　ハーフフィート(www.halfeet.com)で　%@をフォローしました",self.title];                
            }
            if([[UserDefaults valueForKey:@"TUser"] length]){
                FHSTwitterEngine * aEngine = [[[FHSTwitterEngine alloc]initWithConsumerKey:@"2cZXkfmSC6UrPUkhSPtfwQ" andSecret:@"mdoijXeFbK6dGVs5C61rADMOWSgFdNtPOBsxgnKw"]autorelease];
                [aEngine loadAccessToken];
                dispatch_async(GCDBackgroundThread, ^{
                    @autoreleasepool {
                        
                        //发送的内容
                        [aEngine postTweet:str];
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
                        // otherwise fall back on a request for permissions and a direct post
                        
                        [FBRequestConnection startForPostStatusUpdate:str
                                                    completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
                                                        
                                                    }];
                        
                    }];
                }
            }
        }
        
    }
    
}

-(void)reportAndPullBlack:(NSString *)message{
//    NSLog(@"%@",message);
    NSMutableDictionary *pars = [NSMutableDictionary dictionaryWithCapacity:2];
    [pars setValue:[_profile valueForKey:@"userid"] forKey:ReportTouID];
    [pars setValue:message forKey:@"saytext"];
    [AppComManager getBanBuData:BanBu_Report_User par:pars delegate:self];
    self.navigationController.view.userInteractionEnabled = NO;
    
    _isBlack = YES;

}
/*
-(void)willPresentAlertView:(UIAlertView *)alertView
{
 
 
    if(alertView==customAlert)
    {
        CGRect frame=alertView.frame;

        frame.origin.y=frame.origin.y-185;
        
        if(frame.size.height ==115){
            frame.size.height=frame.size.height+150;

        }
        
//        frame.size.width=frame.size.width;
        
        alertView.frame=frame;
        
        for(UIView *view in alertView.subviews)
        {
            if(![view isKindOfClass:[UILabel class]])
            {
                
                if(view.tag==1)
                {
                    CGRect btnFrame=CGRectMake(30, frame.size.height-55, 105, 40);
                    
                    view.frame=btnFrame;
                    
                }else if(view.tag==2)
                {
                    
                    CGRect btnFrame2 =CGRectMake(142, frame.size.height-55, 105, 40);
                    view.frame = btnFrame2;
                    
                    
                }
                
                
            }
            
        }

        UIView *container = [[UIView alloc] initWithFrame:CGRectMake(20, 40, 250, 80)];
        container.backgroundColor = [UIColor clearColor];
        [self.view addSubview:container];
        
        RadioButton *rb1 = [[RadioButton alloc] initWithGroupId:@"first group" index:0];
        RadioButton *rb2 = [[RadioButton alloc] initWithGroupId:@"first group" index:1];
        RadioButton *rb3 = [[RadioButton alloc] initWithGroupId:@"first group" index:2];
        RadioButton *rb4 = [[RadioButton alloc] initWithGroupId:@"first group" index:3];
        [rb1 handleButtonTap:rb1.button];//自己加的
        rb1.frame = CGRectMake(5,20,22+80,22);
        rb2.frame = CGRectMake(5,50,22+80,22);
        rb3.frame = CGRectMake(115,20,22+120,22);
        rb4.frame = CGRectMake(115,50,22+120,22);
        
        [container addSubview:rb1];
        [container addSubview:rb2];
        [container addSubview:rb3];
        [container addSubview:rb4];
        
        [rb1 release];
        [rb2 release];
        [rb3 release];
        [rb4 release];
        [alertView addSubview:container];
        
        UILabel *label1 =[[UILabel alloc] initWithFrame:CGRectMake(35, 20, 80, 20)];
        label1.backgroundColor = [UIColor clearColor];
        label1.textColor = [UIColor whiteColor];
        label1.text = NSLocalizedString(@"badMessage", nil);
        [container addSubview:label1];
        [label1 release];
        
        UILabel *label2 =[[UILabel alloc] initWithFrame:CGRectMake(35, 50, 80, 20)];
        label2.backgroundColor = [UIColor clearColor];
        label2.text = NSLocalizedString(@"badMessage1", nil);
        label2.textColor = [UIColor whiteColor];

        [container addSubview:label2];
        [label2 release];
        
        UILabel *label3 =[[UILabel alloc] initWithFrame:CGRectMake(145, 20, 120, 20)];
        label3.backgroundColor = [UIColor clearColor];
        label3.text = NSLocalizedString(@"badMessage2", nil);
        label3.textColor = [UIColor whiteColor];
        
        [container addSubview:label3];
        [label3 release];
        
        UILabel *label4 =[[UILabel alloc] initWithFrame:CGRectMake(145, 50, 120, 20)];
        label4.backgroundColor = [UIColor clearColor];
        label4.text = NSLocalizedString(@"badMessage3", nil);
        label4.textColor = [UIColor whiteColor];
        
        [container addSubview:label4];
        [label4 release];
        
        [RadioButton addObserverForGroupId:@"first group" observer:self];

        // 放留言的内容：
        
        
        textView1=[[UITextField alloc]initWithFrame:CGRectMake(20, 120, 250, 80)];
        
//        textView1.bounces=YES;
        textView1.backgroundColor = [UIColor whiteColor];
        textView1.delegate=self;
        textView1.text = @"";
        textView1.layer.cornerRadius=5;
        textView1.layer.borderColor = [[UIColor grayColor]CGColor];
        textView1.layer.borderWidth = 3;
        textView1.font=[UIFont systemFontOfSize:18];
        textView1.returnKeyType = UIReturnKeyDone;
        textView1.textColor=[UIColor grayColor];
        textView1.placeholder = NSLocalizedString(@"badDetailMessage", nil);
        //        textView1.text=NSLocalizedString(@"textWord", nil);
        
        [alertView addSubview:textView1];
        
        [textView1 release];
        
        
        
    }
    
    
}


*/
-(void)radioButtonSelectedAtIndex:(NSUInteger)index inGroup:(NSString *)groupId{
    reportMessIndex = index;
    //NSLog(@"changed to %d in %@",index,groupId);
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    if([textField isFirstResponder]){
        [textField resignFirstResponder];

    }

    return  YES;
}

-(void)changeNameAction:(NSString *)noteName{
    NSMutableDictionary *parDic = [NSMutableDictionary dictionary];
    [parDic setValue:[_profile valueForKey:@"userid"] forKey:@"friendid"];
    [parDic setValue:[MyAppDataManager IsMinGanWord:noteName] forKey:@"fname"];
    [AppComManager getBanBuData:BanBu_Set_FriendName par:parDic delegate:self];
    self.navigationController.view.userInteractionEnabled = NO;
}

#pragma mark - ActionSheet delegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(!actionSheet.tag == 1)
    {
        
    }
    else 
    {
        if(_kind == 2){
                       
            if(buttonIndex == 0){
                
                aNote = [[BanBu_NoteView alloc]initWithFrame:self.navigationController.view.bounds andTitle:[MyAppDataManager theRevisedName:[_profile valueForKey:@"pname"] andUID:[_profile valueForKey:@"userid"]]];
                aNote.delegate = self;
                [self.navigationController.view addSubview:aNote];
                [aNote release];

                
            }
            if(buttonIndex == 1)
            {
                if(!_isBlack){
                    NSString *action = @"black";
                    NSMutableDictionary *pars = [NSMutableDictionary dictionary];
                    [pars setValue:[_profile valueForKey:@"userid"] forKey:LinkTouID];
                    [pars setValue:action forKey:Action];
                    [AppComManager getBanBuData:BanBu_Set_Friend_Link par:pars delegate:self];
                    self.navigationController.view.userInteractionEnabled = NO;
                    
                    _isBlack = YES;
                    
                }else{
                    [TKLoadingView showTkloadingAddedTo:self.navigationController.view point:CGPointMake(0, 190) title:NSLocalizedString(@"pullBlackOK", nil) activityAnimated:NO duration:1.0];
                }
                
            }else if(buttonIndex == 2){
                aReportView = [[BanBu_ReportView alloc]initWithFrame:CGRectMake(0, 0, 320, __MainScreen_Height+20)];
                aReportView.delegate = self;
                [self.navigationController.view addSubview:aReportView];
                [aReportView release];
             
            }else if(buttonIndex == 3){
                BanBu_BlacklistViewController *black = [[BanBu_BlacklistViewController alloc]init];
                [self.navigationController pushViewController:black animated:YES];
                [black release];
            }

        }else{
            if(buttonIndex == 0){
                
                if(!_isBlack){
                    NSString *action = @"black";
                    NSMutableDictionary *pars = [NSMutableDictionary dictionary];
                    [pars setValue:[_profile valueForKey:@"userid"] forKey:LinkTouID];
                    [pars setValue:action forKey:Action];
                    [AppComManager getBanBuData:BanBu_Set_Friend_Link par:pars delegate:self];
                    self.navigationController.view.userInteractionEnabled = NO;
                    
                    _isBlack = YES;
                    
                }else{
                    [TKLoadingView showTkloadingAddedTo:self.navigationController.view point:CGPointMake(0, 190) title:NSLocalizedString(@"pullBlackOK", nil) activityAnimated:NO duration:1.0];
                }
            }
            if(buttonIndex == 1)
            {
                //            UIActionSheet *reportSheet = [[UIActionSheet alloc]
                //                                          initWithTitle:@"举报"
                //                                          delegate:self
                //                                          cancelButtonTitle:@"取消"
                //                                          destructiveButtonTitle:nil
                //                                          otherButtonTitles:@"骚扰信息",@"色情信息",@"个人资料不当",@"盗用他人资料",nil];
                //            [reportSheet showInView:self.view];
                //            [reportSheet release];
                //            customAlert =[[CustomAlertView alloc]initWithTitle:NSLocalizedString(@"reportUser", nil) message:nil delegate:self cancelButtonTitle:NSLocalizedString(@"cancelNotice", nil) otherButtonTitles:NSLocalizedString(@"submitButton", nil), nil];
                //            [customAlert show];
                //            [customAlert release];
                //            [textView1 becomeFirstResponder];
                aReportView = [[BanBu_ReportView alloc]initWithFrame:CGRectMake(0, 0, 320, __MainScreen_Height+20)];
                aReportView.delegate = self;
                [self.navigationController.view addSubview:aReportView];
                [aReportView release];
                
                
            }
            else if(buttonIndex == 2){
                BanBu_BlacklistViewController *black = [[BanBu_BlacklistViewController alloc]init];
                [self.navigationController pushViewController:black animated:YES];
                [black release];
            }

        }
        
    }
    
}

- (void)banbuRequestDidFinished:(NSDictionary *)resDic error:(NSError *)error
{
    NSLog(@"%@",resDic);

    self.navigationController.view.userInteractionEnabled = YES;
    [TKLoadingView dismissTkFromView:self.navigationController.view animated:YES afterShow:0.0];
    if(error)
    {
        if([error.domain isEqualToString:BanBuDataformatError])
        {
            [TKLoadingView showTkloadingAddedTo:self.navigationController.view title:NSLocalizedString(@"data_error", nil) activityAnimated:NO duration:2.0];
        }
        else
        {
            [TKLoadingView showTkloadingAddedTo:self.navigationController.view title:NSLocalizedString(@"network_error", nil) activityAnimated:NO duration:2.0];
        }
        if(_type == DisplayTypePeopleProfile){
            _isBlack = !_isBlack;

        }
        return;
    }
    
    
    if([AppComManager respondsDic:resDic isFunctionData:BanBu_Set_Friend_Link])
    {
        if([[resDic valueForKey:@"ok"]boolValue])
        {
                    
            NSMutableDictionary *uidDic = [NSMutableDictionary dictionaryWithDictionary:[UserDefaults valueForKey:MyAppDataManager.useruid]];
            [uidDic setValue:[resDic valueForKey:@"friendlist"] forKey:FriendShip];
            [UserDefaults setValue:uidDic forKey:MyAppDataManager.useruid];
            [UserDefaults synchronize];
            //[[UserDefaults valueForKey:MyAppDataManager.useruid] setValue:[resDic valueForKey:@"friendlist"] forKey:FriendShip];
//            if(!_isBlack){
                
            if(!_isBlack || _linked ==YES){
                if(!_linked){
                    [_linkButton setBackgroundImage:[UIImage imageNamed:@"button_delbuddy.png"] forState:UIControlStateNormal];
                    [_linkButton setTitle: NSLocalizedString(@"delLink", nil) forState:UIControlStateNormal];

                }else{
                     [_linkButton setBackgroundImage:[UIImage imageNamed:@"button_addfriend.png"] forState:UIControlStateNormal];
                    [_linkButton setTitle:NSLocalizedString(@"addLink", nil) forState:UIControlStateNormal];

                }
                
                _linked = !_linked;
                if(!_linked && _isBlack){
                    
                    [TKLoadingView showTkloadingAddedTo:self.navigationController.view point:CGPointMake(0, 190) title:NSLocalizedString(@"pullBlackOK", nil) activityAnimated:NO duration:1.0];

                }else{
                    if(_linked){
#warning 关注的分享
                        NSString *langauage = [[MyAppDataManager getPreferredLanguage]substringToIndex:2];
                        if(![langauage isEqual:@"zh"]){
                             //分享修改后的资料
                            
                            NSString *shareString;
                            if([langauage isEqualToString:@"en"]){
                                shareString = [NSString stringWithFormat:@"I followed %@ in Halfeet.",self.title];
                            }else if([langauage isEqualToString:@"ja"]){
                                shareString = [NSString stringWithFormat:@"私は　ハーフフィートで%@をフォローしました",self.title];
                            }
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
                                        // otherwise fall back on a request for permissions and a direct post
                                         
                                        [FBRequestConnection startForPostStatusUpdate:shareString
                                                                    completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
                                                                        
                                                                     }];
                                        
                                     }];
                                }
                                else{
//                                    [FBSession openActiveSessionWithPublishPermissions:[NSArray arrayWithObject:@"publish_actions"] defaultAudience:FBSessionDefaultAudienceFriends allowLoginUI:YES completionHandler:nil];
                                }
                            }
                             
                        }

                    }
                    [TKLoadingView showTkloadingAddedTo:self.navigationController.view point:CGPointMake(0, 190) title:_linked?NSLocalizedString(@"linkSuccess", nil):NSLocalizedString(@"unlinkSuccess", nil) activityAnimated:NO duration:1.0];

                }
            }
            else{
                
                [TKLoadingView showTkloadingAddedTo:self.navigationController.view point:CGPointMake(0, 190) title:NSLocalizedString(@"pullBlackOK", nil) activityAnimated:NO duration:1.0];
                
            }
            //判断好友关系
            for(NSDictionary *find in [[[UserDefaults valueForKey:MyAppDataManager.useruid]valueForKey:FriendShip] valueForKey:@"flist"]){
                //        //NSLog(@"ni%@wo%@",[find valueForKey:@"fuid"],[_profile valueForKey:@"userid"]);
                if([[find valueForKey:@"fuid"] isEqualToString:[_profile valueForKey:@"userid"]]){
                    _linked = YES;
                    NSArray *frindshipArr = [NSArray arrayWithObjects:@"g",@"f",@"h",@"x", nil];
                    
                    _kind = [frindshipArr indexOfObject:[find valueForKey:@"linkkind"]];
                    if(_kind == 1 || _kind == 3){
                        _linked = NO;
                    }
                    NSLog(@"--%d",_kind);

                    break;
                }
                _kind = 4;
            }
//                if(_kind == 10){
//                    _kind = 4;//陌生人
//                }

//            NSLog(@"--------%d",_kind);
//            if(_kind == 2){
//                
//                [_talkButton setTitle:NSLocalizedString(@"writeMessage", nil) forState:UIControlStateNormal];
//                _writeButtonTitleType = 3;
//                
//            }else{
//                if(_isRequestFriend){
//                     
//                    //确认请求
//                    [_talkButton setTitle:[NSString stringWithFormat:@"      %@",NSLocalizedString(@"confirmFriend", nil)] forState:UIControlStateNormal];
//                    _writeButtonTitleType = 2;
//                    
//                }else{
//                    
//                    //好友请求
//                    [_talkButton setTitle:[NSString stringWithFormat:@"      %@",NSLocalizedString(@"requestUser", nil)] forState:UIControlStateNormal];
//                    _writeButtonTitleType = 1;
//                    
//                }
//       
//                
//            }

            [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:isHaveGRJS?3:2] withRowAnimation:UITableViewRowAnimationNone];
        }
        else{
            [TKLoadingView showTkloadingAddedTo:self.navigationController.view title:[MyAppDataManager IsInternationalLanguage:[resDic valueForKey:@"error"]] activityAnimated:NO duration:1.0];
        }
    }
    else if([AppComManager respondsDic:resDic isFunctionData:BanBu_Report_User]){
        if([[resDic valueForKey:@"ok"]boolValue]){
//            NSLog(@"%@",resDic);
            NSMutableDictionary *uidDic = [NSMutableDictionary dictionaryWithDictionary:[UserDefaults valueForKey:MyAppDataManager.useruid]];
            [uidDic setValue:[resDic valueForKey:@"friendlist"] forKey:FriendShip];
            [UserDefaults setValue:uidDic forKey:MyAppDataManager.useruid];
            [UserDefaults synchronize];
            
            if(!_isBlack || _linked ==YES){
                if(!_linked){
                    [_linkButton setBackgroundImage:[UIImage imageNamed:@"button_delbuddy.png"] forState:UIControlStateNormal];
                    [_linkButton setTitle: NSLocalizedString(@"delLink", nil) forState:UIControlStateNormal];
                    
                }else{
                    [_linkButton setBackgroundImage:[UIImage imageNamed:@"button_addfriend.png"] forState:UIControlStateNormal];
                    [_linkButton setTitle:NSLocalizedString(@"addLink", nil) forState:UIControlStateNormal];
                    
                }
                _linked = !_linked;
                if(!_linked && _isBlack){
                    [TKLoadingView showTkloadingAddedTo:self.navigationController.view point:CGPointMake(0, 190) title:NSLocalizedString(@"blackAndReportOK", nil) activityAnimated:NO duration:1.0];
                    
                }
            }else{
                [TKLoadingView showTkloadingAddedTo:self.navigationController.view point:CGPointMake(0, 190) title:NSLocalizedString(@"blackAndReportOK", nil) activityAnimated:NO duration:1.0];
                
            }
            //显示黑名单
            _kind = 3; _linked = NO;
            
            [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:isHaveGRJS?3:2] withRowAnimation:UITableViewRowAnimationNone];
        }
        else{
            [TKLoadingView showTkloadingAddedTo:self.navigationController.view title:[resDic valueForKey:@"error"] activityAnimated:NO duration:1.0];
        }
    }
    else if([AppComManager respondsDic:resDic isFunctionData:BanBu_Get_Friend_FriendDo])
    {
        if([[resDic valueForKey:@"ok"]boolValue])
        {
//    NSLog(@"%@",resDic);
            for(int i=0;i<[[resDic valueForKey:@"list"]count];i++){
                
                NSMutableDictionary *aDic = [NSMutableDictionary dictionaryWithDictionary:[[resDic valueForKey:@"list"] objectAtIndex:i]];
                
                NSMutableDictionary *mcontentDic = [NSMutableDictionary dictionaryWithDictionary:[AppComManager getAMsgFrom64String:[aDic valueForKey:@"mcontent"]]];
//                NSMutableString *saytextStr = [NSMutableString stringWithString:[mcontentDic valueForKey:@"saytext"]];
//                if([saytextStr rangeOfString:@"__modifyuserfile__"].location != NSNotFound){
//                    
//                    if([[MyAppDataManager getPreferredLanguage] isEqual:@"zh-Hans"]){
//                        [saytextStr deleteCharactersInRange:NSMakeRange([saytextStr rangeOfString:@"__modifyuserfile__"].location, 18)];
//                        
//                        saytextStr = (NSMutableString *)[@"__modifyuserfile__ " stringByAppendingString:saytextStr];
//                        //                            NSLog(@"%@",saytextStr);
//                        
//                    }
//                }
//                
//                [mcontentDic setValue:[MyAppDataManager IsInternationalLanguage:(NSString *)saytextStr] forKey:@"saytext"];
                
                 [mcontentDic setValue:[MyAppDataManager IsInternationalLanguage:[mcontentDic valueForKey:@"saytext"]] forKey:@"saytext"];
                  [aDic setValue:mcontentDic forKey:@"mcontent"];
                
                
                
                
//                NSLog(@"%@",aDic);
                 [self.userActions addObject:aDic];
//                NSLog(@"%@",self.userActions);

            }
 
            [self.tableView reloadData];
        }
        else{
//            NSLog(@"%@",[resDic valueForKey:@"error"]);
            if([[resDic valueForKey:@"error"] isEqualToString:@"__loginidinvalid__"]){
                [self.navigationController popToRootViewControllerAnimated:NO];

            }
         }
    }
    else if([AppComManager respondsDic:resDic isFunctionData:BanBu_Set_User_View]){
//        //NSLog(@"%@",resDic);
    }
    else if([AppComManager respondsDic:resDic isFunctionData:BanBu_Set_FriendName]){
//        NSLog(@"%@",resDic);
        if([[resDic valueForKey:@"ok"]boolValue]){
            NSMutableDictionary *uidDic = [NSMutableDictionary dictionaryWithDictionary:[UserDefaults valueForKey:MyAppDataManager.useruid]];
            [uidDic setValue:[resDic valueForKey:@"list"] forKey:@"renameflist"];
            [UserDefaults setValue:uidDic forKey:MyAppDataManager.useruid];
            [UserDefaults synchronize];
            [aNote removeFromSuperview];
            self.title =  [MyAppDataManager IsInternationalLanguage:[MyAppDataManager theRevisedName:[_profile valueForKey:@"pname"] andUID:[_profile valueForKey:@"userid"]]];
        }else{
                        
            [TKLoadingView showTkloadingAddedTo:self.navigationController.view title:[MyAppDataManager IsInternationalLanguage:[resDic valueForKey:@"error"]] activityAnimated:NO duration:1.0];

        }
        

    }
    //蛋疼的更新
    else if([AppComManager respondsDic:resDic isFunctionData:BanBu_Get_User_Info]){
        if([[resDic valueForKey:@"ok"]boolValue]){
            
            NSLog(@"%@",resDic);
            _profile = [[NSMutableDictionary alloc]initWithDictionary:resDic];
            _photoView.myPhotos = [_profile valueForKey:@"facelist"];
            
            UIView  *headView = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 30)];
            headView.backgroundColor = [UIColor colorWithRed:255.0/255 green:250.0/255 blue:240.0/255 alpha:1.0];
            
            
            UILabel *sexLabel = [[UILabel alloc] initWithFrame:CGRectMake(10,5,20,20)];
            sexLabel.font = [UIFont systemFontOfSize:14];
            sexLabel.textAlignment = UITextAlignmentCenter;
            sexLabel.textColor = [UIColor whiteColor];
            sexLabel.layer.cornerRadius = 4.0f;
            if([[_profile valueForKey:@"gender" ] isEqualToString:@"m"])
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
            
            UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, 0, 100, 30)];
            titleLabel.font = [UIFont systemFontOfSize:14];
            titleLabel.backgroundColor = [UIColor clearColor];
            titleLabel.textColor = [UIColor colorWithRed:56.0/255 green:84.0/255 blue:135.0/255 alpha:1.0];
            titleLabel.text = [NSString stringWithFormat:@"%@ %@",[MyAppDataManager IsInternationalLanguage:[_profile valueForKey:@"sstar"]],[_profile valueForKey:@"oldyears"]];
            [headView addSubview:titleLabel];
            [titleLabel release];
            
            UILabel *distanceLabel = [[UILabel alloc] initWithFrame:CGRectMake(150, 0, 160, 30)];
            distanceLabel.font = [UIFont systemFontOfSize:14];
            distanceLabel.backgroundColor = [UIColor clearColor];
            
            distanceLabel.textColor = [UIColor colorWithRed:56.0/255 green:84.0/255 blue:135.0/255 alpha:1.0];
            distanceLabel.textAlignment = UITextAlignmentRight;
            //    NSLog(@"%@",_profile );
            
            if(![[_profile allKeys] containsObject:@"dmeter"] || ![[_profile allKeys] containsObject:@"ltime"]){
                //        NSMutableDictionary *pars = [NSMutableDictionary dictionaryWithCapacity:2];
                //        [pars setValue:[_profile valueForKey:@"userid"] forKey:@"email_uid"];
                //        [AppComManager getBanBuData:BanBu_Get_User_Info par:pars delegate:self];
                //        self.navigationController.view.userInteractionEnabled = NO;
                //        distanceLabel.text = @"";
            }else{
                //        distanceLabel.text = [NSString stringWithFormat:@"%@ | %@",[_profile valueForKey:@"dmeter"],[_profile valueForKey:@"ltime"]];
                NSString *interLtime = [MyAppDataManager IsInternationalLanguage:[_profile valueForKey:@"ltime"]];
                NSString *interDmeter = [MyAppDataManager IsInternationalLanguage:[_profile valueForKey:@"dmeter"]];
                CGFloat btnLen = [interLtime sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(100, 30)].width;
                CGFloat btnLen1 = [interDmeter sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(100, 30)].width;
                UILabel *ltimeLabel = [[UILabel alloc]initWithFrame:CGRectMake(310-btnLen, 0, btnLen, 30)];
                ltimeLabel.text = interLtime;
                ltimeLabel.font = [UIFont systemFontOfSize:14];
                ltimeLabel.backgroundColor = [UIColor clearColor];
                ltimeLabel.textColor = [UIColor colorWithRed:56.0/255 green:84.0/255 blue:135.0/255 alpha:1.0];
                [headView addSubview:ltimeLabel];
                [ltimeLabel release];
                UIImageView *ltimeImageView = [[UIImageView alloc]initWithFrame:CGRectMake(ltimeLabel.frame.origin.x-30+6, 3+6, 12, 12)];
                ltimeImageView.image = [UIImage imageNamed:@"ic_user_loctime.png"];
                [headView addSubview:ltimeImageView];
                [ltimeImageView release];
                
                UILabel *dmeterLabel = [[UILabel alloc]initWithFrame:CGRectMake(ltimeImageView.frame.origin.x-btnLen1-5, 0, btnLen1, 30)];
                dmeterLabel.text = interDmeter;
                dmeterLabel.font = [UIFont systemFontOfSize:14];
                dmeterLabel.backgroundColor = [UIColor clearColor];
                dmeterLabel.textColor = [UIColor colorWithRed:56.0/255 green:84.0/255 blue:135.0/255 alpha:1.0];
                [headView addSubview:dmeterLabel];
                [dmeterLabel release];
                UIImageView *dmeterImageView = [[UIImageView alloc]initWithFrame:CGRectMake(dmeterLabel.frame.origin.x-27+6, 3+6, 12, 12)];
                dmeterImageView.image = [UIImage imageNamed:@"ic_user_location.png"];
                [headView addSubview:dmeterImageView];
                [dmeterImageView release];
            }
            [headView addSubview:distanceLabel];
            [distanceLabel release];
            
            UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 29, 320, 1.0)];
            lineView.backgroundColor = [UIColor colorWithRed:224.0/255 green:224.0/255 blue:224.0/255 alpha:1.0];
            [headView addSubview:lineView];
            [lineView release];
            
            self.tableView.tableHeaderView = headView;
            [headView release];

            [self.tableView reloadData];
        }
    }
    
}




- (void) performPublishAction:(void (^)(void)) action {
    // we defer request for permission to post to the moment of post, then we check for the permission
    if ([FBSession.activeSession.permissions indexOfObject:@"publish_actions"] == NSNotFound) {
        // if we don't already have the permission, then we request it now
        [[FBSession activeSession] reauthorizeWithPublishPermissions:@[@"publish_actions"] defaultAudience:FBSessionDefaultAudienceFriends completionHandler:^(FBSession *session, NSError *error) {
            if (!error) {
                action();
            }
        }];
    } else {
        action();
    }
    
    
    
}







@end
