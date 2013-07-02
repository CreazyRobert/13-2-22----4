//
//  BanBu_icePicController.m
//  BanBu
//
//  Created by apple on 12-12-11.
//
//

#import "BanBu_icePicController.h"
#import "AppCommunicationManager.h"
#import "ImageViewCell.h"
#import "AppDataManager.h"
#import "TKLoadingView.h"
// 这是点击放大的图片
#import "MWPhotoBrowser.h"
#import <QuartzCore/QuartzCore.h>
#import "BanBu_IceBreaker_Voice.h"
#import "BanBu_IceBreakerController.h"
#import "SDWebImageManager.h"
#import "WXOpen.h"
#import "BanBu_AppDelegate.h"
#import "MWPhotoBrowser.h"
#import "ALAssetsLibrary+CustomPhotoAlbum.h"

@interface BanBu_icePicController (){
    
    ALAssetsLibrary *_assetLibrary;
}

@end

int selectedIndexPath = -1;
@implementation BanBu_icePicController
@synthesize receiveDictionary=_receiveDictionary;
@synthesize showPhotoes=_showPhotoes;
@synthesize urlArray=_urlArray;
@synthesize delegate = _delegate;


-(void)sendMessageTochat
{
    UIActionSheet *conSheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:NSLocalizedString(@"cancelNotice", nil) destructiveButtonTitle:nil otherButtonTitles:NSLocalizedString(@"ice_actionSheetButtionTitle", nil),NSLocalizedString(@"ice_actionSheetButtionTitle1", nil),NSLocalizedString(@"ice_actionSheetButtionTitle2", nil),nil];
    [conSheet showInView:self.view];
    [conSheet release];
}
- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        
        self.title=NSLocalizedString(@"ice_picTitle", nil);
//        self.title= @"图片破冰语";
        
        self.tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
        
        
    }
    return self;
}


-(id)initWithDictionary:(NSDictionary *)receiveDictionary
{
    
    self=[super initWithStyle:UITableViewStylePlain];
    
    if(self)
    {
        self.title=NSLocalizedString(@"ice_picTitle", nil);
         
        self.tableView.separatorStyle=UITableViewCellSeparatorStyleNone;

        
        _receiveDictionary=[[NSMutableDictionary alloc]initWithDictionary:receiveDictionary];
        
        _showPhotoes=[[NSMutableArray alloc]initWithCapacity:1];
        
        _urlArray=[[NSMutableArray alloc]initWithCapacity:1];
        
        _arrayData=[[NSMutableArray alloc]initWithArray:[_receiveDictionary valueForKey:@"list"]];
        
        
        waterFlow=[[WaterFlowView alloc]initWithFrame:CGRectMake(0, 0, 320, __MainScreen_Height-44)];
        
        [waterFlow retain];
        
        waterFlow.delegatee=self;
        
        waterFlow.datasouce=self;
        
        [self.view addSubview:waterFlow];
        
        [waterFlow release];
        
        [waterFlow reloadData];
    }
    
    return self;
}


//向网络请求数据 获取图片的位置和url


-(void)loadingData
{
    [super loadingData];
    
    //    NSLog(@"is it the refresh");
    
    //    NSMutableDictionary *parDic = [NSMutableDictionary dictionary];
    //    [parDic setValue:@"image" forKey:@"kind"];
    [AppComManager getBanBuData:BanBu_Get_Sayhi_Rand par:self.parDic delegate:self];
    
    
    
    
}
-(void)finishedLoading
{
    [super finishedLoading];
    
    //    NSLog(@"well i will be");
    
    
}

-(void)banbuRequestDidFinished:(NSDictionary *)resDic error:(NSError *)error
{
    NSString *str=@"error";
    BOOL t1=NO;
    
    for(NSString *t in [resDic allKeys])
    {
        if ([t isEqual:str]) {
            
            t1=YES;
            
        }
        
    }
    
    if(t1)
    {
        [TKLoadingView showTkloadingAddedTo:self.navigationController.view title:@"failed" activityAnimated:NO duration:1.5];
        
        [self performSelector:@selector(finishedLoading)];
        
    }else
    {
        
        
        [_arrayData removeAllObjects];
        
        [_arrayData addObjectsFromArray:[resDic objectForKey:@"list"]];
        
        [waterFlow reloadData];
        
        [self performSelector:@selector(finishedLoading) withObject:nil afterDelay:2.0f];
        
    }

}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.view setBackgroundColor:[UIColor colorWithRed:255.0/255 green:250.0/255 blue:240.0/255 alpha:1.0]];
//    BanBu_AppDelegate *de = (BanBu_AppDelegate *)[UIApplication sharedApplication].delegate;
//    if(de.isTuYa == YES)
//    {
//        UIButton *btn_return=[UIButton buttonWithType:UIButtonTypeCustom];
//        
//        [btn_return setBackgroundImage:[[UIImage imageNamed:@"app_nav_back_bg1.png"] stretchableImageWithLeftCapWidth:15.0 topCapHeight:15.0] forState:UIControlStateNormal];
//        [btn_return setBackgroundImage:[[UIImage imageNamed:@"app_nav_back_bg2.png"] stretchableImageWithLeftCapWidth:15.0 topCapHeight:15.0] forState:UIControlStateHighlighted];
//        btn_return.frame=CGRectMake(0, 0, 50, 30);
//        [btn_return setTitleEdgeInsets:UIEdgeInsetsMake(3, 9, 2, 2)];
//        [btn_return setTitle:@"返回" forState:UIControlStateNormal];
//        [btn_return addTarget:self action:@selector(comeBack) forControlEvents:UIControlEventTouchUpInside];
//        btn_return.titleLabel.font = [UIFont systemFontOfSize:14];
//        UIBarButtonItem *bar_itemreturn=[[[UIBarButtonItem alloc] initWithCustomView:btn_return] autorelease];
//        
//        self.navigationItem.leftBarButtonItem=bar_itemreturn;
//    }
    UIButton *reButton = [UIButton buttonWithType:UIButtonTypeCustom];
    reButton.frame = CGRectMake(0, 0, 40, 30);
    [reButton addTarget:self action:@selector(refreshContent) forControlEvents:UIControlEventTouchUpInside];
    [reButton setBackgroundImage:[[UIImage imageNamed:@"app_nav_btn_bg1.png"] stretchableImageWithLeftCapWidth:15.0 topCapHeight:15.0] forState:UIControlStateNormal];
    
    [reButton setImage:[UIImage imageNamed:@"refresh.png"] forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:reButton] autorelease];
//
//    //    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadUnderlying) name:@"updataIndex" object:nil];
//    
//    
//    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [AppComManager cancalHandlesForObject:self];
}

-(void)comeBack
{
    [self dismissModalViewControllerAnimated:YES];
}
-(void)refreshContent{
    [self setRefreshing];
}


- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo{
    //    NSLog(@"%@",error);
    [TKLoadingView dismissTkFromView:self.navigationController.view  animated:NO afterShow:0.0];
    if(error){
        if([error code] == -3310){
            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"此应用没有权限来访问您的照片或视频" message:@"您可以在\"隐私设置\"中启用访问" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alertView show];
            [alertView release];
            return;
        }
        [TKLoadingView showTkloadingAddedTo:self.navigationController.view title:@"\n  保  存  失  败  \n\n" activityAnimated:NO duration:2.0];
        
        
    }else{
        [TKLoadingView showTkloadingAddedTo:self.navigationController.view title:@"\n  保  存  成  功  \n\n" activityAnimated:NO duration:2.0];
        
    }
}



#pragma mark WaterFlowViewDataSource

-(NSInteger)numberOfColumsInWaterFlowView:(WaterFlowView *)waterFlowView
{
    
    return 3;
    
}

- (NSInteger)numberOfAllWaterFlowView:(WaterFlowView *)waterFlowView{
    
    
    return [_arrayData count];
}

- (UIView *)waterFlowView:(WaterFlowView *)waterFlowView cellForRowAtIndexPath:(IndexPath *)indexPath{
    
    ImageViewCell *view = [[ImageViewCell alloc] initWithIdentifier:@"love"];
    
    return [view autorelease];
}


- (CGFloat)waterFlowView:(WaterFlowView *)waterFlowView heightForRowAtIndexPath:(IndexPath *)indexPath
{
    int arrIndex = indexPath.row * waterFlowView.cloumn + indexPath.cloumn;
    
    
    NSDictionary *dict = [_arrayData objectAtIndex:arrIndex];
    
    
    
    waterFlow.cellWidth = [[dict valueForKey:@"extend"] floatValue];
    
    
    
    return waterFlow.cellWidth;
    
    
}
-(void)waterFlowView:(WaterFlowView *)waterFlowView relayoutCellSubview:(UIView *)view withIndexPath:(IndexPath *)indexPath
{
    
    int arrIndex = indexPath.row * waterFlowView.cloumn + indexPath.cloumn;
    //    NSLog(@"%d---%d---%d",indexPath.row,waterFlowView.cloumn,indexPath.cloumn);
    NSDictionary *object = [_arrayData objectAtIndex:arrIndex];
    
    NSString *url=[object valueForKey:@"saytext"];
    
    
    ImageViewCell *imageViewCell = (ImageViewCell *)view;
    imageViewCell.indexpath = indexPath;
    imageViewCell.columnCount = waterFlowView.cloumn;
    [imageViewCell relayoutViews];
    
    [imageViewCell setImagewithString:url];
    
}
/**/

//-(void)loadUnderlying:(NSNotification *)notifi{
//
//    int arrIndex = [[notifi object] intValue];
//    NSDictionary *object = [_arrayData objectAtIndex:arrIndex];
//
//    thumbImageStr =  [object valueForKey:@"saytext"] ;
//    saybeforString =  [object valueForKey:@"saybefore"];
//}


/**/

-(void)waterFlowView:(WaterFlowView *)waterFlowView didSelectRowAtIndexPath:(IndexPath *)indexPath
{
//    BanBu_AppDelegate *de = (BanBu_AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    int arrIndex = indexPath.row * waterFlowView.cloumn + indexPath.cloumn;
    selectedIndexPath = arrIndex;
    
    NSDictionary *object = [NSDictionary dictionaryWithDictionary:[_arrayData objectAtIndex:arrIndex]];
    
    //    NSLog(@"%@",object);
    // 取到的图片的网址是
    
    NSString *url=[object valueForKey:@"saytext"];
    suffixArr = [[NSArray alloc]initWithArray:[url componentsSeparatedByString:@"."]];
    self.hints = nil;
    self.hints = [object valueForKey:@"hints"];
    
    thumbImageStr = url;
    
    [_urlArray removeAllObjects];
    [_urlArray addObject:[url stringByAppendingString:[NSString stringWithFormat:@".%@",[suffixArr lastObject]]]];
        SCGIFViewController *aSC = [[SCGIFViewController alloc]init];
    aSC.isBreaker = YES;
        aSC.delegate = self;
        aSC.arrayData = _arrayData;
        aSC.indexPathSelected = selectedIndexPath;
        
        [self.navigationController pushViewController:aSC animated:YES];
        
        [aSC release];
//    }
//    else{
//        [self.delegate placeImageToTuya:thumbImageStr];
//        
//        [self dismissModalViewControllerAnimated:YES];
//        
//    }
    
    
}

// 失败的方法
-(void)removeTk
{
    
    [TKLoadingView dismissTkFromView:self.navigationController.view animated:NO afterShow:0.0];
    
}




// 成功的方法
//-(void)seeBigPic
//{
//    self.navigationController.view.userInteractionEnabled = YES;
//
//    [TKLoadingView dismissTkFromView:self.navigationController.view animated:YES afterShow:.3];
//
//    SCGIFViewController *aSC = [[SCGIFViewController alloc]init];
//    aSC.delegate = self;
//    aSC.arrayData = _arrayData;
//    aSC.indexPathSelected = selectedIndexPath;
//
////    aSC.gifString = [_urlArray objectAtIndex:0];
////    NSLog(@"%@",[_urlArray objectAtIndex:0]);
//
////    aSC.hints     = self.hints;
//    [self.navigationController pushViewController:aSC animated:YES];
//
//    [aSC release];
//
//}




// 点击放大的代理函数

//- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser {
//    return [_showPhotoes count];
//}

//- (MWPhoto *)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index {
//    if (index < _showPhotoes.count)
//        return [_showPhotoes objectAtIndex:index];
//    return nil;
//
//}








- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    // Return the number of sections.
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    // Return the number of rows in the section.
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
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
//-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
//    //    NSLog(@"%d",buttonIndex);
//    [self dismissModalViewControllerAnimated:NO];
//    if(buttonIndex == 0){
//        // 这是url
//        
//        NSString *imageString=[_urlArray objectAtIndex:0];
//        
//        //   UIImage *image=[MyAppDataManager imageForImageUrlStr:[_urlArray objectAtIndex:0]];
//        //
//        //    NSData *data=UIImageJPEGRepresentation(image, 1.0);
//        //
//        
//        NSMutableDictionary *picDictionary=[[[NSMutableDictionary alloc]init] autorelease];
//        
//        // [picDictionary setValue:data forKey:@"image"];
//        
//        // 发送图片
//        
//        [picDictionary setValue:imageString forKey:@"image"];
//        [picDictionary setValue:[suffixArr lastObject] forKey:@"filetype"];
//        
//        NSLog(@"%@",picDictionary);
//        [[NSNotificationCenter defaultCenter]postNotificationName:@"icePic" object:picDictionary];
//        
//        [[NSNotificationCenter defaultCenter]postNotificationName:@"popToChat" object:nil];
//        
//        
//        
//    }
//    else if(buttonIndex == 1){
////        [TKLoadingView showTkloadingAddedTo:self.navigationController.view title:@"正在保存..." activityAnimated:YES];
//        
//        UIImage *aImage = [UIImage imageWithData:[MyAppDataManager imageDataForImageUrlStr:[_urlArray objectAtIndex:0]]];
//        
//        UIImageWriteToSavedPhotosAlbum(aImage, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
//        
//    }
//    else if(buttonIndex == 2){
//        //        NSLog(@"%@,%@",thumbImageStr,UIImageJPEGRepresentation([MyAppDataManager imageForImageUrlStr:thumbImageStr], 1.0));
//        MyWXOpen.scene = WXSceneSession;
//        if([[suffixArr lastObject] isEqualToString:@"gif"]){
//            [MyWXOpen sendGifContentWithImageData:[MyAppDataManager imageDataForImageUrlStr:[_urlArray objectAtIndex:0]] andThumbImage:[[SDWebImageManager sharedManager] imageWithURL:[NSURL URLWithString:thumbImageStr]]];
//        }else{
//            [MyWXOpen sendImageContentWithImageData:[MyAppDataManager imageDataForImageUrlStr:[_urlArray objectAtIndex:0]] andThumbImage:[[SDWebImageManager sharedManager] imageWithURL:[NSURL URLWithString:thumbImageStr]]];
//            
//        }
//        
//    }else if(buttonIndex ==3){
//        MyWXOpen.scene = WXSceneTimeline;
//        [MyWXOpen sendImageContentWithImageData:UIImageJPEGRepresentation([MyAppDataManager imageForImageUrlStr:[_urlArray objectAtIndex:0]], 1.0) andThumbImage:[[SDWebImageManager sharedManager] imageWithURL:[NSURL URLWithString:thumbImageStr]]];
//        
//    }
//    
//    /*
//     if(buttonIndex == 0){
//     BanBu_IceBreakerController *word = nil;
//     for(UIViewController *vc in [self.navigationController viewControllers])
//     if([vc isKindOfClass:[BanBu_IceBreakerController class]])
//     {
//     word = (BanBu_IceBreakerController *)vc;
//     break;
//     }
//     if(word)
//     {
//     [self.navigationController popToViewController:word animated:NO];
//     }
//     else
//     {
//     word = [[BanBu_IceBreakerController alloc] init];
//     [self.navigationController pushViewController:word animated:NO];
//     [word release];
//     }
//     }
//     if(buttonIndex == 1){
//     [self setRefreshing];
//     }
//     if(buttonIndex == 2 ){
//     BanBu_IceBreaker_Voice *voice = nil;
//     for(UIViewController *vc in [self.navigationController viewControllers])
//     if([vc isKindOfClass:[BanBu_IceBreaker_Voice class]])
//     {
//     voice = (BanBu_IceBreaker_Voice *)vc;
//     break;
//     }
//     if(voice)
//     {
//     [self.navigationController popToViewController:voice animated:NO];
//     }
//     else
//     {
//     voice = [[BanBu_IceBreaker_Voice alloc] init];
//     [self.navigationController pushViewController:voice animated:NO];
//     [voice release];
//     }
//     }
//     */
//}


-(void)dealloc
{
    //    [thumbImageStr release];
    //    [saybeforString release];
    [suffixArr release];
    [_receiveDictionary release];
    self.arrayData = nil;
    //    [_arrayData release],_arrayData = nil;
    [_showPhotoes release];
    [super dealloc];
}


@end
