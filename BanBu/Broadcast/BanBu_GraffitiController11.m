//
//  RootViewController.m
//  兔丫丫
//
//  Created by mac on 12-8-6.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "BanBu_GraffitiController11.h"
#import "Canvas2D.h"
#import "BanBu_ReleaseController.h"

#import "GTMBase64.h"
#import "AppDataManager.h"
#import "AppCommunicationManager.h"
#import "TKLoadingView.h"
#import "BanBu_LocationManager.h"

@interface BanBu_GraffitiController11 ()

@end

@implementation BanBu_GraffitiController11
 
-(void)closeAction{
    if(isClose==NO){
        [closeBtn setBackgroundImage:[UIImage imageNamed:@"btn_popmenu.png"] forState:UIControlStateNormal];
        
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.3];
        bgView.frame=CGRectMake(0, __MainScreen_Height, 320, 180);
        closeBtn.frame=CGRectMake(2, __MainScreen_Height-2-25, 25, 25);
        [UIView commitAnimations];
        isClose=YES;
    }else {
        [closeBtn setBackgroundImage:[UIImage imageNamed:@"btn_closemenu.png"] forState:UIControlStateNormal];
        
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.3];
        bgView.frame=CGRectMake(0, __MainScreen_Height-180, 320, 180);
        closeBtn.frame=CGRectMake(2, __MainScreen_Height-2-25-180, 25, 25);
        [UIView commitAnimations];
        isClose=NO;
    }
    
}

//选择涂鸦模板
-(void)selectPic:(UIButton *)sender{
    
    tuyaImageView.image=[UIImage imageNamed:[NSString stringWithFormat:@"0%d.jpg",sender.tag]];
    [aCan.arrayStrokes removeAllObjects];
    [aCan setNeedsDisplay];


}

//选择颜色
-(void)selectColor:(UIButton *)sender{
    
    NSArray *arr=[NSArray arrayWithObjects:[UIColor blackColor],[UIColor redColor],[UIColor orangeColor],[UIColor yellowColor],[UIColor greenColor],[UIColor cyanColor],[UIColor blueColor],[UIColor purpleColor],[UIColor clearColor], nil];
    aCan.lineColor=[arr objectAtIndex:sender.tag-1];


}

//选择画笔粗细
-(void)selectSize:(UISlider *)slider
{
    aCan.sizeValue=[NSNumber numberWithInt:slider.value]; 
    textLabel.text=[NSString stringWithFormat:@"%@%d",NSLocalizedString(@"brushSize", nil),[aCan.sizeValue intValue]];
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
    emptySheet=[[UIActionSheet alloc]initWithTitle:NSLocalizedString(@"emptySheet", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"cancelNotice", nil) destructiveButtonTitle:NSLocalizedString(@"deleteButton", nil) otherButtonTitles:nil];
    [emptySheet showInView:aCan];
    [emptySheet release];
    
}

-(void)send{
    sendSheet=[[UIActionSheet alloc]initWithTitle:NSLocalizedString(@"sendSheet", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"cancelNotice", nil) destructiveButtonTitle:nil otherButtonTitles:NSLocalizedString(@"sendAndSaveImage", nil),NSLocalizedString(@"onlySendImage", nil),nil];
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

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleBlackTranslucent animated:NO];
	// Do any additional setup after loading the view.
    
    tuyaImageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, __MainScreen_Height)];
//    tuyaImageView.image=[UIImage imageNamed:@""];
    [self.view addSubview:tuyaImageView];
    
    aCan=[[Canvas2D alloc]initWithFrame:CGRectMake(0, -20, 320, __MainScreen_Height+20)];
    aCan.backgroundColor=[UIColor colorWithWhite:0.9 alpha:0.8];
    [self.view addSubview:aCan];
    //辅助。。。。。。。。
    //背景
    bgView=[[UIView alloc]initWithFrame:CGRectMake(0, __MainScreen_Height-180, 320, 180)];
    bgView.backgroundColor=[UIColor colorWithWhite:0.3 alpha:1.0];
    bgView.alpha=0.8;
    [self.view addSubview:bgView];
//    UIButton *tempBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    tempBtn.frame = CGRectMake(0, 0, 320, 180);
//    [bgView addSubview:tempBtn];
    
    //关闭、打开
    closeBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    closeBtn.frame=CGRectMake(2, __MainScreen_Height-2-25-180, 25, 25);
    [closeBtn setBackgroundImage:[UIImage imageNamed:@"btn_closemenu.png"] forState:UIControlStateNormal];
    [closeBtn addTarget:self action:@selector(closeAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:closeBtn];
    
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
    UIScrollView *picScroll=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 5, 320, 55)];
    picScroll.contentSize=CGSizeMake(321, 55);
//    picScroll.alpha=0.9;
//    picScroll.backgroundColor = [UIColor redColor];
    [bgView addSubview:picScroll];
    [picScroll release];
    for(int i=1;i<7;i++){
        UIButton *aButton=[UIButton buttonWithType:UIButtonTypeCustom];
        aButton.frame=CGRectMake(15+(i-1)*50, 0, 40, 55);
        aButton.tag=i;
        [aButton setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"0%d.jpg",i]] forState:UIControlStateNormal];
        [aButton addTarget:self action:@selector(selectPic:) forControlEvents:UIControlEventTouchUpInside];
        [picScroll addSubview:aButton];
    }

    
    UIScrollView *colorScroll=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 5+60, 320, 40)];
    colorScroll.contentSize=CGSizeMake(321, 40);
    colorScroll.alpha=0.9;
//    colorScroll.backgroundColor = [UIColor redColor];

    [bgView addSubview:colorScroll];
    [colorScroll release];
    for(int j=1;j<9;j++){
        UIButton *aButton=[UIButton buttonWithType:UIButtonTypeCustom];
        aButton.frame=CGRectMake((j-1)*40, 0, 40, 40);
        aButton.tag=j;
        [aButton setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"color%d.png",j]] forState:UIControlStateNormal];
        [aButton addTarget:self action:@selector(selectColor:) forControlEvents:UIControlEventTouchUpInside];
        [colorScroll addSubview:aButton];
    }
//    [self selectColor:0];

    //画笔粗细
    textLabel=[[UILabel alloc]initWithFrame:CGRectMake(10, 50+60, 95, 20)];
    textLabel.text=[NSString stringWithFormat:@"%@%d",NSLocalizedString(@"brushSize", nil),[aCan.sizeValue intValue]];
    textLabel.font=[UIFont systemFontOfSize:15];
    textLabel.textColor=[UIColor whiteColor];
    textLabel.backgroundColor=[UIColor clearColor];
    [bgView addSubview:textLabel];
    
    UISlider *sizeSlider=[[UISlider alloc]initWithFrame:CGRectMake(105, 50+60, 200, 20)];
    sizeSlider.minimumValue=2;
    sizeSlider.maximumValue=30;
    sizeSlider.value=5;
    [sizeSlider addTarget:self action:@selector(selectSize:) forControlEvents:UIControlEventValueChanged];
    [bgView addSubview:sizeSlider];
    [sizeSlider release];
//    [self selectSize:sizeSlider];
   
    //撤销
    UIButton*revokedBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    revokedBtn.frame=CGRectMake(35, 75+60, 40, 40);
    [revokedBtn setBackgroundImage:[UIImage imageNamed:@"toleft_small.png"] forState:UIControlStateNormal];

    [revokedBtn addTarget:self action:@selector(revoked) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:revokedBtn];
    UIButton*unrevokedBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    unrevokedBtn.frame=CGRectMake(105, 75+60, 40, 40);
    [unrevokedBtn setBackgroundImage:[UIImage imageNamed:@"toright_small.png"] forState:UIControlStateNormal];
    [unrevokedBtn addTarget:self action:@selector(unrevoked) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:unrevokedBtn];
    //清空
    UIButton*emptyBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    emptyBtn.frame=CGRectMake(175, 75+60, 40, 40);
    [emptyBtn setBackgroundImage:[UIImage imageNamed:@"todelete.png"] forState:UIControlStateNormal];
    [emptyBtn addTarget:self action:@selector(emptyAction) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:emptyBtn];
    //发送
    UIButton*sendBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    sendBtn.frame=CGRectMake(245, 75+60, 40, 40);
    [sendBtn setBackgroundImage:[UIImage imageNamed:@"go_small.png"] forState:UIControlStateNormal];
    [sendBtn addTarget:self action:@selector(send) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:sendBtn];
  
}



-(void)dealloc{
    [aCan release],aCan=nil;
    [textLabel release],textLabel=nil;
    [bgView release],bgView=nil;
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

#pragma mark - ActionSheet
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(actionSheet == emptySheet){
        if(buttonIndex == 0){
            tuyaImageView.image=[UIImage imageNamed:@""];
            [aCan.arrayStrokes removeAllObjects];
            [aCan setNeedsDisplay];
        }
    }else{
        if(buttonIndex != 2){
            UIGraphicsBeginImageContext(aCan.bounds.size);
            [aCan.layer renderInContext:UIGraphicsGetCurrentContext()];
            viewImage = UIGraphicsGetImageFromCurrentImageContext();
            
            UIGraphicsEndImageContext();
            if(buttonIndex == 0){
                //将图片保存到相册
                UIImageWriteToSavedPhotosAlbum(viewImage, nil, nil, nil);
            }
            sendImageview = [[UIImageView alloc]initWithImage:viewImage];
            NSData * data=UIImageJPEGRepresentation(viewImage, 0.5);
            NSLog(@"%d",data.length);
            [self sendTuYaImage: data];
        }else {
            [self dismissModalViewControllerAnimated:YES];
            
        }
        
    }
    
    
}
//上传图片数据
-(void)sendTuYaImage:(NSData *)tuyaData{
    
    NSMutableDictionary *sendDic = [NSMutableDictionary dictionaryWithCapacity:1];
    [sendDic setValue:@"jpg" forKey:@"extname"];
    [AppComManager uploadBanBuMedia:tuyaData mediaName:@"tuya" par:sendDic delegate:self];
    
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

        [self dismissModalViewControllerAnimated:YES];
    }
    
}




@end
