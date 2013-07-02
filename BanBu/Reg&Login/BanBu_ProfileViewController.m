//
//  BanBu_ProfileViewController.m
//  BanBu
//
//  Created by apple on 13-1-11.
//
//

#import "BanBu_ProfileViewController.h"
#import "BanBu_ListCellCell.h"
#import "AppDataManager.h"
#import "BanBu_LoginViewController.h"
#import "BanBu_RegViewController.h"
@interface BanBu_ProfileViewController ()

@end

@implementation BanBu_ProfileViewController
@synthesize headerArr=_headerArr;
@synthesize dictionary=_dictionary;
@synthesize type=_type;
@synthesize photoView=_photoView;
@synthesize toolbarView=_toolbarView;
@synthesize userActions=_userActions;
-(id)initWithDictionary:(NSMutableDictionary *)dictionary DisplayType:(DisplayType)type
{
    self=[super initWithStyle:UITableViewStylePlain];
    
     if(!self)
     {
         return nil;
     }
    _dictionary= [[NSMutableDictionary alloc]initWithDictionary:dictionary];
//    NSLog(@"%@",_dictionary);
    _type=type;
    
    self.title=[_dictionary valueForKey:@"pname"];
   
    
    return self;

}
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
	// Do any additional setup after loading the view.
    
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
        [button addTarget:self action:@selector(listStyle:) forControlEvents:UIControlEventTouchUpInside];
        [barView addSubview:button];
        x += image.size.width;
        
    }
    
    
    self.toolbarView = barView;
    
    
   [self.navigationController.view addSubview:barView];
    
    [barView release];
    
    UIView *footer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 45)];
    footer.backgroundColor = [UIColor clearColor];
    self.tableView.tableFooterView = footer;
    [footer release];

    UIView  *headView = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 30)];
    headView.backgroundColor = [UIColor colorWithRed:255.0/255 green:250.0/255 blue:240.0/255 alpha:1.0];
    
    
    UILabel *sexLabel = [[UILabel alloc] initWithFrame:CGRectMake(10,5,20,20)];
    sexLabel.font = [UIFont systemFontOfSize:14];
    sexLabel.textAlignment = UITextAlignmentCenter;
    sexLabel.textColor = [UIColor whiteColor];
    sexLabel.layer.cornerRadius = 4.0f;
    if([[_dictionary valueForKey:@"gender" ] isEqualToString:@"m"])
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
    titleLabel.text = [NSString stringWithFormat:@"%@ %@",[_dictionary valueForKey:@"sstar"],[_dictionary valueForKey:@"oldyears"]];
    [headView addSubview:titleLabel];
    [titleLabel release];
    
    UILabel *distanceLabel = [[UILabel alloc] initWithFrame:CGRectMake(150, 0, 160, 30)];
    distanceLabel.font = [UIFont systemFontOfSize:14];
    distanceLabel.backgroundColor = [UIColor clearColor];
    
    distanceLabel.textColor = [UIColor colorWithRed:56.0/255 green:84.0/255 blue:135.0/255 alpha:1.0];
    distanceLabel.textAlignment = UITextAlignmentRight;
    //    NSLog(@"%@",_profile );
    
    if(![[_dictionary allKeys] containsObject:@"dmeter"] || ![[_dictionary allKeys] containsObject:@"ltime"]){
        distanceLabel.text = @"";
    }else{
        distanceLabel.text = [NSString stringWithFormat:@"%@ | %@",[_dictionary valueForKey:@"dmeter"],[_dictionary valueForKey:@"ltime"]];
        
    }
    [headView addSubview:distanceLabel];
    [distanceLabel release];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 29, 320, 1.0)];
    lineView.backgroundColor = [UIColor colorWithRed:224.0/255 green:224.0/255 blue:224.0/255 alpha:1.0];
    [headView addSubview:lineView];
    [lineView release];
    
    self.tableView.tableHeaderView = headView;
    [headView release];
    
    titleAndValueArr = [[NSMutableArray alloc]initWithCapacity:10];

    NSArray *grjsArr = [NSArray arrayWithObjects: @"liked" ,@"lovego" , @"company" , @"jobtitle" , @"school" , nil];
    NSArray *titleArr1 = [NSArray arrayWithObjects: NSLocalizedString(@"s2c0", nil),NSLocalizedString(@"s2c1", nil),NSLocalizedString(@"s2c2", nil),NSLocalizedString(@"s2c3", nil),NSLocalizedString(@"s2c4", nil), nil];
    for (int i=0; i<5; i++) {
        if([[_dictionary valueForKey:[grjsArr objectAtIndex:i]] length]){
            NSDictionary *aDic = [NSDictionary dictionaryWithObject:[_dictionary valueForKey:[grjsArr objectAtIndex:i]] forKey:[titleArr1 objectAtIndex:i]];
            [titleAndValueArr addObject:aDic];
            grjsNum++;
        }
    }
    //    grjsNum = 5;
    grjsNum?(isHaveGRJS = YES):(isHaveGRJS = NO);
    //NSLog(@"%d%d",grjsNum,isHaveGRJS);
    
    
    
}

-(void)listStyle:(UIButton *)sender
{

    UIAlertView *alertView = nil;
    NSString *langauage=[MyAppDataManager getPreferredLanguage];
    if([langauage isEqual:@"zh-Hans"]){
        alertView=[[UIAlertView alloc]initWithTitle:NSLocalizedString(@"noticeNotLog", nil) message:nil delegate:self cancelButtonTitle:NSLocalizedString(@"cancelNotice", nil) otherButtonTitles:NSLocalizedString(@"logButton", nil),NSLocalizedString(@"regButton", nil), nil];

    }else{
        alertView=[[UIAlertView alloc]initWithTitle:NSLocalizedString(@"noticeNotLog", nil) message:nil delegate:self cancelButtonTitle:NSLocalizedString(@"cancelNotice", nil) otherButtonTitles:NSLocalizedString(@"logButton", nil), nil];

    }
    
    
    
    alertView.tag=1989;

    [alertView show];
//    UIActionSheet *aSheet = [[UIActionSheet alloc]initWithTitle:NSLocalizedString(@"noticeNotLog", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"cancelNotice", nil) destructiveButtonTitle:nil otherButtonTitles:NSLocalizedString(@"logButton", nil),NSLocalizedString(@"regButton", nil), nil];
//    aSheet.tag = 1989;
//    [aSheet showInView:self.view.window];
//    [aSheet release];
    
//    [TKLoadingView showTkloadingAddedTo:self.view title:NSLocalizedString(@"noticeNotLog", nil) activityAnimated:NO duration:2.0];
//    [self performSelector:@selector(backToLast) withObject:nil afterDelay:2.0];
}

-(void)backToLast{
    [self.navigationController popToRootViewControllerAnimated:YES];

}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.tag!=1989)
        return;
    NSLog(@"%d",buttonIndex);
    NSString *langauage=[MyAppDataManager getPreferredLanguage];
    if([langauage isEqual:@"zh-Hans"]){
        if(buttonIndex==1)
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
        else if(buttonIndex == 2)
        {
            
            BanBu_RegViewController *regsiter=[[BanBu_RegViewController alloc]init];
            
            CATransition *animation = [CATransition animation];
            animation.duration = .5f;
            animation.timingFunction=UIViewAnimationCurveEaseInOut;
            animation.fillMode = kCAFillModeForwards;
            animation.type = kCATransitionReveal;
            animation.subtype = kCATransitionFade;
            
            [self.view.window.layer addAnimation:animation forKey:@"animation"];
            
            [self.navigationController pushViewController:regsiter animated:NO];
            
            [regsiter release];
            
        }
    }else{
        if(buttonIndex == 1){
            
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

    }
   

        
     
    
    
    
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
            NSString *detailValue = [_dictionary valueForKey:@"sayme"];
            return [detailValue sizeWithFont:[UIFont systemFontOfSize:15] constrainedToSize:CGSizeMake(300, 1000)].height+30;
        }
        else{
            
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

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
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
        NSDictionary *mcontentDic = [AppComManager getAMsgFrom64String:[aData valueForKey:@"mcontent"]];
        
        [cell setSignature:[mcontentDic valueForKey:@"saytext"]];
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
                        if(![[_dictionary valueForKey:@"hbody"] isEqualToString:@"-"]){
                            cell.detailTextLabel.text = [_dictionary valueForKey:@"hbody"];
                        }else{
                            cell.detailTextLabel.text =@"<160";
                        }
                    }else if(indexPath.row == 1){
                        cell.textLabel.text = NSLocalizedString(@"s1c1", nil);
                        if(![[_dictionary valueForKey:@"xblood"] isEqualToString:@""]){
                            cell.detailTextLabel.text = [_dictionary valueForKey:@"xblood"];
                        }else{
                            cell.detailTextLabel.text =@"A";
                        }
                    }else if(indexPath.row == 2){
                        cell.textLabel.text = NSLocalizedString(@"s1c2", nil);
                        if(![[_dictionary valueForKey:@"wbody"] isEqualToString:@"-"]){
                            cell.detailTextLabel.text = [_dictionary valueForKey:@"wbody"];
                        }else{
                            cell.detailTextLabel.text =@"<40";
                        }                    }
                }else if(indexPath.section == 2){
                    
                    cell.textLabel.text = [[[titleAndValueArr objectAtIndex:indexPath.row] allKeys] objectAtIndex:0];
                    cell.detailTextLabel.text =  [[[titleAndValueArr objectAtIndex:indexPath.row] allValues] objectAtIndex:0];
                    
                }else if(indexPath.section == 3){
                    if(indexPath.row == 0){
                        cell.textLabel.text = NSLocalizedString(@"s0c0", nil);
                        cell.detailTextLabel.text = [_dictionary valueForKey:@"userid"];
                    }else if(indexPath.row == 1){
                       // NSArray *frindshipArr = [NSArray arrayWithObjects:NSLocalizedString(@"friendShip", nil),NSLocalizedString(@"friendShip1", nil),NSLocalizedString(@"friendShip2", nil),NSLocalizedString(@"friendShip3", nil),NSLocalizedString(@"friendShip4", nil),NSLocalizedString(@"friendShip5", nil), nil];
                        cell.textLabel.text = NSLocalizedString(@"relationshipLabel", nil);
                        
                        cell.detailTextLabel.text =NSLocalizedString(@"friendShip4", nil);
                       //                       if(_kind == 3){
                        //                            _isBlack =  YES;
                        //                        }else{
                        //                            _isBlack = NO;
                        //                        }
                        //                        //NSLog(@"%d",_kind);
                    }
                }
                
                
                
            }else{
                id faces = [_dictionary valueForKey:@"facelist"];
                if([faces isKindOfClass:[NSArray class]])
                {
                    if([faces count]){
                        _photoView.myPhotos = faces;
                        
                    }else{
                        _photoView.myPhotos = [NSArray arrayWithObject:[NSDictionary dictionaryWithObject:[_dictionary valueForKey:@"uface"] forKey:@"facefile"]];
                        //                        NSMutableDictionary *parDic = [NSMutableDictionary dictionary];
                        //                        parDic setValue:<#(id)#> forKey:<#(NSString *)#>
                        
                    }
                }
                cell.textLabel.text = NSLocalizedString(@"s0c2", nil);
                cell.detailTextLabel.text =  [_dictionary valueForKey:@"sayme"];
            }
        }else{
            if(indexPath.section){
                if (indexPath.section == 1) {
                    //                    NSArray *heightArr = [NSArray arrayWithObjects:@"a",@"b",@"c",@"d",@"e",@"<160",@"160-165",@"165-170",@"170-175",@">175", nil];
                    //                    NSArray *weightArr = [NSArray arrayWithObjects:@"a",@"b",@"c",@"d",@"e",@"<40",@"40-50",@"50-60",@"60-70",@">70", nil];
                    if(indexPath.row == 0){
                        cell.textLabel.text = NSLocalizedString(@"s1c0", nil);
                        //                        //NSLog(@"%@",[_profile valueForKey:@"hbody"]);
                        if(![[_dictionary valueForKey:@"hbody"] isEqualToString:@""]){
                            cell.detailTextLabel.text = [_dictionary valueForKey:@"hbody"];
                        }else{
                            cell.detailTextLabel.text =@"<160";
                        }
                    }else if(indexPath.row == 1){
                        cell.textLabel.text = NSLocalizedString(@"s1c1", nil);
                        if(![[_dictionary valueForKey:@"xblood"] isEqualToString:@""]){
                            cell.detailTextLabel.text = [_dictionary valueForKey:@"xblood"];
                        }else{
                            cell.detailTextLabel.text =@"A";
                        }
                    }else if(indexPath.row == 2){
                        cell.textLabel.text = NSLocalizedString(@"s1c2", nil);
                        if(![[_dictionary valueForKey:@"wbody"] isEqualToString:@""]){
                            cell.detailTextLabel.text = [_dictionary valueForKey:@"wbody"];
                        }else{
                            cell.detailTextLabel.text =@"<40";
                        }                    }
                }else if(indexPath.section == 2){
                    if(indexPath.row == 0){
                        cell.textLabel.text = NSLocalizedString(@"s0c0", nil);
                        cell.detailTextLabel.text = [_dictionary valueForKey:@"userid"];
                    }else if(indexPath.row == 1){
                       // NSArray *frindshipArr = [NSArray arrayWithObjects:NSLocalizedString(@"friendShip", nil),NSLocalizedString(@"friendShip1", nil),NSLocalizedString(@"friendShip2", nil),NSLocalizedString(@"friendShip3", nil),NSLocalizedString(@"friendShip4", nil),NSLocalizedString(@"friendShip5", nil), nil];
                       
                        cell.textLabel.text = NSLocalizedString(@"relationshipLabel", nil);
                        
                        cell.detailTextLabel.text =NSLocalizedString(@"friendShip4", nil);
                        //cell.detailTextLabel.text =  [frindshipArr objectAtIndex:_kind];
                        //                        if(_kind == 3){
                        //                            _isBlack =  YES;
                        //                        }else{
                        //                            _isBlack = NO;
                        //                        }
                        //                        //NSLog(@"%d",_kind);
                    }
                }
                
                
                
            }else{
                id faces = [_dictionary valueForKey:@"facelist"];
                if([faces isKindOfClass:[NSArray class]])
                {
                    if([faces count]){
                        _photoView.myPhotos = faces;
                        
                    }else{
                        _photoView.myPhotos = [NSArray arrayWithObject:[NSDictionary dictionaryWithObject:[_dictionary valueForKey:@"uface"] forKey:@"facefile"]];
                        
                    }                }
                cell.textLabel.text = NSLocalizedString(@"s0c2", nil);
                cell.detailTextLabel.text =  [_dictionary valueForKey:@"sayme"];
            }
        }
        
        cell.detailTextLabel.textColor = [UIColor colorWithRed:56.0/255 green:84.0/255 blue:135.0/255 alpha:1.0];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
    }
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
   
}

-(void)viewWillUnload
{
    [super viewWillUnload];
    
    self.dictionary = nil;
    //    _success =NO;
    [_toolbarView removeFromSuperview];
    self.toolbarView = nil;
    _photoView = nil;



}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

    [UIView animateWithDuration:0.5
                     animations:^{
                         CGRect rect = _toolbarView.frame;
                         rect.origin.y -= 44;
                         _toolbarView.frame = rect;
                     }];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
       
    [UIView animateWithDuration:0.5
                     animations:^{
                         
                         CGRect rect=_toolbarView.frame;
                         
                         rect.origin.y+=44;
                         
                         _toolbarView.frame=rect;
                         
                     }];


}





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
}


-(void)dealloc
{

    [_dictionary release];
    [titleAndValueArr release];
    _photoView = nil;
    [_toolbarView removeFromSuperview];
    [_toolbarView release];
    [_headerArr release];

    
    [super dealloc];
}


+(BanBu_ProfileViewController*)getBanBu
{
 
    return [[[BanBu_ProfileViewController alloc]init]autorelease];
}
@end
