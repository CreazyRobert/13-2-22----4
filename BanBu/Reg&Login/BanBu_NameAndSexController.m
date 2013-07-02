//
//  BanBu_NameAndSexController.m
//  BanBu
//
//  Created by jie zheng on 12-7-6.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "BanBu_NameAndSexController.h"
#import "BanBu_BloodTypeAndHeightController.h"
#import "AppDataManager.h"
#import "TKLoadingView.h"

@interface BanBu_NameAndSexController ()

@end

@implementation BanBu_NameAndSexController

@synthesize viewType = _viewType;
@synthesize name = _name;
@synthesize sex = _sex;

// 获取当前机器语言
-(NSString*)getPreferredLanguage
{
    NSUserDefaults* defs = [NSUserDefaults standardUserDefaults];
    NSArray* languages = [defs objectForKey:@"AppleLanguages"];
    NSString* preferredLang = [languages objectAtIndex:0];
    return preferredLang;
}

- (id)initWithViewType:(NameAndSexViewType)type
{
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self) {

        _viewType = type;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

//    NSLog(@"%@%@",[MyAppDataManager.regDic valueForKey:@"pname"],[MyAppDataManager.regDic valueForKey:@"gender"]);
    
    self.tableView.backgroundView = nil;
    self.tableView.backgroundColor = [UIColor colorWithRed:255.0/255 green:250.0/255 blue:240.0/255 alpha:1.0];
    if(_viewType == NameAndSexViewFullType)
        self.title = NSLocalizedString(@"nameAndSexTitle", nil);
    else 
        self.title = NSLocalizedString(@"nameLabel", nil);
    
    if(_viewType == NameAndSexViewFullType)
    {
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
        
        NSArray *items;
        
        NSString *langauage=[self getPreferredLanguage];
        if([langauage isEqual:@"zh-Hans"])
        {
            items = [NSArray arrayWithObjects:@"          男 ♂          ",@"          女 ♀          ",nil];
        }else if ([langauage isEqual:@"ja"])
        {
            items = [NSArray arrayWithObjects:@"         男性 ♂          ",@"         女性 ♀          ",nil];
        }else
        {
            items = [NSArray arrayWithObjects:@"          Male ♂          ",@"          Female ♀          ",nil];
        }
        SVSegmentedControl *seg = [[SVSegmentedControl alloc] initWithSectionTitles:items];
//        seg.backgroundColor = [UIColor colorWithWhite:0 alpha:.7];
        seg.frame = CGRectMake(35, 100, 250, 30);
        seg.center = CGPointMake(160, 135);
        seg.crossFadeLabelsOnDrag = YES;
//        seg.thumb.tintColor = [UIColor colorWithRed:0.6 green:0.2 blue:0.2 alpha:1];
        seg.thumb.tintColor = [UIColor colorWithRed:252.0/255 green:192.0/255 blue:213.0/255 alpha:1.0];
        seg.backgroundColor = [UIColor colorWithWhite:0 alpha:.2];
        seg.selectedIndex = 0;
        if(MyAppDataManager.regDic){
            NSInteger sexInteger;
            if([[MyAppDataManager.regDic valueForKey:@"gender"] isEqualToString:@"m"]){
                sexInteger = 0;
            }else{
                sexInteger = 1;
            }
            seg.selectedIndex =sexInteger;
        }else{
            seg.selectedIndex =1;

        }
        [seg addTarget:self action:@selector(segmentedControlDidChangeValue:) forControlEvents:UIControlEventValueChanged];
        _sexSeg = seg;
        [self.view addSubview:seg];
        [seg release];
        
    }
}

- (void)segmentedControlDidChangeValue:(SVSegmentedControl *)seg
{
//    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"小提示"
//                                                    message:@"请确定你的选择，一旦提交无法更改！" delegate:nil
//                                          cancelButtonTitle:@"确定"
//                                          otherButtonTitles:nil, nil];
//    [alert show];
//    [alert release];
    if([_nameField isFirstResponder]){
        [_nameField resignFirstResponder];

    }
    if(seg.selectedIndex){
        seg.thumb.tintColor = [UIColor colorWithRed:252.0/255 green:192.0/255 blue:213.0/255 alpha:1.0];

    }else{
        seg.thumb.tintColor = [UIColor colorWithRed:48.0/255 green:169.0/255 blue:217.0/255 alpha:1.0];

    }
    [TKLoadingView showTkloadingAddedTo:self.view point:CGPointMake(0, 152) title:NSLocalizedString(@"changeNotice", nil) activityAnimated:NO duration:1.0];

}


- (void)viewDidUnload
{
    [super viewDidUnload];
    self.name = nil;
    
}

- (void)dealloc
{
    [_name release];
    [super dealloc];
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

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
    return NSLocalizedString(@"nameNotice", nil);
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
        textField = [[UITextField alloc] initWithFrame:CGRectMake(100, 10, 180, 25)];
        if(_viewType == NameAndSexViewNameOnlyType)
            textField.frame = CGRectMake(20, 10, 280, 25);
        textField.tag = 111;
        textField.backgroundColor = [UIColor clearColor];
        textField.borderStyle = UITextBorderStyleNone;
        textField.textColor = [UIColor colorWithRed:50.0/255 green:79.0/255 blue:133.0/255 alpha:1.0];
        textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        textField.returnKeyType = UIReturnKeyNext;
        [cell addSubview:textField];
        [textField release];
        if(_viewType == NameAndSexViewFullType)
            cell.textLabel.text = NSLocalizedString(@"nameLabel", nil);
        _nameField = textField;
        textField.placeholder =NSLocalizedString(@"namePlaceholder", nil);
        if(MyAppDataManager.regDic){
            textField.text = [MyAppDataManager.regDic valueForKey:@"pname"];
        }
        if(_name)
            textField.text = _name;
    }
    
    return cell;

}

- (void)nextStep:(UIButton *)button
{
    if(![[_nameField.text stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]] length] )
    {
//        for (TKLoadingView *loading in [self.view subviews]) {
//            if ([loading isKindOfClass:[TKLoadingView class]])
//                [loading removeFromSuperview];
//        }
//        TKLoadingView *loading = [[[TKLoadingView alloc] initWithTitle:@"请输入您的名字"] autorelease];
//        [loading showWithActivityAnimating:NO inView:self.view];
//        [loading dismissAfterDelay:1.0 animated:YES];
//        CGRect rect = loading.frame;
//        rect.origin.y = 140;
//        //NSLog(@"%f",rect.origin.x);
//        loading.frame = rect;
        
        [TKLoadingView showTkloadingAddedTo:self.view point:CGPointMake(0, 140) title:NSLocalizedString(@"namePlaceholder", nil) activityAnimated:NO duration:1.0];
//        [TKLoadingView showTkloadingAddedTo:self.view title:@"请输入您的名字" activityAnimated:NO duration:1.0];
        return;
    }
    NSString *sexStr = [NSString stringWithFormat:@"%@%@",NSLocalizedString(@"selectSex", nil),_sexSeg.selectedIndex?NSLocalizedString(@"girl", nil):NSLocalizedString(@"boy", nil)];
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"helpfulTitle", nil) message:sexStr delegate:self cancelButtonTitle:NSLocalizedString(@"editSex", nil) otherButtonTitles:NSLocalizedString(@"confirmNotice", nil), nil];
    [alert show];
    [alert release];

    
}

- (void)setName:(NSString *)name
{
    [_name release];
    _name = [name retain];
    [self.tableView reloadData];
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(buttonIndex){
        [MyAppDataManager.regDic setValue:[MyAppDataManager IsMinGanWord:_nameField.text] forKey:@"pname"];
        [MyAppDataManager.regDic setValue:_sexSeg.selectedIndex?@"f":@"m" forKey:@"gender"];
        
        BanBu_BloodTypeAndHeightController *blood = [[BanBu_BloodTypeAndHeightController alloc] init];
        [self.navigationController pushViewController:blood animated:YES];
        [blood release];
    }
}


@end
