//
//  BanBu_BloodTypeAndHeightController.m
//  BanBu
//
//  Created by 17xy on 12-8-6.
//
//

#import "BanBu_BloodTypeAndHeightController.h"
#import "BanBu_BirthdayViewController.h"
#import "AppDataManager.h"
#import "TKLoadingView.h"
@interface BanBu_BloodTypeAndHeightController ()

@end

@implementation BanBu_BloodTypeAndHeightController

- (id)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

//    self.view.backgroundView = nil;
    self.view.backgroundColor = [UIColor colorWithRed:255.0/255 green:250.0/255 blue:240.0/255 alpha:1.0];
    self.title = NSLocalizedString(@"bodyAndBloodTitle", nil);
    
    UIButton *nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
    nextButton.frame=CGRectMake(0, 0, 60, 30);
    [nextButton addTarget:self action:@selector(nextStep:) forControlEvents:UIControlEventTouchUpInside];
    [nextButton setBackgroundImage:[[UIImage imageNamed:@"app_nav_btn_bg1.png"] stretchableImageWithLeftCapWidth:15.0 topCapHeight:15.0] forState:UIControlStateNormal];
    [nextButton setBackgroundImage:[[UIImage imageNamed:@"app_nav_btn_bg2.png"] stretchableImageWithLeftCapWidth:15.0 topCapHeight:15.0] forState:UIControlStateHighlighted];
    [nextButton setTitleEdgeInsets:UIEdgeInsetsMake(3, 2, 2, 2)];
    [nextButton setTitle:NSLocalizedString(@"nextButton", nil) forState:UIControlStateNormal];
    nextButton.titleLabel.font = [UIFont systemFontOfSize:14];
    UIBarButtonItem *next = [[[UIBarButtonItem alloc] initWithCustomView:nextButton] autorelease];
    self.navigationItem.rightBarButtonItem = next;
    
    UILabel *heightLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 15, 320, 20)];
    heightLabel.backgroundColor = [UIColor clearColor];
    heightLabel.textAlignment = UITextAlignmentLeft;
    heightLabel.textColor = [UIColor darkGrayColor];
    heightLabel.font = [UIFont boldSystemFontOfSize:16];
    heightLabel.text = NSLocalizedString(@"heightLabel", nil);
    [self.view addSubview:heightLabel];
    [heightLabel release];
    
    NSArray *items = [NSArray arrayWithObjects:
					  @"<160",@"160-165",@"165-170",@"170-175",@">175",nil];
	SVSegmentedControl *seg = [[SVSegmentedControl alloc] initWithSectionTitles:items];

//    seg.backgroundColor = [UIColor colorWithWhite:0 alpha:.7];
    seg.center = CGPointMake(160, 55);
	seg.crossFadeLabelsOnDrag = YES;
//	seg.thumb.tintColor = [UIColor colorWithRed:0.6 green:0.2 blue:0.2 alpha:1];
    seg.thumb.tintColor = [UIColor colorWithWhite:0 alpha:.3];
    seg.backgroundColor = [UIColor colorWithWhite:0 alpha:.2];
	seg.selectedIndex = 0;
    _heightSeg = seg;
    [seg addTarget:self action:@selector(segmentedControlDidChangeValue:) forControlEvents:UIControlEventValueChanged];
	[self.view addSubview:seg];
    [seg release];
    
    UILabel *bloodLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 85, 320, 20)];
    bloodLabel.backgroundColor = [UIColor clearColor];
    bloodLabel.textAlignment = UITextAlignmentLeft;
    bloodLabel.textColor = [UIColor darkGrayColor];
    bloodLabel.font = [UIFont boldSystemFontOfSize:16];
    bloodLabel.text = NSLocalizedString(@"bloodLabel", nil);
    [self.view addSubview:bloodLabel];
    [bloodLabel release];

    SVSegmentedControl *seg1 = [[SVSegmentedControl alloc] initWithSectionTitles:[NSArray arrayWithObjects:@"A",@"B",@"O",@"AB",nil]];
//    seg1.backgroundColor = [UIColor colorWithWhite:0 alpha:.7];
    seg1.center = CGPointMake(160, 125);
    seg1.crossFadeLabelsOnDrag = YES;
    seg1.selectedIndex = 0;
//    seg1.thumb.tintColor = [UIColor colorWithRed:0.6 green:0.2 blue:0.2 alpha:1];
    seg1.thumb.tintColor = [UIColor colorWithWhite:0 alpha:.3];
    seg1.backgroundColor = [UIColor colorWithWhite:0 alpha:.2];
    _bloodtypeSeg = seg1;
    [seg1 addTarget:self action:@selector(segmentedControlDidChangeValue:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:seg1];
    [seg1 release];
    
    UILabel *wightLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 155, 320, 20)];
    wightLabel.backgroundColor = [UIColor clearColor];
    wightLabel.textAlignment = UITextAlignmentLeft;
    wightLabel.textColor = [UIColor darkGrayColor];
    wightLabel.font = [UIFont boldSystemFontOfSize:16];
    wightLabel.text = NSLocalizedString(@"wightLabel", nil);
    [self.view addSubview:wightLabel];
    [wightLabel release];
    
    SVSegmentedControl *seg2 = [[SVSegmentedControl alloc] initWithSectionTitles:[NSArray arrayWithObjects:@"<40",@"40-50",@"50-60",@"60-70",@">70",nil]];
//    seg2.backgroundColor = [UIColor colorWithWhite:0 alpha:.7];
    seg2.center = CGPointMake(160, 195);
    seg2.crossFadeLabelsOnDrag = YES;
    seg2.selectedIndex = 0;
//    seg2.thumb.tintColor = [UIColor colorWithRed:0.6 green:0.2 blue:0.2 alpha:1];
    seg2.thumb.tintColor = [UIColor colorWithWhite:0 alpha:.3];
    seg2.backgroundColor = [UIColor colorWithWhite:0 alpha:.2];
    _wightSeg = seg2;
    [seg2 addTarget:self action:@selector(segmentedControlDidChangeValue:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:seg2];
    [seg2 release];
    
//    NSArray *items = [NSArray arrayWithObjects:
//					  @"小于160",@"160-165",@"165-170",@"170-175",@"大于175",nil];
//	SVSegmentedControl *seg = [[SVSegmentedControl alloc] initWithSectionTitles:items];
//    seg.backgroundColor = [UIColor colorWithWhite:0 alpha:.7];
//    seg.center = CGPointMake(160, 30);
//	seg.crossFadeLabelsOnDrag = YES;
//	seg.thumb.tintColor = [UIColor colorWithRed:0.6 green:0.2 blue:0.2 alpha:1];
//	seg.selectedIndex = 0;
//    _heightSeg = seg;
//    [seg addTarget:self action:@selector(segmentedControlDidChangeValue:) forControlEvents:UIControlEventValueChanged];
//	[self.view addSubview:seg];
//    [seg release];
//    
//    UILabel *heightLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 50, 320, 20)];
//    heightLabel.backgroundColor = [UIColor clearColor];
//    heightLabel.textAlignment = UITextAlignmentCenter;
//    heightLabel.textColor = [UIColor darkGrayColor];
//    heightLabel.font = [UIFont boldSystemFontOfSize:16];
//    heightLabel.text = @"请选择的您的身高";
//    [self.view addSubview:heightLabel];
//    [heightLabel release];
//    
//    SVSegmentedControl *seg1 = [[SVSegmentedControl alloc] initWithSectionTitles:[NSArray arrayWithObjects:@"A型",@"B型",@"O型",@"AB型",@"其他",nil]];
//    seg1.backgroundColor = [UIColor colorWithWhite:0 alpha:.7];
//    seg1.center = CGPointMake(160, 90);
//    seg1.crossFadeLabelsOnDrag = YES;
//    seg1.selectedIndex = 0;
//    seg1.thumb.tintColor = [UIColor colorWithRed:0.6 green:0.2 blue:0.2 alpha:1];
//    _bloodtypeSeg = seg1;
//    [seg1 addTarget:self action:@selector(segmentedControlDidChangeValue:) forControlEvents:UIControlEventValueChanged];
//    [self.view addSubview:seg1];
//    [seg1 release];
//    
//    UILabel *bloodLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 110, 320, 20)];
//    bloodLabel.backgroundColor = [UIColor clearColor];
//    bloodLabel.textAlignment = UITextAlignmentCenter;
//    bloodLabel.textColor = [UIColor darkGrayColor];
//    bloodLabel.font = [UIFont boldSystemFontOfSize:16];
//    bloodLabel.text = @"请选择的您的血型";
//    [self.view addSubview:bloodLabel];
//    [bloodLabel release];
//    
//    
//    SVSegmentedControl *seg2 = [[SVSegmentedControl alloc] initWithSectionTitles:[NSArray arrayWithObjects:@"<40kg",@"40-50kg",@"50-60kg",@"60-70kg",@">70kg",nil]];
//    seg2.backgroundColor = [UIColor colorWithWhite:0 alpha:.7];
//    seg2.center = CGPointMake(160, 150);
//    seg2.crossFadeLabelsOnDrag = YES;
//    seg2.selectedIndex = 0;
//    seg2.thumb.tintColor = [UIColor colorWithRed:0.6 green:0.2 blue:0.2 alpha:1];
//    _wightSeg = seg2;
//    [seg2 addTarget:self action:@selector(segmentedControlDidChangeValue:) forControlEvents:UIControlEventValueChanged];
//    [self.view addSubview:seg2];
//    [seg2 release];
//    
//    UILabel *wightLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 170, 320, 20)];
//    wightLabel.backgroundColor = [UIColor clearColor];
//    wightLabel.textAlignment = UITextAlignmentCenter;
//    wightLabel.textColor = [UIColor darkGrayColor];
//    wightLabel.font = [UIFont boldSystemFontOfSize:16];
//    wightLabel.text = @"请选择的您的体重";
//    [self.view addSubview:wightLabel];
//    [wightLabel release];
    
    //读取写过的数据
//    if(MyAppDataManager.regDic){
//        
//    }else{
//        seg.selectedIndex =1;
//        
//    }
}

- (void)segmentedControlDidChangeValue:(UISegmentedControl *)seg
{
//    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"小提示"
//                                                    message:@"请确定你的选择，一旦提交无法更改！" delegate:nil
//                                          cancelButtonTitle:@"确定"
//                                          otherButtonTitles:nil, nil];
//    [alert show];
//    [alert release];

    [TKLoadingView showTkloadingAddedTo:self.view point:CGPointMake(0, 230) title:NSLocalizedString(@"changeNotice", nil) activityAnimated:NO duration:1.0];

    
}

- (void)nextStep:(UIButton *)button
{
    NSString *typeStr = @"abocx";
    [MyAppDataManager.regDic setValue:[typeStr substringWithRange:NSMakeRange(_bloodtypeSeg.selectedIndex, 1)] forKey:@"blood"];
    NSString *hStr = @"abcde";
    [MyAppDataManager.regDic setValue:[hStr substringWithRange:NSMakeRange(_heightSeg.selectedIndex, 1)] forKey:@"hbody"];
    NSString *wStr = @"abcde";
    [MyAppDataManager.regDic setValue:[wStr substringWithRange:NSMakeRange(_heightSeg.selectedIndex, 1)] forKey:@"wbody"];
    
    BanBu_BirthdayViewController *birthday = [[BanBu_BirthdayViewController alloc] init];
    [self.navigationController pushViewController:birthday animated:YES];
    [birthday release];
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

@end
