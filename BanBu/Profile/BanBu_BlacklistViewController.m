//
//  BanBu_BlacklistViewController.m
//  BanBu
//
//  Created by jie zheng on 12-7-8.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "BanBu_BlacklistViewController.h"
#import "BanBu_ListCell.h"
#import "BanBu_DialogueCell.h"
#import "AppDataManager.h"
#import "AppCommunicationManager.h"
#import "TKLoadingView.h"
#import "UIImageView+WebCache.h"

@interface BanBu_BlacklistViewController ()

@end

@implementation BanBu_BlacklistViewController

@synthesize dataArr = _dataArr;

- (id)init
{
    self = [super initWithStyle:UITableViewStylePlain];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView.backgroundView = nil;
    self.tableView.backgroundColor = [UIColor colorWithRed:255.0/255 green:250.0/255 blue:240.0/255 alpha:1.0];    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.title = NSLocalizedString(@"blackTitle", nil);
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    CGFloat btnLen = [NSLocalizedString(@"unlockButton", nil) sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(150, 30)].width;
    unlock = [UIButton buttonWithType:UIButtonTypeCustom];
    unlock.frame=CGRectMake(0, 0, btnLen+20, 30);
    [unlock addTarget:self action:@selector(unlock:) forControlEvents:UIControlEventTouchUpInside];
    [unlock setBackgroundImage:[[UIImage imageNamed:@"app_nav_btn_bg1.png"] stretchableImageWithLeftCapWidth:15.0 topCapHeight:15.0] forState:UIControlStateNormal];
    [unlock setBackgroundImage:[[UIImage imageNamed:@"app_nav_btn_bg2.png"] stretchableImageWithLeftCapWidth:15.0 topCapHeight:15.0] forState:UIControlStateHighlighted];
    [unlock setTitleEdgeInsets:UIEdgeInsetsMake(3, 2, 2, 2)];
    [unlock setTitle:NSLocalizedString(@"unlockButton", nil) forState:UIControlStateNormal];
    unlock.titleLabel.font = [UIFont systemFontOfSize:14];
    UIBarButtonItem *unlockItem = [[[UIBarButtonItem alloc] initWithCustomView:unlock] autorelease];
    self.navigationItem.rightBarButtonItem = unlockItem;
    
    _dataArr = [[NSMutableArray alloc] init];
//    [_dataArr addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"aaaa",@"name",@"123",@"ID",nil]];
//    [_dataArr addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"bbbb",@"name",@"456",@"ID",nil]];
//    [_dataArr addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"cccc",@"name",@"789",@"ID",nil]];

}

- (void)unlock:(UIButton *)button
{
    if(_dataArr.count){
        [self.tableView setEditing:!self.tableView.editing animated:YES];
        [button setTitle:self.tableView.editing?NSLocalizedString(@"finishButton", nil):NSLocalizedString(@"unlockButton", nil) forState:UIControlStateNormal];
    }
    

}

- (void)viewDidUnload
{
    [super viewDidUnload];
//    self.dataArr = nil;
}

- (void)dealloc
{
//    [_dataArr release];
    [super dealloc];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if(!_dataArr.count){
        [self setRefreshing];
    }
}

-(void)viewWillDisappear:(BOOL)animated
{

    [super viewWillAppear:animated];
    [AppComManager cancalHandlesForObject:self];
    
    
}

-(void)loadingData{
    NSMutableDictionary *parDic = [NSMutableDictionary dictionary];
    [parDic setValue:@"x" forKey:@"linkkind"];
    [AppComManager getBanBuData:BanBu_Get_Friend_OfMy par:parDic delegate:self];
//    self.navigationController.view.userInteractionEnabled = NO;
//    //NSLog(@"%@",parDic);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_dataArr count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
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
    NSDictionary *aData = [_dataArr objectAtIndex:indexPath.row];
    NSLog(@"%@",[aData valueForKey:@"userid"]);

    [cell setAvatar:[aData valueForKey:@"uface"]];
    [cell setName:[aData valueForKey:@"pname"]];
    [cell setAge:[aData valueForKey:@"oldyears"] sex: [aData valueForKey:@"gender"]];
    [cell setDistance:[MyAppDataManager IsInternationalLanguage:[aData valueForKey:@"dmeter"]] timeAgo:[MyAppDataManager IsInternationalLanguage:[aData valueForKey:@"dtime"]]];
//    static NSString *CellIdentifier = @"Cell";
//    BanBu_DialogueCell *cell = (BanBu_DialogueCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
//    if(cell == nil)
//    {
//        cell = [[[BanBu_DialogueCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
//        
//    }
//    NSDictionary *aData = [_dataArr objectAtIndex:indexPath.row];
//    [cell setAvatar:[aData valueForKey:@"uface"]];
//    [cell setName:[aData valueForKey:@"pname"]];
//    [cell setAge:[aData valueForKey:@"oldyears"] sex:[[aData valueForKey:@"gender"] isEqualToString:@"m"]];
//    
//    
//    [cell setLastInfo:[NSString stringWithFormat:@"%@ | %@",[aData valueForKey:@"dmeter"],[aData valueForKey:@"ltime"]]];
//    [cell setlastDialogue:[aData valueForKey:@"sayme"]];
//    [cell setStatus:DialogueStatusNoneType num:nil];
    return cell;
}


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (BOOL)tableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{ 
    return NSLocalizedString(@"unlockButton", nil); 
}
-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
       
        NSMutableDictionary *parDic = [NSMutableDictionary dictionary];
        [parDic setValue:[[_dataArr objectAtIndex:indexPath.row] valueForKey:@"userid"] forKey:LinkTouID];
        [parDic setValue:@"unlink" forKey:Action];
        [AppComManager getBanBuData:BanBu_Set_Friend_Link par:parDic delegate:self];
//    //NSLog(@"%@",parDic);
        
        
        
        [_dataArr removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationTop];
        [self.tableView setEditing:!self.tableView.editing animated:YES];
        [unlock setTitle:self.tableView.editing?NSLocalizedString(@"finishButton", nil):NSLocalizedString(@"unlockButton", nil) forState:UIControlStateNormal];
        //        tempIndexPath = indexPath;

    }
   
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

#pragma mark - BanBuDelegate

- (void)banbuRequestDidFinished:(NSDictionary *)resDic error:(NSError *)error{
    
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
    if([AppComManager respondsDic:resDic isFunctionData:BanBu_Get_Friend_OfMy]){
        if([[resDic valueForKey:@"ok"]boolValue]){
            if(_isLoadingRefresh){
                [_dataArr removeAllObjects];
            }
            [_dataArr addObjectsFromArray:[resDic valueForKey:@"list"]];
            
        }else{
            if([[resDic valueForKey:@"error"] isEqualToString:@"__loginidinvalid__"]){
                [self.navigationController popToRootViewControllerAnimated:NO];
                
            }
            [TKLoadingView showTkloadingAddedTo:self.view title:[MyAppDataManager IsInternationalLanguage:[resDic valueForKey:@"error"]] activityAnimated:NO duration:1.0];
        }

    }
    if([AppComManager respondsDic:resDic isFunctionData:BanBu_Set_Friend_Link]){
        NSMutableDictionary *uidDic = [NSMutableDictionary dictionaryWithDictionary:[UserDefaults valueForKey:MyAppDataManager.useruid]];
        [uidDic setValue:[resDic valueForKey:@"friendlist"] forKey:FriendShip];
        [UserDefaults setValue:uidDic forKey:MyAppDataManager.useruid];
        [UserDefaults synchronize];
        if(![[resDic valueForKey:@"ok"]boolValue]){
            if([[resDic valueForKey:@"error"] isEqualToString:@"__loginidinvalid__"]){
                [self.navigationController popToRootViewControllerAnimated:NO];
                
            }
        }
//        //NSLog(@"%@",[resDic valueForKey:@"friendlist"]);
    }
  
    [self.tableView reloadData];
    [self finishedLoading];
    
    

}












@end
