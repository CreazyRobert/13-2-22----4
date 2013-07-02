//
//  BanBu_ForgetPWController.m
//  BanBu
//
//  Created by jie zheng on 12-7-6.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "BanBu_ForgetPWController.h"

@interface BanBu_ForgetPWController ()

@end

@implementation BanBu_ForgetPWController

- (id)init
{
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self) {

        self.tableView.backgroundColor = [UIColor colorWithRed:219.0/255 green:218.0/255 blue:212.0/255 alpha:1.0];

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.title = @"忘记密码";
    
    UIButton *resetButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [resetButton setBackgroundImage:[[UIImage imageNamed:@"app_btn_blue.png"] stretchableImageWithLeftCapWidth:10 topCapHeight:10] forState:UIControlStateNormal];
    [resetButton setTitle:@"重置密码" forState:UIControlStateNormal];
    resetButton.titleLabel.font = [UIFont boldSystemFontOfSize:20];
    [resetButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    resetButton.frame = CGRectMake(10, 120, 300, 40);
    [self.tableView addSubview:resetButton];
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

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell == nil)
    {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        
    }
    
    
    UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(20, 10, 300, 25)];
    textField.backgroundColor = [UIColor clearColor];
    textField.borderStyle = UITextBorderStyleNone;
    textField.clearsOnBeginEditing = YES;
    textField.textColor = [UIColor colorWithRed:50.0/255 green:79.0/255 blue:133.0/255 alpha:1.0];
    //textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    textField.placeholder = @"请输入你的注册邮箱";
    _emailField = textField;
    [cell addSubview:textField];
    [textField release];
    
    
    return cell;

}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *bkView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 50)];
    bkView.backgroundColor = [UIColor clearColor];
    UILabel *footLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 305, 50)];
    footLabel.backgroundColor = [UIColor clearColor];
    footLabel.textColor = [UIColor grayColor];
    footLabel.font = [UIFont systemFontOfSize:15];
    footLabel.numberOfLines = 0;
    footLabel.text = @"密码重置链接将发送到你注册的邮箱，如未能收取邮件，请检查 “垃圾邮件” 。";
    [bkView addSubview:footLabel];
    [footLabel release];
    
    return [bkView autorelease];
    
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     [detailViewController release];
     */
}

@end
