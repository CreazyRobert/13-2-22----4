//
//  QweiboViewController.m
//  ToadyIsFree
//
//  Created by apple on 11-10-12.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "QweiboViewController.h"
#import "Colors.h"



@implementation QweiboViewController

@synthesize btnSend, btnCancel, sendImageView;
@synthesize messageTextField;

@synthesize connection = _connection;
@synthesize responseData = _responseData;


- (id)initWithText:(NSString *)text image:(UIImage *)image {
    self = [super init];
    if (self) {
        _text = [text retain];
		_sendImage = [image retain];
    }
    return self;
}


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

- (void)viewDidAppear:(BOOL)animated {
	
	NSString *key = [user valueForKey:AppTokenKey];
	NSString *secret = [user valueForKey:AppTokenSecret];
	if (key && ![key isEqualToString:@""] && 
		secret && ![secret isEqualToString:@""])
		_authorized = YES;
	else 
	{
		[user removeObjectForKey:@"QUser"];
		[user synchronize];
		_authorized = NO;
	}
	
	_statue.text = _authorized?[user valueForKey:@"QUser"]:@"未绑定";
	
	
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



- (void)dealloc {
    
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidShowNotification object:nil];

	[messageTextField release];
	[btnSend release];
	[btnCancel release];
	[sendImageView release];
	
	[_connection release];
	[_responseData release];
	
	
    [super dealloc];
}

- (IBAction)send:(id)sender {
	
	if(!_authorized)
	{
		QVerifyWebViewController *qVerify = [[QVerifyWebViewController alloc] init];
		[self presentModalViewController:qVerify animated:YES];
		[qVerify release];
		return;
	}
	
	QWeiboAsyncApi *api = [[[QWeiboAsyncApi alloc] init] autorelease];
	NSString *tokenKey = [user valueForKey:AppTokenKey];
	NSString *tokenSecret = [user valueForKey:AppTokenSecret];
	
	NSString *imagePath = [NSTemporaryDirectory() stringByAppendingFormat:@"releaseImage"];
	if(sendImageView.image)
	{
		NSData *imageData = UIImagePNGRepresentation(sendImageView.image);
		if(!imageData)
			imageData = UIImageJPEGRepresentation(sendImageView.image, 1.0);
		[imageData writeToFile:imagePath atomically:YES];
	}
	
	
	self.connection	= [api publishMsgWithConsumerKey:AppKey 
									  consumerSecret:AppSecret
									  accessTokenKey:tokenKey 
								   accessTokenSecret:tokenSecret 
											 content:messageTextField.text 
										   imageFile:sendImageView.image?imagePath:nil 
										  resultType:RESULTTYPE_JSON 
											delegate:self];
	
	[TKLoadingView showTkloadingAddedTo:self.view title:@"正在发布⋯⋯" activityAnimated:YES];
	
}


#pragma mark -
#pragma mark NSURLConnection delegate

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
	
	[_responseData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
	
	self.responseData = [NSMutableData data];
	//NSLog(@"total = %d", [response expectedContentLength]);
}

- (void) connectionDidFinishLoading:(NSURLConnection *)connection {
	
	TKLoadingView *indictor = nil;
	for(indictor in self.view.subviews)
		if([indictor isKindOfClass:[TKLoadingView class]])
		{
			[indictor setActivityAnimating:NO withShowMsg:@"已发布!"];
			[indictor dismissAfterDelay:1.0 animated:YES];
		}
	self.connection = nil;
	[self cancel:nil];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
	
	TKLoadingView *indictor = nil;
	for(indictor in self.view.subviews)
		if([indictor isKindOfClass:[TKLoadingView class]])
		{
			[indictor setActivityAnimating:NO withShowMsg:@"网络似乎已断开!"];
			[indictor dismissAfterDelay:1.0 animated:YES];
			
		}
	
	self.connection = nil;

}



- (IBAction)cancel:(id)sender {
	messageTextField.text = nil;
	sendImageView.image = nil;
	[self dismissModalViewControllerAnimated:YES];
}



@end
