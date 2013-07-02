//
//  BanBu_IceBreakerController.m
//  BanBu
//
//  Created by mac on 12-8-18.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "BanBu_IceBreakerController.h"
#import "BanBu_ChatViewController.h"
#import "AppDataManager.h"
#import "TKLoadingView.h"
//#import "BanBu_IceCell.h"
#import "BanBu_IceTextCell.h"
#import "BanBu_IceBreaker_Voice.h"
#import "BanBu_icePicController.h"
#import "WXOpen.h"
@interface BanBu_IceBreakerController ()

@end

@implementation BanBu_IceBreakerController
@synthesize dataArray = _dataArray;



-(void)dealloc{
    [_dataArray release],_dataArray=nil;
    [super dealloc];
}
- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    UIButton *reButton = [UIButton buttonWithType:UIButtonTypeCustom];
    reButton.frame = CGRectMake(0, 0, 40, 30);
    [reButton addTarget:self action:@selector(refreshContent) forControlEvents:UIControlEventTouchUpInside];
    [reButton setBackgroundImage:[[UIImage imageNamed:@"app_nav_btn_bg1.png"] stretchableImageWithLeftCapWidth:15.0 topCapHeight:15.0] forState:UIControlStateNormal];
    //    [addButton setBackgroundImage:[[UIImage imageNamed:@"app_nav_btn_bg2.png"] stretchableImageWithLeftCapWidth:15.0 topCapHeight:15.0] forState:UIControlStateHighlighted];
    [reButton setImage:[UIImage imageNamed:@"refresh.png"] forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:reButton] autorelease];
//    UIButton *moreButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    moreButton.frame = CGRectMake(0, 0, 40, 30);
//    [moreButton addTarget:self action:@selector(moreContent) forControlEvents:UIControlEventTouchUpInside];
//    [moreButton setBackgroundImage:[[UIImage imageNamed:@"app_nav_btn_bg1.png"] stretchableImageWithLeftCapWidth:15.0 topCapHeight:15.0] forState:UIControlStateNormal];
//    [moreButton setImage:[UIImage imageNamed:@"btn_plus.png"] forState:UIControlStateNormal];
//    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:moreButton] autorelease];
    
//    self.view.backgroundColor = [UIColor redColor];
    if(!self.title){
        self.title = NSLocalizedString(@"ice_textTitle", nil);
    }
//    self.tableView.separatorColor=[UIColor colorWithRed:224.0/255 green:224.0/255 blue:224.0/255 alpha:1.0];
//    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor colorWithRed:255.0/255 green:250.0/255 blue:240.0/255 alpha:1.0];
  
}
-(void)refreshContent{
    [self setRefreshing];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [AppComManager cancalHandlesForObject:self];
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

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if(!self.dataArray.count){
        [self setRefreshing];
    }
}

//点击更多

-(void)moreContent{
//    UIActionSheet *conSheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"文字破冰语",@"图片破冰语",@"语音破冰语",nil];
//    [conSheet showInView:self.view];
//    [conSheet release];
}

-(void)popToChat{
    
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
    }else
    {
        BanBu_ChatViewController *chat=[[BanBu_ChatViewController alloc]init];
        
        [self.navigationController pushViewController:chat animated:YES];
        [chat release];
        
        
    }
    
}


-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{

    if(buttonIndex == 0){
        [[NSNotificationCenter defaultCenter]postNotificationName:@"iceWord" object:[[_dataArray objectAtIndex:selectedRow] valueForKey:@"saytext"]];
//        [[NSNotificationCenter defaultCenter]postNotificationName:@"popToChat" object:nil];
        [self popToChat];
//        [self.navigationController popViewControllerAnimated:YES];
    }
//    else if(buttonIndex == 1){
//        MyWXOpen.scene = WXSceneSession;
//        NSString *sendStr = [NSString stringWithFormat:@"%@\n%@",[[_dataArray objectAtIndex:selectedRow] valueForKey:@"saybefore"],[[_dataArray objectAtIndex:selectedRow] valueForKey:@"saytext"]];
//        [MyWXOpen sendTextContent:sendStr];
//    }else if(buttonIndex == 2){
//        MyWXOpen.scene = WXSceneTimeline;
//        NSString *sendStr = [NSString stringWithFormat:@"%@\n%@",[[_dataArray objectAtIndex:selectedRow] valueForKey:@"saybefore"],[[_dataArray objectAtIndex:selectedRow] valueForKey:@"saytext"]];
//        [MyWXOpen sendTextContent:sendStr];
//    }else if(buttonIndex ==3){
//        
//    }
//    if(buttonIndex!=3){
//        if(buttonIndex == 2){
//            BanBu_IceBreaker_Voice *aVoice = [[BanBu_IceBreaker_Voice alloc]init];
//            [self.navigationController pushViewController:aVoice animated:NO];
//            [aVoice release];
//        }else {
//            NSArray *typeArr = [NSArray arrayWithObjects:@"test",@"image",@"sound", nil];
//            NSMutableDictionary *parDic = [NSMutableDictionary dictionary];
//            [parDic setValue:[typeArr objectAtIndex:buttonIndex] forKey:@"kind"];
//            [AppComManager getBanBuData:BanBu_Get_Sayhi_Rand par:parDic delegate:self];
//            NSLog(@"%@",parDic);
//            [TKLoadingView showTkloadingAddedTo:self.navigationController.view title:@"正在加载……" activityAnimated:YES];
//            aBNC = (BanBu_NavigationController *)self.navigationController;
//            aBNC.isLoading = YES;
//        }
//    }

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
    return [_dataArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell==nil)
    {
        
        cell=[[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier]autorelease];
//        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        
    }
    // 去掉以前的Banbu_dynamiccell
    for(BanBu_IceTextCell *banbucell in cell.contentView.subviews)
    {
        if([banbucell isKindOfClass:[BanBu_IceTextCell class]])
        {
            [banbucell removeFromSuperview];
            break;
        }
    }
    BanBu_IceTextCell *mycell=[[BanBu_IceTextCell alloc]initWithFrame:CGRectZero];
    [cell.contentView addSubview:mycell];
    mycell.saytextStr = [[_dataArray objectAtIndex:indexPath.row] valueForKey:@"saytext"];
    if(![[[_dataArray objectAtIndex:indexPath.row] valueForKey:@"extend"] isEqualToString:@""]){
        mycell.extendStr = [[_dataArray objectAtIndex:indexPath.row] valueForKey:@"extend"];
    }
    cell.frame = mycell.frame;
    [mycell release];
      return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    UITableViewCell*cell =[self tableView:tableView cellForRowAtIndexPath:indexPath];
    
    return cell.frame.size.height;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    selectedRow = indexPath.row;
//    UIActionSheet *conSheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:NSLocalizedString(@"cancelNotice", nil) destructiveButtonTitle:nil otherButtonTitles:NSLocalizedString(@"ice_actionSheetButtionTitle", nil),NSLocalizedString(@"ice_actionSheetButtionTitle1", nil),NSLocalizedString(@"ice_actionSheetButtionTitle2", nil),nil];
    UIActionSheet *conSheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:NSLocalizedString(@"cancelNotice", nil) destructiveButtonTitle:nil otherButtonTitles:NSLocalizedString(@"ice_actionSheetButtionTitle", nil),nil];

    [conSheet showInView:self.view];
    [conSheet release];
    
    
    
}


-(void)loadingData{
//    NSArray *typeArr = [NSArray arrayWithObjects:@"text",@"image",@"sound", nil];
//    NSMutableDictionary *parDic = [NSMutableDictionary dictionary];
//    [parDic setValue:[typeArr objectAtIndex:0] forKey:@"kind"];
    
    [AppComManager getBanBuData:BanBu_Get_Sayhi_Rand par:self.parDic delegate:self];
//    [TKLoadingView showTkloadingAddedTo:self.navigationController.view title:@"正在加载……" activityAnimated:YES];
    aBNC = (BanBu_NavigationController *)self.navigationController;
    aBNC.isLoading = YES;
}

#pragma mark - BanBuDelegate

- (void)banbuRequestDidFinished:(NSDictionary *)resDic error:(NSError *)error{
    aBNC.isLoading = NO;
    [TKLoadingView dismissTkFromView:self.navigationController.view animated:YES afterShow:0.0];
    if(error){
        if([error.domain isEqualToString:BanBuDataformatError])
        {
            [TKLoadingView showTkloadingAddedTo:self.navigationController.view title:NSLocalizedString(@"data_error", nil) activityAnimated:NO duration:2.0];
        }
        else
        {
            [TKLoadingView showTkloadingAddedTo:self.navigationController.view title:NSLocalizedString(@"network_error", nil) activityAnimated:NO duration:2.0];
        }
        [self finishedLoading];

        return;
    }
    
    if([AppComManager respondsDic:resDic isFunctionData:BanBu_Get_Sayhi_Rand]){
        if([[resDic valueForKey:@"ok"]boolValue]&&[[[[resDic valueForKey:@"list"] objectAtIndex:0] valueForKey:@"kind"] isEqual:@"t"]){
//            self.title = [NSString stringWithFormat:@"搜索-%@",[self.parDic valueForKey:@"keyword"]];
            NSArray *listArr = [[NSArray alloc]initWithArray:[resDic valueForKey:@"list"]];
            
            
//            NSArray *pathArray=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDirectory, YES);
//            NSString *filePath=[[pathArray objectAtIndex:0] stringByAppendingPathComponent:@"IceLanguage.plist"];
//            [listArr writeToFile:filePath atomically:YES];
 
            self.dataArray = listArr;
            [listArr release];
            
            [self.tableView reloadData];
        }else if([[resDic valueForKey:@"ok"]boolValue]&&[[[[resDic valueForKey:@"list"] objectAtIndex:0] valueForKey:@"kind"] isEqual:@"i"])
        {
            
            BanBu_icePicController *picBanbu=[[BanBu_icePicController alloc]initWithDictionary:resDic];
            
            [self.navigationController pushViewController:picBanbu animated:NO];
            
            [picBanbu release];
            
            
            
        }else{
            [TKLoadingView showTkloadingAddedTo:self.navigationController.view title:[MyAppDataManager IsInternationalLanguage:[resDic valueForKey:@"error"]] activityAnimated:NO duration:1.0];
        }
    }
    [self finishedLoading];
}



@end
