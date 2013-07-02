//
//  BanBu_ChangePWViewController.m
//  BanBu
//
//  Created by jie zheng on 12-7-7.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "BanBu_ChangePWViewController.h"
#import "TKLoadingView.h"
#import "AppCommunicationManager.h"
#import "AppDataManager.h"
@interface BanBu_ChangePWViewController ()

@end

@implementation BanBu_ChangePWViewController

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
    self.title = NSLocalizedString(@"changePWTitle", nil);
    UIButton *cancel = [UIButton buttonWithType:UIButtonTypeCustom];
    cancel.frame=CGRectMake(0, 0,50, 30);
    [cancel addTarget:self action:@selector(cancel:) forControlEvents:UIControlEventTouchUpInside];
    [cancel setBackgroundImage:[[UIImage imageNamed:@"app_nav_btn_bg1.png"] stretchableImageWithLeftCapWidth:15.0 topCapHeight:15.0] forState:UIControlStateNormal];
//    [cancel setBackgroundImage:[[UIImage imageNamed:@"app_nav_btn_bg2.png"] stretchableImageWithLeftCapWidth:15.0 topCapHeight:15.0] forState:UIControlStateHighlighted];
    [cancel setTitleEdgeInsets:UIEdgeInsetsMake(3, 2, 2, 2)];
    [cancel setTitle:NSLocalizedString(@"returnButton", nil) forState:UIControlStateNormal];
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
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)cancel:(UIButton *)button
{
    [self dismissModalViewControllerAnimated:YES];
}

- (void)complete:(UIButton *)button
{
    NSString *errorMsg = nil;
    if(!_oldPWField.text.length)
    {
        errorMsg = NSLocalizedString(@"errorMsg6", nil);
    }
    else if(!_newPWField.text.length)
    {
        errorMsg = NSLocalizedString(@"errorMsg7", nil);
    }
    else if(_newPWField.text.length<6)
    {
        errorMsg = NSLocalizedString(@"errorMsg3", nil);
    }
    else if(![_confirmPWField.text isEqualToString:_newPWField.text])
    {
        errorMsg = NSLocalizedString(@"errorMsg5", nil);
    }
    if(errorMsg)
    {
        [TKLoadingView showTkloadingAddedTo:self.navigationController.view title:errorMsg activityAnimated:NO duration:1.5f];
        return;
    }

    NSMutableDictionary *parsDic = [NSMutableDictionary dictionaryWithCapacity:1];
    [parsDic setValue:_oldPWField.text forKey:@"oldpass"];
    [parsDic setValue:_newPWField.text forKey:@"newpass"];
    [AppComManager getBanBuData:BanBu_Set_User_Password par:parsDic delegate:self];
    self.navigationController.view.userInteractionEnabled = NO;
    [TKLoadingView showTkloadingAddedTo:self.navigationController.view title:NSLocalizedString(@"changePWNotice", nil) activityAnimated:YES];

}

- (void)banbuRequestDidFinished:(NSDictionary *)resDic error:(NSError *)error
{
    self.navigationController.view.userInteractionEnabled = YES;
    [TKLoadingView dismissTkFromView:self.navigationController.view animated:YES afterShow:0.0];
    if(error)
    {
        [TKLoadingView showTkloadingAddedTo:self.navigationController.view title:NSLocalizedString(@"network_error", nil) activityAnimated:NO duration:1.5f];
        return;
    }
    //NSLog(@"res:%@",resDic);
    if([AppComManager respondsDic:resDic isFunctionData:BanBu_Set_User_Password])
    {
        if([[resDic valueForKey:@"ok"] boolValue])
        {
            [TKLoadingView showTkloadingAddedTo:self.navigationController.view title:NSLocalizedString(@"changeOK", nil) activityAnimated:NO duration:1.5f];
            [self.navigationController dismissModalViewControllerAnimated:YES];

        }
        else
            [TKLoadingView showTkloadingAddedTo:self.navigationController.view title:[MyAppDataManager IsInternationalLanguage:[resDic valueForKey:@"error"]] activityAnimated:NO duration:1.5f];
    }
    
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [_confirmPWField resignFirstResponder];
    [_oldPWField resignFirstResponder];
    [_newPWField resignFirstResponder];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell == nil)
    {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        
    }

    UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(100, 10, 180, 25)];
    textField.delegate = self;
    textField.tag = 111;
    textField.backgroundColor = [UIColor clearColor];
    textField.borderStyle = UITextBorderStyleNone;
    textField.clearsOnBeginEditing = YES;
    textField.textColor = [UIColor colorWithRed:50.0/255 green:79.0/255 blue:133.0/255 alpha:1.0];
    textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    textField.returnKeyType = UIReturnKeyNext;
    textField.keyboardType = UIKeyboardTypeASCIICapable;
    textField.secureTextEntry = YES;
    [cell addSubview:textField];
    [textField release];
    if(!indexPath.row)
    {
        cell.textLabel.text = NSLocalizedString(@"oldPWLabel", nil);
        _oldPWField = textField;
        CGFloat btnLen = [NSLocalizedString(@"oldPWLabel", nil) sizeWithFont:[UIFont systemFontOfSize:16] constrainedToSize:CGSizeMake(150, 30)].width;
        _oldPWField.frame = CGRectMake(btnLen+30+5, 10, 270-btnLen, 25);
        textField.placeholder = NSLocalizedString(@"inputOldPW", nil);        
    }
    else if(indexPath.row == 1)
    {
        cell.textLabel.text = NSLocalizedString(@"newPWLabel", nil);
        _newPWField = textField;
        CGFloat btnLen = [NSLocalizedString(@"newPWLabel", nil) sizeWithFont:[UIFont systemFontOfSize:16] constrainedToSize:CGSizeMake(150, 30)].width;
        _newPWField.frame = CGRectMake(btnLen+30, 10, 270-btnLen, 25);
        textField.placeholder =NSLocalizedString(@"pPlaceholder", nil);
    }
    else if(indexPath.row == 2)
    {
        cell.textLabel.text = NSLocalizedString(@"conPWLabel", nil);
        _confirmPWField = textField;
        CGFloat btnLen = [NSLocalizedString(@"conPWLabel", nil) sizeWithFont:[UIFont systemFontOfSize:16] constrainedToSize:CGSizeMake(150, 30)].width;
        _confirmPWField.frame = CGRectMake(btnLen+30+5, 10, 270-btnLen, 25);
        textField.placeholder =NSLocalizedString(@"cPlaceholedr", nil);
        textField.returnKeyType = UIReturnKeyGo;
    }

    return cell;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    
    if(textField.returnKeyType == UIReturnKeyNext)
    {
        UITableViewCell *cell = (UITableViewCell *)textField.superview;
        NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
        indexPath = [NSIndexPath indexPathForRow:indexPath.row+1 inSection:indexPath.section];
        UITextField *inputField = (UITextField *)[[self.tableView cellForRowAtIndexPath:indexPath] viewWithTag:111];
        [inputField becomeFirstResponder];
    }
    else 
    {
       [self performSelector:@selector(complete:) withObject:nil];
    }
    
    return  YES;
}



@end
