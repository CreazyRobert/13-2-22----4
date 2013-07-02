//
//  BanBu_FaceBookShare.m
//  BanBu
//
//  Created by Jc Zhang on 13-2-18.
//
//

#import "BanBu_FaceBookShare.h"
NSString *const kPlaceholderPostMessage = @"Say something about this...";

@interface BanBu_FaceBookShare ()

@end

@implementation BanBu_FaceBookShare

-(id)initWithText:(NSString *)text image:(UIImage *)image{
    
    self = [super init];
    if (self) {
        _text = [text retain];
		_sendImage = [image retain];
    }
    return self;
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor colorWithRed:255.0/255 green:250.0/255 blue:240.0/255 alpha:1.0];
    self.title = @"FaceBook Info";
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
    
    
    UIButton *save = [UIButton buttonWithType:UIButtonTypeCustom];
    save.frame=CGRectMake(0, 0, 50, 30);
    [save addTarget:self action:@selector(complete:) forControlEvents:UIControlEventTouchUpInside];
    [save setBackgroundImage:[[UIImage imageNamed:@"app_nav_btn_bg1.png"] stretchableImageWithLeftCapWidth:15.0 topCapHeight:15.0] forState:UIControlStateNormal];
    //    [save setBackgroundImage:[[UIImage imageNamed:@"app_nav_btn_bg2.png"] stretchableImageWithLeftCapWidth:15.0 topCapHeight:15.0] forState:UIControlStateHighlighted];
    [save setTitleEdgeInsets:UIEdgeInsetsMake(3, 2, 2, 2)];
    [save setTitle:NSLocalizedString(@"saveButton", nil) forState:UIControlStateNormal];
    save.titleLabel.font = [UIFont systemFontOfSize:14];
    UIBarButtonItem *saveItem = [[[UIBarButtonItem alloc] initWithCustomView:save] autorelease];
    self.navigationItem.rightBarButtonItem = saveItem;
    
    UIButton *send = [UIButton buttonWithType:UIButtonTypeCustom];
    send.frame = CGRectMake(0, 0, 50, 30);
    [send addTarget:self action:@selector(shareObject) forControlEvents:UIControlEventTouchUpInside];
    [send setBackgroundImage:[[UIImage imageNamed:@"app_nav_btn_bg1.png"]stretchableImageWithLeftCapWidth:15.0 topCapHeight:15.0] forState:UIControlStateNormal];
    [send setTitleEdgeInsets:UIEdgeInsetsMake(3, 2, 2, 2)];
    [send setTitle:@"Send" forState:UIControlStateNormal];
    send.titleLabel.font = [UIFont systemFontOfSize:14];
    UIBarButtonItem *sendItem = [[[UIBarButtonItem alloc] initWithCustomView:save] autorelease];
    self.navigationItem.rightBarButtonItem = sendItem;
    
    UITextView *aTextView = [[UITextView alloc]initWithFrame:CGRectMake(10, 10, 300, 100)];
    aTextView.delegate = self;
    self.postMessageTextView = aTextView;
    [aTextView release];
    
}

- (void)cancel:(UIButton *)button
{
    [self dismissModalViewControllerAnimated:YES];
}

-(void)shareObject{
    
}

- (void)resetPostMessage
{
    self.postMessageTextView.text = kPlaceholderPostMessage;
    self.postMessageTextView.textColor = [UIColor lightGrayColor];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *) event
{
    UITouch *touch = [[event allTouches] anyObject];
    if ([self.postMessageTextView isFirstResponder] &&
        (self.postMessageTextView != touch.view))
    {
        [self.postMessageTextView resignFirstResponder];
    }
}

#pragma mark - TextViewDelegate

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    // Clear the message text when the user starts editing
    if ([textView.text isEqualToString:kPlaceholderPostMessage]) {
        textView.text = @"";
        textView.textColor = [UIColor blackColor];
    }
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    // Reset to placeholder text if the user is done
    // editing and no message has been entered.
    if ([textView.text isEqualToString:@""]) {
        [self resetPostMessage];
    }
}











@end
