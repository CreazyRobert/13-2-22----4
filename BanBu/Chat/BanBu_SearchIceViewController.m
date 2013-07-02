//
//  BanBu_SearchIceViewController.m
//  BanBu
//
//  Created by Jc Zhang on 12-12-29.
//
//

#import "BanBu_SearchIceViewController.h"
#import "AppDataManager.h"
#import "TKLoadingView.h"
#import "AppCommunicationManager.h"
#import "BanBu_IceBreaker_Voice.h"
#import "BanBu_icePicController.h"
#import "BanBu_IceBreakerController.h"

@interface BanBu_SearchIceViewController ()

@end

@implementation BanBu_SearchIceViewController

// 获取当前机器语言
-(NSString*)getPreferredLanguage
{
    NSUserDefaults* defs = [NSUserDefaults standardUserDefaults];
    NSArray* languages = [defs objectForKey:@"AppleLanguages"];
    NSString* preferredLang = [languages objectAtIndex:0];
    return preferredLang;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)dealloc{
    [hotKeyArr release];
  //  [[NSNotificationCenter defaultCenter]removeObserver:self name:@"popToChat" object:nil];
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.title = NSLocalizedString(@"searchIce", nil);
    
    UIButton *reButton = [UIButton buttonWithType:UIButtonTypeCustom];
    reButton.frame = CGRectMake(0, 0, 40, 30);
    [reButton addTarget:self action:@selector(refreshContent) forControlEvents:UIControlEventTouchUpInside];
    [reButton setBackgroundImage:[[UIImage imageNamed:@"app_nav_btn_bg1.png"] stretchableImageWithLeftCapWidth:15.0 topCapHeight:15.0] forState:UIControlStateNormal];
    //    [addButton setBackgroundImage:[[UIImage imageNamed:@"app_nav_btn_bg2.png"] stretchableImageWithLeftCapWidth:15.0 topCapHeight:15.0] forState:UIControlStateHighlighted];
    [reButton setImage:[UIImage imageNamed:@"refresh.png"] forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:reButton] autorelease];
    
    search=[[UITextField alloc]initWithFrame:CGRectMake(30, 70, 160, 30)];
    search.placeholder = NSLocalizedString(@"searchTextField", nil);
    search.delegate  = self;
    search.text = @"";
    search.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    search.layer.borderWidth = 1.0;
    search.layer.cornerRadius = 4;
    search.clearButtonMode = UITextFieldViewModeWhileEditing;
    search.returnKeyType = UIReturnKeyDone;
    [search setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    search.backgroundColor = [UIColor clearColor];
    [self.view addSubview:search];
    UILabel *paddingView = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 5, 30)];
    paddingView.backgroundColor = [UIColor clearColor];
    search.leftView = paddingView;
    search.leftViewMode = UITextFieldViewModeAlways;
    [paddingView release];
    
    UIButton *aSearchButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [aSearchButton addTarget:self action:@selector(searchAction) forControlEvents:UIControlEventTouchUpInside];
    [aSearchButton setBackgroundImage:[[UIImage imageNamed:@"app_nav_btn_bg1.png"] stretchableImageWithLeftCapWidth:15.0 topCapHeight:15.0] forState:UIControlStateNormal];
    aSearchButton.frame=CGRectMake(200, 70, 103, 30);
    [aSearchButton setTitleEdgeInsets:UIEdgeInsetsMake(3, 2, 2, 2)];
    [aSearchButton setTitle:NSLocalizedString(@"searchIceBtn", nil) forState:UIControlStateNormal];
    aSearchButton.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    [self.view addSubview:aSearchButton];
    
    NSArray *items;
    NSString *langauage=[self getPreferredLanguage];
    if([langauage isEqual:@"zh-Hans"])
    {
        items = [NSArray arrayWithObjects:@"    文字    ",@"    图片    ",@"    语音    ",nil];
        langauageStr = @"zh";
    }else if ([langauage isEqual:@"ja"])
    {
        items = [NSArray arrayWithObjects:@"      テキスト     ",@"       写真       ",nil];
        langauageStr = @"ja";

    }else
    {
        items = [NSArray arrayWithObjects:@"       Text       ",@"     Pictures     ",nil];
        langauageStr = @"en";

    }
    seg = [[SVSegmentedControl alloc] initWithSectionTitles:items];
    //        seg.backgroundColor = [UIColor colorWithWhite:0 alpha:.7];
    seg.center = CGPointMake(160, 35);
    seg.crossFadeLabelsOnDrag = YES;
    //        seg.thumb.tintColor = [UIColor colorWithRed:0.6 green:0.2 blue:0.2 alpha:1];
    seg.thumb.tintColor = [UIColor colorWithWhite:0 alpha:.3];
    seg.backgroundColor = [UIColor colorWithWhite:0 alpha:.2];
    seg.selectedIndex = 0;
       [seg addTarget:self action:@selector(segmentedControlDidChangeValue:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:seg];
    [seg release];
    
    //
    UILabel *lineLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 125, 300, 1)];
    lineLabel.backgroundColor = [UIColor colorWithRed:208.0/255 green:201.0/255 blue:184.0/255 alpha:1.0];
    [self.view addSubview:lineLabel];
    [lineLabel release];
    
    UILabel *tuijianLabel=[[UILabel alloc]initWithFrame:CGRectMake(10, 135, 180, 30)];
    tuijianLabel.text = NSLocalizedString(@"tuijianLabel", nil);
    
    tuijianLabel.font = [UIFont boldSystemFontOfSize:20];
    tuijianLabel.textColor =[UIColor colorWithRed:255.0/255 green:138.0/255 blue:45.0/255 alpha:1.0];
    tuijianLabel.textAlignment = UITextAlignmentLeft;
    tuijianLabel.backgroundColor=[UIColor clearColor];
    [self.view addSubview:tuijianLabel];
    [tuijianLabel release];
    
    NSMutableDictionary *parDic = [NSMutableDictionary dictionary];
    [parDic setValue:langauageStr forKey:@"country"];
    [AppComManager getBanBuData:BanBu_Get_Sayhi_Hot par:parDic delegate:self];
//    self.navigationController.view.userInteractionEnabled = NO;
    [TKLoadingView showTkloadingAddedTo:self.navigationController.view title:NSLocalizedString(@"loadingNotice", nil) activityAnimated:YES];

    hotKeyArr = [[NSMutableArray alloc]initWithCapacity:10];

    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(popToChat) name:@"popToChat" object:nil];

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

-(void)refreshContent{
    
    NSMutableDictionary *parDic = [NSMutableDictionary dictionary];
    [parDic setValue:langauageStr forKey:@"country"];
    [AppComManager getBanBuData:BanBu_Get_Sayhi_Hot par:parDic delegate:self];
//    self.navigationController.view.userInteractionEnabled = NO;
    
    
}

-(void)searchAction{
    
    NSLog(@"%d",seg.selectedIndex);
    NSArray *typeArr = [NSArray arrayWithObjects:@"text",@"image",@"sound", nil];
    NSMutableDictionary *parDic = [NSMutableDictionary dictionary];
    [parDic setValue:[typeArr objectAtIndex:seg.selectedIndex] forKey:@"kind"];
    [parDic setValue:search.text forKey:@"keyword"];
    [parDic setValue:langauageStr forKey:@"country"];
    
    switch(seg.selectedIndex){
        case 0:
        {
            BanBu_IceBreakerController  *text = [[BanBu_IceBreakerController alloc]init];
            text.parDic = parDic;
//            NSLog(@"%@",search.text);
            if(search.text.length){
                text.title =[NSString stringWithFormat:@"%@%@",NSLocalizedString(@"searchkey", nil),search.text];
                
            }
            [self.navigationController pushViewController:text animated:YES];
            [text release];
            
        }
            break;
        case 1:
        {
            
            [AppComManager getBanBuData:BanBu_Get_Sayhi_Rand par:parDic delegate:self];
//            self.navigationController.view.userInteractionEnabled = NO;
            [TKLoadingView showTkloadingAddedTo:self.navigationController.view title:NSLocalizedString(@"loadingNotice", nil) activityAnimated:YES];

        }
            break;
        case 2:
        {
            BanBu_IceBreaker_Voice *voice = [[BanBu_IceBreaker_Voice alloc]init];
            voice.parDic = parDic;
            if(search.text.length){
                voice.title =[NSString stringWithFormat:@"%@%@",NSLocalizedString(@"searchkey", nil),search.text];
                
            }
            [self.navigationController pushViewController:voice animated:YES];
            [voice release];
        }
            break;
        default:
            break;
    }

    
}

- (void)segmentedControlDidChangeValue:(SVSegmentedControl *)segment{
    search.text = @"";
    if(segment.selectedIndex == 0){
        
        [self buildHotKeyButton:0];
        
    }else if(segment.selectedIndex == 1){
        
        [self buildHotKeyButton:1];
        
        
    }else if(segment.selectedIndex == 2){
        
        
        [self buildHotKeyButton:2];
        
    }
    
}

-(void)buildHotKeyButton:(NSInteger)num{
    
    if(hotkeyView){
        lineHeight = 0;
        [[self.view viewWithTag:101] removeFromSuperview];
    }
    hotkeyView=[[[UIView alloc]initWithFrame:CGRectZero]autorelease];
    hotkeyView.tag=101;
    hotkeyView.backgroundColor=[UIColor clearColor];
    [self.view addSubview:hotkeyView];
    
    if(!hotKeyArr.count)
        return;
    for (int i=0; i<[[hotKeyArr objectAtIndex:num] count]; i++) {
        UIButton *aButton=[UIButton buttonWithType:UIButtonTypeCustom];
        aButton.tag=i;
        aButton.frame=CGRectMake(i%3*100, i/3*45, 100, 20);
        lineHeight = i/3*45;
        [aButton setTitle:[[hotKeyArr objectAtIndex:num] objectAtIndex:i] forState:UIControlStateNormal];
        [aButton setTitleColor:[UIColor colorWithRed:(arc4random()%256/256.0) green:(arc4random()%256/256.0) blue:(arc4random()%256/256.0) alpha:1.0] forState:UIControlStateNormal];
        aButton.backgroundColor=[UIColor clearColor];
        [hotkeyView addSubview:aButton];
        [aButton addTarget:self action:@selector(placeSelect:) forControlEvents:UIControlEventTouchUpInside];
        
        
    }
    
    hotkeyView.frame=CGRectMake(10, 175, 300, lineHeight+25);
    
}

-(void)placeSelect:(UIButton *)sender{
    
//    if([search.text isEqualToString:[[hotKeyArr objectAtIndex:seg.selectedIndex]objectAtIndex:sender.tag]]){
//        [self searchAction];
//    }else{
//        search.text = [[hotKeyArr objectAtIndex:seg.selectedIndex]objectAtIndex:sender.tag];
//        search.textColor = sender.titleLabel.textColor;
//    }
    
    search.text = [[hotKeyArr objectAtIndex:seg.selectedIndex]objectAtIndex:sender.tag];
    search.textColor = sender.titleLabel.textColor;
    [self searchAction];

 }

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [AppComManager cancalHandlesForObject:self];
    [TKLoadingView dismissTkFromView:self.navigationController.view animated:YES afterShow:0.0];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
    [search resignFirstResponder];
}

#pragma mark - UITextFieldDelegate

//-(BOOL)textFieldShouldReturn:(UITextField *)textField{
//    
//    [search resignFirstResponder];
//    return YES;
//    
//}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if(textField.returnKeyType == UIReturnKeyDone)
    {
        if(search.text.length){
            [self searchAction];

        }else{
            [search resignFirstResponder];
        }
    }
    return YES;
}

#pragma mark - BanBuDelegate

- (void)banbuRequestDidFinished:(NSDictionary *)resDic error:(NSError *)error{
    self.navigationController.view.userInteractionEnabled = YES;
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
        
        return;
    }
    NSLog(@"%@",resDic);

    if([AppComManager respondsDic:resDic isFunctionData:BanBu_Get_Sayhi_Hot]){
        NSMutableArray *textArr = [[NSMutableArray alloc]initWithCapacity:10];
        NSMutableArray *imageArr = [[NSMutableArray alloc]initWithCapacity:10];
        NSMutableArray *voiceArr = [[NSMutableArray alloc]initWithCapacity:10];
        
        for(NSString *nameAndTypeStr in [resDic objectForKey:@"list"]){
            
            NSArray *separateArr = [nameAndTypeStr componentsSeparatedByString:@"-"];
            NSString *lastStr = [separateArr objectAtIndex:1];
            if([lastStr isEqualToString:@"0"]){
                
                [textArr addObject:[separateArr objectAtIndex:0]];
                
            }else if([lastStr isEqualToString:@"1"]){
                
                [imageArr addObject:[separateArr objectAtIndex:0]];
                
            }else if([lastStr isEqualToString:@"2"]){
                
                [voiceArr addObject:[separateArr objectAtIndex:0]];
                
            }
        }
        [hotKeyArr removeAllObjects];
        [hotKeyArr addObjectsFromArray:[NSArray arrayWithObjects:textArr,imageArr,voiceArr, nil]];
        [self buildHotKeyButton:seg.selectedIndex];
        [textArr release];
        [imageArr release];
        [voiceArr release];
        //        NSLog(@"%@",hotKeyArr);
    }
    else if([AppComManager respondsDic:resDic isFunctionData:BanBu_Get_Sayhi_Rand]){
        if([[resDic valueForKey:@"ok"]boolValue]){
            if(seg.selectedIndex == 1){
                NSArray *typeArr = [NSArray arrayWithObjects:@"text",@"image",@"sound", nil];
                NSMutableDictionary *parDic = [NSMutableDictionary dictionary];
                [parDic setValue:[typeArr objectAtIndex:seg.selectedIndex] forKey:@"kind"];
                [parDic setValue:search.text forKey:@"keyword"];
                [parDic setValue:langauageStr forKey:@"country"];

                BanBu_icePicController *pic = [[BanBu_icePicController alloc]initWithDictionary:resDic];
                if(![[parDic valueForKey:@"keyword"] isEqualToString:@""]){
                    pic.title =[NSString stringWithFormat:@"%@%@",@"搜索-",[parDic valueForKey:@"keyword"]];
                    
                }
                
                pic.parDic = parDic;
                
                [self.navigationController pushViewController:pic animated:YES];
                [pic release];
            }
            
        }else{
            [TKLoadingView showTkloadingAddedTo:self.navigationController.view title:[MyAppDataManager IsInternationalLanguage:[resDic valueForKey:@"error"]] activityAnimated:NO duration:1.0];
            
        }
        
    }


}













@end
