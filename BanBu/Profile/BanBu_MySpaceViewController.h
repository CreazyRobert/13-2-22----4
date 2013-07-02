//
//  BanBu_MySpaceViewController.h
//  BanBu
//
//  Created by 17xy on 12-7-31.
//
//

#import <UIKit/UIKit.h>
#import "BanBu_HelpViewController.h"
@interface BanBu_MySpaceViewController : UITableViewController
{
 
    

}
@property(nonatomic,retain)UIButton *dynamicButton;
@property(nonatomic,retain)NSString *badaget;

-(void)createTheBandageView:(NSString *)string;

@end
