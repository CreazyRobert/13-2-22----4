//
//  BanBu_ExDynamicController.m
//  BanBu
//
//  Created by apple on 12-8-16.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "BanBu_ExDynamicController.h"

@interface BanBu_ExDynamicController ()

@end

@implementation BanBu_ExDynamicController
@synthesize dic=_dic;
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
   
    
    // 利用观察者模式传值
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(receve:) name:@"1" object:nil];
    
    // 利用NSUserDefaults 进行传值
   
    //[self performSelector:@selector(doit) withObject:nil afterDelay:1];
    
    
     NSString *title=  [[NSUserDefaults standardUserDefaults]objectForKey:@"ID"];
    
    self.title=title;

}

-(void)doit
{
   }

-(void)receve:(NSNotification *)notification
{
    _dic=[NSDictionary dictionary];
    
    _dic=[notification userInfo ];
   
    NSMutableString *str=[_dic objectForKey:@"ID"];
    
    self.title=str;

}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
