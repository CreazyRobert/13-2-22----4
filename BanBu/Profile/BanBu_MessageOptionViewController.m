//
//  BanBu_MessageOptionViewController.m
//  BanBu
//
//  Created by apple on 13-3-5.
//
//

#import "BanBu_MessageOptionViewController.h"
#import "BanBu_MessageOptionCell.h"
#import "AppDataManager.h"
@interface BanBu_MessageOptionViewController ()
{

    NSMutableArray *dataArray;
    
    UITableView *tableview;
    
    
}
@end

@implementation BanBu_MessageOptionViewController
static BanBu_MessageOptionViewController  *sharet;
@synthesize flag;


-(void)dealloc
{
    [dataArray release],dataArray=nil;
    
    [[NSNotificationCenter defaultCenter]removeObserver:self];

    [super dealloc];
}


 +(id)share
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        sharet=[[self alloc]init];
        
    });
    
    return sharet;
}
+(void)haha
{

    NSLog(@"= = = - -- - -");
    
}


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
    
    self.tableView.backgroundColor = [UIColor colorWithRed:255.0/255 green:250.0/255 blue:240.0/255 alpha:1.0];
    
    flag=YES;
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    dataArray=[[NSMutableArray alloc]initWithObjects:NSLocalizedString(@"notificChat", nil),NSLocalizedString(@"notificFriend", nil), nil];
    
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(listeningAction:) name:@"haha" object:nil];
    
    self.title=NSLocalizedString(@"notific", nil);
    
    
    self.tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    
}
-(void)listeningAction:(NSNotification *)notification
{
    BanBu_MessageOptionCell *cell=(BanBu_MessageOptionCell *)notification.object;

    
    NSIndexPath *index=[self.tableView indexPathForCell:cell];
    
    
    if(index.row)
    {
        cell.flag=!cell.flag;
    
        [MyAppDataManager.boolArr removeAllObjects];
        
        [MyAppDataManager.boolArr addObjectsFromArray: [UserDefaults valueForKey:@"boolKey"]];
        
        [MyAppDataManager.boolArr replaceObjectAtIndex:index.row withObject:[NSNumber numberWithBool:cell.flag]];
    
        [UserDefaults setValue:MyAppDataManager.boolArr forKey:@"boolKey"];
        
        
    }

    
    

}


-(void)tomakeChangeThePic:(int)cell
{


    
    

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
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    // Return the number of rows in the section.
    return [dataArray count];
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;

}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    BanBu_MessageOptionCell *cell =(BanBu_MessageOptionCell *) [tableView dequeueReusableCellWithIdentifier:CellIdentifier];

    if(!cell)
    {
        cell=[[[BanBu_MessageOptionCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
      cell.multipleSelectionBackgroundView = [[[UIView alloc] initWithFrame:cell.bounds] autorelease];
        
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
    }
    
    [cell setString:[dataArray objectAtIndex:indexPath.row]];
    
    if([[UserDefaults valueForKey:@"boolKey"] count]!=[dataArray count])
    {
        cell.flag=indexPath.row?0:1;
        
        [MyAppDataManager.boolArr addObject:[NSNumber numberWithBool:cell.flag]];
        
        [UserDefaults setValue:MyAppDataManager.boolArr forKey:@"boolKey"];
        
        
    }else
    {
      
        cell.flag=[[[UserDefaults valueForKey:@"boolKey"] objectAtIndex:indexPath.row] boolValue];
        
        
    
    }
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

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
   
    if(indexPath.row)
    {
//       BanBu_MessageOptionCell *cell=(BanBu_MessageOptionCell*)[tableView cellForRowAtIndexPath:indexPath];
//    
//    
//        cell.flag=!cell.flag;
//        
//        
//        [MyAppDataManager.boolArr replaceObjectAtIndex:indexPath.row withObject:[NSNumber numberWithBool:cell.flag]];
//        
//        [UserDefaults setValue:MyAppDataManager.boolArr forKey:@"boolKey"];
        
    
    }
      
  [tableView deselectRowAtIndexPath:indexPath animated:YES];

}

@end
