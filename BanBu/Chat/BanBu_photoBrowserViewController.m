//
//  BanBu_photoBrowserViewController.m
//  BanBu
//
//  Created by apple on 12-12-13.
//
//

#import "BanBu_photoBrowserViewController.h"

@interface BanBu_photoBrowserViewController ()

@end

@implementation BanBu_photoBrowserViewController

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
    UIBarButtonItem *sendButton = [[[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"sendReply", nil) style:UIBarButtonItemStylePlain target:self action:@selector(sendButtonPressed:)] autorelease];
    // Set appearance
    if ([UIBarButtonItem respondsToSelector:@selector(appearance)]) {
        [sendButton setBackgroundImage:nil forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
        [sendButton setBackgroundImage:nil forState:UIControlStateNormal barMetrics:UIBarMetricsLandscapePhone];
        [sendButton setBackgroundImage:nil forState:UIControlStateHighlighted barMetrics:UIBarMetricsDefault];
        [sendButton setBackgroundImage:nil forState:UIControlStateHighlighted barMetrics:UIBarMetricsLandscapePhone];
        [sendButton setTitleTextAttributes:[NSDictionary dictionary] forState:UIControlStateNormal];
        [sendButton setTitleTextAttributes:[NSDictionary dictionary] forState:UIControlStateHighlighted];
    }
    self.navigationItem.rightBarButtonItem = sendButton;

    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
