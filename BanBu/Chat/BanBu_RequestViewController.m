//
//  BanBu_RequestViewController.m
//  BanBu
//
//  Created by apple on 13-1-29.
//
//

#import "BanBu_RequestViewController.h"
#import "AppDataManager.h"
#import "BanBu_ProfileViewController.h"
@interface BanBu_RequestViewController ()

-(BOOL)isFriend:(NSDictionary *)dict;

@end

@implementation BanBu_RequestViewController
@synthesize friendt;
@synthesize badage;
@synthesize dictionary=_dictionary;
@synthesize receiveButton=_receiveButton;
@synthesize profile=_profile;
@synthesize delegate=_delegate;
@synthesize relationArr=_relationArr;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        
        _receiveButton=[UIButton buttonWithType:UIButtonTypeCustom];
        
        _profile=[[[NSMutableDictionary alloc]init]autorelease];
        
       

        
    }
    return self;
}


-(void)viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:animated];
    
    [self setRefreshing];
    
    // 一个人的各种关系
    
     _relationArr=[[NSMutableArray alloc] initWithArray:[[[UserDefaults valueForKey:MyAppDataManager.useruid] valueForKey:@"friendlist"] valueForKey:@"flist"]];
   
}


-(BOOL)isFriend:(NSDictionary *)dict
{
    for(NSDictionary * dic in _relationArr)
    {
        if([VALUE(@"fuid", dic) isEqual:VALUE(KeyFromUid, dict)]&&[VALUE(@"linkkind", dic)isEqual:@"h"])
        {
            return YES;
        }
    }
    return NO;
}




-(void)loadingData
{
    [super loadingData];
    
    NSMutableDictionary *parDic = [NSMutableDictionary dictionary];
    [AppComManager getBanBuData:BanBu_Get_Request_From_All par:parDic delegate:self];
    self.navigationController.view.userInteractionEnabled = NO;


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
    
    if([AppComManager respondsDic:resDic isFunctionData:BanBu_Get_Request_From_All]){
        if([[resDic valueForKey:@"ok"]boolValue]){
            if(_isLoadingRefresh)
            {
                [requestArr removeAllObjects];
            }
           
            [requestArr addObjectsFromArray:[resDic valueForKey:@"list"]];
        
            NSArray *sortedArray = [requestArr sortedArrayUsingComparator: ^(id obj1, id obj2) {
                if ([[obj2 objectForKey:@"meters"] integerValue] < [[obj1 objectForKey:@"meters"] integerValue]) {
                    return (NSComparisonResult)NSOrderedDescending;
                }
                if ([[obj2 objectForKey:@"meters"] integerValue] > [[obj1 objectForKey:@"meters"] integerValue]) {
                    return (NSComparisonResult)NSOrderedAscending;
                }
                return (NSComparisonResult)NSOrderedSame;
            }];
        
            [requestArr removeAllObjects];
            [requestArr addObjectsFromArray:sortedArray];
            
        }
        // 将每个requestArr 加入数据库
        
        // [MyAppDataManager insertAgreeData:<#(id)#> forItem:<#(NSString *)#> forUid:<#(NSString *)#>]
    
        [self.tableView reloadData];
      [self performSelector:@selector(finishedLoading) withObject:nil afterDelay:1.5];
    
    }else if([AppComManager respondsDic:resDic isFunctionData:BanBu_Delete_Request_ByIDList])
    {
    
    
    
    }else if ([AppComManager respondsDic:resDic isFunctionData:BanBu_Set_Friend_Link])
    {
         // 这是同意对方添加
      
        NSMutableDictionary *uidDic = [NSMutableDictionary dictionaryWithDictionary:[UserDefaults valueForKey:MyAppDataManager.useruid]];
        [uidDic setValue:[resDic valueForKey:@"friendlist"] forKey:FriendShip];
        [UserDefaults setValue:uidDic forKey:MyAppDataManager.useruid];
        [UserDefaults synchronize];
        
         _relationArr=[[NSMutableArray alloc] initWithArray:[[[UserDefaults valueForKey:MyAppDataManager.useruid] valueForKey:@"friendlist"] valueForKey:@"flist"]];
        
        _receiveButton.tag=11;
        
        _receiveButton.isActivity=NO;
        
        _receiveButton.isFridends=YES;
    //   [_receiveButton setBackgroundImage:[UIImage imageNamed:@"请求对话.png"] forState:UIControlStateNormal];
        
    
        [self  pushTheChatViewControllr];
        
        [self.tableView reloadData];
        
    }
}

-(void)pushTheChatViewController:(BanBu_RequestCell *)cell
{
    NSIndexPath *indexpath =[self.tableView indexPathForCell:cell];
    
    _profile=[[requestArr objectAtIndex:indexpath.row] retain];
    
    
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



-(void)pushTheChatViewControllr
{
    
    _profile=[[requestArr objectAtIndex:rowt] retain];
    
    
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
        
        self.delegate=chat;
        
        [_delegate RequestOneMsg:NSLocalizedString(@"requestFrom", nil) type:0 filePathExtension:nil From:@"mo"];
        
       // [self.navigationController pushViewController:chat animated:YES];
        
        [chat release];
    }

    


}






-(id)initWithNumber:(NSString *)number MutableDictionary:(NSMutableDictionary *)dic
{
    self=[super initWithStyle:UITableViewStylePlain];

    if(self)
    {
        //friendt->string=number;
     
          badage=number;
    
         _dictionary=[[[NSMutableDictionary alloc]initWithDictionary:dic] autorelease];
    
        requestArr=[[NSMutableArray alloc]initWithCapacity:10];
        
        self.tableView.delegate=self;
        
        self.tableView.dataSource=self;
        
         MyAppDataManager.chatuid=[_dictionary valueForKey:@"userid"];
        
       
       
        return self;
    }
    
    
    
    return nil;
}






- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.title=NSLocalizedString(@"requestUser", nil);
    
    self.tableView.backgroundColor = [UIColor colorWithRed:255.0/255 green:250.0/255 blue:240.0/255 alpha:1.0];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
   

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    // Return the number of rows in the section.
    

    return [requestArr count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell123";
    BanBu_RequestCell *cell = (BanBu_RequestCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if(cell==nil)
    {
    
        cell = [[[BanBu_RequestCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        cell.request=self;
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        UIView *aView =[[[UIView alloc] initWithFrame:cell.bounds] autorelease];
        aView.backgroundColor = [UIColor colorWithRed:2/256.0 green:120/256.0 blue:230/256.0 alpha:1.0];
        cell.multipleSelectionBackgroundView = [[[UIView alloc] initWithFrame:cell.bounds] autorelease];

    }
 
    NSDictionary *buddy = [requestArr objectAtIndex:indexPath.row];
    
    [cell setAvatar:[buddy valueForKey:@"uface"]];
    [cell setName:[MyAppDataManager IsMinGanWord:[MyAppDataManager theRevisedName:[buddy valueForKey:@"pname"] andUID:[buddy valueForKey:@"userid"]]]];
    [cell setAge:[buddy valueForKey:@"oldyears"] sex:[buddy valueForKey:@"gender"] ];
    [cell setDistance:[buddy valueForKey:@"dmeter"] timeAgo:[buddy valueForKey:@"dtime"]];
    [cell setLastInfo:[buddy valueForKey:@"ltime"]];
    
    [cell setSignature:[MyAppDataManager IsMinGanWord:[buddy valueForKey:@"saytext"]]];

    [cell setButtonName:@"FUCK" Isfriend:[self isFriend:buddy]];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{

    return 89;
    
}


-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    

}

-(void)reToAgreetoChange:(BanBu_RequestCell *)cell Button:(RequestButton *)sender
{
    
    _receiveButton=sender;
    
     NSIndexPath *indexpath =[self.tableView indexPathForCell:cell];
    
    rowt=indexpath.row;
    
    NSMutableDictionary *parDic = [NSMutableDictionary dictionary];
    [parDic setValue:[[requestArr objectAtIndex:indexpath.row] valueForKey:@"userid"] forKey:LinkTouID];
    [parDic setValue:@"friend" forKey:Action];
    
    [AppComManager getBanBuData:BanBu_Set_Friend_Link par:parDic delegate:self];
    self.navigationController.view.userInteractionEnabled = NO;

}

-(void)retoDeleteChange:(BanBu_RequestCell *)cell
{
      NSIndexPath *indexpath =[self.tableView indexPathForCell:cell];
    
    NSMutableDictionary *parDic = [NSMutableDictionary dictionary];
    [parDic setValue:[[requestArr objectAtIndex:indexpath.row] valueForKey:@"requestid"] forKey:@"idlist"];
    [AppComManager getBanBuData:BanBu_Delete_Request_ByIDList par:parDic delegate:self];
    self.navigationController.view.userInteractionEnabled = NO;
    [TKLoadingView showTkloadingAddedTo:self.view  title:NSLocalizedString(@"chuliNotice", nil) activityAnimated:YES];

    
    [requestArr removeObjectAtIndex:indexpath.row];
    [self.tableView beginUpdates];
    [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:indexpath.row inSection:indexpath.section]] withRowAnimation:UITableViewRowAnimationNone];
    [self.tableView endUpdates];
    
}

-(void)pushTheNextController:(BanBu_RequestCell *)cell
{
 
    NSIndexPath *indexpath =[self.tableView indexPathForCell:cell];
  
    NSDictionary *aFriend;
    
    aFriend = [requestArr objectAtIndex:indexpath.row];
    BanBu_PeopleProfileController *peopleFfofile = [[BanBu_PeopleProfileController alloc] initWithProfile:aFriend displayType:DisplayTypePeopleProfile];
    
    peopleFfofile.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:peopleFfofile animated:YES];
    [peopleFfofile release];
    

}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     [detailViewController release];
     */
}

@end
