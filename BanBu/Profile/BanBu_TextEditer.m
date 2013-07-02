//
//  BanBu_TextEditer.m
//  BanBu
//
//  Created by jie zheng on 12-7-10.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "BanBu_TextEditer.h"
#import <QuartzCore/QuartzCore.h>

@interface BanBu_TextEditer ()

@end

@implementation BanBu_TextEditer

@synthesize textContent = _textContent;


- (id)initWithTitle:(NSString *)myTitle oldText:(NSString *)oldText description:(NSString *)des
{
    self = [super init];
    if (self) {
        NSLog(@"%@",myTitle);
 
        if([myTitle isEqualToString:@"Personal signature"]){
            myTitle = @"Signature";
        }else if([myTitle isEqualToString:@"Interests and hobbies"]){
            myTitle = @"Interests";
        }
        self.title = myTitle;
        self.view.backgroundColor = [UIColor colorWithRed:255.0/255 green:250.0/255 blue:240.0/255 alpha:1.0];
        self.textContent = oldText;
        
        UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(10, 10, 300, 120)];
        //textView.delegate = self;
        _inputView = textView;
        [_inputView becomeFirstResponder];
        textView.backgroundColor = [UIColor whiteColor];
        textView.layer.borderColor = [[UIColor grayColor] CGColor];
        textView.layer.borderWidth = 1.0;
        textView.layer.cornerRadius = 6.0;
        textView.textColor = [UIColor darkTextColor];
        textView.font = [UIFont systemFontOfSize:16];
        textView.text = _textContent;
        [self.view addSubview:textView];
        [textView release];
        
        UILabel *infoLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 135, 300, 40)];
        infoLabel.numberOfLines = 0;
        infoLabel.textAlignment = UITextAlignmentCenter;
        infoLabel.backgroundColor = [UIColor clearColor];
        infoLabel.textColor = [UIColor grayColor];
        infoLabel.font = [UIFont systemFontOfSize:15];
        infoLabel.text = des;
        [self.view addSubview:infoLabel];
        [infoLabel release];

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:219.0/255 green:218.0/255 blue:212.0/255 alpha:1.0];

    CGFloat btnLen1 = [NSLocalizedString(@"confirmNotice", nil) sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(150, 30)].width;
    UIButton *deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
    deleteButton.frame=CGRectMake(0, 0, btnLen1+20, 30);
    deleteButton.tag = 101;
    [deleteButton addTarget:self action:@selector(delete) forControlEvents:UIControlEventTouchUpInside];
    [deleteButton setBackgroundImage:[[UIImage imageNamed:@"app_nav_btn_bg1.png"] stretchableImageWithLeftCapWidth:15.0 topCapHeight:15.0] forState:UIControlStateNormal];
    [deleteButton setBackgroundImage:[[UIImage imageNamed:@"app_nav_btn_bg2.png"] stretchableImageWithLeftCapWidth:15.0 topCapHeight:15.0] forState:UIControlStateHighlighted];
    [deleteButton setTitleEdgeInsets:UIEdgeInsetsMake(3, 2, 2, 2)];
    [deleteButton setTitle:NSLocalizedString(@"confirmNotice", nil) forState:UIControlStateNormal];
    deleteButton.titleLabel.font = [UIFont systemFontOfSize:14];
    UIBarButtonItem *delItem = [[[UIBarButtonItem alloc] initWithCustomView:deleteButton] autorelease];
    self.navigationItem.rightBarButtonItem = delItem;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    self.textContent = nil;

    
    
}

-(void)delete{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    if(![_inputView.text isEqualToString:_textContent])
    {
        if([_delegate respondsToSelector:@selector(banBuTextEditerDidChangeValue:forItem:)]){
            if([self.title isEqualToString:@"Signature"]){
                self.title = @"Personal signature";
            }else if([self.title isEqualToString:@"Interests"]){
                self.title = @"Interests and hobbies";
            }
            
            [_delegate banBuTextEditerDidChangeValue:_inputView.text forItem:self.title];
        }
            
          
    }
}

- (void)dealloc
{
    [_textContent release];
    [super dealloc];
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

@end
