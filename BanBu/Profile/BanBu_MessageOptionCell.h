//
//  BanBu_MessageOptionCell.h
//  BanBu
//
//  Created by apple on 13-3-5.
//
//

#import <UIKit/UIKit.h>
#import "BanBu_MessageOptionViewController.h"
@interface BanBu_MessageOptionCell : UITableViewCell
{
 


}
@property(nonatomic,retain)UILabel *messageLabel;
@property(nonatomic,retain)UIImageView *imageViewt;
@property(nonatomic,assign)BOOL flag;
-(void)setString:(NSString *)stringt;

@end
