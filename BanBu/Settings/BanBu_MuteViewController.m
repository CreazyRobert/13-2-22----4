//
//  BanBu_MuteViewController.m
//  BanBu
//
//  Created by jie zheng on 12-7-7.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "BanBu_MuteViewController.h"

@interface BanBu_MuteViewController ()

@end

@implementation BanBu_MuteViewController

@synthesize footerView = _footerView;
@synthesize timePicker = _timePicker;

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
    self.title = @"静音设置";
    
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 50)];
    footerView.backgroundColor = [UIColor clearColor];
    self.footerView = footerView;
    [footerView release];
    
    _fromTime = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 140, 50)];
    _fromTime.textAlignment = UITextAlignmentRight;
    _fromTime.backgroundColor = [UIColor clearColor];
    _fromTime.font = [UIFont boldSystemFontOfSize:26];
    _fromTime.text = @"0:00";
    [_footerView addSubview:_fromTime];
    [_fromTime release];
    
    UILabel *toLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, 8, 120, 40)];
    toLabel.textAlignment = UITextAlignmentCenter;
    toLabel.backgroundColor = [UIColor clearColor];
    toLabel.font = [UIFont boldSystemFontOfSize:20];
    toLabel.text = @"to";
    [_footerView addSubview:toLabel];
    [toLabel release];
    
    _endTime = [[UILabel alloc] initWithFrame:CGRectMake(180, 0, 80, 50)];
    _endTime.backgroundColor = [UIColor clearColor];
    _endTime.font = [UIFont boldSystemFontOfSize:26];
    _endTime.text = @"23:00";
    [_footerView addSubview:_endTime];
    [_endTime release];
    
    self.tableView.tableFooterView = self.footerView;
    
    UIPickerView *picker = [[UIPickerView alloc] initWithFrame:CGRectMake(0,200, 320, 216)];
    picker.showsSelectionIndicator = YES;
    picker.delegate = self;
    picker.dataSource = self;
    [self.view addSubview:picker];
    self.timePicker = picker;
    [picker release];
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    self.footerView = nil;
    self.timePicker = nil;
}

- (void)dealloc
{
    [_footerView release];
    [_timePicker release];
    [super dealloc];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)switchOn:(UISwitch *)sw
{
    [UIView animateWithDuration:.5
                     animations:^{
                         self.tableView.tableFooterView = sw.on?self.footerView:nil;
                         self.timePicker.frame = CGRectMake(0, sw.on?200:460, 320, 216);
                     } completion:^(BOOL finished) {
                         ;
                     }];
    
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
    return @"打开静音时段功能后，手机在这个时间段收到的新的消息不会有声音和震动。";
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
        [sw addTarget:self action:@selector(switchOn:) forControlEvents:UIControlEventValueChanged];
        cell.accessoryView = sw;
        [sw release];
        
    } 

    cell.textLabel.text = @"静音设置";
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}


#pragma mark -
#pragma mark pickerView DataSource Methods

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
	return 2;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
	
	return 24;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
	return 160.0;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return row>9?[NSString stringWithFormat:@"%i:00",row]:[NSString stringWithFormat:@"0%i:00",row];
}

#pragma mark -
#pragma mark pickerView delegate Methods

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
	
	if(!component)
    {
        _fromTime.text = row>9?[NSString stringWithFormat:@"%i:00",row]:[NSString stringWithFormat:@"0%i:00",row];
    }
    else 
    {
        _endTime.text = row>9?[NSString stringWithFormat:@"%i:00",row]:[NSString stringWithFormat:@"0%i:00",row];   
    }
}



@end
