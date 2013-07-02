//
//  BanBu_HelpViewController.m
//  BanBu
//
//  Created by apple on 12-11-23.
//
//

#import "BanBu_HelpViewController.h"

@interface BanBu_HelpViewController ()

@end

@implementation BanBu_HelpViewController

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
    
    self.title=NSLocalizedString(@"helpTitle", nil);
    
    // 移动社交只需半步
    
    UILabel *banbu=[[UILabel alloc]initWithFrame:CGRectMake(0, 150, 320, 42)];
    
    banbu.backgroundColor=[UIColor clearColor];
    banbu.textAlignment = UITextAlignmentCenter;
    [self.view addSubview:banbu];
    
    [banbu release];
    
    banbu.numberOfLines=0;
    banbu.font = [UIFont boldSystemFontOfSize:16];
    banbu.text= NSLocalizedString(@"propagandaTitle", nil);
    
    // 图标
    
    UIImageView *iconImage=[[UIImageView alloc]initWithFrame:CGRectMake(100, 30,120 , 120)];
    
    
    iconImage.image=[UIImage imageNamed:@"_256.png"];
    
    [self.view addSubview:iconImage];
    
    [iconImage release];
    
 
    // 详细描述
    
    
       
  NSString *string = NSLocalizedString(@"descripLabel", nil);
    
    CGSize size=[string sizeWithFont:[UIFont systemFontOfSize:16] constrainedToSize:CGSizeMake(280, 1000)];
    
    UILabel *descripLabel=[[UILabel alloc]initWithFrame:CGRectMake(20,165+42, 280,size.height)];
    
    descripLabel.backgroundColor=[UIColor clearColor];
    descripLabel.text=string;
    descripLabel.font = [UIFont systemFontOfSize:16];
    descripLabel.numberOfLines=0;

    [self.view addSubview:descripLabel];
    
    [descripLabel release];
    
   
    // uilable tips
    
    UILabel *tipsLabel=[[UILabel alloc]initWithFrame:CGRectMake(20, descripLabel.frame.origin.y+size.height, 280, 100)];
    
    tipsLabel.text= NSLocalizedString(@"tipsLabel", nil);
    tipsLabel.font = [UIFont systemFontOfSize:15];
    tipsLabel.numberOfLines=0;
    tipsLabel.backgroundColor=[UIColor clearColor];
    
    [self.view addSubview:tipsLabel];
    
    [tipsLabel release];
    
     
    NSString *appVersion = [[NSBundle mainBundle] objectForInfoDictionaryKey:(NSString *)kCFBundleVersionKey];
    UILabel *versionLabel = [[UILabel alloc]initWithFrame:CGRectMake(310-100, 0, 100, 30)];
    versionLabel.textAlignment = UITextAlignmentRight;
    versionLabel.backgroundColor = [UIColor clearColor];
    versionLabel.font = [UIFont systemFontOfSize:15];
    versionLabel.text = [NSString stringWithFormat:@"V%@",appVersion];
    [self.view addSubview:versionLabel];
    [versionLabel release];
    
    
    
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
