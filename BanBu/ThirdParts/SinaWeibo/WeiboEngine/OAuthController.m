//
//  OAuthController.m
//  WeiboPad
//
//  Created by junmin liu on 10-10-5.
//  Copyright 2010 Openlab. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "OAuthController.h"
#import "OAuthEngine.h"
#import "Colors.h"

@interface OAuthController ()
@property (nonatomic, readwrite) UIInterfaceOrientation orientation;

- (id) initWithEngine: (OAuthEngine *) engine andOrientation:(UIInterfaceOrientation)theOrientation;
//- (void) performInjection;
- (NSString *) locateAuthPinInWebView: (UIWebView *) webView;

//- (void) showPinCopyPrompt;
- (void) gotPin: (NSString *) pin;
@end


@interface DummyClassForProvidingSetDataDetectorTypesMethod
- (void) setDataDetectorTypes: (int) types;
- (void) setDetectsPhoneNumbers: (BOOL) detects;
@end

@interface NSString (OAuth)
- (BOOL) oauth_isNumeric;
@end

@implementation NSString (OAuth)
- (BOOL) oauth_isNumeric {
	const char				*raw = (const char *) [self UTF8String];
	
	for (int i = 0; i < strlen(raw); i++) {
		if (raw[i] < '0' || raw[i] > '9') return NO;
	}
	return YES;
}
@end

@implementation OAuthController
@synthesize engine = _engine, delegate = _delegate, navigationBar = _navBar, orientation = _orientation;


- (void) dealloc {
	
	[[NSNotificationCenter defaultCenter] removeObserver: self];
	_webView.delegate = nil;
	[_webView loadRequest: [NSURLRequest requestWithURL: [NSURL URLWithString: @""]]];
	[_webView release];
	
	self.view = nil;
	self.engine = nil;
	[_userName release];
	[super dealloc];
}

+ (OAuthController *) controllerToEnterCredentialsWithEngine: (OAuthEngine *) engine delegate: (id <OAuthControllerDelegate>) delegate forOrientation: (UIInterfaceOrientation)theOrientation {
	if (![self credentialEntryRequiredWithEngine: engine]) return nil;			//not needed
	
	OAuthController					*controller = [[[OAuthController alloc] initWithEngine: engine andOrientation: theOrientation] autorelease];
	
	controller.delegate = delegate;
	return controller;
}

+ (OAuthController *) controllerToEnterCredentialsWithEngine: (OAuthEngine *) engine delegate: (id <OAuthControllerDelegate>) delegate {
	return [OAuthController controllerToEnterCredentialsWithEngine: engine delegate: delegate forOrientation: UIInterfaceOrientationPortrait];
}


+ (BOOL) credentialEntryRequiredWithEngine: (OAuthEngine *) engine {
	return ![engine isAuthorized];
}


- (id) initWithEngine: (OAuthEngine *) engine andOrientation:(UIInterfaceOrientation)theOrientation {
	if (self = [super init]) {
		self.engine = engine;
		if (!engine.OAuthSetup) [_engine requestRequestToken];
		self.orientation = theOrientation;
		_firstLoad = YES;
		
		
		[[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(pasteboardChanged:) name: UIPasteboardChangedNotification object: nil];
	}
	return self;
}

//=============================================================================================================================
#pragma mark Actions
- (void) denied {
	if ([_delegate respondsToSelector: @selector(OAuthControllerFailed:)]) [_delegate OAuthControllerFailed: self];
	[self performSelector: @selector(dismissModalViewControllerAnimated:) withObject: (id) kCFBooleanTrue afterDelay: 1.0];
}

- (void) gotPin: (NSString *) pin {
	_engine.pin = pin;
	[_engine requestAccessToken];
	
	if ([_delegate respondsToSelector: @selector(OAuthController:authenticatedWithUsername:)]) 
		[_delegate OAuthController: self authenticatedWithUsername: _engine.username];
	[self performSelector: @selector(dismissModalViewControllerAnimated:) withObject: (id) kCFBooleanTrue afterDelay: 1.0];
}

- (void) cancel: (id) sender {
	if ([_delegate respondsToSelector: @selector(OAuthControllerCanceled:)]) [_delegate OAuthControllerCanceled: self];
	[self performSelector: @selector(dismissModalViewControllerAnimated:) withObject: (id) kCFBooleanTrue afterDelay: 0.0];
}

//=============================================================================================================================
#pragma mark View Controller Stuff
- (void) loadView {
	[super loadView];
	self.view = [[[UIView alloc] initWithFrame: ApplicationFrame(self.orientation)] autorelease];
	_navBar = [[[UINavigationBar alloc] initWithFrame: CGRectMake(0, 0, self.view.frame.size.width, 44)] autorelease];
	
	_navBar.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin;
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
    
    
	UINavigationItem *navItem = [[[UINavigationItem alloc] initWithTitle: NSLocalizedString(@"新浪微博授权", nil)] autorelease];
	navItem.leftBarButtonItem = cancel;
	[_navBar pushNavigationItem: navItem animated: NO];
	
    self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	CGRect frame = ApplicationFrame(self.orientation);
	frame.origin.y = 44;
	frame.size.height -= 44;
	_webView = [[UIWebView alloc] initWithFrame: ApplicationFrame(self.orientation)];
	_webView.delegate = self;
	_webView.backgroundColor = [UIColor colorWithRed:236.0f/255.0f green:245.0f/255.0f blue:250.0f/255.0f alpha:1.0f];
	_webView.opaque = NO;
	//_webView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	if ([_webView respondsToSelector: @selector(setDetectsPhoneNumbers:)]) [(id) _webView setDetectsPhoneNumbers: NO];
	if ([_webView respondsToSelector: @selector(setDataDetectorTypes:)]) [(id) _webView setDataDetectorTypes: 0];
	
	NSURLRequest			*request = _engine.authorizeURLRequest;
	[_webView loadRequest: request];
	
	[self.view addSubview: _webView];
	[self.view addSubview: _navBar];
	
	[self locateAuthPinInWebView: nil];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return NO;
}


//=============================================================================================================================
#pragma mark Notifications
- (void) pasteboardChanged: (NSNotification *) note {
	UIPasteboard					*pb = [UIPasteboard generalPasteboard];
	
	if ([note.userInfo objectForKey: UIPasteboardChangedTypesAddedKey] == nil) return;		//no meaningful change
	
	NSString *copied = pb.string;
	
	if (copied.length != 6 || !copied.oauth_isNumeric) return;
	
	[self gotPin: copied];
}

//=============================================================================================================================
#pragma mark Webview Delegate stuff
- (void) webViewDidFinishLoad: (UIWebView *) webView {
	NSString *authPin = [self locateAuthPinInWebView: webView];
	
	if (authPin.length) {
		[self gotPin: authPin];
		[user setValue:_userName forKey:@"sinaUser"];
		[user synchronize];
		return;
	}
	
	[TKLoadingView dismissTkFromView:_webView animated:YES afterShow:0.0f];
	[UIView beginAnimations: nil context: nil];
	[UIView commitAnimations];
	

}


/*********************************************************************************************************
 I am fully aware that this code is chock full 'o flunk. That said:
 
 - first we check, using standard DOM-diving, for the pin, looking at both the old and new tags for it.
 - if not found, we try a regex for it. This did not work for me (though it did work in test web pages).
 - if STILL not found, we iterate the entire HTML and look for an all-numeric 'word', 7 characters in length
 
 Ugly. I apologize for its inelegance. Bleah.
 
 *********************************************************************************************************/

- (NSString *) locateAuthPinInWebView: (UIWebView *) webView {
    
    NSString *pin;
	
	NSString			*html = [webView stringByEvaluatingJavaScriptFromString: @"document.body.innerText"];
	//NSLog(@"html:%@", [webView stringByEvaluatingJavaScriptFromString: @"document.body.innerHTML"]);
	
	if (html.length == 0) return nil;
	
	const char			*rawHTML = (const char *) [html UTF8String];
	int					length = strlen(rawHTML), chunkLength = 0;
	
	for (int i = 0; i < length; i++) {
		if (rawHTML[i] < '0' || rawHTML[i] > '9') {
			if (chunkLength == 6) {
				char				*buffer = (char *) malloc(chunkLength + 1);
				
				memmove(buffer, &rawHTML[i - chunkLength], chunkLength);
				buffer[chunkLength] = 0;
				
				pin = [NSString stringWithUTF8String: buffer];
				free(buffer);
				return pin;
			}
			chunkLength = 0;
		} else
			chunkLength++;
	}
	
	return nil;
}


- (void) webViewDidStartLoad: (UIWebView *) webView {
	
	[TKLoadingView showTkloadingAddedTo:_webView title:@"请稍后……" activityAnimated:YES];
}


- (BOOL) webView: (UIWebView *) webView shouldStartLoadWithRequest: (NSURLRequest *) request navigationType: (UIWebViewNavigationType) navigationType {

	NSData				*data = [request HTTPBody];
	char				*raw = data ? (char *) [data bytes] : "";
	NSString *userName = [webView stringByEvaluatingJavaScriptFromString:@"document.getElementById('userId').value;"];
	if(userName)
	{
		[_userName release];
		_userName = [userName retain];
	}
	if (raw && strstr(raw, "cancel=")) {
		[self denied];
		return NO;
	}
	return YES;
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
	[TKLoadingView showTkloadingAddedTo:_webView title:@"出错了！" activityAnimated:NO];
	[TKLoadingView dismissTkFromView:_webView animated:YES afterShow:1.5f];
}

@end
