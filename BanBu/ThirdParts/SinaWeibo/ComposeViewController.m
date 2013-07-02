//
//  ComposeViewController.m
//  SinaWeiboOAuthDemo
//
//  Created by junmin liu on 11-1-4.
//  Copyright 2011 Openlab. All rights reserved.
//

#import "ComposeViewController.h"
#import "Colors.h"

 

@interface ComposeViewController (Private)

- (void)postNewStatus;
- (void)removeCachedOAuthDataForUsername:(NSString *) username;


@end

@implementation ComposeViewController
@synthesize btnSend, btnCancel, sendImageView;
@synthesize messageTextField;


- (id)initWithText:(NSString *)text image:(UIImage *)image {
    self = [super init];
    if (self) {
        _text = [text retain];
		_sendImage = [image retain];
    }
    return self;
}



// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	[[NSNotificationCenter defaultCenter] addObserver:self 
											 selector:@selector(textChanged:) 
												 name:UITextViewTextDidChangeNotification 
											   object:messageTextField];
    for(UIToolbar *bar in self.view.subviews)
        if([bar isKindOfClass:[UIToolbar class]])
            bar.tintColor = NavTintColor;
	UIView *aView = (UIView *)[self.view viewWithTag:222];
    aView.backgroundColor = NavTintColor;
	_statue = (UILabel *)[aView viewWithTag:223];
	_info = (UILabel *)[aView viewWithTag:224];
	messageTextField.text = _text;
	sendImageView.image = _sendImage;
	[_text release];
	[_sendImage release];
	_info.text = [NSString stringWithFormat:@"您还可以输入%i个字",140-messageTextField.text.length];
	_statue.text = nil;
	[messageTextField becomeFirstResponder];
	if(messageTextField.text.length)
		btnSend.enabled = YES;
    
[[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardShowNotify:) name:UIKeyboardDidShowNotification object:nil];	
	
}

- (void)keyboardShowNotify:(NSNotification *)notification
{
    //216   252
    CGSize kbSize = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size; 
    
    [UIView beginAnimations:@"fit" context:nil];
    [UIView setAnimationDuration:0.4];
    CGRect rect = _statue.superview.frame;
    CGRect rect1 = sendImageView.frame;
    float dis = rect.origin.y - rect1.origin.y;
    rect.origin.y = 430 - kbSize.height;
    _statue.superview.frame = rect;
    rect1.origin.y = rect.origin.y - dis;
    sendImageView.frame = rect1;
    
    [UIView commitAnimations];
}


/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

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
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidShowNotification object:nil];
    
	[messageTextField release];
	[btnSend release];
	[btnCancel release];
	[sendImageView release];
	
	[_engine release];
	[draft release];
    [super dealloc];
}

- (IBAction)send:(id)sender {
	[self postNewStatus];
}

- (IBAction)cancel:(id)sender {
	messageTextField.text = nil;
	sendImageView.image = nil;
	[self dismissModalViewControllerAnimated:YES];
}


- (void)viewDidAppear:(BOOL)animated {

	if (!_engine){
		_engine = [[OAuthEngine alloc] initOAuthWithDelegate: self];
		_engine.consumerKey = kOAuthConsumerKey;
		_engine.consumerSecret = kOAuthConsumerSecret;
	}
	
	UIViewController *controller = [OAuthController controllerToEnterCredentialsWithEngine: _engine delegate: self];
	if (controller) 
	{
		[user removeObjectForKey:@"sinaUser"];
		[user synchronize];
		_authorized = NO;
	}
	else 
		_authorized = YES;
	_statue.text = _authorized?[user valueForKey:@"sinaUser"]:@"未绑定";
	
}

- (void)textChanged:(NSNotification *)notification{
	int maxLength = 140;
	btnSend.enabled = messageTextField.text.length > 0;
	if (messageTextField.text.length >= maxLength)
    {
        messageTextField.text = [messageTextField.text substringToIndex:maxLength];
    }
	_info.text = [NSString stringWithFormat:@"您还可以输入%i个字",maxLength-messageTextField.text.length];
	//draft.text = messageTextField.text;
}

- (void)newTweet {
	[draft release];
	draft = [[Draft alloc]initWithType:DraftTypeNewTweet];
}

- (void)postNewStatus
{
	if(!_authorized)
	{
		UIViewController *controller = [OAuthController controllerToEnterCredentialsWithEngine: _engine delegate: self];
		[self presentModalViewController: controller animated: YES];
		return;
	}
	draft.text = messageTextField.text;
	draft.attachmentImage = sendImageView.image;
	WeiboClient *weiboClient = [[WeiboClient alloc] initWithTarget:self 
															engine:_engine
															action:@selector(postStatusDidSucceed:obj:)];
	weiboClient.context = [draft retain];
	draft.draftStatus = DraftStatusSending;
	if (draft.attachmentImage) {
		[weiboClient upload:draft.attachmentData status:draft.text];
	}
	else {
		[weiboClient post:draft.text];
	}
	[TKLoadingView showTkloadingAddedTo:self.view title:@"正在发送……" activityAnimated:YES];
}

- (void)postStatusDidSucceed:(WeiboClient*)sender obj:(NSObject*)obj;
{
	[TKLoadingView dismissTkFromView:self.view animated:YES afterShow:0.0f];
	Draft *sentDraft = nil;
	if (sender.context && [sender.context isKindOfClass:[Draft class]]) {
		sentDraft = (Draft *)sender.context;
		[sentDraft autorelease];
	}
	
    if (sender.hasError) {
        [sender alert];	
        return;
    }
    
    NSDictionary *dic = nil;
    if (obj && [obj isKindOfClass:[NSDictionary class]]) {
        dic = (NSDictionary*)obj;    
    }
	
    if (dic) {
        Status* sts = [Status statusWithJsonDictionary:dic];
		if (sts) {
			//delete draft!
			if (sentDraft) {
				
			}
		}
    }
	[self cancel:nil];
	
}

#pragma mark OAuthEngineDelegate
- (void) storeCachedOAuthData: (NSString *) data forUsername: (NSString *) username {
	
	[user setObject: data forKey: @"authData"];
	[user synchronize];
}

- (NSString *) cachedOAuthDataForUsername: (NSString *) username {
	return [user objectForKey: @"authData"];
	
}

- (void)removeCachedOAuthDataForUsername:(NSString *) username{
	
	[user removeObjectForKey: @"authData"];
	[user removeObjectForKey:@"sinaUser"];
	[user synchronize];
}
//=============================================================================================================================
#pragma mark OAuthSinaWeiboControllerDelegate
- (void) OAuthController: (OAuthController *) controller authenticatedWithUsername: (NSString *) username {
	NSLog(@"Authenicated for %@", username);
	
}

- (void) OAuthControllerFailed: (OAuthController *) controller {
	NSLog(@"Authentication Failed!");
	//UIViewController *controller = [OAuthController controllerToEnterCredentialsWithEngine: _engine delegate: self];
	
	if (controller) 
        [self dismissModalViewControllerAnimated:YES];
	
}

- (void) OAuthControllerCanceled: (OAuthController *) controller {
	NSLog(@"Authentication Canceled.");
	//UIViewController *controller = [OAuthController controllerToEnterCredentialsWithEngine: _engine delegate: self];
	
	if (controller) 
        [self dismissModalViewControllerAnimated:YES];
	
}


@end
