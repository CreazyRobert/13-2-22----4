//
//  RootViewController.m
//  兔丫丫
//
//  Created by mac on 12-8-6.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "BanBu_GraffitiController.h"
#import "Canvas2D.h"
#import "BanBu_ReleaseController.h"

#import "GTMBase64.h"
#import "AppDataManager.h"
#import "AppCommunicationManager.h"
#import "TKLoadingView.h"
#import "BanBu_LocationManager.h"
#import "WXOpen.h"
#import "BanBu_MyProfileViewController.h"
@interface BanBu_GraffitiController ()

@end

@implementation BanBu_GraffitiController
 /*
-(void)closeAction{         //关闭叉号操作
    if(isClose==NO){
//        [closeBtn setBackgroundImage:[UIImage imageNamed:@"btn_popmenu.png"] forState:UIControlStateNormal];//关闭按钮
        
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.3];
        bgView.frame=CGRectMake(0, __MainScreen_Height, 320, 180);
//        closeBtn.frame=CGRectMake(2, __MainScreen_Height-2-25, 25, 25);
        [UIView commitAnimations];
        isClose=YES;
    }else {
//        [closeBtn setBackgroundImage:[UIImage imageNamed:@"btn_closemenu.png"] forState:UIControlStateNormal];
        
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.3];
        bgView.frame=CGRectMake(0, __MainScreen_Height-180, 320, 180);
//        closeBtn.frame=CGRectMake(2, __MainScreen_Height-2-25-180, 25, 25);
        [UIView commitAnimations];
        isClose=NO;
    }
    
}
*///刘杨注释
//选择涂鸦模板
NSInteger selectedButtonTag = -1;
NSInteger buttonTag         = -1;
-(void)selectPic:(UIButton *)sender{
    isCameraOrAlbum = NO;
    selectedButtonTag = sender.tag;
    
    if(buttonTag != sender.tag){
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"changeBackImage", nil) message:nil delegate:self cancelButtonTitle:NSLocalizedString(@"cancelNotice" , nil) otherButtonTitles:NSLocalizedString(@"confirmNotice", nil), nil];
        [alertView show];
        [alertView release];
        return;
    }
    tuyaImageView.image=[UIImage imageNamed:[NSString stringWithFormat:@"a%d.jpg",sender.tag]];
    [aCan.arrayStrokes removeAllObjects];
    aCan.backgroundColor=[UIColor colorWithWhite:0.9 alpha:0.8];
    [aCan setNeedsDisplay];


}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 1)
    {
        tuyaImageView.image=[UIImage imageNamed:[NSString stringWithFormat:@"a%d.jpg",selectedButtonTag]];
        [aCan.arrayStrokes removeAllObjects];
        aCan.backgroundColor=[UIColor colorWithWhite:0.9 alpha:0.8];
        [aCan setNeedsDisplay];
        buttonTag = selectedButtonTag;
    }
}

//选择颜色
-(void)selectColor:(UIButton *)sender{
    
    NSArray *arr=[NSArray arrayWithObjects:[UIColor blackColor],[UIColor redColor],[UIColor orangeColor],[UIColor yellowColor],[UIColor greenColor],[UIColor cyanColor],[UIColor blueColor],[UIColor purpleColor],[UIColor whiteColor], nil];
    aCan.lineColor=[arr objectAtIndex:sender.tag-1];


}

//选择画笔粗细
-(void)selectSize:(UISlider *)slider
{
    aCan.sizeValue=[NSNumber numberWithInt:slider.value];
    textLabel.text=[NSString stringWithFormat:@"%@%d",NSLocalizedString(@"brushSize", nil),[aCan.sizeValue intValue]];
//    [pointView setFrame:CGRectMake(0, 0, 15*(slider.value/30.0),15*(slider.value/30.0))];
//    [pointView setCenter:CGPointMake(50,125)];
    if(slider.value<=12)
    {
        [pointView setFrame:CGRectMake(0, 0, 8,8)];
    }
    else
    if(slider.value<=21)
    {
        [pointView setFrame:CGRectMake(0, 0, 10,10)];
    }
    else
    if(slider.value<=30)
    {
        [pointView setFrame:CGRectMake(0, 0, 12,12)];
    }
    [pointView setCenter:CGPointMake(50,125)];


}

//撤销
-(void)revoked
{   
    if([aCan.arrayStrokes count]){
        [aCan.tempArray addObject:[aCan.arrayStrokes lastObject]];
        [aCan.arrayStrokes removeLastObject];
        [aCan setNeedsDisplay];
    }
    
}

-(void)unrevoked{
    if([aCan.tempArray count]){
        [aCan.arrayStrokes addObject:[aCan.tempArray objectAtIndex:0]];
        [aCan.tempArray removeObjectAtIndex:0];
        [aCan setNeedsDisplay];
    }
    
}

-(void)emptyAction{
    emptySheet=[[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:NSLocalizedString(@"cancelNotice", nil) destructiveButtonTitle:NSLocalizedString(@"deleteButton", nil) otherButtonTitles:nil];
    [emptySheet showInView:aCan];
    [emptySheet release];
    
}

-(void)send{

    if(_type){
        sendSheet=[[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:NSLocalizedString(@"exitBtn", nil) destructiveButtonTitle:nil otherButtonTitles:NSLocalizedString(@"tuyaReply", nil),NSLocalizedString(@"saveToAlum", nil),NSLocalizedString(@"continueEdit", nil),nil];
   
    }else{
        sendSheet=[[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:NSLocalizedString(@"exitBtn", nil) destructiveButtonTitle:nil otherButtonTitles:NSLocalizedString(@"saveToAlum", nil),NSLocalizedString(@"share_broadcast", nil),NSLocalizedString(@"continueEdit", nil),nil];

    }
    [sendSheet showInView:aCan];
    [sendSheet release];
    
}


-(void)willPresentActionSheet:(UIActionSheet *)actionSheet{
    actionSheet.backgroundColor=[UIColor colorWithRed:0.5 green:0 blue:0 alpha:1];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(id)initwithImage:(UIImage *)sendImage andSourceType:(int)type{
    
    self = [super init];
    if(self){
        _type = type;
        tuyaImageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 320)];
        tuyaImageView.userInteractionEnabled = YES;
        [self.view addSubview:tuyaImageView];
        tuyaImageView.image = sendImage;
 
        aCan=[[Canvas2D alloc]initWithFrame:CGRectMake(0, 0, 320, 320)];
        [self.view addSubview:aCan];
        isCameraOrAlbum = YES;
        aCan.backgroundColor = [UIColor clearColor];
    }
    return self;
}

-(void)callTheCamera
{
    UIActionSheet *cameraSheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:NSLocalizedString(@"cancelNotice", nil) destructiveButtonTitle:nil otherButtonTitles:NSLocalizedString(@"btnXiangCe", nil),NSLocalizedString(@"btnCamera", nil), nil];
    cameraSheet.tag = 10086;
    [cameraSheet showInView:self.view];
    [cameraSheet release];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    isClose = YES;
    isCameraOrAlbum = NO;
    [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleBlackTranslucent animated:NO];
    self.view.backgroundColor = [UIColor colorWithWhite:0.9 alpha:0.8];

   
    
    if(!tuyaImageView){
        tuyaImageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 320)];
        tuyaImageView.userInteractionEnabled = YES;

        [self.view addSubview:tuyaImageView];
        
        
        
        aCan=[[Canvas2D alloc]initWithFrame:CGRectMake(0, 0, 320, 320)];
        aCan.backgroundColor=[UIColor colorWithWhite:0.9 alpha:0.8];
        [self.view addSubview:aCan];
        
    } 
    
    
    
    //辅助。。。。。。。。
    //背景
//    bgView=[[UIView alloc]initWithFrame:CGRectMake(0, __MainScreen_Height-180, 320, 180)];////////////////
    bgView=[[UIView alloc]initWithFrame:CGRectMake(0, 320, 320, __MainScreen_Height-320)];
    bgView.backgroundColor=[UIColor colorWithWhite:0.3 alpha:1.0];
    bgView.alpha=0.8;
    [self.view addSubview:bgView];
//    UIButton *tempBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    tempBtn.frame = CGRectMake(0, 0, 320, 180);
//    [bgView addSubview:tempBtn];
    
    //关闭、打开
    /*
    closeBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    closeBtn.frame=CGRectMake(2, __MainScreen_Height-2-25-180, 25, 25);
    [closeBtn setBackgroundImage:[UIImage imageNamed:@"btn_closemenu.png"] forState:UIControlStateNormal];
    [closeBtn addTarget:self action:@selector(closeAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:closeBtn];
     *///刘杨注释

    
    //颜色
//    NSArray *array=[NSArray arrayWithObjects:[UIImage imageNamed:@"color8.png"],[UIImage imageNamed:@"color7.png"],[UIImage imageNamed:@"color7.png"],[UIImage imageNamed:@"color6.png"],[UIImage imageNamed:@"color5.png"],[UIImage imageNamed:@"color1.png"],[UIImage imageNamed:@"color6.png"],[UIImage imageNamed:@"color5.png"], nil];
//    UISegmentedControl *segment=[[UISegmentedControl alloc]initWithItems:array];
//    segment.Frame=CGRectMake(0, 10, 320, 36);
//    segment.selectedSegmentIndex=0;
//    segment.segmentedControlStyle=UISegmentedControlStyleBar;
//    segment.tintColor=[UIColor darkGrayColor];
//    [segment addTarget:self action:@selector(selectColor:) forControlEvents:UIControlEventValueChanged];
//    [bgView addSubview:segment];
//    [segment release];
//    [self selectColor:segment];
    //方案二
    UIScrollView *picScroll=[[UIScrollView alloc]initWithFrame:CGRectMake(60, 5, 320, 50)];/////
    picScroll.contentSize=CGSizeMake(33*55+5, 50);////////
//    picScroll.alpha=0.9;
//    picScroll.backgroundColor = [UIColor redColor];
    [bgView addSubview:picScroll];
    [picScroll release];
    for(int i=1;i<=32;i++){
        UIButton *aButton=[UIButton buttonWithType:UIButtonTypeRoundedRect];
        aButton.frame=CGRectMake((i-1)*55, 0, 50, 50);//000000000
        aButton.tag=i;
        
        [aButton.layer setMasksToBounds:YES];
        
        aButton.layer.cornerRadius = 8.0;
        aButton.layer.borderWidth = 2.0;
        aButton.layer.borderColor = [[UIColor blackColor] CGColor];
        
        
        [aButton setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"a%d.jpg",i]] forState:UIControlStateNormal];////////////////////
        [aButton addTarget:self action:@selector(selectPic:) forControlEvents:UIControlEventTouchUpInside];
        [picScroll addSubview:aButton];
    }

    
    UIScrollView *colorScroll=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 60, 320, 30)];//////
    colorScroll.contentSize=CGSizeMake(321, 30);/////
    colorScroll.alpha=0.9;
//    colorScroll.backgroundColor = [UIColor redColor];

    [bgView addSubview:colorScroll];
    [colorScroll release];
    for(int j=1;j<=9;j++){
        UIButton *aButton=[UIButton buttonWithType:UIButtonTypeCustom];
        aButton.frame=CGRectMake((j-1)*35+5, 0, 30, 30);/////
        aButton.tag=j;
        [aButton setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"color%d.png",j]] forState:UIControlStateNormal];
        [aButton addTarget:self action:@selector(selectColor:) forControlEvents:UIControlEventTouchUpInside];
        [colorScroll addSubview:aButton];
    }
//    [self selectColor:0];

    /*
    //画笔粗细
    textLabel=[[UILabel alloc]initWithFrame:CGRectMake(10, 95, 95, 20)];/////
    textLabel.text=[NSString stringWithFormat:@"%@%d",NSLocalizedString(@"brushSize", nil),[aCan.sizeValue intValue]];
    textLabel.font=[UIFont systemFontOfSize:15];
    textLabel.textColor=[UIColor whiteColor];
    textLabel.backgroundColor=[UIColor clearColor];
    [bgView addSubview:textLabel];
    
    UISlider *sizeSlider=[[UISlider alloc]initWithFrame:CGRectMake(105, 95, 200, 20)];
    sizeSlider.minimumValue=2;
    sizeSlider.maximumValue=30;
    sizeSlider.value=5;
    [sizeSlider addTarget:self action:@selector(selectSize:) forControlEvents:UIControlEventValueChanged];
    [bgView addSubview:sizeSlider];
    [sizeSlider release];
//    [self selectSize:sizeSlider];
   *///刘杨注释
    
#pragma liuyang 相机button 和画笔button  画笔粗细调节
    
    UIButton *camBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    camBtn.frame = CGRectMake(5, 5, 50, 50);
    [camBtn setBackgroundImage:[UIImage imageNamed:@"导入图片.png"] forState:UIControlStateNormal];
    [camBtn setBackgroundImage:[UIImage imageNamed:@"导出图片.png"] forState:UIControlStateSelected];
    [camBtn addTarget:self action:@selector(callTheCamera) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:camBtn];
    //画笔button
    UIButton *penButton = [UIButton buttonWithType:UIButtonTypeCustom];
    penButton.frame = CGRectMake(20, 97.5, 35, 35);
    [penButton setBackgroundImage:[UIImage imageNamed:@"画笔.png"] forState:UIControlStateNormal];
    //画笔边上那个可以放大缩小的点
    [penButton addTarget:self action:@selector(changePen) forControlEvents:UIControlEventTouchUpInside];
    pointView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 8, 8)];
    pointView.center = CGPointMake(50,125);
    pointView.image = [UIImage imageNamed:@"画笔线条.png"];
    [bgView addSubview:pointView];
    [pointView release];
    [bgView addSubview:penButton];
    
    // silder 画笔调节
    sliderView = [[UIView alloc]initWithFrame:CGRectMake(0, 270, 320, 50)];
    [sliderView setBackgroundColor:[UIColor colorWithWhite:0.3 alpha:1.0]];
    textLabel=[[UILabel alloc]initWithFrame:CGRectMake(10, 15, 95, 20)];/////
    textLabel.text=[NSString stringWithFormat:@"%@%d",NSLocalizedString(@"brushSize", nil),5];
    textLabel.font=[UIFont systemFontOfSize:15];
    textLabel.textColor=[UIColor whiteColor];
    textLabel.backgroundColor=[UIColor clearColor];
    [sliderView addSubview:textLabel];
    
    UISlider *sizeSlider=[[UISlider alloc]initWithFrame:CGRectMake(105, 15, 200, 20)];
    sizeSlider.minimumValue=2;
    sizeSlider.maximumValue=30;
    sizeSlider.value=5;
    [sizeSlider addTarget:self action:@selector(selectSize:) forControlEvents:UIControlEventValueChanged];
    [sliderView addSubview:sizeSlider];
    [sizeSlider release];
#pragma liuyang
    //撤销
    UIButton*revokedBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    revokedBtn.frame=CGRectMake(80, 95, 40, 40);
    [revokedBtn setBackgroundImage:[UIImage imageNamed:@"toleft_small.png"] forState:UIControlStateNormal];

    [revokedBtn addTarget:self action:@selector(revoked) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:revokedBtn]; 
    UIButton*unrevokedBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    unrevokedBtn.frame=CGRectMake(140, 95, 40, 40);
    [unrevokedBtn setBackgroundImage:[UIImage imageNamed:@"toright_small.png"] forState:UIControlStateNormal];
    [unrevokedBtn addTarget:self action:@selector(unrevoked) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:unrevokedBtn];
    //清空
    UIButton*emptyBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    emptyBtn.frame=CGRectMake(200, 95, 40, 40);
    [emptyBtn setBackgroundImage:[UIImage imageNamed:@"todelete.png"] forState:UIControlStateNormal];
    [emptyBtn addTarget:self action:@selector(emptyAction) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:emptyBtn];
    //发送
    UIButton*sendBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    sendBtn.frame=CGRectMake(260, 95, 40, 40);
    [sendBtn setBackgroundImage:[UIImage imageNamed:@"go_small.png"] forState:UIControlStateNormal];
    [sendBtn addTarget:self action:@selector(send) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:sendBtn];
    if(self.view.frame.size.height>480)
    {
        UIButton *closedButton = [UIButton buttonWithType:UIButtonTypeCustom];
        closedButton.frame = CGRectMake(10, 150, 300, 60);
        [closedButton setBackgroundImage:[[UIImage imageNamed:@"app_btn_blue.png"] stretchableImageWithLeftCapWidth:10.0 topCapHeight:0.0] forState:UIControlStateNormal];
        closedButton.layer.cornerRadius = 6;
        [closedButton setTitle:NSLocalizedString(@"exitBtn", nil) forState:UIControlStateNormal];
        [closedButton addTarget:self action:@selector(popSelf) forControlEvents:UIControlEventTouchUpInside];
        [bgView addSubview:closedButton];
    }
   
  
}
-(void)popSelf
{
    [self dismissModalViewControllerAnimated:YES];
}
-(void)removeTheClearView:(UIGestureRecognizer *)gesture
{
//    if(clearView){
//        [clearView release];
// 
//    }
    [clearView removeFromSuperview];
//    [clearView removeGestureRecognizer:gesture];
    [sliderView removeFromSuperview];
    isClose = YES;
}
-(void)changePen
{
    if(isClose == YES)
    {
//        if(clearView){
//            [clearView release];
//        }
        clearView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, __MainScreen_Height)];
        [clearView setBackgroundColor:[UIColor clearColor]];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(removeTheClearView:)];
        [clearView addGestureRecognizer:tap];
        [tap release];
        UIPanGestureRecognizer *swipe = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(removeTheClearView:)];
        [clearView addGestureRecognizer:swipe];
        [swipe release];
        [self.view addSubview:clearView];
        [self.view addSubview:sliderView];
        [clearView release];
        isClose = NO;
    }
    else
    {
//        [clearView removeFromSuperview];

        [sliderView removeFromSuperview];
        
        isClose = YES;
    }
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
//    if(isClose == NO)
//    {
//        [sliderView removeFromSuperview];
//        isClose = YES;
//    }
}
-(void)dealloc{
    [aCan release],aCan=nil;
    [textLabel release],textLabel=nil;
    [bgView release],bgView=nil;
    [sliderView release],sliderView = nil;
    [tuyaImageView release],tuyaImageView=nil;
    [sendImageview release],sendImageview = nil;
    [super dealloc];
}
- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    UIApplication *app = [UIApplication sharedApplication];
    [app setStatusBarStyle:UIStatusBarStyleBlackOpaque animated:YES];
    [app setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
//    [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleBlackTranslucent animated:NO];

}
//....................
-(void)tuyaSave{
    if(!_assetLibrary){
        _assetLibrary = [[ALAssetsLibrary alloc]init];
    }
    [_assetLibrary saveImage:viewImage toAlbum:NSLocalizedString(@"fristTitle", nil) completionBlock:^(NSURL *assetURL, NSError *error) {
        
        [TKLoadingView showTkloadingAddedTo:self.view title:NSLocalizedString(@"savesucess", nil) activityAnimated:NO duration:2.0];
        
    } failureBlock:^(NSError *error) {
        
        [TKLoadingView showTkloadingAddedTo:self.view title:NSLocalizedString(@"savefail", nil) activityAnimated:NO duration:2.0];
    }];
}

#pragma mark - ActionSheet
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
//    NSLog(@"%d----%d",actionSheet.tag,buttonIndex);
    if(actionSheet.tag != 10086)
    {
        if(actionSheet == emptySheet){
            if(buttonIndex == 0){
                tuyaImageView.image=[UIImage imageNamed:@"af97jfgn"];
                [aCan.arrayStrokes removeAllObjects];
                
                [aCan setNeedsDisplay];
            }
        }
        else if(actionSheet == sendSheet){
            if(_type){
                if(buttonIndex == 0||buttonIndex == 1){
                    UIGraphicsBeginImageContext(CGSizeMake(320, 320));
                    if(isCameraOrAlbum == YES)
                    {
                        [self.view.layer renderInContext:UIGraphicsGetCurrentContext()];
                    }
                    if (isCameraOrAlbum == NO) {
                        [aCan.layer renderInContext:UIGraphicsGetCurrentContext()];
                    }
                    viewImage = UIGraphicsGetImageFromCurrentImageContext();
                    UIGraphicsEndImageContext();
//                    NSLog(@"%d",buttonIndex);
                    if(buttonIndex == 1){
                        [self tuyaSave];
                        
                    }
                    if(buttonIndex == 0)
                    {
                        sendImageview = [[UIImageView alloc]initWithImage:viewImage];
                        NSData * data=UIImageJPEGRepresentation(viewImage, 0.5);
                        NSLog(@"%d",data.length);
                        [self sendTuYaImage: data];
                    }
                    
                }
                else if(buttonIndex == 2)  //分享到button。。。
                {
//                    NSString *langauage=[MyAppDataManager getPreferredLanguage];
//                    
//                    if([langauage isEqual:@"zh-Hans"]){
//                        UIActionSheet *fenxiang=[[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:NSLocalizedString(@"cancelNotice", nil) destructiveButtonTitle:nil otherButtonTitles:@"分享给微信好友",@"分享到微信好友圈",@"分享到新浪微博",@"分享到腾讯微博", nil];
//                        fenxiang.tag = 2;
//                        [fenxiang showInView:self.view];
//                        [fenxiang release];
//                    }
//                    else{
//                        UIActionSheet *fenxiang=[[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:NSLocalizedString(@"cancelNotice", nil) destructiveButtonTitle:nil otherButtonTitles:@"Facebook",@"Twitter", nil];
//                        fenxiang.tag = 2;
//                        [fenxiang showInView:self.view];
//                        [fenxiang release];
//                    }
                }
//                else if(buttonIndex == 3)
//                {
//                    
//                }
                else
                {
                    [self dismissModalViewControllerAnimated:YES];
                }
            }
            else{
                if(buttonIndex == 0){
                    UIGraphicsBeginImageContext(CGSizeMake(320, 320));
                    if(isCameraOrAlbum == YES)
                    {
                        [self.view.layer renderInContext:UIGraphicsGetCurrentContext()];
                    }
                    if (isCameraOrAlbum == NO) {
                        [aCan.layer renderInContext:UIGraphicsGetCurrentContext()];
                    }
                    viewImage = UIGraphicsGetImageFromCurrentImageContext();
                    UIGraphicsEndImageContext();
                    
                    //将图片保存到相册
                    [self tuyaSave];
                    
                }
                else if(buttonIndex == 1)  //分享到button。。。
                {
                    NSString *langauage=[MyAppDataManager getPreferredLanguage];
                    
                    if([langauage isEqual:@"zh-Hans"]){
                        UIActionSheet *fenxiang=[[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:NSLocalizedString(@"cancelNotice", nil) destructiveButtonTitle:nil otherButtonTitles:@"分享给微信好友",@"分享到微信好友圈",@"分享到新浪微博",@"分享到腾讯微博", nil];
                        fenxiang.tag = 2;
                        [fenxiang showInView:self.view];
                        [fenxiang release];
                    }
                    else{
                        UIActionSheet *fenxiang=[[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:NSLocalizedString(@"cancelNotice", nil) destructiveButtonTitle:nil otherButtonTitles:@"Facebook",@"Twitter", nil];
                        fenxiang.tag = 2;
                        [fenxiang showInView:self.view];
                        [fenxiang release];
                    }
                    
                }
                else if(buttonIndex == 2)
                {
                    
                }
                else
                {
                    [self dismissModalViewControllerAnimated:YES];
                }
            }
            
        }
        else {
            
            UIGraphicsBeginImageContext(CGSizeMake(320, 320));
            if(isCameraOrAlbum == YES)
            {
                [self.view.layer renderInContext:UIGraphicsGetCurrentContext()];
            }
            if (isCameraOrAlbum == NO) {
                [aCan.layer renderInContext:UIGraphicsGetCurrentContext()];
            }
            viewImage = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
  
                            
            NSString *langauage=[MyAppDataManager getPreferredLanguage];
            
            if([langauage isEqual:@"zh-Hans"]){
                NSData *aData = [NSData dataWithData:UIImageJPEGRepresentation(viewImage, 0.5)];
                NSLog(@"%d",aData.length);
                for(float i= 100;i>0;i -= 10){
                    if(aData.length>32000){
                        aData = UIImageJPEGRepresentation(viewImage,i/100);
                        NSLog(@"%f--%d",i,aData.length);
                        
                    }else{
                        break;
                    }
                }
                
                
                NSLog(@"%d",aData.length);
                
                if(buttonIndex == 0){
                    MyWXOpen.scene = WXSceneSession;
//                    if(self.shareArr.count>1){
//                        if([[self.shareArr lastObject] hasSuffix:@"gif"]){
//                            [MyWXOpen sendGifContentWithImageData:[MyAppDataManager imageDataForImageUrlStr:[self.shareArr lastObject]] andThumbImage:[[[UIImage alloc] initWithData:aData] autorelease]];
//                        }else{
//                            [MyWXOpen sendImageContentWithImageData:UIImageJPEGRepresentation([self.shareArr objectAtIndex:0], 1.0) andThumbData:aData];
//                            
//                        }
//                        
//                    }
//                    else{
                        [MyWXOpen sendImageContentWithImageData:UIImageJPEGRepresentation(viewImage ,0.5) andThumbData:aData];
                        
//                    }
                }
                else if(buttonIndex == 1){
                    MyWXOpen.scene = WXSceneTimeline;

                    [MyWXOpen sendImageContentWithImageData:UIImageJPEGRepresentation(viewImage ,0.5) andThumbData:aData];
                    
                }
                else if(buttonIndex == 2){
                    
                    if([[UserDefaults valueForKey:@"sinaUser"] length]){
                        WBEngine *_wbEngine = [[WBEngine alloc] initWithAppKey:kWBSDKDemoAppKey appSecret:kWBSDKDemoAppSecret];
                        [_wbEngine setDelegate:self];
                        [_wbEngine setRootViewController:self];
                        [_wbEngine setRedirectURI:@"http://www.halfeet.com"];
                        [_wbEngine setIsUserExclusive:NO];
                        
                        //NSLog(@"%@",_receiveImage);
                        [_wbEngine sendWeiBoWithText:@"分享个好东西" image: viewImage];
                        [TKLoadingView showTkloadingAddedTo:self.view title:NSLocalizedString(@"sendingNotice", nil) activityAnimated:YES];
                        
                        
                    }else{
                        BanBu_MyProfileViewController *profile = [[BanBu_MyProfileViewController alloc]autorelease];
                        profile.tableView.contentOffset = CGPointMake(0, 360);
                        [self.navigationController pushViewController:profile animated:YES];
                    }
                }
                else if(buttonIndex == 3){
                    if([[UserDefaults valueForKey:@"QUser"] length]){
                        
                        QWeiboAsyncApi *api = [[[QWeiboAsyncApi alloc] init] autorelease];
                        NSString *tokenKey = [user valueForKey:AppTokenKey];
                        NSString *tokenSecret = [user valueForKey:AppTokenSecret];
                        
                        NSString *imagePath = [NSTemporaryDirectory() stringByAppendingFormat:@"releaseImage"];
                        UIImage *tempImage = viewImage;
//                        NSLog(@"%@-----%@",tempImage,[self.shareArr objectAtIndex:0]);
                        UIImageView *sendImageView = [[UIImageView alloc]initWithImage:tempImage] ;
                        if(sendImageView.image)
                        {
                            NSData *imageData;
                            //            if(!imageData)
                            imageData = UIImageJPEGRepresentation(sendImageView.image, 0.7);
                            [imageData writeToFile:imagePath atomically:YES];
                            //                    //NSLog(@"%@",imageData);
                        }
                        self.connection	= [api publishMsgWithConsumerKey:AppKey
                                                          consumerSecret:AppSecret
                                                          accessTokenKey:tokenKey
                                                       accessTokenSecret:tokenSecret
                                                                 content:@"分享个好东西"
                                                               imageFile:sendImageView.image?imagePath:nil
                                                              resultType:RESULTTYPE_JSON
                                                                delegate:self];
                        [sendImageView release];
                        [TKLoadingView showTkloadingAddedTo:self.view title:NSLocalizedString(@"sendingNotice", nil) activityAnimated:YES];
                        
                        
                        
                    }else{
                        
                        BanBu_MyProfileViewController *profile = [[BanBu_MyProfileViewController alloc]autorelease];
                        profile.tableView.contentOffset = CGPointMake(0, 360);
                        [self.navigationController pushViewController:profile animated:YES];
                        
                    }
                }
                
            }
            else{
                if(buttonIndex == 0){
                    if([[UserDefaults valueForKey:@"TUser"] length]){
                        FHSTwitterEngine * aEngine = [[[FHSTwitterEngine alloc]initWithConsumerKey:@"2cZXkfmSC6UrPUkhSPtfwQ" andSecret:@"mdoijXeFbK6dGVs5C61rADMOWSgFdNtPOBsxgnKw"]autorelease];
                        [aEngine loadAccessToken];
                        [TKLoadingView showTkloadingAddedTo:self.view title:NSLocalizedString(@"sendingNotice", nil) activityAnimated:YES];
                        
                        dispatch_async(GCDBackgroundThread, ^{
                            @autoreleasepool {
                                [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
                                NSError *returnCode = [aEngine postTweet:@"Share a good thing" withImageData:UIImageJPEGRepresentation(viewImage ,0.5)];
                                [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                                
                                NSString *title = nil;
                                //                                NSString *message = nil;
                                
                                if (returnCode) {
                                    //                                    title = [NSString stringWithFormat:@"Error %d",returnCode.code];
                                    //                                    message = returnCode.domain;
                                    title = NSLocalizedString(@"errcode_fail", nil);
                                } else {
                                    //                                    title = @"Tweet Posted";
                                    //                                    message = tweetField.text;
                                    title = NSLocalizedString(@"shareSuccess", nil);
                                }
                                
                                dispatch_sync(GCDMainThread, ^{
                                    [TKLoadingView dismissTkFromView:self.view animated:NO afterShow:0.0];
                                    [TKLoadingView showTkloadingAddedTo:self.view title:title activityAnimated:NO duration:2.0];
                                });
                            }
                        });
                        
                        
                    }else{
                        
                        BanBu_MyProfileViewController *profile = [[BanBu_MyProfileViewController alloc]autorelease];
                        profile.tableView.contentOffset = CGPointMake(0, 360);
                        [self.navigationController pushViewController:profile animated:YES];
                    }
                }
                else if(buttonIndex == 1){
                    if([[UserDefaults valueForKey:@"FBUser"] length]){
                        
                        
                        BOOL displayedNativeDialog = [FBNativeDialogs presentShareDialogModallyFrom:self
                                                                                        initialText:nil
                                                                                              image:viewImage
                                                                                                url:nil
                                                                                            handler:nil];
                        
                        if (!displayedNativeDialog) {
                            
                            [self performPublishAction:^{
                                
                                
                                [FBRequestConnection startForUploadPhoto:viewImage
                                                       completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
                                                           //                                       [self showAlert:@"Photo Post" result:result error:error];
                                                           [TKLoadingView dismissTkFromView:self.view animated:NO afterShow:0.0];
                                                           [TKLoadingView showTkloadingAddedTo:self.view title:NSLocalizedString(@"shareSuccess", nil) activityAnimated:NO duration:2.0 ];
                                                           
                                                           
                                                       }];
                                
                                
                                
                            }];
                            
                    }
  
                    }else{
                        BanBu_MyProfileViewController *profile = [[BanBu_MyProfileViewController alloc]autorelease];
                        profile.tableView.contentOffset = CGPointMake(0, 360);
                        [self.navigationController pushViewController:profile animated:YES];
                    }
                }
                
            }
       
            
        }
    }
    if(actionSheet.tag == 10086)
    {
        if(buttonIndex == 0)
        {
            UIImagePickerController *picker = [[UIImagePickerController alloc]init];
            picker.delegate = self;
            picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            [picker setAllowsEditing:YES];
            [self presentModalViewController:picker animated:YES];
            [picker release];
        }
        if(buttonIndex == 1)
        {
            UIImagePickerController *picker = [[UIImagePickerController alloc]init];
            if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
            {
                picker.sourceType = UIImagePickerControllerSourceTypeCamera;
                NSArray *temp_MediaTypes = [UIImagePickerController availableMediaTypesForSourceType:picker.sourceType];
                picker.mediaTypes = temp_MediaTypes;
                picker.delegate = self;
                picker.allowsEditing = YES;
                [self presentModalViewController:picker animated:YES];
            }
            else
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"相机不可用" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alert show];
                [alert release];
            }
        }
    }
 
}

//上传图片数据
-(void)sendTuYaImage:(NSData *)tuyaData{
    
//    NSMutableDictionary *sendDic = [NSMutableDictionary dictionaryWithCapacity:1];
//    [sendDic setValue:@"jpg" forKey:@"extname"];
//    [AppComManager uploadBanBuMedia:tuyaData mediaName:@"tuya" par:sendDic delegate:self];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"Mynotification" object:nil userInfo:[NSDictionary dictionaryWithObject:sendImageview.image forKey:@"tuyaImage"]];
    
    //        [self dismissModalViewControllerAnimated:YES];
    [self dismissViewControllerAnimated:YES completion:^{
        [[NSNotificationCenter defaultCenter]postNotificationName:@"dismissController" object:nil];
        
    }];
    
}

#pragma mark - BanBuUploadRequestDelegate

- (void)banbuUploadRequest:(NSDictionary *)resDic didFinishedWithError:(NSError *)error
{
//        //NSLog(@"%@",resDic);

    if(error)
    {
        [TKLoadingView showTkloadingAddedTo:self.view title:NSLocalizedString(@"uploadFailNotice", nil) activityAnimated:NO duration:2.0];
        return;
    }
    if([[resDic objectForKey:@"ok"] isEqualToString:@"y"]){
        NSString *picName=[resDic objectForKey:@"fileurl"];
//        //NSLog(@"%@",picName);
        [[NSNotificationCenter defaultCenter]postNotificationName:@"Mynotification" object:picName userInfo:[NSDictionary dictionaryWithObject:sendImageview.image forKey:@"tuyaImage"]];

//        [self dismissModalViewControllerAnimated:YES];
        [self dismissViewControllerAnimated:YES completion:^{
            [[NSNotificationCenter defaultCenter]postNotificationName:@"dismissController" object:nil];

        }];

        
    }
    
}

#pragma UIimagepickerController delegata

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    isCameraOrAlbum = YES;
    aCan.backgroundColor = [UIColor clearColor];
    [aCan.arrayStrokes removeAllObjects];
    [aCan setNeedsDisplay];
    tuyaImageView.image = [info objectForKey:@"UIImagePickerControllerEditedImage"];
    [self dismissModalViewControllerAnimated:YES];

    
}
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissModalViewControllerAnimated:YES];
}



#pragma mark - Share

- (void) performPublishAction:(void (^)(void)) action {
    // we defer request for permission to post to the moment of post, then we check for the permission
    if ([FBSession.activeSession.permissions indexOfObject:@"publish_actions"] == NSNotFound) {
        // if we don't already have the permission, then we request it now
        [FBSession.activeSession reauthorizeWithPublishPermissions:[NSArray arrayWithObject:@"publish_actions"]
                                                   defaultAudience:FBSessionDefaultAudienceFriends
                                                 completionHandler:^(FBSession *session, NSError *error) {
                                                     if (!error) {
                                                         [TKLoadingView showTkloadingAddedTo:self.view title:NSLocalizedString(@"sendingNotice", nil) activityAnimated:YES];
                                                         
                                                         action();
                                                     }
                                                     //For this example, ignore errors (such as if user cancels).
                                                 }];
    } else {
        [TKLoadingView showTkloadingAddedTo:self.view title:NSLocalizedString(@"sendingNotice", nil) activityAnimated:YES];
        
        action();
    }
    
}
- (void)showAlert:(NSString *)message
           result:(id)result
            error:(NSError *)error {
    
    NSString *alertMsg;
    NSString *alertTitle;
    if (error) {
        alertMsg = error.localizedDescription;
        alertTitle = @"Error";
    } else {
        NSDictionary *resultDict = (NSDictionary *)result;
        alertMsg = [NSString stringWithFormat:@"Successfully posted '%@'.\nPost ID: %@",
                    message, [resultDict valueForKey:@"id"]];
        alertTitle = @"Success";
    }
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:alertTitle
                                                        message:alertMsg
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
    [alertView show];
}
#pragma mark - 分享结果

- (void)engine:(WBEngine *)engine requestDidFailWithError:(NSError *)error{
    NSLog(@"%@",error);
    
    TKLoadingView *indictor = nil;
	for(indictor in self.view.subviews)
		if([indictor isKindOfClass:[TKLoadingView class]])
		{
			[indictor setActivityAnimating:NO withShowMsg:NSLocalizedString(@"errcode_fail", nil)];
			[indictor dismissAfterDelay:1.0 animated:YES];
		}
}
- (void)engine:(WBEngine *)engine requestDidSucceedWithResult:(id)result{
    NSLog(@"asdfasdf");
    TKLoadingView *indictor = nil;
	for(indictor in self.view.subviews)
		if([indictor isKindOfClass:[TKLoadingView class]])
		{
			[indictor setActivityAnimating:NO withShowMsg:NSLocalizedString(@"shareSuccess", nil)];
			[indictor dismissAfterDelay:1.0 animated:YES];
		}
}

- (void) connectionDidFinishLoading:(NSURLConnection *)connection {
	
    
    TKLoadingView *indictor = nil;
	for(indictor in self.view.subviews)
		if([indictor isKindOfClass:[TKLoadingView class]])
		{
			[indictor setActivityAnimating:NO withShowMsg:NSLocalizedString(@"shareSuccess", nil)];
			[indictor dismissAfterDelay:1.0 animated:YES];
		}
    
}
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
	
    TKLoadingView *indictor = nil;
	for(indictor in self.view.subviews)
		if([indictor isKindOfClass:[TKLoadingView class]])
		{
			[indictor setActivityAnimating:NO withShowMsg:NSLocalizedString(@"errcode_fail", nil)];
			[indictor dismissAfterDelay:1.0 animated:YES];
		}
}

- (void)storeAccessToken:(NSString *)accessToken {
    [[NSUserDefaults standardUserDefaults]setObject:accessToken forKey:@"SavedAccessHTTPBody"];
}

- (NSString *)loadAccessToken {
    return [[NSUserDefaults standardUserDefaults]objectForKey:@"SavedAccessHTTPBody"];
}

@end
