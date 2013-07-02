//
//  BanBu_choiceController.m
//  BanBu
//
//  Created by apple on 13-3-18.
//
//

#import "BanBu_choiceController.h"
#import "SVSegmentedControl.h"
#import "AppDataManager.h"
@interface BanBu_choiceController ()

-(void)initSubViews;
-(void)toseleTime:(SVSegmentedControl*)sender;
-(void)changeToSelect:(UIButton *)sender;
@end
@interface SVSegmentedControl (fuck)

-(void)setMakeHeight:(float)height;

@end

@implementation SVSegmentedControl(fuck)


-(void)setMakeHeight:(float)height
{

    self.height=height;

}
@end



@implementation BanBu_choiceController

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
    
    self.title=NSLocalizedString(@"selectTitle", nil);

    UIButton *selectButton=[UIButton buttonWithType:UIButtonTypeCustom];
    
    [selectButton addTarget:self action:@selector(toSelsect:) forControlEvents:UIControlEventTouchUpInside];
    

    selectButton.frame=CGRectMake(0, 0,50, 30);
        
 
    [selectButton setTitle:NSLocalizedString(@"returnButton", nil) forState:UIControlStateNormal];
    
    selectButton.titleLabel.font=[UIFont systemFontOfSize:14];
    
    [selectButton setBackgroundImage:[[UIImage imageNamed:@"app_nav_btn_bg1.png"] stretchableImageWithLeftCapWidth:15.0 topCapHeight:15.0] forState:UIControlStateNormal];
    
    [selectButton setImageEdgeInsets:UIEdgeInsetsMake(3.0, 5.0, 2.0, 3.0)];
    
    UIBarButtonItem *leftButton = [[[UIBarButtonItem alloc] initWithCustomView:selectButton] autorelease];
    self.navigationItem.leftBarButtonItem = leftButton;

    [self initSubViews];
    
  self.view.backgroundColor=[UIColor colorWithRed:255.0/255 green:250.0/255 blue:240.0/255 alpha:1.0];
    
    
    
    
}

// 获取当前机器语言
-(NSString*)getPreferredLanguage
{
    NSUserDefaults* defs = [NSUserDefaults standardUserDefaults];
    NSArray* languages = [defs objectForKey:@"AppleLanguages"];
    NSString* preferredLang = [languages objectAtIndex:0];
    return preferredLang;
}

-(void)initSubViews
{
    NSString *str=NSLocalizedString(@"sexSelect", nil);
    
   CGSize titleSize = [str sizeWithFont:[UIFont systemFontOfSize:16] constrainedToSize:CGSizeMake(1000, 30)];
    
    UILabel *userLabel=[[UILabel alloc]initWithFrame:CGRectMake(15, 20, titleSize.width, 20)];
    
    userLabel.text=NSLocalizedString(@"sexSelect", nil);
    
    userLabel.font=[UIFont systemFontOfSize:16];
    
    userLabel.backgroundColor=[UIColor clearColor];
    
    [self.view addSubview:userLabel];
    
    [userLabel release];
    
    // segment的title
   
    NSMutableDictionary *dic;
    
    if([UserDefaults valueForKey:[NSString stringWithFormat:@"%@electNearBy",MyAppDataManager.useruid]])
    {
        dic=[NSMutableDictionary dictionaryWithDictionary:[UserDefaults valueForKey:[NSString stringWithFormat:@"%@electNearBy",MyAppDataManager.useruid]]];
        
    }else
    {
        dic=[NSMutableDictionary dictionaryWithCapacity:1];
        
    }


    NSString *langauage=[self getPreferredLanguage];
    
    NSArray *arr;
    
    if([langauage isEqual:@"zh-Hans"])
    {
        arr = [NSArray arrayWithObjects:@"   全部   ",@"     ♂ 男     ",@"    ♀ 女     ", nil];
    }else if ([langauage isEqual:@"ja"])
    {
        arr = [NSArray arrayWithObjects:@"  全体  ",@"  ♂ 男性  ",@"  ♀ 女性  ", nil];
    }else
    {
        arr = [NSArray arrayWithObjects:@" All ",@" ♂ Male ",@" ♀ Female ", nil];
    }

    

    segMent=[[SVSegmentedControl alloc]initWithSectionTitles:arr];
    
    
    segMent.crossFadeLabelsOnDrag = YES;
    segMent.thumb.tintColor = [UIColor colorWithWhite:0 alpha:.3];
    segMent.backgroundColor = [UIColor colorWithWhite:0 alpha:.2];
//    NSLog(@"%@",dic);
    if([dic count])
    {
        segMent.selectedIndex=[[dic valueForKey:@"sex"]intValue];
    }else{
        segMent.selectedIndex=0;
    }
    segMent.center=CGPointMake(160, 70);
   //segMent.frame=CGRectMake(15, 70,290 , 45);
    
    segMent.height=40;
    
    segMent.font=[UIFont systemFontOfSize:16];
    
    [segMent addTarget:self action:@selector(toseleSex:) forControlEvents:UIControlEventValueChanged];
    
    [self.view addSubview:segMent];
    
    [segMent release];
    
    
    // 出现的时间
    
    NSString *time=NSLocalizedString(@"timeSelect", nil);
    
    CGSize size=[time sizeWithFont:[UIFont systemFontOfSize:16] constrainedToSize:CGSizeMake(1000, 30)];
    
    UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(15, 130, size.width, 20)];
    
    label.font=[UIFont systemFontOfSize:16];
    
    label.text=time;
    
    label.backgroundColor=[UIColor clearColor];
    
    [self.view addSubview:label];
    
    [label release];
    
     
    NSArray *timeArray;
    
    if([langauage isEqual:@"zh-Hans"])
    {
      timeArray =[NSArray arrayWithObjects:@"全部",@"15分钟",@"1小时",@"1天",@"7天" ,nil];
    }else if ([langauage isEqual:@"ja"])
    {
       timeArray=[NSArray arrayWithObjects:@"全体",@"15分",@"1時間",@"1日",@"7日" ,nil];
    }else
    {
        timeArray=[NSArray arrayWithObjects:@"All",@"15Min",@"1Hour",@"1Day",@"7Day" ,nil];
    }

    segMentTime=[[SVSegmentedControl alloc]initWithSectionTitles:timeArray];
    
    segMentTime.crossFadeLabelsOnDrag = YES;
    segMentTime.thumb.tintColor = [UIColor colorWithWhite:0 alpha:.3];
    segMentTime.backgroundColor = [UIColor colorWithWhite:0 alpha:.2];
    
    if([dic count])
    {
        segMentTime.selectedIndex=[[dic valueForKey:@"time"] intValue];
        
    }else{
    segMentTime.selectedIndex=0;
    }
    
    segMentTime.center=CGPointMake(160, 180);
    //segMent.frame=CGRectMake(15, 70,290 , 45);
    
    segMentTime.height=40;
    
    segMentTime.font=[UIFont systemFontOfSize:16];

    [segMentTime addTarget:self action:@selector(toseleTime:) forControlEvents:UIControlEventValueChanged];
    
    [self.view addSubview:segMentTime];
    
    [segMentTime release];
    
    
    UILabel *messageLabel=[[UILabel alloc]initWithFrame:CGRectMake(40, 210, 240, 20)];
    
    messageLabel.backgroundColor=[UIColor clearColor];
    
    messageLabel.font=[UIFont systemFontOfSize:15];
    
    messageLabel.textAlignment=NSTextAlignmentCenter;
    
   // messageLabel.text=@"选中时间内刷新过位置的用户";
    
    messageLabel.textColor=[UIColor darkGrayColor];
    
    [self.view addSubview:messageLabel];
    
    [messageLabel release];
    
    
    UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
    
    button.frame=CGRectMake(40, 280, 240, 40);
    
    [button setBackgroundImage:[[UIImage imageNamed:@"app_nav_btn_bg1.png"] stretchableImageWithLeftCapWidth:15.0 topCapHeight:15.0] forState:UIControlStateNormal];
    
    [button addTarget:self action:@selector(changeToSelect:) forControlEvents:UIControlEventTouchUpInside];
    
    [button setTitle:NSLocalizedString(@"confirmNotice", nil) forState:UIControlStateNormal];
    
    [self.view addSubview:button];
    
    
}

-(void)changeToSelect:(UIButton *)sender
{
    NSMutableDictionary *dic=[[NSMutableDictionary alloc]init];

    [dic setValue:[NSNumber numberWithInteger:segMent.selectedIndex] forKey:@"sex"];
    
    [dic setValue:[NSNumber numberWithInteger:segMentTime.selectedIndex] forKey:@"time"];
    
    
    [UserDefaults setValue:dic forKey:[NSString stringWithFormat:@"%@electNearBy",MyAppDataManager.useruid]];
    
      [[NSNotificationCenter defaultCenter]postNotificationName:@"toselect" object:dic];
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        
        NSData *listData = [NSKeyedArchiver archivedDataWithRootObject:dic];
      
        NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"%@electNearBy",MyAppDataManager.useruid]];
        [listData writeToFile:path atomically:YES];
       
      
    });

     [self dismissModalViewControllerAnimated:YES];
    
    [dic release];


}
-(void)toseleSex:(SVSegmentedControl *)sender
{

    selectsex=sender.selectedIndex;
    

}

-(void)toseleTime:(SVSegmentedControl*)sender
{
    selectTime=sender.selectedIndex;
    
}






-(void)toSelsect:(UIButton *)sender
{

    [self.navigationController dismissModalViewControllerAnimated:YES];
    
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
