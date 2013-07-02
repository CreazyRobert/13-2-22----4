//
//  SCGIFViewController.m
//  BanBu
//
//  Created by Jc Zhang on 13-1-5.
//
//

#import "SCGIFViewController.h"
#import "SCGIFImageView.h"
#import "AppDataManager.h"
#import "AppCommunicationManager.h"
#import "BanBu_HelpViewController.h"
#import "BanBu_AppDelegate.h"
#import "MRZoomScrollView.h"
#import "SDImageCache.h"
#import "WXOpen.h"
#import "TKLoadingView.h"
#import "ShareViewController.h"
@interface SCGIFViewController ()

@end

@implementation SCGIFViewController
@synthesize isBreaker;
int currentPage = -1;

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
    if(!isBreaker)
    {
    self.view.backgroundColor = [UIColor blackColor];
    UIBarButtonItem *backButton = [[[UIBarButtonItem alloc]initWithTitle:NSLocalizedString(@"returnButton", nil) style:UIBarButtonItemStylePlain target:self action:@selector(backAction)]autorelease];
    self.navigationItem.leftBarButtonItem = backButton;
    
    UIBarButtonItem *sendButton = [[[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"sendReply", nil) style:UIBarButtonItemStylePlain target:self action:@selector(sendButtonPressed:)] autorelease];
  
    self.navigationItem.rightBarButtonItem = sendButton;
    
    NSString* filePath = [AppComManager pathForMedia:self.gifString];
    SCGIFImageView* gifImageView = [[[SCGIFImageView alloc] initWithGIFFile:filePath] autorelease];
    gifImageView.frame = CGRectMake(0, 0, gifImageView.image.size.width, gifImageView.image.size.height);
    gifImageView.center = self.view.center;
    [self.view addSubview:gifImageView];
    }
    else
    {
        self.view.multipleTouchEnabled = YES;
        //
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(refreshUI)
                                                     name: @"refreshUIImage"
                                                   object: nil];
        // Do any additional setup after loading the view.
        self.title = NSLocalizedString(@"scanPic", nil);
        self.view.backgroundColor = [UIColor whiteColor];
        
        
        
        UIButton *listButton = [UIButton buttonWithType:UIButtonTypeCustom];
        listButton.frame = CGRectMake(0, 0, 50, 30);
        listButton.titleLabel.font = [UIFont systemFontOfSize:14];
        [listButton setBackgroundImage:[[UIImage imageNamed:@"app_nav_btn_bg1.png"] stretchableImageWithLeftCapWidth:15.0 topCapHeight:15.0] forState:UIControlStateNormal];
        [listButton setBackgroundImage:[[UIImage imageNamed:@"app_nav_btn_bg2.png"] stretchableImageWithLeftCapWidth:15.0 topCapHeight:15.0] forState:UIControlStateHighlighted];
        [listButton setTitle:NSLocalizedString(@"sendReply", nil) forState:UIControlStateNormal];
        [listButton addTarget:self action:@selector(sendButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *rightItem = [[[UIBarButtonItem alloc] initWithCustomView:listButton] autorelease];
        self.navigationItem.rightBarButtonItem = rightItem;
        
        UIScrollView *imageScroll = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, 320, __MainScreen_Height-44)];
        imageScroll.contentSize = CGSizeMake(320*_arrayData.count, __MainScreen_Height-44);
        imageScroll.contentOffset = CGPointMake(320*self.indexPathSelected, 0);
        imageScroll.pagingEnabled = YES;
        imageScroll.tag = 3456;
        imageScroll.backgroundColor = [UIColor clearColor];
        imageScroll.delegate = self;
        imageScroll.showsHorizontalScrollIndicator = NO;
        imageScroll.showsVerticalScrollIndicator = NO;
        imageScroll.decelerationRate = UIScrollViewDecelerationRateFast;
        //    imageScroll.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [self.view addSubview:imageScroll];
        
        currentPage = self.indexPathSelected;
        [imageScroll release];
        
        
        for(int i = 0;i<_arrayData.count;i++)
        {
            MRZoomScrollView *_zoomScrollView= [[MRZoomScrollView alloc]init];
            _zoomScrollView.frame = CGRectMake(i*320, 0, 320, __MainScreen_Height-44);
            _zoomScrollView.showsVerticalScrollIndicator = NO;
            _zoomScrollView.showsHorizontalScrollIndicator = NO;
            _zoomScrollView.multipleTouchEnabled = YES;
            _zoomScrollView.contentSize = CGSizeMake(320, __MainScreen_Height-44-40);
            _zoomScrollView.tag = (i+1)*10;
            _zoomScrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
            
            //        _zoomScrollView.backgroundColor = [UIColor redColor];
            
            [imageScroll addSubview:_zoomScrollView];
            _zoomScrollView.backgroundColor = [UIColor clearColor];
            [_zoomScrollView release];
            
            //        [gifImageView release];
            
        }
        NSDictionary *object = [NSDictionary dictionaryWithDictionary:[self.arrayData objectAtIndex:self.indexPathSelected]];
        NSString *url=[object valueForKey:@"saytext"];
        self.hints = [object valueForKey:@"hints"];
        MRZoomScrollView *imageView1 = (MRZoomScrollView *)[imageScroll viewWithTag:(self.indexPathSelected+1)*10];
        imageView1.isReady = NO;
        activity = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        activity.frame = CGRectMake(160-20, (__MainScreen_Height-44)/2,40, 40);
        activity.center = CGPointMake(160,((float)__MainScreen_Height)/2);//
        //    activity.center =CGPointMake(160, (__MainScreen_Height-90-44)/2+45);
        activity.hidesWhenStopped = YES;
        activity.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin |
        UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleRightMargin;
        [self.view addSubview:activity];
        [activity release];
        [activity startAnimating];
        if([url hasSuffix:@".gif"])
        {
            imageView1.userInteractionEnabled = NO;
        }
        
        
        [(SCGIFImageView *)imageView1.imageView initWithURL:url];
        //    isLoading = YES;
        NSLog(@"%@",url);
        
        
        
        
        //底部长条buttom
        
//        UIButton *btu1 = [UIButton buttonWithType:UIButtonTypeCustom];
//        btu1.hidden = YES;
//        btu1.titleLabel.numberOfLines = 0;
//        if(self.hints){
//            btu1.hidden = NO;
//            
//        }
//        btu1.tag = 52152;
//        [btu1 setTitle:[NSString stringWithFormat:@"   %@",self.hints] forState:UIControlStateNormal];
//        [btu1 setTitleColor:[UIColor darkTextColor] forState:UIControlStateNormal];
//        btu1.contentHorizontalAlignment=UIControlContentHorizontalAlignmentLeft;
//        [btu1 setFrame:CGRectMake(5,5, 310, 45)];
//        [self.view addSubview:btu1];
        
        UIButton *btu2 = [UIButton buttonWithType:UIButtonTypeCustom];
        btu2.tag = 52152;
//        NSLog(@"%@",object);
//        [btu2 setTitle:self.hints forState:UIControlStateNormal];
        btu2.titleLabel.font = [UIFont systemFontOfSize:14.0];
        [btu2 setBackgroundColor:[UIColor clearColor]];
//        btu2.
        [btu2 setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        btu2.contentHorizontalAlignment=UIControlContentHorizontalAlignmentLeft;
        [btu2.layer setBorderColor:[[UIColor grayColor] CGColor]];
//        [btu2.layer setBorderWidth:2.0];
        
//        [btu2 addTarget:self action:@selector(callHelperWeb) forControlEvents:UIControlEventTouchUpInside];
        
        [btu2 setFrame:CGRectMake(0,0, 320, 45)];
        [self.view addSubview:btu2];
        UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
        leftButton.frame = CGRectMake(10, (__MainScreen_Height-44)/2-23, 31, 46);
        leftButton.alpha = 0.4;
        if(self.indexPathSelected == 0)
        {
            leftButton.hidden = YES;
        }
        leftButton.tag = 135;
        [leftButton setBackgroundImage:[UIImage imageNamed:@"向左滚动.png"]  forState:UIControlStateNormal];
        [leftButton addTarget:self action:@selector(swapToNextPage:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:leftButton];
        UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
        rightButton.frame = CGRectMake(280, (__MainScreen_Height-44)/2-23, 31, 46);
        rightButton.alpha = 0.4;
        rightButton.tag = 246;
        if(self.indexPathSelected == _arrayData.count-1)
        {
            rightButton.hidden = YES;
        }
        [rightButton setBackgroundImage:[UIImage imageNamed:@"向右滚动.png"]  forState:UIControlStateNormal];
        [rightButton addTarget:self action:@selector(swapToNextPage:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:rightButton];
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)backAction{
    
    [self dismissModalViewControllerAnimated:YES];
}

-(void)sendButtonPressed:(id)sender
{
//    if([_delegate respondsToSelector:@selector(sendMessageTochat)])
//    {
//        [_delegate sendMessageTochat];
//        
////        [self dismissModalViewControllerAnimated:NO];
//        
//    }
    if(!activity.isAnimating)
    [self sendMessageTochat];
}


-(void)sendMessageTochat
{
//    UIActionSheet *conSheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:NSLocalizedString(@"cancelNotice", nil) destructiveButtonTitle:nil otherButtonTitles:NSLocalizedString(@"ice_actionSheetButtionTitle", nil),NSLocalizedString(@"ice_actionSheetButtionTitle1", nil),NSLocalizedString(@"ice_actionSheetButtionTitle2", nil),nil];
    
    UIActionSheet *conSheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:NSLocalizedString(@"cancelNotice", nil) destructiveButtonTitle:nil otherButtonTitles:NSLocalizedString(@"ice_actionSheetButtionTitle", nil),nil];

    [conSheet showInView:self.view];
    [conSheet release];
}
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    //    NSLog(@"%d",buttonIndex);
    [self dismissModalViewControllerAnimated:NO];
    
    
    NSDictionary *object = [NSDictionary dictionaryWithDictionary:[self.arrayData objectAtIndex:currentPage]];
    NSString *thumbImageStr = [object valueForKey:@"saytext"];
//    NSString *saybeforString = [object valueForKey:@"saybefor"];
//    NSLog(@"%@ %@",thumbImageStr,saybeforString);
    NSString *imageString=thumbImageStr;
    NSMutableDictionary *picDictionary=[[[NSMutableDictionary alloc]init] autorelease];
    // 发送图片
    
    [picDictionary setValue:[self getBigPicUrl:imageString] forKey:@"image"];
    NSArray *suffixArr = [[NSArray alloc]initWithArray:[imageString componentsSeparatedByString:@"."]];
    [picDictionary setValue:[suffixArr lastObject] forKey:@"filetype"];
    
    NSLog(@"%@",picDictionary);

    if(buttonIndex == 0){
        // 这是url
        
            [[NSNotificationCenter defaultCenter]postNotificationName:@"icePic" object:picDictionary];
        
        [[NSNotificationCenter defaultCenter]postNotificationName:@"popToChat" object:nil];
        
        
        
    }
//    else if(buttonIndex == 1){
//        [TKLoadingView showTkloadingAddedTo:self.navigationController.view title:@"正在保存..." activityAnimated:YES];
        
//        UIImage *aImage = [UIImage imageWithData:[MyAppDataManager imageDataForImageUrlStr:[[self getBigPicUrl:thumbImageStr] objectAtIndex:0]]];
//
//        UIImageWriteToSavedPhotosAlbum(aImage, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
        
//    }
//    else if(buttonIndex == 1){
//        MyWXOpen.scene = WXSceneSession;
//        if([[suffixArr lastObject] isEqualToString:@"gif"]){
//            [MyWXOpen sendGifContentWithImageData:[MyAppDataManager imageDataForImageUrlStr:[self getBigPicUrl:thumbImageStr]] andThumbImage:[MyAppDataManager imageForImageUrlStr:thumbImageStr]];
//        }else{
//
//            [MyWXOpen sendImageContentWithImageData:[NSData dataWithContentsOfFile:[[SDImageCache sharedImageCache] cachePathForKey:[self getBigPicUrl:thumbImageStr]]] andThumbData:[NSData dataWithContentsOfFile:[[SDImageCache sharedImageCache] cachePathForKey:thumbImageStr]]];
//            
//        }
//        
//    }
//    else if(buttonIndex ==2){
//        MyWXOpen.scene = WXSceneTimeline;
//        [MyWXOpen sendImageContentWithImageData:[NSData dataWithContentsOfFile:[[SDImageCache sharedImageCache] cachePathForKey:[self getBigPicUrl:thumbImageStr]]] andThumbData:[NSData dataWithContentsOfFile:[[SDImageCache sharedImageCache] cachePathForKey:thumbImageStr]]];
//
//    }

}








-(void)swapToNextPage:(UIButton *)button
{
    UIScrollView *scroll = (UIScrollView *)[self.view viewWithTag:3456];
    if(button.tag==135&&currentPage>0)
    {
//        [UIView animateWithDuration:0.3 animations:^{
//           
//        }];
        [UIView animateWithDuration:0.3 animations:^{
            scroll.contentOffset = CGPointMake((currentPage-1)*320, 0);
            //            scroll.transform = CGAffineTransformMakeRotation(M_PI);
            currentPage--;
        } completion:^(BOOL finished) {
//            scroll.isDecelerating = YES;
//            isEnded = YES;
        }];
        UIButton *button1 = (UIButton *)[self.view viewWithTag:246];
        button1.hidden = NO;
        if(currentPage == 0)
        {
            button.hidden = YES;
        }
        
    }
    if(button.tag==246&&currentPage<_arrayData.count-1)
    {
        [UIView animateWithDuration:0.3 animations:^{
            scroll.contentOffset = CGPointMake((currentPage+1)*320, 0);
            currentPage++;
        }];
        UIButton *button1 = (UIButton *)[self.view viewWithTag:135];
        button1.hidden = NO;
        if(currentPage == _arrayData.count-1)
        {
            button.hidden = YES;
        }
        
    }
    
    MRZoomScrollView *aview2 = (MRZoomScrollView *)[scroll viewWithTag:(currentPage+1)*10];
    aview2.isLarger = NO;
    [aview2 setZoomScale:0.5];
    
    NSDictionary *object = [NSDictionary dictionaryWithDictionary:[self.arrayData objectAtIndex:currentPage]];
    NSString *url=[object valueForKey:@"saytext"];
    MRZoomScrollView *aview = (MRZoomScrollView *)[scroll viewWithTag:(currentPage+1)*10];
    aview.isLarger = NO;
    [aview setZoomScale:0.5];
    [self refreshUI];

    if([url hasSuffix:@".gif"])
    {        aview.userInteractionEnabled = NO;
    }
    else
    {
        aview.userInteractionEnabled = YES;
    }
    
    
    [(SCGIFImageView *)aview.imageView initWithURL:url];
    NSLog(@"%@",url);
    
    NSString *suffix = nil;
    
    NSRange range = [url rangeOfString:@"." options:NSBackwardsSearch];
    
    if(range.location!=NSNotFound)
    {
        suffix = [url substringFromIndex:range.location];
        url = [url stringByAppendingString:suffix];
    }
    NSData *data = [NSData dataWithContentsOfFile:[[SDImageCache sharedImageCache] cachePathForKey:url]];
    
    if(data.length<4)
    {
        [activity startAnimating];
    }
    

}


-(void)dealloc
{
    self.delegate = nil;
    //    [self.arrayData release];
    self.arrayData = nil;
    //    [self.hints release];
    self.hints = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [super dealloc];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSInteger page = scrollView.contentOffset.x/320;
    if(currentPage != page)
    {
        
        MRZoomScrollView *aview2 = (MRZoomScrollView *)[scrollView viewWithTag:(currentPage+1)*10];
        aview2.isLarger = NO;
        [aview2 setZoomScale:0.5];
        
        currentPage = page;
        NSDictionary *object = [NSDictionary dictionaryWithDictionary:[self.arrayData objectAtIndex:currentPage]];
        NSString *url=[object valueForKey:@"saytext"];
        MRZoomScrollView *aview = (MRZoomScrollView *)[scrollView viewWithTag:(currentPage+1)*10];
        aview.isLarger = NO;
        [aview setZoomScale:0.5];
        [self refreshUI];
        if([url hasSuffix:@".gif"])
        {
            aview.userInteractionEnabled = NO;
        }
        else
        {
            aview.userInteractionEnabled = YES;
        }
        
        
        [(SCGIFImageView *)aview.imageView initWithURL:url];
        
        NSString *suffix = nil;
        
        NSRange range = [url rangeOfString:@"." options:NSBackwardsSearch];
        
        if(range.location!=NSNotFound)
        {
            suffix = [url substringFromIndex:range.location];
            url = [url stringByAppendingString:suffix];
        }
        NSData *data = [NSData dataWithContentsOfFile:[[SDImageCache sharedImageCache] cachePathForKey:url]];
        
        if(data.length<4)
        {
            [activity startAnimating];
        }
        
    }
    UIButton *button1 = (UIButton *)[self.view viewWithTag:135];
    UIButton *button2 = (UIButton *)[self.view viewWithTag:246];
    if(currentPage == 0)
    {
        
        button1.hidden = YES;
    }
    else
        if(currentPage == 19)
        {
            button2.hidden = YES;
        }
        else
        {
            button1.hidden = NO;
            button2.hidden = NO;
        }
    
}
-(void)refreshUI
{
    NSLog(@"%d",activity.isAnimating);

    if(activity.isAnimating)
        [activity stopAnimating];
    
    
    UIScrollView *scrollView = (UIScrollView *)[self.view viewWithTag:3456];
    MRZoomScrollView *gifImageView = (MRZoomScrollView *)[scrollView viewWithTag:(currentPage+1)*10];
//    gifImageView.backgroundColor = [UIColor redColor];
    //动画
//    [gifImageView.imageView setGifData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"http://116.255.212.11/talkhelper/file/image/20130322/201303221629ccy05.jpg.jpg"]]];
    
    
    NSDictionary *object = [NSDictionary dictionaryWithDictionary:[self.arrayData objectAtIndex:currentPage]];
    NSString *url=[object valueForKey:@"saytext"];
    NSData *data = [NSData dataWithContentsOfFile:[[SDImageCache sharedImageCache] cachePathForKey:[self getBigPicUrl:url]]];
    
    if(data.length<4)
    {
        
        CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"opacity"];
        animation.fromValue = [NSNumber numberWithFloat:0.0f];
        animation.toValue = [NSNumber numberWithFloat:1.0f];
        animation.duration = 0.5f;
        animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
        [gifImageView.layer addAnimation: animation forKey: @"FadeIn"];
    }
    
    [gifImageView setNeedsDisplay];
    gifImageView.isReady = YES;
    
    NSLog(@"%f %f",gifImageView.frame.size.width,gifImageView.frame.size.height);
    gifImageView.frame = CGRectMake(currentPage*320, 0, 320, __MainScreen_Height-44);
    gifImageView.contentSize = CGSizeMake(320, __MainScreen_Height-44);
    gifImageView.imageView.frame = CGRectMake(0, 0, gifImageView.imageView.image.size.width, gifImageView.imageView.image.size.height);
    //     NSLog(@"2222   %f++++++%f",gifImageView.imageView.frame.size.width,gifImageView.imageView.frame.size.height);
    if(gifImageView.imageView.frame.size.width>(__MainScreen_Width-10))
    {
        gifImageView.imageView.frame = CGRectMake(0, 0, __MainScreen_Width-10, ((__MainScreen_Width-10)/gifImageView.imageView.frame.size.width)*gifImageView.imageView.frame.size.height);
    }
    //    NSLog(@"2222   %f++++++%f",gifImageView.imageView.frame.size.width,gifImageView.imageView.frame.size.height);
    if(gifImageView.imageView.frame.size.height>(__MainScreen_Height-44))
    {
        gifImageView.imageView.frame = CGRectMake(0, 0, ((__MainScreen_Height-44)/gifImageView.imageView.frame.size.height)*gifImageView.imageView.frame.size.width, __MainScreen_Height-44);
    }
    //    NSLog(@"2222   %f++++++%f",gifImageView.imageView.frame.size.width,gifImageView.imageView.frame.size.height);
    gifImageView.imageView.center = CGPointMake(160, (float)(__MainScreen_Height-44)/2);
//    self.hints = [object valueForKey:@"hints"];
//    NSLog(@"%@",object);
//    UIButton *btn = (UIButton *)[self.view viewWithTag:52152];
//    [btn setTitle:[NSString stringWithFormat:@"   %@",self.hints] forState:UIControlStateNormal];
    
}
-(NSString *)getBigPicUrl:(NSString *)url
{
    NSString *suffix = nil;
    
    NSRange range = [url rangeOfString:@"." options:NSBackwardsSearch];
    
    if(range.location!=NSNotFound)
    {
        suffix = [url substringFromIndex:range.location];
        url = [url stringByAppendingString:suffix];
    }
    return url;
}
//-(void)sendMessageTochat{
//    if([MyAppDelegate fromWX]){
//        
//        //       UIActionSheet *conSheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"分享给微信好友",nil];
//        //        [conSheet showInView:self.view];
//        //        [conSheet release];
//        BanBu_AppDelegate *delegate1 = (BanBu_AppDelegate *)[UIApplication sharedApplication].delegate;
//        delegate1.fromWX = NO;
//        
//        NSDictionary *object = [NSDictionary dictionaryWithDictionary:[self.arrayData objectAtIndex:currentPage]];
//        NSString *thumbImageStr = [object valueForKey:@"saytext"];
//        
//        
//        MyWXOpen.scene = WXSceneSession;
//        if([thumbImageStr hasSuffix:@"gif"]){
//            [MyWXOpen RespGifContentWithImageData:[MyAppDataManager imageDataForImageUrlStr:[self getBigPicUrl:thumbImageStr]] andThumbImage:[[SDWebImageManager sharedManager] imageWithURL:[NSURL URLWithString:thumbImageStr]]];
//        }else{
//            [MyWXOpen RespImageContentWithImageData:[MyAppDataManager imageDataForImageUrlStr:[self getBigPicUrl:thumbImageStr]] andThumbImage:[[SDWebImageManager sharedManager] imageWithURL:[NSURL URLWithString:thumbImageStr]]];
//            
//        }
//        
//    }else{
//        UIActionSheet *conSheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"复制到剪贴板",@"保存到手机",@"分享给微信好友",@"分享到好友圈",@"     QQ空间 微博 人人网 orz",nil];
//        [conSheet showInView:self.navigationController.view];
//        [conSheet release];
//    }
//    
//}
//-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
//    //    NSLog(@"%d",buttonIndex);
//    
//    NSDictionary *object = [NSDictionary dictionaryWithDictionary:[self.arrayData objectAtIndex:currentPage]];
//    NSString *thumbImageStr = [object valueForKey:@"saytext"];
//    NSString *saybeforString = [object valueForKey:@"saybefor"];
//    if([MyAppDelegate fromWX])
//    {
//        if(buttonIndex == 0){
//            [self dismissModalViewControllerAnimated:YES];
//            
//            MyWXOpen.scene = WXSceneSession;
//            if([thumbImageStr hasSuffix:@"gif"]){
//                [MyWXOpen RespGifContentWithImageData:[MyAppDataManager imageDataForImageUrlStr:[self getBigPicUrl:thumbImageStr]] andThumbImage:[[SDWebImageManager sharedManager] imageWithURL:[NSURL URLWithString:thumbImageStr]]];
//            }else{
//                [MyWXOpen RespImageContentWithImageData:[MyAppDataManager imageDataForImageUrlStr:[self getBigPicUrl:thumbImageStr]] andThumbImage:[[SDWebImageManager sharedManager] imageWithURL:[NSURL URLWithString:thumbImageStr]]];
//                
//            }
//            
//            
//            
//        }
//        
//    }
//    else{
//        if(buttonIndex != 4){
//            //            [self dismissModalViewControllerAnimated:YES];
//            
//        }
//        if(buttonIndex == 0){
//            
//            UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
//            [pasteboard setString:[NSString stringWithFormat:@"%@\n%@",saybeforString,[self getBigPicUrl:thumbImageStr]]];
//            [TKLoadingView showTkloadingAddedTo:self.navigationController.view title:@"内容已复制\n请粘贴到QQ、微博、陌陌等！" activityAnimated:NO duration:2.0];
//            
//            
//        }
//        else if(buttonIndex == 1){
//            //            [TKLoadingView showTkloadingAddedTo:self.navigationController.view title:@"正  在  保  存...\n" activityAnimated:YES];
//            
//            UIImage *aImage = [UIImage imageWithData:[MyAppDataManager imageDataForImageUrlStr:[self getBigPicUrl:thumbImageStr]]];
//            //            NSLog(@"%@",aImage);
//            if(!_assetLibrary){
//                _assetLibrary = [[ALAssetsLibrary alloc]init];
//            }
//            [_assetLibrary saveImage:aImage toAlbum:@"聊天小助手" completionBlock:^(NSURL *assetURL, NSError *error) {
//                
//                [TKLoadingView showTkloadingAddedTo:self.navigationController.view title:@"\n  保  存  成  功  \n\n" activityAnimated:NO duration:2.0];
//                
//            } failureBlock:^(NSError *error) {
//                
//                [TKLoadingView showTkloadingAddedTo:self.navigationController.view title:@"\n  保  存  失  败  \n\n" activityAnimated:NO duration:2.0];
//            }];
//            
//            
//            
//        }
//        else if(buttonIndex == 2){
//            
//            //        NSLog(@"%@,%@",thumbImageStr,UIImageJPEGRepresentation([MyAppDataManager imageForImageUrlStr:thumbImageStr], 1.0));
//            MyWXOpen.scene = WXSceneSession;
//            
//            if([thumbImageStr hasSuffix:@"gif"]){
//                [MyWXOpen sendGifContentWithImageData:[MyAppDataManager imageDataForImageUrlStr:[self getBigPicUrl:thumbImageStr]] andThumbImage:[[SDWebImageManager sharedManager] imageWithURL:[NSURL URLWithString:thumbImageStr]]];
//            }else{
//                [MyWXOpen sendImageContentWithImageData:[MyAppDataManager imageDataForImageUrlStr:[self getBigPicUrl:thumbImageStr]] andThumbImage:[[SDWebImageManager sharedManager] imageWithURL:[NSURL URLWithString:thumbImageStr]]];
//                
//            }
//            
//            
//        }
//        else if(buttonIndex == 3){
//            MyWXOpen.scene = WXSceneTimeline;
//            [MyWXOpen sendImageContentWithImageData:UIImageJPEGRepresentation([MyAppDataManager imageForImageUrlStr:[self getBigPicUrl:thumbImageStr]], 1.0) andThumbImage:[[SDWebImageManager sharedManager] imageWithURL:[NSURL URLWithString:thumbImageStr]]];
//        }
//        else if(buttonIndex == 4)
//        {
//            NSDictionary *object = [NSDictionary dictionaryWithDictionary:[self.arrayData objectAtIndex:currentPage]];
//            NSString *url=[object valueForKey:@"saytext"];
//            ShareViewController *share = [[ShareViewController alloc] initWithURLString:[self getBigPicUrl:url]];
//            [self.navigationController pushViewController:share animated:YES];
//            [share release];
//        }
//        
//    }
//    
//    
//}

@end
