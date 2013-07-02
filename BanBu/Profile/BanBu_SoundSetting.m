//
//  BanBu_SoundSetting.m
//  BanBu
//
//  Created by Jc Zhang on 13-6-8.
//
//

#import "BanBu_SoundSetting.h"
#import "AppDataManager.h"
@interface BanBu_SoundSetting ()

@end

@implementation BanBu_SoundSetting

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

    self.title = NSLocalizedString(@"soundSwitch", nil);
    self.tableView.backgroundView = nil;
    self.tableView.backgroundColor = [UIColor colorWithRed:255.0/255 green:250.0/255 blue:240.0/255 alpha:1.0];
    
     
    if([[[[UserDefaults valueForKey:MyAppDataManager.useruid] valueForKey:@"settings"] valueForKey:@"MusicSwith"]length]){
        _sectionNumber = 2;
        
        NSArray *soundArr = [NSArray arrayWithObjects:@"msg_1",@"msg_2",@"msg_3",@"msg_4",@"msg_5",@"msg_6",@"msg_7",@"msg_8",@"msg_9", nil];
        MyAppDataManager.musicName = [[[UserDefaults valueForKey:MyAppDataManager.useruid] valueForKey:@"settings"] valueForKey:@"MusicSwith"];
        for(int i=0; i<soundArr.count; i++){
            if([[soundArr objectAtIndex:i] isEqualToString:MyAppDataManager.musicName]){
                _selectRow = i;
                break;
            }
                
        }
        
    }else{
        _sectionNumber = 1;

    }


}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
     // Return the number of sections.
    return _sectionNumber;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
     // Return the number of rows in the section.
    if(!section){
        return 1;
    }
    return 9;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(!cell){
        cell = [[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier]autorelease];
        
    }
 

    if(!indexPath.section){
        
        cell.textLabel.text = NSLocalizedString(@"soundSwitch", nil);
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        //一个switch没必要这么做
        UISwitch *aSwitch = (UISwitch *)[cell viewWithTag:100];
        if(!aSwitch){
            aSwitch = [[UISwitch alloc]initWithFrame:CGRectMake(310-80, 7, 80, 30)];
            aSwitch.tag = 100;
            [aSwitch addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
            cell.accessoryView = aSwitch;
            [aSwitch release];
            
        }
        
        
        _soundSwitch = aSwitch;
        if([[[[UserDefaults valueForKey:MyAppDataManager.useruid] valueForKey:@"settings"] valueForKey:@"MusicSwith"]length]){
            _soundSwitch.on = YES;
        }else{
            _soundSwitch.on = NO;
        }
        

        
    }else{
        cell.accessoryView = nil;
        if (indexPath.row == _selectRow) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }else{
            cell.accessoryType = UITableViewCellAccessoryNone;

        }
//        if(indexPath.row == 0){
            cell.textLabel.text = [NSString stringWithFormat:@"%d",indexPath.row+1];

//        }else if(indexPath.row == 1){
//            cell.textLabel.text = NSLocalizedString(@"噔噔噔", nil);
//
//        }else if(indexPath.row == 2){
//            cell.textLabel.text = NSLocalizedString(@"咚咚咚", nil);
//
//        }
    }

    // Configure the cell...
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

 
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 30)];
    backView.backgroundColor = [UIColor clearColor];
    UILabel *headerTitle = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 300, 30)];
    headerTitle.backgroundColor = [UIColor clearColor];

    headerTitle.font = [UIFont systemFontOfSize:14];
    headerTitle.textColor = [UIColor darkGrayColor];
    if(!section){
        headerTitle.text = NSLocalizedString(@"newmsgNotice", nil);

    }else{
        headerTitle.text = NSLocalizedString(@"soundType", nil);

    }
    [backView addSubview:headerTitle];
    [headerTitle release];
    return [backView autorelease];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 30;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    if(indexPath.section){
        NSMutableDictionary *settingsDic = [NSMutableDictionary dictionaryWithDictionary:[[UserDefaults valueForKey:MyAppDataManager.useruid] valueForKey:@"settings"]];

        
        
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:_selectRow inSection:1]];
        cell.accessoryType = UITableViewCellAccessoryNone;
        
        cell = [tableView cellForRowAtIndexPath:indexPath];
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        _selectRow = indexPath.row;
        
        NSArray *soundArr = [NSArray arrayWithObjects:@"msg_1",@"msg_2",@"msg_3",@"msg_4",@"msg_5",@"msg_6",@"msg_7",@"msg_8",@"msg_9", nil];
        MyAppDataManager.musicName = [soundArr objectAtIndex:_selectRow];
        [settingsDic setValue:MyAppDataManager.musicName forKey:@"MusicSwith"];

        
        NSMutableDictionary *settingsUpdata = [NSMutableDictionary dictionaryWithDictionary:[UserDefaults valueForKey:MyAppDataManager.useruid]];
        [settingsUpdata setValue:settingsDic forKey:@"settings"];
        [UserDefaults setValue:settingsUpdata forKey:MyAppDataManager.useruid];
        [self.tableView reloadData];
        
        
        //播放音乐
        
        if(_player){
            
            [_player release],_player = nil;
        }
        NSString *path=[[NSBundle mainBundle]pathForResource:MyAppDataManager.musicName ofType:@"mp3"];
        
        _player = [[AVAudioPlayer alloc]initWithData:[NSData dataWithContentsOfFile:path] error:nil];
        _player.volume = 1.0;
        [_player prepareToPlay];
        
        [_player play];
        
    }
    

}

-(void)switchAction:(UISwitch *)sender{
    NSMutableDictionary *settingsDic = [NSMutableDictionary dictionaryWithDictionary:[[UserDefaults valueForKey:MyAppDataManager.useruid] valueForKey:@"settings"]];

    if(sender.on){
        _sectionNumber = 2;
        _soundSwitch.on = YES;
        if([MyAppDataManager.musicName isEqualToString:@""]){
            NSArray *soundArr = [NSArray arrayWithObjects:@"msg_1",@"msg_2",@"msg_3",@"msg_4",@"msg_5",@"msg_6",@"msg_7",@"msg_8",@"msg_9", nil];

            MyAppDataManager.musicName = [soundArr objectAtIndex:_selectRow];
        }
        [settingsDic setValue:MyAppDataManager.musicName forKey:@"MusicSwith"];


    }else{
        _sectionNumber = 1;
        _soundSwitch.on = NO;
        [settingsDic setValue:@"" forKey:@"MusicSwith"];
        MyAppDataManager.musicName = @"";


    }

    NSMutableDictionary *settingsUpdata = [NSMutableDictionary dictionaryWithDictionary:[UserDefaults valueForKey:MyAppDataManager.useruid]];
    [settingsUpdata setValue:settingsDic forKey:@"settings"];
    [UserDefaults setValue:settingsUpdata forKey:MyAppDataManager.useruid];
    [self.tableView reloadData];
}


-(void)dealloc{
    [_player release];
    [super dealloc];
}


@end
