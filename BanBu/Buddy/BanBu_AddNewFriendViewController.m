//
//  BanBu_AddNewFriendViewController.m
//  BanBu
//
//  Created by laiguo zheng on 12-7-12.
//  Copyright (c) 2012年 17xy. All rights reserved.
//

#import "BanBu_AddNewFriendViewController.h"
#import "BanBu_PeopleProfileController.h"
#import "QRCodeGenerator.h"
#import "NSData+Base64.h"
@interface BanBu_AddNewFriendViewController ()

@end

@implementation BanBu_AddNewFriendViewController

- (id)init
{
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self) {
        
       
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView.backgroundView = nil;
    self.tableView.backgroundColor = [UIColor colorWithRed:255.0/255 green:250.0/255 blue:240.0/255 alpha:1.0];
    self.tableView.scrollEnabled = NO;
    
     self.title = NSLocalizedString(@"andNewFriendTitle", nil);
 
    flag=NO;
    
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 100)];
    footerView.backgroundColor = [UIColor clearColor];
    UIButton *searchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    searchBtn.frame = CGRectMake(10, 10, 300, 40);
    [searchBtn setBackgroundImage:[[UIImage imageNamed:@"app_btn_blue.png"] stretchableImageWithLeftCapWidth:10.0 topCapHeight:0.0] forState:UIControlStateNormal];
    [searchBtn setTitle:NSLocalizedString(@"searchBtn", nil) forState:UIControlStateNormal];
    [searchBtn addTarget:self action:@selector(searchFriend:) forControlEvents:UIControlEventTouchUpInside];
    [footerView addSubview:searchBtn];
    
    UIButton *zibar=[UIButton buttonWithType:UIButtonTypeCustom];
    
    zibar.frame=CGRectMake(10, 60, 300, 40);
    
    [zibar setBackgroundImage:[[UIImage imageNamed:@"app_btn_blue.png"] stretchableImageWithLeftCapWidth:10.0 topCapHeight:0.0] forState:UIControlStateNormal];
    
    [zibar setTitle:NSLocalizedString(@"zibarBtn", nil) forState:UIControlStateNormal];
     
    [zibar addTarget:self action:@selector(showZbar:) forControlEvents:UIControlEventTouchUpInside];
    
//    [footerView addSubview:zibar];
    
    
    self.tableView.tableFooterView = footerView;
    
    [footerView release];

}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [_IDInput becomeFirstResponder];

}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [AppComManager cancalHandlesForObject:self];
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

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [_IDInput resignFirstResponder];
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

- (float)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 300, 40)];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.text = [NSString stringWithFormat:@"    %@",NSLocalizedString(@"headerAndholder", nil)];
    titleLabel.textColor = [UIColor viewFlipsideBackgroundColor];
    return [titleLabel autorelease];
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
    
    UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(20, 10, 280, 30)];
    _IDInput = textField;
    textField.delegate = self;
    textField.backgroundColor = [UIColor clearColor];
    textField.borderStyle = UITextBorderStyleNone;
//    textField.keyboardType = UIKeyboardTypeNumberPad;
    textField.textColor = [UIColor colorWithRed:50.0/255 green:79.0/255 blue:133.0/255 alpha:1.0];
    textField.placeholder = NSLocalizedString(@"headerAndholder", nil);
//    textField.clearButtonMode = UITextFieldViewModeWhileEditing;
//    textField.returnKeyType = UIReturnKeyNext;
    [cell addSubview:textField];
    [textField release];
    
    return cell;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)validateEmail:(NSString *)email {
    NSString *emailRegex = @"^\\w+([-+.]\\w+)*@\\w+([-.]\\w+)*\\.\\w+([-.]\\w+)*$";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}

- (void)searchFriend:(UIButton *)button
{
    
    [_IDInput resignFirstResponder];
    if(!_IDInput.text.length)
    {
        [TKLoadingView showTkloadingAddedTo:self.view title:NSLocalizedString(@"nilNotice", nil) activityAnimated:NO duration:1.0];
        return;
    }
    if([MyAppDataManager.useruid isEqualToString:_IDInput.text]){
        [TKLoadingView showTkloadingAddedTo:self.view title:NSLocalizedString(@"selfNotice", nil) activityAnimated:NO duration:1.0];
        return;
    }
    if([self validateEmail:_IDInput.text] || [_IDInput.text intValue]){
        
        NSMutableDictionary *pars = [NSMutableDictionary dictionaryWithCapacity:2];
        [pars setValue:_IDInput.text forKey:@"email_uid"];
        [AppComManager getBanBuData:BanBu_Get_User_Info par:pars delegate:self];
        [TKLoadingView showTkloadingAddedTo:self.view title:NSLocalizedString(@"searchNotice", nil) activityAnimated:YES];
//        self.navigationController.view.userInteractionEnabled = NO;
        
        
    }else{
               
        [TKLoadingView showTkloadingAddedTo:self.view title:NSLocalizedString(@"emailError", nil) activityAnimated:NO duration:1.0];

    }
    
    
   
}

-(void)showZbar:(UIButton *)sender
{
   
        
    reader = [ZBarReaderViewController new];
    
    reader.title=NSLocalizedString(@"readerTitle", nil);
    
    UIButton *btn_return=[UIButton buttonWithType:UIButtonTypeCustom];
    
    [btn_return addTarget:self action:@selector(popself) forControlEvents:UIControlEventTouchUpInside];
    
    [btn_return setBackgroundImage:[[UIImage imageNamed:@"app_nav_back_bg1.png"] stretchableImageWithLeftCapWidth:15.0 topCapHeight:15.0] forState:UIControlStateNormal];
//    [btn_return setBackgroundImage:[[UIImage imageNamed:@"app_nav_back_bg2.png"] stretchableImageWithLeftCapWidth:15.0 topCapHeight:15.0] forState:UIControlStateHighlighted];
    btn_return.frame=CGRectMake(0, 0, 48, 30);
    [btn_return setTitleEdgeInsets:UIEdgeInsetsMake(3, 9, 2, 2)];
    [btn_return setTitle:NSLocalizedString(@"returnButton", nil) forState:UIControlStateNormal];
    btn_return.titleLabel.font = [UIFont systemFontOfSize:14];
    
    reader.navigationItem.leftBarButtonItem=[[[UIBarButtonItem alloc]initWithCustomView:btn_return] autorelease];

    
    for(UIView *t in reader.view.subviews)
    {
        //        //NSLog(@"k k k %@",t);
        
        
        // 建立新图 把老图覆盖住
        
        // 下面的横条
        if([t isKindOfClass:[UIView class]]&&t.frame.origin.y==426)
        {
            [t setHidden:YES];
//            UIToolbar *temp =[[UIToolbar alloc]init];
//            temp = (UIToolbar *)t;
//            UIBarButtonItem *aBar = [[UIBarButtonItem alloc]initWithBarButtonSystemIt em:UIButtonTypeInfoLight target:self action:nil];
//            t.items = [NSArray arrayWithObject:aBar];
            
        }else
        {
        //  t.frame=CGRectMake(35, 112, 252, 229);
            
//            lineImage=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, t.frame.size.width, 4)];
//            
//            lineImage.image=[UIImage imageNamed:@"scan_line.png"];
//            
//            lineImage.hidden=YES;
//            
//            [t addSubview:lineImage];
//            
//            [lineImage release];
//            
//          
//            time=[NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(Look) userInfo:nil repeats:YES];
//            
            
          //  t.superview.backgroundColor=[UIColor whiteColor];
            

        
        }
    
    
    
    
    }

    reader.readerDelegate = self;
    reader.supportedOrientationsMask = ZBarOrientationMaskAll;
    
    ZBarImageScanner *scanner = reader.scanner;
    
    [scanner setSymbology: ZBAR_I25
                   config: ZBAR_CFG_ENABLE
                       to: 0];

//    [self presentModalViewController:reader animated:YES];
//    reader.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:reader animated:YES];
   
    [reader release];
 
    
}






-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
   
    reader.view.backgroundColor=[UIColor blackColor];
    
     flag=YES;
    
    [TKLoadingView showTkloadingAddedTo:reader.view title:NSLocalizedString(@"chuliNotice", nil) activityAnimated:YES];
    

    id<NSFastEnumeration> results =
    [info objectForKey: ZBarReaderControllerResults];
    ZBarSymbol *symbol = nil;
    for(symbol in results)
        break;
   
    
    // 判断这个字符串是不是本公司的
    
  
    
    NSString *corpStr=@"halfeet.com";
    
    NSRange range=[symbol.data rangeOfString:corpStr];
    
 //   [lineImage setHidden:YES];
    
    if(range.length==0)
    {
        flag=NO;
        [TKLoadingView dismissTkFromView:reader.view animated:YES afterShow:0.5];
    // this is the 不是本公司的
        MyAppDataManager.zibarString=symbol.data;
        BanBu_zbar *ZBAR=[[BanBu_zbar alloc]init];
        
        [self.navigationController pushViewController:ZBAR animated:NO];
        
        [ZBAR release];
        
    
    }else{
        //NSLog(@"sym%@",symbol.data);

     // 是本公司的
        NSInteger i=[symbol.data rangeOfString:@"code"].location+7;
        
        NSString *string=[symbol.data substringWithRange:NSMakeRange(i, symbol.data.length-2-i)];
        //NSLog(@" string %@",string);

        NSData *data=[NSData dataFromBase64String:string];
      
        //NSLog(@"%@",data);
    NSDictionary *dic=[NSDictionary dictionaryWithJSONData:data error:nil];
    
        //NSLog(@"&&&%@",dic);
        
        
//        string=[[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding] autorelease];
        
        
        //NSLog(@" what is this string %@",string);
        
        
        
        NSMutableDictionary *informationDic=[[NSMutableDictionary alloc]initWithDictionary:dic];
        
        [informationDic setValue:MyAppDataManager.loginid  forKey:@"loginid"];
        
        [informationDic setValue:[dic objectForKey:@"email_uid"] forKey:@"email_uid"];
        
        
        [AppComManager getBanBuData:BanBu_Get_User_Info par:informationDic delegate:self];
        //NSLog(@"%@",informationDic);
        [informationDic release];
        
    
    }

}

-(void)Look
{
    //NSLog(@"ee");
   
   
    lineImage.hidden=NO;
    
    CGRect frame=lineImage.frame;
    
    frame.origin.y=frame.origin.y+0.5;
    
    lineImage.frame=frame;
    if(lineImage.frame.origin.y>229)
    {
        CGRect frame=CGRectMake(0, 0, 252, 4);
        
        lineImage.frame=frame;
        
        
    }
    
}
-(void)More:(UIBarButtonItem *)buttonItem
{
    static BOOL flag1=NO;
    
    flag1=!flag1;
    
    ZBarReaderController *zipt=nil;
    
    for(ZBarReaderController *zip in [self.navigationController viewControllers])
    {
        
        zipt=(ZBarReaderController *)[[self.navigationController viewControllers] objectAtIndex:2];
        
        
    }
    
    if(zipt)
    {
        
        if(flag==YES)
        {
            
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"what" message:nil delegate:self cancelButtonTitle:@" i know" otherButtonTitles: nil];
            
            [alert show];
            
            [alert release];
            
            
            // [self.navigationController popToRootViewControllerAnimated:YES];
            
        } 
    }
    
    
    
    
    
}

-(void)popself
{
    //NSLog(@"t t t %d",flag);
    
    if(flag==YES)
    {
  //  [time invalidate];
        
       
        
        [TKLoadingView showTkloadingAddedTo:self.navigationController.view title:NSLocalizedString(@"resquesting", inline) activityAnimated:NO duration:1.5];
        
        return;
    }
    
    
    
    [self.navigationController popViewControllerAnimated:YES];

}

- (void)banbuRequestDidFinished:(NSDictionary *)resDic error:(NSError *)error
{
    self.navigationController.view.userInteractionEnabled = YES;
    [TKLoadingView dismissTkFromView:self.view animated:YES afterShow:0.0];
    [TKLoadingView dismissTkFromView:reader.view animated:YES afterShow:0.0];

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
        flag=NO;

        return;
    }
    
//    NSLog(@"%@",resDic);
    if([AppComManager respondsDic:resDic isFunctionData:BanBu_Get_User_Info]){

        if([[resDic valueForKey:@"ok"]boolValue]){
     
            NSDictionary *_profile = [NSDictionary dictionaryWithDictionary:resDic];
            BanBu_PeopleProfileController *people = [[BanBu_PeopleProfileController alloc] initWithProfile:_profile displayType:DisplayTypePeopleProfile];
            [self.navigationController pushViewController:people animated:YES];
            [people release];
            
            
            flag=NO;

        }else{
            flag=NO;

            [TKLoadingView showTkloadingAddedTo:self.view title:[MyAppDataManager IsInternationalLanguage:[resDic valueForKey:@"error"]] activityAnimated:NO duration:1.0];
        }
        
        
    }

       
    


    

}










@end
