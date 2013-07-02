//
//  BanBu_TextEditer.m
//  BanBu
//
//  Created by jie zheng on 12-7-10.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "BanBu_ReplyViewController.h"
#import <QuartzCore/QuartzCore.h>

#import "AppCommunicationManager.h"
#import "AppDataManager.h"
#import "TKLoadingView.h"

@interface BanBu_ReplyViewController ()

@end

@implementation BanBu_ReplyViewController
@synthesize replyid = _replyid;
@synthesize delegate = _delegate;

- (id)initWithTitle:(NSString *)myTitle replyid:(NSString *)rid
{
    self = [super init];
    if (self) {
        
        self.title = myTitle;
        self.view.backgroundColor = [UIColor colorWithRed:255.0/255 green:250.0/255 blue:240.0/255 alpha:1.0];
        
        UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(10, 10, 300, 120)];
        //textView.delegate = self;
        _inputView = textView;
        textView.backgroundColor = [UIColor whiteColor];
        textView.layer.borderColor = [[UIColor grayColor] CGColor];
        textView.layer.borderWidth = 1.0;
        textView.layer.cornerRadius = 6.0;
        textView.textColor = [UIColor darkTextColor];
        textView.font = [UIFont systemFontOfSize:16];
        [self.view addSubview:textView];
        [textView release];
        _replyid = [[NSString alloc]initWithString:rid];//动态id
//        //NSLog(@"%@",rid);
//        //NSLog(@"%@",_replyid);
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:219.0/255 green:218.0/255 blue:212.0/255 alpha:1.0];
    UIButton *listButton = [UIButton buttonWithType:UIButtonTypeCustom];
    listButton.frame = CGRectMake(0, 0, 50, 30);
    listButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [listButton setBackgroundImage:[[UIImage imageNamed:@"app_nav_btn_bg1.png"] stretchableImageWithLeftCapWidth:15.0 topCapHeight:15.0] forState:UIControlStateNormal];
    [listButton setBackgroundImage:[[UIImage imageNamed:@"app_nav_btn_bg2.png"] stretchableImageWithLeftCapWidth:15.0 topCapHeight:15.0] forState:UIControlStateHighlighted];
    [listButton setTitle:NSLocalizedString(@"sendReply", nil) forState:UIControlStateNormal];
    [listButton addTarget:self action:@selector(sendReply) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[[UIBarButtonItem alloc] initWithCustomView:listButton] autorelease];
    self.navigationItem.rightBarButtonItem = rightItem;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
}

- (void)dealloc
{
    [_replyid release];
    [super dealloc];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [_inputView becomeFirstResponder];

}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [_inputView resignFirstResponder];
}
#pragma -
#pragma UITextView delegate methods


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void)sendReply{
    [_inputView resignFirstResponder];
    NSMutableDictionary *abrd = [NSMutableDictionary dictionaryWithCapacity:2];
    [abrd setValue:_inputView.text forKey:@"saytext"];
    [abrd setValue:[NSArray array] forKey:@"attach"];
    NSMutableDictionary *pars = [NSMutableDictionary dictionaryWithCapacity:1];
    [pars setValue:_replyid forKey:@"replyid"];
    [pars setValue:abrd forKey:@"says"];
    [AppComManager getBanBuData:BanBu_Reply_Broadcast par:pars delegate:self];
    self.navigationController.view.userInteractionEnabled = NO;
    [TKLoadingView showTkloadingAddedTo:self.view title:NSLocalizedString(@"sendingNotice", nil) activityAnimated:YES];
//    self.navigationController.view.userInteractionEnabled = NO;
}

#pragma mark - BanBuDelegate
-(void)banbuRequestDidFinished:(NSDictionary *)resDic error:(NSError *)error{
    self.navigationController.view.userInteractionEnabled = YES;
    [TKLoadingView dismissTkFromView:self.view animated:YES afterShow:0.0];
    if(error)
    {
        if([error.domain isEqualToString:BanBuDataformatError])
        {
            [TKLoadingView showTkloadingAddedTo:self.view title:NSLocalizedString(@"data_error", nil) activityAnimated:NO duration:2.0];
        }
        else
        {
            [TKLoadingView showTkloadingAddedTo:self.view title:NSLocalizedString(@"network_error", nil) activityAnimated:NO duration:2.0];
        }
        
        return;
    }
    //NSLog(@"%@",resDic);
    if([AppComManager respondsDic:resDic isFunctionData:BanBu_Reply_Broadcast]){
        if([[resDic valueForKey:@"ok"]boolValue]){
//            if([_delegate respondsToSelector:@selector(banBuReplySuccessed)]){
//                [_delegate banBuReplySuccessed];
//            }
            [[NSNotificationCenter defaultCenter]postNotificationName:@"replySuc" object:nil];
            [self.navigationController popViewControllerAnimated:YES];

        }else{
            if([[resDic valueForKey:@"error"] isEqualToString:@"__loginidinvalid__"]){
                [self.navigationController popToRootViewControllerAnimated:NO];
                
            }
        }
    }
    
}

@end
