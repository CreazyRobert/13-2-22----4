//
//  BanBu_SmallListView.m
//  BanBu
//
//  Created by laiguo zheng on 12-7-11.
//  Copyright (c) 2012年 17xy. All rights reserved.
//

#import "BanBu_SmallListView.h"
#import <QuartzCore/QuartzCore.h>

#define checkMarkWidth 20.0
#define Marge 2.0

@implementation BanBu_SmallListView

@synthesize selectedIndex = _selectedIndex;
@synthesize delegate = _delegate;
@synthesize listTitles = _listTitles;

- (id)initWithFrame:(CGRect)frame listTitles:(NSArray *)titles
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor colorWithRed:230.0/255 green:232.0/255 blue:232.0/255 alpha:1.0];
        self.layer.cornerRadius = 4.0f;
        
        _selectedIndex = 0;
        self.listTitles = [titles retain];
        
        UITableView *listView = [[UITableView alloc] initWithFrame:CGRectMake(0, Marge, frame.size.width, frame.size.height-2*Marge) style:UITableViewStylePlain];
        _listView = listView;
        listView.delegate = self;
        listView.dataSource = self;
        listView.backgroundColor = [UIColor clearColor];
        [self addSubview:listView];
        [listView release];
       
    }
    return self;
}

- (void)dealloc
{
    self.delegate = nil;
    _listView = nil;
    [_listTitles release];
    [super dealloc];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return _listTitles.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return (self.bounds.size.height-2*Marge)/_listTitles.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell == nil)
    {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
        cell.textLabel.font = [UIFont systemFontOfSize:15];
    }
    
    cell.textLabel.text = [_listTitles objectAtIndex:indexPath.row];
    if(_selectedIndex == indexPath.row)
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    else 
        cell.accessoryType = UITableViewCellAccessoryNone;
    
    return cell;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.selectedIndex = indexPath.row;
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if([_delegate respondsToSelector:@selector(smallListView:didSelectIndex:)])
        [_delegate smallListView:self didSelectIndex:indexPath.row];
    
}


- (void)showFromPoint:(CGPoint)originPoint inView:(UIView *)superView animation:(BOOL)animationed
{
    if(animationed)
    {
        self.frame = CGRectMake(originPoint.x, originPoint.y-self.frame.size.height, self.frame.size.width, self.frame.size.height);
        [superView addSubview:self];
        if([[superView nextResponder] isKindOfClass:[UINavigationController class]])
        {
            UINavigationBar *bar = ((UINavigationController *)[superView nextResponder]).navigationBar;
            [superView bringSubviewToFront:bar];
        }
        
        [UIView animateWithDuration:0.3
                         animations:^{
                             CGRect rect = self.frame;
                             rect.origin.y = rect.origin.y + rect.size.height-5.0;
                             self.frame = rect;
                         }];
    }
    else 
    {
        self.frame = CGRectMake(originPoint.x, originPoint.y-5.0, self.frame.size.width, self.frame.size.height);
        [superView addSubview:self];
    }
            
}

- (void)dismissWithAnimation:(BOOL)animationed
{
    if(animationed)
    {
        [UIView animateWithDuration:0.3
                         animations:^{
                             CGRect rect = self.frame;
                             rect.origin.y = rect.origin.y - rect.size.height;
                             self.frame = rect;
                         }
                         completion:^(BOOL finished) {
                             
                             [self removeFromSuperview];
                         }];
    }
    else       
        [self removeFromSuperview];
      
}

- (void)setSelectedIndex:(NSInteger)selectedIndex
{
    if(selectedIndex == _selectedIndex)
        return;
    UITableViewCell *cell = [_listView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:_selectedIndex inSection:0]];
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell = [_listView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:selectedIndex inSection:0]];
    cell.accessoryType = UITableViewCellAccessoryCheckmark;
    _selectedIndex = selectedIndex;
    
}


@end
