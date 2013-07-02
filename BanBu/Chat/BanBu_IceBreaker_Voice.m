//
//  BanBu_IceBreaker_Voice.m
//  BanBu
//
//  Created by Jc Zhang on 12-12-12.
//
//

#import "BanBu_IceBreaker_Voice.h"
#import "BanBu_IceBreakerController.h"
#import "BanBu_icePicController.h"
#import "AppDataManager.h"
#import "BanBu_playVoice.h"
@interface BanBu_IceBreaker_Voice ()

-(void)popself1;

@end

// Handle depreciations and supress hide warnings
@interface UIApplication (DepreciationWarningSuppresion)
- (void)setStatusBarHidden:(BOOL)hidden animated:(BOOL)animated;
@end

@implementation BanBu_IceBreaker_Voice
@synthesize voiceString=_voiceString;
- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)dealloc{
    self.dataArray = nil;
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    if(!self.title){
        self.title = NSLocalizedString(@"ice_voiceTitle", nil);

    }
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor colorWithRed:255.0/255 green:250.0/255 blue:240.0/255 alpha:1.0];
//    UIButton *moreButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    moreButton.frame = CGRectMake(0, 0, 40, 30);
//    [moreButton addTarget:self action:@selector(moreContent) forControlEvents:UIControlEventTouchUpInside];
//    [moreButton setBackgroundImage:[[UIImage imageNamed:@"app_nav_btn_bg1.png"] stretchableImageWithLeftCapWidth:15.0 topCapHeight:15.0] forState:UIControlStateNormal];
//    [moreButton setImage:[UIImage imageNamed:@"btn_plus.png"] forState:UIControlStateNormal];
//    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:moreButton] autorelease];
    
//    UIButton *btn_return=[UIButton buttonWithType:UIButtonTypeCustom];
//    
//    [btn_return addTarget:self action:@selector(popself) forControlEvents:UIControlEventTouchUpInside];
//    
//    [btn_return setBackgroundImage:[[UIImage imageNamed:@"app_nav_back_bg1.png"] stretchableImageWithLeftCapWidth:15.0 topCapHeight:15.0] forState:UIControlStateNormal];
//    btn_return.frame=CGRectMake(0, 0, 48, 30);
//    [btn_return setTitleEdgeInsets:UIEdgeInsetsMake(3, 9, 2, 2)];
//    [btn_return setTitle:NSLocalizedString(@"returnButton", nil) forState:UIControlStateNormal];
//    btn_return.titleLabel.font = [UIFont systemFontOfSize:14];
//    UIBarButtonItem *bar_itemreturn=[[[UIBarButtonItem alloc] initWithCustomView:btn_return] autorelease];
//    self.navigationItem.leftBarButtonItem = bar_itemreturn;
    
    UIButton *reButton = [UIButton buttonWithType:UIButtonTypeCustom];
    reButton.frame = CGRectMake(0, 0, 40, 30);
    [reButton addTarget:self action:@selector(refreshContent) forControlEvents:UIControlEventTouchUpInside];
    [reButton setBackgroundImage:[[UIImage imageNamed:@"app_nav_btn_bg1.png"] stretchableImageWithLeftCapWidth:15.0 topCapHeight:15.0] forState:UIControlStateNormal];
    //    [addButton setBackgroundImage:[[UIImage imageNamed:@"app_nav_btn_bg2.png"] stretchableImageWithLeftCapWidth:15.0 topCapHeight:15.0] forState:UIControlStateHighlighted];
    [reButton setImage:[UIImage imageNamed:@"refresh.png"] forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:reButton] autorelease];
    
    NSArray * dataArr =  [[NSArray alloc]init];
    self.dataArray = dataArr;
    [dataArr release];
}
-(void)refreshContent{
    [self setRefreshing];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if(!self.dataArray.count){
        [self setRefreshing];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [AppComManager cancalHandlesForObject:self];
}

//点击更多

-(void)moreContent{
    UIActionSheet *conSheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:NSLocalizedString(@"cancelNotice", nil) destructiveButtonTitle:nil otherButtonTitles:NSLocalizedString(@"ice_actionSheetButtionTitle", nil),NSLocalizedString(@"ice_actionSheetButtionTitle1", nil),NSLocalizedString(@"ice_actionSheetButtionTitle2", nil),nil];
    [conSheet showInView:self.view];
    [conSheet release];
}

-(void)popself
{
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


-(void)popself1
{
    NSMutableDictionary *picDictionary=[[NSMutableDictionary alloc]init];
    
    
    [picDictionary setValue:_voiceString forKey:@"music"];
    
    
    [[NSNotificationCenter defaultCenter]postNotificationName:@"iceVoice" object:picDictionary];
    
    
    [picDictionary release];
    
    [self popself];
//    [[NSNotificationCenter defaultCenter]postNotificationName:@"popToChat" object:nil];

    
    
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    //    NSLog(@"%d",buttonIndex);

        if(buttonIndex == 0){
            BanBu_IceBreakerController *word = nil;
            for(UIViewController *vc in [self.navigationController viewControllers])
                if([vc isKindOfClass:[BanBu_IceBreakerController class]])
                {
                    word = (BanBu_IceBreakerController *)vc;
                    break;
                }
            if(word)
            {
                [self.navigationController popToViewController:word animated:NO];
            }
            else
            {
                word = [[BanBu_IceBreakerController alloc] init];
                [self.navigationController pushViewController:word animated:NO];
                [word release];
            }
        }
        if(buttonIndex == 1 ){
            NSMutableDictionary *parDic = [NSMutableDictionary dictionary];
            [parDic setValue:@"image" forKey:@"kind"];
            [AppComManager getBanBuData:BanBu_Get_Sayhi_Rand par:parDic delegate:self];
            NSLog(@"%@",parDic);
            [TKLoadingView showTkloadingAddedTo:self.navigationController.view title:NSLocalizedString(@"loadingNotice", nil) activityAnimated:YES];
        }
        if(buttonIndex == 2){
            [self setRefreshing];
        }
    if(buttonIndex ==3){
        
    }

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
    return self.dataArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 58;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *voiceCellIdentifier = @"voiceCell";
//    BanBu_IceCell *cell = (BanBu_IceCell *)[tableView dequeueReusableCellWithIdentifier:voiceCellIdentifier];
//    
//    if(cell == nil)
//    {
//        cell = [[[BanBu_IceCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:voiceCellIdentifier] autorelease];
////        cell.selectionStyle = UITableViewCellSelectionStyleNone;
//        
//    }
//    [cell setIconView:@"playvoice.png"];
//    if(self.dataArray.count){
//        [cell setSayTextLabel:[[self.dataArray objectAtIndex:indexPath.row] valueForKey:@"extend"]];
//    }
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:voiceCellIdentifier];
    
    if(cell == nil)
    {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:voiceCellIdentifier] autorelease];
//        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }
    cell.imageView.image = [UIImage imageNamed:@"playvoice.png"];
    cell.textLabel.font = [UIFont systemFontOfSize:16];
    cell.textLabel.text =  [[self.dataArray objectAtIndex:indexPath.row] valueForKey:@"extend"];
    
    return cell;
}



#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    self.voiceString = [[self.dataArray objectAtIndex:indexPath.row] valueForKey:@"saytext"];
    _selectedRow = indexPath.row;
    [AppComManager getBanBuMedia:self.voiceString delegate:self];
    
    [TKLoadingView showTkloadingAddedTo:self.navigationController.view title:NSLocalizedString(@"loadingNotice", nil) activityAnimated:YES];
    
}

-(void)loadingData{
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//    NSArray *typeArr = [NSArray arrayWithObjects:@"text",@"image",@"sound", nil];
//    NSMutableDictionary *parDic = [NSMutableDictionary dictionary];
//    [parDic setValue:[typeArr objectAtIndex:2] forKey:@"kind"];
    [AppComManager getBanBuData:BanBu_Get_Sayhi_Rand par:self.parDic delegate:self];
//    NSLog(@"%@",self.parDic);
    //    [TKLoadingView showTkloadingAddedTo:self.navigationController.view title:@"正在加载……" activityAnimated:YES];
    aBNC = (BanBu_NavigationController *)self.navigationController;
    aBNC.isLoading = YES;
}


#pragma mark - BanBuDelegate

- (void)banbuRequestDidFinished:(NSDictionary *)resDic error:(NSError *)error{
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;

//    NSLog(@"%@",resDic);

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
        if([[resDic valueForKey:@"ok"]boolValue]&&[[[[resDic valueForKey:@"list"] objectAtIndex:0] valueForKey:@"kind"] isEqual:@"s"]){
//            self.title = [NSString stringWithFormat:@"搜索-%@",[self.parDic valueForKey:@"keyword"]];
            NSArray *listArr = [[NSArray alloc]initWithArray:[resDic valueForKey:@"list"]];
            self.dataArray = listArr;
            [listArr release];
//            NSLog(@"%d",self.dataArray.count);
            
        }else if([[resDic valueForKey:@"ok"]boolValue]&&[[[[resDic valueForKey:@"list"] objectAtIndex:0] valueForKey:@"kind"] isEqual:@"i"]){
            BanBu_icePicController *image = nil;
            for(UIViewController *vc in [self.navigationController viewControllers])
                if([vc isKindOfClass:[BanBu_icePicController class]])
                {
                    image = (BanBu_icePicController *)vc;
                    break;
                }
            if(image)
            {
                [self.navigationController popToViewController:image animated:NO];
            }
            else
            {
                image = [[BanBu_icePicController alloc] initWithDictionary:resDic];
                [self.navigationController pushViewController:image animated:NO];
                [image release];
            }
        }
        else{
            [TKLoadingView showTkloadingAddedTo:self.navigationController.view title:[MyAppDataManager IsInternationalLanguage:[resDic valueForKey:@"error"]] activityAnimated:NO duration:1.0];
        }
    }
    [self.tableView reloadData];

    [self finishedLoading];
}


#pragma mark -banbudown

- (void)banbuDownloadRequest:(NSDictionary *)resDic didFinishedWithError:(NSError *)error{
//    NSLog(@"%@",resDic);
    [TKLoadingView dismissTkFromView:self.navigationController.view animated:NO afterShow:0.0];
    if([[resDic valueForKey:@"ok"]boolValue]){
//        NSData *aData = [NSData dataWithContentsOfFile:[AppComManager pathForMedia:self.voiceURL]];
//        _player = [[AVAudioPlayer alloc]initWithData:aData error:nil];
//        _player.delegate = self;
//        _player.volume = 1.0;
//        [_player prepareToPlay];
//        [_player play];
        BanBu_playVoice *aPlay = [[BanBu_playVoice alloc]init];
        aPlay.voiceURL = self.voiceString;
        aPlay.naviTitle =  [NSString stringWithFormat:@"%@_%@",[[self.dataArray objectAtIndex:_selectedRow] valueForKey:@"saybefore"],[[self.dataArray objectAtIndex:_selectedRow] valueForKey:@"extend"]];
        UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:aPlay];
        nc.navigationBar.barStyle =  UIBarStyleBlackTranslucent;
        
        aPlay.push=self;
        
        [self presentModalViewController:nc animated:YES];
        [nc release];
        [aPlay release];
        
    }else{
//        [TKLoadingView showTkloadingAddedTo:self.view title:@"下载失败" activityAnimated:NO duration:1.0];
    }
}

@end
