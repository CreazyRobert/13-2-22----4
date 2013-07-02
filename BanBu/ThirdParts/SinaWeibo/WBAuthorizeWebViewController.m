//
//  WBAuthorizeWebView.m
//  SinaWeiBoSDK
//  Based on OAuth 2.0
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
//  EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
//  OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
//  NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
//  HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
//  WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
//  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
//  OTHER DEALINGS IN THE SOFTWARE.
//
//  Copyright 2011 Sina. All rights reserved.
//

#import "WBAuthorizeWebViewController.h"
#import <QuartzCore/QuartzCore.h> 
#import "Colors.h"
#import "TKLoadingView.h"


@interface WBAuthorizeWebViewController (Private)

- (void)addObservers;
- (void)removeObservers;

@end

@implementation WBAuthorizeWebViewController

@synthesize delegate;

#pragma mark - WBAuthorizeWebView Life Circle

- (id)init
{
    if (self = [super init])
    {
        self.title = @"新浪微博授权";
        
        UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        cancelButton.frame=CGRectMake(0, 0, 50, 30);
        [cancelButton addTarget:self action:@selector(dismiss:) forControlEvents:UIControlEventTouchUpInside];
        [cancelButton setBackgroundImage:[[UIImage imageNamed:@"app_nav_btn_bg1.png"] stretchableImageWithLeftCapWidth:15.0 topCapHeight:15.0] forState:UIControlStateNormal];
        [cancelButton setBackgroundImage:[[UIImage imageNamed:@"app_nav_btn_bg2.png"] stretchableImageWithLeftCapWidth:15.0 topCapHeight:15.0] forState:UIControlStateHighlighted];
        [cancelButton setTitleEdgeInsets:UIEdgeInsetsMake(3, 2, 2, 2)];
        [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        cancelButton.titleLabel.font = [UIFont systemFontOfSize:13];
        UIBarButtonItem *cancel = [[[UIBarButtonItem alloc] initWithCustomView:cancelButton] autorelease];
        
        self.navigationItem.leftBarButtonItem = cancel;
        
        // background settings
        [self.view setBackgroundColor:[UIColor clearColor]];
        [self.view setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
        
        
        // add the web view
        webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
		[webView setDelegate:self];
        [self.view addSubview:webView];
    }
    return self;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.navigationController.navigationBar.tintColor = NavTintColor;

    
}

- (void)dealloc
{
    [webView release], webView = nil;
    
    [super dealloc];
}

#pragma mark Actions

- (void)onCloseButtonTouched:(id)sender
{
    [self dismiss:YES];
}

#pragma mark Orientations

- (UIInterfaceOrientation)currentOrientation
{
    return [UIApplication sharedApplication].statusBarOrientation;
}


- (BOOL)shouldRotateToOrientation:(UIInterfaceOrientation)orientation 
{
	if (orientation == previousOrientation)
    {
		return NO;
	}
    else
    {
		return orientation == UIInterfaceOrientationLandscapeLeft
		|| orientation == UIInterfaceOrientationLandscapeRight
		|| orientation == UIInterfaceOrientationPortrait
		|| orientation == UIInterfaceOrientationPortraitUpsideDown;
	}
    return YES;
}

#pragma mark Obeservers

- (void)addObservers
{
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(deviceOrientationDidChange:)
												 name:@"UIDeviceOrientationDidChangeNotification" object:nil];
}

- (void)removeObservers
{
	[[NSNotificationCenter defaultCenter] removeObserver:self
													name:@"UIDeviceOrientationDidChangeNotification" object:nil];
}


#pragma mark - WBAuthorizeWebView Public Methods

- (void)loadRequestWithURL:(NSURL *)url
{
    NSURLRequest *request =[NSURLRequest requestWithURL:url
                                            cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                                        timeoutInterval:60.0];
    [webView loadRequest:request];
}


- (void)dismiss:(BOOL)animated;
{
	[self dismissModalViewControllerAnimated:animated];
}


#pragma mark - UIWebViewDelegate Methods

- (void)webViewDidStartLoad:(UIWebView *)aWebView
{
	[TKLoadingView showTkloadingAddedTo:self.navigationController.view title:@"加载中……" activityAnimated:YES];
    self.navigationItem.leftBarButtonItem.enabled = NO;
}

- (void)webViewDidFinishLoad:(UIWebView *)aWebView
{
    [TKLoadingView dismissTkFromView:self.navigationController.view animated:YES afterShow:0.0];
    self.navigationItem.leftBarButtonItem.enabled = YES;

}

- (void)webView:(UIWebView *)aWebView didFailLoadWithError:(NSError *)error
{
    [TKLoadingView showTkloadingAddedTo:self.navigationController.view title:@"加载失败!" activityAnimated:NO];
    [TKLoadingView dismissTkFromView:self.navigationController.view animated:YES afterShow:2.0];
    self.navigationItem.leftBarButtonItem.enabled = YES;

}

- (BOOL)webView:(UIWebView *)aWebView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{

    NSRange range = [request.URL.absoluteString rangeOfString:@"code="];
    
    if (range.location != NSNotFound)
    {
        NSString *code = [request.URL.absoluteString substringFromIndex:range.location + range.length];
        
        if ([delegate respondsToSelector:@selector(authorizeWebView:didReceiveAuthorizeCode:)])
        {
            [delegate authorizeWebView:self didReceiveAuthorizeCode:code];
        }
    }
    
    return YES;
}

@end
