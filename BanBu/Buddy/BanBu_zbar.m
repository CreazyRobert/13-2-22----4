//
//  BanBu_zbar.m
//  BanBu
//
//  Created by apple on 12-10-25.
//
//

#import "BanBu_zbar.h"

@interface BanBu_zbar ()

@end

@implementation BanBu_zbar
@synthesize showScrollView=_showScrollView,receiveString=_receiveString;
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

    
  
    UIScrollView *scrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, 320, 480)];
    
    scrollView.contentSize=CGSizeMake(320, 480);
    
    _showScrollView=scrollView;
   
    scrollView.scrollEnabled=YES;

    scrollView.backgroundColor=[UIColor whiteColor];
    
    scrollView.bounces=YES;
    
    scrollView.pagingEnabled = YES;
    
    scrollView.delegate=self;
    
    scrollView.showsHorizontalScrollIndicator=YES;
    scrollView.showsVerticalScrollIndicator=YES;
    
    [self.view addSubview:scrollView];
     
    [scrollView release];
    
    
    // ui
    
    UILabel *showLabel=[[UILabel alloc]initWithFrame:CGRectMake(10, 0, 30, 60)];
    
    CGSize size=[MyAppDataManager.zibarString sizeWithFont:[UIFont systemFontOfSize:13] constrainedToSize:CGSizeMake(300, 200) lineBreakMode:UILineBreakModeCharacterWrap ];
    

    showLabel.frame=CGRectMake(10, 0, 300, size.width);
    
    showLabel.numberOfLines=0;
    
    showLabel.text=MyAppDataManager.zibarString;
    
    showLabel.backgroundColor=[UIColor clearColor];
    
    showLabel.textColor=[UIColor blackColor];
    
    
    [scrollView addSubview:showLabel];
    
    [showLabel release];
    



}

- (void)viewDidUnload
{
   // [_showScrollView release];
    
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void)dealloc
{
   /* [_showScrollView release];
    
*/    [super dealloc];
}

@end
