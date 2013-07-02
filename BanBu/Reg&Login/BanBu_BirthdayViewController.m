//
//  BanBu_BirthdayViewController.m
//  BanBu
//
//  Created by jie zheng on 12-7-6.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "BanBu_BirthdayViewController.h"
#import "BanBu_SetAvatarViewController.h"
#import "AppDataManager.h"
#import "AppCommunicationManager.h"
#import "TKLoadingView.h"

@interface BanBu_BirthdayViewController ()

@end

@implementation BanBu_BirthdayViewController

@synthesize birthdayPicker = _birthdayPicker;
@synthesize birthdayStr = _birthdayStr;

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
    self.tableView.scrollEnabled = NO;
    self.tableView.backgroundView = nil;
    self.tableView.backgroundColor = [UIColor colorWithRed:255.0/255 green:250.0/255 blue:240.0/255 alpha:1.0];
    self.title = NSLocalizedString(@"birthdayTitle", nil);
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
    UIDatePicker *datePicker = [ [ UIDatePicker alloc] initWithFrame:CGRectMake(0.0,__MainScreen_Height-260,0.0,0.0)];

    
    self.birthdayPicker = datePicker;
    [datePicker addTarget:self action:@selector(dateDidChanged:) forControlEvents:UIControlEventValueChanged];
    datePicker.datePickerMode = UIDatePickerModeDate;
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    [formatter setLocale:[NSLocale currentLocale]];
    
    NSString *dateStr = [formatter stringFromDate:[NSDate date]];

    dateStr = [dateStr stringByReplacingCharactersInRange:NSMakeRange(0, 4) withString:[NSString stringWithFormat:@"%i",[[dateStr substringToIndex:4] intValue]-18]];

    NSDate *miniDate = [formatter dateFromString:dateStr];
    datePicker.maximumDate = miniDate;
//    dateStr = [dateStr stringByReplacingCharactersInRange:NSMakeRange(8, 2) withString:[NSString stringWithFormat:@"%d",[[dateStr substringFromIndex:8]intValue]-1]];
//        NSLog(@"%@",dateStr);
    NSDate *maxDate = [NSDate dateWithTimeInterval:-(24*60*60) sinceDate:miniDate];
    
//    NSDate *maxDate = [formatter dateFromString:dateStr];
    [formatter release];
    NSLog(@"%@",maxDate);
    datePicker.date = maxDate;
    [self.view addSubview:datePicker];  
    [datePicker release];
    
    [self.tableView reloadData];
}

-(void)viewDidAppear:(BOOL)animated{
   
    if(!isFirst){
        NSInteger age = 0;
        NSInteger currentDate[3];
        NSInteger pickDate[3];
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"YYYY-MM-dd"];
        
        NSString *dateStr = [formatter stringFromDate:[NSDate date]];
        
        dateStr = [dateStr stringByReplacingCharactersInRange:NSMakeRange(0, 4) withString:[NSString stringWithFormat:@"%i",[[dateStr substringToIndex:4] intValue]-18]];
    
        if([MyAppDataManager.regDic objectForKey:@"borndate"]){
            self.birthdayStr = [MyAppDataManager.regDic objectForKey:@"borndate"];
        }else{
            self.birthdayStr = dateStr;

        }
        //NSLog(@"%@",self.birthdayStr);
        NSArray *pickDateArr = [_birthdayStr componentsSeparatedByString:@"-"];
        NSArray *nowDateArr = [[formatter stringFromDate:[NSDate date]] componentsSeparatedByString:@"-"];
        
        for(int i=0; i<3; i++)
        {
            pickDate[i] = [[pickDateArr objectAtIndex:i] intValue];
            currentDate[i] = [[nowDateArr objectAtIndex:i] intValue];
        }
        
        age = currentDate[0] - pickDate[0]-1;
        if((currentDate[1]>pickDate[1]) ||((currentDate[1]=pickDate[1]) && (currentDate[2]>=pickDate[2])))
            age ++;
        UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%i%@",age,NSLocalizedString(@"ageNumber", nil)];
        cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
        cell.detailTextLabel.text = [self xingzuoForMoth:pickDate[1] day:pickDate[2]];
        [self.tableView reloadData];
        isFirst = YES;
    }
}
- (void)setDate:(NSDate *)date
{
    [self.birthdayPicker setDate:date animated:YES];
    [self.birthdayPicker sendActionsForControlEvents:UIControlEventValueChanged];
}

- (NSString *)xingzuoForMoth:(NSInteger)month day:(NSInteger)day
{
    NSArray *array = [NSArray arrayWithObjects:NSLocalizedString(@"starItem", nil),NSLocalizedString(@"starItem1", nil),NSLocalizedString(@"starItem2", nil),NSLocalizedString(@"starItem3", nil),NSLocalizedString(@"starItem4", nil),NSLocalizedString(@"starItem5", nil),NSLocalizedString(@"starItem6", nil),NSLocalizedString(@"starItem7", nil),NSLocalizedString(@"starItem8", nil),NSLocalizedString(@"starItem9", nil),NSLocalizedString(@"starItem10", nil),NSLocalizedString(@"starItem11", nil),nil];
    int sep[12] = {20,19,21,20,21,22,23,23,23,24,23,22};
    NSInteger index = month-1;
    index = (day<sep[index])?--index:index;
    if(index < 0)
        index = 11;
    return [array objectAtIndex:index];
}

- (void)dateDidChanged:(UIDatePicker *)picker
{
    NSDateFormatter *formatter1 = [[NSDateFormatter alloc] init];
    [formatter1 setDateFormat:@"yyyy-MM-dd"];
    
    NSString *dateStr = [formatter1 stringFromDate:[NSDate date]];
    
    dateStr = [dateStr stringByReplacingCharactersInRange:NSMakeRange(0, 4) withString:[NSString stringWithFormat:@"%i",[[dateStr substringToIndex:4] intValue]-18]];
//    dateStr = [dateStr stringByReplacingCharactersInRange:NSMakeRange(8, 2) withString:[NSString stringWithFormat:@"%d",[[dateStr substringFromIndex:8]intValue]-1]];
    NSDate *miniDate = [formatter1 dateFromString:dateStr];
    NSDate *maxDate = [NSDate dateWithTimeInterval:-(24*60*60) sinceDate:miniDate];
//    NSDate *maxDate = [formatter1 dateFromString:dateStr];
    picker.date = [maxDate earlierDate:picker.date];

    NSInteger age = 0;
    NSInteger currentDate[3];
    NSInteger pickDate[3];

    NSDate *pickerDate = [NSDate dateWithTimeInterval:3600*12 sinceDate:picker.date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYY-MM-dd"];
    self.birthdayStr = [formatter stringFromDate:pickerDate];
    
    NSArray *pickDateArr = [_birthdayStr componentsSeparatedByString:@"-"];
    NSArray *nowDateArr = [[formatter stringFromDate:[NSDate date]] componentsSeparatedByString:@"-"];
    [formatter release];
    
    for(int i=0; i<3; i++)
    {
        pickDate[i] = [[pickDateArr objectAtIndex:i] intValue];
        currentDate[i] = [[nowDateArr objectAtIndex:i] intValue];
    }
    
    age = currentDate[0] - pickDate[0] -1;
    if((currentDate[1]>pickDate[1]) ||((currentDate[1]=pickDate[1]) && (currentDate[2]>pickDate[2])))
        age ++;
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%i%@",age,NSLocalizedString(@"ageNumber", nil)];
    cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    cell.detailTextLabel.text = [self xingzuoForMoth:pickDate[1] day:pickDate[2]];

}
- (void)nextStep:(UIButton *)button
{
    NSLog(@"%@",_birthdayStr);
    if(!_birthdayStr)
    {
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"小提示"
//                                                        message:@"请输入年龄"
//                                                       delegate:nil
//                                              cancelButtonTitle:@"好的"
//                                              otherButtonTitles:nil, nil];
//        [alert show];
//        [alert release];
        [TKLoadingView showTkloadingAddedTo:self.view title:NSLocalizedString(@"ageNotice", nil) activityAnimated:NO duration:1.0];
        return;
    }
    
    [MyAppDataManager.regDic setValue:_birthdayStr forKey:@"borndate"];
//    [TKLoadingView showTkloadingAddedTo:self.view title:@"正在上传数据" activityAnimated:YES];
        BanBu_SetAvatarViewController *avatar = [[BanBu_SetAvatarViewController alloc] init];
        [self.navigationController pushViewController:avatar animated:YES];
        [avatar release];

}


//- (void)banbuRequestDidFinished:(NSDictionary *)resDic error:(NSError *)error
//{
//    self.navigationController.view.userInteractionEnabled = YES;
//    [TKLoadingView dismissTkFromView:self.view animated:YES afterShow:0.0];
//    if(error)
//    {
//        if([error.domain isEqualToString:BanBuDataformatError])
//        {
//            [TKLoadingView showTkloadingAddedTo:self.view title:Data_Error_Msg activityAnimated:NO duration:2.0];
//        }
//        else
//        {
//            [TKLoadingView showTkloadingAddedTo:self.view title:NSLocalizedString(@"network_error", nil) activityAnimated:NO duration:2.0];
//        }
//        
//        return;
//    }
//    
//    //NSLog(@"res:%@",resDic);
//    if([[resDic valueForKey:@"ok"] boolValue])
//    {
//        BanBu_SetAvatarViewController *avatar = [[BanBu_SetAvatarViewController alloc] init];
//        [self.navigationController pushViewController:avatar animated:YES];
//        [avatar release];
//    }
//}


- (void)viewDidUnload
{
    [super viewDidUnload];
    self.birthdayStr = nil;
    self.birthdayPicker = nil;
}

- (void)dealloc
{
    [_birthdayStr release];
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
    
    return 2;
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
    return NSLocalizedString(@"birthNotice", nil);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell == nil)
    {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier] autorelease];
        
    }
    
    if(!indexPath.row)
    {
        cell.textLabel.text = NSLocalizedString(@"ageLabel", nil);
    }
    else 
    {
        cell.textLabel.text = NSLocalizedString(@"starLabel", nil);
    }
    
    return cell;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}



@end
