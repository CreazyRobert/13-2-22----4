//
//  BanBu_TwitterShare.m
//  BanBu
//
//  Created by Jc Zhang on 13-2-17.
//
//

#import "BanBu_TwitterShare.h"

@interface BanBu_TwitterShare ()

@end

@implementation BanBu_TwitterShare

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
    
    self.view.backgroundColor = [UIColor colorWithRed:255.0/255 green:250.0/255 blue:240.0/255 alpha:1.0];
    self.title = @"Twitter Info";
    UIButton *cancel = [UIButton buttonWithType:UIButtonTypeCustom];
    cancel.frame=CGRectMake(0, 0, 60, 30);
    [cancel addTarget:self action:@selector(cancel:) forControlEvents:UIControlEventTouchUpInside];
    [cancel setBackgroundImage:[[UIImage imageNamed:@"app_nav_btn_bg1.png"] stretchableImageWithLeftCapWidth:15.0 topCapHeight:15.0] forState:UIControlStateNormal];
    //    [cancel setBackgroundImage:[[UIImage imageNamed:@"app_nav_btn_bg2.png"] stretchableImageWithLeftCapWidth:15.0 topCapHeight:15.0] forState:UIControlStateHighlighted];
    [cancel setTitleEdgeInsets:UIEdgeInsetsMake(3, 2, 2, 2)];
    [cancel setTitle:@"cancel" forState:UIControlStateNormal];
    cancel.titleLabel.font = [UIFont systemFontOfSize:14];
    UIBarButtonItem *cancelItem = [[[UIBarButtonItem alloc] initWithCustomView:cancel] autorelease];
    self.navigationItem.leftBarButtonItem = cancelItem;
    
    
}

- (void)cancel:(UIButton *)button
{
    [self dismissModalViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
