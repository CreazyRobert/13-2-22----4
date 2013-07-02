//
//  BanBu_SelectController.m
//  BanBu
//
//  Created by mac on 12-9-7.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "BanBu_SelectController.h"
#import "BanBu_SelectPlaceController.h"
#import "BanBu_MyBallsController.h"
#import <QuartzCore/QuartzCore.h>
#import "AppDataManager.h"
#import "AppCommunicationManager.h"
#import "BanBuAPIs.h"
@interface BanBu_SelectController ()

@end

@implementation BanBu_SelectController

@synthesize totalUnreadNum=_totalUnreadNum;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization


    }
    return self;
}

-(void)buildButtonWithFrame:(CGRect)frame andImageName:(NSString *)imageName andText:(NSString *)text andAction:(SEL)action{
    UIButton *aButton = [UIButton buttonWithType:UIButtonTypeCustom];
    aButton.frame = frame;
    aButton.backgroundColor = [UIColor clearColor];
    [aButton setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    [aButton addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:aButton];
    UILabel *aLabel = [[UILabel alloc]initWithFrame:CGRectMake(2, 60, 70, 15)];
    aLabel.text = text;
    aLabel.textColor = [UIColor darkGrayColor];
    aLabel.textAlignment = UITextAlignmentCenter;
    aLabel.font = [UIFont systemFontOfSize:15];
    aLabel.backgroundColor = [UIColor clearColor];
    [aButton addSubview:aLabel];
    [aLabel release];

}

-(UILabel *)buildLabelWithFrame:(CGRect)frame andText:(NSString *)text{
    UILabel *instructLabel = [[UILabel alloc]initWithFrame:frame];
    instructLabel.text = text;
    instructLabel.textColor = [UIColor darkGrayColor];
    instructLabel.textAlignment = UITextAlignmentCenter;
    instructLabel.backgroundColor = [UIColor clearColor];
    [self.view addSubview:instructLabel];
    return [instructLabel autorelease];
}

-(void)locationAction{
    BanBu_SelectPlaceController *place =[[BanBu_SelectPlaceController alloc]init];
    //    [self shownavigationBar];
    place.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController: place animated:YES];
    [place release];
}

-(void)myBallAction{
    BanBu_MyBallsController *myBalls = [[BanBu_MyBallsController alloc]init];
    //    [self shownavigationBar];
    myBalls.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:myBalls animated:YES];
    [myBalls release];
}

// 展示数码
- (void)updateBadgeShow
{
    [MyAppDataManager readTalkList:BallList];
    _totalUnreadNum = 0;
    for(NSDictionary *aTalk in MyAppDataManager.playBall)
    {
        _totalUnreadNum += [VALUE(KeyUnreadNum, aTalk) integerValue];
    }  
    
    self.navigationController.tabBarItem.badgeValue = [NSString stringWithFormat:@"%i",_totalUnreadNum];
}




- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
//    self.title = @"抛绣球";
    self.view.backgroundColor=[UIColor colorWithRed:255.0/255 green:250.0/255 blue:240.0/255 alpha:1.0];

    UIImageView *backImageView= [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, __MainScreen_Height-44)];
    backImageView.image = [UIImage imageNamed:@"back1.jpg"];
    backImageView.userInteractionEnabled = YES;
    [self.view addSubview:backImageView];
    [backImageView release];
//    [NSTimer scheduledTimerWithTimeInterval:0.8 target:self selector:@selector(hideNavigationBar) userInfo:nil repeats:NO];
//    label1 = [self buildLabelWithFrame:CGRectMake(45, 100, 80, 30) andText:@"一个地点"];
//    label2 = [self buildLabelWithFrame:CGRectMake(170, 170, 80, 30) andText:@"一篇心情"];
//    label3 = [self buildLabelWithFrame:CGRectMake(120, 210, 80, 30) andText:@"一段缘分"];
    
    
    UIImageView *ballImageView= [[UIImageView alloc]initWithFrame:CGRectMake( 180, 40, 64, 64)];
    ballImageView.image = [UIImage imageNamed:@"bigBall.png"];
    ballImageView.userInteractionEnabled = YES;
    [self.view addSubview:ballImageView];
    [ballImageView release];
    label1 = [self buildLabelWithFrame:CGRectMake(45, 130, 80, 30) andText:NSLocalizedString(@"placeLabel", nil)];
    label2 = [self buildLabelWithFrame:CGRectMake(170, 170, 80, 30) andText:NSLocalizedString(@"moodLabel", nil)];
    label3 = [self buildLabelWithFrame:CGRectMake(120, 210, 80, 30) andText:NSLocalizedString(@"fateLabel", nil)];
    [self buildButtonWithFrame:CGRectMake(45, __MainScreen_Height-44-49-102, 75, 70) andImageName: @"throw.png" andText:NSLocalizedString(@"throwOneLabel", nil) andAction:@selector(locationAction)];
    [self buildButtonWithFrame:CGRectMake(200, __MainScreen_Height-44-49-102, 75, 70) andImageName:@"kuang.png" andText:NSLocalizedString(@"myBallLabel", nil) andAction:@selector(myBallAction)];
    
}

-(void)fly{
    CAKeyframeAnimation * flyAnimation1 = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    
    NSArray * array1 = [NSArray arrayWithObjects:[NSValue valueWithCGPoint:CGPointMake(85, 145)],
                        [NSValue valueWithCGPoint:CGPointMake(75, 145)],
                        [NSValue valueWithCGPoint:CGPointMake(60, 145)],
                        [NSValue valueWithCGPoint:CGPointMake(55, 145)],
                        [NSValue valueWithCGPoint:CGPointMake(45, 145)],
                        [NSValue valueWithCGPoint:CGPointMake(55, 145)],
                        [NSValue valueWithCGPoint:CGPointMake(65, 145)],
                        [NSValue valueWithCGPoint:CGPointMake(75, 145)],
                        [NSValue valueWithCGPoint:CGPointMake(85, 145)],nil];
    [flyAnimation1 setValues:array1];
    [flyAnimation1 setDuration:8.0];
    [label1.layer addAnimation:flyAnimation1 forKey:@"i"];
    CAKeyframeAnimation * flyAnimation2 = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    
    NSArray * array2 = [NSArray arrayWithObjects:[NSValue valueWithCGPoint:CGPointMake(210,  185)],
                        [NSValue valueWithCGPoint:CGPointMake(220,  185)],
                        [NSValue valueWithCGPoint:CGPointMake(230,  185)],
                        [NSValue valueWithCGPoint:CGPointMake(240,  185)],
                        [NSValue valueWithCGPoint:CGPointMake(250,  185)],
                        [NSValue valueWithCGPoint:CGPointMake(260,  185)],
                        [NSValue valueWithCGPoint:CGPointMake(270,  185)],
                        [NSValue valueWithCGPoint:CGPointMake(260,  185)],
                        [NSValue valueWithCGPoint:CGPointMake(250,  185)],
                        [NSValue valueWithCGPoint:CGPointMake(240,  185)],
                        [NSValue valueWithCGPoint:CGPointMake(230,  185)],
                        [NSValue valueWithCGPoint:CGPointMake(220,  185)],
                        [NSValue valueWithCGPoint:CGPointMake(210,  185)],nil];
    [flyAnimation2 setValues:array2];
    [flyAnimation2 setDuration:8.0];
    [label2.layer addAnimation:flyAnimation2 forKey:@"ii"];
    CAKeyframeAnimation * flyAnimation3 = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    
    NSArray * array3 = [NSArray arrayWithObjects:[NSValue valueWithCGPoint:CGPointMake(160, 225)],
                        [NSValue valueWithCGPoint:CGPointMake(150, 225)],
                        [NSValue valueWithCGPoint:CGPointMake(140, 225)],
                        [NSValue valueWithCGPoint:CGPointMake(130, 225)],
                        [NSValue valueWithCGPoint:CGPointMake(120, 225)],
                        [NSValue valueWithCGPoint:CGPointMake(130, 225)],
                        [NSValue valueWithCGPoint:CGPointMake(140, 225)],
                        [NSValue valueWithCGPoint:CGPointMake(150, 225)],
                        [NSValue valueWithCGPoint:CGPointMake(160, 225)],
                        [NSValue valueWithCGPoint:CGPointMake(170, 225)],
                        [NSValue valueWithCGPoint:CGPointMake(180, 225)],
                        [NSValue valueWithCGPoint:CGPointMake(190, 225)],
                        [NSValue valueWithCGPoint:CGPointMake(200, 225)],
                        [NSValue valueWithCGPoint:CGPointMake(190, 225)],
                        [NSValue valueWithCGPoint:CGPointMake(180, 225)],
                        [NSValue valueWithCGPoint:CGPointMake(170, 225)],
                        [NSValue valueWithCGPoint:CGPointMake(160, 225)],nil];
    [flyAnimation3 setValues:array3];
    [flyAnimation3 setDuration:8.0];
    [label3.layer addAnimation:flyAnimation3 forKey:@"iii"];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self fly];
    aTimer = [NSTimer scheduledTimerWithTimeInterval:8.0 target:self selector:@selector(fly) userInfo:nil repeats:YES];

    [self updateBadgeShow];
    
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [aTimer invalidate];
}

//-(void)hideNavigationBar{
//    [[UIApplication sharedApplication]setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
//    [UIView beginAnimations:nil context:nil];
//    [UIView setAnimationDuration:0.3];
//    self.navigationController.navigationBar.frame =CGRectMake(0, -44, 320, 44);
//    [UIView commitAnimations];
//}
//-(void)shownavigationBar{
//    [[UIApplication sharedApplication]setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
//    [UIView beginAnimations:nil context:nil];
//    [UIView setAnimationDuration:0.3];
//    self.navigationController.navigationBar.frame =CGRectMake(0, 20, 320, 44);
//    [UIView commitAnimations];
//}


//-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
//    if(isHidden){
//        [self hideNavigationBar];
//        isHidden = NO;
//    }else{
//        [self shownavigationBar];
//        isHidden = YES;
//    }
//    
//}
- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


@end
