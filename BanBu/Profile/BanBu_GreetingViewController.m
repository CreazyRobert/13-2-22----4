//
//  BanBu_GreetingViewController.m
//  BanBu
//
//  Created by Jc Zhang on 13-1-23.
//
//

#import "BanBu_GreetingViewController.h"
#import "AppCommunicationManager.h"
#import "AppDataManager.h"
#import "TKLoadingView.h"

@interface BanBu_GreetingViewController ()

@end

@implementation BanBu_GreetingViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.title = NSLocalizedString(@"requestUser", nil);
    self.tableView.backgroundView = nil;
    self.tableView.backgroundColor = [UIColor colorWithRed:255.0/255 green:250.0/255 blue:240.0/255 alpha:1.0];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    CGFloat btnLen = [NSLocalizedString(@"cancelNotice", nil) sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(150, 30)].width;

    UIButton *canelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    canelBtn.frame=CGRectMake(0, 0, btnLen+20, 30);
    [canelBtn addTarget:self action:@selector(dimissViewController) forControlEvents:UIControlEventTouchUpInside];
    [canelBtn setBackgroundImage:[[UIImage imageNamed:@"app_nav_btn_bg1.png"] stretchableImageWithLeftCapWidth:15.0 topCapHeight:15.0] forState:UIControlStateNormal];
    //    [save setBackgroundImage:[[UIImage imageNamed:@"app_nav_btn_bg2.png"] stretchableImageWithLeftCapWidth:15.0 topCapHeight:15.0] forState:UIControlStateHighlighted];
    [canelBtn setTitleEdgeInsets:UIEdgeInsetsMake(3, 2, 2, 2)];
    [canelBtn setTitle:NSLocalizedString(@"cancelNotice", nil) forState:UIControlStateNormal];
    canelBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    UIBarButtonItem *saveItem = [[[UIBarButtonItem alloc] initWithCustomView:canelBtn] autorelease];
    self.navigationItem.leftBarButtonItem = saveItem;
    
    CGFloat btnLen1 = [NSLocalizedString(@"confirmNotice", nil) sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(150, 30)].width;

    UIButton *conBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    conBtn.frame=CGRectMake(0, 0, btnLen1+20, 30);
    [conBtn addTarget:self action:@selector(complete) forControlEvents:UIControlEventTouchUpInside];
    [conBtn setBackgroundImage:[[UIImage imageNamed:@"app_nav_btn_bg1.png"] stretchableImageWithLeftCapWidth:15.0 topCapHeight:15.0] forState:UIControlStateNormal];
    //    [save setBackgroundImage:[[UIImage imageNamed:@"app_nav_btn_bg2.png"] stretchableImageWithLeftCapWidth:15.0 topCapHeight:15.0] forState:UIControlStateHighlighted];
    [conBtn setTitleEdgeInsets:UIEdgeInsetsMake(3, 2, 2, 2)];
    [conBtn setTitle:NSLocalizedString(@"confirmNotice", nil) forState:UIControlStateNormal];
    conBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    UIBarButtonItem *saveItem1 = [[[UIBarButtonItem alloc] initWithCustomView:conBtn] autorelease];
    self.navigationItem.rightBarButtonItem = saveItem1;
    
    //    NSMutableDictionary *parDic = [NSMutableDictionary dictionary];
    //    [AppComManager getBanBuData:BanBu_Send_Request_To_User par:parDic delegate:self];
    //    self.navigationController.view.userInteractionEnabled = NO;
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 100)];
    footerView.backgroundColor = [UIColor clearColor];
    UIButton *searchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    searchBtn.frame = CGRectMake(10, 10, 300, 40);
    [searchBtn setBackgroundImage:[[UIImage imageNamed:@"app_btn_blue.png"] stretchableImageWithLeftCapWidth:10.0 topCapHeight:0.0] forState:UIControlStateNormal];
    [searchBtn setTitle:NSLocalizedString(@"sendReply", nil) forState:UIControlStateNormal];
    [searchBtn addTarget:self action:@selector(complete) forControlEvents:UIControlEventTouchUpInside];
    [footerView addSubview:searchBtn];
    self.tableView.tableFooterView = footerView;
    [footerView release];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dimissViewController{
    
    [self dismissModalViewControllerAnimated:YES];
}

-(void)complete{
    [UIView animateWithDuration:0.0 animations:^{
        if([_greetTextField isFirstResponder]){
            [_greetTextField resignFirstResponder];
            
        }
    }completion:^(BOOL finished){
        if([_greetTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length){
            NSMutableDictionary *parDic = [NSMutableDictionary dictionary];
            [parDic setValue:self.touid forKey:@"touid"];
            [parDic setValue:_greetTextField.text forKey:@"saytext"];
            [AppComManager getBanBuData:BanBu_Send_Request_To_User par:parDic delegate:self];
            [TKLoadingView showTkloadingAddedTo:self.navigationController.view title:NSLocalizedString(@"sendingNotice", nil) activityAnimated:YES];
            self.navigationController.view.userInteractionEnabled = NO;
            
        }
    }];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    // Return the number of rows in the section.
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell == nil)
    {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }
    if(!indexPath.section)
    {
        UITextField *textField = (UITextField *)[cell viewWithTag:111];
        if(!textField){
            textField = [[UITextField alloc] initWithFrame:CGRectMake(20, 10, 280, 25)];
            textField.delegate = self;
            textField.tag = 111;
            textField.backgroundColor = [UIColor clearColor];
            textField.borderStyle = UITextBorderStyleNone;
//            textField.textColor = [UIColor colorWithRed:50.0/255 green:79.0/255 blue:133.0/255 alpha:1.0];
            textField.clearButtonMode = UITextFieldViewModeWhileEditing;
            textField.returnKeyType = UIReturnKeyDone;

            [cell addSubview:textField];
            [textField release];
            _greetTextField = textField;
            [_greetTextField becomeFirstResponder];
        }
    }
    // Configure the cell...
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if(!section){
        return 44;
    }
    return 0;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView *aBackView = [[[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 44)]autorelease];
    aBackView.backgroundColor = [UIColor clearColor];
    UILabel *aHeaderLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, 260, 44)];
    aHeaderLabel.text = NSLocalizedString(@"saywhat", nil);
    aHeaderLabel.backgroundColor = [UIColor clearColor];
    aHeaderLabel.textColor = [UIColor darkGrayColor];
    [aBackView addSubview:aHeaderLabel];
    [aHeaderLabel release];
    
    return aBackView;
    
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

#pragma mark - UITextFieldDelegate

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [self complete];
    
    return YES;
}


#pragma mark - BanBuDelegate

- (void)banbuRequestDidFinished:(NSDictionary *)resDic error:(NSError *)error{
    
    self.navigationController.view.userInteractionEnabled = YES;
    [TKLoadingView dismissTkFromView:self.navigationController.view animated:YES afterShow:0.0];
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
    
//    NSLog(@"%@",resDic);
    if([AppComManager respondsDic:resDic isFunctionData:BanBu_Send_Request_To_User])
    {
        if([[resDic valueForKey:@"ok"]boolValue])
        {
            
            [self dimissViewController];
            [TKLoadingView showTkloadingAddedTo:self.navigationController.view title:NSLocalizedString(@"sendS", nil) activityAnimated:NO duration:2.0];
        }else{
            [TKLoadingView showTkloadingAddedTo:self.navigationController.view title:NSLocalizedString(@"sendF", nil) activityAnimated:NO duration:2.0];

        }
    }
    
    
}








@end
