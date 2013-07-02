//
//  BanBu_MySpaceViewController.m
//  BanBu
//
//  Created by 17xy on 12-7-31.
//
//

#import "BanBu_MySpaceViewController.h"
#import "BanBu_MyProfileViewController.h"
#import "BanBu_SettingViewController.h"
#import "BanBu_DynamicController.h"
//#import "WebViewController.h"
#import "UIBadgeView.h"
#import "AppCommunicationManager.h"
#import "AppDataManager.h"
@interface BanBu_MySpaceViewController ()
{
    BOOL  _isReceive;

}

-(void)LoadBadaget:(NSString *)badaget;

-(NSString *)BindUserid:(NSString *)usrid;
@end

@implementation BanBu_MySpaceViewController

@synthesize dynamicButton=_dynamicButton,badaget=_badaget;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        
         
        
        
        
        
    }
    return self;
}

-(NSString *)BindUserid:(NSString *)usrid
{
   
    return [@"myusridis"stringByAppendingString:usrid];

}

-(void)createTheBandageView:(NSString *)string
{
    self.navigationController.tabBarItem.badgeValue =string;
    
}


-(void)viewWillDisappear:(BOOL)animated
{


    if([[[UserDefaults valueForKey:MyAppDataManager.useruid] valueForKey:@"settings"] valueForKey:@"boolKey"])
    {
     
        NSMutableDictionary *settingsDic = [NSMutableDictionary dictionaryWithDictionary:[[UserDefaults valueForKey:MyAppDataManager.useruid] valueForKey:@"settings"]];

        NSMutableArray  *boolArr=[NSMutableArray arrayWithArray:[[[UserDefaults valueForKey:MyAppDataManager.useruid] valueForKey:@"settings"] valueForKey:@"boolKey"]];
        
        [boolArr replaceObjectAtIndex:1 withObject:[NSNumber numberWithBool:_isReceive]];
 
        [settingsDic setValue:boolArr forKey:@"boolKey"];
     
        
        NSMutableDictionary *settingsUpdata = [NSMutableDictionary dictionaryWithDictionary:[UserDefaults valueForKey:MyAppDataManager.useruid]];
        [settingsUpdata setValue:settingsDic forKey:@"settings"];
        [UserDefaults setValue:settingsUpdata forKey:MyAppDataManager.useruid];
        
        
        
        
    }

    [super viewWillDisappear:animated];
    
}




- (void)viewDidLoad
{
    [super viewDidLoad];

//    self.title = @"我的空间";
    self.tableView.scrollEnabled = NO;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor colorWithRed:255.0/255 green:250.0/255 blue:240.0/255 alpha:1.0];
    
    
    // 这是存放我有没有查看这个人
    
    NSString *key=[self BindUserid:MyAppDataManager.useruid];
    
     if(![UserDefaults valueForKey:key])
      [UserDefaults setValue:@"0" forKey:key];
    
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void)buildButtonWithFrame:(CGRect)frame andImage:(NSString *)imageName andTag:(NSInteger)tag andSuperView:(UIView *)superV{
    UIButton *aButton=[UIButton buttonWithType:UIButtonTypeCustom];
    aButton.tag=tag;
    
    if(aButton.tag==2)
    {
        _dynamicButton=aButton;
        
    }
    
    aButton.backgroundColor = [UIColor clearColor];
    [aButton setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    aButton.frame=frame;
    [aButton addTarget:self action:@selector(action:) forControlEvents:UIControlEventTouchUpInside];
    [superV addSubview:aButton];
    
    NSArray *imageTitles = [NSArray arrayWithObjects:NSLocalizedString(@"myinfoLabel", nil),NSLocalizedString(@"systemLabel", nil),NSLocalizedString(@"visitorLabel", nil),NSLocalizedString(@"helperLabel", nil),NSLocalizedString(@"trainTitle", nil),@"水果忍着", nil];

    UILabel *aLabel = [[UILabel alloc]initWithFrame:CGRectMake(-15, 42, 80, 25)];
    aLabel.backgroundColor = [UIColor clearColor];
    
    aLabel.text = [imageTitles objectAtIndex:tag];
    aLabel.textAlignment =UITextAlignmentCenter;
    aLabel.font = [UIFont systemFontOfSize:12];
    [aButton addSubview:aLabel];
    [aLabel release];
//    aButton.backgroundColor=[UIColor redColor];
//    aLabel.backgroundColor = [UIColor greenColor];
    
   // 这是
    
    
    
}

-(void)LoadBadaget:(NSString *)badaget
{
    
    UIBadgeView *badgeView = (UIBadgeView *)[self.view viewWithTag:1000];
    if(!badaget)
    {
        if(badgeView)
            [badgeView removeFromSuperview];
    }
    else
    {
        float width = [badaget sizeWithFont:[UIFont boldSystemFontOfSize:12]].width+18;
        if(!badgeView)
        {
            badgeView = [[UIBadgeView alloc] initWithFrame:CGRectMake(35, -2, width, 20)];
            badgeView.tag = 1000;
            badgeView.backgroundColor = [UIColor clearColor];
            badgeView.badgeColor = [UIColor redColor];
            [_dynamicButton addSubview:badgeView];
         
        }
     
        badgeView.badgeString = badaget;
        [UIView animateWithDuration:0.5
                         animations:^{
                             badgeView.frame = CGRectMake(35, -2, width, 20);
                             
                         }];

        
        
    }
    
    

}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    return 1;
}

- (float)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 25;
}

- (float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(!indexPath.section)
        return 75;
    else
        return 240;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UILabel *header = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 25)];
    header.backgroundColor = [UIColor colorWithRed:206.0/255 green:206.0/255 blue:206.0/255 alpha:1.0];
    header.font = [UIFont boldSystemFontOfSize:14];
    header.textColor = [UIColor darkGrayColor];
    header.text = section?NSLocalizedString(@"myApp", nil):NSLocalizedString(@"myCenter", nil);
    return [header autorelease];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell == nil)
    {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.backgroundView.backgroundColor = [UIColor colorWithRed:255.0/255 green:250.0/255 blue:240.0/255 alpha:1.0];

    if(indexPath.section)
    {
        [self buildButtonWithFrame:CGRectMake(24, 5, 50, 50) andImage:@"train.png" andTag:4 andSuperView:cell];
//        [self buildButtonWithFrame:CGRectMake(24+74, 5, 50, 50) andImage:@"train.png" andTag:5 andSuperView:cell];


    }
    else
    {
        NSArray *imagesNames = [NSArray arrayWithObjects:@"info.png",@"system.png",@"dymScan.png",@"helper.png", nil];
        for(int i=0; i<4; i++)
        {
            [self buildButtonWithFrame:CGRectMake(24+74*i, 5, 50, 50) andImage:[imagesNames objectAtIndex:i] andTag:i andSuperView:cell];
            
            
        }
    }
    
    return cell;
}

- (void)action:(UIButton *)button
{
    if(button.tag == 0)
    {
        BanBu_MyProfileViewController *myProfile = [[BanBu_MyProfileViewController alloc] init];
        myProfile.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:myProfile animated:YES];
        [myProfile release];
    }
    else if(button.tag == 1)
    {
        BanBu_SettingViewController *setting = [[BanBu_SettingViewController alloc] init];
        setting.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:setting animated:YES];
        [setting release];
    }else if(button.tag == 2)
    {
        
        if([[[UserDefaults valueForKey:MyAppDataManager.useruid] valueForKey:@"settings"] valueForKey:@"boolKey"])
        {
            
            
            
            
            NSMutableDictionary *settingsDic = [NSMutableDictionary dictionaryWithDictionary:[[UserDefaults valueForKey:MyAppDataManager.useruid] valueForKey:@"settings"]];
            
            
            NSMutableArray  *boolArr=[NSMutableArray arrayWithArray:[[[UserDefaults valueForKey:MyAppDataManager.useruid] valueForKey:@"settings"] valueForKey:@"boolKey"]];
            
            _isReceive=[[boolArr objectAtIndex:1] boolValue];
            
            [boolArr replaceObjectAtIndex:1 withObject:[NSNumber numberWithBool:NO]];
            
            [UserDefaults setValue:boolArr forKey:@"boolKey"];
            [settingsDic setValue:boolArr forKey:@"boolKey"];
            
            
            NSMutableDictionary *settingsUpdata = [NSMutableDictionary dictionaryWithDictionary:[UserDefaults valueForKey:MyAppDataManager.useruid]];
            [settingsUpdata setValue:settingsDic forKey:@"settings"];
            [UserDefaults setValue:settingsUpdata forKey:MyAppDataManager.useruid];

            
            
        }

        BanBu_DynamicController *dynamic = [[BanBu_DynamicController alloc]initWithDynamicDisplayType:DisplayVisitRecord];
        dynamic.hidesBottomBarWhenPushed =  YES;
        [self.navigationController pushViewController:dynamic animated:YES];
        [dynamic  release];
        
        self.navigationController.tabBarItem.badgeValue=@"0";
        
    }else if(button.tag == 3)
    {
        BanBu_HelpViewController *help=[[BanBu_HelpViewController alloc]init];
    
        help.hidesBottomBarWhenPushed=YES;
        
        [self.navigationController pushViewController:help animated:YES];
        
        [help release];
        
      
        
    }else if(button.tag >= 4)
    {
//        WebViewController *aWeb = [[WebViewController alloc]init];
//        aWeb.adNum =  button.tag-4;
//        [self presentModalViewController:aWeb animated:YES];
//        [aWeb release];
    }
    
    
    
}



-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // 这里要请求
    
    NSMutableDictionary *parDic = [NSMutableDictionary dictionary];
  
     if([self.navigationController.tabBarItem.badgeValue intValue])
  
         [AppComManager getBanBuData:BanBu_Get_Friend_ViewList par:parDic delegate:self];
  
    if([[[UserDefaults valueForKey:MyAppDataManager.useruid] valueForKey:@"settings"] valueForKey:@"boolKey"])
    {
        NSMutableArray  *boolArr=[NSMutableArray arrayWithArray:[[[UserDefaults valueForKey:MyAppDataManager.useruid] valueForKey:@"settings"] valueForKey:@"boolKey"]];
        
        _isReceive=[[boolArr objectAtIndex:1] boolValue];
        
                
    }

    
}

// 获取成功的
- (void)banbuRequestDidFinished:(NSDictionary *)resDic error:(NSError *)error
{
    
  // 获取成功的话
   if(error)
   {
//       [TKLoadingView showTkloadingAddedTo:self.tableView title:@"获取动态失败" activityAnimated:NO duration:1.2];
   
       return;
   }
    
   if([AppComManager respondsDic:resDic isFunctionData:BanBu_Get_Friend_ViewList])
   {
      if(![[resDic valueForKey:@"ok"] boolValue])
      {
         // 如果返回为n 那么请求失败
//          [TKLoadingView showTkloadingAddedTo:self.tableView title:@"获取动态失败" activityAnimated:NO duration:1.2];
          
          return;
          
      }
      else{
          // 看过我的人的数组存放
          [MyAppDataManager.friendViewList removeAllObjects];
          
          [MyAppDataManager.friendViewList addObjectsFromArray:[resDic valueForKey:@"list"]];
      
          _badaget=self.navigationController.tabBarItem.badgeValue;
        
          // 判断 有没有最新的动态 且看没看过
          if(![[UserDefaults valueForKey:[self BindUserid:MyAppDataManager.useruid]] boolValue]&&[MyAppDataManager.friendViewList count]>0)
              
          {
              
              [self LoadBadaget:_badaget];
          
          
          }else
          {
                      
          if( [self.navigationController.view viewWithTag:1000])
          {
          
              [[self.navigationController.view viewWithTag:1000]removeFromSuperview];
          }
             
         }

      }

   }

}







#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
}

@end
