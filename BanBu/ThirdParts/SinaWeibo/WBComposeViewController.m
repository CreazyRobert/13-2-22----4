//
//  ComposeViewController.m
//  SinaWeiboOAuthDemo
//
//  Created by junmin liu on 11-1-4.
//  Copyright 2011 Openlab. All rights reserved.
//

#import "WBComposeViewController.h"
#import "WBAuthorizeWebViewController.h"
#import "Colors.h"
#import "TKLoadingView.h"

 
static BOOL WBIsDeviceIPad()
{
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 30200
	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
		return YES;
	}
#endif
	return NO;
}


@interface WBComposeViewController(Private)

- (void)postNewStatus;
- (void)removeCachedOAuthDataForUsername:(NSString *) username;

@end

@implementation WBComposeViewController
@synthesize sendImageView;
@synthesize messageTextField;


- (id)initWithText:(NSString *)text image:(UIImage *)image {
    self = [super init];
    if (self) {
        
        self.title = @"发布消息";
        _text = [text retain];
		_sendImage = [image retain];
        _engine = [[WBEngine alloc] initWithAppKey:kWBSDKDemoAppKey appSecret:kWBSDKDemoAppSecret];
        [_engine setDelegate:self];
        [_engine setRootViewController:self];
        [_engine setRedirectURI:@"http://"];
        [_engine setIsUserExclusive:NO];

    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBar.tintColor = NavTintColor;
    UIBarButtonItem *cancel = [[[UIBarButtonItem alloc] initWithTitle:@"取消"
                                                               style:UIBarButtonItemStylePlain target:self
                                                               action:@selector(dismiss:)] autorelease];
    self.navigationItem.leftBarButtonItem = cancel;
    
    UIBarButtonItem *send = [[[UIBarButtonItem alloc] initWithTitle:@"发送"
                                                                style:UIBarButtonItemStylePlain target:self
                                                               action:@selector(send)]
                             autorelease];
    self.navigationItem.rightBarButtonItem = send;
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self 
											 selector:@selector(textChanged:) 
												 name:UITextViewTextDidChangeNotification 
											   object:messageTextField];
    
    messageTextField = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, 320, 180)];
    messageTextField.backgroundColor = [UIColor clearColor];
    messageTextField.font = [UIFont boldSystemFontOfSize:16];
    [self.view addSubview:messageTextField];
        
    
    UIView *barView = [[UIView alloc] initWithFrame:CGRectMake(0, 200, 320, 30)];
    barView.backgroundColor = NavTintColor;
    [self.view addSubview:barView];
    [barView release];
    
    
    _statue = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, 100, 20)];
    _statue.backgroundColor = [UIColor clearColor];
    _statue.font = [UIFont boldSystemFontOfSize:13];
    _statue.textColor = [UIColor whiteColor];
    [barView addSubview:_statue];
    [_statue release];
    
    _info = [[UILabel alloc] initWithFrame:CGRectMake(160, 5, 150, 20)];
    _info.backgroundColor = [UIColor clearColor];
    _info.font = [UIFont systemFontOfSize:13];
    _info.textColor = [UIColor whiteColor];
    _info.textAlignment = UITextAlignmentRight;
    [barView addSubview:_info];
    [_info release];
	

    sendImageView = [[UIImageView alloc] initWithFrame:CGRectMake(225, 135, 80, 60)];
    sendImageView.contentMode = UIViewContentModeScaleAspectFill;
    sendImageView.clipsToBounds = YES;
    sendImageView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:sendImageView];
	
    messageTextField.text = _text.length>140?[_text substringToIndex:140]:_text;
	sendImageView.image = _sendImage;
	[_text release];
	[_sendImage release];
	
    _info.text = [NSString stringWithFormat:@"您还可以输入%i个字",140-messageTextField.text.length];
	_statue.text = nil;
	
    [messageTextField becomeFirstResponder];
	if(messageTextField.text.length)
        self.navigationItem.rightBarButtonItem.enabled = YES;
    else
        self.navigationItem.rightBarButtonItem.enabled = NO;
    
[[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardShowNotify:) name:UIKeyboardDidShowNotification object:nil];	
	
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    _statue.text = ([_engine isLoggedIn] && ![_engine isAuthorizeExpired])?[[NSUserDefaults standardUserDefaults] valueForKey:@"SinaUser"]:@"未绑定";
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
    rect.origin.y = 386 - kbSize.height;
    _statue.superview.frame = rect;
    rect1.origin.y = rect.origin.y - dis;
    sendImageView.frame = rect1;
    
    [UIView commitAnimations];
}



- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidShowNotification object:nil];
    [_engine setDelegate:nil];
    [_engine release], _engine = nil;
	[messageTextField release];
	[sendImageView release];
    [super dealloc];
}

- (void)send
{
    if([_engine isLoggedIn] && ![_engine isAuthorizeExpired])
    {
        [_engine sendWeiBoWithText:messageTextField.text image:sendImageView.image];
        [TKLoadingView showTkloadingAddedTo:self.navigationController.view title:@"发送中……" activityAnimated:YES];
    }
    else
    {
        [_engine logIn];
    }
}

- (void)dismiss:(BOOL)animated
 {
	[self dismissModalViewControllerAnimated:animated];
}

- (void)textChanged:(NSNotification *)notification{
	int maxLength = 140;
	self.navigationItem.rightBarButtonItem.enabled = messageTextField.text.length > 0;
	if (messageTextField.text.length >= maxLength)
    {
        messageTextField.text = [messageTextField.text substringToIndex:maxLength];
    }
	_info.text = [NSString stringWithFormat:@"您还可以输入%i个字",maxLength-messageTextField.text.length];
}

#pragma mark - WBEngineDelegate Methods



- (void)getSinaUserName
{
    [_engine loadRequestWithMethodName:@"users/show.json"
                            httpMethod:@"GET"
                                params:[NSDictionary dictionaryWithObjectsAndKeys:_engine.userID,@"uid",_engine.accessToken,@"access_token",nil]
                          postDataType:kWBRequestPostDataTypeNone
                      httpHeaderFields:nil];
}


- (void)engineDidLogIn:(WBEngine *)engine
{
    [self getSinaUserName];
}

- (void)engineDidLogOut:(WBEngine *)engine
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"SinaUser"];
}

- (void)engine:(WBEngine *)engine requestDidFailWithError:(NSError *)error
{
    [TKLoadingView showTkloadingAddedTo:self.navigationController.view title:[error domain] activityAnimated:NO];
    [TKLoadingView dismissTkFromView:self.navigationController.view animated:YES afterShow:1.5f];
    
}
- (void)engine:(WBEngine *)engine requestDidSucceedWithResult:(id)result
{
    id user = [result valueForKey:@"user"];
    if(user)
    {
        [TKLoadingView showTkloadingAddedTo:self.navigationController.view title:@"已发布" activityAnimated:NO];
        [TKLoadingView dismissTkFromView:self.navigationController.view animated:YES afterShow:1.5f];
        [self dismiss:YES];
    }
    
    NSString *name = [result valueForKey:@"screen_name"];
    if(name)
    {
        [[NSUserDefaults standardUserDefaults] setValue:name forKey:@"SinaUser"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}


- (void)engineNotAuthorized:(WBEngine *)engine
{
    [_engine logIn];
}

- (void)engineAuthorizeExpired:(WBEngine *)engine
{
    [_engine logIn];
    [TKLoadingView showTkloadingAddedTo:self.navigationController.view title:@"授权已过期需重新授权" activityAnimated:NO duration:1.5];

    
}


@end
