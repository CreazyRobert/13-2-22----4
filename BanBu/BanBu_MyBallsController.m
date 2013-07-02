//
//  BanBu_MyBallsController.m
//  BanBu
//
//  Created by mac on 12-9-10.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "BanBu_MyBallsController.h"
#import "BanBu_DialogueCell.h"
#import "BanBu_ChatViewController.h"
#import "AppDataManager.h"
#import "AppCommunicationManager.h"
#import "TKLoadingView.h"

@interface BanBu_MyBallsController ()

@end

@implementation BanBu_MyBallsController
@synthesize totalUnreadNum = _totalUnreadNum;

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
    
    [MyAppDataManager readTalkList:BallList];
    
    
    self.tableView.backgroundColor = [UIColor colorWithRed:255.0/255 green:250.0/255 blue:240.0/255 alpha:1.0];
    self.title = NSLocalizedString(@"myBallTitle", nil);
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    
    UIButton *deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
    deleteButton.frame=CGRectMake(0, 0, 50, 30);
    [deleteButton addTarget:self action:@selector(delete:) forControlEvents:UIControlEventTouchUpInside];
    [deleteButton setBackgroundImage:[[UIImage imageNamed:@"app_nav_btn_bg1.png"] stretchableImageWithLeftCapWidth:15.0 topCapHeight:15.0] forState:UIControlStateNormal];
    [deleteButton setBackgroundImage:[[UIImage imageNamed:@"app_nav_btn_bg2.png"] stretchableImageWithLeftCapWidth:15.0 topCapHeight:15.0] forState:UIControlStateHighlighted];
    [deleteButton setTitleEdgeInsets:UIEdgeInsetsMake(3, 2, 2, 2)];
    [deleteButton setTitle:NSLocalizedString(@"deleteButton", nil) forState:UIControlStateNormal];
    deleteButton.titleLabel.font = [UIFont systemFontOfSize:14];
    UIBarButtonItem *delItem = [[[UIBarButtonItem alloc] initWithCustomView:deleteButton] autorelease];
    self.navigationItem.rightBarButtonItem = delItem;
    
}



-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [MyAppDataManager readTalkList:BallList];
}

- (void)delete:(UIButton *)button
{
    [self.tableView setEditing:!self.tableView.editing animated:YES];
    [button setTitle:self.tableView.editing?NSLocalizedString(@"finishButton", nil):NSLocalizedString(@"deleteButton", nil) forState:UIControlStateNormal];
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
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return [MyAppDataManager.playBall count];
    
}

-(float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 84;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    BanBu_DialogueCell *cell = (BanBu_DialogueCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell == nil)
    {
        cell = [[[BanBu_DialogueCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        
    }
    NSDictionary *aTalk;
    if([MyAppDataManager.playBall count]!=0)
    {
        aTalk = [MyAppDataManager.playBall objectAtIndex:indexPath.row];
    }else
    {
        aTalk=nil;
        
    }
    [cell setAvatar:VALUE(KeyUface, aTalk)];
    [cell setName:[MyAppDataManager IsMinGanWord:VALUE(KeyUname, aTalk)]];
    [cell setLastInfo:VALUE(KeyStime, aTalk)];
    //NSLog(@"%@",VALUE(KeyAge, aTalk));

//    [cell setAge:[VALUE(KeyAge, aTalk) stringByReplacingOccurrencesOfString:@"岁" withString:@""] sex:[VALUE(KeySex, aTalk) boolValue]];
    [cell setAge:VALUE(KeyAge, aTalk) sex:[VALUE(KeySex, aTalk) boolValue]];

    NSString *type = VALUE(KeyType, aTalk);
    if([type isEqualToString:@"text"])
    {
//        if([VALUE(KeyMe, aTalk) boolValue])
//            [cell setlastDialogue:[NSString stringWithFormat:@"%@ %@",NSLocalizedString(@"mySay", nil),VALUE(KeyLasttalk, aTalk)]];
//        else
//            [cell setlastDialogue:VALUE(KeyLasttalk, aTalk)];
    }
    else
    {
//        NSDictionary *mapDic = [NSDictionary dictionaryWithObjectsAndKeys:NSLocalizedString(@"talkPicture", nil),@"image",NSLocalizedString(@"talkLocation", nil),@"location",NSLocalizedString(@"talkSound", nil),@"sound",nil];
//        [cell setlastDialogue:VALUE(VALUE(KeyType, aTalk), mapDic)];
    }
    NSInteger unReadNum = [VALUE(KeyUnreadNum, aTalk) integerValue];
    [cell setStatus:unReadNum?DialogueStatusUnreadType:DialogueStatusNoneType num:[NSString stringWithFormat:@"%i+",unReadNum]];
    
    return cell;
}


// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

-(BOOL)tableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}


// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        
        NSDictionary *aTalk = [MyAppDataManager.playBall objectAtIndex:indexPath.row];
        [MyAppDataManager deleteData:aTalk forItem:BallList forUid:VALUE(KeyFromUid, aTalk)];
        
        [MyAppDataManager removeTableNamed:[MyAppDataManager getTableNameForUid:VALUE(KeyFromUid, aTalk)]];
        
        [MyAppDataManager readTalkList:BallList];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationTop];
        
//        BanBu_AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
//        [appDelegate updateBallBadge];
        
    }
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableDictionary *aTalk =  [NSMutableDictionary dictionaryWithDictionary:[MyAppDataManager.playBall objectAtIndex:indexPath.row]];
    BanBu_ViewController *ball = [[BanBu_ViewController alloc] initWithPeopleProfile:aTalk];
    ball.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:ball animated:YES];
    [ball release];
    [aTalk setValue:[NSNumber numberWithInteger:0] forKey:KeyUnreadNum];
    [MyAppDataManager.playBall replaceObjectAtIndex:indexPath.row withObject:aTalk];
    
    NSString *jsonfrom = [[CJSONSerializer serializer] serializeArray: VALUE(@"facelist", aTalk)];
    
    [aTalk setValue:jsonfrom forKey:@"facelist"];
    
    
    [MyAppDataManager updateData:aTalk forItem:BallList forUid:VALUE(KeyUid, aTalk)];
    
    
    [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationNone];
    

    
    
}





@end
