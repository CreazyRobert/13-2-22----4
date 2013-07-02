//
//  BanBu_NavigationController.m
//  BanBu
//
//  Created by jie zheng on 12-7-5.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "BanBu_NavigationController.h"

@interface BanBu_NavigationController ()

@end

@implementation BanBu_NavigationController

@synthesize isLoading;

//替换返回按钮

- (void)popself {
    
//    if (isLoading) {
//        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"上次的操作还没结束！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
//        [alert show];
//        [alert release];
//        return;
//        
//    }
    
    [self popViewControllerAnimated:YES];
    
    
    
    
}

- (id)initWithRootViewController:(UIViewController *)rootViewController
{
    self = [super initWithRootViewController:rootViewController];
    

    if(self)
    {
        if ([self.navigationBar respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)])
        { 
            NSString *path = [[NSBundle mainBundle] pathForResource:@"topbar" ofType:@"png"];
            UIImage *image = [UIImage imageWithContentsOfFile:path];
            [self.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
        }  
        
        return self;
    }
    
    return nil;

}


- (UIBarButtonItem*)createBackButton {
    
    UIButton *btn_return=[UIButton buttonWithType:UIButtonTypeCustom];
    
    [btn_return addTarget:self action:@selector(popself) forControlEvents:UIControlEventTouchUpInside];
    
    [btn_return setBackgroundImage:[[UIImage imageNamed:@"app_nav_back_bg1.png"] stretchableImageWithLeftCapWidth:15.0 topCapHeight:15.0] forState:UIControlStateNormal];
    [btn_return setBackgroundImage:[[UIImage imageNamed:@"app_nav_back_bg2.png"] stretchableImageWithLeftCapWidth:15.0 topCapHeight:15.0] forState:UIControlStateHighlighted];
    CGFloat btnLen = [NSLocalizedString(@"returnButton", nil) sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(100, 30)].width;
//    NSLog(@"%f",btnLen);
    btn_return.frame=CGRectMake(0, 0, btnLen+20, 30);
    [btn_return setTitleEdgeInsets:UIEdgeInsetsMake(3, 9, 2, 2)];
    [btn_return setTitle:NSLocalizedString(@"returnButton", nil) forState:UIControlStateNormal];
    btn_return.titleLabel.font = [UIFont systemFontOfSize:14];
    UIBarButtonItem *bar_itemreturn=[[[UIBarButtonItem alloc] initWithCustomView:btn_return] autorelease];
    
    return bar_itemreturn;
    
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    
    [super pushViewController:viewController animated:animated];
    if(viewController.navigationItem.hidesBackButton)
        return;
    if (viewController.navigationItem.leftBarButtonItem== nil && [self.viewControllers count] > 1) {
        
        viewController.navigationItem.leftBarButtonItem =[self createBackButton];
        
        
    }
    
}

@end