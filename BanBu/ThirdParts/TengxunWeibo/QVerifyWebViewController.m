//
//  QVerifyWebViewController.m
//  QWeiboSDK4iOSDemo
//
//  Created   on 11-1-14.
//   
//

#import "QVerifyWebViewController.h"
#import "QweiboViewController.h"
#import "Colors.h"
#import "AppDataManager.h"
#import "AppCommunicationManager.h"

@implementation QVerifyWebViewController

@synthesize QwebView = _QwebView;
@synthesize navBar = _navBar;
@synthesize tokenKey = _tokenKey;
@synthesize tokenSecret = _tokenSecret;


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
	_navBar.tintColor = NavTintColor;
	UIImageView *navBk = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"topbar.png"]];
	[_navBar addSubview:navBk];
	[navBk release];
    
    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelButton.frame=CGRectMake(0, 0, 50, 30);
    [cancelButton addTarget:self action:@selector(cancel:) forControlEvents:UIControlEventTouchUpInside];
    [cancelButton setBackgroundImage:[[UIImage imageNamed:@"app_nav_btn_bg1.png"] stretchableImageWithLeftCapWidth:15.0 topCapHeight:15.0] forState:UIControlStateNormal];
    [cancelButton setBackgroundImage:[[UIImage imageNamed:@"app_nav_btn_bg2.png"] stretchableImageWithLeftCapWidth:15.0 topCapHeight:15.0] forState:UIControlStateHighlighted];
    [cancelButton setTitleEdgeInsets:UIEdgeInsetsMake(3, 2, 2, 2)];
    [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    cancelButton.titleLabel.font = [UIFont systemFontOfSize:13];
    UIBarButtonItem *cancel = [[[UIBarButtonItem alloc] initWithCustomView:cancelButton] autorelease];
    
    
	UINavigationItem *navItem = [[[UINavigationItem alloc] initWithTitle: NSLocalizedString(@"腾讯微博授权", nil)] autorelease];
	navItem.leftBarButtonItem = cancel;
	[_navBar pushNavigationItem: navItem animated: NO];


	_authorized = NO;
	self.QwebView.delegate = self;
	self.QwebView.backgroundColor = [UIColor colorWithRed:236.0f/255.0f green:245.0f/255.0f blue:250.0f/255.0f alpha:1.0f];
	self.QwebView.opaque = NO;
    [TKLoadingView showTkloadingAddedTo:_QwebView title:@"验证数据……" activityAnimated:YES];

}


-(void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];
	
	QWeiboSyncApi *api = [[[QWeiboSyncApi alloc] init] autorelease];
	NSString *retString = [api getRequestTokenWithConsumerKey:AppKey consumerSecret:AppSecret];
//NSLog(@"Get requestToken:%@", retString);
	[self parseTokenKeyWithResponse:retString];
	
	NSString *url = [NSString stringWithFormat:@"%@%@", VERIFY_URL, _tokenKey];
	NSURL *requestUrl = [NSURL URLWithString:url];
	NSURLRequest *request = [NSURLRequest requestWithURL:requestUrl];
	[_QwebView loadRequest:request];

}


- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
	[_tokenKey release];
	[_tokenSecret release];
	[_QwebView release];
    [super dealloc];
}

#pragma mark -
#pragma mark private methods

-(NSString*) valueForKey:(NSString *)key ofQuery:(NSString*)query
{
	NSArray *pairs = [query componentsSeparatedByString:@"&"];
	for(NSString *aPair in pairs){
		NSArray *keyAndValue = [aPair componentsSeparatedByString:@"="];
		if([keyAndValue count] != 2) continue;
		if([[keyAndValue objectAtIndex:0] isEqualToString:key]){
			return [keyAndValue objectAtIndex:1];
		}
	}
	return nil;
}

#pragma mark -
#pragma mark UIWebViewDelegate

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    //NSLog(@"start%@",[webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.outerHTML;"]);
	NSString *query = [[request URL] query];
	NSString *verifier = [self valueForKey:@"oauth_verifier" ofQuery:query];
	[TKLoadingView showTkloadingAddedTo:webView title:@"请稍后……" activityAnimated:YES];

	if (verifier && ![verifier isEqualToString:@""]) {
		
		QWeiboSyncApi *api = [[[QWeiboSyncApi alloc] init] autorelease];
		NSString *retString = [api getAccessTokenWithConsumerKey:AppKey 
												  consumerSecret:AppSecret 
												 requestTokenKey:_tokenKey 
											  requestTokenSecret:_tokenSecret 
														  verify:verifier];
		[self parseTokenKeyWithResponse:retString];
		[self saveDefaultKey];
        NSString *userName = [retString substringFromIndex:[retString rangeOfString:@"name="].location+5];
		[UserDefaults setValue:userName forKey:@"QUser"];
		[UserDefaults synchronize];
        
        NSMutableDictionary *pars = [NSMutableDictionary dictionaryWithCapacity:2];
        [pars setValue:@"ten_weib" forKey:@"bindto"];
        [pars setValue:[NSString stringWithFormat:@"%@,%@,%@",[UserDefaults valueForKey:AppTokenKey],[UserDefaults valueForKey:AppTokenSecret],[user valueForKey:@"QUser"]] forKey:@"bindstring"];
        [AppComManager getBanBuData:BanBu_Set_User_accountbind par:pars delegate:self];
		[self dismissModalViewControllerAnimated:YES];
		
		return NO;
	}
	
	return YES;
}


- (void) webViewDidFinishLoad: (UIWebView *) webView {
    
	[TKLoadingView dismissTkFromView:webView animated:YES afterShow:0.0f];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
	for(TKLoadingView *loading in webView.subviews)
		if([loading isKindOfClass:[TKLoadingView class]])
		{
			[loading setActivityAnimating:NO withShowMsg:@"网络错误!"];
			[loading dismissAfterDelay:1.0 animated:YES];
			
		}
}

-(IBAction)cancel:(id)sender
{
	[_QwebView stopLoading];
	[self dismissModalViewControllerAnimated:YES];
    if([_delegate respondsToSelector:@selector(qVerifyWebViewControllerDidDismiss:)])
        [_delegate qVerifyWebViewControllerDidDismiss:self];
	
}

#pragma mark -
#pragma mark instance methods

- (void)parseTokenKeyWithResponse:(NSString *)aResponse {
	
	NSDictionary *params = [NSURL parseURLQueryString:aResponse];
	self.tokenKey = [params objectForKey:@"oauth_token"];
	self.tokenSecret = [params objectForKey:@"oauth_token_secret"];
	
}

- (void)saveDefaultKey {
	
	[[NSUserDefaults standardUserDefaults] setValue:AppKey forKey:AppKey];
	[[NSUserDefaults standardUserDefaults] setValue:AppSecret forKey:AppSecret];
	[[NSUserDefaults standardUserDefaults] setValue:_tokenKey forKey:AppTokenKey];
	[[NSUserDefaults standardUserDefaults] setValue:_tokenSecret forKey:AppTokenSecret];
	[[NSUserDefaults standardUserDefaults] synchronize];
}


@end
