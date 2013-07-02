//
//  BanBu_UserAgreement.m
//  BanBu
//
//  Created by Jc Zhang on 12-12-18.
//
//

#import "BanBu_UserAgreement.h"

@interface BanBu_UserAgreement ()

@end

@implementation BanBu_UserAgreement

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

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.navigationItem.title = NSLocalizedString(@"userAgreeTitle", nil);
    self.view.backgroundColor = [UIColor whiteColor];
    UIWebView *aWeb = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, 320, __MainScreen_Height-44)];
    aWeb.backgroundColor =  [UIColor colorWithRed:255.0/255 green:250.0/255 blue:240.0/255 alpha:1.0];
    [aWeb setOpaque:NO];
    [self.view addSubview:aWeb];
    [aWeb release];
    NSString *filePath;
    NSString *langauage=[self getPreferredLanguage];
    if([langauage isEqual:@"zh-Hans"])
    {
        filePath =[[NSBundle mainBundle] pathForResource:@"license_cn" ofType:@"html"];
    }else if([langauage isEqual:@"ja"]){
        filePath =[[NSBundle mainBundle] pathForResource:@"license_ja" ofType:@"html"];

    }
    else
    {
        filePath = [[NSBundle mainBundle] pathForResource:@"license_en" ofType:@"html"];
    }
    [aWeb loadRequest:[NSURLRequest requestWithURL:[NSURL fileURLWithPath: filePath]]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
