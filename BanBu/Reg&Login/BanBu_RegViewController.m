//
//  BanBu_RegViewController.m
//  BanBu
//
//  Created by jie zheng on 12-7-6.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "BanBu_RegViewController.h"
#import "BanBu_NameAndSexController.h"
#import "AppCommunicationManager.h"
#import "BanBu_LocationManager.h"
#import "TKLoadingView.h"
#import "AppDataManager.h"

@interface BanBu_RegViewController ()

@end

@implementation BanBu_RegViewController

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
    //    self.tableView.scrollEnabled = NO;
    self.tableView.frame= CGRectMake(0, 0, 320, 480-64);
    self.title = NSLocalizedString(@"regTitle", nil);
    UIButton *nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
    nextButton.frame=CGRectMake(0, 0, 60, 30);
    [nextButton addTarget:self action:@selector(nextStep:) forControlEvents:UIControlEventTouchUpInside];
    [nextButton setBackgroundImage:[[UIImage imageNamed:@"app_nav_btn_bg1.png"] stretchableImageWithLeftCapWidth:15.0 topCapHeight:15.0] forState:UIControlStateNormal];
    [nextButton setBackgroundImage:[[UIImage imageNamed:@"app_nav_btn_bg2.png"] stretchableImageWithLeftCapWidth:15.0 topCapHeight:15.0] forState:UIControlStateHighlighted];
    [nextButton setTitleEdgeInsets:UIEdgeInsetsMake(3, 2, 2, 2)];
    [nextButton setTitle:NSLocalizedString(@"nextButton", nil) forState:UIControlStateNormal];
    nextButton.titleLabel.font = [UIFont systemFontOfSize:14];
    UIBarButtonItem *next = [[[UIBarButtonItem alloc] initWithCustomView:nextButton] autorelease];
    self.navigationItem.rightBarButtonItem = next;
    
}

- (BOOL)validateEmail:(NSString *)email {
    NSString *emailRegex = @"^\\w+([-+.]\\w+)*@\\w+([-.]\\w+)*\\.\\w+([-.]\\w+)*$";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}

- (void)showError:(NSString *)errorMsg
{
//    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:errorMsg
//                                                    message:nil
//                                                   delegate:nil
//                                          cancelButtonTitle:@"确定"
//                                          otherButtonTitles:nil, nil];
//    [alert show];
//    [alert release];
    [TKLoadingView showTkloadingAddedTo:self.view title:errorMsg activityAnimated:NO duration:1.0];
}


- (void)nextStep:(UIButton *)button
{

    NSString *errorMsg = nil;
    if(!_emailField.text.length)
    {
        errorMsg = NSLocalizedString(@"errorMsg", nil);
        [self showError:errorMsg];
        return;
    }
    if(![self validateEmail:_emailField.text])
    {
        errorMsg = NSLocalizedString(@"errorMsg1", nil);
        [self showError:errorMsg];
        return;
    }
    if(!_pwField.text.length)
    {
        errorMsg = NSLocalizedString(@"errorMsg2", nil);
        [self showError:errorMsg];
        return;
    }
    else if(_pwField.text.length<6)
    {
        errorMsg = NSLocalizedString(@"errorMsg3", nil);
        [self showError:errorMsg];
        return;
    }
    if(!_confirmPwField.text.length)
    {
        errorMsg = NSLocalizedString(@"errorMsg4", nil);
        [self showError:errorMsg];
        return;
    }
    if(![_confirmPwField.text isEqualToString:_pwField.text])
    {
        errorMsg = NSLocalizedString(@"errorMsg5", nil);
        [self showError:errorMsg];
        return;
    }
   /* if(!_checkCodeField.text.length)
    {
        errorMsg = @"请输入验证码";
        [self showError:errorMsg];
        return;
    }*/
    
   /* 网址　http://www.halfeet.com/_user_login/_register_email.php?jsonfrom=
    参数　{"fc":"register_email","email":"www@gmail.com","pass":"123456","plong":"113199203","plat":"23633104"}
    返回　{"fc":"register_email","email":"abcd123456@gmail.com","regok":"y","loginid":"20120707205138-BBA7CD0A-6BCA-B760-3C69-7A1AC10B522A","serveron":"127.0.0.1"}
    
    email值为用户邮箱
    pass值为密码
    long值为经度，lat为纬度
    regok值为y表示注册成功，值为n表示注册不成功
    loginid值为注册成功时返回的唯一标识id，供后期调用时向服务器端提交此值
    serveron值为分配的服务器，部分接口功能需发送请求到该返回值指定的服务器
    *本接口调用时，已同时完成登录并取得登录id*/
    
    
//    NSMutableDictionary *regDic = [NSMutableDictionary dictionary];
//    [regDic setValue:_emailField.text forKey:@"email"];
//    [regDic setValue:_pwField.text forKey:@"pass"];
//    [regDic setValue:[NSString stringWithFormat:@"%.f",AppLocationManager.curLocation.latitude*1000000] forKey:@"plat"];
//    [regDic setValue:[NSString stringWithFormat:@"%.f",AppLocationManager.curLocation.longitude*1000000] forKey:@"plong"];
//    
//    [AppComManager getBanBuData:BanBu_Register_Email par:regDic delegate:self];
//    self.navigationController.view.userInteractionEnabled = NO;
//     [TKLoadingView showTkloadingAddedTo:self.view title:@"正在注册……" activityAnimated:YES];
//    if(canNext){
//        BanBu_NameAndSexController *nameVC = [[BanBu_NameAndSexController alloc] initWithViewType:NameAndSexViewFullType];
//        [self.navigationController pushViewController:nameVC animated:YES];
//        [nameVC release];
//        
//    }else{
//        NSMutableDictionary *checkDic = [NSMutableDictionary dictionary];
//        [checkDic setValue:_emailField.text forKey:@"email"];
//        
//        [AppComManager getBanBuData:BanBu_Check_Email par:checkDic delegate:self];
//        self.navigationController.view.userInteractionEnabled = NO;
//        [TKLoadingView showTkloadingAddedTo:self.view title:@"正在检测邮箱" activityAnimated:YES];
//    }
    [MyAppDataManager.regDic setValue:_emailField.text forKey:@"email"];
    [MyAppDataManager.regDic setValue:_pwField.text forKey:@"pass"];

    if(canNext){
        
        
        /*改动了*/
        BanBu_NameAndSexController *nameVC = [[BanBu_NameAndSexController alloc] initWithViewType:NameAndSexViewFullType];
        [self.navigationController pushViewController:nameVC animated:YES];
        [nameVC release];
    }else{
        isTrue = YES;
        NSMutableDictionary *checkDic = [NSMutableDictionary dictionary];
        [checkDic setValue:_emailField.text forKey:@"email"];
        
        [AppComManager getBanBuData:BanBu_Check_Email par:checkDic delegate:self];
        self.navigationController.view.userInteractionEnabled = NO;
        [TKLoadingView showTkloadingAddedTo:self.view title:NSLocalizedString(@"detectEmail", nil) activityAnimated:YES];
    }
    
}

//-(BOOL) respondsToSelector:(SEL)aSelector {
//    printf("SELECTOR: %s\n", [NSStringFromSelector(aSelector) UTF8String]);
//    return [super respondsToSelector:aSelector];
//}


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

    return 3;
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
    return NSLocalizedString(@"bottomNotice", nil);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell == nil)
    {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        
        
    }
    UITextField *textField = (UITextField *)[cell viewWithTag:111];
    if(!textField)
    {
        textField = [[UITextField alloc] initWithFrame:CGRectMake(105, 10, 180, 25)];
        textField.delegate = self;
        textField.tag = 111;
        textField.backgroundColor = [UIColor clearColor];
        textField.borderStyle = UITextBorderStyleNone;
        textField.clearsOnBeginEditing = NO;
        textField.textColor = [UIColor colorWithRed:50.0/255 green:79.0/255 blue:133.0/255 alpha:1.0];
        textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        textField.returnKeyType = UIReturnKeyNext;
        [cell addSubview:textField];
        [textField release];
    }
    if(!indexPath.row)
    {
        cell.textLabel.text = NSLocalizedString(@"emailLabel", nil);        
        _emailField = textField;
        CGFloat btnLen = [NSLocalizedString(@"emailLabel", nil) sizeWithFont:[UIFont systemFontOfSize:16] constrainedToSize:CGSizeMake(150, 30)].width;
        _emailField.frame = CGRectMake(btnLen+30+5, 10, 270-btnLen, 25);
        textField.placeholder = @"you@domain.com";
        textField.keyboardType = UIKeyboardTypeEmailAddress;
        if([MyAppDataManager.regDic objectForKey:@"email"]){
            _emailField.text =  [MyAppDataManager.regDic objectForKey:@"email"];
            _emailField.userInteractionEnabled = NO;
        }else{
            _emailField.userInteractionEnabled = YES;
        }
//        textField.text = @"zjc123@170.com";
        
    }
    else if(indexPath.row == 1)
    {
        cell.textLabel.text = NSLocalizedString(@"passwordLabel", nil);
        _pwField = textField;
        CGFloat btnLen = [NSLocalizedString(@"passwordLabel", nil) sizeWithFont:[UIFont systemFontOfSize:16] constrainedToSize:CGSizeMake(150, 30)].width;
        _pwField.frame = CGRectMake(btnLen+30+5, 10, 270-btnLen, 25);
        textField.placeholder = NSLocalizedString(@"pPlaceholder", nil);
        textField.keyboardType = UIKeyboardTypeASCIICapable;
        textField.secureTextEntry = YES;
        
//        textField.text = @"123456";
        
        
    }
    else if(indexPath.row == 2)
    {
        cell.textLabel.text = NSLocalizedString(@"confirmationLabel", nil);
        _confirmPwField = textField;
        CGFloat btnLen = [NSLocalizedString(@"confirmationLabel", nil) sizeWithFont:[UIFont systemFontOfSize:16] constrainedToSize:CGSizeMake(150, 30)].width;
        _confirmPwField.frame = CGRectMake(btnLen+30+5, 10, 270-btnLen, 25);
        textField.placeholder = NSLocalizedString(@"cPlaceholedr", nil);
        textField.keyboardType = UIKeyboardTypeASCIICapable;
        textField.returnKeyType = UIReturnKeyGo;
        textField.secureTextEntry = YES;
        
        
//        textField.text = @"123456";
    }
    else if(indexPath.row == 3)
    {
        textField.frame = CGRectMake(100, 10, 100, 25);
        cell.textLabel.text = @"验证码";
        _checkCodeField = textField;
        textField.placeholder = @"点击刷新";
        textField.keyboardType = UIKeyboardTypeASCIICapable;
        textField.returnKeyType = UIReturnKeyGo;
        
        if(!_randCodeView)
        {
            _randCodeView = [[UIImageView alloc] initWithFrame:CGRectMake(200, 10, 78, 26)];
            _randCodeView.backgroundColor = self.tableView.backgroundColor;
            _randCodeView.userInteractionEnabled = YES;
            [cell.contentView addSubview:_randCodeView];
            [_randCodeView release];
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapToGetRandCode:)];
            [_randCodeView addGestureRecognizer:tap];
            [tap release];
        }
        [self performSelector:@selector(tapToGetRandCode:)];
    }

   

    return cell;

}

- (void)tapToGetRandCode:(UITapGestureRecognizer *)tap
{
    
    UIActivityIndicatorView *loading = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    loading.frame = CGRectMake((_randCodeView.frame.size.width-16)/2, 5, 16, 16);
    [_randCodeView addSubview:loading];
    [loading startAnimating];
    [loading release];
    [NSThread detachNewThreadSelector:@selector(getNewRandCode) toTarget:self withObject:nil];
    
}

- (void)getNewRandCode
{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    UIImage *image = nil;//[TicketAPIs freshRandCode];
    [self performSelectorOnMainThread:@selector(showRandCode:) withObject:image waitUntilDone:NO];
    [pool release];
}


- (void)showRandCode:(UIImage *)image
{
    for (UIActivityIndicatorView *loading in _randCodeView.subviews)
    {
        if([loading isKindOfClass:[UIActivityIndicatorView class]])
            [loading removeFromSuperview];
    }
    _randCodeView.image = image;
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if(textField != _confirmPwField)
    {
        UITableViewCell *cell = (UITableViewCell *)textField.superview;
        NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
        indexPath = [NSIndexPath indexPathForRow:indexPath.row+1 inSection:indexPath.section];
        UITextField *inputField = (UITextField *)[[self.tableView cellForRowAtIndexPath:indexPath] viewWithTag:111];
        [inputField becomeFirstResponder];
    }
    else 
    {
        [self performSelector:@selector(nextStep:) withObject:nil];
    }
    
    return  YES;
}

/*检验邮箱是否可用
网址　http://www.halfeet.com/_user_login/_check_email_exist.php?jsonfrom=
参数　{"fc":"check_email_exist","email":"abcd123456@163.com"}
返回　{"fc":"check_email_exist","email":"abcd123456@163.com","exist":"n"}

email值为用户邮箱
exist值为n表示检查邮箱不存在，值为y表示检查邮箱已存在*/


- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if(textField == _emailField)
    {
        NSString *errorMsg = nil;
        if(!_emailField.text.length)
        {
            errorMsg = NSLocalizedString(@"errorMsg", nil);
        }
        if(![self validateEmail:_emailField.text])
        {
            errorMsg = NSLocalizedString(@"errorMsg1", nil);
        }

        if(errorMsg)
        {
            [_emailField becomeFirstResponder];
            [self showError:errorMsg];

            return;
        }

        if(!isTrue){
            NSMutableDictionary *checkDic = [NSMutableDictionary dictionary];
            [checkDic setValue:_emailField.text forKey:@"email"];
            
            [AppComManager getBanBuData:BanBu_Check_Email par:checkDic delegate:self];
            self.navigationController.view.userInteractionEnabled = NO;
            [TKLoadingView showTkloadingAddedTo:self.view title:NSLocalizedString(@"detectEmail", nil) activityAnimated:YES];
        }
        
        
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

- (void)banbuRequestDidFinished:(NSDictionary *)resDic error:(NSError *)error
{
    self.navigationController.view.userInteractionEnabled = YES;
    [TKLoadingView dismissTkFromView:self.view animated:YES afterShow:0.0];
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
    
NSLog(@"res:%@",resDic);
    
    if([AppComManager respondsDic:resDic isFunctionData:BanBu_Check_Email])
    {
        if([[resDic valueForKey:@"ok"] boolValue]){
            [TKLoadingView showTkloadingAddedTo:self.view title:NSLocalizedString(@"successEmail", nil) activityAnimated:NO duration:1.0];
            if(isTrue){
//                [MyAppDataManager.regDic setValue:_emailField.text forKey:@"email"];
//                [MyAppDataManager.regDic setValue:_pwField.text forKey:@"pass"];
                BanBu_NameAndSexController *nameVC = [[BanBu_NameAndSexController alloc] initWithViewType:NameAndSexViewFullType];
                [self.navigationController pushViewController:nameVC animated:YES];
                [nameVC release];
                isTrue =NO;

//                self performSelector:@selector(12) withObject:<#(id)#> afterDelay:1.0]
            }
            canNext = YES;
           
        }
        else
        {
            canNext = NO;
            [TKLoadingView showTkloadingAddedTo:self.view title:[MyAppDataManager IsInternationalLanguage:[resDic valueForKey:@"error"]] activityAnimated:NO duration:2.0];
            [_emailField becomeFirstResponder];
        }
    }
    else
    {
        
//        BOOL regOK = [[resDic valueForKey:@"ok"] boolValue];
//        if(regOK)
//        {
//            MyAppDataManager.loginid = [resDic valueForKey:@"loginid"];
//            BanBu_NameAndSexController *nameVC = [[BanBu_NameAndSexController alloc] initWithViewType:NameAndSexViewFullType];
//            [self.navigationController pushViewController:nameVC animated:YES];
//            [nameVC release];
//        }
//        else
//            [TKLoadingView showTkloadingAddedTo:self.view title:[resDic valueForKey:@"error"] activityAnimated:NO duration:2.0];

            
    }
}

//-(void)pushNextController{
//    [MyAppDataManager.regDic setValue:_emailField.text forKey:@"email"];
//    [MyAppDataManager.regDic setValue:_pwField.text forKey:@"pass"];
//    BanBu_NameAndSexController *nameVC = [[BanBu_NameAndSexController alloc] initWithViewType:NameAndSexViewFullType];
//    [self.navigationController pushViewController:nameVC animated:YES];
//    [nameVC release];
//    isTrue =NO;
//}


- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    _emailField.delegate = nil;
    [_emailField resignFirstResponder];
    [_pwField resignFirstResponder];
    [_confirmPwField resignFirstResponder];

}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    _emailField.delegate =self;
    canNext = NO;
    isTrue = NO;

}


@end
