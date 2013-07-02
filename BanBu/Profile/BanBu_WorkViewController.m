//
//  BanBu_WorkViewController.m
//  BanBu
//
//  Created by jie zheng on 12-7-10.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "BanBu_WorkViewController.h"
#import "TKLoadingView.h"
@interface BanBu_WorkViewController ()

@end

@implementation BanBu_WorkViewController

@synthesize workInfo = _workInfo;
@synthesize workType = _workType;
@synthesize worksArray = _worksArray;
@synthesize delegate=_delegate;
@synthesize select=_select;
- (id)initWithWorkInfo:(NSString *)info type:(NSInteger)type
{
    self = [super initWithStyle:UITableViewStylePlain];
    if (self) {
        
        _workType = type;
        
        _select=type;
        
        self.workInfo = info; 
        //NSLog(@"%@,%d",info,type);
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    
    self.title=NSLocalizedString(@"workTitle", nil);
    self.tableView.backgroundColor = [UIColor colorWithRed:255.0/255 green:250.0/255 blue:240.0/255 alpha:1.0];
    
    _worksArray = [[NSArray alloc] initWithObjects:NSLocalizedString(@"workItem", nil),NSLocalizedString(@"workItem1", nil),NSLocalizedString(@"workItem2", nil),NSLocalizedString(@"workItem3", nil),NSLocalizedString(@"workItem4", nil),NSLocalizedString(@"workItem5", nil),NSLocalizedString(@"workItem6", nil),NSLocalizedString(@"workItem7", nil),NSLocalizedString(@"workItem8", nil),NSLocalizedString(@"workItem9", nil),NSLocalizedString(@"workItem10", nil), nil];

    
    UIButton *btn_return=[UIButton buttonWithType:UIButtonTypeCustom];
    
    [btn_return addTarget:self action:@selector(popself) forControlEvents:UIControlEventTouchUpInside];
    
    [btn_return setBackgroundImage:[[UIImage imageNamed:@"app_nav_back_bg1.png"] stretchableImageWithLeftCapWidth:15.0 topCapHeight:15.0] forState:UIControlStateNormal];
    [btn_return setBackgroundImage:[[UIImage imageNamed:@"app_nav_back_bg2.png"] stretchableImageWithLeftCapWidth:15.0 topCapHeight:15.0] forState:UIControlStateHighlighted];
    btn_return.frame=CGRectMake(0, 0, 48, 30);
    [btn_return setTitleEdgeInsets:UIEdgeInsetsMake(3, 9, 2, 2)];
    [btn_return setTitle:NSLocalizedString(@"returnButton", nil) forState:UIControlStateNormal];
    btn_return.titleLabel.font = [UIFont systemFontOfSize:14];
 
    self.navigationItem.leftBarButtonItem=[[[UIBarButtonItem alloc]initWithCustomView:btn_return] autorelease];

    
    CGFloat btnLen1 = [NSLocalizedString(@"confirmNotice", nil) sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(150, 30)].width;
    UIButton *deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
    deleteButton.frame=CGRectMake(0, 0, btnLen1+20, 30);
    deleteButton.tag = 101;
    [deleteButton addTarget:self action:@selector(popself) forControlEvents:UIControlEventTouchUpInside];
    [deleteButton setBackgroundImage:[[UIImage imageNamed:@"app_nav_btn_bg1.png"] stretchableImageWithLeftCapWidth:15.0 topCapHeight:15.0] forState:UIControlStateNormal];
    [deleteButton setBackgroundImage:[[UIImage imageNamed:@"app_nav_btn_bg2.png"] stretchableImageWithLeftCapWidth:15.0 topCapHeight:15.0] forState:UIControlStateHighlighted];
    [deleteButton setTitleEdgeInsets:UIEdgeInsetsMake(3, 2, 2, 2)];
    [deleteButton setTitle:NSLocalizedString(@"confirmNotice", nil) forState:UIControlStateNormal];
    deleteButton.titleLabel.font = [UIFont systemFontOfSize:14];
    UIBarButtonItem *delItem = [[[UIBarButtonItem alloc] initWithCustomView:deleteButton] autorelease];
    self.navigationItem.rightBarButtonItem = delItem;

    
}

-(void)popself
{
 
    
    
    if([_customWork.text isEqual:@""])
    {
        
//        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"提示" message:@"职业不能为空哦" delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil];
//        
//        [alert show];
//        
//        [alert release];
        [TKLoadingView showTkloadingAddedTo:self.view title:NSLocalizedString(@"workNil", nil) activityAnimated:NO duration:1.0];
        return;
    }else
    {
        [self.navigationController popViewControllerAnimated:YES];

    }
    

}
- (void)viewDidUnload
{
    [super viewDidUnload];
    self.worksArray = nil;
    self.workInfo = nil;
}

- (void)dealloc
{
    [_workInfo release];
    [_worksArray release];
    [super dealloc];
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
        return _worksArray.count;
}

//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
//{
//    if(section)
//        return @"所属行业";
//    else 
//        return nil;
//}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
     
    if(section){
        return 30;
    }else{
        return 0;
    }
  
    
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if(section == 0){
        return nil;
    }
        
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 30)];
    titleLabel.backgroundColor = [UIColor lightGrayColor];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.font = [UIFont boldSystemFontOfSize:14];
    titleLabel.text= NSLocalizedString(@"workBelong", nil);
    return [titleLabel autorelease];

    
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
//    if(cell == nil)
//    {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier] autorelease];
        cell.textLabel.textColor = [UIColor darkTextColor];
//    }

   // UITextField *textField = (UITextField *)[self.view viewWithTag:111];
    
    if(indexPath.section)
    {
        //[textField removeFromSuperview];
        cell.textLabel.text = [_worksArray objectAtIndex:indexPath.row];
        NSString *imageName = [NSString stringWithFormat:@"icon_industry%i_personal.png",indexPath.row+1];
        cell.imageView.image = [UIImage imageNamed:imageName];
        
        if(indexPath.row == _workType)
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        else 
            cell.accessoryType = UITableViewCellAccessoryNone;

    }
    else 
    {
        CGFloat btnLen1 = [NSLocalizedString(@"workTitle", nil) sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(150, 30)].width+40;
        UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(btnLen1, 7, 290-btnLen1, 30)];
        textField.delegate = self;
        textField.backgroundColor = [UIColor whiteColor];
        textField.borderStyle = UITextBorderStyleNone;
        textField.textColor = [UIColor colorWithRed:56.0/255 green:84.0/255 blue:135.0/255 alpha:1.0];
        textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        [textField setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
        textField.keyboardType = UIReturnKeyDone;
        textField.layer.cornerRadius = 3;
        textField.layer.borderColor = [[UIColor lightGrayColor]CGColor];
        textField.layer.borderWidth = 2;
        UILabel *paddingView = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 10, 30)];
        paddingView.backgroundColor = [UIColor clearColor];
        textField.leftView = paddingView;
        textField.leftViewMode = UITextFieldViewModeAlways;
        [cell addSubview:textField];
        [textField release];
        [paddingView release];
        cell.textLabel.text = NSLocalizedString(@"workTitle", nil);
        _customWork = textField;
        _customWork.returnKeyType = UIReturnKeyDone;
        _customWork.text = @"";
        _customWork.placeholder = NSLocalizedString(@"s2c3DefaluteValue", nil);
        if(_workInfo)
        {
            textField.text = _workInfo;
            cell.textLabel.text = NSLocalizedString(@"workTitle", nil);
            cell.imageView.image = nil;
        }
    }
    
    return cell;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
   // self.workInfo = textField.text;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    
    return YES;
    
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [_customWork resignFirstResponder];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if(indexPath.section){
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:_select inSection:indexPath.section]];
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell = [tableView cellForRowAtIndexPath:indexPath];
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        
        _select = indexPath.row;
        
    }else{
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:_select inSection:indexPath.section]];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }

}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
       
    
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    
    
    NSString *str=[_worksArray objectAtIndex:_select];
    //NSLog(@"%@",str);
    str=[[str stringByAppendingString:@"-"] stringByAppendingString:_customWork.text];
    //NSLog(@"%@",str);

    NSString *str1=[[[_worksArray objectAtIndex:_workType] stringByAppendingString:@"-"] stringByAppendingString:_workInfo];
    //NSLog(@"%@",str1);

    if(![str isEqualToString:str1])
    {
 
        if([_delegate respondsToSelector:@selector(banBuTextEditerDidChangeValue:forItem:)])
        {
         
//            //NSLog(@"%@",self.title);
            [_delegate banBuTextEditerDidChangeValue:str forItem:self.title];
        
        
        }
    }
}






@end
