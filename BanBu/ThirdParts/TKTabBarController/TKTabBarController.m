//
//  TKTabBarController.m
//  Ivan_Test
//
//  Created by laiguo zheng on 12-7-13.
//  Copyright (c) 2012年 17xy. All rights reserved.
//

#import "TKTabBarController.h"
#import "TKTabBarItem.h"
#import "BanBu_NavigationController.h"
#import "BanBu_ListViewController.h"
#import "BanBu_BroadcastController.h"
#import "BanBu_MyFriendViewController.h"
#define TitleTag 111

@interface TKTabBarController ()

- (void)layoutOverlayBarView;

@end

@implementation TKTabBarController

@synthesize slideView = _slideView;
@synthesize useImageOnly = _useImageOnly;
@synthesize naviArr=_naviArr;
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
    
    UIImageView *overlayView = [[UIImageView alloc] initWithFrame:self.tabBar.frame];
    overlayView.backgroundColor = [UIColor blackColor];
    overlayView.contentMode = UIViewContentModeScaleToFill;
    _overlayBarView = overlayView;
    overlayView.userInteractionEnabled = YES;
    [self.view addSubview:overlayView];
    [overlayView release];
    
    _customItems = [[NSMutableArray alloc] initWithCapacity:5];
    
    _naviArr=[[[NSArray alloc]init]autorelease];
    
    [self.tabBar addObserver:self forKeyPath:@"frame" options:1 context:nil];
    
   
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    _overlayBarView = nil;
    self.slideView = nil;
}

- (void)dealloc
{
    [self.tabBar removeObserver:self forKeyPath:@"Frame"];
    [_customItems release];
    [_slideView release];
    [super dealloc];
}

-(UIView *)hideTabbar:(BOOL)hide
{
    UIView *contentview = nil;
    
    if(hide==YES)
    {
        if([self.tabBarController.view.subviews count]<2)
        {
            
            return nil ;
            
        }
        
        if([[self.tabBarController.view.subviews objectAtIndex:0]isKindOfClass:[UITabBar class]])
        {
            contentview=[self.tabBarController.view.subviews objectAtIndex:1];
             
        }else if([[self.view.subviews objectAtIndex:1] isKindOfClass:[UITabBar class]])
        {
            
            UITabBar *t= (UITabBar *)[self.tabBarController.view.subviews objectAtIndex:1];
            
            t.frame=CGRectMake(-320, 480, 320, 44);
            
            
            contentview=[self.tabBarController.view.subviews objectAtIndex:0];
            
            
        }
        
        contentview.frame=CGRectMake(0, 0, 320, 480);
        
        return contentview;
    }else {
        
        {
            if([self.tabBarController.view.subviews count]<2)
            {
                
                return nil ;
                
            }
            
            if([[self.tabBarController.view.subviews objectAtIndex:0]isKindOfClass:[UITabBar class]])
            {
                contentview=[self.tabBarController.view.subviews objectAtIndex:1];
                
                
            }else if([[self.tabBarController.view.subviews objectAtIndex:1] isKindOfClass:[UITabBar class]])
            {
                
                UITabBar *t= (UITabBar *)[self.tabBarController.view.subviews objectAtIndex:1];
                
                t.frame=CGRectMake(0, 480-44, 320, 44);
                
                
                contentview=[self.tabBarController.view.subviews objectAtIndex:0];
                
                
            }
            
            contentview.frame=CGRectMake(0, 0, 320, 446);
            
            return contentview;
            
            
            
            
        }
        
        
    }
    
    
    
    
    
}

-(void)setTabBarHidde:(BOOL)hidden{
    self.tabBar.hidden = hidden;
//    [self hideTabbar:hidden];
    if(hidden){
        [UIView animateWithDuration:0.4
                         animations:^{

                             _overlayBarView.frame = CGRectMake(0,  __MainScreen_Height+20, 320, 49);

                         }];

    }else{
        [UIView animateWithDuration:0.4
                         animations:^{
                             
                             _overlayBarView.frame = CGRectMake(0, __MainScreen_Height+20-49, 320, 49);
                             
                         }];

    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{

    if([keyPath isEqualToString:@"title"] && !_useImageOnly)
    {
        NSInteger index = [self.tabBar.items indexOfObject:context];
        TKTabBarItem *item = [_customItems objectAtIndex:index];
        item.title = [change valueForKey:@"new"];
        
    }
    else if([keyPath isEqualToString:@"frame"])
    {
        self.tabBar.hidden = YES;

        CGRect rect = [[change valueForKey:@"new"] CGRectValue];
       {
            [UIView animateWithDuration:0.4
                             animations:^{
                                 if(rect.origin.x < 0)
                                     _overlayBarView.frame = CGRectMake(0,  __MainScreen_Height+20, 320, 49);
                                 else 
                                     _overlayBarView.frame = CGRectMake(0, __MainScreen_Height+20-49, 320, 49);
                             }];
        }
    }
    
    else if([keyPath isEqualToString:@"badgeValue"]) 
    {
        NSInteger index = [self.tabBar.items indexOfObject:context];
        
         if([_customItems count]!=0)
         {
        TKTabBarItem *item = [_customItems objectAtIndex:index];
      
        
        item.badgeValue = [change valueForKey:@"new"];
               // 这里监测 item 的
         }
    
    }
    
}

- (void)setViewControllers:(NSArray *)viewControllers
{
    [super setViewControllers:viewControllers];
    [self layoutOverlayBarView];

    _naviArr=[viewControllers retain];
    
    for(UITabBarItem *item in self.tabBar.items)
    {
        [item addObserver:self forKeyPath:@"title" options:1 context:item];
        [item addObserver:self forKeyPath:@"badgeValue" options:1 context:item];
    }
    

    
    
} 

- (void)setUseImageOnly:(BOOL)useImageOnly
{
    if(_useImageOnly == useImageOnly)
        return;
    _useImageOnly = useImageOnly;
    
}

- (void)layoutOverlayBarView
{
    for(TKTabBarItem *item in _customItems)
        [item removeFromSuperview];
    [_customItems removeAllObjects];
        
    float width = 320.0/self.viewControllers.count;
    for(int i=0; i<self.viewControllers.count; i++)
    {
        UITabBarItem *item = [[self.viewControllers objectAtIndex:i] tabBarItem];
        TKTabBarItem *tkItem = [[TKTabBarItem alloc] initWithFrame:CGRectMake(width*i, 0, width, self.tabBar.frame.size.height)];
        tkItem.tag = i;
        tkItem.title = item.title;
        tkItem.useImageOnly = _useImageOnly;
        if(self.selectedIndex == i)
            tkItem.selected = YES;
        
         if(tkItem.tag==4)
             tkItem.space=YES;
        
        [_overlayBarView addSubview:tkItem];
        [_customItems addObject:tkItem];
        [tkItem release];
    }
}

- (void)setNormaolImage:(UIImage *)normalImage selectedImage:(UIImage *)selectedImage forItemWithIndex:(NSInteger)index
{
    TKTabBarItem *item = [_customItems objectAtIndex:index];
    item.normalImage = normalImage;
    item.selectedImage = selectedImage;
}


- (void)animationToSelectedItem
{
    [UIView animateWithDuration:0.3
                     animations:^{
                         
                         float width = 320.0/_customItems.count;
                         float x = width*self.selectedIndex;
                         float offset = (int)_animationView.frame.origin.x%(int)width;
                         x += offset;
                         CGRect rect = _animationView.frame;
                         rect.origin.x = x;
                         _animationView.frame = rect;
                     }];
}

- (void)setTabBarBackgroundImage:(UIImage *)image
{
    if(image == nil)
    {
        _overlayBarView.image = nil;
        return;
    }
    _overlayBarView.image = image;
}

- (void)setAnimationImage:(UIImage *)image
{
    if(!image)
    {
        [_animationView removeFromSuperview];
        _animationView = nil;
    }
    else 
    {
        if(!_animationView)
        {
            _animationView = [[UIImageView alloc] initWithFrame:CGRectZero];
            [_overlayBarView insertSubview:_animationView atIndex:0];
            if(_useImageOnly)
                [_overlayBarView bringSubviewToFront:_animationView];
            [_animationView release];
        }
        
    float width = 320.0/_customItems.count;
    float x = width*self.selectedIndex;
    x += (width-image.size.width)/2;
    _animationView.frame = CGRectMake(x,self.tabBar.frame.size.height-image.size.height,image.size.width,image.size.height);
    _animationView.image = image;
    }
    
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{

    UITouch *touch = [touches anyObject];
    //
    if(touch.view != _overlayBarView)
        return;
    CGPoint point = [touch  locationInView:_overlayBarView];
    if(point.y < 0)
    {
        return;
    }
    
    NSInteger index = (int)point.x/(320.0/_customItems.count);
    
    if(index == self.selectedIndex)
    {
        UINavigationController *nav = [self.viewControllers objectAtIndex:index];
        if([nav isMemberOfClass:[BanBu_NavigationController class]])
        {
            if(index == 0){
                 [(BanBu_ListViewController*)[nav.viewControllers objectAtIndex:0] setRefreshing];

            }else if(index == 1){
                [(BanBu_BroadcastController*)[nav.viewControllers objectAtIndex:0] setRefreshing];

            }else if(index == 3){
                [(BanBu_MyFriendViewController*)[nav.viewControllers objectAtIndex:0] setRefreshing];
            }
            [nav popToRootViewControllerAnimated:YES];
        }
        return;
    }
    //TKTabBarItem *item = [_customItems objectAtIndex:self.selectedIndex];
    //item.selected = NO;
    //item = [_customItems objectAtIndex:index];
    //item.selected = YES;
    self.selectedIndex = index;
    if(_animationView)
        [self animationToSelectedItem];
}

- (void)setSelectedIndex:(NSUInteger)selectedIndex
{
//    NSLog(@"%d",selectedIndex);
    if([_customItems count])
    {
        TKTabBarItem *item = [_customItems objectAtIndex:self.selectedIndex];
        item.selected = NO;
        item = [_customItems objectAtIndex:selectedIndex];
        item.selected = YES;
       

    }
    [super setSelectedIndex:selectedIndex];

}
        
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
