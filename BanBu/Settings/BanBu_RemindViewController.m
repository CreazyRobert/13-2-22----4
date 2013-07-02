//
//  BanBu_RemindViewController.m
//  BanBu
//
//  Created by jie zheng on 12-7-7.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "BanBu_RemindViewController.h"

@interface BanBu_RemindViewController ()

@end

@implementation BanBu_RemindViewController

- (id)init
{
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.tableView.backgroundView = nil;
    self.tableView.backgroundColor = [UIColor colorWithRed:255.0/255 green:250.0/255 blue:240.0/255 alpha:1.0];
    self.title = @"提醒设置";

}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(!section)
        return 1;
    else 
        return 2;
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
    if(!section)
        return @"半步的通知功能（新消息提醒）如果无法开启，请在手机系统的‘设置’-‘通知’，找到‘半步’打开即可。";
    else 
        return @"管理半步内的声音和震动，系统的提醒设置需要在手机设置-通知-半步里面控制。";
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell == nil)
    {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier] autorelease];
        
        UISwitch *sw = [[UISwitch alloc] initWithFrame:CGRectMake(0, 0, 60, 25)];
        sw.on = YES;
        cell.accessoryView = sw;
        [sw release];
        
    } 
    
    if(!indexPath.section)
        cell.textLabel.text = @"提醒";
    else 
    {
        if(!indexPath.row)
            cell.textLabel.text = @"声音";
        else 
            cell.textLabel.text = @"震动";
    }
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
 
    [tableView deselectRowAtIndexPath:indexPath animated:NO];

}

@end
